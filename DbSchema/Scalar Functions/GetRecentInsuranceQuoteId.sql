USE [visionary]; -- change the database name if required
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'GetRecentInsuranceQuoteId'), N'IsScalarFunction'), 0) = 1
	DROP FUNCTION [dbo].GetRecentInsuranceQuoteId;
GO

CREATE FUNCTION [dbo].[GetRecentInsuranceQuoteId] ( @OrderId INT )
RETURNS INT
AS
BEGIN

	DECLARE @Id INT;

	SELECT @Id = MAX([Insurance_Quote_id]) FROM [dbo].[Insurance_Quote] WHERE [Order_id] = ISNULL(@OrderId, -1) AND ISNULL([variation_type], 0) = 0;

	RETURN @Id;

END;
GO