USE [visionary]; -- change the database name if required
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Estimator_Item_Get_Partial_Reader'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Estimator_Item_Get_Partial_Reader];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 25 February 2013
-- Description:	Obtains the unregistered insurance work order quote line items
--              for a specific insurance work order quote identity from the pool
--              of available insurance work order quote line items for the
--              associated insurance work order identity.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Estimator_Item_Get_Partial_Reader] ( @QuoteId INT = NULL)
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	/* Declarations */

	DECLARE @OrderId INT;

	SELECT @OrderId = [Order_id] FROM [dbo].[Insurance_Quote] WITH (READCOMMITTED) WHERE [Insurance_Quote_id] = ISNULL(@QuoteId, -1);

	DECLARE cvReader CURSOR LOCAL FAST_FORWARD FOR
		SELECT	IE.[Insurance_Estimator_Item_Id],
				IE.[Insurance_Quote_id],
				IE.[Insurance_Scope_Item_Id],
				IR.[name] AS [room_name],
				IE.[short_desc],
				IE.[long_desc],
				LIU.[Name] AS [l_unit_name],
				MIU.[Name] AS [m_unit_name],
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
				IE.[l_cost_rate],
				IE.[m_cost_rate],
				IE.[l_total_with_margin],
				IE.[m_total_with_margin],
				IE.[total_with_margin],
				IE.[total],
				IE.[created_by],
				IE.[create_date],
				IT.[Trade_Name] AS [Insurance_Trade_Name],
				IE.[code],
				IE.[is_lock_for_negative_quote],
				IE.[old_est_id],
				IE.[neg_l_markup],
				IE.[neg_m_markup],
				IE.[neg_from_quote_id],
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
				IE.[updated_date]
		FROM [dbo].[Insurance_Quote] IQ 
				INNER JOIN [dbo].[Insurance_Estimator_Item] IE ON [IE].[Insurance_Quote_id] = IQ.[Insurance_Quote_id]
				INNER JOIN [dbo].[Insurance_Room] IR ON IR.[Insurance_Room_Id] = IE.[room_id]
				INNER JOIN [dbo].[Insurance_Unit] LIU ON LIU.[Insurance_Unit_ID] = IE.[l_unit]
				INNER JOIN [dbo].[Insurance_Unit] MIU ON MIU.[Insurance_Unit_ID] = IE.[m_unit]
				INNER JOIN [dbo].[Insurance_Trade] IT ON IT.[Insurance_Trade_ID] = IE.[Insurance_Trade_Id]
		WHERE   ( IQ.[Order_id] = ISNULL(@OrderId, -1) )
		AND     ( ISNULL(IQ.[variation_type], 0) <> 2 )
		ORDER BY IE.[Insurance_Estimator_Item_Id];

	-- THE @container inline table contains the insurance work order quote line items (estimations) for the specific insurance work order quote identity.

	DECLARE @VariationType INT;

	SELECT @VariationType = ISNULL([variation_type], 0) FROM [dbo].[Insurance_Quote] WITH (READCOMMITTED) WHERE [Insurance_Quote_id] = ISNULL(@QuoteId, -1);

	DECLARE @container TABLE
	(
		[Insurance_Estimator_Item_Id] INT NOT NULL,
		[Insurance_Quote_id] INT NOT NULL,
		[Insurance_Scope_Item_Id] INT NOT NULL,
		[room_name] VARCHAR(100) NOT NULL,
		[short_desc] VARCHAR(300) NULL,
		[long_desc] VARCHAR(2000) NULL,
		[l_unit_name] VARCHAR(100) NOT NULL,
		[m_unit_name] VARCHAR(100) NOT NULL,
		[l_quantity] DECIMAL(18, 2) NOT NULL,
		[m_quantity] DECIMAL(18, 2) NOT NULL,
		[l_rate] DECIMAL(9, 2) NOT NULL,
		[m_rate] DECIMAL(9, 2) NOT NULL,
		[l_total] DECIMAL(9, 2) NOT NULL,
		[m_total] DECIMAL(9, 2) NOT NULL,
		[l_percent] DECIMAL(9, 2) NULL,
		[m_percent] DECIMAL(9, 2) NULL,
		[l_percent_type] TINYINT NULL,
		[m_percent_type] TINYINT NULL,
		[l_cost_total] DECIMAL(9, 2) NULL,
		[m_cost_total] DECIMAL(9, 2) NULL,
		[cost_total] DECIMAL(9, 2) NULL,
		[l_cost_rate] DECIMAL(9, 2) NULL,
		[m_cost_rate] DECIMAL(9, 2) NULL,
		[l_total_with_margin] DECIMAL(9, 2) NULL,
		[m_total_with_margin] DECIMAL(9, 2) NULL,
		[total_with_margin] DECIMAL(9, 2) NULL,
		[total] DECIMAL(9, 2) NULL,
		[created_by] VARCHAR(20) NOT NULL,
		[create_date] DATETIME NOT NULL,
		[Insurance_Trade_Name] VARCHAR(100) NOT NULL,
		[code] VARCHAR(200) NULL,
		[is_lock_for_negative_quote] BIT NULL,
		[old_est_id] INT NULL,
		[neg_l_markup] DECIMAL(9, 2) NULL,
		[neg_m_markup] DECIMAL(9, 2) NULL,
		[neg_from_quote_id] INT NULL,
		[neg_assigned_to_name] VARCHAR(200) NULL,
		[bypass] BIT NULL,
		[room_size_1] DECIMAL(9, 2) NULL,
		[room_size_2] DECIMAL(9, 2) NULL,
		[room_size_3] DECIMAL(9, 2) NULL,
		[IsExtraItem] BIT NULL,
		[Cancelled_Estimator_Item_ID] INT NULL,
		[Damage_Result_Of] INT NULL,
		[Has_Structural_Damage] BIT NULL,
		[DamageText] VARCHAR(50) NULL,
		[MinimumCharge] VARCHAR(255) NULL,
		[updated_by] VARCHAR(20) NULL,
		[updated_date] DATETIME NULL
	);

	DECLARE @myContainer TABLE
	(
		[VersionLabel] VARCHAR(20) NULL,
		[Insurance_Estimator_Item_Id] INT NOT NULL,
		[Insurance_Quote_id] INT NOT NULL,
		[Insurance_Scope_Item_Id] INT NOT NULL,
		[room_name] VARCHAR(100) NOT NULL,
		[short_desc] VARCHAR(300) NULL,
		[long_desc] VARCHAR(2000) NULL,
		[l_unit_name] VARCHAR(100) NOT NULL,
		[m_unit_name] VARCHAR(100) NOT NULL,
		[l_quantity] DECIMAL(18, 2) NOT NULL,
		[m_quantity] DECIMAL(18, 2) NOT NULL,
		[l_rate] DECIMAL(9, 2) NOT NULL,
		[m_rate] DECIMAL(9, 2) NOT NULL,
		[l_total] DECIMAL(9, 2) NOT NULL,
		[m_total] DECIMAL(9, 2) NOT NULL,
		[l_percent] DECIMAL(9, 2) NULL,
		[m_percent] DECIMAL(9, 2) NULL,
		[l_percent_type] TINYINT NULL,
		[m_percent_type] TINYINT NULL,
		[l_cost_total] DECIMAL(9, 2) NULL,
		[m_cost_total] DECIMAL(9, 2) NULL,
		[cost_total] DECIMAL(9, 2) NULL,
		[l_cost_rate] DECIMAL(9, 2) NULL,
		[m_cost_rate] DECIMAL(9, 2) NULL,
		[l_total_with_margin] DECIMAL(9, 2) NULL,
		[m_total_with_margin] DECIMAL(9, 2) NULL,
		[total_with_margin] DECIMAL(9, 2) NULL,
		[total] DECIMAL(9, 2) NULL,
		[created_by] VARCHAR(20) NOT NULL,
		[create_date] DATETIME NOT NULL,
		[Insurance_Trade_Name] VARCHAR(100) NOT NULL,
		[code] VARCHAR(200) NULL,
		[is_lock_for_negative_quote] BIT NULL,
		[old_est_id] INT NULL,
		[neg_l_markup] DECIMAL(9, 2) NULL,
		[neg_m_markup] DECIMAL(9, 2) NULL,
		[neg_from_quote_id] INT NULL,
		[neg_assigned_to_name] VARCHAR(200) NULL,
		[bypass] BIT NULL,
		[room_size_1] DECIMAL(9, 2) NULL,
		[room_size_2] DECIMAL(9, 2) NULL,
		[room_size_3] DECIMAL(9, 2) NULL,
		[IsExtraItem] BIT NULL,
		[Cancelled_Estimator_Item_ID] INT NULL,
		[Damage_Result_Of] INT NULL,
		[Has_Structural_Damage] BIT NULL,
		[DamageText] VARCHAR(50) NULL,
		[MinimumCharge] VARCHAR(255) NULL,
		[updated_by] VARCHAR(20) NULL,
		[updated_date] DATETIME NULL
	);
	
	DECLARE @InsuranceEstimatorId INT;

	DECLARE @InsuranceQuoteId INT;

	DECLARE @InsuranceScopeId INT;

	DECLARE @RoomName VARCHAR(100);

	DECLARE @ShortDescription VARCHAR(300);

	DECLARE @LongDescription VARCHAR(2000);

	DECLARE @LabourUnitName VARCHAR(100);

	DECLARE @MaterialUnitName VARCHAR(100);

	DECLARE @LabourQuantity DECIMAL(9, 2);

	DECLARE @MaterialQuantity DECIMAL(9, 2);

	DECLARE @LabourRate DECIMAL(9, 2);

	DECLARE @MaterialRate DECIMAL(9, 2);

	DECLARE @LabourTotal DECIMAL(9, 2);

	DECLARE @MaterialTotal DECIMAL(9, 2);

	DECLARE @LabourPercent DECIMAL(9, 2);

	DECLARE @MaterialPercent DECIMAL(9, 2);

	DECLARE @LabourPercentType TINYINT;

	DECLARE @MaterialPercentType TINYINT;

	DECLARE @LabourCostTotal DECIMAL(9, 2);

	DECLARE @MaterialCostTotal DECIMAL(9, 2);

	DECLARE @CostTotal DECIMAL(9, 2);

	DECLARE @LabourCostRate DECIMAL(9, 2);

	DECLARE @MaterialCostRate DECIMAL(9, 2);

	DECLARE @LabourMarginTotal DECIMAL(9, 2);

	DECLARE @MaterialMarginTotal DECIMAL(9, 2);

	DECLARE @MarginTotal DECIMAL(9, 2);

	DECLARE @Total DECIMAL(9, 2);

	DECLARE @CreatedBy VARCHAR(20);

	DECLARE @CreatedDate DATETIME;

	DECLARE @InsuranceTradeName VARCHAR(100);

	DECLARE @Code VARCHAR(200);

	DECLARE @IsNegativeQuoteLocked BIT;

	DECLARE @OldEstimatorId INT;

	DECLARE @NegativeLabourMarkup DECIMAL(9, 2);

	DECLARE @NegativeMaterialMarkup DECIMAL(9, 2);

	DECLARE @NegativeFromQuoteId INT;

	DECLARE @NegativeAssignedToName VARCHAR(200);

	DECLARE @Bypass BIT;

	DECLARE @Roomsize1 DECIMAL(9, 2);

	DECLARE @Roomsize2 DECIMAL(9, 2);

	DECLARE @Roomsize3 DECIMAL(9, 2);

	DECLARE @IsExtraItem BIT;

	DECLARE @CancelledEstimatorId INT;

	DECLARE @DamageResultOf INT;

	DECLARE @HasStructuralDamage BIT;

	DECLARE @DamageText VARCHAR(50);

	DECLARE @MinimumCharge VARCHAR(255);

	DECLARE @UpdatedBy VARCHAR(20);

	DECLARE @UpdatedDate DATETIME;

	DECLARE @VersionLabel VARCHAR(20);

	DECLARE @EstimatorRowCount INT;

	/* Processing Section */
	
	INSERT INTO @container
	(
		[Insurance_Estimator_Item_Id],
		[Insurance_Quote_id],
		[Insurance_Scope_Item_Id],
		[room_name],
		[short_desc],
		[long_desc],
		[l_unit_name],
		[m_unit_name],
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
		[l_cost_rate],
		[m_cost_rate],
		[l_total_with_margin],
		[m_total_with_margin],
		[total_with_margin],
		[total],
		[created_by],
		[create_date],
		[Insurance_Trade_Name],
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
		[updated_date]
	)
	SELECT	IE.[Insurance_Estimator_Item_Id],
			IE.[Insurance_Quote_id],
			IE.[Insurance_Scope_Item_Id],
			IR.[name] AS [room_name],
			IE.[short_desc],
			IE.[long_desc],
			LIU.[Name] AS [l_unit_name],
			MIU.[Name] AS [m_unit_name],
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
			IE.[l_cost_rate],
			IE.[m_cost_rate],
			IE.[l_total_with_margin],
			IE.[m_total_with_margin],
			IE.[total_with_margin],
			IE.[total],
			IE.[created_by],
			IE.[create_date],
			IT.[Trade_Name] AS [Insurance_Trade_Name],
			IE.[code],
			IE.[is_lock_for_negative_quote],
			IE.[old_est_id],
			IE.[neg_l_markup],
			IE.[neg_m_markup],
			IE.[neg_from_quote_id],
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
			IE.[updated_date]
	FROM    [dbo].[Insurance_Estimator_Item] IE
			INNER JOIN [dbo].[Insurance_Quote] IQ ON IQ.[Insurance_Quote_id] = IE.[Insurance_Quote_id]
			INNER JOIN [dbo].[Insurance_Room] IR ON IR.[Insurance_Room_Id] = IE.[room_id]
			INNER JOIN [dbo].[Insurance_Unit] LIU ON LIU.[Insurance_Unit_ID] = IE.[l_unit]
			INNER JOIN [dbo].[Insurance_Unit] MIU ON MIU.[Insurance_Unit_ID] = IE.[m_unit]
			INNER JOIN [dbo].[Insurance_Trade] IT ON IT.[Insurance_Trade_ID] = IE.[Insurance_Trade_Id]
	WHERE ( IE.[Insurance_Quote_id] = @QuoteId )
	ORDER BY IE.[Insurance_Estimator_Item_Id];

	SELECT @EstimatorRowCount = COUNT(*) FROM @container;

	OPEN cvReader;

	FETCH NEXT FROM cvReader INTO @InsuranceEstimatorId, @InsuranceQuoteId, @InsuranceScopeId, @RoomName, @ShortDescription, @LongDescription, @LabourUnitName,
							      @MaterialUnitName, @LabourQuantity, @MaterialQuantity, @LabourRate, @MaterialRate, @LabourTotal, @MaterialTotal, @LabourPercent,
								  @MaterialPercent, @LabourPercentType, @MaterialPercentType, @LabourCostTotal, @MaterialCostTotal, @CostTotal, @LabourCostRate,
								  @MaterialCostRate, @LabourMarginTotal, @MaterialMarginTotal, @MarginTotal, @Total, @CreatedBy, @CreatedDate, @InsuranceTradeName, @Code,
								  @IsNegativeQuoteLocked, @OldEstimatorId, @NegativeLabourMarkup, @NegativeMaterialMarkup, @NegativeFromQuoteId, @NegativeAssignedToName,
								  @Bypass, @Roomsize1, @Roomsize2, @Roomsize3, @IsExtraItem, @CancelledEstimatorId, @DamageResultOf, @HasStructuralDamage, @DamageText,
								  @MinimumCharge, @UpdatedBy, @UpdatedDate;

	WHILE ( @@FETCH_STATUS = 0 )
	BEGIN

		IF ( @InsuranceEstimatorId IS NULL ) OR ( @InsuranceQuoteId IS NULL ) OR ( @InsuranceScopeId IS NULL ) OR ( @RoomName IS NULL ) OR ( @LabourUnitName IS NULL) OR
		   ( @MaterialUnitName IS NULL ) OR ( @LabourQuantity IS NULL) OR ( @MaterialQuantity IS NULL ) OR ( @LabourRate IS NULL ) OR ( @MaterialRate IS NULL ) OR
		   ( @LabourTotal IS NULL ) OR ( @MaterialTotal IS NULL ) OR ( @InsuranceTradeName IS NULL )
		BEGIN

			FETCH NEXT FROM cvReader INTO @InsuranceEstimatorId, @InsuranceQuoteId, @InsuranceScopeId, @RoomName, @ShortDescription, @LongDescription, @LabourUnitName,
										  @MaterialUnitName, @LabourQuantity, @MaterialQuantity, @LabourRate, @MaterialRate, @LabourTotal, @MaterialTotal, @LabourPercent,
										  @MaterialPercent, @LabourPercentType, @MaterialPercentType, @LabourCostTotal, @MaterialCostTotal, @CostTotal, @LabourCostRate,
										  @MaterialCostRate, @LabourMarginTotal, @MaterialMarginTotal, @MarginTotal, @Total, @CreatedBy, @CreatedDate, @InsuranceTradeName, @Code,
										  @IsNegativeQuoteLocked, @OldEstimatorId, @NegativeLabourMarkup, @NegativeMaterialMarkup, @NegativeFromQuoteId, @NegativeAssignedToName,
										  @Bypass, @Roomsize1, @Roomsize2, @Roomsize3, @IsExtraItem, @CancelledEstimatorId, @DamageResultOf, @HasStructuralDamage, @DamageText,
										  @MinimumCharge, @UpdatedBy, @UpdatedDate;

			CONTINUE;

		END;

		SET @RoomName = LTRIM(RTRIM(@RoomName));

		SET @LabourUnitName = LTRIM(RTRIM(@LabourUnitName));

		SET @MaterialUnitName = LTRIM(RTRIM(@MaterialUnitName));

		SET @InsuranceTradeName = LTRIM(RTRIM(@InsuranceTradeName));

		IF ( LEN(@RoomName) = 0 ) OR ( LEN(@LabourUnitName) = 0 ) OR ( LEN(@MaterialUnitName) = 0 ) OR ( LEN(@InsuranceTradeName) = 0)
		BEGIN

			FETCH NEXT FROM cvReader INTO @InsuranceEstimatorId, @InsuranceQuoteId, @InsuranceScopeId, @RoomName, @ShortDescription, @LongDescription, @LabourUnitName,
										  @MaterialUnitName, @LabourQuantity, @MaterialQuantity, @LabourRate, @MaterialRate, @LabourTotal, @MaterialTotal, @LabourPercent,
										  @MaterialPercent, @LabourPercentType, @MaterialPercentType, @LabourCostTotal, @MaterialCostTotal, @CostTotal, @LabourCostRate,
										  @MaterialCostRate, @LabourMarginTotal, @MaterialMarginTotal, @MarginTotal, @Total, @CreatedBy, @CreatedDate, @InsuranceTradeName, @Code,
										  @IsNegativeQuoteLocked, @OldEstimatorId, @NegativeLabourMarkup, @NegativeMaterialMarkup, @NegativeFromQuoteId, @NegativeAssignedToName,
										  @Bypass, @Roomsize1, @Roomsize2, @Roomsize3, @IsExtraItem, @CancelledEstimatorId, @DamageResultOf, @HasStructuralDamage, @DamageText,
										  @MinimumCharge, @UpdatedBy, @UpdatedDate;

			CONTINUE;

		END;

		IF ( @EstimatorRowCount = 0 )
		BEGIN

			SELECT @VersionLabel = [version_label] FROM [dbo].[Insurance_Quote] WHERE [Insurance_Quote_id] = @InsuranceQuoteId;

			INSERT INTO @myContainer
			(
				[VersionLabel],
				[Insurance_Estimator_Item_Id],
				[Insurance_Quote_id],
				[Insurance_Scope_Item_Id],
				[room_name],
				[short_desc],
				[long_desc],
				[l_unit_name],
				[m_unit_name],
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
				[l_cost_rate],
				[m_cost_rate],
				[l_total_with_margin],
				[m_total_with_margin],
				[total_with_margin],
				[total],
				[created_by],
				[create_date],
				[Insurance_Trade_Name],
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
				[updated_date]
			)
			VALUES
			(
				@VersionLabel,
				@InsuranceEstimatorId, 
				@InsuranceQuoteId, 
				@InsuranceScopeId, 
				@RoomName, 
				@ShortDescription, 
				@LongDescription, 
				@LabourUnitName,
				@MaterialUnitName, 
				@LabourQuantity, 
				@MaterialQuantity, 
				@LabourRate, 
				@MaterialRate, 
				@LabourTotal, 
				@MaterialTotal, 
				@LabourPercent,
				@MaterialPercent, 
				@LabourPercentType, 
				@MaterialPercentType, 
				@LabourCostTotal, 
				@MaterialCostTotal, 
				@CostTotal, 
				@LabourCostRate,
				@MaterialCostRate, 
				@LabourMarginTotal, 
				@MaterialMarginTotal, 
				@MarginTotal,
				@Total, 
				@CreatedBy, 
				@CreatedDate, 
				@InsuranceTradeName, 
				@Code,
				@IsNegativeQuoteLocked, 
				@OldEstimatorId, 
				@NegativeLabourMarkup, 
				@NegativeMaterialMarkup, 
				@NegativeFromQuoteId, 
				@NegativeAssignedToName,
				@Bypass, 
				@Roomsize1, 
				@Roomsize2, 
				@Roomsize3, 
				@IsExtraItem, 
				@CancelledEstimatorId, 
				@DamageResultOf, 
				@HasStructuralDamage, 
				@DamageText,
				@MinimumCharge, 
				@UpdatedBy, 
				@UpdatedDate
			);

		END
		ELSE
		BEGIN

			IF ( @VariationType = 2 /* Negative insurance work order quote variation */ )
			BEGIN

				IF ( @InsuranceQuoteId = @QuoteId )
				BEGIN

					-- exclude the negative insurance work order quote line items for the same insurance quote identity from the generated resultset

					FETCH NEXT FROM cvReader INTO @InsuranceEstimatorId, @InsuranceQuoteId, @InsuranceScopeId, @RoomName, @ShortDescription, @LongDescription, @LabourUnitName,
												  @MaterialUnitName, @LabourQuantity, @MaterialQuantity, @LabourRate, @MaterialRate, @LabourTotal, @MaterialTotal, @LabourPercent,
												  @MaterialPercent, @LabourPercentType, @MaterialPercentType, @LabourCostTotal, @MaterialCostTotal, @CostTotal, @LabourCostRate,
												  @MaterialCostRate, @LabourMarginTotal, @MaterialMarginTotal, @MarginTotal, @Total, @CreatedBy, @CreatedDate, @InsuranceTradeName, @Code,
												  @IsNegativeQuoteLocked, @OldEstimatorId, @NegativeLabourMarkup, @NegativeMaterialMarkup, @NegativeFromQuoteId, @NegativeAssignedToName,
												  @Bypass, @Roomsize1, @Roomsize2, @Roomsize3, @IsExtraItem, @CancelledEstimatorId, @DamageResultOf, @HasStructuralDamage, @DamageText,
												  @MinimumCharge, @UpdatedBy, @UpdatedDate;

					CONTINUE;

				END
				ELSE
				BEGIN

					-- exclude the negative insurance work order quote line items for the parent insurance quote line item identity

					IF EXISTS(SELECT 1 FROM @container WHERE ( [old_est_id] IS NOT NULL ) AND ( [old_est_id] = @InsuranceEstimatorId ))
					BEGIN

						FETCH NEXT FROM cvReader INTO @InsuranceEstimatorId, @InsuranceQuoteId, @InsuranceScopeId, @RoomName, @ShortDescription, @LongDescription, @LabourUnitName,
													  @MaterialUnitName, @LabourQuantity, @MaterialQuantity, @LabourRate, @MaterialRate, @LabourTotal, @MaterialTotal, @LabourPercent,
													  @MaterialPercent, @LabourPercentType, @MaterialPercentType, @LabourCostTotal, @MaterialCostTotal, @CostTotal, @LabourCostRate,
													  @MaterialCostRate, @LabourMarginTotal, @MaterialMarginTotal, @MarginTotal, @Total, @CreatedBy, @CreatedDate, @InsuranceTradeName, @Code,
													  @IsNegativeQuoteLocked, @OldEstimatorId, @NegativeLabourMarkup, @NegativeMaterialMarkup, @NegativeFromQuoteId, @NegativeAssignedToName,
													  @Bypass, @Roomsize1, @Roomsize2, @Roomsize3, @IsExtraItem, @CancelledEstimatorId, @DamageResultOf, @HasStructuralDamage, @DamageText,
													  @MinimumCharge, @UpdatedBy, @UpdatedDate;

						CONTINUE;

					END;

					SELECT @VersionLabel = [version_label] FROM [dbo].[Insurance_Quote] WHERE [Insurance_Quote_id] = @InsuranceQuoteId;

					INSERT INTO @myContainer
					(
						[VersionLabel],
						[Insurance_Estimator_Item_Id],
						[Insurance_Quote_id],
						[Insurance_Scope_Item_Id],
						[room_name],
						[short_desc],
						[long_desc],
						[l_unit_name],
						[m_unit_name],
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
						[l_cost_rate],
						[m_cost_rate],
						[l_total_with_margin],
						[m_total_with_margin],
						[total_with_margin],
						[total],
						[created_by],
						[create_date],
						[Insurance_Trade_Name],
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
						[updated_date]
					)
					VALUES
					(
						@VersionLabel,
						@InsuranceEstimatorId, 
						@InsuranceQuoteId, 
						@InsuranceScopeId, 
						@RoomName, 
						@ShortDescription, 
						@LongDescription, 
						@LabourUnitName,
						@MaterialUnitName, 
						@LabourQuantity, 
						@MaterialQuantity, 
						@LabourRate, 
						@MaterialRate, 
						@LabourTotal, 
						@MaterialTotal, 
						@LabourPercent,
						@MaterialPercent, 
						@LabourPercentType, 
						@MaterialPercentType, 
						@LabourCostTotal, 
						@MaterialCostTotal, 
						@CostTotal, 
						@LabourCostRate,
						@MaterialCostRate, 
						@LabourMarginTotal, 
						@MaterialMarginTotal, 
						@MarginTotal,
						@Total, 
						@CreatedBy, 
						@CreatedDate, 
						@InsuranceTradeName, 
						@Code,
						@IsNegativeQuoteLocked, 
						@OldEstimatorId, 
						@NegativeLabourMarkup, 
						@NegativeMaterialMarkup, 
						@NegativeFromQuoteId, 
						@NegativeAssignedToName,
						@Bypass, 
						@Roomsize1, 
						@Roomsize2, 
						@Roomsize3, 
						@IsExtraItem, 
						@CancelledEstimatorId, 
						@DamageResultOf, 
						@HasStructuralDamage, 
						@DamageText,
						@MinimumCharge, 
						@UpdatedBy, 
						@UpdatedDate
					);

				END;

			END
			ELSE /* Positive insurance work order quote variation or insurance work order quote revision */
			BEGIN

				IF NOT EXISTS
				(
					SELECT 1 FROM @container 
					WHERE ( NOT ((( [Cancelled_Estimator_Item_ID] IS NULL ) AND ( @CancelledEstimatorId IS NOT NULL )) OR (( [Cancelled_Estimator_Item_ID] IS NOT NULL ) AND ( @CancelledEstimatorId IS NULL ))) )
					AND ( NOT ( (( [code] IS NULL ) AND ( @Code IS NOT NULL )) OR (( [code] IS NOT NULL ) AND ( @Code IS NULL )) OR (( [code] IS NOT NULL ) AND ( @Code IS NOT NULL ) AND ( LTRIM(RTRIM([code])) <> LTRIM(RTRIM(@Code)) )) ) )
					AND ( NOT ( (( [cost_total] IS NULL ) AND ( @CostTotal IS NOT NULL )) OR (( [cost_total] IS NOT NULL ) AND ( @CostTotal IS NULL )) OR (( [cost_total] IS NOT NULL ) AND ( @CostTotal IS NOT NULL ) AND ( CAST([cost_total] AS DECIMAL(9, 2)) <> CAST(@CostTotal AS DECIMAL(9, 2)) )) ) )
					AND ( NOT ( (( [room_size_1] IS NULL ) AND ( @Roomsize1 IS NOT NULL )) OR (( [room_size_1] IS NOT NULL ) AND ( @Roomsize1 IS NULL )) OR ( (( [room_size_1] IS NOT NULL ) AND ( @Roomsize1 IS NOT NULL )) AND ( CAST([room_size_1] AS DECIMAL(9, 2)) <> CAST(@Roomsize1 AS DECIMAL(9, 2)) ) ) ) )
					AND ( NOT ( (( [room_size_2] IS NULL ) AND ( @Roomsize2 IS NOT NULL )) OR (( [room_size_2] IS NOT NULL ) AND ( @Roomsize2 IS NULL )) OR ( (( [room_size_2] IS NOT NULL ) AND ( @Roomsize2 IS NOT NULL )) AND ( CAST([room_size_2] AS DECIMAL(9, 2)) <> CAST(@Roomsize2 AS DECIMAL(9, 2)) ) ) ) )
					AND ( NOT ( (( [room_size_3] IS NULL ) AND ( @Roomsize3 IS NOT NULL )) OR (( [room_size_3] IS NOT NULL ) AND ( @Roomsize3 IS NULL )) OR ( (( [room_size_3] IS NOT NULL ) AND ( @Roomsize3 IS NOT NULL )) AND ( CAST([room_size_3] AS DECIMAL(9, 2)) <> CAST(@Roomsize3 AS DECIMAL(9, 2)) ) ) ) )
					AND ( NOT ( [Insurance_Scope_Item_Id] <> @InsuranceScopeId ) )
					AND ( NOT ( (( [bypass] IS NULL ) AND ( @Bypass IS NOT NULL )) OR (( [bypass] IS NOT NULL ) AND ( @Bypass IS NULL )) OR (( [bypass] IS NOT NULL ) AND ( @Bypass IS NOT NULL ) AND ( [bypass] <> @Bypass )) ) )
					AND ( NOT ( (( [IsExtraItem] IS NULL ) AND ( @IsExtraItem IS NOT NULL )) OR (( [IsExtraItem] IS NOT NULL ) AND ( @IsExtraItem IS NULL )) OR ( (( [IsExtraItem] IS NOT NULL ) AND ( @IsExtraItem IS NOT NULL ) AND ( CAST([IsExtraItem] AS BIT) <> CAST(@IsExtraItem AS BIT) )) ) ) )
					AND ( NOT ( (( [is_lock_for_negative_quote] IS NULL ) AND  ( @IsNegativeQuoteLocked IS NOT NULL )) OR (( [is_lock_for_negative_quote] IS NOT NULL ) AND  ( @IsNegativeQuoteLocked IS NULL )) OR ( (( [is_lock_for_negative_quote] IS NOT NULL ) AND  ( @IsNegativeQuoteLocked IS NOT NULL ) AND ( CAST([is_lock_for_negative_quote] AS BIT) <> CAST(@IsNegativeQuoteLocked AS BIT) )) ) ) )
					AND ( NOT ( (( [l_cost_rate] IS NULL ) AND ( @LabourCostRate IS NOT NULL )) OR (( [l_cost_rate] IS NOT NULL ) AND ( @LabourCostRate IS NULL )) OR ( (( [l_cost_rate] IS NOT NULL ) AND ( @LabourCostRate IS NOT NULL ) AND ( CAST([l_cost_rate] AS DECIMAL(9, 2)) <> CAST(@LabourCostRate AS DECIMAL(9, 2)) )) ) ) )
					AND ( NOT ( (( [m_cost_rate] IS NULL ) AND ( @MaterialCostRate IS NOT NULL )) OR (( [m_cost_rate] IS NOT NULL ) AND ( @MaterialCostRate IS NULL )) OR ( (( [m_cost_rate] IS NOT NULL ) AND ( @MaterialCostRate IS NOT NULL ) AND ( CAST([m_cost_rate] AS DECIMAL(9, 2)) <> CAST(@MaterialCostRate AS DECIMAL(9, 2)) )) ) ) )
					AND ( NOT ( (( [l_cost_total] IS NULL ) AND ( @LabourCostTotal IS NOT NULL )) OR (( [l_cost_total] IS NOT NULL ) AND ( @LabourCostTotal IS NULL )) OR ( (( [l_cost_total] IS NOT NULL ) AND ( @LabourCostTotal IS NOT NULL ) AND ( CAST([l_cost_total] AS DECIMAL(9, 2)) <> CAST(@LabourCostTotal AS DECIMAL(9, 2)) )) ) ) )
					AND ( NOT ( (( [m_cost_total] IS NULL ) AND ( @MaterialCostTotal IS NOT NULL )) OR (( [m_cost_total] IS NOT NULL ) AND ( @MaterialCostTotal IS NULL )) OR ( (( [m_cost_total] IS NOT NULL ) AND ( @MaterialCostTotal IS NOT NULL ) AND ( CAST([m_cost_total] AS DECIMAL(9, 2)) <> CAST(@MaterialCostTotal AS DECIMAL(9, 2)) )) ) ) )
					AND ( NOT ( CAST([l_quantity] AS DECIMAL(18, 2)) <> CAST(@LabourQuantity AS DECIMAL(18, 2)) ) )
					AND ( NOT ( CAST([m_quantity] AS DECIMAL(18, 2)) <> CAST(@MaterialQuantity AS DECIMAL(18, 2)) ) )
					AND ( NOT ( CAST([l_rate] AS DECIMAL(9, 2)) <> CAST(@LabourRate AS DECIMAL(9, 2)) ) )
					AND ( NOT ( CAST([m_rate] AS DECIMAL(9, 2)) <> CAST(@MaterialRate AS DECIMAL(9, 2)) ) )
					AND ( NOT ( CAST([l_total] AS DECIMAL(9, 2)) <> CAST(@LabourTotal AS DECIMAL(9, 2)) ) )
					AND ( NOT ( CAST([m_total] AS DECIMAL(9, 2)) <> CAST(@MaterialTotal AS DECIMAL(9, 2)) ) )
					AND ( NOT ( CAST([total] AS DECIMAL(9, 2)) <> CAST(@Total AS DECIMAL(9, 2)) ) )
					AND ( NOT ( (( [long_desc] IS NULL ) AND ( @LongDescription IS NOT NULL )) OR (( [long_desc] IS NOT NULL ) AND ( @LongDescription IS NULL )) OR ( (( [long_desc] IS NOT NULL ) AND ( @LongDescription IS NOT NULL ) AND ( LTRIM(RTRIM([long_desc])) <> LTRIM(RTRIM(@LongDescription)) ) ) )  ) )
					AND ( NOT ( (( [short_desc] IS NULL ) AND ( @ShortDescription IS NOT NULL )) OR (( [short_desc] IS NOT NULL ) AND ( @ShortDescription IS NULL )) OR ( (( [short_desc] IS NOT NULL ) AND ( @ShortDescription IS NOT NULL ) AND ( LTRIM(RTRIM([short_desc])) <> LTRIM(RTRIM(@ShortDescription)) ) ) )  ) )
					AND ( NOT ( (( [neg_assigned_to_name] IS NULL ) AND ( @NegativeAssignedToName IS NOT NULL )) OR (( [neg_assigned_to_name] IS NOT NULL ) AND ( @NegativeAssignedToName IS NULL )) OR ( (( [neg_assigned_to_name] IS NOT NULL ) AND ( @NegativeAssignedToName IS NOT NULL ) AND ( LTRIM(RTRIM([neg_assigned_to_name])) <> LTRIM(RTRIM(@NegativeAssignedToName)) ) ) )  ) )
					AND ( NOT ( (( [neg_l_markup] IS NULL ) AND ( @NegativeLabourMarkup IS NOT NULL )) OR (( [neg_l_markup] IS NOT NULL ) AND ( @NegativeLabourMarkup IS NULL )) OR ( (( [neg_l_markup] IS NOT NULL ) AND ( @NegativeLabourMarkup IS NOT NULL ) AND ( CAST([neg_l_markup] AS DECIMAL(9, 2)) <> CAST(@NegativeLabourMarkup AS DECIMAL(9, 2)) )) ) ) )
					AND ( NOT ( (( [neg_m_markup] IS NULL ) AND ( @NegativeMaterialMarkup IS NOT NULL )) OR (( [neg_m_markup] IS NOT NULL ) AND ( @NegativeMaterialMarkup IS NULL )) OR ( (( [neg_m_markup] IS NOT NULL ) AND ( @NegativeMaterialMarkup IS NOT NULL ) AND ( CAST([neg_m_markup] AS DECIMAL(9, 2)) <> CAST(@NegativeMaterialMarkup AS DECIMAL(9, 2)) )) ) ) )
					AND ( NOT ( (( [MinimumCharge] IS NULL ) AND ( @MinimumCharge IS NOT NULL )) OR (( [MinimumCharge] IS NOT NULL ) AND ( @MinimumCharge IS NULL )) OR ( (( [MinimumCharge] IS NOT NULL ) AND ( @MinimumCharge IS NOT NULL ) AND ( LTRIM(RTRIM([MinimumCharge])) <> LTRIM(RTRIM(@MinimumCharge)) ) ) )  ) )

				)
				BEGIN

					SELECT @VersionLabel = [version_label] FROM [dbo].[Insurance_Quote] WHERE [Insurance_Quote_id] = @InsuranceQuoteId;

					INSERT INTO @myContainer
					(
						[VersionLabel],
						[Insurance_Estimator_Item_Id],
						[Insurance_Quote_id],
						[Insurance_Scope_Item_Id],
						[room_name],
						[short_desc],
						[long_desc],
						[l_unit_name],
						[m_unit_name],
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
						[l_cost_rate],
						[m_cost_rate],
						[l_total_with_margin],
						[m_total_with_margin],
						[total_with_margin],
						[total],
						[created_by],
						[create_date],
						[Insurance_Trade_Name],
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
						[updated_date]
					)
					VALUES
					(
						@VersionLabel,
						@InsuranceEstimatorId, 
						@InsuranceQuoteId, 
						@InsuranceScopeId, 
						@RoomName, 
						@ShortDescription, 
						@LongDescription, 
						@LabourUnitName,
						@MaterialUnitName, 
						@LabourQuantity, 
						@MaterialQuantity, 
						@LabourRate, 
						@MaterialRate, 
						@LabourTotal, 
						@MaterialTotal, 
						@LabourPercent,
						@MaterialPercent, 
						@LabourPercentType, 
						@MaterialPercentType, 
						@LabourCostTotal, 
						@MaterialCostTotal, 
						@CostTotal, 
						@LabourCostRate,
						@MaterialCostRate, 
						@LabourMarginTotal, 
						@MaterialMarginTotal, 
						@MarginTotal,
						@Total, 
						@CreatedBy, 
						@CreatedDate, 
						@InsuranceTradeName, 
						@Code,
						@IsNegativeQuoteLocked, 
						@OldEstimatorId, 
						@NegativeLabourMarkup, 
						@NegativeMaterialMarkup, 
						@NegativeFromQuoteId, 
						@NegativeAssignedToName,
						@Bypass, 
						@Roomsize1, 
						@Roomsize2, 
						@Roomsize3, 
						@IsExtraItem, 
						@CancelledEstimatorId, 
						@DamageResultOf, 
						@HasStructuralDamage, 
						@DamageText,
						@MinimumCharge, 
						@UpdatedBy, 
						@UpdatedDate
					);

				END
				ELSE
				BEGIN

					-- A COPY OF THE PREVIOUS COPY OPERATION TO THE LINE ITEM (INSURANCE ESTIMATOR QUOTE ESTIMATION) WILL BE APPLICABLE FOR SELECTION

					IF ( @InsuranceQuoteId <> @QuoteId )
					BEGIN

						SELECT @VersionLabel = [version_label] FROM [dbo].[Insurance_Quote] WHERE [Insurance_Quote_id] = @InsuranceQuoteId;

						INSERT INTO @myContainer
						(
							[VersionLabel],
							[Insurance_Estimator_Item_Id],
							[Insurance_Quote_id],
							[Insurance_Scope_Item_Id],
							[room_name],
							[short_desc],
							[long_desc],
							[l_unit_name],
							[m_unit_name],
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
							[l_cost_rate],
							[m_cost_rate],
							[l_total_with_margin],
							[m_total_with_margin],
							[total_with_margin],
							[total],
							[created_by],
							[create_date],
							[Insurance_Trade_Name],
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
							[updated_date]
						)
						VALUES
						(
							@VersionLabel,
							@InsuranceEstimatorId, 
							@InsuranceQuoteId, 
							@InsuranceScopeId, 
							@RoomName, 
							@ShortDescription, 
							@LongDescription, 
							@LabourUnitName,
							@MaterialUnitName, 
							@LabourQuantity, 
							@MaterialQuantity, 
							@LabourRate, 
							@MaterialRate, 
							@LabourTotal, 
							@MaterialTotal, 
							@LabourPercent,
							@MaterialPercent, 
							@LabourPercentType, 
							@MaterialPercentType, 
							@LabourCostTotal, 
							@MaterialCostTotal, 
							@CostTotal, 
							@LabourCostRate,
							@MaterialCostRate, 
							@LabourMarginTotal, 
							@MaterialMarginTotal, 
							@MarginTotal,
							@Total, 
							@CreatedBy, 
							@CreatedDate, 
							@InsuranceTradeName, 
							@Code,
							@IsNegativeQuoteLocked, 
							@OldEstimatorId, 
							@NegativeLabourMarkup, 
							@NegativeMaterialMarkup, 
							@NegativeFromQuoteId, 
							@NegativeAssignedToName,
							@Bypass, 
							@Roomsize1, 
							@Roomsize2, 
							@Roomsize3, 
							@IsExtraItem, 
							@CancelledEstimatorId, 
							@DamageResultOf, 
							@HasStructuralDamage, 
							@DamageText,
							@MinimumCharge, 
							@UpdatedBy, 
							@UpdatedDate
						);

					END; -- Different insurance work order quote identity

				END;

			END; -- Insurance work order quote variation check

		END;

		FETCH NEXT FROM cvReader INTO @InsuranceEstimatorId, @InsuranceQuoteId, @InsuranceScopeId, @RoomName, @ShortDescription, @LongDescription, @LabourUnitName,
									  @MaterialUnitName, @LabourQuantity, @MaterialQuantity, @LabourRate, @MaterialRate, @LabourTotal, @MaterialTotal, @LabourPercent,
									  @MaterialPercent, @LabourPercentType, @MaterialPercentType, @LabourCostTotal, @MaterialCostTotal, @CostTotal, @LabourCostRate,
									  @MaterialCostRate, @LabourMarginTotal, @MaterialMarginTotal, @MarginTotal, @Total, @CreatedBy, @CreatedDate, @InsuranceTradeName, @Code,
									  @IsNegativeQuoteLocked, @OldEstimatorId, @NegativeLabourMarkup, @NegativeMaterialMarkup, @NegativeFromQuoteId, @NegativeAssignedToName,
									  @Bypass, @Roomsize1, @Roomsize2, @Roomsize3, @IsExtraItem, @CancelledEstimatorId, @DamageResultOf, @HasStructuralDamage, @DamageText,
									  @MinimumCharge, @UpdatedBy, @UpdatedDate;

	END; -- WHILE BEGIN

	CLOSE cvReader;

	DEALLOCATE cvReader;

	SELECT  [VersionLabel],
			[Insurance_Estimator_Item_Id] AS [Id],
			[Insurance_Quote_id] AS [InsuranceQuoteId],
			[Insurance_Scope_Item_Id] AS [InsuranceScopeId],
			[room_name] AS [InsuranceRoom],
			[short_desc] [ShortDescription],
			[long_desc] AS [Description],
			[l_unit_name] AS [LabourUnit],
			[m_unit_name] AS [MaterialUnit],
			[l_quantity] AS [LabourQuantity],
			[m_quantity] AS [MaterialQuantity],
			[l_rate] AS [LabourRate],
			[m_rate] AS [MaterialRate],
			[l_total] AS [LabourTotal],
			[m_total] AS [MaterialTotal],
			[l_percent] AS [LabourPercent],
			[m_percent] AS [MaterialPercent],
			[l_percent_type] AS [LabourPercentType],
			[m_percent_type] AS [MaterialPercentType],
			[l_cost_total] AS [LabourTotal],
			[m_cost_total] AS [MaterialTotal],
			[cost_total] AS [Total],
			[l_cost_rate] AS [LabourCostRate],
			[m_cost_rate] AS [MaterialCostRate],
			[l_total_with_margin] AS [LabourMarkupCost],
			[m_total_with_margin] AS [MaterialMarkupCost],
			[total_with_margin] AS [TotalMarkupCost],
			[total] AS [Total],
			[created_by] AS [CreatedBy],
			[create_date] AS [CreationDate],
			[Insurance_Trade_Name] AS [InsuranceTrade],
			[code] AS [Code],
			[is_lock_for_negative_quote] AS [IsNegativeQuoteLocked],
			[old_est_id] AS [Parent],
			[neg_l_markup] AS [NegativeLabourMarkup],
			[neg_m_markup] AS [NegativeMaterialMarkup],
			[neg_from_quote_id] AS [NegativeInsuranceQuoteId],
			[neg_assigned_to_name] AS [NegativeAssignedName],
			[bypass] AS [Bypass],
			[room_size_1] AS [Width],
			[room_size_2] AS [Height],
			[room_size_3] AS [Length],
			[IsExtraItem],
			[Cancelled_Estimator_Item_ID] AS [CancelledInsuranceEstimatorId],
			[Damage_Result_Of] AS [Damage Reason],
			[Has_Structural_Damage] AS [HasStructuralDamage],
			[DamageText] AS [Damage Text],
			[MinimumCharge],
			[updated_by] AS [UpdatedBy],
			[updated_date] AS [Updated On]
	FROM @myContainer
	ORDER BY [VersionLabel], [InsuranceRoom];

	SET NOCOUNT OFF;

END;
GO