USE [visionary]; -- change if required
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Room_Get_Rooms'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Room_Get_Rooms];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 4 February 2013
-- Description:	Gets the room categories from the data warehouse.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Room_Get_Rooms]
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT [Insurance_Room_Id], [name] = LTRIM(RTRIM([name])) FROM [dbo].[Insurance_Room] ORDER BY [name];

	SET NOCOUNT OFF;

END;
GO