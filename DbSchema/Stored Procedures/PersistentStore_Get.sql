USE [visionary]; -- change if required
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'PersistentStore_Get'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[PersistentStore_Get];
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
CREATE PROCEDURE [dbo].[PersistentStore_Get] ( @Id NVARCHAR(512), @Key NVARCHAR(512) )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT [Id], [Key], [Value], [CreatedBy], [CreatedDate] FROM [dbo].[PersistentStore]
	WHERE [Id] = ISNULL(@Id, N'') -- session identity
	AND (( LEN(ISNULL(@Key, '')) = 0 ) OR ( [Key] = LTRIM(RTRIM(@Key)) ));

	SET NOCOUNT OFF;

END;
GO