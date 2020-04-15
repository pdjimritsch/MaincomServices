USE [visionary]; -- change the database name if required
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'ByteShift'), N'IsScalarFunction'), 0) = 1
	DROP FUNCTION [dbo].[ByteShift];
GO

CREATE FUNCTION [dbo].[ByteShift] ( @val BIT )
RETURNS SMALLINT
AS
BEGIN

	DECLARE @retval SMALLINT;

	SET @retval = CAST(POWER(2, 8) AS SMALLINT) + ISNULL(@val, 0);

	RETURN @retval;

END;
GO