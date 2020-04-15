USE [visionary];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Estimator_Item_Associate'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Estimator_Item_Associate];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 1 May 2013
-- Description:	Associates the negative insurance quote variation, identified by
--              the @quoteId parameter, with the pre-existing insurance work order
--              quote estimation.
-- Assumption:  The production database server and the production web server resides
--              on the same Windows Server device.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Estimator_Item_Associate] ( @quoteId INT, @estimatorId INT, @username VARCHAR(50) = NULL )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SET @quoteId = ISNULL( @quoteId, 0 );

	SET @estimatorId = ISNULL( @estimatorId, 0 );

	IF NOT EXISTS(SELECT 1 FROM [dbo].[Insurance_Quote] WHERE [Insurance_Quote_id] = @quoteId)
		RAISERROR( 'The insurance work order quote identity ( %d ) has not been registered within the data warehouse.', 16, 2, @quoteId) WITH NOWAIT;

	DECLARE @variationType INT;

	SELECT @variationType = ISNULL([variation_type], 0) FROM [dbo].[Insurance_Quote] WHERE [Insurance_Quote_id] = @quoteId;

	DECLARE @Id INT;

	DECLARE @ErrNumber INT;

	DECLARE @Error INT;

	EXEC [getNextID] 'Insurance_Estimator_Item', @Id OUTPUT, @Error OUTPUT, @ErrNumber OUTPUT;

	IF ( NOT ( @ErrNumber = 0 ) ) OR ( NOT ( @Error = 0 ) )
		RAISERROR(N'The sequence generator cannot generate the sequence key for the table %s', 16, 2, 'Insurance_Estimator_Item') WITH NOWAIT;

	DECLARE @ErrMessage VARCHAR(2048);

	DECLARE @ErrSeverity INT;

	DECLARE @ErrStatus INT;

	DECLARE @Transaction INT;
	
	SET @Transaction = @@TRANCOUNT;

	BEGIN TRY

		IF ( @Transaction = 0 ) BEGIN TRANSACTION;

		INSERT INTO [dbo].[Insurance_Estimator_Item]
		(
			[Insurance_Estimator_Item_Id],
			[Insurance_Quote_id],
			[Insurance_Scope_Item_Id],
			[room_id],
			[short_desc],
			[long_desc],
			[l_unit],
			[m_unit],
			[l_quantity],
			[m_quantity],
			[l_rate],
			[m_rate],
			[l_total],
			[m_total],
			[l_percent],
			[m_percent],
			[l_percent_type],
			[m_percent_type],
			[l_cost_total],
			[m_cost_total],
			[cost_total],
			[total],
			[l_total_with_margin],
			[m_total_with_margin],
			[l_cost_rate],
			[m_cost_rate],
			[total_with_margin],
			[created_by],
			[create_date],
			[Insurance_Trade_Id],
			[code],
			[is_lock_for_negative_quote],
			[old_est_id],
			[neg_l_markup],
			[neg_m_markup],
			[neg_from_quote_id],
			[neg_assigned_to_name],
			[bypass],
			[room_size_1],
			[room_size_2],
			[room_size_3],
			[IsExtraItem],
			[Cancelled_Estimator_Item_ID],
			[Damage_Result_Of],
			[Has_Structural_Damage],
			[DamageText],
			[MinimumCharge],
			[updated_by],
			[updated_date],
			[row_version]
		)
		SELECT	@Id,
				@quoteId,
				IE.[Insurance_Scope_Item_Id],
				IE.[room_id],
				IE.[short_desc],
				IE.[long_desc],
				IE.[l_unit],
				IE.[m_unit],
				IE.[l_quantity],
				IE.[m_quantity],
				IE.[l_rate],
				IE.[m_rate],
				IE.[l_total],
				IE.[m_total],
				IE.[l_percent],
				IE.[m_percent],
				ISNULL(IE.[l_percent_type], 1) AS [l_percent_type],
				ISNULL(IE.[m_percent_type], 1) AS [m_percent_type],
				IE.[l_cost_total],
				IE.[m_cost_total],
				IE.[cost_total],
				IE.[total],
				IE.[l_total_with_margin],
				IE.[m_total_with_margin],
				IE.[l_cost_rate],
				IE.[m_cost_rate],
				IE.[total_with_margin],
				IE.[created_by],
				IE.[create_date],
				IE.[Insurance_Trade_Id],
				IE.[code],
				IE.[is_lock_for_negative_quote],
				CASE WHEN ( @variationType = 2 /* Negative Insurance Quote Variation */ ) THEN ISNULL(@estimatorId, IE.[old_est_id]) ELSE IE.[old_est_id] END,
				IE.[neg_l_markup],
				IE.[neg_m_markup],
				CASE WHEN (@variationType = 2 /* Negative Insurance Quote Variation */ ) THEN @quoteId ELSE IE.[neg_from_quote_id] END,
				IE.[neg_assigned_to_name],
				IE.[bypass],
				IE.[room_size_1],
				IE.[room_size_2],
				IE.[room_size_3],
				IE.[IsExtraItem],
				IE.[Cancelled_Estimator_Item_ID],
				IE.[Damage_Result_Of],
				IE.[Has_Structural_Damage],
				IE.[DamageText],
				IE.[MinimumCharge],
				IE.[updated_by],
				IE.[updated_date],
				0
		FROM    [dbo].[Insurance_Estimator_Item] IE
		WHERE ( IE.[Insurance_Estimator_Item_id] = @estimatorId );

		SET @ErrNumber = @@ERROR;

		IF ( @ErrNumber = 0 )
		BEGIN

			IF ( @Transaction = 0 ) COMMIT TRANSACTION;

		END
		ELSE
		BEGIN

			IF ( @Transaction = 0 ) ROLLBACK TRANSACTION;

		END;

		IF ( @ErrNumber = 0 )
		BEGIN

			-- UPDATE THE INSURANCE QUOTE ESTIMATE DETAILS.

			DECLARE @retval INT;

			EXEC @retval = [dbo].[Insurance_Quote_Bulk_Insert_Update] @quoteId;

		END;

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