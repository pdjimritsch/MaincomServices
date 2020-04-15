USE [visionary]; -- change the database name if required
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Damage_Get_By_Name'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Damage_Get_By_Name];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 1 March 2013
-- Description:	Obtains the registered insurance damage that is identified by the
--              specified identity.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Damage_Get_By_Name] ( @Name VARCHAR(50) )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT [ID], [Name] FROM [dbo].[Insurance_Damage_Cause] WHERE [Name] = ISNULL(@Name, '');

	SET NOCOUNT OFF;

END;
GO