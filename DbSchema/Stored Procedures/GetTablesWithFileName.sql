USE [visionary]; -- CHANGE IF REQUIRED
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'GetTablesWithFileName'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[GetTablesWithFileName];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 3 jUNE 2013
-- Description:	Retrieves the database schema tables that contain filename based columns
-- ============================================================================
CREATE PROCEDURE [dbo].[GetTablesWithFileName]
WITH EXECUTE AS CALLER
AS
BEGIN

	SELECT T1.[name] AS [Table Name], C1.[name] AS [Column Name] 
	FROM sys.tables T1 INNER JOIN sys.columns C1 on C1.[object_id] = T1.[object_id] AND ( C1.[name] LIKE '%filename%' OR  C1.[name] LIKE '%file_name%' )
	WHERE T1.[name] NOT IN ( 'article', 'bank_rec', 'BER_LOG', 'ber_questionnaire_document', 'EMPLOYEE', 'FileUploadStandard', 'Image_Tables', 'Insurance_Audit', 'Insurance_Correspondence', 'Insurance_Document_2', 'ORDER_LOG', 'PERSON', 'questionnaire', 'TASK_LOG')
	ORDER BY T1.[name];
END;
GO