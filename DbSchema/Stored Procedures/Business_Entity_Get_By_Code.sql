USE [Visionary]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Business_Entity_Get_By_Code'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Business_Entity_Get_By_Code]
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 25 February 2013
-- Description:	Obtains the business entity for the specified entity identity
-- ============================================================================
CREATE PROCEDURE [dbo].[Business_Entity_Get_By_Code] ( @Filter VARCHAR(50), @StartIndex INT = 0, @EndIndex INT = 100 )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @SeekFilter VARCHAR(254);

	SET @SeekFilter = '%' + ISNULL(@Filter, '') + '%'; -- contains the specified business entity search code

	WITH MyFilter ([BE_ID], [BE_NAME], [SEARCH_CODE], [Row Number] ) AS
	(
		SELECT BE.[BE_ID] AS [BE_ID], BE.[BE_NAME] AS [BE_NAME], BE.[SEARCH_CODE] AS [SEARCH_CODE], ROW_NUMBER() OVER (ORDER BY BE.[SEARCH_CODE]) AS [Row Number]
		FROM [dbo].[BUSINESS_ENTITY] BE WITH (READCOMMITTED)
		WHERE ( BE.[BE_NAME] + ' ' + BE.[SEARCH_CODE] LIKE @SeekFilter )
	)
	SELECT DISTINCT [BE_ID], [BE_NAME], [SEARCH_CODE] FROM MyFilter WHERE [Row Number] BETWEEN ISNULL(@StartIndex, 0) AND ISNULL(@EndIndex, 0);

	SET NOCOUNT OFF;

END;
GO
