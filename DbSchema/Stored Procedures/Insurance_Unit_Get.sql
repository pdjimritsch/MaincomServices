USE [visionary]; -- change if required
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Unit_Get'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Unit_Get];
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
-- Description:	Gets the registered insurance unit entries.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Unit_Get]
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT [Insurance_Unit_ID], [Name] = LTRIM(RTRIM([Name])), [labour_unit], [material_unit]
	FROM [dbo].[Insurance_Unit];

	SET NOCOUNT OFF;

END;
GO