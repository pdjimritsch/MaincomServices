USE [visionary];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Quote_Insert'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Quote_Insert];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 25 February 2013
-- Description:	Registers the new insurance quote within the database schema.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Quote_Insert]
(
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
	@ValidateEntry BIT = 0
)
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @QuoteId INT;

	SET @QuoteId = -1;

	DECLARE @ErrNumber INT;

	DECLARE @retval INT;

	SET @retval = 0;

	IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'getNextID'), N'IsProcedure'), 0) = 0
		RAISERROR(N'The sequence generator has not been registered within the database.', 16, 2) WITH NOWAIT;

	IF ( NOT ( @ErrNumber = 0 ) ) OR ( NOT ( @retval = 0 ) )
	BEGIN
		IF ( ISNULL(@ValidateEntry, 0) <> 0 ) RAISERROR(N'The sequence generator cannot generate the sequence key for the table %s', 16, 2, 'Insurance_Quote') WITH NOWAIT;
	END;

	IF ( ISNULL(@ValidateEntry, 0) <> 0 )
	BEGIN

		IF ( @OrderId IS NULL ) OR ( NOT EXISTS(SELECT 1 FROM [dbo].[ORDERS] WHERE [ORDER_ID] = @OrderId) )
		BEGIN
			IF ( @OrderId IS NOT NULL ) RAISERROR('The work order reference identity %d has not been registered within Visionary', 16, 2, @OrderId) WITH NOWAIT;
			RETURN @QuoteId;
		END;

	END;

	IF ( LEN(ISNULL(@UserName, '')) = 0 ) SET @UserName = SESSION_USER;

	EXEC [getNextID] 'Insurance_Quote', @QuoteId OUTPUT, @retval OUTPUT, @ErrNumber OUTPUT;

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

	DECLARE @ReferenceNumber INT;

	SELECT @ReferenceNumber = COUNT(*) + 1 
	FROM [dbo].[Insurance_Quote] WITH (READCOMMITTED) 
	WHERE ( [Order_id] = ISNULL(@OrderId, 0) )
	AND ( [supplier_ref] = ISNULL(LTRIM(RTRIM(@SupplierReference)), '') )
	AND ( ISNULL([variation_type], 0) = @VariationType );

	IF ( @VariationType = 0 /* Insurance Quote Revision */ )
		SET @Version = 'R' + CONVERT(VARCHAR(19), @ReferenceNumber); -- Revision number
	ELSE IF (( @VariationType = 1 /* Positive quote variation */ ) OR ( @VariationType = 2 /* Negative quote variation */ ))
		SET @Version = 'V' + CONVERT(VARCHAR(19), @ReferenceNumber); -- Variation number

	IF ( @Transaction = 0 ) BEGIN TRANSACTION;

	BEGIN TRY

		INSERT INTO [dbo].[Insurance_Quote]
		(
			[Insurance_Quote_id],
			[Order_id],
			[created_by],
			[create_date],
			[details_and_Circumstances],
			[comments],
			[supplier_ref],
			[incident_confirmed],
			[initial_contact_datetime],
			[site_attend_datetime],
			[attend_with_insured],
			[attend_with_rep],
			[reps_name],
			[attend_with_noone],
			[attend_na],
			[sum_insured_adequate],
			[make_safe],
			[has_insured_been_advised],
			[is_insured_aware_of_repairs],
			[cost_of_repairs],
			[recommendation],
			[client_willing_to_proceed],
			[building_type],
			[design_type],
			[construction_type],
			[roof_type],
			[square_metres],
			[age],
			[overall_condition_acceptable],
			[is_iag_assessment_required],
			[ob_bungalow],
			[ob_fibro_shed],
			[ob_brick_shed],
			[ob_metal_shed],
			[ob_metal_garage],
			[ob_above_ground_pool],
			[ob_pergola],
			[ob_timber_carport],
			[ob_brick_carport],
			[ob_dog_kennel],
			[ob_external_laundry],
			[ob_below_ground_pool],
			[ob_external_wc],
			[ob_bbq_area],
			[ob_pool_room],
			[ob_store_room],
			[ob_cubby_house],
			[ob_pump_room],
			[ob_granny_flat],
			[ob_brick_garage],
			[ob_fibro_garage],
			[ob_carport_metal],
			[ob_screen_enclosures],
			[ob_fence],
			[est_labour_markup],
			[est_material_markup],
			[est_room_cost],
			[est_job_cost],
			[est_room_sale_price],
			[est_job_sale_price],
			[est_room_profit],
			[est_job_profit],
			[profit_percentage],
			[labour_total],
			[material_total],
			[room_trade_total],
			[job_trade_total],
			[insurance_trade_id],
			[insurance_room_id],
			[sun_client_discussion],
			[sun_cause_of_damage],
			[sun_conclusion],
			[sun_estimate],
			[sun_maintenance_defects_not_covered],
			[sun_insured_advised_not_covered],
			[sun_estimate_not_covered],
			[sun_recovery_details],
			[sun_total_estimate],
			--[attach_filename],
			--[attach],
			--[proceed_filename],
			--[proceed_doc],
			--[signed_filename],
			--[signed_doc],
			[negative_quote_id],
			[from_search],
			[is_fake_neg_quote],
			[fake_bypass],
			[variation_checked_by],
			[variation_checked_on],
			[est_job_sale_price_with_HOW],
			[home_habitable],
			[VacateDays],
			[contains_asbestos],
			[home_warranty_required],
			[home_warranty_sum],
			[sun_resultant_damage],
			[Maintenance_issues_noted],
			[sun_maintenance_defects],
			[sun_insured_advised],
			[sun_claim_covered],
			[sun_action_required],
			[sun_action_desc],
			[sun_contents_involved],
			[sun_contents_desc],
			[status],
			[variation_type],
			[version_label],
			[SignNumber],
			[SignedByClient],
			[Damage_match_explanation],
			[Has_Structural_Damage],
			[Damage_Result_Of],
			[Damage_Date],
			[Repairs_Proceeding_per_authorisation_limits],
			[Damage_date2]
		)
		VALUES
		(
			@QuoteId,
			@OrderId,
			@UserName,
			GETDATE(),
			@Circumstances,
			@Comments,
			@SupplierReference,
			@IsIncidentConfirmed,
			@ContactDate,
			@SiteAttendDate,
			@InsuredAttended,
			@RepAttended,
			@RepresentativeName,
			@NobodyAttended,
			@AttendanceNotApplicable,
			@IsInsuredAmountAdequate,
			@IsMakeSafe,
			@IsInsuredAdvised,
			@IsInsuredAwareOfRepairs,
			@RepairCost,
			@MyRecommendation,
			@IsClientWillingToProceed,
			@buildingTypeId,
			@designTypeId,
			@constructionTypeId,
			@roofTypeId,
			@SquareMetres,
			@Age,
			@IsConditionAcceptable,
			@IsAssessmentRequired,
			@IsBungalow,
			@IsFibroShed,
			@IsBrickShed,
			@IsMetalShed,
			@IsMetalGarage,
			@IsAboveGroundPool,
			@IsPergola,
			@IsTimberCarport,
			@IsBrickCarport,
			@IsDogKennel,
			@IsExternalLaundry,
			@IsBelowGroundPool,
			@IsExternalWc,
			@IsBarbequeArea,
			@IsPoolRoom,
			@IsStoreRoom,
			@IsCubbyHouse,
			@IsPumpRoom,
			@IsGrannyFlat,
			@IsBrickGarage,
			@IsFibroGarage,
			@IsMetalCarport,
			@IsScreenEnclosure,
			@IsFence,
			@EstimatedLabourMarkup,
			@EstimatedMaterialMarkup,
			@EstimatedRoomCost,
			@EstimatedCost,
			@EstimatedRoomSalePrice,
			@EstimatedJobSalePrice,
			@EstimatedRoomProfit,
			@EstimatedJobProfit,
			@ProfitPercentage,
			@TotalLabour,
			@TotalMaterial,
			@TotalRoomTrade,
			@TotalJobTrade,
			@InsuranceTradeId,
			@InsuranceRoomId,
			@ClientDiscussion,
			@DamageDescription,
			@Conclusion,
			@Estimate,
			@MaintenanceDefectsNotCovered,
			@HasInsurerAdvisedNotCovered,
			@EstimateNotCovered,
			@RecoveryDetails,
			@TotalEstimate,
			--@FileName,
			--@Contents,
			--@ProceedFileName,
			--@ProceedDocument,
			--@SignedFileName,
			--@SignedDocument,
			@NegativeQuoteId,
			@IsFromSearch,
			@IsFakeNegativeQuote,
			@IsFakeBypass,
			@VariationCheckedBy,
			@VariationCheckedDate,
			@EstimatedJobSalePriceWithWarranty,
			@HomeOccupancy,
			@VacateDays,
			@ContainsAsbestos,
			@HomeWarrantyRequired,
			@HomeWarranty,
			@ResultantDamage,
			@MaintenanceIssuesNoted,
			@MaintenanceDefects,
			@HasInsurerAdvised,
			@CoveredClaim,
			@IsActionRequired,
			@ActionDescription,
			@ContentsInvolved,
			@ContentDescription,
			@status,
			@VariationType,
			@Version,
			@SignNumber,
			@SignedByClient,
			@DamageMatchExplanation,
			@HasStructuralDamage,
			@DamageResultOf,
			@DamageDate,
			@IsAuthorisedRepairsProceeding,
			@DamageDate2
		);

		SET @Error = @@ERROR;

		IF ( @Error = 0 )
		BEGIN

			IF ( @Transaction = 0 ) COMMIT TRANSACTION;

			SET @QuoteId = SCOPE_IDENTITY();

		END
		ELSE
		BEGIN

			IF ( @Transaction = 0 ) ROLLBACK TRANSACTION;

			SET @QuoteId = -1;

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

	RETURN @QuoteId;

END;
GO
