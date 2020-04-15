USE [visionary];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Estimator_Item_Delete'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Estimator_Item_Delete];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 26 April 2013
-- Description:	Deregisters the specified insurance quote estimation within the database schema.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Estimator_Item_Delete] ( @estimatorId INT, @validateEntry BIT = NULL )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET @estimatorId = ISNULL( @estimatorId, 0 );

	SET @validateEntry = ISNULL( @validateEntry, 0 );

	DECLARE @maxEstimatorId AS INT;

	SELECT @maxEstimatorId = MAX([Insurance_Estimator_Item_id]) FROM [dbo].[Insurance_Estimator_Item] WITH (READCOMMITTED);

	DECLARE @ErrMessage VARCHAR(2048);

	SET @ErrMessage = '';

	DECLARE @ErrNumber INT;

	SET @ErrNumber = @@ERROR;

	DECLARE @ErrSeverity INT;

	SET @ErrSeverity = 0;

	DECLARE @ErrStatus INT;

	SET @ErrStatus = 0;

	IF ( @validateEntry <> 0 )
	BEGIN

		IF NOT EXISTS(SELECT 1 FROM [dbo].[Insurance_Estimator_Item] WITH (READCOMMITTED) WHERE [Insurance_Estimator_Item_id] = @estimatorId)
		BEGIN

			SET @ErrMessage = 'The insurance work order quote estimation identity [ %d ] cannot be retrieved from the data warehouse.';

			RAISERROR( @ErrMessage, 16, 2, @estimatorId ) WITH NOWAIT;

		END;

	END;

	DECLARE @insuranceQuoteId AS INT;

	SELECT @insuranceQuoteId = [Insurance_Quote_id] FROM [dbo].[Insurance_Estimator_Item] WITH (READCOMMITTED)
	WHERE [Insurance_Estimator_Item_id] = @estimatorId;

	IF ( @insuranceQuoteId IS NULL )
	BEGIN

		SET @ErrMessage = 'The insurance work order quote identity cannot be located within the data warehouse.';

		RAISERROR( @ErrMessage, 16, 2 ) WITH NOWAIT;

	END;

	DECLARE @Transaction AS INT;

	SET @Transaction = @@TRANCOUNT;

	BEGIN TRY

		IF ( @Transaction = 0 ) BEGIN TRANSACTION;

		DELETE FROM [dbo].[Insurance_Estimator_Item] WHERE [Insurance_Estimator_Item_id] = @estimatorId;

		SET @ErrNumber = @@ERROR;

		IF ( @ErrNumber = 0 )
		BEGIN
			IF ( @Transaction = 0 ) COMMIT TRANSACTION;
		END
		ELSE
		BEGIN
			IF ( @Transaction = 0 ) ROLLBACK TRANSACTION;
		END;

		IF ( @estimatorId = @maxEstimatorId )
		BEGIN

			-- decrement the sequence table [MAX_ID] column value for the [Insurance_Estimator_Item] database table
			UPDATE [dbo].[SEQUENCE_TABLE] WITH (READCOMMITTED) SET [MAX_ID] = CAST( ( @maxEstimatorId - 1 ) AS INT ) WHERE ( [SEQUENCE_NAME] = 'Insurance_Estimator_Item' );

		END;

		IF ( @ErrNumber = 0 ) EXEC @ErrNumber = Insurance_Quote_Bulk_Insert_Update @insuranceQuoteId;

	END TRY
	BEGIN CATCH

		SET @ErrNumber = @@ERROR;

		SET @ErrMessage = ERROR_MESSAGE();

		SET @ErrSeverity = ERROR_SEVERITY();

		SET @ErrStatus = ERROR_STATE();

		IF ( @Transaction = 0 ) ROLLBACK TRANSACTION;

		RAISERROR ( @ErrMessage, @ErrSeverity,  @ErrStatus ) WITH NOWAIT;

	END CATCH

	RETURN @ErrNumber;

END;
GO
