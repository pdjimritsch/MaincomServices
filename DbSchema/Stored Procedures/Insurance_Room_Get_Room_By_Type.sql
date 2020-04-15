USE [visionary]; -- change if required
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Room_Get_Room_By_Type'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Room_Get_Room_By_Type];
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
-- Description:	Gets the room category from the data warehouse.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Room_Get_Room_by_Type] ( @Type VARCHAR(100) )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT [Insurance_Room_Id], [name] = LTRIM(RTRIM([name])) 
	FROM [dbo].[Insurance_Room]
	WHERE [name] = ISNULL(@Type, '');

	SET NOCOUNT OFF;

END;
GO