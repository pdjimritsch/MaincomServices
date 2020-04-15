USE [visionary]; -- change if required
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_WorkOrder_Main_Get'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_WorkOrder_Main_Get];
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
-- Description:	Gets the collection of registered insurance work order main
--              entries from the data warehouse.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_WorkOrder_Main_Get]
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT	[Insurance_WorkOrderMain_Id],
			[Order_id],
			[be_id],
			[status_id],
			[start_date],
			[end_date],
			[contact_method],
			[fax],
			[email],
			[notes],
			[created_by],
			[create_date],
			[signed_wo_filename],
			[signed_wo],
			[invoice_filename],
			[invoice],
			[amount_invoiced],
			[received_date],
			[completed_datetime],
			[completed_by],
			[completed],
			[invoice_datetime],
			[invoice_by],
			[reference_no],
			[is_locked],
			[negative_quote_id],
			[send_date],
			[send_by],
			[wo_pdf],
			[wo_filename],
			[in_invoice_progress],
			[cost_auto_total],
			[partial_id]
	FROM	[dbo].[Insurance_WorkOrderMain];

	SET NOCOUNT OFF;

END;
GO

