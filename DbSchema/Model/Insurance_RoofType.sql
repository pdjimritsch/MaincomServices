USE [visionary]; -- CHANGE IF REQUIRED
GO

IF ( ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_RoofType'), N'IsUserTable'), 0) = 1 )
BEGIN

	DECLARE @id INT;

	-- The [id] column is a primary key whose value is not auto-generated. The column is not designed as a identity column.

	IF NOT EXISTS(SELECT 1 FROM [dbo].[Insurance_RoofType] WHERE UPPER(LTRIM(RTRIM(ISNULL([name], '')))) = 'SLATE')
	BEGIN
		SELECT @id = MAX([id]) + 1 FROM [dbo].[Insurance_RoofType];
		INSERT INTO [dbo].[Insurance_RoofType] ( [id], [name] ) VALUES ( @id, 'Slate' );
	END;

	IF NOT EXISTS(SELECT 1 FROM [dbo].[Insurance_RoofType] WHERE UPPER(LTRIM(RTRIM(ISNULL([name], '')))) = 'SHINGLE')
	BEGIN
		SELECT @id = MAX([id]) + 1 FROM [dbo].[Insurance_RoofType];
		INSERT INTO [dbo].[Insurance_RoofType] ( [id], [name] ) VALUES ( @id, 'Shingle' );
	END;

END;
GO