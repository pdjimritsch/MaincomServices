USE [visionary];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Quote_Create'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Quote_Create];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 7 March 2013
-- Description:	Registers the new insurance quote within the database schema.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Quote_Create] 
( 
	@OrderId INT, 
	@UserName VARCHAR(20),
	@CopyRecent BIT = 0,
	@VariationType INT OUTPUT,
	@VariationReason VARCHAR(MAX) OUTPUT,
	@SupplierReference VARCHAR(20) OUTPUT,
	@Keyword VARCHAR(50) OUTPUT, 
	@InsuranceQuoteId INT OUTPUT, 
	@JobStatus VARCHAR(50) OUTPUT, 
	@WorkOrderStatus VARCHAR(50) OUTPUT,
	@QuoteStatus VARCHAR(50) OUTPUT,
	@Version VARCHAR(20) OUTPUT
)
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SET @InsuranceQuoteId = -1;

	DECLARE @RecentQuoteId INT;

	SET @RecentQuoteId = NULL;

	DECLARE @ErrNumber INT;

	DECLARE @retval INT;

	SET @retval = 0;

	IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'getNextID'), N'IsProcedure'), 0) = 0
		RAISERROR(N'The sequence generator has not been registered within the database.', 16, 2) WITH NOWAIT;

	DECLARE @identity INT;

	EXEC [getNextID] 'Insurance_Quote', @identity OUTPUT, @retval OUTPUT, @ErrNumber OUTPUT;

	IF ( NOT ( @ErrNumber = 0 ) ) OR ( NOT ( @retval = 0 ) )
		RAISERROR(N'The sequence generator cannot generate the sequence key for the table %s', 16, 2, 'Insurance_Quote') WITH NOWAIT;

	SET @InsuranceQuoteId = @identity;

	IF ( @OrderId IS NULL ) OR ( NOT EXISTS(SELECT 1 FROM [dbo].[ORDERS] WHERE [ORDER_ID] = @OrderId) )
	BEGIN
		IF ( @OrderId IS NOT NULL )
		BEGIN
			SET NOCOUNT OFF;
			SET @InsuranceQuoteId = -1;
			RAISERROR('The work order reference identity %d has not been registered within Visionary', 16, 2, @OrderId) WITH NOWAIT;
		END;
		RETURN;
	END;

	DECLARE @currDate DATETIME;

	SET @currDate = GETDATE();

	SET @VariationType = ISNULL(@VariationType, 0);

	DECLARE @ReferenceNumber INT;

	-- Get the recent insurance quote version or variation number
	
	IF (( @VariationType IS NULL /* New Insurance Quote Revision */ ) OR ( @VariationType = 0 /* New Insurance Quote Revision */ ))
		SELECT @ReferenceNumber = COUNT(*) + 1 
		FROM [dbo].[Insurance_Quote] WITH (READCOMMITTED) 
		WHERE ( [Order_id] = ISNULL(@OrderId, 0) )
		AND ( ISNULL([variation_type], 0) = 0 );
	ELSE IF ( @VariationType = 1 /* New Positive Insurance Quote Variation */ )
		SELECT @ReferenceNumber = COUNT(*) + 1 
		FROM [dbo].[Insurance_Quote] WITH (READCOMMITTED) 
		WHERE ( [Order_id] = ISNULL(@OrderId, 0) )
		AND ( ISNULL([variation_type], 0) = 1 );
	ELSE IF ( @VariationType = 2 /* New Negative Insurance Quote Variation */ )
		SELECT @ReferenceNumber = COUNT(*) + 1 
		FROM [dbo].[Insurance_Quote] WITH (READCOMMITTED) 
		WHERE ( [Order_id] = ISNULL(@OrderId, 0) )
		AND ( ISNULL([variation_type], 0) = 2 );

	-- Get the insurance work order supplier reference number
	SELECT @SupplierReference = ISNULL(LTRIM(RTRIM([supplier_ref])), ''),
	       @Keyword = ISNULL(LTRIM(RTRIM([search_code_value])), '')
	FROM [dbo].[Insurance_WorkOrder]
	WHERE ( [ORDER_ID] = ISNULL(@OrderId, 0) );

	-- Get the associated job status for the insurance work order

	SELECT @JobStatus = JS.[name] 
	FROM [dbo].[Orders] O 
		LEFT JOIN [InsuranceStatus] JS ON JS.[id] = O.[STATUS]
	WHERE O.[ORDER_ID] = @OrderId;

	-- Get the associated work order status for the insurance work order

	SELECT @WorkOrderStatus = IWS.[name]
	FROM [dbo].[Insurance_WorkOrder] IW
		LEFT JOIN [dbo].[InsuranceStatus] IWS ON IWS.[id] = IW.[status_id]
	WHERE IW.[ORDER_ID] = @OrderId;

	DECLARE @Status INT; -- Insurance quote status

	SET @Status = 30; -- In Progress
	SELECT @QuoteStatus = [name] FROM [dbo].[Insurance_QuoteStatus] WHERE [id] = @Status;

	IF (( @VariationType IS NULL /* New Insurance Quote Revision */ ) OR ( @VariationType = 0 /* New Insurance Quote Revision */ ))
	BEGIN
		SET @Version = 'R' + CONVERT(VARCHAR(19), @ReferenceNumber); -- Revision number
	END
	ELSE IF (( @VariationType = 1 /* Positive quote variation */ ) OR ( @VariationType = 2 /* Negative quote variation */ ))
	BEGIN
		SET @Version = 'V' + CONVERT(VARCHAR(19), @ReferenceNumber); -- Variation number
	END;

	IF ( @VariationReason IS NOT NULL ) SET @VariationReason = LTRIM(RTRIM(@VariationReason));

	IF ( LEN(ISNULL(@UserName, '')) = 0 ) SET @UserName = SESSION_USER;

	DECLARE @Transaction INT;

	SET @Transaction = @@TRANCOUNT;

	DECLARE @Error INT;

	SET @Error = @@ERROR;

	IF ( @Transaction = 0 ) BEGIN TRANSACTION;

	BEGIN TRY

		IF (( @VariationType IS NULL /* New Insurance Quote Revision */ ) OR ( @VariationType = 0 /* New Insurance Quote Revision */ ))
		BEGIN

				INSERT INTO [dbo].[Insurance_Quote]
				(
					[Insurance_Quote_id],
					[Order_id],
					[supplier_ref],
					[created_by],
					[create_date],
					[status],
					[details_and_Circumstances],
					[variation_type],
					[version_label],
					[site_attend_datetime]
				)
				VALUES
				(
					@InsuranceQuoteId,
					@OrderId,
					@SupplierReference,
					@UserName,
					@currDate,
					@Status, -- In Progress
					@VariationReason, -- Circumstances
					@VariationType, -- Insurance quote revision
					@Version, -- Insurance quote version
					@currDate
				);

		END
		ELSE
		BEGIN

			INSERT INTO [dbo].[Insurance_Quote]
			(
				[Insurance_Quote_id],
				[Order_id],
				[supplier_ref],
				[created_by],
				[create_date],
				[status],
				[details_and_Circumstances],
				[variation_type],
				[version_label]
			)
			VALUES
			(
				@InsuranceQuoteId,
				@OrderId,
				@SupplierReference,
				@UserName,
				@currDate,
				@Status, -- In Progress
				@VariationReason, -- Circumstances
				@VariationType, -- Insurance quote revision or variation type
				@Version -- Insurance quote version
			);

		END;

		SET @Error = @@ERROR;

		IF ( @Error = 0 )
		BEGIN

			IF ( @Transaction = 0 ) COMMIT TRANSACTION;

		END
		ELSE
		BEGIN

			IF ( @Transaction = 0 ) ROLLBACK TRANSACTION;

			SET @InsuranceQuoteId = -1;

		END;

		IF ( ISNULL(@InsuranceQuoteId, -1) > 0 ) AND ( ISNULL(@CopyQuote, 0) <> 0 )
		BEGIN

			IF ( ISNULL(OBJECTPROPERTY(OBJECT_ID(N'GetRecentInsuranceQuoteId'), N'IsScalarFunction'), 0) = 1 )
			BEGIN

				SET @RecentQuoteId = [dbo].[GetRecentInsuranceQuoteId] ( @OrderId );

				EXEC [Insurance_Quote_Copy] @RecentQuoteId, @InsuranceQuoteId, @UserName;

			END;

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
