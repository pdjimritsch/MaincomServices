USE [visionary]; -- CHANGE IF REQUIRED
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
	[m_qty] DECIMAL(9, 2),
	[m_measure] VARCHAR(100),
	[m_rate] DECIMAL(9, 2),
	[m_margin] DECIMAL(9, 2),
	[username] VARCHAR(50),
	[client_address] VARCHAR(32)
)
ON [PRIMARY];
GO