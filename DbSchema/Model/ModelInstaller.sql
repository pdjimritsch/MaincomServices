USE [visionary]; -- CHANGE IF REQUIRED
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING ON;
GO

SET ANSI_WARNINGS ON;
GO

SET ARITHABORT ON;
GO

SET NUMERIC_ROUNDABORT OFF;
GO

SET CONCAT_NULL_YIELDS_NULL ON;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Employee'), N'IsUserTable'), 0) = 1
	IF ( COLUMNPROPERTY(OBJECT_ID(N'Employee'), 'Description', 'ColumnId') IS NULL )
		ALTER TABLE [dbo].[Employee] ADD [Description] VARCHAR(200) NULL;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Document'), N'IsUserTable'), 0) = 1
	IF ( COLUMNPROPERTY(OBJECT_ID('Insurance_Document'), 'file_id', 'ColumnId') IS NULL )
		ALTER TABLE [dbo].[Insurance_Document] ADD [file_id] UNIQUEIDENTIFIER NULL;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Document'), N'IsUserTable'), 0) = 1
	IF ( COLUMNPROPERTY(OBJECT_ID('Insurance_Document'), 'SubcontractorID', 'ColumnId') IS NULL )
		ALTER TABLE [dbo].[Insurance_Document] ADD [SubcontractorID] INT NULL;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Document'), N'IsUserTable'), 0) = 1
	IF ( COLUMNPROPERTY(OBJECT_ID('Insurance_Document'), 'WorkOrderID', 'ColumnId') IS NULL )
		ALTER TABLE [dbo].[Insurance_Document] ADD [WorkOrderID] INT NULL;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Estimator_Item'), N'IsUserTable'), 0) = 1
