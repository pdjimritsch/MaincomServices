USE [visionary]; -- change if required
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Work_Order_Status_Get'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Work_Order_Status_Get];
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
-- Description:	Gets the insurance unit entry that is associated with the identity key.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Work_Order_Status_Get]
WITH EXECUTE AS CALLER
AS 
BEGIN

	SET NOCOUNT ON;

	SELECT [id], [name] FROM [dbo].[Insurance_Work_Order_Status];

	SET NOCOUNT OFF;

END;
GO