USE [visionary]; -- change if required
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_WorkOrderMain_Get_By_Status'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_WorkOrderMain_Get_By_Status];
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
-- Description:	Gets the insurance work order that is associated with the identity key.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_WorkOrderMain_Get_By_Status] ( @Status INT )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT	WO.[Insurance_WorkOrderMain_Id],
			WO.[Order_id],
			WO.[be_id],
			WO.[status_id],
			WO.[start_date],
			WO.[end_date],
			WO.[contact_method],
			WO.[fax],
			WO.[email],
			WO.[notes],
			WO.[created_by],
			WO.[create_date],
			WO.[signed_wo_filename],
			WO.[signed_wo],
			WO.[invoice_filename],
			WO.[invoice],
			WO.[amount_invoiced],
			WO.[received_date],
			WO.[completed_datetime],
			WO.[completed_by],
			WO.[completed],
			WO.[invoice_datetime],
			WO.[invoice_by],
			WO.[reference_no],
			WO.[is_locked],
			WO.[negative_quote_id],
			WO.[send_date],
			WO.[send_by],
			WO.[wo_pdf],
			WO.[wo_filename],
			WO.[in_invoice_progress],
			WO.[cost_auto_total],
			WO.[partial_id]
	FROM	[dbo].[Insurance_WorkOrderMain] WO LEFT JOIN [dbo].[Insurance_workorder_status] IWS ON ( IWS.[id] = WO.[status_id] ) AND ( IWS.[id] = ISNULL(@Status, -1) );

	SET NOCOUNT OFF;

END;
GO