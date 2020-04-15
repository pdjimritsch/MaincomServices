USE [visionary]; -- change the database name if required
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Quote_Get_Quote_By_Id'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Quote_Get_Quote_by_Id];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 25 February 2013
-- Description:	Obtains the insurance quote from the specified insurance quote identity.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Quote_Get_Quote_By_Id] ( @Id INT )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT IQ.[Insurance_Quote_id], 
		   IQ.[Order_id],
		   IQ.[supplier_ref],
		   IW.[search_code_value],
		   IQ.[version_label],
		   IQ.[variation_type],
		   [job_status] = LTRIM(RTRIM(ISNULL(JS.[name], ''))),
		   [work_order_status] = LTRIM(RTRIM(ISNULL(IWS.[name], ''))),
		   [quote_status] = LTRIM(RTRIM(ISNULL(QS.[name], ''))),
		   -- Site Inspection
		   IQ.[initial_contact_datetime],
		   IQ.[site_attend_datetime],
		   ISNULL(IQ.[attend_with_insured], 0) AS [attend_with_insured],
		   ISNULL(IQ.[attend_with_rep], 0) AS [attend_with_rep],
		   ISNULL(IQ.[reps_name], '') AS [reps_name],
		   ISNULL(IQ.[attend_with_noone], 0) AS [attend_with_noone],
		   ISNULL(IQ.[attend_na], 0) AS [attend_na],
		   -- Property Description
		   LTRIM(RTRIM(BT.[name])) AS [building_type],
		   LTRIM(RTRIM(DT.[name])) AS [design_type],
		   LTRIM(RTRIM(CT.[name])) AS [construction_type],
		   LTRIM(RTRIM(RT.[name])) AS [roof_type],
		   ISNULL(IQ.[age], 0) AS [age], -- can be represented as YYYY or NNN
		   ISNULL(IQ.[square_metres], 0) AS [square_metres],
		   ISNULL(IQ.[ob_bungalow], 0) AS [ob_bungalow],
		   ISNULL(IQ.[ob_fibro_shed], 0) AS [ob_fibro_shed],
		   ISNULL(IQ.[ob_brick_shed], 0) AS [ob_brick_shed],
		   ISNULL(IQ.[ob_metal_shed], 0) AS [ob_metal_shed],
		   ISNULL(IQ.[ob_metal_garage], 0) AS [ob_metal_garage],
		   ISNULL(IQ.[ob_above_ground_pool], 0) AS [ob_above_ground_pool],
		   ISNULL(IQ.[ob_pergola], 0) AS [ob_pergola],
		   ISNULL(IQ.[ob_timber_carport], 0) AS [ob_timber_carport],
		   ISNULL(IQ.[ob_brick_carport], 0) AS [ob_brick_carport],
		   ISNULL(IQ.[ob_dog_kennel], 0) AS [ob_dog_kennel],
		   ISNULL(IQ.[ob_external_laundry], 0) AS [ob_external_laundry],
		   ISNULL(IQ.[ob_below_ground_pool], 0) AS [ob_below_ground_pool],
		   ISNULL(IQ.[ob_external_wc], 0) AS [ob_external_wc],
		   ISNULL(IQ.[ob_bbq_area], 0) AS [ob_bbq_area],
		   ISNULL(IQ.[ob_pool_room], 0) AS [ob_pool_room],
		   ISNULL(IQ.[ob_store_room], 0) AS [ob_store_room],
		   ISNULL(IQ.[ob_cubby_house], 0) AS [ob_cubby_house],
		   ISNULL(IQ.[ob_pump_room], 0) AS [ob_pump_room],
		   ISNULL(IQ.[ob_granny_flat], 0) AS [ob_granny_flat],
		   ISNULL(IQ.[ob_fibro_garage], 0) AS [ob_fibro_garage],
		   ISNULL(IQ.[ob_brick_garage], 0) AS [ob_brick_garage],
		   ISNULL(IQ.[ob_carport_metal], 0) AS [ob_carport_metal],
		   ISNULL(IQ.[ob_screen_enclosures], 0) AS [ob_screen_enclosures],
		   ISNULL(IQ.[ob_fence], 0) AS [ob_fence],
		   HH.[name] AS [home_habitable],
		   ISNULL(IQ.[VacateDays], 0) AS [vacate_days],
		   ISNULL(IQ.[contains_asbestos], 'No') AS [contains_asbestos],
		   ISNULL(IQ.[home_warranty_required], 0) AS [home_warranty_required],
		   ISNULL(IQ.[Home_Warranty_Sum], CAST(0 AS DECIMAL(9, 2))) AS [home_warranty_sum],
		   -- Damage Report
		   ISNULL(IQ.[details_and_Circumstances], '') AS [details_and_Circumstances],
		   ISNULL(IQ.[sun_resultant_damage], '') AS [sun_resultant_damage],
		   ISNULL(IQ.[comments], '') AS [comments], -- assessor comments
		   ISNULL(IQ.[supplier_ref], '') AS [supplier_ref],
		   -- Policy Exclusions / Maintenance defects
		   LTRIM(RTRIM(ISNULL(IQ.[sun_maintenance_defects], ''))) AS [sun_maintenance_defects],
		   [sun_insured_advised] = CASE LTRIM(RTRIM(ISNULL(IQ.[sun_insured_advised], '')))
										WHEN '' THEN 'No'
		                                WHEN '0' THEN 'No'
										WHEN '1' THEN 'No'
										WHEN '2' THEN 'Yes'
										ELSE LTRIM(RTRIM(IQ.[sun_insured_advised]))
										END,
		   ISNULL(IQ.[est_job_cost], CAST(0 AS DECIMAL(9, 2))) AS [est_job_cost],
		   -- Claim Assessment Summary
		   LTRIM(RTRIM(ISNULL(IQ.[sun_claim_covered], ''))) AS [sun_claim_covered],
		   [sun_action_required] = CASE LTRIM(RTRIM(ISNULL(IQ.[sun_action_required], '')))
		                           WHEN '' THEN 'No'
								   WHEN '1' THEN 'No'
								   WHEN '2' THEN 'Yes'
								   ELSE LTRIM(RTRIM(IQ.[sun_action_required]))
								   END,
			[recommendation] = CASE LTRIM(RTRIM(IR.[name]))
			                   WHEN 'Unsure' THEN 'Unsure / Refer to Insurer'
							   ELSE IR.[name]
							   END,
		    LTRIM(RTRIM(ISNULL(IQ.[sun_action_desc], ''))) AS [sun_action_desc],
			[sun_contents_involved] = CASE LTRIM(RTRIM(ISNULL(IQ.[sun_contents_involved], '')))
			                          WHEN '' THEN 'No'
									  WHEN '1' THEN 'No'
									  WHEN '2' THEN 'Yes'
									  ELSE LTRIM(RTRIM(IQ.[sun_contents_involved]))
									  END,
			LTRIM(RTRIM(ISNULL(IQ.[sun_contents_desc], ''))) AS [sun_contents_desc],
			-- Report Conclusion
			ISNULL(IQ.[incident_confirmed], 0) AS [incident_confirmed],
			ISNULL(IQ.[sum_insured_adequate], 0) AS [sum_insured_adequate],
			ISNULL(IQ.[has_insured_been_advised], 0) AS [has_insured_been_advised],
			ISNULL(IQ.[is_insured_aware_of_repairs], 0) AS [is_insured_aware_of_repairs],
			ISNULL(IQ.[is_iag_assessment_required], 0) AS [is_iag_assessment_required],
			ISNULL(IQ.[make_safe], 0) AS [make_safe],
			ISNULL(IQ.[client_willing_to_proceed], 0) AS [client_willing_to_proceed],
			-- Hidden Fields
			ISNULL(IQ.[overall_condition_acceptable], 0) AS [overall_condition_acceptable],
			ISNULL(IQ.[est_labour_markup], 0) AS [est_labour_markup],
			ISNULL(IQ.[est_material_markup], 0) AS [est_material_markup],
			ISNULL(IQ.[est_room_cost], 0) AS [est_room_cost],
			ISNULL(IQ.[est_room_sale_price], 0) AS [est_room_sale_price],
			ISNULL(IQ.[est_job_sale_price], 0) AS [est_job_sale_price],
			ISNULL(IQ.[est_room_profit], 0) AS [est_room_profit],
			ISNULL(IQ.[est_job_profit], 0) AS [est_job_profit],
			ISNULL(IQ.[profit_percentage], 0) AS [profit_percentage],
			ISNULL(IQ.[labour_total], 0) AS [labour_total],
			ISNULL(IQ.[material_total], 0) AS [material_total],
			ISNULL(IQ.[room_trade_total], 0) AS [room_trade_total],
			ISNULL(IQ.[job_trade_total], 0) AS [job_trade_total],
			ISNULL(IQ.[insurance_trade_id], 0) AS [insurance_trade_id],
			ISNULL(IQ.[insurance_room_id], 0) AS [insurance_room_id],
			ISNULL(IQ.[sun_client_discussion], '') AS [sun_client_discussion],
			ISNULL(IQ.[sun_resultant_damage], '') AS [sun_resultant_damage],
			ISNULL(IQ.[sun_conclusion], '') AS [sun_conclusion],
			IQ.[sun_estimate],
			ISNULL(IQ.[sun_maintenance_defects_not_covered], '') AS [sun_maintenance_defects_not_covered],
			ISNULL(IQ.[sun_insured_advised_not_covered], '') AS [sun_insured_advised_not_covered],
			IQ.[sun_estimate_not_covered],
			ISNULL(IQ.[sun_recovery_details], '') AS [sun_recovery_details],
			IQ.[sun_total_estimate],
			IQ.[cost_of_repairs],
			IQ.[sun_cause_of_damage],
			--ISNULL(IQ.[attach_filename], '') AS [attach_filename],
			--IQ.[attach],
			--ISNULL(IQ.[proceed_filename], '') AS [proceed_filename],
			--IQ.[proceed_doc],
			--ISNULL(IQ.[signed_filename], '') AS [signed_filename],
			--IQ.[signed_doc],
			IQ.[negative_quote_id],
			ISNULL(IQ.[from_search], 0) AS [from_search],
			ISNULL(IQ.[is_fake_neg_quote], 0) AS [is_fake_neg_quote],
			ISNULL(IQ.[fake_bypass], 0) AS [fake_bypass],
			ISNULL(IQ.[variation_checked_by], '') AS [variation_checked_by],
			IQ.[variation_checked_on],
			IQ.[est_job_sale_price_with_HOW],
			IQ.[SignNumber],
			IQ.[SignedByClient],
			IQ.[Damage_match_explanation],
			IQ.[Maintenance_issues_noted],
			IQ.[Damage_Result_Of],
			IQ.[Damage_Date],
			IQ.[Repairs_Proceeding_per_authorisation_limits],
			IQ.[Damage_Date2],
			IQ.[created_by],
			IQ.[create_date],
			IQ.[updated_by],
			IQ.[updated_date]
	FROM    [dbo].[Insurance_Quote] IQ
			INNER JOIN [dbo].[Insurance_WorkOrder] IW ON IW.[ORDER_ID] = IQ.[Order_id]
			LEFT JOIN [dbo].[Insurance_QuoteStatus] QS ON QS.[id] = IQ.[status]
			LEFT JOIN [dbo].[InsuranceStatus] IWS ON IWS.[id] = IW.[status_id]
			LEFT JOIN [dbo].[Orders] O ON O.[ORDER_ID] = IQ.[Order_id]
			LEFT JOIN [dbo].[InsuranceStatus] JS ON JS.[id] = O.[STATUS]
			LEFT JOIN [dbo].[Insurance_BuildingType] BT ON BT.[id] = IQ.[building_type]
			LEFT JOIN [dbo].[Insurance_DesignType] DT ON DT.[id] = IQ.[design_type]
			LEFT JOIN [dbo].[Insurance_ConstructionType] CT ON CT.[id] = IQ.[construction_type]
			LEFT JOIN [dbo].[Insurance_RoofType] RT ON RT.[id] = IQ.[roof_type]
			LEFT JOIN [dbo].[Insurance_HomeHabitable] HH ON HH.[id] = IQ.[home_habitable]
			LEFT JOIN [dbo].[Insurance_YesNo] HW ON HW.[id] = ISNULL(IQ.[home_warranty_required], 2) -- defaults to NO
			LEFT JOIN [dbo].[Insurance_Recommendation] IR ON IR.[id] = ISNULL(IQ.[recommendation], 3) -- defaults to Unsure
	WHERE  IQ.[Insurance_Quote_id] = ISNULL(@Id, 0)

	SET NOCOUNT OFF;

END;
GO
