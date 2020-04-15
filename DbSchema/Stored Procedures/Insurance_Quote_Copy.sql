USE [visionary];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Quote_Copy'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Quote_Copy];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 7 June 2013
-- Description:	Copies the content of the former insurance owrk order quote into
--              the specified insurance work order quote.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Quote_Copy] ( @RecentQuoteId INT, @InsuranceQuoteId INT, @UserName VARCHAR(20) )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	IF ( ISNULL( @RecentQuoteId, - 1) <= 0 ) OR ( NOT EXISTS(SELECT 1 FROM [dbo].[Insurance_Quote] WITH (READCOMMITTED) WHERE [Insurance_Quote_id] = @RecentQuoteId ) )
		RETURN;

	IF ( ISNULL( @InsuranceQuoteId, - 1) <= 0 ) OR ( NOT EXISTS(SELECT 1 FROM [dbo].[Insurance_Quote] WITH (READCOMMITTED) WHERE [Insurance_Quote_id] = @InsuranceQuoteId ) )
		RETURN;

	DECLARE @Transaction INT;

	SET @Transaction = @@TRANCOUNT;

	DECLARE @Error INT;

	SET @Error = @@ERROR;

	IF ( @Transaction = 0 ) BEGIN TRANSACTION;

	BEGIN TRY

		UPDATE [dbo].[Insurance_Quote] WITH (READCOMMITTED) SET
				IQ.[comments] = COPY.[comments],
				IQ.[supplier_ref] = COPY.[supplier_ref],
				IQ.[incident_confirmed] = COPY.[incident_confirmed],
				IQ.[initial_contact_datetime] = COPY.[initial_contact_datetime],
				IQ.[site_attend_datetime] = COPY.[site_attend_date],
				IQ.[attend_with_insured] = COPY.[attend_with_insured],
				IQ.[attend_with_rep] = COPY.[attend_with_rep],
				IQ.[reps_name] = COPY.[reps_name],
				IQ.[attend_with_noone] = COPY.[attend_with_noone],
				IQ.[attend_na] = COPY.[attend_na],
				IQ.[sum_insured_adequate] = COPY.[sum_insured_adequate],
				IQ.[make_safe] = COPY.[make_safe],
				IQ.[has_insured_been_advised] = COPY.[has_insured_been_advised],
				IQ.[is_insured_aware_of_repairs] = COPY.[is_insured_aware_of_repairs],
				IQ.[cost_of_repairs] = COPY.[cost_of_repairs],
				IQ.[recommendation] = COPY.[recommendation],
				IQ.[client_willing_to_proceed] = COPY.[client_willing_to_proceed],
				IQ.[building_type] = COPY.[building_type],
				IQ.[design_type] = COPY.[design_type],
				IQ.[construction_type] = COPY.[construction_type],
				IQ.[roof_type] = COPY.[roof_type],
				IQ.[square_metres] = COPY.[square_metres],
				IQ.[age] = COPY.[age],
				IQ.[overall_condition_acceptable] = COPY.[overall_condition_acceptable],
				IQ.[is_iag_assessment_required] = COPY.[is_iag_assessment_required],
				IQ.[ob_bungalow] = COPY.[ob_bungalow],
				IQ.[ob_fibro_shed] = COPY.[ob_fibro_shed],
				IQ.[ob_brick_shed] = COPY.[ob_brick_shed],
				IQ.[ob_metal_shed] = COPY.[ob_metal_shed],
				IQ.[ob_metal_garage] = COPY.[ob_metal_garage],
				IQ.[ob_above_ground_pool] = COPY.[ob_above_ground_pool],
				IQ.[ob_pergola] = COPY.[ob_pergola],
				IQ.[ob_timber_carport] = COPY.[ob_timber_carport],
				IQ.[ob_brick_carport] = COPY.[ob_brick_carport],
				IQ.[ob_dog_kennel] = COPY.[ob_dog_kennel],
				IQ.[ob_external_laundry] = COPY.[ob_external_laundry],
				IQ.[ob_below_ground_pool] = COPY.[ob_below_ground_pool],
				IQ.[ob_external_wc] = COPY.[ob_external_wc],
				IQ.[ob_bbq_area] = COPY.[ob_bbq_area],
				IQ.[ob_pool_room] = COPY.[ob_pool_room],
				IQ.[ob_store_room] = COPY.[ob_store_room],
				IQ.[ob_cubby_house] = COPY.[ob_cubby_house],
				IQ.[ob_pump_room] = COPY.[ob_pump_room],
				IQ.[ob_granny_flat] = COPY.[ob_granny_flat],
				IQ.[ob_brick_garage] = COPY.[ob_brick_garage],
				IQ.[ob_fibro_garage] = COPY.[ob_fibro_garage],
				IQ.[ob_carport_metal] = COPY.[ob_carport_metal],
				IQ.[ob_screen_enclosures] = COPY.[ob_screen_enclosures],
				IQ.[ob_fence] = COPY.[ob_fence],
				IQ.[est_labour_markup] = COPY.[est_labour_markup],
				IQ.[est_material_markup] = COPY.[est_material_markup],
				IQ.[est_room_cost] = COPY.[est_room_cost],
				IQ.[est_job_cost] = COPY.[est_job_cost],
				IQ.[est_room_sale_price] = COPY.[est_room_sale_price],
				IQ.[est_job_sale_price] = COPY.[est_job_sale_price],
				IQ.[est_room_profit] = COPY.[est_room_profit],
				IQ.[est_job_profit] = COPY.[est_job_profit],
				IQ.[profit_percentage] = COPY.[profit_percentage],
				IQ.[labour_total] = COPY.[labour_total],
				IQ.[material_total] = COPY.[material_total],
				IQ.[room_trade_total] = COPY.[room_trade_total],
				IQ.[job_trade_total] = COPY.[job_trade_total],
				IQ.[insurance_trade_id] = COPY.[insurance_trade_id],
				IQ.[insurance_room_id] = COPY.[insurance_room_id],
				IQ.[sun_client_discussion] = COPY.[sun_client_discussion],
				IQ.[sun_cause_of_damage] = COPY.[sun_cause_of_damage],
				IQ.[sun_conclusion] = COPY.[sun_conclusion],
				IQ.[sun_estimate] = COPY.[sun_estimate],
				IQ.[sun_maintenance_defects_not_covered] = COPY.[sun_maintenance_defects_not_covered],
				IQ.[sun_insured_advised_not_covered] = COPY.[sun_insured_advised_not_covered],
				IQ.[sun_estimate_not_covered] = COPY.[sun_estimate_not_covered],
				IQ.[sun_recovery_details] = COPY.[sun_recovery_details],
				IQ.[sun_total_estimate] = COPY.[sun_total_estimate],
				--IQ.[attach_filename] = COPY.[attach_filename],
				--IQ.[attach] = COPY.[attach],
				--IQ.[proceed_filename] = COPY.[proceed_filename],
				--IQ.[proceed_doc] = COPY.[proceed_doc],
				--IQ.[signed_filename] = COPY.[signed_filename],
				--IQ.[signed_doc] = COPY.[signed_doc],
				IQ.[negative_quote_id] = COPY.[negative_quote_id],
				IQ.[from_search] = COPY.[from_search],
				IQ.[is_fake_neg_quote] = COPY.[is_fake_neg_quote],
				IQ.[fake_bypass] = COPY.[fake_bypass],
				IQ.[variation_checked_by] = COPY.[variation_checked_by],
				IQ.[variation_checked_on] = COPY.[variation_checked_on],
				IQ.[est_job_sale_price_with_HOW] = COPY.[est_job_sale_price_with_HOW],
				IQ.[home_habitable] = COPY.[home_habitable],
				IQ.[VacateDays] = COPY.[VacateDays],
				IQ.[contains_asbestos] = COPY.[contains_asbestos],
				IQ.[home_warranty_required] = COPY.[home_warranty_required],
				IQ.[home_warranty_sum] = COPY.[home_warranty_sum],
				IQ.[sun_resultant_damage] = COPY.[sun_resultant_damage],
				IQ.[sun_maintenance_defects] = COPY.[sun_maintenance_defects],
				IQ.[sun_insured_advised] = COPY.[sun_insured_advised],
				IQ.[sun_claim_covered] = COPY.[sun_claim_covered],
				IQ.[sun_action_required] = COPY.[sun_action_required],
				IQ.[sun_action_desc] = COPY.[sun_action_desc],
				IQ.[sun_contents_involved] = COPY.[sun_contents_involved],
				IQ.[sun_contents_desc] = COPY.[sun_contents_desc],
				IQ.[version_label] = COPY.[version_label],
				IQ.[SignNumber] = COPY.[SignNumber],
				IQ.[SignedByClient] = COPY.[SignedByClient],
				IQ.[Damage_match_explanation] = COPY.[Damage_match_explanation],
				IQ.[Maintenance_issues_noted] = COPY.[Maintenance_issues_noted],
				IQ.[Damage_Result_Of] = COPY.[Damage_Result_Of],
				IQ.[Damage_Date] = COPY.[Damage_Date],
				IQ.[Damage_Date] = COPY.[Repairs_Proceeding_per_authorisation_limits],
				IQ.[Damage_Date] = COPY.[Damage_Date2],
				IQ.[created_by] = COPY.[created_by],
				IQ.[create_date] = COPY.[create_date],
				IQ.[updated_by] = @UserName,
				IQ.[updated_date] = GETDATE()
			FROM [dbo].[Insurance_Quote] IQ
				INNER JOIN [dbo.[Insurance_Quote] COPY ON COPY.[Insurance_Quote_id] = @RecentQuoteId
			WHERE IQ.[Insurance_Quote_id] = @InsuranceQuoteId;

		SET @Error = @@ERROR;

		IF ( @Error = 0 )
			IF ( @Transaction = 0 ) COMMIT TRANSACTION;
		ELSE
			IF ( @Transaction = 0 ) ROLLBACK TRANSACTION;

	END TRY
	BEGIN CATCH

		DECLARE @ErrMessage VARCHAR(2048);

		SET @ErrMessage = ERROR_MESSAGE();

		DECLARE @ErrSeverity INT;

		SET @ErrSeverity = ERROR_SEVERITY();

		DECLARE @ErrStatus INT;

		SET @ErrStatus = ERROR_STATE();

		IF ( @Transaction = 0 ) ROLLBACK TRANSACTION;

		RAISERROR ( @ErrMessage, @ErrSeverity,  @ErrStatus ) WITH NOWAIT;

	END CATCH;

	SET NOCOUNT OFF;

END;
GO
