USE [visionary]; -- change if required
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'PersistentStore_Set'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[PersistentStore_Set];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 1 April 2013
-- Description:	Sets the session state settings within the data warehouse.
-- ============================================================================
CREATE PROCEDURE [dbo].[PersistentStore_Set]
(
	@Id NVARCHAR(128),
	@Key NVARCHAR(128),
	@Value NVARCHAR(MAX),
	@CreatedBy VARCHAR(128),
	@CreatedDate DATETIME
)
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SET @Id = LTRIM(RTRIM(ISNULL(@Id, N'')));

	SET @Key = LTRIM(RTRIM(ISNULL(@Key, N'')));

	IF ( LEN(@Id) = 0 ) OR ( LEN(@Key) = 0 ) RAISERROR(N'The session identity and / or the form tab identity has not been provided', 16, 1) WITH NOWAIT;

	SET @CreatedBy = LTRIM(RTRIM(ISNULL(@CreatedBy, N'')));

	IF ( LEN(@CreatedBy) = 0 ) RAISERROR(N'The session user identity has not been authenticated', 16, 1) WITH NOWAIT; 

	IF ( @CreatedDate IS NULL ) SET @CreatedDate = GETDATE();

	DECLARE @Error INT;

	SET @Error = @@ERROR;

	DECLARE @Transaction INT;

	SET @Transaction = @@TRANCOUNT;

	IF ( @Transaction = 0 ) BEGIN TRANSACTION;

	DECLARE @ErrNumber INT;

	BEGIN TRY

		IF EXISTS(SELECT 1 FROM [dbo].[PersistentStore] WHERE ( [Id] = @Id ) AND ( [Key] = @Key ) AND  ( [CreatedBy] = @CreatedBy ) )
		BEGIN

			UPDATE [dbo].[PersistentStore] WITH (READCOMMITTED) SET
						[Value] = @Value,
						[CreatedDate] = @CreatedDate
			WHERE ( [Id] = @Id ) AND ( [Key] = @Key ) AND ( [CreatedBy] = @CreatedBy );

		END
		ELSE
		BEGIN

			INSERT INTO [dbo].[PersistentStore]
			(
				[Id],
				[Key],
				[Value],
				[CreatedBy],
				[CreatedDate]
			)
			VALUES
			(
				@Id,
				@Key,
				@Value,
				@CreatedBy,
				@CreatedDate
			);

		END;

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