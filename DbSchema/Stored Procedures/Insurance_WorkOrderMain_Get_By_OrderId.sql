USE [visionary]; -- change if required
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_WorkOrderMain_Get_By_OrderId'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_WorkOrderMain_Get_By_OrderId];
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
CREATE PROCEDURE [dbo].[Insurance_WorkOrderMain_Get_By_OrderId]( @OrderId INT, @StartIndex INT = 0, @EndIndex INT = 501 )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	WITH MyFilter
	(
		[Insurance_WorkOrderMain_Id],
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
		[partial_id],
		[Row Number]
	) AS (
		SELECT	WOM.[Insurance_WorkOrderMain_Id],
				WOM.[Order_id],
				WOM.[be_id],
				WOM.[status_id],
				WOM.[start_date],
				WOM.[end_date],
				WOM.[contact_method],
				WOM.[fax],
				WOM.[email],
				WOM.[notes],
				WOM.[created_by],
				WOM.[create_date],
				WOM.[signed_wo_filename],
				WOM.[signed_wo],
				WOM.[invoice_filename],
				WOM.[invoice],
				WOM.[amount_invoiced],
				WOM.[received_date],
				WOM.[completed_datetime],
				WOM.[completed_by],
				WOM.[completed],
				WOM.[invoice_datetime],
				WOM.[invoice_by],
				WOM.[reference_no],
				WOM.[is_locked],
				WOM.[negative_quote_id],
				WOM.[send_date],
				WOM.[send_by],
				WOM.[wo_pdf],
				WOM.[wo_filename],
				WOM.[in_invoice_progress],
				WOM.[cost_auto_total],
				WOM.[partial_id],
				ROW_NUMBER() OVER (ORDER BY WOM.[Insurance_WorkOrderMain_Id]) AS [Row Number]
		FROM	[dbo].[Insurance_WorkOrderMain] WOM WITH (READCOMMITTED)
		INNER JOIN [dbo].[Insurance_WorkOrder] WO WITH (READCOMMITTED) ON ( WO.[ORDER_ID] = WOM.[Order_id] ) AND ( WO.[ORDER_ID] = ISNULL(@OrderId, -1) )
	)
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
	FROM MyFilter
	WHERE [Row Number] BETWEEN ISNULL(@StartIndex, 0) AND ISNULL(@EndIndex, 0);

	SET NOCOUNT OFF;

END;
GO