USE [visionary];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Quote_Bulk_Insert_Update'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Quote_Bulk_Insert_Update];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 11 April 2013
-- Description:	Updates the estimated costs, sales, and profits for a non-cancelled
--              insurance work order quote.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Quote_Bulk_Insert_Update] ( @insurancequoteId INT )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	IF (( @insurancequoteid IS NULL) OR ( @insurancequoteid < 0 ))
		RETURN -1;

	IF EXISTS(SELECT 1 FROM [dbo].[Insurance_Quote] WHERE ( [Insurance_Quote_id] = @insurancequoteid ) AND ( [status] IS NOT NULL ) AND ( [status] = 5 /* 5 = Cancelled quote status */ ))
		RETURN -1;

	DECLARE cvReader CURSOR FAST_FORWARD FOR 
		SELECT [l_total], [m_total], [l_percent], [m_percent], [total], [total_with_margin]
		FROM [dbo].[Insurance_Estimator_Item] 
		WHERE [Insurance_Quote_id] = @insurancequoteid;

	DECLARE @labourTotal AS DECIMAL(9, 2);

	DECLARE @InterimLabourTotal AS DECIMAL(9, 2);

	SET @InterimLabourTotal = CAST(0 AS DECIMAL(9, 2));

	DECLARE @materialTotal AS DECIMAL(9, 2);

	DECLARE @InterimMaterialTotal AS DECIMAL(9, 2);

	SET @InterimMaterialTotal = CAST(0 AS DECIMAL(9, 2));

	DECLARE @labourMargin AS DECIMAL(9, 2);

	DECLARE @InterimLabourMargin AS DECIMAL(9, 2);

	SET @InterimLabourMargin = CAST(0 AS DECIMAL(9, 2));

	DECLARE @materialMargin AS DECIMAL(9, 2);

	DECLARE @InterimMaterialMargin AS DECIMAL(9, 2);

	SET @InterimMaterialMargin = CAST(0 AS DECIMAL(9, 2));

	DECLARE @Total AS DECIMAL(9, 2);

	DECLARE @InterimTotal AS DECIMAL(9, 2);

	SET @InterimTotal = CAST(0 AS DECIMAL(9,2));

	DECLARE @MarginTotal AS DECIMAL(9, 2);

	DECLARE @InterimMarginTotal AS DECIMAL(9, 2);

	SET @InterimMarginTotal = CAST(0 AS DECIMAL(9,2));

	DECLARE @RowCount INT;

	SET @RowCount = 0;

	DECLARE @ErrMessage AS VARCHAR(2048);

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

		FETCH NEXT FROM cvReader INTO @labourTotal, @materialTotal, @labourMargin, @materialMargin, @Total, @MarginTotal;

		WHILE ( @@FETCH_STATUS = 0 )
		BEGIN

			SET @InterimLabourTotal = @InterimLabourTotal + ISNULL(@labourTotal, CAST(0 AS DECIMAL(9, 2)));

			SET @InterimMaterialTotal = @InterimMaterialTotal + ISNULL(@materialTotal, CAST(0 AS DECIMAL(9, 2)));

			SET @InterimLabourMargin = @InterimLabourMargin + ISNULL(@labourMargin, CAST(0 AS DECIMAL(9, 2)));

			SET @InterimMaterialMargin = @InterimMaterialMargin + ISNULL(@materialMargin, CAST(0 AS DECIMAL(9, 2)));

			SET @InterimTotal = @InterimTotal + ISNULL(@Total, CAST(0 AS DECIMAL(9, 2)));

			SET @InterimMarginTotal = @InterimMarginTotal + ISNULL(@MarginTotal, CAST(0 AS DECIMAL(9, 2)));

			SET @RowCount = @RowCount + 1;

			FETCH NEXT FROM cvReader INTO @labourTotal, @materialTotal, @labourMargin, @materialMargin, @Total, @MarginTotal;

		END;

		CLOSE cvReader;

		DEALLOCATE cvReader;

		IF ( @RowCount > 0 )
		BEGIN

			IF ( @Transaction = 0 ) BEGIN TRANSACTION;

			IF ( @InterimMarginTotal <> CAST(0 AS DECIMAL(9, 2)) )
			BEGIN

				UPDATE [dbo].[Insurance_Quote] WITH (ROWLOCK) SET
					[labour_total] = CAST(@InterimLabourTotal AS DECIMAL(9, 2)),
					[material_total] = CAST(@InterimMaterialTotal AS DECIMAL(9, 2)),
					[est_labour_markup] = CAST((@InterimLabourMargin / @RowCount) AS DECIMAL(9, 2)), /* Average of labour margin [l_percent] column */
					[est_material_markup] = CAST((@InterimMaterialMargin / @RowCount) AS DECIMAL(9, 2)), /* Average of material margin [m_percent] column */
					[est_job_cost] = CAST(@InterimTotal AS DECIMAL(9, 2)), /* Sum of Insurance Estimator Item [total] column */
					[est_room_cost] = CAST(@InterimTotal AS DECIMAL(9, 2)), /* Sum of Insurance Estimator Item [total] column */
					[est_job_sale_price] = CAST(@InterimMarginTotal AS DECIMAL(9, 2)), /* Sum of Insurance Estimator Item [total_with_margin] column */
					[est_room_sale_price] =  CAST(@InterimMarginTotal AS DECIMAL(9, 2)), /* Sum of Insurance Estimator Item [total_with_margin] column */
					[est_job_profit] = CAST((@InterimMarginTotal - @InterimTotal) AS DECIMAL(9, 2)),
					[est_room_profit] = CAST((@InterimMarginTotal - @InterimTotal) AS DECIMAL(9, 2)),
					[profit_percentage] = CAST((CAST((@InterimMarginTotal - @InterimTotal) AS DECIMAL(9, 2)) * CAST(100 AS DECIMAL(9, 2)) /  @InterimMarginTotal) AS DECIMAL(9, 2))
				WHERE ( [Insurance_Quote_id] = @insurancequoteid );

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