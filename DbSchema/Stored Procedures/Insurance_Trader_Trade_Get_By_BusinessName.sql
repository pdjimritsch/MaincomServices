USE [visionary]; -- change if required
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Trader_Trade_Get_By_BusinessName'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Trader_Trade_Get_By_BusinessName];
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
CREATE PROCEDURE [dbo].[Insurance_Trader_Trade_Get_By_BusinessName] ( @BusinessName VARCHAR(254) )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT IT.[Insurance_Trader_Trade_Id], IT.[Insurance_Trade_id], IT.[BE_Id] 
	FROM [dbo].[Insurance_Trader_Trade] IT 
	LEFT JOIN [dbo].[BUSINESS_ENTITY] BE ON ( BE.[BE_ID] = IT.[BE_Id] ) AND ( BE.[BE_NAME] = ISNULL(@BusinessName, '') );

	SET NOCOUNT OFF;

END;
GO