USE [visionary]; -- change if required
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'PersistentStore_Clear'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[PersistentStore_Clear];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 1 April 2013
-- Description:	Sets the session state settings within the data warehouse.
-- ============================================================================
CREATE PROCEDURE [dbo].[PersistentStore_Clear]
(
	@Id NVARCHAR(128)
)
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SET @Id = LTRIM(RTRIM(ISNULL(@Id, N'')));

	IF ( LEN(@Id) = 0 )
		RAISERROR(N'The session identity was not provided.', 16, 1) WITH NOWAIT;

	DECLARE @Error INT;

	SET @Error = @@ERROR;

	DECLARE @Transaction INT;

	SET @Transaction = @@TRANCOUNT;

	IF ( @Transaction = 0 ) BEGIN TRANSACTION;

	DECLARE @ErrNumber INT;

	BEGIN TRY

		IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'PersistentStore'), N'IsUserTable'), 0) = 1
			DELETE FROM [dbo].[PersistentStore] WHERE [Id] = @Id;

		SET @Error = @@ERROR;

		IF ( @Error = 0 )
		BEGIN
			IF ( @Transaction = 0 ) COMMIT TRANSACTION;
		END
		ELSE
		BEGIN
			IF ( @Transaction = 0 ) ROLLBACK TRANSACTION;
		END;

	END TRY
	BEGIN CATCH 

		DECLARE @ErrMessage VARCHAR(2048);

		SET @ErrMessage = ERROR_MESSAGE();

		DECLARE @ErrSeverity INT;

		SET @ErrSeverity = ERROR_SEVERITY();

		DECLARE @ErrStatus INT;

		SET @ErrStatus = ERROR_STATE();

		IF ( @Transaction = 0 ) ROLLBACK TRANSACTION;

		RAISERROR ( @ErrMessage, @ErrSeverity,  @ErrStatus ) WITH NOWAIT;

	END CATCH;

	SET NOCOUNT OFF;

END;
GO