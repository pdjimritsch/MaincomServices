USE [visionary];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Estimator_Item_Import'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Estimator_Item_Import];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 11 April 2013
-- Description:	Bulk inserts the comma separated value spreadsheet, residing on
--              the web server, into the data warehouse.
-- Assumption:  The production database server and the production web server resides
--              on the same Windows Server device.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Estimator_Item_Import] ( @resource VARCHAR(2048), @formatfile VARCHAR(2048), @errorfile VARCHAR(2048), @username VARCHAR(50), @clientAddress VARCHAR(32), @firstrow INT = 2, @maxerrors INT = 20 )
WITH EXECUTE AS CALLER
AS
BEGIN

	DECLARE @retval INT;

	SET @retval = 1; -- error indication

	IF ( LEN(@resource) = 0 ) OR ( LEN(@formatfile) = 0 ) 
		RAISERROR( 'The text based resource and the format file must be specified', 16, 2 ) WITH NOWAIT;

	SET @resource = LTRIM(RTRIM(ISNULL(@resource, '')));

	IF ( CHARINDEX( '\\', @resource, 1 ) > 0 )
		SET @resource = REPLACE( @resource, '\\', '\' );

	IF ( CHARINDEX( '"', @resource, 1) > 0 )
		SET @resource = REPLACE( @resource, '"', '');

	SET @formatfile = LTRIM(RTRIM(ISNULL(@formatfile, '')));

	IF ( CHARINDEX( '\\', @formatfile, 1 ) > 0 )
		SET @formatfile = REPLACE( @formatfile, '\\', '\' );

	IF ( CHARINDEX( '"', @formatfile, 1) > 0 )
		SET @formatfile = REPLACE( @formatfile, '"', '');

	SET @errorfile = LTRIM(RTRIM(ISNULL(@errorfile, '')));

	SET @username = LTRIM(RTRIM(ISNULL(@username, '')));

	SET @clientAddress = LTRIM(RTRIM(ISNULL(@clientAddress, '')));

	DECLARE @sqlCommand VARCHAR(MAX);

	SET @sqlCommand = 'INSERT INTO [dbo].[Insurance_Estimator_Entry_Import] ( [room_category], [width], [length], [height], [trade_name], [is_extra_item], ';

	SET @sqlCommand = @sqlCommand + '[description], [l_qty], [l_measure], [l_rate], [l_margin], [m_qty], [m_measure], [m_rate], [m_margin], ';

	SET @sqlCommand = @sqlCommand + '[username], [client_address] ) ';

	SET @sqlCommand = @sqlCommand + 'SELECT  ISNULL(REPLACE(T.[room_category], ''"'', ''''), '''') AS [room_category], ISNULL(T.[width], 0) AS [width], ';

	SET @sqlCommand = @sqlCommand + 'ISNULL(T.[length], 0) AS [length], ISNULL(T.[height], 0) AS [height], LTRIM(RTRIM(ISNULL(T.[trade_name], ''''))) AS [trade_name], ';
	
	SET @sqlCommand = @sqlCommand + 'ISNULL(T.[is_extra_item], 0) AS [is_extra_item], LTRIM(RTRIM(ISNULL(T.[description] , ''''))) AS [description], ';

	SET @sqlCommand = @sqlCommand + 'ISNULL(T.[l_qty], 0) AS [l_qty], LTRIM(RTRIM(ISNULL(T.[l_measure], ''''))) AS [l_measure], ISNULL(T.[l_rate], 0) AS [l_rate], ';

	SET @sqlCommand = @sqlCommand + 'ISNULL(T.[l_margin], 0) AS [l_margin], ISNULL(T.[m_qty], 0) AS [m_qty], LTRIM(RTRIM(ISNULL(T.[m_measure], ''''))) AS [m_measure], ';

	SET @sqlCommand = @sqlCommand + 'ISNULL(T.[m_rate], 0) AS [m_rate], ISNULL(T.[m_margin], 0) AS [m_margin], ';

	SET @sqlCommand = @sqlCommand + '''' + @username + ''' AS [username], ''' + @clientAddress + ''' AS [client_address] ';

	SET @sqlCommand = @sqlCommand + 'FROM OPENROWSET( BULK ''' + @resource + ''', FORMATFILE = ''' + REPLACE(@formatfile, '"', '') + ''', ';
	
	SET @sqlCommand = @sqlCommand + 'FIRSTROW = ' + LTRIM(RTRIM(CAST(@firstrow AS VARCHAR(8)))) + ', ';

	IF ( LEN(@errorfile) > 0 ) SET @sqlCommand = @sqlCommand + 'ERRORFILE = ''' + @errorfile + ''', ';
	
	SET @sqlCommand = @sqlCommand + 'MAXERRORS = ' + LTRIM(RTRIM(CAST(@maxerrors AS VARCHAR(8)))) + ' ) ';

	SET @sqlCommand = @sqlCommand + 'AS T( [room_category], [width], [length], [height], [trade_name], [is_extra_item], [description], [l_qty], [l_measure], [l_rate], [l_margin], ';

	SET @sqlCommand = @sqlCommand + '[m_qty], [m_measure], [m_rate], [m_margin] );';

	BEGIN TRY

		EXEC ( @sqlCommand );

		SET @retval = @@ERROR;

	END TRY
	BEGIN CATCH

		SET @retval = @@ERROR;

		DECLARE @ErrMessage VARCHAR(2048);

		SET @ErrMessage = ERROR_MESSAGE();

		DECLARE @ErrSeverity INT;

		SET @ErrSeverity = ERROR_SEVERITY();

		DECLARE @ErrStatus INT;

		SET @ErrStatus = ERROR_STATE();

		RAISERROR ( @ErrMessage, @ErrSeverity,  @ErrStatus ) WITH NOWAIT;

	END CATCH

	RETURN @retval;

END;
GO
