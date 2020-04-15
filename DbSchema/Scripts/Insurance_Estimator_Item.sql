USE [visionary];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

BEGIN

	DECLARE @OrderId INT, @InsuranceQuoteId INT;

	SET @OrderId = 215262; /* NSY3290 */

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
	AND     (( IQ.[status] IS NULL ) OR (( IQ.[status] IS NOT NULL) AND EXISTS(SELECT 1 FROM [dbo].[Insurance_QuoteStatus] WHERE  [id] = IQ.[status] AND [name] <> 'Cancelled') ))
	AND     EXISTS(SELECT 1 FROM [dbo].[Insurance_WorkOrder] IWS WHERE ( IWS.[status_id] IS NOT NULL )
	AND     EXISTS(SELECT 1 FROM [dbo].[InsuranceStatus] WHERE ( [id] = IWS.[status_id] ) AND ( [name] = 'Approved' )))
	AND     ( ISNULL(IQ.[variation_type], 0) NOT IN ( 2 /* Negative Insurance Work Order Quote Variation */ ));

	SET @InsuranceQuoteId = 10748; /* Matching Revision R1 */

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
	WHERE ( IE.[Insurance_Quote_id] = @InsuranceQuoteId )
	ORDER BY IE.[Insurance_Estimator_Item_Id];

END;
GO

BEGIN

	DECLARE @estimatorId AS INT;

	SET @estimatorId = 0; -- CHANGE IF REQUIRED

	DECLARE @validateEntry AS BIT;

	SET @validateEntry = 1;

	DECLARE @ErrNumber AS INT;

	EXEC @ErrNumber = [dbo].[Insurance_Estimator_Item_Delete] @estimatorId, @validateEntry;

END;
GO

BEGIN

	SELECT MAX([Insurance_Estimator_Item_id]) FROM [dbo].[Insurance_Estimator_Item];

END;
GO

BEGIN

	SET NOCOUNT ON;

	DECLARE @OrderId INT;

	SET @OrderId = 207086;

	EXEC [Insurance_Estimator_Item_Get_Partial_Details] @OrderId;

	SET NOCOUNT OFF;

END;
GO

BEGIN

	DECLARE @insurancequoteId INT;

	DECLARE @resource VARCHAR(2048);
	
	DECLARE @formatfile VARCHAR(2048);
	
	DECLARE @username VARCHAR(50);

	DECLARE @clientAddress VARCHAR(32);

	DECLARE @separator VARCHAR(32);

	DECLARE @replacement VARCHAR(32);

	DECLARE @errorfile VARCHAR(2048);

	DECLARE @firstrow INT;
	
	DECLARE @maxerrors INT;
	 
	DECLARE @retval INT;

	SET @insurancequoteid = 4228;

	SET @resource = 'C:\Development\Estimator\MaincomServices\MaincomServices\TempDocs2\jclark\Simple Insurance Job Estimate.csv';

	SET @formatfile = 'C:\Development\Estimator\MaincomServices\MaincomServices\Templates\Insurance_Estimator_Item.fmt';

	SET @username = 'jclark';

	SET @clientAddress = '::1';

	SET @separator = ',';

	SET @replacement = ';';

	SET @errorfile = 'C:\Development\Estimator\MaincomServices\MaincomServices\TemplateErrors\jclark\jclark 24 May 2013 02.48.00.error.txt';

	SET @firstrow = 2;

	SET @maxerrors = 20;

	DECLARE @execval INT;

	EXEC @execval = .[Insurance_Estimator_Item_Bulk_Insert] @insurancequoteid, @resource, @formatfile, @username, @clientAddress, @separator, @replacement, @errorfile, @firstrow, @maxerrors, @retval OUTPUT;
	

END;
GO


BEGIN

	DECLARE @resource VARCHAR(2048);
	
	DECLARE @formatfile VARCHAR(2048);
	
	DECLARE @username VARCHAR(50);

	DECLARE @clientAddress VARCHAR(32);

	DECLARE @errorfile VARCHAR(2048);

	DECLARE @firstrow INT;
	
	DECLARE @maxerrors INT;
	 
	SET @resource = 'C:\Development\Estimator\MaincomServices\MaincomServices\TempDocs2\jclark\Simple Insurance Job Estimate.csv';

	SET @formatfile = 'C:\Development\Estimator\MaincomServices\MaincomServices\Templates\Insurance_Estimator_Item.fmt';

	SET @username = 'jclark';

	SET @clientAddress = '::1';

	SET @errorfile = 'C:\Development\Estimator\MaincomServices\MaincomServices\TemplateErrors\jclark\jclark 24 May 2013 02.48.00.error.txt';

	SET @firstrow = 2;

	SET @maxerrors = 20;

	DECLARE @execval INT;

	EXEC @execval = .[Insurance_Estimator_Item_Import] @resource, @formatfile, @errorfile, @username, @clientAddress;
	

END;
GO

BEGIN

	DECLARE cvReader CURSOR LOCAL FAST_FORWARD FOR 
		SELECT [Insurance_Estimator_Item_id] FROM [dbo].[Insurance_Estimator_Item]
		WHERE [Insurance_Quote_id] = 4228
		AND [Insurance_Estimator_Item_id] >= 84016
		ORDER BY [Insurance_Estimator_Item_id] DESC;

	DECLARE @EstimatorId INT;

	DECLARE @retval INT;

	OPEN cvReader;

	FETCH NEXT FROM cvReader INTO @EstimatorId;

	WHILE ( @@FETCH_STATUS = 0 )
	BEGIN

		EXEC @retval = [dbo].[Insurance_Estimator_Item_Delete] @EstimatorId;

		FETCH NEXT FROM cvReader INTO @EstimatorId;

	END;

	CLOSE cvReader;

	DEALLOCATE cvReader;

END;
GO