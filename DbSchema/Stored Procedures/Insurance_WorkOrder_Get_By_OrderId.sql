USE [Visionary]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_WorkOrder_Get_By_OrderId'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_WorkOrder_Get_By_OrderId]
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 25 February 2013
-- Description:	Obtains the insurance work order from the specified keyword.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_WorkOrder_Get_By_OrderId] ( @OrderId INT )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT	IW.[ORDER_ID], 
			IW.[supplier_ref], 
			IW.[search_code_value],
			[job_status] = LTRIM(RTRIM(ISNULL(JS.[name], ''))),
			IW.[authorised_doc],
			IW.[authorised_filename],
			IW.[authorise_template_doc],
			IW.[authorise_template_filename],
			IW.[attach],
			IW.[attach_filename],
			IW.[council_file],
			IW.[council_filename],
			IW.[engineer_filename],
			IW.[engineer_file],
			IW.[makesafe_contents],
			IW.[makesafe_filename],
			IW.[report_contents],
			IW.[report_filename],
			IW.[signed_file],
			IW.[signed_filename],
			IW.[warrantee_file],
			IW.[warrantee_filename]
	FROM	[dbo].[Insurance_WorkOrder] IW
			LEFT JOIN [dbo].[Orders] O ON O.[ORDER_ID] = IW.[ORDER_ID]
			LEFT JOIN [dbo].[InsuranceStatus] JS ON JS.[id] = O.[STATUS]
	WHERE IW.[ORDER_ID] = ISNULL(@OrderId, 0);

	SET NOCOUNT OFF;

END;
GO
