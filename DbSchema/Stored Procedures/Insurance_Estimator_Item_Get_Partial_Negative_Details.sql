USE [visionary]; -- change the database name if required
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Estimator_Item_Get_Partial_Negative_Details'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Estimator_Item_Get_Partial_Negative_Details];
GO

-- ==========================================================================================================
-- Author:		Paul Djimritsch
-- Create date: 25 February 2013
-- Description:	Obtains the insurance estimator line items for a negative insurance work order quote.
-- ==========================================================================================================
CREATE PROCEDURE [dbo].[Insurance_Estimator_Item_Get_Partial_Negative_Details] ( @QuoteId INT = NULL, @StartIndex INT = -1, @FetchCount INT = 0 )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	IF ( @FetchCount = 0 ) OR ( @StartIndex < 0 )
	BEGIN

		SELECT	IE.[Insurance_Estimator_Item_Id],
				IE.[Insurance_Quote_id],
				IE.[Insurance_Scope_Item_Id],
				IR.[name] AS [room_name],
				IE.[short_desc],
				IE.[long_desc],
				LIU.[Name] AS [l_unit_name],
				MIU.[Name] AS [m_unit_name],
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
				IT.[Trade_Name] AS [Insurance_Trade_Name],
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
		FROM [dbo].[Insurance_Estimator_Item] IE
				INNER JOIN [dbo].[Insurance_Quote] IQ ON [IQ].[Insurance_Quote_id] = IE.[Insurance_Quote_id]
					AND ( IQ.[variation_type] IS NOT NULL )
					AND ( IQ.[variation_type] = 2 /* Negative insurance work order quote variation type */ )
				INNER JOIN [dbo].[Insurance_Room] IR ON IR.[Insurance_Room_Id] = IE.[room_id]
				INNER JOIN [dbo].[Insurance_Unit] LIU ON LIU.[Insurance_Unit_ID] = IE.[l_unit]
				INNER JOIN [dbo].[Insurance_Unit] MIU ON MIU.[Insurance_Unit_ID] = IE.[m_unit]
				INNER JOIN [dbo].[Insurance_Trade] IT ON IT.[Insurance_Trade_ID] = IE.[Insurance_Trade_Id]
		WHERE  ( IE.[Insurance_Quote_id] = ISNULL(@QuoteId, -1) )
		ORDER BY IE.[Insurance_Estimator_Item_Id];

	END
	ELSE IF ( @StartIndex >= 0 ) AND ( @FetchCount > 0 )
	BEGIN

		WITH [LocalCache] AS
		(
			SELECT	IE.[Insurance_Estimator_Item_Id],
					IE.[Insurance_Quote_id],
					IE.[Insurance_Scope_Item_Id],
					IR.[name] AS [room_name],
					IE.[short_desc],
					IE.[long_desc],
					LIU.[Name] AS [l_unit_name],
					MIU.[Name] AS [m_unit_name],
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
					IT.[Trade_Name] AS [Insurance_Trade_Name],
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
			FROM [dbo].[Insurance_Estimator_Item] IE
					INNER JOIN [dbo].[Insurance_Quote] IQ ON [IQ].[Insurance_Quote_id] = IE.[Insurance_Quote_id]
						AND ( IQ.[variation_type] IS NOT NULL )
						AND ( IQ.[variation_type] = 2 /* Negative insurance work order quote variation type */ )
					INNER JOIN [dbo].[Insurance_Room] IR ON IR.[Insurance_Room_Id] = IE.[room_id]
					INNER JOIN [dbo].[Insurance_Unit] LIU ON LIU.[Insurance_Unit_ID] = IE.[l_unit]
					INNER JOIN [dbo].[Insurance_Unit] MIU ON MIU.[Insurance_Unit_ID] = IE.[m_unit]
					INNER JOIN [dbo].[Insurance_Trade] IT ON IT.[Insurance_Trade_ID] = IE.[Insurance_Trade_Id]
			WHERE  ( IE.[Insurance_Quote_id] = ISNULL(@QuoteId, -1) )
		)
		SELECT * FROM [LocalCache] LC WHERE LC.[RowIndex] BETWEEN ( @StartIndex + 1 ) AND ( @StartIndex + @FetchCount )
		ORDER BY LC.[Insurance_Estimator_Item_Id];

	END
	ELSE
	BEGIN

		SELECT	IE.[Insurance_Estimator_Item_Id],
				IE.[Insurance_Quote_id],
				IE.[Insurance_Scope_Item_Id],
				IR.[name] AS [room_name],
				IE.[short_desc],
				IE.[long_desc],
				LIU.[Name] AS [l_unit_name],
				MIU.[Name] AS [m_unit_name],
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
				IT.[Trade_Name] AS [Insurance_Trade_Name],
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
		FROM [dbo].[Insurance_Estimator_Item] IE
				INNER JOIN [dbo].[Insurance_Quote] IQ ON [IQ].[Insurance_Quote_id] = IE.[Insurance_Quote_id]
					AND ( IQ.[variation_type] IS NOT NULL )
					AND ( IQ.[variation_type] = 2 /* Negative insurance work order quote variation type */ )
				INNER JOIN [dbo].[Insurance_Room] IR ON IR.[Insurance_Room_Id] = IE.[room_id]
				INNER JOIN [dbo].[Insurance_Unit] LIU ON LIU.[Insurance_Unit_ID] = IE.[l_unit]
				INNER JOIN [dbo].[Insurance_Unit] MIU ON MIU.[Insurance_Unit_ID] = IE.[m_unit]
				INNER JOIN [dbo].[Insurance_Trade] IT ON IT.[Insurance_Trade_ID] = IE.[Insurance_Trade_Id]
		WHERE  ( IE.[Insurance_Quote_id] = ISNULL(@QuoteId, -1) )
		ORDER BY IE.[Insurance_Estimator_Item_Id];

	END;
	
	SET NOCOUNT OFF;	

END;
GO