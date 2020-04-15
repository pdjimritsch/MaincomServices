USE [visionary];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Estimator_Item_Bulk_Insert'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Estimator_Item_Bulk_Insert];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 11 April 2013
-- Description:	Bulk inserts the comma separated value spreadsheet, residing on
--              the web server, into the data warehouse.
-- Assumption:  The production database server and the production web server resides
--              on the same Windows Server device.
--
-- History:     
--              Paul Djimritsch. Aemnded on 26 April 2012
--              The applied update for the corresponding insurance work order has
--              removed as approved by the Maincom Manager.
--               
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Estimator_Item_Bulk_Insert] 
( 
	@insurancequoteId INT, 
	@resource VARCHAR(2048), 
	@formatfile VARCHAR(2048), 
	@username VARCHAR(50), 
	@clientAddress VARCHAR(32), 
	@separator VARCHAR(32) = '', 
	@replacement VARCHAR(32) = '', 
	@errorfile VARCHAR(2048) = '', 
	@firstrow INT = 2, 
	@maxerrors INT = 20, 
	@retval INT OUTPUT 
)
WITH EXECUTE AS CALLER
AS
BEGIN

	SET @retval = @@ERROR;

	IF ( @insurancequoteId IS NULL ) OR ( @insurancequoteId < 1 )
		RAISERROR( 'The insurance work order quote identity was not provided.', 16, 2 ) WITH NOWAIT;
	ELSE IF NOT EXISTS(SELECT 1 FROM [dbo].[Insurance_Quote] WHERE [Insurance_Quote_id] = @insurancequoteId)
		RAISERROR( 'The provided insurance work order quote identity [ %d ] does not appear to be registered within the data warehouse', 16, 2, @insurancequoteId ) WITH NOWAIT;

	SET @username = LTRIM(RTRIM(ISNULL(@username, '')));

	SET @clientAddress = LTRIM(RTRIM(ISNULL(@clientAddress, '')));

	SET @separator = ISNULL(@separator, '');

	SET @replacement = ISNULL(@replacement, '');
	
	-- BULK INSERT INTO [dbo].[Insurance_Estimator_Entry_Import]
	EXEC @retval = [dbo].[Insurance_Estimator_Item_Import] @resource, @formatfile, @errorfile, @username, @clientAddress, @firstrow, @maxerrors;

	IF NOT ( @retval = 0 ) 
		RAISERROR( 'The insurance work order quote estimation import failed. Error = %d', 16, 2, @retval ) WITH NOWAIT;

	DECLARE @roomCategory AS VARCHAR(100);

	DECLARE @roomId AS INT;

	DECLARE @width AS DECIMAL(9, 2);

	DECLARE @length AS DECIMAL(9, 2);

	DECLARE @height AS DECIMAL(9, 2);

	DECLARE @tradename AS VARCHAR(100);

	DECLARE @tradeId AS INT;

	DECLARE @isAdditional AS VARCHAR(3);

	DECLARE @isRequired BIT;

	DECLARE @description AS VARCHAR(2000);

	DECLARE @labourQty AS DECIMAL(9, 2);

	DECLARE @labourMeasure AS VARCHAR(100);

	DECLARE @lmeasureId AS INT;

	DECLARE @labourRate AS DECIMAL(9, 2);

	DECLARE @labourMargin AS DECIMAL(9, 2);

	DECLARE @labourMarginDesc AS VARCHAR(10);

	DECLARE @labourMarginType AS TINYINT;

	DECLARE @labourTotal AS DECIMAL(9, 2);

	DECLARE @materialQty AS DECIMAL(9, 2);

	DECLARE @materialMeasure AS VARCHAR(100);

	DECLARE @mmeasureId AS INT;

	DECLARE @materialRate AS DECIMAL(9, 2);

	DECLARE @materialMargin AS DECIMAL(9, 2);

	DECLARE @materialMarginDesc AS VARCHAR(10);

	DECLARE @materialMarginType AS TINYINT;

	DECLARE @materialTotal AS DECIMAL(9, 2);

	DECLARE @Total AS DECIMAL(9, 2);

	DECLARE @labourMarkupTotal DECIMAL(9, 2);

	DECLARE @materialMarkupTotal DECIMAL(9, 2);

	DECLARE @markupTotal DECIMAL(9, 2);

	DECLARE @position INT;

	DECLARE @estimatorId INT;

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
	
	DECLARE cvReader CURSOR FAST_FORWARD FOR
		SELECT [room_category], 
		       [width], 
			   [length], 
			   [height], 
			   [trade_name], 
			   [is_extra_item],
			   [description],
			   [l_qty],
			   [l_measure],
			   [l_rate],
			   [l_margin],
			   [l_margin_type],
			   [m_qty],
			   [m_measure],
			   [m_rate],
			   [m_margin],
			   [m_margin_type]
		FROM [dbo].[Insurance_Estimator_Entry_Import];

		IF ( @Transaction = 0 ) BEGIN TRANSACTION;

		BEGIN TRY

			OPEN cvReader;

			FETCH FROM cvReader INTO @roomCategory,
									 @width,
									 @length,
									 @height,
									 @tradename,
									 @isAdditional,
									 @description,
									 @labourQty,
									 @labourMeasure,
									 @labourRate,
									 @labourMargin,
									 @labourMarginDesc,
									 @materialQty,
									 @materialMeasure,
									 @materialRate,
									 @materialMargin,
									 @materialMarginDesc;

			WHILE ( @@FETCH_STATUS = 0 )
			BEGIN

				SET @roomCategory = LTRIM(RTRIM(ISNULL(@roomCategory, '')));

				IF ( LEN(@roomCategory) = 0 )
				BEGIN

					FETCH FROM cvReader INTO @roomCategory,
											 @width,
											 @length,
											 @height,
											 @tradename,
											 @isAdditional,
											 @description,
											 @labourQty,
											 @labourMeasure,
											 @labourRate,
											 @labourMargin,
											 @labourMarginDesc,
											 @materialQty,
											 @materialMeasure,
											 @materialRate,
											 @materialMargin,
											 @materialMarginDesc;

					CONTINUE;

				END;

				SELECT @roomId = [Insurance_Room_Id] FROM [dbo].[Insurance_Room] WHERE [name] = @roomCategory;

				IF ( @roomId IS NULL )
				BEGIN

					FETCH FROM cvReader INTO @roomCategory,
											 @width,
											 @length,
											 @height,
											 @tradename,
											 @isAdditional,
											 @description,
											 @labourQty,
											 @labourMeasure,
											 @labourRate,
											 @labourMargin,
											 @labourMarginDesc,
											 @materialQty,
											 @materialMeasure,
											 @materialRate,
											 @materialMargin,
											 @materialMarginDesc;

					CONTINUE;

				END;

				SET @width = ISNULL(@width, CAST(0 AS DECIMAL(9, 2)));

				SET @length = ISNULL(@length, CAST(0 AS DECIMAL(9, 2)));

				SET @height = ISNULL(@height, CAST(0 AS DECIMAL(9, 2)));

				SET @tradename = LTRIM(RTRIM(ISNULL(@tradename, '')));

				IF ( LEN(@tradename) = 0 )
				BEGIN

					FETCH FROM cvReader INTO @roomCategory,
											 @width,
											 @length,
											 @height,
											 @tradename,
											 @isAdditional,
											 @description,
											 @labourQty,
											 @labourMeasure,
											 @labourRate,
											 @labourMargin,
											 @labourMarginDesc,
											 @materialQty,
											 @materialMeasure,
											 @materialRate,
											 @materialMargin,
											 @materialMarginDesc;

					CONTINUE;

				END;

				SELECT @tradeId = [Insurance_Trade_ID] FROM [dbo].[Insurance_Trade] WHERE [Trade_Name] = @tradename;

				IF ( @tradeId IS NULL )
				BEGIN

					FETCH FROM cvReader INTO @roomCategory,
											 @width,
											 @length,
											 @height,
											 @tradename,
											 @isAdditional,
											 @description,
											 @labourQty,
											 @labourMeasure,
											 @labourRate,
											 @labourMargin,
											 @labourMarginDesc,
											 @materialQty,
											 @materialMeasure,
											 @materialRate,
											 @materialMargin,
											 @materialMarginDesc;

					CONTINUE;

				END;

				SET @isAdditional = LTRIM(RTRIM(ISNULL(@isAdditional, '')));

				IF ( LEN(@isAdditional) = 0 )
					SET @isRequired = 0;
				ELSE IF ( LOWER(@isAdditional) = 'yes' )
					SET @isRequired = 1;
				ELSE
					SET @isRequired = 0;

				SET @description = LTRIM(RTRIM(ISNULL(@description, '')));

				IF ( @description IS NOT NULL ) SET @description = LTRIM(RTRIM(@description));

				IF ( LEN(@separator) > 0 ) AND ( LEN(@replacement) > 0 ) AND ( @description IS NOT NULL )
					IF ( LEN(@description) > 0 ) AND ( CHARINDEX( @replacement, @description, 1 ) > 0 )
						SET @description = REPLACE( @description, @replacement, @separator );

				IF ( @description IS NOT NULL ) AND ( LEN(@description) > 0 )
				BEGIN

					SET @position = CHARINDEX( '"', @description, 1 );

					IF ( @position = 1 )
					BEGIN

						SET @description = SUBSTRING( @description, 2, LEN( @description ) - 1 );

					END;

					SET @position = CHARINDEX( '"', @description, 1 );

					IF ( @position = LEN( @description ) )
					BEGIN

						SET @description = SUBSTRING( @description, 1, LEN( @description ) - 1 );

					END;

				END;

				SET @labourQty = ISNULL(@labourQty, CAST(0 AS DECIMAL(9, 2)));

				SET @labourMeasure = LTRIM(RTRIM(ISNULL(@labourMeasure, '')));

				IF ( LEN(@labourMeasure) = 0 )
				BEGIN

					FETCH FROM cvReader INTO @roomCategory,
											 @width,
											 @length,
											 @height,
											 @tradename,
											 @isAdditional,
											 @description,
											 @labourQty,
											 @labourMeasure,
											 @labourRate,
											 @labourMargin,
											 @labourMarginDesc,
											 @materialQty,
											 @materialMeasure,
											 @materialRate,
											 @materialMargin,
											 @materialMarginDesc;

					CONTINUE;

				END;

				SELECT @lmeasureId = [Insurance_Unit_ID] FROM [dbo].[Insurance_Unit] WHERE [Name] = @labourMeasure;

				IF ( @lmeasureId IS NULL )
				BEGIN

					FETCH FROM cvReader INTO @roomCategory,
											 @width,
											 @length,
											 @height,
											 @tradename,
											 @isAdditional,
											 @description,
											 @labourQty,
											 @labourMeasure,
											 @labourRate,
											 @labourMargin,
											 @labourMarginDesc,
											 @materialQty,
											 @materialMeasure,
											 @materialRate,
											 @materialMargin,
											 @materialMarginDesc;

					CONTINUE;

				END;

				SET @labourRate = ISNULL(@labourRate, CAST(0 AS DECIMAL(9, 2)));

				SET @labourMargin = ISNULL(@labourMargin, CAST(0 AS DECIMAL(9, 2)));

				SET @labourMarginDesc = LTRIM(RTRIM(ISNULL(@labourMarginDesc, '')));

				IF ( LEN(@labourMarginDesc) = 0 )
				BEGIN

					SET @labourMarginType = 0; -- LABOUR MARGIN AS PERCENTAGE VALUE

				END
				ELSE
				BEGIN

					IF ( LOWER(@labourMarginDesc) = 'monetary' )
						SET @labourMarginType = 1; -- LABOUR MARGIN AS MONETARY VALUE
					ELSE IF ( LOWER(@labourMarginDesc) = 'percentage' )
						SET @labourMarginType = 0; -- LABOUR MARGIN AS PERCENTAGE VALUE
					ELSE
						SET @labourMarginType = 0; -- LABOUR MARGIN AS PERCENTAGE VALUE

				END;

				SET @materialQty = ISNULL(@materialQty, CAST(0 AS DECIMAL(9, 2)));

				SET @materialMeasure = LTRIM(RTRIM(ISNULL(@materialMeasure, '')));

				IF ( LEN(@materialMeasure) = 0 )
				BEGIN

					FETCH FROM cvReader INTO @roomCategory,
											 @width,
											 @length,
											 @height,
											 @tradename,
											 @isAdditional,
											 @description,
											 @labourQty,
											 @labourMeasure,
											 @labourRate,
											 @labourMargin,
											 @labourMarginDesc,
											 @materialQty,
											 @materialMeasure,
											 @materialRate,
											 @materialMargin,
											 @materialMarginDesc;

					CONTINUE;

				END;

				SELECT @mmeasureId = [Insurance_Unit_ID] FROM [dbo].[Insurance_Unit] WHERE [Name] = @materialMeasure;

				IF ( @mmeasureId IS NULL )
				BEGIN

					FETCH FROM cvReader INTO @roomCategory,
											 @width,
											 @length,
											 @height,
											 @tradename,
											 @isAdditional,
											 @description,
											 @labourQty,
											 @labourMeasure,
											 @labourRate,
											 @labourMargin,
											 @labourMarginDesc,
											 @materialQty,
											 @materialMeasure,
											 @materialRate,
											 @materialMargin,
											 @materialMarginDesc;

					CONTINUE;

				END;

				SET @materialRate = ISNULL(@materialRate, CAST(0 AS DECIMAL(9, 2)));

				SET @materialMargin = ISNULL(@materialMargin, CAST(0 AS DECIMAL(9, 2)));

				SET @materialMarginDesc = LTRIM(RTRIM(ISNULL(@materialMarginDesc, '')));

				IF ( LEN(@materialMarginDesc) = 0 )
				BEGIN

					SET @materialMarginType = 0; -- MATERIAL MARGIN AS PERCENTAGE VALUE

				END
				ELSE
				BEGIN

					IF ( LOWER(@materialMarginDesc) = 'monetary' )
						SET @materialMarginType = 1; -- MATERIAL MARGIN AS MONETARY VALUE
					ELSE IF ( LOWER(@materialMarginDesc) = 'percentage' )
						SET @materialMarginType = 0; -- MATERIAL MARGIN AS PERCENTAGE VALUE
					ELSE
						SET @materialMarginType = 0; -- MATERIAL MARGIN AS PERCENTAGE VALUE

				END;

				SET @labourTotal = CAST(@labourQty * @labourRate AS DECIMAL(9, 2));

				SET @materialTotal = CAST(@materialQty * @materialRate AS DECIMAL(9, 2));

				SET @Total = CAST( @labourTotal + @materialTotal AS DECIMAL(9, 2));

				IF ( @labourMarginType <> 0 /* MONETARY VALUE */ )
					SET @labourMarkupTotal = @labourTotal + @labourMargin;
				ELSE IF ( @labourMarginType = 0  /* PERCENTAGE */ )
					SET @labourMarkupTotal = @labourTotal + CAST((( @labourTotal * @labourMargin ) / 100) AS DECIMAL(9, 2));
				ELSE /* PERCENTAGE */
					SET @labourMarkupTotal = @labourTotal + CAST((( @labourTotal * @labourMargin ) / 100) AS DECIMAL(9, 2));

				IF ( @materialMarginType <> 0 /* MONETARY VALUE */ )
					SET @materialMarkupTotal = @materialTotal + @materialMargin;
				ELSE IF ( @materialMarginType = 0 /* PERCENTAGE */ )
					SET @materialMarkupTotal = @materialTotal + CAST((( @materialTotal * @materialMargin ) / 100) AS DECIMAL(9, 2));
				ELSE /* PERCENTAGE */
					SET @materialMarkupTotal = @materialTotal + CAST((( @materialTotal * @materialMargin ) / 100) AS DECIMAL(9, 2));

				SET @markupTotal = @labourMarkupTotal + @materialMarkupTotal;

				EXEC [getNextID] 'Insurance_Estimator_Item', @estimatorId OUTPUT, @ErrMessage OUTPUT, @ErrNumber OUTPUT;

				IF ( ( @ErrNumber = 0 ) AND ( @estimatorId > 0 ) )
				BEGIN

					--
					-- Notes:
					--       The labour and material markup types are preserved within the columns
					--       [l_percent_type] and [m_percent_type] consecutively.
					--
					--       The preserved value of 0 reflects a monetary value while a preserved value of 1
					--       reflects a percentage value for the preserved values within the labour and material
					--       markup values preserved within the columns [l_percent] and [m_percent] consecutively.
					--  

					INSERT INTO [dbo].[Insurance_Estimator_Item]
					(
						[Insurance_Estimator_Item_Id],
						[Insurance_Quote_id],
						[Insurance_Scope_Item_Id],
						[Insurance_Trade_Id],
						[room_id],
						[long_desc],
						[l_unit],
						[m_unit],
						[l_quantity],
						[m_quantity],
						[l_rate],
						[m_rate],
						[l_total],
						[m_total],
						[l_cost_total],
						[m_cost_total],
						[cost_total],
						[total],
						[l_percent],
						[m_percent],
						[l_percent_type],
						[m_percent_type],
						[l_total_with_margin],
						[m_total_with_margin],
						[total_with_margin],
						[room_size_1],
						[room_size_2],
						[room_size_3],
						[IsExtraItem],
						[created_by],
						[create_date],
						[row_version]
					)
					VALUES
					(
						@estimatorId,
						@insurancequoteId,
						0, -- Insurance scope item is not relevant
						@tradeId,
						@roomId,
						@description,
						@lmeasureId,
						@mmeasureId,
						@labourQty,
						@materialQty,
						@labourRate,
						@materialRate,
						@labourTotal,
						@materialTotal,
						@labourTotal,
						@materialTotal,
						@Total,
						@Total,
						@labourMargin,
						@materialMargin,
						@labourMarginType,
						@materialMarginType,
						@labourMarkupTotal, -- Labour markup total
						@materialMarkupTotal, -- Material markup total
						@markupTotal, -- Total markup value
						@width,
						@height,
						@length,
						@isRequired,
						@username,
						GETDATE(),
						0 -- row version is not relevant
					);

				END
				ELSE
				BEGIN

					BREAK;

				END;

				FETCH FROM cvReader INTO @roomCategory,
										 @width,
										 @length,
										 @height,
										 @tradename,
										 @isAdditional,
										 @description,
										 @labourQty,
										 @labourMeasure,
										 @labourRate,
										 @labourMargin,
										 @labourMarginDesc,
										 @materialQty,
										 @materialMeasure,
										 @materialRate,
										 @materialMargin,
										 @materialMarginDesc;

			END;

			IF ( LEN( @ErrMessage ) = 0 )
			BEGIN
				SET @retval = @@ERROR;
			END
			ELSE
			BEGIN
				SET @retval = @ErrNumber;
			END;

			IF ( @retval = 0 )
			BEGIN
				IF ( @Transaction = 0 ) COMMIT TRANSACTION;
			END
			ELSE
			BEGIN
				IF ( @Transaction = 0 ) ROLLBACK TRANSACTION;
			END;

			CLOSE cvReader;

			DEALLOCATE cvReader;

			IF ( LEN(@username) > 0 ) AND ( LEN(@clientAddress) > 0 )
			BEGIN
				IF ( ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Estimator_Entry_Import'), N'IsUserTable'), 0) = 1 )
				BEGIN
					DELETE FROM [dbo].[Insurance_Estimator_Entry_Import] WHERE ( [username] = @username ) AND ( [client_address] = @clientAddress );
				END;
			END;

			IF ( LEN( @ErrMessage ) > 0 ) AND ( @retval <> 0 )
			BEGIN

				SET @ErrSeverity = ERROR_SEVERITY();

				SET @ErrStatus = ERROR_STATE();

				RAISERROR ( @ErrMessage, @ErrSeverity,  @ErrStatus ) WITH NOWAIT;

			END;

			-- UPDATE THE INSURANCE QUOTE ESTIMATE DETAILS.

			EXEC @retval = [dbo].[Insurance_Quote_Bulk_Insert_Update] @insurancequoteid;
			
			-- UPDATE THE INSURANCE WORK ESTIMATED SALES, COSTS AND PROFITS FOR NON-CANCELLED INSURANCE WORK ORDER QUOTES
			
			-- IF ( @retval = 0 ) EXEC @retval = [dbo].[Insurance_WorkOrder_Bulk_Insert_Update] @insurancequoteid;

		END TRY
		BEGIN CATCH

			SET @retval = @@ERROR;

			SET @ErrMessage = ERROR_MESSAGE();

			SET @ErrSeverity = ERROR_SEVERITY();

			SET @ErrStatus = ERROR_STATE();

			IF ( @Transaction = 0 ) ROLLBACK TRANSACTION;

			IF ( LEN(@username) > 0 ) AND ( LEN(@clientAddress) > 0 )
			BEGIN
				IF ( ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Estimator_Entry_Import'), N'IsUserTable'), 0) = 1 )
				BEGIN
					DELETE FROM [dbo].[Insurance_Estimator_Entry_Import] WHERE ( [username] = @username ) AND ( [client_address] = @clientAddress );
				END;
			END;

			SELECT @estimatorId = [MAX_ID] FROM [dbo].[SEQUENCE_TABLE] WHERE [SEQUENCE_NAME] = 'Insurance_Estimator_Item';

			IF ( @estimatorId IS NOT NULL )
			BEGIN

				SET @estimatorId = @estimatorId - 1;

				UPDATE [dbo].[SEQUENCE_TABLE] WITH (READCOMMITTED) SET [MAX_ID] = @estimatorId WHERE [SEQUENCE_NAME] = 'Insurance_Estimator_Item';

			END;

			RAISERROR ( @ErrMessage, @ErrSeverity,  @ErrStatus ) WITH NOWAIT;

		END CATCH;

		RETURN @retval;

END;
GO