BEGIN

	IF ( COLUMNPROPERTY(OBJECT_ID('Insurance_Estimator_Item'), 'room_size_3', 'ColumnId') IS NULL )
		ALTER TABLE [dbo].[Insurance_Estimator_Item] ADD [room_size_3] DECIMAL(9,2) NULL;

	IF ( COLUMNPROPERTY(OBJECT_ID('Insurance_Estimator_Item'), 'updated_by', 'ColumnId') IS NULL )
		ALTER TABLE [dbo].[Insurance_Estimator_Item] ADD [updated_by] VARCHAR(20) NULL;

	IF ( COLUMNPROPERTY(OBJECT_ID('Insurance_Estimator_Item'), 'updated_date', 'ColumnId') IS NULL )
		ALTER TABLE [dbo].[Insurance_Estimator_Item] ADD [updated_date] DATETIME NULL;

	/*
	IF ( COLUMNPROPERTY(OBJECT_ID('Insurance_Estimator_Item'), 'l_margin', 'ColumnId') IS NULL )
		ALTER TABLE [dbo].[Insurance_Estimator_Item] ADD [l_margin] DECIMAL(9, 2) NULL;

	IF ( COLUMNPROPERTY(OBJECT_ID('Insurance_Estimator_Item'), 'm_margin', 'ColumnId') IS NULL )
		ALTER TABLE [dbo].[Insurance_Estimator_Item] ADD [m_margin] DECIMAL(9, 2) NULL;
	*/

	IF ( COLUMNPROPERTY(OBJECT_ID('Insurance_Estimator_Item'), 'l_margin', 'ColumnId') IS NOT NULL )
		ALTER TABLE [dbo].[Insurance_Estimator_Item] DROP COLUMN [l_margin]; -- replaced by [l_percent]

	IF ( COLUMNPROPERTY(OBJECT_ID('Insurance_Estimator_Item'), 'm_margin', 'ColumnId') IS NOT NULL )
		ALTER TABLE [dbo].[Insurance_Estimator_Item] DROP COLUMN [m_margin]; -- replaced by [m_percent]

	IF ( COLUMNPROPERTY(OBJECT_ID('Insurance_Estimator_Item'), 'l_percent', 'ColumnId') IS NULL )
		ALTER TABLE [dbo].[Insurance_Estimator_Item] ADD [l_percent] DECIMAL(9, 2) NULL;

	IF ( COLUMNPROPERTY(OBJECT_ID('Insurance_Estimator_Item'), 'm_percent', 'ColumnId') IS NULL )
		ALTER TABLE [dbo].[Insurance_Estimator_Item] ADD [m_percent] DECIMAL(9, 2) NULL;

	IF ( COLUMNPROPERTY(OBJECT_ID('Insurance_Estimator_Item'), 'l_percent_type', 'ColumnId') IS NULL )
		ALTER TABLE [dbo].[Insurance_Estimator_Item] ADD [l_percent_type] TINYINT NULL;
	ELSE
	BEGIN
		ALTER TABLE [dbo].[Insurance_Estimator_Item] DROP COLUMN [l_percent_type];
		ALTER TABLE [dbo].[Insurance_Estimator_Item] ADD [l_percent_type] TINYINT NULL;
	END;

	IF ( COLUMNPROPERTY(OBJECT_ID('Insurance_Estimator_Item'), 'm_percent_type', 'ColumnId') IS NULL )
		ALTER TABLE [dbo].[Insurance_Estimator_Item] ADD [m_percent_type] TINYINT NULL;
	ELSE
	BEGIN
		ALTER TABLE [dbo].[Insurance_Estimator_Item] DROP COLUMN [m_percent_type];
		ALTER TABLE [dbo].[Insurance_Estimator_Item] ADD [m_percent_type] TINYINT NULL;
	END;

	IF ( COLUMNPROPERTY(OBJECT_ID('Insurance_Estimator_Item'), 'l_total_with_margin', 'ColumnId') IS NULL )
		ALTER TABLE [dbo].[Insurance_Estimator_Item] ADD [l_total_with_margin] DECIMAL(9, 2) NULL;

	IF ( COLUMNPROPERTY(OBJECT_ID('Insurance_Estimator_Item'), 'm_total_with_margin', 'ColumnId') IS NULL )
		ALTER TABLE [dbo].[Insurance_Estimator_Item] ADD [m_total_with_margin] DECIMAL(9, 2) NULL;

	IF ( COLUMNPROPERTY(OBJECT_ID('Insurance_Estimator_Item'), 'total_with_margin', 'ColumnId') IS NULL )
		ALTER TABLE [dbo].[Insurance_Estimator_Item] ADD [total_with_margin] DECIMAL(9, 2) NULL;
 
	IF ( COLUMNPROPERTY(OBJECT_ID('Insurance_Estimator_Item'), 'Damage_Result_Of', 'ColumnId') IS NULL )
		ALTER TABLE [dbo].[Insurance_Estimator_Item] ADD [Damage_Result_Of] INT NULL;

	IF ( COLUMNPROPERTY(OBJECT_ID('Insurance_Estimator_Item'), 'Has_Structural_Damage', 'ColumnId') IS NULL )
		ALTER TABLE [dbo].[Insurance_Estimator_Item] ADD [Has_Structural_Damage] BIT NULL;

	IF ( COLUMNPROPERTY(OBJECT_ID('Insurance_Estimator_Item'), 'DamageText', 'ColumnId') IS NULL )
		ALTER TABLE [dbo].[Insurance_Estimator_Item] ADD [DamageText] VARCHAR(50) NULL;

	IF ( ISNULL(OBJECTPROPERTY(OBJECT_ID('DF_Insurance_Quote_Has_Structural_Damage'), 'IsConstraint') , 0) = 0 ) AND
	   ( ISNULL(OBJECTPROPERTY(OBJECT_ID('DF_Insurance_Quote_Has_Structural_Damage'), 'IsDefault') , 0) = 0 ) 
		ALTER TABLE [dbo].[Insurance_Estimator_Item] ADD CONSTRAINT [DF_Insurance_Quote_Has_Structural_Damage] DEFAULT (0) FOR [Has_Structural_Damage]; 

END;
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
	IF ( COLUMNPROPERTY(OBJECT_ID('Insurance_Quote'), 'SignedByClient', 'ColumnId') IS NULL )
		ALTER TABLE [dbo].[Insurance_Quote] ADD [SignedByClient] BIT NULL;
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

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Estimator_Entry_Import'), N'IsUserTable'), 0) = 1
	DROP TABLE [dbo].[Insurance_Estimator_Entry_Import];
GO

