USE [visionary]; -- change if required
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Work_Order_Item_Get_By_SearchCode'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Work_Order_Item_Get_By_SearchCode];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 4 February 2013
-- Description:	Gets the insurance unit entry that is associated with the identity key.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Work_Order_Item_Get_By_SearchCode]( @SearchCode VARCHAR(50) )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	IF @SearchCode IS NOT NULL SET @SearchCode = LTRIM(RTRIM(@SearchCode));

	SELECT	WOI.[Insurance_WorkOrderItems_Id],
			WOI.[Order_id],
			WOI.[Insurance_WorkOrderMain_id],
			WOI.[be_id],
			WOI.[long_desc],
			WOI.[created_by],
			WOI.[create_date],
			WOI.[row_version],
			WOI.[l_unit],
			WOI.[m_unit],
			WOI.[Room_Id],
			WOI.[Trade_Id],
			WOI.[sor_code],
			WOI.[l_quantity],
			WOI.[m_quantity],
			WOI.[l_rate],
			WOI.[m_rate],
			WOI.[l_total],
			WOI.[m_total],
			WOI.[total],
			WOI.[estimate_id],
			WOI.[bypass_delete],
			WOI.[bypass_save],
			WOI.[l_cost_rate],
			WOI.[m_cost_rate],
			WOI.[l_cost_total],
			WOI.[m_cost_total],
			WOI.[cost_total],
			WOI.[IsExtraItem]
	FROM	[dbo].[Insurance_WorkOrderItems] WOI
	LEFT JOIN [dbo].[Insurance_WorkOrder] WO ON WO.[ORDER_ID] = WOI.[Order_id] AND WO.[search_code_value] = @SearchCode;

	SET NOCOUNT OFF;

END;
GO