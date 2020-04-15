USE [visionary]; -- CHANGE IF REQUIRED
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Quote'), N'IsUserTable'), 0) = 1
	IF ( COLUMNPROPERTY(OBJECT_ID('Insurance_Quote'), 'updated_by', 'ColumnId') IS NULL )
		ALTER TABLE [dbo].[Insurance_Quote] ADD [updated_by] VARCHAR(20) NULL;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Quote'), N'IsUserTable'), 0) = 1
	IF ( COLUMNPROPERTY(OBJECT_ID('Insurance_Quote'), 'updated_date', 'ColumnId') IS NULL )
		ALTER TABLE [dbo].[Insurance_Quote] ADD [updated_date] DATETIME NULL;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Quote'), N'IsUserTable'), 0) = 1
	IF ( COLUMNPROPERTY(OBJECT_ID('Insurance_Quote'), 'row_version', 'ColumnId') IS NOT NULL )
		IF NOT EXISTS(SELECT 1 FROM [sys.types] WHERE [system_type_id] IN (SELECT [system_type_id] FROM sys.columns WHERE OBJECT_NAME([object_id]) = 'Insurance_Quote' AND [name] = 'row_version') and [name] = 'int')
			ALTER TABLE [dbo].[Insurance_Quote] ALTER COLUMN [row_version] INT NULL;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Quote'), N'IsUserTable'), 0) = 1
	IF ( COLUMNPROPERTY(OBJECT_ID('Insurance_Quote'), 'SignNumber', 'ColumnId') IS NULL )
		ALTER TABLE [dbo].[Insurance_Quote] ADD [SignNumber] INT NULL;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Quote'), N'IsUserTable'), 0) = 1
	IF ( COLUMNPROPERTY(OBJECT_ID('Insurance_Quote'), 'Has_Structural_Damage', 'ColumnId') IS NULL )
		ALTER TABLE [dbo].[Insurance_Quote] ADD [Has_Structural_Damage] BIT NULL CONSTRAINT [DF_Insurance_Quote_Has_Structural_Damage] DEFAULT ((0));
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Quote'), N'IsUserTable'), 0) = 1
	IF ( COLUMNPROPERTY(OBJECT_ID('Insurance_Quote'), 'Damage_match_explanation', 'ColumnId') IS NULL )
		ALTER TABLE [dbo].[Insurance_Quote] ADD [Damage_match_explanation] BIT NULL;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Quote'), N'IsUserTable'), 0) = 1
	IF ( COLUMNPROPERTY(OBJECT_ID('Insurance_Quote'), 'Maintenance_issues_noted', 'ColumnId') IS NULL )
		ALTER TABLE [dbo].[Insurance_Quote] ADD [Maintenance_issues_noted] BIT NULL;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Quote'), N'IsUserTable'), 0) = 1
	IF ( COLUMNPROPERTY(OBJECT_ID('Insurance_Quote'), 'SignedByClient', 'ColumnId') IS NULL )
		ALTER TABLE [dbo].[Insurance_Quote] ADD [SignedByClient] BIT NULL;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Quote'), N'IsUserTable'), 0) = 1
	IF ( COLUMNPROPERTY(OBJECT_ID('Insurance_Quote'), 'Damage_Result_Of', 'ColumnId') IS NULL )
		ALTER TABLE [dbo].[Insurance_Quote] ADD [Damage_Result_Of] INT NULL CONSTRAINT [DF_Insurance_Quote_Damage_Result_Of] DEFAULT ((0));
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Quote'), N'IsUserTable'), 0) = 1
	IF ( COLUMNPROPERTY(OBJECT_ID('Insurance_Quote'), 'Damage_Date', 'ColumnId') IS NULL )
		ALTER TABLE [dbo].[Insurance_Quote] ADD [Damage_Date] DATETIME NULL;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Quote'), N'IsUserTable'), 0) = 1
	IF ( COLUMNPROPERTY(OBJECT_ID('Insurance_Quote'), 'Repairs_Proceeding_per_authorisation_limits', 'ColumnId') IS NULL )
		ALTER TABLE [dbo].[Insurance_Quote] ADD [Repairs_Proceeding_per_authorisation_limits] BIT NULL;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Quote'), N'IsUserTable'), 0) = 1
	IF ( COLUMNPROPERTY(OBJECT_ID('Insurance_Quote'), 'Damage_Date2', 'ColumnId') IS NULL )
		ALTER TABLE [dbo].[Insurance_Quote] ADD [Damage_Date2] DATETIME NULL;
GO