-- ================================================================================================
-- Author:		Paul Djimritsch
-- Create date: 11 April 2013
-- Description:	Provides temporary storage for imported insurance work order quote estimations.
-- ================================================================================================
CREATE TABLE [dbo].[Insurance_Estimator_Entry_Import]
(
	[room_category] VARCHAR(100),
	[width] DECIMAL(9, 2),
	[length] DECIMAL(9, 2),
	[height] DECIMAL(9, 2),
	[trade_name] VARCHAR(100),
	[is_extra_item] VARCHAR(3),
	[description] VARCHAR(2000),
	[l_qty] DECIMAL(9, 2),
	[l_measure] VARCHAR(100),
	[l_rate] DECIMAL(9, 2),
	[l_margin] DECIMAL(9, 2),
	[l_margin_type] VARCHAR(10),
	[m_qty] DECIMAL(9, 2),
	[m_measure] VARCHAR(100),
	[m_rate] DECIMAL(9, 2),
	[m_margin] DECIMAL(9, 2),
	[m_margin_type] varchar(10),
	[username] VARCHAR(50),
	[client_address] VARCHAR(32)
)
ON [PRIMARY];
GO

-- ================================================================================================
-- Author:		Andrei Baranovski
-- Create date: 18 April 2013
-- Description:	Insurance_Damage_Cause
-- ================================================================================================

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Damage_Cause'), N'IsUserTable'), 0) = 1
	DROP TABLE [dbo].[Insurance_Damage_Cause];
GO

CREATE TABLE dbo.Insurance_Damage_Cause
(
	ID INT NOT NULL IDENTITY (1, 1),
	Name VARCHAR(50) NULL,
	CONSTRAINT [PK_Insurance_Damage_Cause] PRIMARY KEY CLUSTERED (ID)
	WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)  ON [PRIMARY]
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Damage_Cause'), N'IsUserTable'), 0) = 1
BEGIN

	DECLARE @Transaction INT;

	SET @Transaction = @@TRANCOUNT;

	DECLARE @Error INT;

	IF ( @Transaction = 0 ) BEGIN TRANSACTION;

	IF NOT EXISTS(SELECT 1 FROM [dbo].[Insurance_Damage_Cause] WHERE [Name] = 'Storm')
		INSERT INTO [dbo].[Insurance_Damage_Cause] ( [Name] ) VALUES ( 'Storm' );

	IF NOT EXISTS(SELECT 1 FROM [dbo].[Insurance_Damage_Cause] WHERE [Name] = 'Flooding')
		INSERT INTO [dbo].[Insurance_Damage_Cause] ( [Name] ) VALUES ( 'Flooding' );

	IF NOT EXISTS(SELECT 1 FROM [dbo].[Insurance_Damage_Cause] WHERE [Name] = 'Water damage')
		INSERT INTO [dbo].[Insurance_Damage_Cause] ( [Name] ) VALUES ( 'Water damage' );

	IF NOT EXISTS(SELECT 1 FROM [dbo].[Insurance_Damage_Cause] WHERE [Name] = 'Wind')
		INSERT INTO [dbo].[Insurance_Damage_Cause] ( [Name] ) VALUES ( 'Wind' );

	IF NOT EXISTS(SELECT 1 FROM [dbo].[Insurance_Damage_Cause] WHERE [Name] = 'Fire')
		INSERT INTO [dbo].[Insurance_Damage_Cause] ( [Name] ) VALUES ( 'Fire' );

	IF NOT EXISTS(SELECT 1 FROM [dbo].[Insurance_Damage_Cause] WHERE [Name] = 'Malicious actions')
		INSERT INTO [dbo].[Insurance_Damage_Cause] ( [Name] ) VALUES ( 'Malicious actions' );

	IF NOT EXISTS(SELECT 1 FROM [dbo].[Insurance_Damage_Cause] WHERE [Name] = 'Impact')
		INSERT INTO [dbo].[Insurance_Damage_Cause] ( [Name] ) VALUES ( 'Impact' );

	IF NOT EXISTS(SELECT 1 FROM [dbo].[Insurance_Damage_Cause] WHERE [Name] = 'Hail')
		INSERT INTO [dbo].[Insurance_Damage_Cause] ( [Name] ) VALUES ( 'Hail' );

	SET @Error = @@ERROR;

	IF ( @Transaction = 0 )
	BEGIN

		IF ( @Error = 0 )
			COMMIT TRANSACTION;
		ELSE
			ROLLBACK TRANSACTION;

	END;

END;
GO

