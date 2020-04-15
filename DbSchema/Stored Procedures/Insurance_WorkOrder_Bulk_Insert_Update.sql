USE [visionary];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_WorkOrder_Bulk_Insert_Update'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_WorkOrder_Bulk_Insert_Update];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 11 April 2013
-- Description:	Updates the estimated costs, sales, and profits from the collection
--              of registered insurance work order quotes. The details are extracted
--              from insurance work order quotes that are not cancelled
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_WorkOrder_Bulk_Insert_Update] ( @insurancequoteId INT )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	IF (( @insurancequoteid IS NULL) OR ( @insurancequoteid < 0 ))
		RETURN -1;

	IF NOT EXISTS(SELECT 1 FROM [dbo].[Insurance_WorkOrder] WHERE [ORDER_ID] IN (SELECT [Order_id] FROM [dbo].[Insurance_Quote] WHERE [Insurance_Quote_id] = @insurancequoteid))
		RETURN -1;

	-- OBTAINS THE ENTIRE COLLECTION OF INSURANCE WORK ORDER QUOTES FOR A SPECIFIC INSURANCE WORK ORDER IDENTITY.
	DECLARE cvReader CURSOR FAST_FORWARD FOR 
		SELECT [est_job_cost], [est_job_sale_price], [status], [negative_quote_id]
		FROM [dbo].[Insurance_Quote] 
		WHERE [Order_id] IN ( SELECT [Order_id] FROM [dbo].[Insurance_Quote] WHERE [Insurance_Quote_id] = @insurancequoteid );

	DECLARE @JobCostEstimate AS DECIMAL(9, 2);

	DECLARE @InterimJobCostEstimate AS DECIMAL(9, 2);

	SET @InterimJobCostEstimate = CAST(0 AS DECIMAL(9, 2));

	DECLARE @JobSalePriceEstimate AS DECIMAL(9, 2);

	DECLARE @InterimJobSalePriceEstimate AS DECIMAL(9, 2);

	SET @InterimJobSalePriceEstimate = CAST(0 AS DECIMAL(9, 2));

	DECLARE @QuoteStatus AS INT;

	DECLARE @NegativeQuoteId AS INT;

	DECLARE @RowCount AS INT;

	SET @RowCount = 0;

	DECLARE @ErrMessage VARCHAR(2048);

	SET @ErrMessage = '';

	DECLARE @ErrNumber INT;

	SET @ErrNumber = @@ERROR;

	DECLARE @ErrSeverity INT;

	SET @ErrSeverity = 0;

	DECLARE @ErrStatus INT;

	SET @ErrStatus = 0;

	DECLARE @Transaction AS INT;

	SET @Transaction = @@TRANCOUNT;

	BEGIN TRY

		OPEN cvReader;

		FETCH NEXT FROM cvReader INTO @JobCostEstimate, @JobSalePriceEstimate, @QuoteStatus, @NegativeQuoteId;

		WHILE ( @@FETCH_STATUS = 0 )
		BEGIN

			IF ( @QuoteStatus IS NOT NULL ) AND ( ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_QuoteStatus'), N'IsUserTable'), 0) = 1 )
			BEGIN

				DECLARE @StatusName VARCHAR(50);

				SELECT @StatusName = [name] FROM [dbo].[Insurance_QuoteStatus] WHERE [id] = @QuoteStatus;

				IF ( @StatusName IS NOT NULL ) AND ( CHARINDEX( 'Cancelled', @StatusName, 1 ) > 0 )
				BEGIN

					FETCH NEXT FROM cvReader INTO @JobCostEstimate, @JobSalePriceEstimate, @QuoteStatus, @NegativeQuoteId;

					CONTINUE;

				END;

			END;

			IF ( @NegativeQuoteId IS NULL ) OR (( @NegativeQuoteId IS NOT NULL ) AND ( @NegativeQuoteId <= 0 ))
			BEGIN
				SET @InterimJobCostEstimate = @InterimJobCostEstimate + ISNULL(@JobCostEstimate, CAST(0 AS DECIMAL(9, 2)));
				SET @InterimJobSalePriceEstimate = @InterimJobSalePriceEstimate + ISNULL(@JobSalePriceEstimate, CAST(0 AS DECIMAL(9, 2)));
			END
			ELSE
			BEGIN
				SET @InterimJobCostEstimate = @InterimJobCostEstimate - ISNULL(@JobCostEstimate, CAST(0 AS DECIMAL(9, 2)));
				SET @InterimJobSalePriceEstimate = @InterimJobSalePriceEstimate - ISNULL(@JobSalePriceEstimate, CAST(0 AS DECIMAL(9, 2)));
			END;

			SET @RowCount = @RowCount + 1;

			FETCH NEXT FROM cvReader INTO @JobCostEstimate, @JobSalePriceEstimate, @QuoteStatus, @NegativeQuoteId;

		END;

		CLOSE cvReader;

		DEALLOCATE cvReader;

		IF ( @RowCount > 0 )
		BEGIN

			IF ( @Transaction = 0 ) BEGIN TRANSACTION;

			IF ( @InterimJobSalePriceEstimate <> CAST(0 AS DECIMAL(9, 2)))
			BEGIN

				UPDATE [dbo].[Insurance_WorkOrder] WITH (ROWLOCK) SET
					[est_cost] = CAST(@InterimJobCostEstimate AS DECIMAL(9, 2)),
					[est_sale] = CAST(@InterimJobSalePriceEstimate AS DECIMAL(9, 2)),
					[est_profit] = CAST((@InterimJobSalePriceEstimate - @InterimJobCostEstimate) AS DECIMAL(9, 2)),
					[est_profit_percent] = CAST((100 - (( CAST(@InterimJobCostEstimate AS DECIMAL(9, 2)) * CAST(100 AS DECIMAL(9, 2))) / CAST(@InterimJobSalePriceEstimate AS DECIMAL(9, 2)))) AS DECIMAL(9, 2))
				WHERE [ORDER_ID] IN ( SELECT [Order_id] FROM [dbo].[Insurance_Quote] WHERE [Insurance_Quote_id] = @insurancequoteid );

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

		END
		ELSE
			SET @ErrNumber = -1;

	END TRY
	BEGIN CATCH 

		SET @ErrNumber = @@ERROR;

		SET @ErrMessage = ERROR_MESSAGE();

		SET @ErrSeverity = ERROR_SEVERITY();

		SET @ErrStatus = ERROR_STATE();

		IF ( @Transaction = 0 ) ROLLBACK TRANSACTION;

		RAISERROR ( @ErrMessage, @ErrSeverity,  @ErrStatus ) WITH NOWAIT;

	END CATCH;

	SET NOCOUNT OFF;

	RETURN @ErrNumber;

END;
GO