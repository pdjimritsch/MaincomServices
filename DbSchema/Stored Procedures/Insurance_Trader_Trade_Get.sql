USE [visionary]; -- change if required
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Trader_Trade_Get'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Trader_Trade_Get];
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
-- Description:	Gets the insurance traders from the data warehouse.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Trader_Trade_Get]
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT [Insurance_Trader_Trade_Id], [Insurance_Trade_id], [BE_Id] FROM [dbo].[Insurance_Trader_Trade];

	SET NOCOUNT OFF;

END;
GO