USE [visionary]; -- change the database name if required
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Quote_Get_Quotes_By_OrderID'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Quote_Get_Quotes_By_OrderID];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

-- =============================================
-- Author: Andrei Baranovski
-- Create date: 22 may 2012
-- =============================================
CREATE PROCEDURE [dbo].[Insurance_Quote_Get_Quotes_By_OrderID]	
	@OrderID int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT [Insurance_Quote_id] AS Quote_ID
		  ,[version_label] AS [Version]     
		  ,[created_by] AS [Created By]
		  ,[create_date] AS [Date]
		  , LEFT ([details_and_Circumstances], 100) AS [Details]
		  ,[est_job_sale_price] AS [Job Price]
		  ,[supplier_ref] AS [Claim Ref]
	FROM [Insurance_Quote]
	WHERE (order_id=@OrderID) AND (version_label IS NOT NULL)

END;
GO
