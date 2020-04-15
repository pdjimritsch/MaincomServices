﻿USE [visionary]; -- change the database name if required
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Status_Get_By_Name'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Status_Get_By_Name];
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
-- Description:	Obtains the registered insurance status.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Status_Get_By_Name] ( @Name VARCHAR(50) )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT [id], [name] FROM [dbo].[InsuranceStatus] WHERE [name] = ISNULL(@Name, '');

	SET NOCOUNT OFF;

END;
GO