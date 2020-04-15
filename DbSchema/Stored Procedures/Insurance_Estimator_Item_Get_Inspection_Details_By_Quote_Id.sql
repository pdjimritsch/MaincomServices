USE [visionary]; -- change the database name if required
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Estimator_Item_Get_Inspection_Details_By_Quote_Id'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Estimator_Item_Get_Inspection_Details_By_Quote_Id];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 25 February 2013
-- Description:	Obtains the insurance estimator from the specified criteria.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Estimator_Item_Get_Inspection_Details_By_Quote_Id] ( @QuoteId INT, @StartIndex INT = -1, @FetchCount INT = 0 )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	--
	-- Notes: 
	--        The markup types for labour and material are [l_markup_type] and [m_markup_type] consecutively.
	--        The value for the markup types are 0 = Monetary setting and 1 = Percentage setting.
	--
	--        The labour and material markup values are currently extracted from the consecutive columns
	--        [est_labour_markup] and [est_material_markup] within the [Insurance_Quote] database table.
	--
	--
	--        The markup cost total for labour and material are preserved in the column [l_total_with_margin]
	--        and [m_total_with_margin] consecutively.
	--
	--        The column [total_with_margin] contains the summation of the values preserved within the columns
	--        [l_total_with_margin] and [m_total_with_margin].
	--
	
	SET @QuoteId = ISNULL(@QuoteId, -1);

	IF ( @QuoteId <= 0 )
	BEGIN
		SET NOCOUNT OFF
		RETURN;
	END;

	IF ( @FetchCount = 0 ) OR ( @StartIndex < 0 )
	BEGIN

		SELECT	IE.[Insurance_Estimator_Item_Id],
				IE.[Insurance_Quote_id],
				IE.[Insurance_Scope_Item_Id],
				IE.[room_id],
				IE.[short_desc],
				IE.[long_desc],
				IE.[l_unit],
				IE.[m_unit],
				IE.[l_quantity],
				IE.[m_quantity],
				IE.[l_rate],
				IE.[m_rate],
				IE.[l_total],
				IE.[m_total],
				IE.[l_percent],
				IE.[m_percent],
				ISNULL(IE.[l_percent_type], 1) AS [l_percent_type],
				ISNULL(IE.[m_percent_type], 1) AS [m_percent_type],
				IE.[l_cost_total],
				IE.[m_cost_total],
				IE.[cost_total],
				IE.[l_cost_rate],
				IE.[m_cost_rate],
				IE.[l_total_with_margin],
				IE.[m_total_with_margin],
				IE.[total_with_margin],
				IE.[total],
				IE.[created_by],
				IE.[create_date],
				IE.[Insurance_Trade_Id],
				IE.[code],
				IE.[is_lock_for_negative_quote],
				IE.[old_est_id],
				IE.[neg_l_markup],
				IE.[neg_m_markup],
				IE.[neg_from_quote_id],
				IE.[neg_assigned_to_name],
				IE.[bypass],
				IE.[room_size_1],
				IE.[room_size_2],
				IE.[room_size_3],
				IE.[IsExtraItem],
				IE.[Cancelled_Estimator_Item_ID],
				IE.[Damage_Result_Of],
				IE.[Has_Structural_Damage],
				IE.[DamageText],
				IE.[MinimumCharge],
				IE.[updated_by],
				IE.[updated_date]
		FROM    [dbo].[Insurance_Estimator_Item] IE
		WHERE ( IE.[Insurance_Quote_id] = @QuoteId )
		ORDER BY IE.[Insurance_Estimator_Item_Id];

	END
	ELSE IF ( @StartIndex >= 0 ) AND ( @FetchCount > 0 )
	BEGIN

		WITH [LocalCache] AS
		(
			SELECT	IE.[Insurance_Estimator_Item_Id],
					IE.[Insurance_Quote_id],
					IE.[Insurance_Scope_Item_Id],
					IE.[room_id],
					IE.[short_desc],
					IE.[long_desc],
					IE.[l_unit],
					IE.[m_unit],
					IE.[l_quantity],
					IE.[m_quantity],
					IE.[l_rate],
					IE.[m_rate],
					IE.[l_total],
					IE.[m_total],
					IE.[l_percent],
					IE.[m_percent],
					ISNULL(IE.[l_percent_type], 1) AS [l_percent_type],
					ISNULL(IE.[m_percent_type], 1) AS [m_percent_type],
					IE.[l_cost_total],
					IE.[m_cost_total],
					IE.[cost_total],
					IE.[l_cost_rate],
					IE.[m_cost_rate],
					IE.[l_total_with_margin],
					IE.[m_total_with_margin],
					IE.[total_with_margin],
					IE.[total],
					IE.[created_by],
					IE.[create_date],
					IE.[Insurance_Trade_Id],
					IE.[code],
					IE.[is_lock_for_negative_quote],
					IE.[old_est_id],
					IE.[neg_l_markup],
					IE.[neg_m_markup],
					IE.[neg_from_quote_id],
					IE.[neg_assigned_to_name],
					IE.[bypass],
					IE.[room_size_1],
					IE.[room_size_2],
					IE.[room_size_3],
					IE.[IsExtraItem],
					IE.[Cancelled_Estimator_Item_ID],
					IE.[Damage_Result_Of],
					IE.[Has_Structural_Damage],
					IE.[DamageText],
					IE.[MinimumCharge],
					IE.[updated_by],
					IE.[updated_date],
					ROW_NUMBER() OVER ( ORDER BY IE.[Insurance_Estimator_Item_id] ) AS [RowIndex]
			FROM    [dbo].[Insurance_Estimator_Item] IE
			WHERE ( IE.[Insurance_Quote_id] = @QuoteId )
		)
		SELECT * FROM [LocalCache] LC WHERE LC.[RowIndex] BETWEEN ( @StartIndex + 1 ) AND ( @StartIndex + @FetchCount )
		ORDER BY LC.[Insurance_Estimator_Item_Id]

	END
	ELSE
	BEGIN

		SELECT	IE.[Insurance_Estimator_Item_Id],
				IE.[Insurance_Quote_id],
				IE.[Insurance_Scope_Item_Id],
				IE.[room_id],
				IE.[short_desc],
				IE.[long_desc],
				IE.[l_unit],
				IE.[m_unit],
				IE.[l_quantity],
				IE.[m_quantity],
				IE.[l_rate],
				IE.[m_rate],
				IE.[l_total],
				IE.[m_total],
				IE.[l_percent],
				IE.[m_percent],
				ISNULL(IE.[l_percent_type], 1) AS [l_percent_type],
				ISNULL(IE.[m_percent_type], 1) AS [m_percent_type],
				IE.[l_cost_total],
				IE.[m_cost_total],
				IE.[cost_total],
				IE.[l_cost_rate],
				IE.[m_cost_rate],
				IE.[l_total_with_margin],
				IE.[m_total_with_margin],
				IE.[total_with_margin],
				IE.[total],
				IE.[created_by],
				IE.[create_date],
				IE.[Insurance_Trade_Id],
				IE.[code],
				IE.[is_lock_for_negative_quote],
				IE.[old_est_id],
				IE.[neg_l_markup],
				IE.[neg_m_markup],
				IE.[neg_from_quote_id],
				IE.[neg_assigned_to_name],
				IE.[bypass],
				IE.[room_size_1],
				IE.[room_size_2],
				IE.[room_size_3],
				IE.[IsExtraItem],
				IE.[Cancelled_Estimator_Item_ID],
				IE.[Damage_Result_Of],
				IE.[Has_Structural_Damage],
				IE.[DamageText],
				IE.[MinimumCharge],
				IE.[updated_by],
				IE.[updated_date]
		FROM    [dbo].[Insurance_Estimator_Item] IE
		WHERE ( IE.[Insurance_Quote_id] = @QuoteId )
		ORDER BY IE.[Insurance_Estimator_Item_Id];

	END;
	
	SET NOCOUNT OFF;	

END;
GO