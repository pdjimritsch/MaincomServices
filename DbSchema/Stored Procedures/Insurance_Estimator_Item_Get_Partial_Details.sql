USE [visionary]; -- change the database name if required
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Estimator_Item_Get_Partial_Details'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Estimator_Item_Get_Partial_Details];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 25 February 2013
-- Description:	Obtains the insurance estimator from the specified criteria.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Estimator_Item_Get_Partial_Details] ( @OrderId INT = NULL )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;
	
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
	FROM [dbo].[Insurance_Quote] IQ 
			INNER JOIN [dbo].[Insurance_Estimator_Item] IE ON [IE].[Insurance_Quote_id] = IQ.[Insurance_Quote_id]
			INNER JOIN [dbo].[Insurance_Room] IR ON IR.[Insurance_Room_Id] = IE.[room_id]
			INNER JOIN [dbo].[Insurance_Unit] LIU ON LIU.[Insurance_Unit_ID] = IE.[l_unit]
			INNER JOIN [dbo].[Insurance_Unit] MIU ON MIU.[Insurance_Unit_ID] = IE.[m_unit]
			INNER JOIN [dbo].[Insurance_Trade] IT ON IT.[Insurance_Trade_ID] = IE.[Insurance_Trade_Id]
	WHERE   ( IQ.[Order_id] = ISNULL(@OrderId, -1) )
	AND     (( IQ.[status] IS NULL ) OR (( IQ.[status] IS NOT NULL) AND EXISTS(SELECT 1 FROM [dbo].[Insurance_QuoteStatus] WHERE  [id] = IQ.[status] AND [name] <> 'Cancelled') ))
	AND     EXISTS(SELECT 1 FROM [dbo].[Insurance_WorkOrder] IWS WHERE ( IWS.[status_id] IS NOT NULL )
	AND     EXISTS(SELECT 1 FROM [dbo].[InsuranceStatus] WHERE ( [id] = IWS.[status_id] ) AND ( [name] = 'Approved' )))
	AND     ( ISNULL(IQ.[variation_type], 0) NOT IN ( 2 /* Negative InsuranCe Work Order Quote Variation */ ))
	ORDER BY IE.[Insurance_Estimator_Item_Id];
	
	SET NOCOUNT OFF;	

END;
GO