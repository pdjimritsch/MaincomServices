USE [visionary];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Estimator_Item_Update'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Estimator_Item_Update];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 25 February 2013
-- Description:	Updates the existing insurance quote estimation within the database schema.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Estimator_Item_Update]
(
	@Id INT,
	@Insurance_Quote_Id INT,
	@Insurance_Scope_Id INT,
	@Insurance_Room_Id INT,
	@Insurance_Trade_Id INT,
	@UserName VARCHAR(20),
	@ShortDescription VARCHAR(300),
	@LongDescription VARCHAR(2000),
	@LabourUnit INT,
	@MaterialUnit INT,
	@LabourQuantity DECIMAL(18, 2),
	@MaterialQuantity DECIMAL(18, 2),
	@LabourRate DECIMAL(9, 2),
	@MaterialRate DECIMAL(9, 2),
	--@LabourTotal DECIMAL(9, 2),
	--@MaterialTotal DECIMAL(9, 2),
	@LabourPercent DECIMAL(9, 2) = NULL,
	@MaterialPercent DECIMAL(9, 2) = NULL,
	@LabourPercentType TINYINT = NULL,
	@MaterialPercentType TINYINT = NULL,
	--@Total DECIMAL(9, 2) = NULL,
	--@LabourCostTotal DECIMAL(9, 2) = NULL,
	--@MaterialCostTotal DECIMAL(9, 2) = NULL,
	--@CostTotal DECIMAL(9, 2) = NULL,
	--@LabourCostRate DECIMAL(9, 2) = NULL,
	--@MaterialCostRate DECIMAL(9, 2) = NULL,
	@Code VARCHAR(200) = NULL,
	@IsLockForNegativeQuote BIT = NULL,
	@NegativeLabourMarkup DECIMAL(9, 2) = NULL,
	@NegativeMaterialMarkup DECIMAL(9, 2) = NULL,
	@NegativeFromQuoteId INT = NULL,
	@NegativeAssignedToName VARCHAR(200) = NULL,
	@Bypass BIT = NULL,
	@RoomSize1 DECIMAL(9, 2) = NULL,
	@RoomSize2 DECIMAL(9, 2) = NULL,
	@RoomSize3 DECIMAL(9, 2) = NULL,
	@IsExtraItem BIT = NULL,
	@CancelledEstimatorItemId INT = NULL,
	@DamageReason INT = NULL,
	@HasStructuralDamage BIT = NULL,
	@DamageText VARCHAR(50) = NULL,
	@MinimumCharge VARCHAR(255) = NULL,
	@ValidateEntry BIT = 0
)
WITH EXECUTE AS CALLER
AS
BEGIN

	DECLARE @Error INT;

	SET @Error = @@ERROR;

	DECLARE @ErrNumber INT;

	DECLARE @retval INT;

	-- Parameter initialization

	IF ( ISNULL(@ValidateEntry, 0) <> 0 )
	BEGIN

		SET @Insurance_Quote_Id = ISNULL(@Insurance_Quote_Id, 0);
		SET @Insurance_Scope_Id = ISNULL(@Insurance_Scope_Id, 0);
		SET @Insurance_Room_Id = ISNULL(@Insurance_Room_Id, 0);
		SET @Insurance_Trade_Id = ISNULL(@Insurance_Trade_Id, 0);

	END;

	SET @LabourUnit = ISNULL(@LabourUnit, 0);
	SET @MaterialUnit = ISNULL(@MaterialUnit, 0);
	
	SET @UserName = LTRIM(RTRIM(ISNULL(@UserName, '')));
	SET @ShortDescription = LTRIM(RTRIM(ISNULL(@ShortDescription, '')));
	SET @LongDescription = LTRIM(RTRIM(ISNULL(@LongDescription, '')));
	SET @LabourQuantity = ISNULL(@LabourQuantity, CAST(0 AS DECIMAL(18, 2)));
	SET @MaterialQuantity = ISNULL(@MaterialQuantity, CAST(0 AS DECIMAL(18, 2)));
	SET @LabourRate = ISNULL(@LabourRate, CAST(0 AS DECIMAL(9, 2)));
	SET @MaterialRate = ISNULL(@MaterialRate, CAST(0 AS DECIMAL(9, 2)));

	SET @LabourPercent = ISNULL(@LabourPercent, CAST(0 AS DECIMAL(9, 2)));
	SET @MaterialPercent = ISNULL(@MaterialPercent, CAST(0 AS DECIMAL(9, 2)));
	SET @LabourPercentType = ISNULL(@LabourPercentType, CAST(0 AS BIT));
	SET @MaterialPercentType = ISNULL(@MaterialPercentType, CAST(0 AS BIT));

	-- Parameter declaration

	DECLARE @LabourTotal AS DECIMAL(9, 2);
	SET @LabourTotal = CAST(ISNULL(@LabourQuantity, CAST(0 AS DECIMAL(9, 2))) * ISNULL(@LabourRate, CAST(0 AS DECIMAL(9, 2))) AS DECIMAL(9, 2));

	DECLARE @MaterialTotal AS DECIMAL(9, 2);
	SET @MaterialTotal = CAST(ISNULL(@MaterialQuantity, CAST(0 AS DECIMAL(9, 2))) * ISNULL(@MaterialRate, CAST(0 AS DECIMAL(9, 2))) AS DECIMAL(9, 2));

	DECLARE @Total AS DECIMAL(9, 2);
	SET @Total = @LabourTotal + @MaterialTotal;

	DECLARE @LabourMarginTotal DECIMAL(9, 2);
	SET @LabourMarginTotal = CAST(0 AS DECIMAL(9, 2));

	IF ( @LabourPercentType <> 0 /* Labour monetary value */ )
		SET @LabourMarginTotal = @LabourMarginTotal + CAST(@LabourTotal + @LabourPercent AS DECIMAL(9, 2));
	ELSE /* Labour Percentage Type */
		SET @LabourMarginTotal = @LabourMarginTotal + @LabourTotal + CAST((@LabourTotal *  @LabourPercent) AS DECIMAL(9, 2));

	DECLARE @MaterialMarginTotal DECIMAL(9, 2);
	SET @MaterialMarginTotal = CAST(0 AS DECIMAL(9, 2));

	IF ( @MaterialPercentType <> 0 /* Material monetary value */ )
		SET @MaterialMarginTotal = @MaterialMarginTotal + CAST(@MaterialTotal + @MaterialPercent AS DECIMAL(9, 2));
	ELSE /* Material Percentage Type */
		SET @MaterialMarginTotal = @MaterialMarginTotal + @MaterialTotal + CAST((@MaterialTotal *  @MaterialPercent) AS DECIMAL(9, 2));

	DECLARE @MarginTotal AS DECIMAL(9, 2);
	SET @MarginTotal = @LabourMarginTotal + @MaterialMarginTotal;

	-- Validate the existence of the insurance quote, insurance scope, insurance room, insurance trade identity

	IF ( ISNULL(@ValidateEntry, 0 ) <> 0 )
	BEGIN

		IF NOT EXISTS(SELECT 1 FROM [dbo].[Insurance_Quote] WHERE [Insurance_Quote_id] = @Insurance_Quote_Id)
			RAISERROR(N'The provided insurance quote identity has not been registered within the data warehouse', 16, 2) WITH NOWAIT; 

		IF NOT EXISTS(SELECT 1 FROM [dbo].[Insurance_Scope_Item] WHERE [Insurance_Scope_Item_id] = @Insurance_Scope_Id)
			RAISERROR(N'The provided insurance scope identity has not been registered within the data warehouse', 16, 2) WITH NOWAIT; 

		IF NOT EXISTS(SELECT 1 FROM [dbo].[Insurance_Room] WHERE [Insurance_Room_Id] = @Insurance_Room_Id)
			RAISERROR(N'The provided insurance room identity has not been registered within the data warehouse', 16, 2) WITH NOWAIT;
		
		IF NOT EXISTS(SELECT 1 FROM [dbo].[Insurance_Trade] WHERE [Insurance_Trade_ID] = @Insurance_Trade_Id)
			RAISERROR(N'The provided insurance trade identity has not been registered within the data warehouse', 16, 2) WITH NOWAIT;

		IF NOT EXISTS(SELECT 1 FROM [dbo].[Insurance_Unit] WHERE [Insurance_Unit_ID] = @LabourUnit)
			RAISERROR(N'The provided insurance labour unit identity has not been registered within the data warehouse', 16, 2) WITH NOWAIT;

		IF NOT EXISTS(SELECT 1 FROM [dbo].[Insurance_Unit] WHERE [Insurance_Unit_ID] = @MaterialUnit)
			RAISERROR(N'The provided insurance material unit identity has not been registered within the data warehouse', 16, 2) WITH NOWAIT;

		IF (@CancelledEstimatorItemId IS NOT NULL) AND (NOT EXISTS(SELECT 1 FROM [dbo].[Insurance_Estimator_Item] WHERE [Insurance_Estimator_Item_id] = @CancelledEstimatorItemId))
			RAISERROR(N'The provided cancelled insurance quote estimation item  has not been registered within the data warehouse', 16, 2) WITH NOWAIT;

	END;

	IF ( NOT ( @ErrNumber = 0 ) ) OR ( NOT ( @Error = 0 ) )
		RAISERROR(N'The sequence generator cannot generate the sequence key for the table %s', 16, 2, 'Insurance_Estimator_Item') WITH NOWAIT;

	DECLARE @Transaction INT;

	SET @Transaction = @@TRANCOUNT;

	IF @Transaction = 0 BEGIN TRANSACTION;

	BEGIN TRY

		UPDATE [dbo].[Insurance_Estimator_Item] WITH (READCOMMITTED) SET
			[Insurance_Quote_id] = @Insurance_Quote_Id,
			[Insurance_scope_Item_Id] = @Insurance_Scope_Id,
			[room_id] = @Insurance_Room_Id,
			[short_desc] = @ShortDescription,
			[long_desc] = @LongDescription,
			[l_unit] = @LabourUnit,
			[m_unit] = @MaterialUnit,
			[l_quantity] = @LabourQuantity,
			[m_quantity] = @MaterialQuantity,
			[l_rate] = @LabourRate,
			[m_rate] = @MaterialRate,
			[l_total] = @LabourTotal,
			[m_total] = @MaterialTotal,
			[l_cost_total] = @LabourTotal,
			[m_cost_total] = @MaterialTotal,
			[cost_total] = @Total,
			[total] = @Total,
			[l_percent] = @LabourPercent,
			[m_percent] = @MaterialPercent,
			[l_percent_type] = @LabourPercentType,
			[m_percent_type] = @MaterialPercentType,
			[l_total_with_margin] = @LabourMarginTotal,
			[m_total_with_margin] = @MaterialMarginTotal,
			[total_with_margin] = @MarginTotal,
			[updated_by] = @UserName,
			[updated_date] = GETDATE(),
			[Insurance_Trade_Id] = @Insurance_Trade_Id,
			[code] = @Code,
			[is_lock_for_negative_quote] = @IsLockForNegativeQuote,
			[neg_l_markup] = @NegativeLabourMarkup,
			[neg_m_markup] = @NegativeMaterialMarkup,
			[neg_from_quote_id] = @NegativeFromQuoteId,
			[neg_assigned_to_name] = @NegativeAssignedToName,
			[bypass] = @Bypass,
			[room_size_1] = @RoomSize1,
			[room_size_2] = @RoomSize2,
			[room_size_3] = @RoomSize3,
			[IsExtraItem] = @IsExtraItem,
			[Cancelled_Estimator_Item_ID] = @CancelledEstimatorItemId,
			[Damage_Result_Of] = @DamageReason,
			[Has_Structural_Damage] = @HasStructuralDamage,
			[DamageText] = @DamageText,
			[MinimumCharge] = @MinimumCharge
		WHERE [Insurance_Estimator_Item_Id] = ISNULL(@Id, 0);

		SET @Error = @@ERROR;

		IF ( @Error = 0 )
		BEGIN
			IF ( @Transaction = 0 ) COMMIT TRANSACTION;
		END
		ELSE
		BEGIN
			IF ( @Transaction = 0 ) ROLLBACK TRANSACTION;
		END;

		IF ( @Error = 0 )
		BEGIN

			-- UPDATE THE INSURANCE QUOTE ESTIMATE DETAILS.
			EXEC @retval = [dbo].[Insurance_Quote_Bulk_Insert_Update] @Insurance_Quote_Id;

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

	RETURN @Id;

END;
GO
