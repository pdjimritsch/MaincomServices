USE [visionary];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Quote_Delete'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Quote_Delete];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 7 March 2013
-- Description:	Deregisters the specific insurance quote from the data warehouse.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Quote_Delete] ( @insuranceQuoteId INT, @validateEntry BIT = NULL )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET @insuranceQuoteId = ISNULL( @insuranceQuoteId, 0 );

	SET @validateEntry = ISNULL( @validateEntry, 0 );

	DECLARE @maxInsuranceQuoteId AS INT;

	SELECT @maxInsuranceQuoteId = MAX([Insurance_Quote_id]) FROM [dbo].[Insurance_Quote];

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

		IF NOT EXISTS(SELECT 1 FROM [dbo].[Insurance_Quote] WITH (READCOMMITTED) WHERE [Insurance_Quote_id] = @insuranceQuoteId)
		BEGIN

			SET @ErrMessage = 'The insurance work order quote identity [ %d ] cannot be retrieved from the data warehouse.';

			RAISERROR( @ErrMessage, 16, 2, @insuranceQuoteId ) WITH NOWAIT;

		END;

	END;

	DECLARE @Transaction AS INT;

	SET @Transaction = @@TRANCOUNT;

	BEGIN TRY

		IF ( @Transaction = 0 ) BEGIN TRANSACTION;

		DELETE FROM [dbo].[Insurance_Quote] WHERE [Insurance_Quote_id] = @insuranceQuoteId;

		IF ( @insuranceQuoteId = @maxInsuranceQuoteId )
		BEGIN

			-- decrement the sequence table [MAX_ID] column value for the [Insurance_Quote] database table
			UPDATE [dbo].[SEQUENCE_TABLE] WITH (READCOMMITTED) SET [MAX_ID] = CAST( ( @maxInsuranceQuoteId - 1 ) AS INT ) WHERE ( [SEQUENCE_NAME] = 'Insurance_Quote' );

		END;

		SET @ErrNumber = @@ERROR;

		IF ( @ErrNumber = 0 )
		BEGIN
			IF ( @Transaction = 0 ) COMMIT TRANSACTION;
		END
		ELSE
		BEGIN
			IF ( @Transaction = 0 ) ROLLBACK TRANSACTION;
		END;

		--IF ( @ErrNumber = 0 ) EXEC @ErrNumber = [Insurance_WorkOrder_Bulk_Insert_Update] @insuranceQuoteId;

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