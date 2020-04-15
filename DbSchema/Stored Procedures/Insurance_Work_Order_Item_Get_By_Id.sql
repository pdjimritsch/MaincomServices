USE [visionary]; -- change if required
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Work_Order_Item_Get_By_Id'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Work_Order_Item_Get_By_Id];
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
CREATE PROCEDURE [dbo].[Insurance_Work_Order_Item_Get_By_Id]( @Id INT )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

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
	WHERE	[Insurance_WorkOrderItems_Id] = ISNULL(@Id, -1);

	SET NOCOUNT OFF;

END;
