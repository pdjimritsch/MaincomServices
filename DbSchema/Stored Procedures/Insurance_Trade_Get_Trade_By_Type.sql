USE [visionary]; -- change if required
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Trade_Get_Trade_by_Type'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Trade_Get_Trade_By_Type];
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
-- Description:	Gets the trade category from the data warehouse.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Trade_Get_Trade_By_Type] ( @Type VARCHAR(100) )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT [Insurance_Trade_ID], [Trade_Name] = LTRIM(RTRIM([Trade_Name])), [Trade_Code] = LTRIM(RTRIM([Trade_Code])) 
	FROM [dbo].[Insurance_Trade]
	WHERE [Trade_Name] = ISNULL(@Type, '');

	SET NOCOUNT OFF;

END;
GO