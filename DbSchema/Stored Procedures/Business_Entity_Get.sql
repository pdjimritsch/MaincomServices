USE [Visionary]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Business_Entity_Get'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Business_Entity_Get]
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 25 February 2013
-- Description:	Obtains the business entity for the specified entity identity
-- ============================================================================
CREATE PROCEDURE [dbo].[Business_Entity_Get] ( @Id INT )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT	[BE_ID], [BE_NAME], [SEARCH_CODE] FROM [dbo].[BUSINESS_ENTITY] WHERE [BE_ID] = ISNULL(@Id, -1);

	SET NOCOUNT OFF;

END;
GO
