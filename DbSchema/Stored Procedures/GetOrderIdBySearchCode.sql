USE [Visionary]
GO

/****** Object:  StoredProcedure [dbo].[Get_Order_ID_By_Search_Code]    Script Date: 01/31/2013 10:25:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Get_Order_ID_By_Search_Code'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Get_Order_ID_By_Search_Code];
GO

-- ============================================================================
-- Author:			Andrei Baranovski
-- Create date:		22 May 2012
-- Modification History
--
-- Paul Djimritsch. 31 January 2012: Added Work Order status information.
--              
-- ============================================================================
CREATE PROCEDURE [dbo].[Get_Order_ID_By_Search_Code] ( @Search_Code VARCHAR(50) )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT O.[ORDER_ID], IW.[supplier_ref], IWS.[name] AS [status_value]
	FROM [dbo].[ORDERS] O WITH (READCOMMITTED) 
	INNER JOIN [dbo].[Insurance_WorkOrder] IW ON IW.[ORDER_ID] = O.[ORDER_ID]
	INNER JOIN [dbo].[InsuranceStatus] IWS ON IWS.[id] = IW.[status_id]
	WHERE O.[SEARCH_CODE] = @Search_Code;

	SET NOCOUNT OFF;

END;
GO
