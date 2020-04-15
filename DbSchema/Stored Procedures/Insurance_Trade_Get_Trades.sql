USE [visionary]; -- change if required
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Trade_Get_Trades'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Trade_Get_Trades];
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
-- Description:	Gets the trade categories from the data warehouse.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Trade_Get_Trades]
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT [Insurance_Trade_ID], [Trade_Name] = LTRIM(RTRIM([Trade_Name])), [Trade_Code] = LTRIM(RTRIM([Trade_Code])) 
	FROM [dbo].[Insurance_Trade] ORDER BY [Trade_Code];

	SET NOCOUNT OFF;

END;
GO