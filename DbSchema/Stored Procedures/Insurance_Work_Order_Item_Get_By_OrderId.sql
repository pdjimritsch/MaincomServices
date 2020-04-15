USE [visionary]; -- change if required
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Work_Order_Item_Get_By_OrderId'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Work_Order_Item_Get_By_OrderId];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 22 October 2013
-- Description:	Gets the insurance work order items that are associated by the
--              insurance work order identity and the subcontractor (trader).
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Work_Order_Item_Get_By_OrderId]( @OrderId INT, @Trader VARCHAR(254) = NULL )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	IF ( LEN(ISNULL(@Trader, '')) = 0 )
	BEGIN

		SELECT	[Insurance_WorkOrderItems_Id],
				[Order_id],
				[Insurance_WorkOrderMain_id],
				[be_id],
				[long_desc],
				[created_by],
				[create_date],
				[row_version],
				[l_unit],
				[m_unit],
				[Room_Id],
				[Trade_Id],
				[sor_code],
				[l_quantity],
				[m_quantity],
				[l_rate],
				[m_rate],
				[l_total],
				[m_total],
				[total],
				[estimate_id],
				[bypass_delete],
				[bypass_save],
				[l_cost_rate],
				[m_cost_rate],
				[l_cost_total],
				[m_cost_total],
				[cost_total],
				[IsExtraItem]
		FROM	[dbo].[Insurance_WorkOrderItems]
		WHERE	[Order_id] = ISNULL(@OrderId, -1);

	END
	ELSE
	BEGIN

		SET @Trader = LTRIM(RTRIM(@Trader));

		SELECT	IWI.[Insurance_WorkOrderItems_Id],
				IWI.[Order_id],
				IWI.[Insurance_WorkOrderMain_id],
				IWI.[be_id],
				IWI.[long_desc],
				IWI.[created_by],
				IWI.[create_date],
				IWI.[row_version],
				IWI.[l_unit],
				IWI.[m_unit],
				IWI.[Room_Id],
				IWI.[Trade_Id],
				IWI.[sor_code],
				IWI.[l_quantity],
				IWI.[m_quantity],
				IWI.[l_rate],
				IWI.[m_rate],
				IWI.[l_total],
				IWI.[m_total],
				IWI.[total],
				IWI.[estimate_id],
				IWI.[bypass_delete],
				IWI.[bypass_save],
				IWI.[l_cost_rate],
				IWI.[m_cost_rate],
				IWI.[l_cost_total],
				IWI.[m_cost_total],
				IWI.[cost_total],
				IWI.[IsExtraItem]
		FROM	[dbo].[Insurance_WorkOrderItems] IWI 
			INNER JOIN [dbo].[Insurance_Trader_Trade] ITT ON ITT.[Insurance_Trade_id] = IWI.[Trade_Id]
			INNER JOIN [dbo].[BUSINESS_ENTITY] BE ON BE.[BE_ID] = ITT.[BE_Id] AND BE.[BE_NAME] = @Trader
		WHERE	( [Order_id] = ISNULL(@OrderId, -1) )

	END;

	SET NOCOUNT OFF;

END;
