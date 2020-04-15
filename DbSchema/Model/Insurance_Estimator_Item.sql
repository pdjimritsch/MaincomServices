USE [visionary]; -- CHANGE IF REQUIRED
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
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

	IF ( COLUMNPROPERTY(OBJECT_ID('Insurance_Estimator_Item'), 'MinimumCharge', 'ColumnId') IS NULL )
		ALTER TABLE [dbo].[Insurance_Estimator_Item] ADD [MinimumCharge] VARCHAR(255) NULL;

END;
GO