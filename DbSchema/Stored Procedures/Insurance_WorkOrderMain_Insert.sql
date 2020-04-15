USE [visionary]; -- change if required
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_WorkOrderMain_Insert'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_WorkOrderMain_Insert];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 23 October 2013
-- Description:	Creates a new work order main entry within the data warehouse.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_WorkOrderMain_Insert] ( @EntityId INT, @OrderId INT, @CreatedBy VARCHAR(20), @CreatedOn DATETIME, @Id INT OUTPUT )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SET @Id = -1;

	-- Validation

	IF NOT EXISTS(SELECT 1 FROM [dbo].[BUSINESS_ENTITY] WITH (READCOMMITTED) WHERE [BE_ID] = ISNULL(@EntityId, -1)) 
	BEGIN

		SET NOCOUNT OFF;

		RAISERROR( 'The identity for the business entity was not provided', 16, 1) WITH NOWAIT;

	END;

	IF NOT EXISTS(SELECT 1 FROM [dbo].[Insurance_WorkOrder] WITH (READCOMMITTED) WHERE [ORDER_ID] = ISNULL(@OrderId, -1)) 
	BEGIN

		SET NOCOUNT OFF;
	
		RAISERROR( 'The identity for the insurance work order was not provided', 16, 1) WITH NOWAIT;

	END;

	-- Processing

	DECLARE @ErrMessage VARCHAR(2048);

	SET @ErrMessage = '';

	DECLARE @ErrNumber INT;

	SET @ErrNumber = @@ERROR;

	DECLARE @ErrSeverity INT;

	SET @ErrSeverity = 0;

	DECLARE @ErrStatus INT;

	SET @ErrStatus = 0;

	DECLARE @Transaction INT;

	SET @Transaction = @@TRANCOUNT;

	DECLARE @LocalIndicator BIT;

	SET @LocalIndicator = 0;

	DECLARE @LocalId INT;

	SET @LocalId = 0;

	BEGIN TRY

		IF ( @Transaction = 0 ) BEGIN TRANSACTION;

		IF ( ISNULL(COLUMNPROPERTY(OBJECT_ID(N'Insurance_WorkOrderMain'), N'Insurance_WorkOrderMain_Id', N'IsIdentity'), 0) = 1 )
		BEGIN

			INSERT INTO [dbo].[Insurance_WorkOrderMain]
			(
				[Order_id],
				[be_id],
				[status_id],
				[created_by],
				[create_date]
			)
			VALUES
			(
				@OrderId,
				@EntityId,
				200, -- Assigned status
				@CreatedBy,
				@CreatedOn
			);

			SET @ErrNumber = @@ERROR;

			SET @LocalId = SCOPE_IDENTITY();

		END
		ELSE
		BEGIN

			-- Fetch the next identity value for the work order main table.

			EXEC [getNextID] 'Insurance_WorkOrderMain', @LocalId OUTPUT, @ErrMessage OUTPUT, @ErrNumber OUTPUT;

			SET @LocalIndicator = 1;

			IF ( @ErrNumber = 0 ) AND ( @LocalId > 0 )
			BEGIN

				INSERT INTO [dbo].[Insurance_WorkOrderMain]
				(
					[Insurance_WorkOrderMain_Id],
					[Order_id],
					[be_id],
					[status_id],
					[created_by],
					[create_date]
				)
				VALUES
				(
					@Id,
					@OrderId,
					@EntityId,
					200, -- Assigned status
					@CreatedBy,
					@CreatedOn
				);

				SET @ErrNumber = @@ERROR;

			END
			ELSE
			BEGIN

				-- the retrieval process for the work order main table identity has suffered a issue.

				IF ( @LocalId > (SELECT MAX([Insurance_WorkOrderMain_Id]) FROM [dbo].[Insurance_WorkOrderMain]) )
				BEGIN

					UPDATE [dbo].[SEQUENCE_TABLE] WITH (READCOMMITTED) SET [MAX_ID] = (SELECT MAX([Insurance_WorkOrderMain_Id]) FROM [dbo].[Insurance_WorkOrderMain]) WHERE [SEQUENCE_NAME] = 'Insurance_WorkOrderMain';

					SET @LocalIndicator = 0;

				END;

			END;

		END;

		IF ( @ErrNumber = 0 )
		BEGIN

			IF ( @Transaction = 0 ) COMMIT TRANSACTION;

			SET @Id = @LocalId;

		END
		ELSE
		BEGIN

			IF ( @Transaction = 0 ) ROLLBACK TRANSACTION;

			SET @Id = -1;

			IF ( @LocalIndicator = 1 ) AND ( ISNULL(COLUMNPROPERTY(OBJECT_ID(N'Insurance_WorkOrderMain'), N'Insurance_WorkOrderMain_Id', N'IsIdentity'), 0) = 0 )
			BEGIN

				UPDATE [dbo].[SEQUENCE_TABLE] WITH (READCOMMITTED) SET [MAX_ID] = (SELECT MAX([Insurance_WorkOrderMain_Id]) FROM [dbo].[Insurance_WorkOrderMain]) WHERE [SEQUENCE_NAME] = 'Insurance_WorkOrderMain';

				SET @LocalIndicator = 0;

			END;

		END;

	END TRY
	BEGIN CATCH

		SET @ErrMessage = ERROR_MESSAGE();

		SET @ErrSeverity = ERROR_SEVERITY();

		SET @ErrStatus = ERROR_STATE();

		IF ( @Transaction = 0 ) ROLLBACK TRANSACTION;

		IF ( @LocalIndicator = 1 ) AND ( ISNULL(COLUMNPROPERTY(OBJECT_ID(N'Insurance_WorkOrderMain'), N'Insurance_WorkOrderMain_Id', N'IsIdentity'), 0) = 0 )
		BEGIN

			UPDATE [dbo].[SEQUENCE_TABLE] WITH (READCOMMITTED) SET [MAX_ID] = (SELECT MAX([Insurance_WorkOrderMain_Id]) FROM [dbo].[Insurance_WorkOrderMain]) WHERE [SEQUENCE_NAME] = 'Insurance_WorkOrderMain';

			SET @LocalIndicator = 0;

		END;

		SET @Id = -1;

		RAISERROR ( @ErrMessage, @ErrSeverity,  @ErrStatus ) WITH NOWAIT;

	END CATCH;

	SET NOCOUNT OFF;

	RETURN @ErrNumber;

END;
GO
