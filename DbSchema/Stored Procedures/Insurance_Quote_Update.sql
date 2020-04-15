USE [visionary];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Quote_Update'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Quote_Update];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 25 February 2013
-- Description:	Updates the registered insurance quote details within the database schema.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Quote_Update]
(
	@QuoteId INT,
	@OrderId INT,
	@SupplierReference VARCHAR(20),
	@ContactDate DATETIME,
	@SiteAttendDate DATETIME,
	@InsuredAttended BIT,
	@RepAttended BIT,
	@RepresentativeName VARCHAR(100),
	@NobodyAttended BIT,
	@AttendanceNotApplicable BIT,
	@BuildingType VARCHAR(50),
	@DesignType VARCHAR(50),
	@ConstructionType VARCHAR(50),
	@RoofType VARCHAR(50),
	@Age INT,
	@IsConditionAcceptable BIT,
	@SquareMetres INT,
	@IsBungalow BIT,
	@IsFibroShed BIT,
	@IsBrickShed BIT,
	@IsMetalShed BIT,
	@IsMetalGarage BIT,
	@IsAboveGroundPool BIT,
	@IsPergola BIT,
	@IsTimberCarport BIT,
	@IsBrickCarport BIT,
	@IsDogKennel BIT,
	@IsExternalLaundry BIT,
	@IsBelowGroundPool BIT,
	@IsExternalWc BIT,
	@IsBarbequeArea BIT,
	@IsPoolRoom BIT,
	@IsStoreRoom BIT,
	@IsCubbyHouse BIT,
	@IsPumpRoom BIT,
	@IsGrannyFlat BIT,
	@IsFibroGarage BIT,
	@IsBrickGarage BIT,
	@IsMetalCarport BIT,
	@IsScreenEnclosure BIT,
	@IsFence BIT,
	@EstimatedLabourMarkup DECIMAL(9, 2),
	@EstimatedMaterialMarkup DECIMAL(9, 2),
	@EstimatedRoomCost DECIMAL(9, 2),
	@EstimatedCost DECIMAL(9, 2),
	@EstimatedRoomSalePrice DECIMAL(9, 2),
	@EstimatedJobSalePrice DECIMAL(9, 2),
	@EstimatedRoomProfit DECIMAL(9, 2),
	@EstimatedJobProfit DECIMAL(9, 2),
	@ProfitPercentage DECIMAL(9, 2),
	@TotalLabour DECIMAL(9, 2),
	@TotalMaterial DECIMAL(9, 2),
	@TotalRoomTrade DECIMAL(9, 2),
	@TotalJobTrade DECIMAL(9, 2),
	@InsuranceTradeId INT,
	@InsuranceRoomId INT,
	@ClientDiscussion VARCHAR(MAX),
	@DamageDescription VARCHAR(MAX),
	@Conclusion VARCHAR(MAX),
	@Estimate DECIMAL(9, 2),
	@MaintenanceDefectsNotCovered VARCHAR(MAX),
	@HasInsurerAdvisedNotCovered VARCHAR(MAX),
	@EstimateNotCovered DECIMAL(9, 2),
	@RecoveryDetails VARCHAR(1000),
	@TotalEstimate DECIMAL(9, 2),
	--@FileName VARCHAR(200),
	--@Contents IMAGE,
	--@ProceedFileName VARCHAR(200),
	--@ProceedDocument IMAGE,
	--@SignedFileName VARCHAR(200),
	--@SignedDocument IMAGE,
	@NegativeQuoteId INT,
	@IsFromSearch BIT,
	@IsFakeNegativeQuote BIT,
	@IsFakeBypass BIT,
	@VariationCheckedBy VARCHAR(20),
	@VariationCheckedDate DATETIME,
	@EstimatedJobSalePriceWithWarranty DECIMAL(9, 2),
	@HomeHabitable VARCHAR(50),
	@VacateDays INT,
	@ContainsAsbestos VARCHAR(10),
	@HomeWarrantyRequired BIT,
	@HomeWarranty DECIMAL(9, 2),
	@Circumstances VARCHAR(MAX),
	@ResultantDamage VARCHAR(MAX),
	@Comments VARCHAR(MAX),
	@MaintenanceIssuesNoted BIT,
	@MaintenanceDefects VARCHAR(MAX),
	@HasInsurerAdvised VARCHAR(20),
	@RepairCost DECIMAL(9, 2),
	@CoveredClaim VARCHAR(200),
	@IsActionRequired VARCHAR(20),
	@Recommendation VARCHAR(50),
	@ActionDescription VARCHAR(1000),
	@ContentsInvolved VARCHAR(20),
	@ContentDescription VARCHAR(1000),
	@IsIncidentConfirmed BIT,
	@IsInsuredAmountAdequate BIT,
	@IsInsuredAdvised BIT,
	@IsInsuredAwareOfRepairs BIT,
	@IsAssessmentRequired BIT,
	@IsMakeSafe BIT,
	@IsClientWillingToProceed BIT,
	@QuoteStatus VARCHAR(50),
	@VariationType INT = NULL,
	@Version VARCHAR(20) = NULL,
	@SignNumber INT = NULL,
	@SignedByClient BIT = NULL,
	@DamageMatchExplanation BIT = NULL,
	@HasStructuralDamage BIT = NULL,
	@DamageResultOf INT = NULL,
	@DamageDate DATETIME = NULL,
	@IsAuthorisedRepairsProceeding BIT = NULL,
	@DamageDate2 DATETIME = NULL,
	@UserName VARCHAR(50) = NULL,
	@ValidateEntry BIT = 1
)
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	IF ( ISNULL(@ValidateEntry, 0) <> 0 )
	BEGIN

		IF ( @OrderId IS NULL ) OR ( NOT EXISTS(SELECT 1 FROM [dbo].[ORDERS] WITH (READCOMMITTED) WHERE [ORDER_ID] = @OrderId) )
		BEGIN
			IF ( @OrderId IS NOT NULL ) RAISERROR('The work order reference identity %d has not been issued within Visionary', 16, 2, @OrderId) WITH NOWAIT;
			RETURN @QuoteId;
		END
		ELSE IF ( @OrderId IS NOT NULL ) AND ( @QuoteId IS NULL )
		BEGIN
			RAISERROR('The work order quote reference identity was not supplied for the insurance work order reference identity %d', 16, 2, @OrderId) WITH NOWAIT;
		END
		ELSE IF ( @OrderId IS NOT NULL ) AND ( @QuoteId IS NOT NULL )
		BEGIN
			IF ( NOT EXISTS(SELECT 1 FROM [dbo].[Insurance_Quote] WITH (READCOMMITTED) WHERE [Insurance_Quote_id] = @QuoteId AND [Order_id] = @OrderId) )
				RAISERROR('The work order quote reference identity %d has not been registered for the insurance work order reference identity %d', 16, 2, @QuoteId, @OrderId) WITH NOWAIT;
		END;

	END;

	DECLARE @Transaction INT;

	SET @Transaction = @@TRANCOUNT;

	DECLARE @Error INT;

	SET @Error = @@ERROR;

	-- Supplementary settings

	DECLARE @buildingTypeId INT;

	SELECT @buildingTypeId = [id] FROM [dbo].[Insurance_BuildingType] WHERE [name] = LTRIM(RTRIM(ISNULL(@BuildingType, '')));

	DECLARE @designTypeId INT;

	SELECT @designTypeId = [id] FROM [dbo].[Insurance_DesignType] WHERE [name] = LTRIM(RTRIM(ISNULL(@DesignType, '')));

	DECLARE @constructionTypeId INT;

	SELECT @constructionTypeId = [id] FROM [dbo].[Insurance_ConstructionType] WHERE [name] = LTRIM(RTRIM(ISNULL(@ConstructionType, '')));

	DECLARE @roofTypeId INT;

	SELECT @roofTypeId = [id] FROM [dbo].[Insurance_RoofType] WHERE [name] = LTRIM(RTRIM(ISNULL(@RoofType, '')));

	DECLARE @status INT;

	SET @status = NULL;

	IF ( @QuoteStatus IS NOT NULL ) AND ( LEN(LTRIM(RTRIM(@QuoteStatus))) > 0 )
		SELECT @status = [id] FROM [dbo].[Insurance_QuoteStatus] WHERE [name] = LTRIM(RTRIM(@QuoteStatus));

	DECLARE @HomeOccupancy INT;

	SET @HomeOccupancy = 0;

	SET @HomeHabitable = LTRIM(RTRIM(ISNULL(@HomeHabitable, '')));

	IF ( @HomeHabitable = 'Home Habitable' ) OR ( @HomeHabitable = 'Home Un-Inhabitable' )
		SELECT @HomeOccupancy = [id] FROM [Insurance_HomeHabitable] WHERE [name] = @HomeHabitable;
	ELSE IF  ( @HomeHabitable = 'Vacate for Repairs' )
		SELECT @HomeOccupancy = [id] FROM [Insurance_HomeHabitable] WHERE [name] = 'Home needs to be vacated during repairs';

	DECLARE @MyRecommendation INT;

	IF ( @Recommendation IS NULL ) OR ( LEN(@Recommendation) = 0 )
		SET @Recommendation = '';
	ELSE IF ( LTRIM(RTRIM(@Recommendation)) = 'Unsure / Refer to Insurer' )
		SET @Recommendation = 'Unsure';
	ELSE IF NOT (( LTRIM(RTRIM(@Recommendation)) = 'Decline' ) OR ( LTRIM(RTRIM(@Recommendation)) = 'Accept' ))
		SET @Recommendation = '';

	SELECT @MyRecommendation = [id] FROM [dbo].[Insurance_Recommendation] WHERE [name] = @Recommendation;

	IF ( @Transaction = 0 ) BEGIN TRANSACTION;

	BEGIN TRY

		UPDATE [dbo].[Insurance_Quote] WITH (READCOMMITTED) SET
			[details_and_Circumstances] = @Circumstances,
			[comments] = @Comments,
			[supplier_ref] = @SupplierReference,
			[incident_confirmed] = @IsIncidentConfirmed,
			[initial_contact_datetime] = @ContactDate,
			[site_attend_datetime] = @SiteAttendDate,
			[attend_with_insured] = @InsuredAttended,
			[attend_with_rep] = @RepAttended,
			[reps_name] = @RepresentativeName,
			[attend_with_noone] = @NobodyAttended,
			[attend_na] = @AttendanceNotApplicable,
			[sum_insured_adequate] = @IsInsuredAmountAdequate,
			[make_safe] = @IsMakeSafe,
			[has_insured_been_advised] = @IsInsuredAdvised,
			[is_insured_aware_of_repairs] = @IsInsuredAwareOfRepairs,
			[cost_of_repairs] = @RepairCost,
			[recommendation] = @MyRecommendation,
			[client_willing_to_proceed] = @IsClientWillingToProceed,
			[building_type] = @buildingTypeId,
			[design_type] = @designTypeId,
			[construction_type] = @constructionTypeId,
			[roof_type] = @roofTypeId,
			[square_metres] = @SquareMetres,
			[age] = @Age,
			[overall_condition_acceptable] = @IsConditionAcceptable,
			[is_iag_assessment_required] = @IsAssessmentRequired,
			[ob_bungalow] = @IsBungalow,
			[ob_fibro_shed] = @IsFibroShed,
			[ob_brick_shed] = @IsBrickShed,
			[ob_metal_shed] = @IsMetalShed,
			[ob_metal_garage] = @IsMetalGarage,
			[ob_above_ground_pool] = @IsAboveGroundPool,
			[ob_pergola] = @IsPergola,
			[ob_timber_carport] = @IsTimberCarport,
			[ob_brick_carport] = @IsBrickCarport,
			[ob_dog_kennel] = @IsDogKennel,
			[ob_external_laundry] = @IsExternalLaundry,
			[ob_below_ground_pool] = @IsBelowGroundPool,
			[ob_external_wc] = @IsExternalWc,
			[ob_bbq_area] = @IsBarbequeArea,
			[ob_pool_room] = @IsPoolRoom,
			[ob_store_room] = @IsStoreRoom,
			[ob_cubby_house] = @IsCubbyHouse,
			[ob_pump_room] = @IsPumpRoom,
			[ob_granny_flat] = @IsGrannyFlat,
			[ob_brick_garage] = @IsBrickGarage,
			[ob_fibro_garage] = @IsFibroGarage,
			[ob_carport_metal] = @IsMetalCarport,
			[ob_screen_enclosures] = @IsScreenEnclosure,
			[ob_fence] = @IsFence,
			[est_labour_markup] = @EstimatedLabourMarkup,
			[est_material_markup] = @EstimatedMaterialMarkup,
			[est_room_cost] = @EstimatedRoomCost,
			[est_job_cost] = @EstimatedCost,
			[est_room_sale_price] = @EstimatedRoomSalePrice,
			[est_job_sale_price] = @EstimatedJobSalePrice,
			[est_room_profit] = @EstimatedRoomProfit,
			[est_job_profit] = @EstimatedJobProfit,
			[profit_percentage] = @ProfitPercentage,
			[labour_total] = @TotalLabour,
			[material_total] = @TotalMaterial,
			[room_trade_total] = @TotalRoomTrade,
			[job_trade_total] = @TotalJobTrade,
			[insurance_trade_id] = @InsuranceTradeId,
			[insurance_room_id] = @InsuranceRoomId,
			[sun_client_discussion] = @ClientDiscussion,
			[sun_cause_of_damage] = @DamageDescription,
			[sun_conclusion] = @Conclusion,
			[sun_estimate] = @Estimate,
			[sun_maintenance_defects_not_covered] = @MaintenanceDefectsNotCovered,
			[sun_insured_advised_not_covered] = @HasInsurerAdvisedNotCovered,
			[sun_estimate_not_covered] = @EstimateNotCovered,
			[sun_recovery_details] = @RecoveryDetails,
			[sun_total_estimate] = @TotalEstimate,
			--[attach_filename] = @FileName,
			--[attach] = @Contents,
			--[proceed_filename] = @ProceedFileName,
			--[proceed_doc] = @ProceedDocument,
			--[signed_filename] = @SignedFileName,
			--[signed_doc] = @SignedDocument,
			[negative_quote_id] = @NegativeQuoteId,
			[from_search] = @IsFromSearch,
			[is_fake_neg_quote] = @IsFakeNegativeQuote,
			[fake_bypass] = @IsFakeBypass,
			[variation_checked_by] = @VariationCheckedBy,
			[variation_checked_on] = @VariationCheckedDate,
			[est_job_sale_price_with_HOW] = @EstimatedJobSalePriceWithWarranty,
			[home_habitable] = @HomeOccupancy,
			[VacateDays] = @VacateDays,
			[contains_asbestos] = @ContainsAsbestos,
			[home_warranty_required] = @HomeWarrantyRequired,
			[home_warranty_sum] = @HomeWarranty,
			[sun_resultant_damage] = @ResultantDamage,
			[Maintenance_issues_noted] = @MaintenanceIssuesNoted,
			[sun_maintenance_defects] = @MaintenanceDefects,
			[sun_insured_advised] = @HasInsurerAdvised,
			[sun_claim_covered] = @CoveredClaim,
			[sun_action_required] = @IsActionRequired,
			[sun_action_desc] = @ActionDescription,
			[sun_contents_involved] = @ContentsInvolved,
			[sun_contents_desc] = @ContentDescription,
			[status] = @status,
			[variation_type] = @VariationType,
			[version_label] = @Version,
			[SignNumber] = @SignNumber,
			[SignedByClient] = @SignedByClient,
			[Damage_match_explanation] = @DamageMatchExplanation,
			[Has_Structural_Damage] = @HasStructuralDamage,
			[Damage_Result_Of] = @DamageResultOf,
			[Damage_Date] = @DamageDate,
			[Repairs_Proceeding_per_authorisation_limits] = @IsAuthorisedRepairsProceeding,
			[Damage_Date2] = @DamageDate2,
			[updated_by] = @UserName,
			[updated_date] = GETDATE()
		WHERE [Insurance_Quote_id] = ISNULL(@QuoteId, 0);

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