USE [visionary]; -- change the database name if required
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Quote_Get_Quotes_By_Order'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Quote_Get_Quotes_By_Order];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 29 January 2013
-- Description:	Obtains the insurance quote version / status details.
--
-- Modification: The circumstances information was replaced by the insurance
--               work order status.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Quote_Get_Quotes_By_Order] ( @OrderId INT )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT IQ.[Insurance_Quote_id] AS [Quote Id], 
	       LTRIM(RTRIM(ISNULL(IQ.[version_label], ''))) AS [Version],
		   [Variation Type] = CASE
						      WHEN IQ.[variation_type] IS NULL THEN 'Revision'
							  WHEN IQ.[variation_type] = 1 THEN 'Positive variation'
							  WHEN IQ.[variation_type] = 2 THEN 'Negative variation'
							  ELSE 'Revision'
							  END,
		   [Job Status] = JS.[name],
		   [Work Order Status] = LTRIM(RTRIM(IWS.[name])),
		   [Quote Status] = CASE WHEN QS.[name] IS NULL THEN 
								'Unspecified'
							ELSE QS.[name]
							END,
		   --IQ.[create_date] AS [Creation Date],
		   CONVERT(varchar(12), IQ.[create_date], 101) AS [Creation Date],
		   IQ.[created_by] AS [Created By], 
		   IQ.[est_job_cost] AS [Cost],
		   IQ.[est_job_sale_price] AS [Sale],
		   IQ.[est_job_profit] AS [Profit],
		   IQ.[supplier_ref] AS [Claim Reference],
		   IQ.[est_job_sale_price] AS [Quote Price],
		   IQ.[status],
		   QS.[name]
/*
		  (SELECT COUNT(*) FROM Insurance_WorkOrderMain WHERE (Insurance_WorkOrderMain.be_id > 0) AND (Insurance_WorkOrderMain.status_id < 600) AND Insurance_WorkOrderMain.order_id=IQ.[order_id]) AS WorkOrders
*/		  

	FROM [dbo].[Insurance_Quote] IQ WITH (NOLOCK)
	LEFT JOIN [dbo].[Insurance_QuoteStatus] QS WITH (NOLOCK) ON QS.[id] = IQ.[status]
	LEFT JOIN [dbo].[Insurance_WorkOrder] IW WITH (NOLOCK) ON IW.[ORDER_ID] = IQ.[Order_id]
	LEFT JOIN [dbo].[InsuranceStatus] IWS WITH (NOLOCK) ON IWS.[id] = IW.[status_id]
	LEFT JOIN [dbo].[Orders] O WITH (NOLOCK) ON O.[ORDER_ID] = IQ.[Order_id]
	LEFT JOIN [dbo].[InsuranceStatus] JS WITH (NOLOCK) ON JS.[id] = O.[STATUS]
	WHERE (IQ.[order_id] = ISNULL(@OrderId, 0)) AND ( NOT IQ.[is_fake_neg_quote]=1)
	ORDER BY IQ.[Insurance_Quote_id];

	SET NOCOUNT OFF;


END;
GO
