USE [visionary]; -- change the database name if required
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'CommentOnColumn'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[CommentOnColumn];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 17 June 2013
-- Description:	Registers the comments for a user-defined database table.
-- ============================================================================
CREATE PROCEDURE [dbo].[CommentOnColumn] ( @Table SYSNAME, @Column SYSNAME, @Comments NVARCHAR(4000) )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET @Table = LTRIM(RTRIM(ISNULL(@Table, '')));

	IF ( LEN(@Table) = 0 ) OR (ISNULL(OBJECTPROPERTY(OBJECT_ID(@Table), N'IsUserTable'), 0) = 0) RETURN;

	SET @Column = LTRIM(RTRIM(ISNULL(@Column, '')));

	IF ( LEN(@Column) = 0 ) OR ( COLUMNPROPERTY(OBJECT_ID(@Table), @Column, 'ColumnId') IS NULL ) RETURN;

	SET @Comments = LTRIM(RTRIM(ISNULL(@Comments, N'')));

	EXECUTE sp_addextendedproperty N'MS_Description', @Comments, N'user', N'dbo', N'table', @Table, N'column', @Column;

END;
GO