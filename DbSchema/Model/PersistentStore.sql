USE [visionary]; -- CHANGE IF REQUIRED
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'PersistentStore'), N'IsUserTable'), 0) = 1
	DROP TABLE [dbo].[PersistentStore];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 1 April 2013
-- Description:	Creates the persistent storage for session state.
-- ============================================================================
CREATE TABLE [dbo].[PersistentStore]
(
	[Id] NVARCHAR(128),
	[Key] NVARCHAR(128),
	[Value] NVARCHAR(MAX) NULL,
	[CreatedBy] VARCHAR(64) NULL,
	[CreatedDate] DATETIME
)
ON [PRIMARY];
GO