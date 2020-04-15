USE [visionary]; -- change the database name if required
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_RoofType_Get'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_RoofType_Get];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 1 March 2013
-- Description:	Obtains the registered insurance recognized building roof types
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_RoofType_Get]
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT [id], [name] FROM [dbo].[Insurance_RoofType];

	SET NOCOUNT OFF;

END;
GO
