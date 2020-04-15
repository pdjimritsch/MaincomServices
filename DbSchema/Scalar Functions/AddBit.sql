USE [visionary]; -- change the database name if required
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'AddBit'), N'IsScalarFunction'), 0) = 1
	DROP FUNCTION [dbo].[AddBit];
GO

CREATE FUNCTION [dbo].[AddBit] ( @lval BIT, @rval BIT )
RETURNS BIGINT
AS
BEGIN

	DECLARE @retval BIGINT;

	SET @retval = CAST(ISNULL(@lval, 0) AS BIGINT) + CAST(ISNULL(@rval, 0) AS BIGINT);

	RETURN @retval;

END;
GO