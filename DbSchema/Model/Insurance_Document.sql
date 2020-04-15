USE [visionary]; -- CHANGE IF REQUIRED
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Document'), N'IsUserTable'), 0) = 1
	IF ( COLUMNPROPERTY(OBJECT_ID('Insurance_Document'), 'file_id', 'ColumnId') IS NULL )
		ALTER TABLE [dbo].[Insurance_Document] ADD [file_id] UNIQUEIDENTIFIER NULL;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Document'), N'IsUserTable'), 0) = 1
	IF ( COLUMNPROPERTY(OBJECT_ID('Insurance_Document'), 'file_path', 'ColumnId') IS NULL )
		ALTER TABLE [dbo].[Insurance_Document] ADD [file_path] VARCHAR(1024) NULL;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Document'), N'IsUserTable'), 0) = 1
	IF ( COLUMNPROPERTY(OBJECT_ID('Insurance_Document'), 'SubcontractorID', 'ColumnId') IS NULL )
		ALTER TABLE [dbo].[Insurance_Document] ADD [SubcontractorID] INT NULL;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Document'), N'IsUserTable'), 0) = 1
	IF ( COLUMNPROPERTY(OBJECT_ID('Insurance_Document'), 'WorkOrderID', 'ColumnId') IS NULL )
		ALTER TABLE [dbo].[Insurance_Document] ADD [WorkOrderID] INT NULL;
GO