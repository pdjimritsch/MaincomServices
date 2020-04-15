USE [visionary]; -- change if required
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Unit_Get_Unit'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Unit_Get_Unit];
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
-- Description:	Gets the insurance unit entry that is associated with the identity key.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Unit_Get_Unit] ( @Id INT )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT [Insurance_Unit_ID], [Name] = LTRIM(RTRIM([Name])), [labour_unit], [material_unit]
	FROM [dbo].[Insurance_Unit] 
	WHERE [Insurance_Unit_ID] = ISNULL(@Id, 0);

	SET NOCOUNT OFF;

END;
GO