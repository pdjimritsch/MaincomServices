USE [visionary]; -- change if required
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'PersistentStore_Delete'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[PersistentStore_Delete];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 1 April 2013
-- Description:	Gets the registered session state entry
-- ============================================================================
CREATE PROCEDURE [dbo].[PersistentStore_Delete]
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'PersistentStore'), N'IsUserTable'), 0) = 1
		TRUNCATE TABLE [dbo].[PersistentStore];

	SET NOCOUNT OFF;

END;
GO