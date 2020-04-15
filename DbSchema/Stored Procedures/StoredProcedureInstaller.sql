USE [Visionary]
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'ByteShift'), N'IsScalarFunction'), 0) = 1
	DROP FUNCTION [dbo].[ByteShift];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'AddBit'), N'IsScalarFunction'), 0) = 1
	DROP FUNCTION [dbo].[AddBit];
GO

-- =============================================
-- Author:		Paul Djimritsch
-- Create date: 21 January 2013
-- Description:	Registers the byte within a dword.
-- =============================================
CREATE FUNCTION [dbo].[AddBit] ( @lval BIT, @rval BIT )
RETURNS BIGINT
AS
BEGIN

	DECLARE @retval BIGINT;

	SET @retval = CAST(ISNULL(@lval, 0) AS BIGINT) + CAST(ISNULL(@rval, 0) AS BIGINT);

	RETURN @retval;

END;
GO

-- =============================================
-- Author:		Paul Djimritsch
-- Create date: 21 January 2013
-- Description:	Shifts the byte towards the higher-byte placement to create
--              a equivalent word. 
-- =============================================
CREATE FUNCTION [dbo].[ByteShift] ( @val BIT )
RETURNS SMALLINT
AS
BEGIN

	DECLARE @retval SMALLINT;

	SET @retval = CAST(POWER(2, 8) AS SMALLINT) + ISNULL(@val, 0);

	RETURN @retval;

END;
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'GetRecentInsuranceQuoteId'), N'IsScalarFunction'), 0) = 1
	DROP FUNCTION [dbo].GetRecentInsuranceQuoteId;
GO

-- =============================================
-- Author:		Paul Djimritsch
-- Create date: 21 January 2013
-- Description:	Obtains the recent reference to the insurance work
--              order quote that references the insurance work order.
-- =============================================
CREATE FUNCTION [dbo].[GetRecentInsuranceQuoteId] ( @OrderId INT )
RETURNS INT
AS
BEGIN

	DECLARE @Id INT;

	SELECT @Id = MAX([Insurance_Quote_id]) FROM [dbo].[Insurance_Quote] WHERE [Order_id] = ISNULL(@OrderId, -1) AND ISNULL([variation_type], 0) = 0;

	RETURN @Id;

END;
GO

/****** Object:  StoredProcedure [dbo].[Get_Order_ID_By_Search_Code]    Script Date: 01/31/2013 10:25:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Get_Order_ID_By_Search_Code'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Get_Order_ID_By_Search_Code];
GO

-- ============================================================================
-- Author:			Andrei Baranovski
-- Create date:		22 May 2012
-- Modification History
--
-- Paul Djimritsch. 31 January 2012: Added Work Order status information.
--              
-- ============================================================================
CREATE PROCEDURE [dbo].[Get_Order_ID_By_Search_Code] ( @Search_Code VARCHAR(50) )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT O.[ORDER_ID], IW.[supplier_ref], IWS.[name] AS [status_value]
	FROM [dbo].[ORDERS] O WITH (READCOMMITTED) 
	INNER JOIN [dbo].[Insurance_WorkOrder] IW ON IW.[ORDER_ID] = O.[ORDER_ID]
	INNER JOIN [dbo].[InsuranceStatus] IWS ON IWS.[id] = IW.[status_id]
	WHERE O.[SEARCH_CODE] = @Search_Code;

	SET NOCOUNT OFF;

END;
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

-- =============================================
-- Author:		Paul Djimritsch
-- Create date: 21 January 2013
-- Description:	Login check
-- =============================================
IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'GetPassword'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[GetPassword];
GO

CREATE PROCEDURE [dbo].[GetPassword] @Username varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [password], [description] FROM [dbo].[Employee] WITH (READCOMMITTED) WHERE [LOGIN_CODE]= @Username

	SET NOCOUNT OFF;

END;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_BuildingType_Get'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_BuildingType_Get];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 1 March 2013
-- Description:	Obtains the registered insurance recognized building types
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_BuildingType_Get]
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT [id], [name] FROM [dbo].[Insurance_BuildingType];

	SET NOCOUNT OFF;

END;
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_ConstructionType_Get'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_ConstructionType_Get];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 1 March 2013
-- Description:	Obtains the registered insurance recognized building construction types
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_ConstructionType_Get]
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT [id], [name] FROM [dbo].[Insurance_ConstructionType];

	SET NOCOUNT OFF;

END;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_DesignType_Get'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_DesignType_Get];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 1 March 2013
-- Description:	Obtains the registered insurance recognized building design types
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_DesignType_Get]
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT [id], [name] FROM [dbo].[Insurance_DesignType];

	SET NOCOUNT OFF;

END;
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Estimator_Get_Estimator_By_Id'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Estimator_Get_Estimator_by_Id];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 25 February 2013
-- Description:	Obtains the insurance estimator from the specified insurance estimator identity.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Estimator_Get_Estimator_by_Id] ( @Id INT )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT	IE.[Insurance_Estimator_Item_Id],
			IE.[Insurance_Quote_id],
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
			IE.[l_cost_total],
			IE.[m_cost_total],
			IE.[l_total_with_margin],
			IE.[m_total_with_margin],
			IE.[total_with_margin],
			IE.[cost_total],
			IE.[l_cost_rate],
			IE.[m_cost_rate],
			IE.[total],
			IE.[created_by],
			IE.[create_date],
			IE.[Insurance_Trade_Id],
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
			IE.[MinimumCharge]
	FROM [dbo].[Insurance_Estimator_Item] IE
	WHERE  IE.[Insurance_Estimator_Item_Id] = ISNULL(@Id, 0);

	SET NOCOUNT OFF;

END;
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Estimator_Item_Get_By_Search_Code'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Estimator_Item_Get_By_Search_Code];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 25 February 2013
-- Description:	Obtains the insurance estimator from the specified job search code
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Estimator_Item_Get_By_Search_Code] ( @Search_Code VARCHAR(50) )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;
	
	SELECT	[Insurance_Estimator_Item_Id],
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
			[l_cost_total],
			[m_cost_total],
			[cost_total],
			[l_cost_rate],
			[m_cost_rate],
			[total],
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
			[updated_date]
	FROM [dbo].[Insurance_Estimator_Item]
	WHERE [Insurance_Quote_id] IN (SELECT [ORDER_ID] FROM [Insurance_WorkOrder] WHERE [search_code_value] = LTRIM(RTRIM(ISNULL(@Search_Code, ''))));
	
	SET NOCOUNT OFF;	

END;
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Estimator_Item_Get_Inspection_Details'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Estimator_Item_Get_Inspection_Details];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 25 February 2013
-- Description:	Obtains the insurance estimator from the specified criteria.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Estimator_Item_Get_Inspection_Details] ( @OrderId INT, @SupplierRef VARCHAR(50), @Version VARCHAR(20) )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	--
	-- Notes: 
	--        The markup types for labour and material are [l_markup_type] and [m_markup_type] consecutively.
	--        The value for the markup types are 0 = Monetary setting and 1 = Percentage setting.
	--
	--        The labour and material markup values are currently extracted from the consecutive columns
	--        [est_labour_markup] and [est_material_markup] within the [Insurance_Quote] database table.
	--
	--
	--        The markup cost total for labour and material are preserved in the column [l_total_with_margin]
	--        and [m_total_with_margin] consecutively.
	--
	--        The column [total_with_margin] contains the summation of the values preserved within the columns
	--        [l_total_with_margin] and [m_total_with_margin].
	--
	
	SET @OrderId = ISNULL(@OrderId, -1);

	SET @SupplierRef = LTRIM(RTRIM(ISNULL(@SupplierRef, '')));

	SET @Version = LTRIM(RTRIM(ISNULL(@Version, '')));

	IF ( @OrderId <= 0 )
	BEGIN
		SET NOCOUNT OFF
		RETURN;
	END;

	IF ( LEN(@SupplierRef) = 0 ) AND ( LEN(@Version) = 0 )
	BEGIN

		SELECT	IE.[Insurance_Estimator_Item_Id],
				IE.[Insurance_Quote_id],
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
				IE.[l_cost_rate],
				IE.[m_cost_rate],
				IE.[l_total_with_margin],
				IE.[m_total_with_margin],
				IE.[total_with_margin],
				IE.[total],
				IE.[created_by],
				IE.[create_date],
				IE.[Insurance_Trade_Id],
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
		FROM [dbo].[Insurance_Quote] IQ INNER JOIN [dbo].[Insurance_Estimator_Item] IE ON [IE].[Insurance_Quote_id] = IQ.[Insurance_Quote_id]
		WHERE ( IQ.[Order_id] = @OrderId )
		ORDER BY IE.[Insurance_Estimator_Item_Id];

	END
	ELSE IF ( LEN(@SupplierRef) = 0 ) AND ( LEN(@Version) > 0 )
	BEGIN

		SELECT	IE.[Insurance_Estimator_Item_Id],
				IE.[Insurance_Quote_id],
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
				IE.[l_cost_rate],
				IE.[m_cost_rate],
				IE.[l_total_with_margin],
				IE.[m_total_with_margin],
				IE.[total_with_margin],
				IE.[total],
				IE.[created_by],
				IE.[create_date],
				IE.[Insurance_Trade_Id],
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
		FROM [dbo].[Insurance_Quote] IQ INNER JOIN [dbo].[Insurance_Estimator_Item] IE ON [IE].[Insurance_Quote_id] = IQ.[Insurance_Quote_id]
		WHERE ( IQ.[Order_id] = @OrderId )
		AND   ( LTRIM(RTRIM(IQ.[version_label])) = @Version )
		ORDER BY IE.[Insurance_Estimator_Item_Id];

	END
	ELSE IF ( LEN(@SupplierRef) > 0 ) AND ( LEN(@Version) = 0 )
	BEGIN

		SELECT	IE.[Insurance_Estimator_Item_Id],
				IE.[Insurance_Quote_id],
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
				IE.[l_cost_rate],
				IE.[m_cost_rate],
				IE.[l_total_with_margin],
				IE.[m_total_with_margin],
				IE.[total_with_margin],
				IE.[total],
				IE.[created_by],
				IE.[create_date],
				IE.[Insurance_Trade_Id],
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
		FROM [dbo].[Insurance_Quote] IQ INNER JOIN [dbo].[Insurance_Estimator_Item] IE ON [IE].[Insurance_Quote_id] = IQ.[Insurance_Quote_id]
		WHERE ( IQ.[Order_id] = @OrderId )
		AND   ( LTRIM(RTRIM(IQ.[supplier_ref])) = @SupplierRef )
		ORDER BY IE.[Insurance_Estimator_Item_Id];

	END
	ELSE
	BEGIN

		SELECT	IE.[Insurance_Estimator_Item_Id],
				IE.[Insurance_Quote_id],
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
				IE.[l_cost_rate],
				IE.[m_cost_rate],
				IE.[l_total_with_margin],
				IE.[m_total_with_margin],
				IE.[total_with_margin],
				IE.[total],
				IE.[created_by],
				IE.[create_date],
				IE.[Insurance_Trade_Id],
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
		FROM [dbo].[Insurance_Quote] IQ INNER JOIN [dbo].[Insurance_Estimator_Item] IE ON [IE].[Insurance_Quote_id] = IQ.[Insurance_Quote_id]
		WHERE  ( IQ.[Order_id] = @OrderId )
		AND    ( LTRIM(RTRIM(IQ.[supplier_ref])) = @SupplierRef )
		AND    ( LTRIM(RTRIM(IQ.[version_label])) = @Version )
		ORDER BY IE.[Insurance_Estimator_Item_Id];

	END;
	
	SET NOCOUNT OFF;	

END;
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Estimator_Item_Get_Inspection_Details_By_Quote_Id'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Estimator_Item_Get_Inspection_Details_By_Quote_Id];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 25 February 2013
-- Description:	Obtains the insurance estimator from the specified criteria.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Estimator_Item_Get_Inspection_Details_By_Quote_Id] ( @QuoteId INT, @StartIndex INT = -1, @FetchCount INT = 0 )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	--
	-- Notes: 
	--        The markup types for labour and material are [l_markup_type] and [m_markup_type] consecutively.
	--        The value for the markup types are 0 = Monetary setting and 1 = Percentage setting.
	--
	--        The labour and material markup values are currently extracted from the consecutive columns
	--        [est_labour_markup] and [est_material_markup] within the [Insurance_Quote] database table.
	--
	--
	--        The markup cost total for labour and material are preserved in the column [l_total_with_margin]
	--        and [m_total_with_margin] consecutively.
	--
	--        The column [total_with_margin] contains the summation of the values preserved within the columns
	--        [l_total_with_margin] and [m_total_with_margin].
	--
	
	SET @QuoteId = ISNULL(@QuoteId, -1);

	IF ( @QuoteId <= 0 )
	BEGIN
		SET NOCOUNT OFF
		RETURN;
	END;

	IF ( @FetchCount = 0 ) OR ( @StartIndex < 0 )
	BEGIN

		SELECT	IE.[Insurance_Estimator_Item_Id],
				IE.[Insurance_Quote_id],
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
				IE.[l_cost_rate],
				IE.[m_cost_rate],
				IE.[l_total_with_margin],
				IE.[m_total_with_margin],
				IE.[total_with_margin],
				IE.[total],
				IE.[created_by],
				IE.[create_date],
				IE.[Insurance_Trade_Id],
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
		WHERE ( IE.[Insurance_Quote_id] = @QuoteId )
		ORDER BY IE.[Insurance_Estimator_Item_Id];

	END
	ELSE IF ( @StartIndex >= 0 ) AND ( @FetchCount > 0 )
	BEGIN

		WITH [LocalCache] AS
		(
			SELECT	IE.[Insurance_Estimator_Item_Id],
					IE.[Insurance_Quote_id],
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
					IE.[l_cost_rate],
					IE.[m_cost_rate],
					IE.[l_total_with_margin],
					IE.[m_total_with_margin],
					IE.[total_with_margin],
					IE.[total],
					IE.[created_by],
					IE.[create_date],
					IE.[Insurance_Trade_Id],
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
					IE.[updated_date],
					ROW_NUMBER() OVER ( ORDER BY IE.[Insurance_Estimator_Item_id] ) AS [RowIndex]
			FROM    [dbo].[Insurance_Estimator_Item] IE
			WHERE ( IE.[Insurance_Quote_id] = @QuoteId )
		)
		SELECT * FROM [LocalCache] LC WHERE LC.[RowIndex] BETWEEN ( @StartIndex + 1 ) AND ( @StartIndex + @FetchCount )
		ORDER BY LC.[Insurance_Estimator_Item_Id]

	END
	ELSE
	BEGIN

		SELECT	IE.[Insurance_Estimator_Item_Id],
				IE.[Insurance_Quote_id],
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
				IE.[l_cost_rate],
				IE.[m_cost_rate],
				IE.[l_total_with_margin],
				IE.[m_total_with_margin],
				IE.[total_with_margin],
				IE.[total],
				IE.[created_by],
				IE.[create_date],
				IE.[Insurance_Trade_Id],
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
		WHERE ( IE.[Insurance_Quote_id] = @QuoteId )
		ORDER BY IE.[Insurance_Estimator_Item_Id];

	END;
	
	SET NOCOUNT OFF;	

END;
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Estimator_Item_Delete'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Estimator_Item_Delete];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 26 April 2013
-- Description:	Deregisters the specified insurance quote estimation within the database schema.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Estimator_Item_Delete] ( @estimatorId INT, @validateEntry BIT = NULL )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET @estimatorId = ISNULL( @estimatorId, 0 );

	SET @validateEntry = ISNULL( @validateEntry, 0 );

	DECLARE @maxEstimatorId AS INT;

	SELECT @maxEstimatorId = MAX([Insurance_Estimator_Item_id]) FROM [dbo].[Insurance_Estimator_Item] WITH (READCOMMITTED);

	DECLARE @ErrMessage VARCHAR(2048);

	SET @ErrMessage = '';

	DECLARE @ErrNumber INT;

	SET @ErrNumber = @@ERROR;

	DECLARE @ErrSeverity INT;

	SET @ErrSeverity = 0;

	DECLARE @ErrStatus INT;

	SET @ErrStatus = 0;

	IF ( @validateEntry <> 0 )
	BEGIN

		IF NOT EXISTS(SELECT 1 FROM [dbo].[Insurance_Estimator_Item] WITH (READCOMMITTED) WHERE [Insurance_Estimator_Item_id] = @estimatorId)
		BEGIN

			SET @ErrMessage = 'The insurance work order quote estimation identity [ %d ] cannot be retrieved from the data warehouse.';

			RAISERROR( @ErrMessage, 16, 2, @estimatorId ) WITH NOWAIT;

		END;

	END;

	DECLARE @insuranceQuoteId AS INT;

	SELECT @insuranceQuoteId = [Insurance_Quote_id] FROM [dbo].[Insurance_Estimator_Item] WITH (READCOMMITTED)
	WHERE [Insurance_Estimator_Item_id] = @estimatorId;

	IF ( @insuranceQuoteId IS NULL )
	BEGIN

		SET @ErrMessage = 'The insurance work order quote identity cannot be located within the data warehouse.';

		RAISERROR( @ErrMessage, 16, 2 ) WITH NOWAIT;

	END;

	DECLARE @Transaction AS INT;

	SET @Transaction = @@TRANCOUNT;

	BEGIN TRY

		IF ( @Transaction = 0 ) BEGIN TRANSACTION;

		DELETE FROM [dbo].[Insurance_Estimator_Item] WHERE [Insurance_Estimator_Item_id] = @estimatorId;

		SET @ErrNumber = @@ERROR;

		IF ( @ErrNumber = 0 )
		BEGIN
			IF ( @Transaction = 0 ) COMMIT TRANSACTION;
		END
		ELSE
		BEGIN
			IF ( @Transaction = 0 ) ROLLBACK TRANSACTION;
		END;

		IF ( @estimatorId = @maxEstimatorId )
		BEGIN

			-- decrement the sequence table [MAX_ID] column value for the [Insurance_Estimator_Item] database table
			UPDATE [dbo].[SEQUENCE_TABLE] WITH (READCOMMITTED) SET [MAX_ID] = CAST( ( @maxEstimatorId - 1 ) AS INT ) WHERE ( [SEQUENCE_NAME] = 'Insurance_Estimator_Item' );

		END;

		IF ( @ErrNumber = 0 ) EXEC @ErrNumber = Insurance_Quote_Bulk_Insert_Update @insuranceQuoteId;

	END TRY
	BEGIN CATCH

		SET @ErrNumber = @@ERROR;

		SET @ErrMessage = ERROR_MESSAGE();

		SET @ErrSeverity = ERROR_SEVERITY();

		SET @ErrStatus = ERROR_STATE();

		IF ( @Transaction = 0 ) ROLLBACK TRANSACTION;

		RAISERROR ( @ErrMessage, @ErrSeverity,  @ErrStatus ) WITH NOWAIT;

	END CATCH

	RETURN @ErrNumber;

END;
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Estimator_Item_Insert'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Estimator_Item_Insert];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 25 February 2013
-- Description:	Registers the new insurance quote estimation within the database schema.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Estimator_Item_Insert]
(
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
	@DamageText varchar(50) = NULL,
	@MinimumCharge VARCHAR(255) = NULL,
	@ValidateEntry BIT = 0
)
WITH EXECUTE AS CALLER
AS
BEGIN

	DECLARE @Id INT;

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

	IF ( ISNULL(@ValidateEntry, 0) <> 0 )
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

	EXEC [getNextID] 'Insurance_Estimator_Item', @Id OUTPUT, @Error OUTPUT, @ErrNumber OUTPUT;

	IF ( NOT ( @ErrNumber = 0 ) ) OR ( NOT ( @Error = 0 ) )
		RAISERROR(N'The sequence generator cannot generate the sequence key for the table %s', 16, 2, 'Insurance_Estimator_Item') WITH NOWAIT;

	DECLARE @Transaction INT;

	SET @Transaction = @@TRANCOUNT;

	IF ( @Transaction = 0 ) BEGIN TRANSACTION;

	BEGIN TRY

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
			[created_by],
			[create_date],
			[Insurance_Trade_Id],
			[code],
			[is_lock_for_negative_quote],
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
			[MinimumCharge]
		)
		VALUES
		(
			@Id,
			@Insurance_Quote_Id,
			@Insurance_Scope_Id,
			@Insurance_Room_Id,
			@ShortDescription,
			@LongDescription,
			@LabourUnit,
			@MaterialUnit,
			@LabourQuantity,
			@MaterialQuantity,
			@LabourRate,
			@MaterialRate,
			@LabourTotal,
			@MaterialTotal,
			@LabourTotal,
			@MaterialTotal,
			@Total,
			@Total,
			@LabourPercent,
			@MaterialPercent,
			@LabourPercentType,
			@MaterialPercentType,
			@LabourMarginTotal,
			@MaterialMarginTotal,
			@MarginTotal,
			@UserName,
			GETDATE(),
			@Insurance_Trade_Id,
			@Code,
			@IsLockForNegativeQuote,
			@NegativeLabourMarkup,
			@NegativeMaterialMarkup,
			@NegativeFromQuoteId,
			@NegativeAssignedToName,
			@Bypass,
			@RoomSize1,
			@RoomSize2,
			@RoomSize3,
			@IsExtraItem,
			@CancelledEstimatorItemId,
			@DamageReason,
			@HasStructuralDamage,
			@DamageText,
			@MinimumCharge
		);

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

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Estimator_Item_Get_Inspection_Details'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Estimator_Item_Get_Inspection_Details];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 25 February 2013
-- Description:	Obtains the insurance estimator from the specified criteria.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Estimator_Item_Get_Inspection_Details] ( @OrderId INT, @SupplierRef VARCHAR(50), @Version VARCHAR(20) )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	--
	-- Notes: 
	--        The markup types for labour and material are [l_markup_type] and [m_markup_type] consecutively.
	--        The value for the markup types are 0 = Monetary setting and 1 = Percentage setting.
	--
	--        The labour and material markup values are currently extracted from the consecutive columns
	--        [est_labour_markup] and [est_material_markup] within the [Insurance_Quote] database table.
	--
	--
	--        The markup cost total for labour and material are preserved in the column [l_total_with_margin]
	--        and [m_total_with_margin] consecutively.
	--
	--        The column [total_with_margin] contains the summation of the values preserved within the columns
	--        [l_total_with_margin] and [m_total_with_margin].
	--
	
	SELECT	IE.[Insurance_Estimator_Item_Id],
			IE.[Insurance_Quote_id],
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
			IE.[l_cost_rate],
			IE.[m_cost_rate],
			IE.[l_total_with_margin],
			IE.[m_total_with_margin],
			IE.[total_with_margin],
			IE.[total],
			IE.[created_by],
			IE.[create_date],
			IE.[Insurance_Trade_Id],
			IE.[code],
			IE.[is_lock_for_negative_quote],
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
			IE.[updated_by],
			IE.[updated_date]
	FROM [dbo].[Insurance_Quote] IQ INNER JOIN [dbo].[Insurance_Estimator_Item] IE ON [IE].[Insurance_Quote_id] = IQ.[Insurance_Quote_id]
	WHERE  IQ.[Order_id] = ISNULL(@OrderId, 0)
    AND    ((IQ.[supplier_ref] IS NULL) AND (DATALENGTH(ISNULL(@SupplierRef, '')) = 0) OR (LTRIM(RTRIM(IQ.[supplier_ref])) = LTRIM(RTRIM(@SupplierRef))))
    AND    ((IQ.[version_label] IS NULL) AND (DATALENGTH(ISNULL(@Version, '')) = 0) OR (LTRIM(RTRIM(IQ.[version_label])) = LTRIM(RTRIM(@Version))))
	
	SET NOCOUNT OFF;	

END;
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Estimator_Item_Get_Partial_Details'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Estimator_Item_Get_Partial_Details];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 25 February 2013
-- Description:	Obtains the insurance estimator from the specified criteria.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Estimator_Item_Get_Partial_Details] ( @OrderId INT = NULL )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;
	
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
	AND     ( ISNULL(IQ.[variation_type], 0) NOT IN ( 2 /* Negative InsuranCe Work Order Quote Variation */ ))
	ORDER BY IE.[Insurance_Estimator_Item_Id];
	
	SET NOCOUNT OFF;	

END;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Estimator_Item_Get_Partial_Exclusive_Reader'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Estimator_Item_Get_Partial_Exclusive_Reader];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 25 February 2013
-- Description:	Obtains the unregistered insurance work order quote line items
--              for a specific insurance work order quote identity from the pool
--              of available insurance work order quote line items for the
--              associated insurance work order identity.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Estimator_Item_Get_Partial_Exclusive_Reader] ( @OrderId INT = NULL, @QuoteId INT = NULL)
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

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
	AND     ( ISNULL(IQ.[variation_type], 0) NOT IN ( 2 /* Negative InsuranCe Work Order Quote Variation */ ))
	EXCEPT
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
			INNER JOIN [dbo].[Insurance_Room] IR ON IR.[Insurance_Room_Id] = IE.[room_id]
			INNER JOIN [dbo].[Insurance_Unit] LIU ON LIU.[Insurance_Unit_ID] = IE.[l_unit]
			INNER JOIN [dbo].[Insurance_Unit] MIU ON MIU.[Insurance_Unit_ID] = IE.[m_unit]
			INNER JOIN [dbo].[Insurance_Trade] IT ON IT.[Insurance_Trade_ID] = IE.[Insurance_Trade_Id]
	WHERE ( IE.[Insurance_Quote_id] = @QuoteId )

	SET NOCOUNT OFF;

END;
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

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Estimator_Item_Get_Partial_Negative_Details'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Estimator_Item_Get_Partial_Negative_Details];
GO

-- ==========================================================================================================
-- Author:		Paul Djimritsch
-- Create date: 25 February 2013
-- Description:	Obtains the insurance estimator line items for a negative insurance work order quote.
-- ==========================================================================================================
CREATE PROCEDURE [dbo].[Insurance_Estimator_Item_Get_Partial_Negative_Details] ( @QuoteId INT = NULL, @StartIndex INT = -1, @FetchCount INT = 0 )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	IF ( @FetchCount = 0 ) OR ( @StartIndex < 0 )
	BEGIN

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
		FROM [dbo].[Insurance_Estimator_Item] IE
				INNER JOIN [dbo].[Insurance_Quote] IQ ON [IQ].[Insurance_Quote_id] = IE.[Insurance_Quote_id]
					AND ( IQ.[variation_type] IS NOT NULL )
					AND ( IQ.[variation_type] = 2 /* Negative insurance work order quote variation type */ )
				INNER JOIN [dbo].[Insurance_Room] IR ON IR.[Insurance_Room_Id] = IE.[room_id]
				INNER JOIN [dbo].[Insurance_Unit] LIU ON LIU.[Insurance_Unit_ID] = IE.[l_unit]
				INNER JOIN [dbo].[Insurance_Unit] MIU ON MIU.[Insurance_Unit_ID] = IE.[m_unit]
				INNER JOIN [dbo].[Insurance_Trade] IT ON IT.[Insurance_Trade_ID] = IE.[Insurance_Trade_Id]
		WHERE  ( IE.[Insurance_Quote_id] = ISNULL(@QuoteId, -1) )
		ORDER BY IE.[Insurance_Estimator_Item_Id];

	END
	ELSE IF ( @StartIndex >= 0 ) AND ( @FetchCount > 0 )
	BEGIN

		WITH [LocalCache] AS
		(
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
					IE.[updated_date],
					ROW_NUMBER() OVER ( ORDER BY IE.[Insurance_Estimator_Item_id] ) AS [RowIndex]
			FROM [dbo].[Insurance_Estimator_Item] IE
					INNER JOIN [dbo].[Insurance_Quote] IQ ON [IQ].[Insurance_Quote_id] = IE.[Insurance_Quote_id]
						AND ( IQ.[variation_type] IS NOT NULL )
						AND ( IQ.[variation_type] = 2 /* Negative insurance work order quote variation type */ )
					INNER JOIN [dbo].[Insurance_Room] IR ON IR.[Insurance_Room_Id] = IE.[room_id]
					INNER JOIN [dbo].[Insurance_Unit] LIU ON LIU.[Insurance_Unit_ID] = IE.[l_unit]
					INNER JOIN [dbo].[Insurance_Unit] MIU ON MIU.[Insurance_Unit_ID] = IE.[m_unit]
					INNER JOIN [dbo].[Insurance_Trade] IT ON IT.[Insurance_Trade_ID] = IE.[Insurance_Trade_Id]
			WHERE  ( IE.[Insurance_Quote_id] = ISNULL(@QuoteId, -1) )
		)
		SELECT * FROM [LocalCache] LC WHERE LC.[RowIndex] BETWEEN ( @StartIndex + 1 ) AND ( @StartIndex + @FetchCount )
		ORDER BY LC.[Insurance_Estimator_Item_Id];

	END
	ELSE
	BEGIN

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
		FROM [dbo].[Insurance_Estimator_Item] IE
				INNER JOIN [dbo].[Insurance_Quote] IQ ON [IQ].[Insurance_Quote_id] = IE.[Insurance_Quote_id]
					AND ( IQ.[variation_type] IS NOT NULL )
					AND ( IQ.[variation_type] = 2 /* Negative insurance work order quote variation type */ )
				INNER JOIN [dbo].[Insurance_Room] IR ON IR.[Insurance_Room_Id] = IE.[room_id]
				INNER JOIN [dbo].[Insurance_Unit] LIU ON LIU.[Insurance_Unit_ID] = IE.[l_unit]
				INNER JOIN [dbo].[Insurance_Unit] MIU ON MIU.[Insurance_Unit_ID] = IE.[m_unit]
				INNER JOIN [dbo].[Insurance_Trade] IT ON IT.[Insurance_Trade_ID] = IE.[Insurance_Trade_Id]
		WHERE  ( IE.[Insurance_Quote_id] = ISNULL(@QuoteId, -1) )
		ORDER BY IE.[Insurance_Estimator_Item_Id];

	END;
	
	SET NOCOUNT OFF;	

END;
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Quote_Get_Inspection_Details'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Quote_Get_Inspection_Details];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 25 February 2013
-- Description:	Obtains the insurance quote from the specified insurance quote criteria.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Quote_Get_Inspection_Details] ( @OrderId INT, @SupplierRef VARCHAR(50), @Version VARCHAR(20) )
WITH EXECUTE AS CALLER -- CHANGE IF REQUIRED
AS
BEGIN

	SET NOCOUNT ON;

	SELECT IQ.[Insurance_Quote_id], 
		   IQ.[Order_id],
		   IQ.[supplier_ref],
		   IW.[search_code_value],
		   IQ.[version_label],
		   IQ.[variation_type],
		   [job_status] = LTRIM(RTRIM(ISNULL(JS.[name], ''))),
		   [work_order_status] = LTRIM(RTRIM(ISNULL(IWS.[name], ''))),
		   [quote_status] = LTRIM(RTRIM(ISNULL(QS.[name], ''))),
		   -- Site Inspection
		   IQ.[initial_contact_datetime],
		   IQ.[site_attend_datetime],
		   ISNULL(IQ.[attend_with_insured], 0) AS [attend_with_insured],
		   ISNULL(IQ.[attend_with_rep], 0) AS [attend_with_rep],
		   ISNULL(IQ.[reps_name], '') AS [reps_name],
		   ISNULL(IQ.[attend_with_noone], 0) AS [attend_with_noone],
		   ISNULL(IQ.[attend_na], 0) AS [attend_na],
		   -- Property Description
		   ISNULL(LTRIM(RTRIM(BT.[name])), '') AS [building_type],
		   ISNULL(LTRIM(RTRIM(DT.[name])), '') AS [design_type],
		   ISNULL(LTRIM(RTRIM(CT.[name])), '') AS [construction_type],
		   ISNULL(LTRIM(RTRIM(RT.[name])), '') AS [roof_type],
		   ISNULL(IQ.[age], 0) AS [age], -- can be represented as YYYY or NNN
		   ISNULL(IQ.[square_metres], 0) AS [square_metres],
		   ISNULL(IQ.[ob_bungalow], 0) AS [ob_bungalow],
		   ISNULL(IQ.[ob_fibro_shed], 0) AS [ob_fibro_shed],
		   ISNULL(IQ.[ob_brick_shed], 0) AS [ob_brick_shed],
		   ISNULL(IQ.[ob_metal_shed], 0) AS [ob_metal_shed],
		   ISNULL(IQ.[ob_metal_garage], 0) AS [ob_metal_garage],
		   ISNULL(IQ.[ob_above_ground_pool], 0) AS [ob_above_ground_pool],
		   ISNULL(IQ.[ob_pergola], 0) AS [ob_pergola],
		   ISNULL(IQ.[ob_timber_carport], 0) AS [ob_timber_carport],
		   ISNULL(IQ.[ob_brick_carport], 0) AS [ob_brick_carport],
		   ISNULL(IQ.[ob_dog_kennel], 0) AS [ob_dog_kennel],
		   ISNULL(IQ.[ob_external_laundry], 0) AS [ob_external_laundry],
		   ISNULL(IQ.[ob_below_ground_pool], 0) AS [ob_below_ground_pool],
		   ISNULL(IQ.[ob_external_wc], 0) AS [ob_external_wc],
		   ISNULL(IQ.[ob_bbq_area], 0) AS [ob_bbq_area],
		   ISNULL(IQ.[ob_pool_room], 0) AS [ob_pool_room],
		   ISNULL(IQ.[ob_store_room], 0) AS [ob_store_room],
		   ISNULL(IQ.[ob_cubby_house], 0) AS [ob_cubby_house],
		   ISNULL(IQ.[ob_pump_room], 0) AS [ob_pump_room],
		   ISNULL(IQ.[ob_granny_flat], 0) AS [ob_granny_flat],
		   ISNULL(IQ.[ob_fibro_garage], 0) AS [ob_fibro_garage],
		   ISNULL(IQ.[ob_brick_garage], 0) AS [ob_brick_garage],
		   ISNULL(IQ.[ob_carport_metal], 0) AS [ob_carport_metal],
		   ISNULL(IQ.[ob_screen_enclosures], 0) AS [ob_screen_enclosures],
		   ISNULL(IQ.[ob_fence], 0) AS [ob_fence],
		   HH.[name] AS [home_habitable],
		   ISNULL(IQ.[VacateDays], 0) AS [vacate_days],
		   ISNULL(IQ.[contains_asbestos], 'No') AS [contains_asbestos],
		   ISNULL(IQ.[home_warranty_required], 0) AS [home_warranty_required],
		   ISNULL(IQ.[Home_Warranty_Sum], CAST(0 AS DECIMAL(9, 2))) AS [home_warranty_sum],
		   -- Damage Report
		   ISNULL(IQ.[details_and_Circumstances], '') AS [details_and_Circumstances],
		   ISNULL(IQ.[sun_resultant_damage], '') AS [sun_resultant_damage],
		   ISNULL(IQ.[comments], '') AS [comments], -- assessor comments
		   ISNULL(IQ.[supplier_ref], '') AS [supplier_ref],
		   -- Policy Exclusions / Maintenance defects
		   LTRIM(RTRIM(ISNULL(IQ.[sun_maintenance_defects], ''))) AS [sun_maintenance_defects],
		   [sun_insured_advised] = CASE LTRIM(RTRIM(ISNULL(IQ.[sun_insured_advised], '')))
										WHEN '' THEN 'No'
		                                WHEN '0' THEN 'No'
										WHEN '1' THEN 'No'
										WHEN '2' THEN 'Yes'
										ELSE LTRIM(RTRIM(IQ.[sun_insured_advised]))
										END,
		   ISNULL(IQ.[est_job_cost], CAST(0 AS DECIMAL(9, 2))) AS [est_job_cost],
		   -- Claim Assessment Summary
		   LTRIM(RTRIM(ISNULL(IQ.[sun_claim_covered], ''))) AS [sun_claim_covered],
		   [sun_action_required] = CASE LTRIM(RTRIM(ISNULL(IQ.[sun_action_required], '')))
		                           WHEN '' THEN 'No'
								   WHEN '1' THEN 'No'
								   WHEN '2' THEN 'Yes'
								   ELSE LTRIM(RTRIM(IQ.[sun_action_required]))
								   END,
			[recommendation] = CASE LTRIM(RTRIM(IR.[name]))
			                   WHEN 'Unsure' THEN 'Unsure / Refer to Insurer'
							   ELSE IR.[name]
							   END,
		    LTRIM(RTRIM(ISNULL(IQ.[sun_action_desc], ''))) AS [sun_action_desc],
			[sun_contents_involved] = CASE LTRIM(RTRIM(ISNULL(IQ.[sun_contents_involved], '')))
			                          WHEN '' THEN 'No'
									  WHEN '1' THEN 'No'
									  WHEN '2' THEN 'Yes'
									  ELSE LTRIM(RTRIM(IQ.[sun_contents_involved]))
									  END,
			LTRIM(RTRIM(ISNULL(IQ.[sun_contents_desc], ''))) AS [sun_contents_desc],
			-- Report Conclusion
			ISNULL(IQ.[incident_confirmed], 0) AS [incident_confirmed],
			ISNULL(IQ.[sum_insured_adequate], 0) AS [sum_insured_adequate],
			ISNULL(IQ.[has_insured_been_advised], 0) AS [has_insured_been_advised],
			ISNULL(IQ.[is_insured_aware_of_repairs], 0) AS [is_insured_aware_of_repairs],
			ISNULL(IQ.[is_iag_assessment_required], 0) AS [is_iag_assessment_required],
			ISNULL(IQ.[make_safe], 0) AS [make_safe],
			ISNULL(IQ.[client_willing_to_proceed], 0) AS [client_willing_to_proceed],
			-- Hidden Fields
			ISNULL(IQ.[overall_condition_acceptable], 0) AS [overall_condition_acceptable],
			ISNULL(IQ.[est_labour_markup], 0) AS [est_labour_markup],
			ISNULL(IQ.[est_material_markup], 0) AS [est_material_markup],
			ISNULL(IQ.[est_room_cost], 0) AS [est_room_cost],
			ISNULL(IQ.[est_room_sale_price], 0) AS [est_room_sale_price],
			ISNULL(IQ.[est_job_sale_price], 0) AS [est_job_sale_price],
			ISNULL(IQ.[est_room_profit], 0) AS [est_room_profit],
			ISNULL(IQ.[est_job_profit], 0) AS [est_job_profit],
			ISNULL(IQ.[profit_percentage], 0) AS [profit_percentage],
			ISNULL(IQ.[labour_total], 0) AS [labour_total],
			ISNULL(IQ.[material_total], 0) AS [material_total],
			ISNULL(IQ.[room_trade_total], 0) AS [room_trade_total],
			ISNULL(IQ.[job_trade_total], 0) AS [job_trade_total],
			ISNULL(IQ.[insurance_trade_id], 0) AS [insurance_trade_id],
			ISNULL(IQ.[insurance_room_id], 0) AS [insurance_room_id],
			ISNULL(IQ.[sun_client_discussion], '') AS [sun_client_discussion],
			ISNULL(IQ.[sun_resultant_damage], '') AS [sun_resultant_damage],
			ISNULL(IQ.[sun_conclusion], '') AS [sun_conclusion],
			IQ.[sun_estimate],
			ISNULL(IQ.[sun_maintenance_defects_not_covered], '') AS [sun_maintenance_defects_not_covered],
			ISNULL(IQ.[sun_insured_advised_not_covered], '') AS [sun_insured_advised_not_covered],
			IQ.[sun_estimate_not_covered],
			ISNULL(IQ.[sun_recovery_details], '') AS [sun_recovery_details],
			IQ.[sun_total_estimate],
			--ISNULL(IQ.[attach_filename], '') AS [attach_filename],
			--IQ.[attach],
			--ISNULL(IQ.[proceed_filename], '') AS [proceed_filename],
			--IQ.[proceed_doc],
			--ISNULL(IQ.[signed_filename], '') AS [signed_filename],
			--IQ.[signed_doc],
			IQ.[negative_quote_id],
			ISNULL(IQ.[from_search], 0) AS [from_search],
			ISNULL(IQ.[is_fake_neg_quote], 0) AS [is_fake_neg_quote],
			ISNULL(IQ.[fake_bypass], 0) AS [fake_bypass],
			ISNULL(IQ.[variation_checked_by], '') AS [variation_checked_by],
			IQ.[variation_checked_on],
			IQ.[est_job_sale_price_with_HOW],
			IQ.[SignNumber],
			IQ.[SignedByClient],
			IQ.[Damage_match_explanation],
			IQ.[Maintenance_issues_noted],
			IQ.[Damage_Result_Of],
			IQ.[Damage_Date],
			IQ.[Repairs_Proceeding_per_authorisation_limits],
			IQ.[Damage_Date2],
			IQ.[created_by],
			IQ.[create_date],
			IQ.[updated_by],
			IQ.[updated_date]
	FROM    [dbo].[Insurance_Quote] IQ
			LEFT JOIN [dbo].[Insurance_QuoteStatus] QS ON QS.[id] = IQ.[status]
			LEFT JOIN [dbo].[Insurance_WorkOrder] IW ON IW.[ORDER_ID] = IQ.[Order_id]
			LEFT JOIN [dbo].[InsuranceStatus] IWS ON IWS.[id] = IW.[status_id]
			LEFT JOIN [dbo].[Orders] O ON O.[ORDER_ID] = IQ.[Order_id]
			LEFT JOIN [dbo].[InsuranceStatus] JS ON JS.[id] = O.[STATUS]
			LEFT JOIN [dbo].[Insurance_BuildingType] BT ON BT.[id] = IQ.[building_type]
			LEFT JOIN [dbo].[Insurance_DesignType] DT ON DT.[id] = IQ.[design_type]
			LEFT JOIN [dbo].[Insurance_ConstructionType] CT ON CT.[id] = IQ.[construction_type]
			LEFT JOIN [dbo].[Insurance_RoofType] RT ON RT.[id] = IQ.[roof_type]
			LEFT JOIN [dbo].[Insurance_HomeHabitable] HH ON HH.[id] = IQ.[home_habitable]
			LEFT JOIN [dbo].[Insurance_YesNo] HW ON HW.[id] = ISNULL(IQ.[home_warranty_required], 2) -- defaults to NO
			LEFT JOIN [dbo].[Insurance_Recommendation] IR ON IR.[id] = ISNULL(IQ.[recommendation], 3) -- defaults to Unsure
	WHERE  IQ.[Order_id] = ISNULL(@OrderId, 0)
    AND    ((IQ.[supplier_ref] IS NULL) AND (DATALENGTH(ISNULL(@SupplierRef, '')) = 0) OR (LTRIM(RTRIM(IQ.[supplier_ref])) = LTRIM(RTRIM(@SupplierRef))))
    AND    ((IQ.[version_label] IS NULL) AND (DATALENGTH(ISNULL(@Version, '')) = 0) OR (LTRIM(RTRIM(IQ.[version_label])) = LTRIM(RTRIM(@Version))));

	SET NOCOUNT OFF;

END;
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Quote_Get_Quote_By_Id'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Quote_Get_Quote_by_Id];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 25 February 2013
-- Description:	Obtains the insurance quote from the specified insurance quote identity.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Quote_Get_Quote_By_Id] ( @Id INT )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT IQ.[Insurance_Quote_id], 
		   IQ.[Order_id],
		   IQ.[supplier_ref],
		   IW.[search_code_value],
		   IQ.[version_label],
		   IQ.[variation_type],
		   [job_status] = LTRIM(RTRIM(ISNULL(JS.[name], ''))),
		   [work_order_status] = LTRIM(RTRIM(ISNULL(IWS.[name], ''))),
		   [quote_status] = LTRIM(RTRIM(ISNULL(QS.[name], ''))),
		   -- Site Inspection
		   IQ.[initial_contact_datetime],
		   IQ.[site_attend_datetime],
		   ISNULL(IQ.[attend_with_insured], 0) AS [attend_with_insured],
		   ISNULL(IQ.[attend_with_rep], 0) AS [attend_with_rep],
		   ISNULL(IQ.[reps_name], '') AS [reps_name],
		   ISNULL(IQ.[attend_with_noone], 0) AS [attend_with_noone],
		   ISNULL(IQ.[attend_na], 0) AS [attend_na],
		   -- Property Description
		   LTRIM(RTRIM(BT.[name])) AS [building_type],
		   LTRIM(RTRIM(DT.[name])) AS [design_type],
		   LTRIM(RTRIM(CT.[name])) AS [construction_type],
		   LTRIM(RTRIM(RT.[name])) AS [roof_type],
		   ISNULL(IQ.[age], 0) AS [age], -- can be represented as YYYY or NNN
		   ISNULL(IQ.[square_metres], 0) AS [square_metres],
		   ISNULL(IQ.[ob_bungalow], 0) AS [ob_bungalow],
		   ISNULL(IQ.[ob_fibro_shed], 0) AS [ob_fibro_shed],
		   ISNULL(IQ.[ob_brick_shed], 0) AS [ob_brick_shed],
		   ISNULL(IQ.[ob_metal_shed], 0) AS [ob_metal_shed],
		   ISNULL(IQ.[ob_metal_garage], 0) AS [ob_metal_garage],
		   ISNULL(IQ.[ob_above_ground_pool], 0) AS [ob_above_ground_pool],
		   ISNULL(IQ.[ob_pergola], 0) AS [ob_pergola],
		   ISNULL(IQ.[ob_timber_carport], 0) AS [ob_timber_carport],
		   ISNULL(IQ.[ob_brick_carport], 0) AS [ob_brick_carport],
		   ISNULL(IQ.[ob_dog_kennel], 0) AS [ob_dog_kennel],
		   ISNULL(IQ.[ob_external_laundry], 0) AS [ob_external_laundry],
		   ISNULL(IQ.[ob_below_ground_pool], 0) AS [ob_below_ground_pool],
		   ISNULL(IQ.[ob_external_wc], 0) AS [ob_external_wc],
		   ISNULL(IQ.[ob_bbq_area], 0) AS [ob_bbq_area],
		   ISNULL(IQ.[ob_pool_room], 0) AS [ob_pool_room],
		   ISNULL(IQ.[ob_store_room], 0) AS [ob_store_room],
		   ISNULL(IQ.[ob_cubby_house], 0) AS [ob_cubby_house],
		   ISNULL(IQ.[ob_pump_room], 0) AS [ob_pump_room],
		   ISNULL(IQ.[ob_granny_flat], 0) AS [ob_granny_flat],
		   ISNULL(IQ.[ob_fibro_garage], 0) AS [ob_fibro_garage],
		   ISNULL(IQ.[ob_brick_garage], 0) AS [ob_brick_garage],
		   ISNULL(IQ.[ob_carport_metal], 0) AS [ob_carport_metal],
		   ISNULL(IQ.[ob_screen_enclosures], 0) AS [ob_screen_enclosures],
		   ISNULL(IQ.[ob_fence], 0) AS [ob_fence],
		   HH.[name] AS [home_habitable],
		   ISNULL(IQ.[VacateDays], 0) AS [vacate_days],
		   ISNULL(IQ.[contains_asbestos], 'No') AS [contains_asbestos],
		   ISNULL(IQ.[home_warranty_required], 0) AS [home_warranty_required],
		   ISNULL(IQ.[Home_Warranty_Sum], CAST(0 AS DECIMAL(9, 2))) AS [home_warranty_sum],
		   -- Damage Report
		   ISNULL(IQ.[details_and_Circumstances], '') AS [details_and_Circumstances],
		   ISNULL(IQ.[sun_resultant_damage], '') AS [sun_resultant_damage],
		   ISNULL(IQ.[comments], '') AS [comments], -- assessor comments
		   ISNULL(IQ.[supplier_ref], '') AS [supplier_ref],
		   -- Policy Exclusions / Maintenance defects
		   LTRIM(RTRIM(ISNULL(IQ.[sun_maintenance_defects], ''))) AS [sun_maintenance_defects],
		   [sun_insured_advised] = CASE LTRIM(RTRIM(ISNULL(IQ.[sun_insured_advised], '')))
										WHEN '' THEN 'No'
		                                WHEN '0' THEN 'No'
										WHEN '1' THEN 'No'
										WHEN '2' THEN 'Yes'
										ELSE LTRIM(RTRIM(IQ.[sun_insured_advised]))
										END,
		   ISNULL(IQ.[est_job_cost], CAST(0 AS DECIMAL(9, 2))) AS [est_job_cost],
		   -- Claim Assessment Summary
		   LTRIM(RTRIM(ISNULL(IQ.[sun_claim_covered], ''))) AS [sun_claim_covered],
		   [sun_action_required] = CASE LTRIM(RTRIM(ISNULL(IQ.[sun_action_required], '')))
		                           WHEN '' THEN 'No'
								   WHEN '1' THEN 'No'
								   WHEN '2' THEN 'Yes'
								   ELSE LTRIM(RTRIM(IQ.[sun_action_required]))
								   END,
			[recommendation] = CASE LTRIM(RTRIM(IR.[name]))
			                   WHEN 'Unsure' THEN 'Unsure / Refer to Insurer'
							   ELSE IR.[name]
							   END,
		    LTRIM(RTRIM(ISNULL(IQ.[sun_action_desc], ''))) AS [sun_action_desc],
			[sun_contents_involved] = CASE LTRIM(RTRIM(ISNULL(IQ.[sun_contents_involved], '')))
			                          WHEN '' THEN 'No'
									  WHEN '1' THEN 'No'
									  WHEN '2' THEN 'Yes'
									  ELSE LTRIM(RTRIM(IQ.[sun_contents_involved]))
									  END,
			LTRIM(RTRIM(ISNULL(IQ.[sun_contents_desc], ''))) AS [sun_contents_desc],
			-- Report Conclusion
			ISNULL(IQ.[incident_confirmed], 0) AS [incident_confirmed],
			ISNULL(IQ.[sum_insured_adequate], 0) AS [sum_insured_adequate],
			ISNULL(IQ.[has_insured_been_advised], 0) AS [has_insured_been_advised],
			ISNULL(IQ.[is_insured_aware_of_repairs], 0) AS [is_insured_aware_of_repairs],
			ISNULL(IQ.[is_iag_assessment_required], 0) AS [is_iag_assessment_required],
			ISNULL(IQ.[make_safe], 0) AS [make_safe],
			ISNULL(IQ.[client_willing_to_proceed], 0) AS [client_willing_to_proceed],
			-- Hidden Fields
			ISNULL(IQ.[overall_condition_acceptable], 0) AS [overall_condition_acceptable],
			ISNULL(IQ.[est_labour_markup], 0) AS [est_labour_markup],
			ISNULL(IQ.[est_material_markup], 0) AS [est_material_markup],
			ISNULL(IQ.[est_room_cost], 0) AS [est_room_cost],
			ISNULL(IQ.[est_room_sale_price], 0) AS [est_room_sale_price],
			ISNULL(IQ.[est_job_sale_price], 0) AS [est_job_sale_price],
			ISNULL(IQ.[est_room_profit], 0) AS [est_room_profit],
			ISNULL(IQ.[est_job_profit], 0) AS [est_job_profit],
			ISNULL(IQ.[profit_percentage], 0) AS [profit_percentage],
			ISNULL(IQ.[labour_total], 0) AS [labour_total],
			ISNULL(IQ.[material_total], 0) AS [material_total],
			ISNULL(IQ.[room_trade_total], 0) AS [room_trade_total],
			ISNULL(IQ.[job_trade_total], 0) AS [job_trade_total],
			ISNULL(IQ.[insurance_trade_id], 0) AS [insurance_trade_id],
			ISNULL(IQ.[insurance_room_id], 0) AS [insurance_room_id],
			ISNULL(IQ.[sun_client_discussion], '') AS [sun_client_discussion],
			ISNULL(IQ.[sun_resultant_damage], '') AS [sun_resultant_damage],
			ISNULL(IQ.[sun_conclusion], '') AS [sun_conclusion],
			IQ.[sun_estimate],
			ISNULL(IQ.[sun_maintenance_defects_not_covered], '') AS [sun_maintenance_defects_not_covered],
			ISNULL(IQ.[sun_insured_advised_not_covered], '') AS [sun_insured_advised_not_covered],
			IQ.[sun_estimate_not_covered],
			ISNULL(IQ.[sun_recovery_details], '') AS [sun_recovery_details],
			IQ.[sun_total_estimate],
			IQ.[cost_of_repairs],
			IQ.[sun_cause_of_damage],
			--ISNULL(IQ.[attach_filename], '') AS [attach_filename],
			--IQ.[attach],
			--ISNULL(IQ.[proceed_filename], '') AS [proceed_filename],
			--IQ.[proceed_doc],
			--ISNULL(IQ.[signed_filename], '') AS [signed_filename],
			--IQ.[signed_doc],
			IQ.[negative_quote_id],
			ISNULL(IQ.[from_search], 0) AS [from_search],
			ISNULL(IQ.[is_fake_neg_quote], 0) AS [is_fake_neg_quote],
			ISNULL(IQ.[fake_bypass], 0) AS [fake_bypass],
			ISNULL(IQ.[variation_checked_by], '') AS [variation_checked_by],
			IQ.[variation_checked_on],
			IQ.[est_job_sale_price_with_HOW],
			IQ.[SignNumber],
			IQ.[SignedByClient],
			IQ.[Damage_match_explanation],
			IQ.[Maintenance_issues_noted],
			IQ.[Damage_Result_Of],
			IQ.[Damage_Date],
			IQ.[Repairs_Proceeding_per_authorisation_limits],
			IQ.[Damage_Date2],
			IQ.[created_by],
			IQ.[create_date],
			IQ.[updated_by],
			IQ.[updated_date]
	FROM    [dbo].[Insurance_Quote] IQ
			INNER JOIN [dbo].[Insurance_WorkOrder] IW ON IW.[ORDER_ID] = IQ.[Order_id]
			LEFT JOIN [dbo].[Insurance_QuoteStatus] QS ON QS.[id] = IQ.[status]
			LEFT JOIN [dbo].[InsuranceStatus] IWS ON IWS.[id] = IW.[status_id]
			LEFT JOIN [dbo].[Orders] O ON O.[ORDER_ID] = IQ.[Order_id]
			LEFT JOIN [dbo].[InsuranceStatus] JS ON JS.[id] = O.[STATUS]
			LEFT JOIN [dbo].[Insurance_BuildingType] BT ON BT.[id] = IQ.[building_type]
			LEFT JOIN [dbo].[Insurance_DesignType] DT ON DT.[id] = IQ.[design_type]
			LEFT JOIN [dbo].[Insurance_ConstructionType] CT ON CT.[id] = IQ.[construction_type]
			LEFT JOIN [dbo].[Insurance_RoofType] RT ON RT.[id] = IQ.[roof_type]
			LEFT JOIN [dbo].[Insurance_HomeHabitable] HH ON HH.[id] = IQ.[home_habitable]
			LEFT JOIN [dbo].[Insurance_YesNo] HW ON HW.[id] = ISNULL(IQ.[home_warranty_required], 2) -- defaults to NO
			LEFT JOIN [dbo].[Insurance_Recommendation] IR ON IR.[id] = ISNULL(IQ.[recommendation], 3) -- defaults to Unsure
	WHERE  IQ.[Insurance_Quote_id] = ISNULL(@Id, 0)

	SET NOCOUNT OFF;

END;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Quote_Get_Quotes_By_Order'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Quote_Get_Quotes_By_Order];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 29 January 2013
-- Description:	Obtains the insurance quote version / status details.
--
-- Modification: The circumstances information was replaced by the insurance
--               work order status.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Quote_Get_Quotes_By_Order] ( @OrderId INT )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT IQ.[Insurance_Quote_id] AS [Quote Id], 
	       LTRIM(RTRIM(ISNULL(IQ.[version_label], ''))) AS [Version],
		   [Variation Type] = CASE
						      WHEN IQ.[variation_type] IS NULL THEN 'Revision'
							  WHEN IQ.[variation_type] = 1 THEN 'Positive variation'
							  WHEN IQ.[variation_type] = 2 THEN 'Negative variation'
							  ELSE 'Revision'
							  END,
		   [Job Status] = JS.[name],
		   [Work Order Status] = LTRIM(RTRIM(IWS.[name])),
		   [Quote Status] = CASE WHEN QS.[name] IS NULL THEN 
								CASE WHEN IWS.[name] = 'Inspected' THEN 'In Progress'
									 WHEN IWS.[name] = 'Quote Started' THEN 'In Progress'
								ELSE 'Unspecified'
								END
							ELSE QS.[name]
							END,
		   IQ.[create_date] AS [Creation Date],
		   IQ.[created_by] AS [Created By], 
		   IQ.[est_job_sale_price] AS [Quote Price],
		   IQ.[supplier_ref] AS [Claim Reference]
	FROM [dbo].[Insurance_Quote] IQ
	LEFT JOIN [dbo].[Insurance_QuoteStatus] QS ON QS.[id] = IQ.[status]
	LEFT JOIN [dbo].[Insurance_WorkOrder] IW ON IW.[ORDER_ID] = IQ.[Order_id]
	LEFT JOIN [dbo].[InsuranceStatus] IWS ON IWS.[id] = IW.[status_id]
	LEFT JOIN [dbo].[Orders] O ON O.[ORDER_ID] = IQ.[Order_id]
	LEFT JOIN [dbo].[InsuranceStatus] JS ON JS.[id] = O.[STATUS]
	WHERE IQ.[order_id] = ISNULL(@OrderId, 0)
	ORDER BY IQ.[Insurance_Quote_id];

	SET NOCOUNT OFF;

END;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Quote_Get_Quotes_By_OrderID'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Quote_Get_Quotes_By_OrderID];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

-- =============================================
-- Author: Andrei Baranovski
-- Create date: 22 may 2012
-- =============================================
CREATE PROCEDURE [dbo].[Insurance_Quote_Get_Quotes_By_OrderID]	
	@OrderID int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT [Insurance_Quote_id] AS Quote_ID
		  ,[version_label] AS [Version]     
		  ,[created_by] AS [Created By]
		  ,[create_date] AS [Date]
		  , LEFT ([details_and_Circumstances], 100) AS [Details]
		  ,[est_job_sale_price] AS [Job Price]
		  ,[supplier_ref] AS [Claim Ref]
	FROM [Insurance_Quote]
	WHERE (order_id=@OrderID) AND (version_label IS NOT NULL)

END;
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Quote_Get_Quote_By_OrderId'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Quote_Get_Quote_By_OrderId];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 13 March 2013
-- Description:	Gets the insurance quote(s) that contains the reference to the
--              insurance work order and the insurance work order status.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Quote_Get_Quote_By_OrderId] ( @OrderId INT, @OrderStatus VARCHAR(50) )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT IQ.[Insurance_Quote_id], 
		   IQ.[Order_id],
		   IQ.[supplier_ref],
		   IW.[search_code_value],
		   IQ.[version_label],
		   IQ.[variation_type],
		   [job_status] = LTRIM(RTRIM(ISNULL(JS.[name], ''))),
		   [work_order_status] = LTRIM(RTRIM(ISNULL(IWS.[name], ''))),
		   [quote_status] = LTRIM(RTRIM(ISNULL(QS.[name], ''))),
		   -- Site Inspection
		   IQ.[initial_contact_datetime],
		   IQ.[site_attend_datetime],
		   ISNULL(IQ.[attend_with_insured], 0) AS [attend_with_insured],
		   ISNULL(IQ.[attend_with_rep], 0) AS [attend_with_rep],
		   ISNULL(IQ.[reps_name], '') AS [reps_name],
		   ISNULL(IQ.[attend_with_noone], 0) AS [attend_with_noone],
		   ISNULL(IQ.[attend_na], 0) AS [attend_na],
		   -- Property Description
		   ISNULL(LTRIM(RTRIM(BT.[name])), '') AS [building_type],
		   ISNULL(LTRIM(RTRIM(DT.[name])), '') AS [design_type],
		   ISNULL(LTRIM(RTRIM(CT.[name])), '') AS [construction_type],
		   ISNULL(LTRIM(RTRIM(RT.[name])), '') AS [roof_type],
		   ISNULL(IQ.[age], 0) AS [age], -- can be represented as YYYY or NNN
		   ISNULL(IQ.[square_metres], 0) AS [square_metres],
		   ISNULL(IQ.[ob_bungalow], 0) AS [ob_bungalow],
		   ISNULL(IQ.[ob_fibro_shed], 0) AS [ob_fibro_shed],
		   ISNULL(IQ.[ob_brick_shed], 0) AS [ob_brick_shed],
		   ISNULL(IQ.[ob_metal_shed], 0) AS [ob_metal_shed],
		   ISNULL(IQ.[ob_metal_garage], 0) AS [ob_metal_garage],
		   ISNULL(IQ.[ob_above_ground_pool], 0) AS [ob_above_ground_pool],
		   ISNULL(IQ.[ob_pergola], 0) AS [ob_pergola],
		   ISNULL(IQ.[ob_timber_carport], 0) AS [ob_timber_carport],
		   ISNULL(IQ.[ob_brick_carport], 0) AS [ob_brick_carport],
		   ISNULL(IQ.[ob_dog_kennel], 0) AS [ob_dog_kennel],
		   ISNULL(IQ.[ob_external_laundry], 0) AS [ob_external_laundry],
		   ISNULL(IQ.[ob_below_ground_pool], 0) AS [ob_below_ground_pool],
		   ISNULL(IQ.[ob_external_wc], 0) AS [ob_external_wc],
		   ISNULL(IQ.[ob_bbq_area], 0) AS [ob_bbq_area],
		   ISNULL(IQ.[ob_pool_room], 0) AS [ob_pool_room],
		   ISNULL(IQ.[ob_store_room], 0) AS [ob_store_room],
		   ISNULL(IQ.[ob_cubby_house], 0) AS [ob_cubby_house],
		   ISNULL(IQ.[ob_pump_room], 0) AS [ob_pump_room],
		   ISNULL(IQ.[ob_granny_flat], 0) AS [ob_granny_flat],
		   ISNULL(IQ.[ob_fibro_garage], 0) AS [ob_fibro_garage],
		   ISNULL(IQ.[ob_brick_garage], 0) AS [ob_brick_garage],
		   ISNULL(IQ.[ob_carport_metal], 0) AS [ob_carport_metal],
		   ISNULL(IQ.[ob_screen_enclosures], 0) AS [ob_screen_enclosures],
		   ISNULL(IQ.[ob_fence], 0) AS [ob_fence],
		   HH.[name] AS [home_habitable],
		   ISNULL(IQ.[VacateDays], 0) AS [vacate_days],
		   ISNULL(IQ.[contains_asbestos], 'No') AS [contains_asbestos],
		   ISNULL(IQ.[home_warranty_required], 0) AS [home_warranty_required],
		   ISNULL(IQ.[Home_Warranty_Sum], CAST(0 AS DECIMAL(9, 2))) AS [home_warranty_sum],
		   -- Damage Report
		   ISNULL(IQ.[details_and_Circumstances], '') AS [details_and_Circumstances],
		   ISNULL(IQ.[sun_resultant_damage], '') AS [sun_resultant_damage],
		   ISNULL(IQ.[comments], '') AS [comments], -- assessor comments
		   ISNULL(IQ.[supplier_ref], '') AS [supplier_ref],
		   -- Policy Exclusions / Maintenance defects
		   LTRIM(RTRIM(ISNULL(IQ.[sun_maintenance_defects], ''))) AS [sun_maintenance_defects],
		   [sun_insured_advised] = CASE LTRIM(RTRIM(ISNULL(IQ.[sun_insured_advised], '')))
										WHEN '' THEN 'No'
		                                WHEN '0' THEN 'No'
										WHEN '1' THEN 'No'
										WHEN '2' THEN 'Yes'
										ELSE LTRIM(RTRIM(IQ.[sun_insured_advised]))
										END,
		   ISNULL(IQ.[est_job_cost], CAST(0 AS DECIMAL(9, 2))) AS [est_job_cost],
		   -- Claim Assessment Summary
		   LTRIM(RTRIM(ISNULL(IQ.[sun_claim_covered], ''))) AS [sun_claim_covered],
		   [sun_action_required] = CASE LTRIM(RTRIM(ISNULL(IQ.[sun_action_required], '')))
		                           WHEN '' THEN 'No'
								   WHEN '1' THEN 'No'
								   WHEN '2' THEN 'Yes'
								   ELSE LTRIM(RTRIM(IQ.[sun_action_required]))
								   END,
			[recommendation] = CASE LTRIM(RTRIM(IR.[name]))
			                   WHEN 'Unsure' THEN 'Unsure / Refer to Insurer'
							   ELSE IR.[name]
							   END,
		    LTRIM(RTRIM(ISNULL(IQ.[sun_action_desc], ''))) AS [sun_action_desc],
			[sun_contents_involved] = CASE LTRIM(RTRIM(ISNULL(IQ.[sun_contents_involved], '')))
			                          WHEN '' THEN 'No'
									  WHEN '1' THEN 'No'
									  WHEN '2' THEN 'Yes'
									  ELSE LTRIM(RTRIM(IQ.[sun_contents_involved]))
									  END,
			LTRIM(RTRIM(ISNULL(IQ.[sun_contents_desc], ''))) AS [sun_contents_desc],
			-- Report Conclusion
			ISNULL(IQ.[incident_confirmed], 0) AS [incident_confirmed],
			ISNULL(IQ.[sum_insured_adequate], 0) AS [sum_insured_adequate],
			ISNULL(IQ.[has_insured_been_advised], 0) AS [has_insured_been_advised],
			ISNULL(IQ.[is_insured_aware_of_repairs], 0) AS [is_insured_aware_of_repairs],
			ISNULL(IQ.[is_iag_assessment_required], 0) AS [is_iag_assessment_required],
			ISNULL(IQ.[make_safe], 0) AS [make_safe],
			ISNULL(IQ.[client_willing_to_proceed], 0) AS [client_willing_to_proceed],
			-- Hidden Fields
			ISNULL(IQ.[overall_condition_acceptable], 0) AS [overall_condition_acceptable],
			ISNULL(IQ.[est_labour_markup], 0) AS [est_labour_markup],
			ISNULL(IQ.[est_material_markup], 0) AS [est_material_markup],
			ISNULL(IQ.[est_room_cost], 0) AS [est_room_cost],
			ISNULL(IQ.[est_room_sale_price], 0) AS [est_room_sale_price],
			ISNULL(IQ.[est_job_sale_price], 0) AS [est_job_sale_price],
			ISNULL(IQ.[est_room_profit], 0) AS [est_room_profit],
			ISNULL(IQ.[est_job_profit], 0) AS [est_job_profit],
			ISNULL(IQ.[profit_percentage], 0) AS [profit_percentage],
			ISNULL(IQ.[labour_total], 0) AS [labour_total],
			ISNULL(IQ.[material_total], 0) AS [material_total],
			ISNULL(IQ.[room_trade_total], 0) AS [room_trade_total],
			ISNULL(IQ.[job_trade_total], 0) AS [job_trade_total],
			ISNULL(IQ.[insurance_trade_id], 0) AS [insurance_trade_id],
			ISNULL(IQ.[insurance_room_id], 0) AS [insurance_room_id],
			ISNULL(IQ.[sun_client_discussion], '') AS [sun_client_discussion],
			ISNULL(IQ.[sun_resultant_damage], '') AS [sun_resultant_damage],
			ISNULL(IQ.[sun_conclusion], '') AS [sun_conclusion],
			IQ.[sun_estimate],
			ISNULL(IQ.[sun_maintenance_defects_not_covered], '') AS [sun_maintenance_defects_not_covered],
			ISNULL(IQ.[sun_insured_advised_not_covered], '') AS [sun_insured_advised_not_covered],
			IQ.[sun_estimate_not_covered],
			ISNULL(IQ.[sun_recovery_details], '') AS [sun_recovery_details],
			IQ.[sun_total_estimate],
			--ISNULL(IQ.[attach_filename], '') AS [attach_filename],
			--IQ.[attach],
			--ISNULL(IQ.[proceed_filename], '') AS [proceed_filename],
			--IQ.[proceed_doc],
			--ISNULL(IQ.[signed_filename], '') AS [signed_filename],
			--IQ.[signed_doc],
			IQ.[negative_quote_id],
			ISNULL(IQ.[from_search], 0) AS [from_search],
			ISNULL(IQ.[is_fake_neg_quote], 0) AS [is_fake_neg_quote],
			ISNULL(IQ.[fake_bypass], 0) AS [fake_bypass],
			ISNULL(IQ.[variation_checked_by], '') AS [variation_checked_by],
			IQ.[variation_checked_on],
			IQ.[est_job_sale_price_with_HOW],
			IQ.[SignNumber],
			IQ.[SignedByClient],
			IQ.[Damage_match_explanation],
			IQ.[Maintenance_issues_noted],
			IQ.[Damage_Result_Of],
			IQ.[Damage_Date],
			IQ.[Repairs_Proceeding_per_authorisation_limits],
			IQ.[Damage_Date2],
			IQ.[created_by],
			IQ.[create_date],
			IQ.[updated_by],
			IQ.[updated_date]
	FROM    [dbo].[Insurance_Quote] IQ
			INNER JOIN [dbo].[Insurance_WorkOrder] IW ON IW.[ORDER_ID] = IQ.[Order_id]
			LEFT JOIN [dbo].[Insurance_QuoteStatus] QS ON QS.[id] = IQ.[status]
			LEFT JOIN [dbo].[InsuranceStatus] IWS ON IWS.[id] = IW.[status_id]
			LEFT JOIN [dbo].[Orders] O ON O.[ORDER_ID] = IQ.[Order_id]
			LEFT JOIN [dbo].[InsuranceStatus] JS ON JS.[id] = O.[STATUS]
			LEFT JOIN [dbo].[Insurance_BuildingType] BT ON BT.[id] = IQ.[building_type]
			LEFT JOIN [dbo].[Insurance_DesignType] DT ON DT.[id] = IQ.[design_type]
			LEFT JOIN [dbo].[Insurance_ConstructionType] CT ON CT.[id] = IQ.[construction_type]
			LEFT JOIN [dbo].[Insurance_RoofType] RT ON RT.[id] = IQ.[roof_type]
			LEFT JOIN [dbo].[Insurance_HomeHabitable] HH ON HH.[id] = IQ.[home_habitable]
			LEFT JOIN [dbo].[Insurance_YesNo] HW ON HW.[id] = ISNULL(IQ.[home_warranty_required], 2) -- defaults to NO
			LEFT JOIN [dbo].[Insurance_Recommendation] IR ON IR.[id] = ISNULL(IQ.[recommendation], 3) -- defaults to Unsure
	WHERE  IQ.[Order_id] = ISNULL(@OrderId, 0)
	AND EXISTS
	(
		SELECT 1 FROM [dbo].[Insurance_WorkOrder] IW
			LEFT JOIN [dbo].[InsuranceStatus] IWS ON IWS.[id] = IW.[status_id] 
				AND IWS.[name] = ISNULL(LTRIM(RTRIM(@OrderStatus)), '')
		WHERE IW.[ORDER_ID] = ISNULL(@OrderId, 0)
	);

	SET NOCOUNT OFF;

END;
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Quote_Copy'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Quote_Copy];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 7 June 2013
-- Description:	Copies the content of the former insurance owrk order quote into
--              the specified insurance work order quote.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Quote_Copy] ( @RecentQuoteId INT, @InsuranceQuoteId INT, @UserName VARCHAR(20) )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	IF ( ISNULL( @RecentQuoteId, - 1) <= 0 ) OR ( NOT EXISTS(SELECT 1 FROM [dbo].[Insurance_Quote] WITH (READCOMMITTED) WHERE [Insurance_Quote_id] = @RecentQuoteId ) )
		RETURN;

	IF ( ISNULL( @InsuranceQuoteId, - 1) <= 0 ) OR ( NOT EXISTS(SELECT 1 FROM [dbo].[Insurance_Quote] WITH (READCOMMITTED) WHERE [Insurance_Quote_id] = @InsuranceQuoteId ) )
		RETURN;

	DECLARE @Transaction INT;

	SET @Transaction = @@TRANCOUNT;

	DECLARE @Error INT;

	SET @Error = @@ERROR;

	IF ( @Transaction = 0 ) BEGIN TRANSACTION;

	BEGIN TRY

		UPDATE [dbo].[Insurance_Quote] WITH (READCOMMITTED) SET
				IQ.[comments] = COPY.[comments],
				IQ.[supplier_ref] = COPY.[supplier_ref],
				IQ.[incident_confirmed] = COPY.[incident_confirmed],
				IQ.[initial_contact_datetime] = COPY.[initial_contact_datetime],
				IQ.[site_attend_datetime] = COPY.[site_attend_date],
				IQ.[attend_with_insured] = COPY.[attend_with_insured],
				IQ.[attend_with_rep] = COPY.[attend_with_rep],
				IQ.[reps_name] = COPY.[reps_name],
				IQ.[attend_with_noone] = COPY.[attend_with_noone],
				IQ.[attend_na] = COPY.[attend_na],
				IQ.[sum_insured_adequate] = COPY.[sum_insured_adequate],
				IQ.[make_safe] = COPY.[make_safe],
				IQ.[has_insured_been_advised] = COPY.[has_insured_been_advised],
				IQ.[is_insured_aware_of_repairs] = COPY.[is_insured_aware_of_repairs],
				IQ.[cost_of_repairs] = COPY.[cost_of_repairs],
				IQ.[recommendation] = COPY.[recommendation],
				IQ.[client_willing_to_proceed] = COPY.[client_willing_to_proceed],
				IQ.[building_type] = COPY.[building_type],
				IQ.[design_type] = COPY.[design_type],
				IQ.[construction_type] = COPY.[construction_type],
				IQ.[roof_type] = COPY.[roof_type],
				IQ.[square_metres] = COPY.[square_metres],
				IQ.[age] = COPY.[age],
				IQ.[overall_condition_acceptable] = COPY.[overall_condition_acceptable],
				IQ.[is_iag_assessment_required] = COPY.[is_iag_assessment_required],
				IQ.[ob_bungalow] = COPY.[ob_bungalow],
				IQ.[ob_fibro_shed] = COPY.[ob_fibro_shed],
				IQ.[ob_brick_shed] = COPY.[ob_brick_shed],
				IQ.[ob_metal_shed] = COPY.[ob_metal_shed],
				IQ.[ob_metal_garage] = COPY.[ob_metal_garage],
				IQ.[ob_above_ground_pool] = COPY.[ob_above_ground_pool],
				IQ.[ob_pergola] = COPY.[ob_pergola],
				IQ.[ob_timber_carport] = COPY.[ob_timber_carport],
				IQ.[ob_brick_carport] = COPY.[ob_brick_carport],
				IQ.[ob_dog_kennel] = COPY.[ob_dog_kennel],
				IQ.[ob_external_laundry] = COPY.[ob_external_laundry],
				IQ.[ob_below_ground_pool] = COPY.[ob_below_ground_pool],
				IQ.[ob_external_wc] = COPY.[ob_external_wc],
				IQ.[ob_bbq_area] = COPY.[ob_bbq_area],
				IQ.[ob_pool_room] = COPY.[ob_pool_room],
				IQ.[ob_store_room] = COPY.[ob_store_room],
				IQ.[ob_cubby_house] = COPY.[ob_cubby_house],
				IQ.[ob_pump_room] = COPY.[ob_pump_room],
				IQ.[ob_granny_flat] = COPY.[ob_granny_flat],
				IQ.[ob_brick_garage] = COPY.[ob_brick_garage],
				IQ.[ob_fibro_garage] = COPY.[ob_fibro_garage],
				IQ.[ob_carport_metal] = COPY.[ob_carport_metal],
				IQ.[ob_screen_enclosures] = COPY.[ob_screen_enclosures],
				IQ.[ob_fence] = COPY.[ob_fence],
				IQ.[est_labour_markup] = COPY.[est_labour_markup],
				IQ.[est_material_markup] = COPY.[est_material_markup],
				IQ.[est_room_cost] = COPY.[est_room_cost],
				IQ.[est_job_cost] = COPY.[est_job_cost],
				IQ.[est_room_sale_price] = COPY.[est_room_sale_price],
				IQ.[est_job_sale_price] = COPY.[est_job_sale_price],
				IQ.[est_room_profit] = COPY.[est_room_profit],
				IQ.[est_job_profit] = COPY.[est_job_profit],
				IQ.[profit_percentage] = COPY.[profit_percentage],
				IQ.[labour_total] = COPY.[labour_total],
				IQ.[material_total] = COPY.[material_total],
				IQ.[room_trade_total] = COPY.[room_trade_total],
				IQ.[job_trade_total] = COPY.[job_trade_total],
				IQ.[insurance_trade_id] = COPY.[insurance_trade_id],
				IQ.[insurance_room_id] = COPY.[insurance_room_id],
				IQ.[sun_client_discussion] = COPY.[sun_client_discussion],
				IQ.[sun_cause_of_damage] = COPY.[sun_cause_of_damage],
				IQ.[sun_conclusion] = COPY.[sun_conclusion],
				IQ.[sun_estimate] = COPY.[sun_estimate],
				IQ.[sun_maintenance_defects_not_covered] = COPY.[sun_maintenance_defects_not_covered],
				IQ.[sun_insured_advised_not_covered] = COPY.[sun_insured_advised_not_covered],
				IQ.[sun_estimate_not_covered] = COPY.[sun_estimate_not_covered],
				IQ.[sun_recovery_details] = COPY.[sun_recovery_details],
				IQ.[sun_total_estimate] = COPY.[sun_total_estimate],
				--IQ.[attach_filename] = COPY.[attach_filename],
				--IQ.[attach] = COPY.[attach],
				--IQ.[proceed_filename] = COPY.[proceed_filename],
				--IQ.[proceed_doc] = COPY.[proceed_doc],
				--IQ.[signed_filename] = COPY.[signed_filename],
				--IQ.[signed_doc] = COPY.[signed_doc],
				IQ.[negative_quote_id] = COPY.[negative_quote_id],
				IQ.[from_search] = COPY.[from_search],
				IQ.[is_fake_neg_quote] = COPY.[is_fake_neg_quote],
				IQ.[fake_bypass] = COPY.[fake_bypass],
				IQ.[variation_checked_by] = COPY.[variation_checked_by],
				IQ.[variation_checked_on] = COPY.[variation_checked_on],
				IQ.[est_job_sale_price_with_HOW] = COPY.[est_job_sale_price_with_HOW],
				IQ.[home_habitable] = COPY.[home_habitable],
				IQ.[VacateDays] = COPY.[VacateDays],
				IQ.[contains_asbestos] = COPY.[contains_asbestos],
				IQ.[home_warranty_required] = COPY.[home_warranty_required],
				IQ.[home_warranty_sum] = COPY.[home_warranty_sum],
				IQ.[sun_resultant_damage] = COPY.[sun_resultant_damage],
				IQ.[sun_maintenance_defects] = COPY.[sun_maintenance_defects],
				IQ.[sun_insured_advised] = COPY.[sun_insured_advised],
				IQ.[sun_claim_covered] = COPY.[sun_claim_covered],
				IQ.[sun_action_required] = COPY.[sun_action_required],
				IQ.[sun_action_desc] = COPY.[sun_action_desc],
				IQ.[sun_contents_involved] = COPY.[sun_contents_involved],
				IQ.[sun_contents_desc] = COPY.[sun_contents_desc],
				IQ.[version_label] = COPY.[version_label],
				IQ.[SignNumber] = COPY.[SignNumber],
				IQ.[SignedByClient] = COPY.[SignedByClient],
				IQ.[Damage_match_explanation] = COPY.[Damage_match_explanation],
				IQ.[Maintenance_issues_noted] = COPY.[Maintenance_issues_noted],
				IQ.[Damage_Result_Of] = COPY.[Damage_Result_Of],
				IQ.[Damage_Date] = COPY.[Damage_Date],
				IQ.[Damage_Date] = COPY.[Repairs_Proceeding_per_authorisation_limits],
				IQ.[Damage_Date] = COPY.[Damage_Date2],
				IQ.[created_by] = COPY.[created_by],
				IQ.[create_date] = COPY.[create_date],
				IQ.[updated_by] = @UserName,
				IQ.[updated_date] = GETDATE()
			FROM [dbo].[Insurance_Quote] IQ
				INNER JOIN [dbo.[Insurance_Quote] COPY ON COPY.[Insurance_Quote_id] = @RecentQuoteId
			WHERE IQ.[Insurance_Quote_id] = @InsuranceQuoteId;

		SET @Error = @@ERROR;

		IF ( @Error = 0 )
			IF ( @Transaction = 0 ) COMMIT TRANSACTION;
		ELSE
			IF ( @Transaction = 0 ) ROLLBACK TRANSACTION;

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

		IF ( ISNULL(@InsuranceQuoteId, -1) > 0 ) AND ( ISNULL(@CopyRecent, 0) <> 0 )
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

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Quote_Delete'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Quote_Delete];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 7 March 2013
-- Description:	Deregisters the specific insurance quote from the data warehouse.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Quote_Delete] ( @insuranceQuoteId INT, @validateEntry BIT = NULL )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET @insuranceQuoteId = ISNULL( @insuranceQuoteId, 0 );

	SET @validateEntry = ISNULL( @validateEntry, 0 );

	DECLARE @maxInsuranceQuoteId AS INT;

	SELECT @maxInsuranceQuoteId = MAX([Insurance_Quote_id]) FROM [dbo].[Insurance_Quote];

	DECLARE @ErrMessage VARCHAR(2048);

	SET @ErrMessage = '';

	DECLARE @ErrNumber INT;

	SET @ErrNumber = @@ERROR;

	DECLARE @ErrSeverity INT;

	SET @ErrSeverity = 0;

	DECLARE @ErrStatus INT;

	SET @ErrStatus = 0;

	IF ( @validateEntry <> 0 )
	BEGIN

		IF NOT EXISTS(SELECT 1 FROM [dbo].[Insurance_Quote] WITH (READCOMMITTED) WHERE [Insurance_Quote_id] = @insuranceQuoteId)
		BEGIN

			SET @ErrMessage = 'The insurance work order quote identity [ %d ] cannot be retrieved from the data warehouse.';

			RAISERROR( @ErrMessage, 16, 2, @insuranceQuoteId ) WITH NOWAIT;

		END;

	END;

	DECLARE @Transaction AS INT;

	SET @Transaction = @@TRANCOUNT;

	BEGIN TRY

		IF ( @Transaction = 0 ) BEGIN TRANSACTION;

		DELETE FROM [dbo].[Insurance_Quote] WHERE [Insurance_Quote_id] = @insuranceQuoteId;

		IF ( @insuranceQuoteId = @maxInsuranceQuoteId )
		BEGIN

			-- decrement the sequence table [MAX_ID] column value for the [Insurance_Quote] database table
			UPDATE [dbo].[SEQUENCE_TABLE] WITH (READCOMMITTED) SET [MAX_ID] = CAST( ( @maxInsuranceQuoteId - 1 ) AS INT ) WHERE ( [SEQUENCE_NAME] = 'Insurance_Quote' );

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

		--IF ( @ErrNumber = 0 ) EXEC @ErrNumber = [Insurance_WorkOrder_Bulk_Insert_Update] @insuranceQuoteId;

	END TRY
	BEGIN CATCH

		SET @ErrNumber = @@ERROR;

		SET @ErrMessage = ERROR_MESSAGE();

		SET @ErrSeverity = ERROR_SEVERITY();

		SET @ErrStatus = ERROR_STATE();

		IF ( @Transaction = 0 ) ROLLBACK TRANSACTION;

		RAISERROR ( @ErrMessage, @ErrSeverity,  @ErrStatus ) WITH NOWAIT;

	END CATCH

	RETURN @ErrNumber;

END;
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

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_QuoteStatus_Get'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_QuoteStatus_Get];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 1 March 2013
-- Description:	Obtains the registered insurance quote status.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_QuoteStatus_Get]
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT [id], [name] FROM [dbo].[Insurance_QuoteStatus];

	SET NOCOUNT OFF;

END;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_QuoteStatus_Get_by_Name'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_QuoteStatus_Get_By_Name];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 1 March 2013
-- Description:	Obtains the registered insurance quote status.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_QuoteStatus_Get_By_Name] ( @Name VARCHAR(50) )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT [id], [name] FROM [dbo].[Insurance_QuoteStatus] WHERE [name] = ISNULL(@Name, '');

	SET NOCOUNT OFF;

END;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_RoofType_Get'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_RoofType_Get];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 1 March 2013
-- Description:	Obtains the registered insurance recognized building roof types
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_RoofType_Get]
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT [id], [name] FROM [dbo].[Insurance_RoofType];

	SET NOCOUNT OFF;

END;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Room_Get_Room'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Room_Get_Room];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 4 February 2013
-- Description:	Gets the room category from the data warehouse.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Room_Get_Room] ( @Id INT )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT [Insurance_Room_Id], [name] = LTRIM(RTRIM([name])) 
	FROM [dbo].[Insurance_Room]
	WHERE [Insurance_Room_Id] = ISNULL(@Id, 0);

	SET NOCOUNT OFF;

END;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Room_Get_Room_By_Type'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Room_Get_Room_By_Type];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 4 February 2013
-- Description:	Gets the room category from the data warehouse.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Room_Get_Room_by_Type] ( @Type VARCHAR(100) )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT [Insurance_Room_Id], [name] = LTRIM(RTRIM([name])) 
	FROM [dbo].[Insurance_Room]
	WHERE [name] = ISNULL(@Type, '');

	SET NOCOUNT OFF;

END;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Room_Get_Rooms'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Room_Get_Rooms];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 4 February 2013
-- Description:	Gets the room categories from the data warehouse.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Room_Get_Rooms]
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT [Insurance_Room_Id], [name] = LTRIM(RTRIM([name])) FROM [dbo].[Insurance_Room] ORDER BY [name];

	SET NOCOUNT OFF;

END;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Scope_Get_Scope_By_Id'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Scope_Get_Scope_by_Id];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 25 February 2013
-- Description:	Obtains the insurance scope from the specified insurance scope identity.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Scope_Get_Scope_By_Id] ( @Id INT )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT	[Insurance_Scope_Item_id],
			[code],
			[short_desc],
			[long_desc],
			[Insurance_Trade_Id],
			[l_unit],
			[m_unit],
			[created_by],
			[create_date],
			[l_value],
			[m_value]
	FROM [dbo].[Insurance_Scope_Item]
	WHERE [Insurance_Scope_Item_id] = ISNULL(@Id, 0);

	SET NOCOUNT OFF;

END;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Status_Get'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Status_Get];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 1 March 2013
-- Description:	Obtains the registered insurance status.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Status_Get]
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT [id], [name] FROM [dbo].[InsuranceStatus];

	SET NOCOUNT OFF;

END;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Status_Get_By_Name'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Status_Get_By_Name];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 1 March 2013
-- Description:	Obtains the registered insurance status.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Status_Get_By_Name] ( @Name VARCHAR(50) )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT [id], [name] FROM [dbo].[InsuranceStatus] WHERE [name] = ISNULL(@Name, '');

	SET NOCOUNT OFF;

END;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Trade_Get_Trade'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Trade_Get_Trade];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 4 February 2013
-- Description:	Gets the trade category from the data warehouse.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Trade_Get_Trade] ( @Id INT )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT [Insurance_Trade_ID], [Trade_Name] = LTRIM(RTRIM([Trade_Name])), [Trade_Code] = LTRIM(RTRIM([Trade_Code])) 
	FROM [dbo].[Insurance_Trade]
	WHERE [Insurance_Trade_ID] = ISNULL(@Id, 0);

	SET NOCOUNT OFF;

END;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Trade_Get_Trades'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Trade_Get_Trades];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 4 February 2013
-- Description:	Gets the trade categories from the data warehouse.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Trade_Get_Trades]
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT [Insurance_Trade_ID], [Trade_Name] = LTRIM(RTRIM([Trade_Name])), [Trade_Code] = LTRIM(RTRIM([Trade_Code])) FROM [dbo].[Insurance_Trade] ORDER BY [Trade_Code];

	SET NOCOUNT OFF;

END;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Trade_Get_Trade'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Trade_Get_Trade];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 4 February 2013
-- Description:	Gets the trade category from the data warehouse.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Trade_Get_Trade] ( @Id INT )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT [Insurance_Trade_ID], [Trade_Name] = LTRIM(RTRIM([Trade_Name])), [Trade_Code] = LTRIM(RTRIM([Trade_Code])) 
	FROM [dbo].[Insurance_Trade]
	WHERE [Insurance_Trade_ID] = ISNULL(@Id, 0);

	SET NOCOUNT OFF;

END;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Unit_Get'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Unit_Get];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 4 February 2013
-- Description:	Gets the registered insurance unit entries.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Unit_Get]
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT [Insurance_Unit_ID], [Name] = LTRIM(RTRIM([Name])), [labour_unit], [material_unit]
	FROM [dbo].[Insurance_Unit];

	SET NOCOUNT OFF;

END;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Unit_Get_Unit'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Unit_Get_Unit];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 4 February 2013
-- Description:	Gets the insurance unit entry that is associated with the identity key.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Unit_Get_Unit] ( @Id INT )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT [Insurance_Unit_ID], [Name] = LTRIM(RTRIM([Name])), [labour_unit], [material_unit]
	FROM [dbo].[Insurance_Unit] 
	WHERE [Insurance_Unit_ID] = ISNULL(@Id, 0);

	SET NOCOUNT OFF;

END;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Unit_Get_Unit_By_Name'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Unit_Get_Unit_By_Name];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 4 February 2013
-- Description:	Gets the insurance unit entry that is associated with the identity key.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Unit_Get_Unit_By_Name] ( @Name VARCHAR(100) )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT [Insurance_Unit_ID], [Name] = LTRIM(RTRIM([Name])), [labour_unit], [material_unit]
	FROM [dbo].[Insurance_Unit] 
	WHERE [Name] = ISNULL(@Name, '');

	SET NOCOUNT OFF;

END;
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_WorkOrder_Get_By_SearchCode'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_WorkOrder_Get_By_SearchCode];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 25 February 2013
-- Description:	Obtains the insurance work order from the specified keyword.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_WorkOrder_Get_By_SearchCode] ( @Keyword VARCHAR(50) )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT	IW.[ORDER_ID], 
			IW.[supplier_ref], 
			IW.[search_code_value] ,
			[job_status] = LTRIM(RTRIM(ISNULL(JS.[name], ''))),
			IW.[authorised_doc],
			IW.[authorised_filename],
			IW.[authorise_template_doc],
			IW.[authorise_template_filename],
			IW.[attach],
			IW.[attach_filename],
			IW.[council_file],
			IW.[council_filename],
			IW.[engineer_filename],
			IW.[engineer_file],
			IW.[makesafe_contents],
			IW.[makesafe_filename],
			IW.[report_contents],
			IW.[report_filename],
			IW.[signed_file],
			IW.[signed_filename],
			IW.[warrantee_file],
			IW.[warrantee_filename]
	FROM	[dbo].[Insurance_WorkOrder]  IW
			LEFT JOIN [dbo].[Orders] O ON O.[ORDER_ID] = IW.[ORDER_ID]
			LEFT JOIN [dbo].[InsuranceStatus] JS ON JS.[id] = O.[STATUS]
	WHERE IW.[search_code_value] = LTRIM(RTRIM(ISNULL(@Keyword, '')));

	SET NOCOUNT OFF;

END;
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_WorkOrder_Get_By_OrderId'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_WorkOrder_Get_By_OrderId]
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 25 February 2013
-- Description:	Obtains the insurance work order from the specified keyword.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_WorkOrder_Get_By_OrderId] ( @OrderId INT )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT	IW.[ORDER_ID], 
			IW.[supplier_ref], 
			IW.[search_code_value],
			[job_status] = LTRIM(RTRIM(ISNULL(JS.[name], ''))),
			IW.[authorised_doc],
			IW.[authorised_filename],
			IW.[authorise_template_doc],
			IW.[authorise_template_filename],
			IW.[attach],
			IW.[attach_filename],
			IW.[council_file],
			IW.[council_filename],
			IW.[engineer_filename],
			IW.[engineer_file],
			IW.[makesafe_contents],
			IW.[makesafe_filename],
			IW.[report_contents],
			IW.[report_filename],
			IW.[signed_file],
			IW.[signed_filename],
			IW.[warrantee_file],
			IW.[warrantee_filename]
	FROM	[dbo].[Insurance_WorkOrder] IW
			LEFT JOIN [dbo].[Orders] O ON O.[ORDER_ID] = IW.[ORDER_ID]
			LEFT JOIN [dbo].[InsuranceStatus] JS ON JS.[id] = O.[STATUS]
	WHERE IW.[ORDER_ID] = ISNULL(@OrderId, 0);

	SET NOCOUNT OFF;

END;
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_WorkOrder_Get_Supplier_Reference'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_WorkOrder_Get_Supplier_Reference];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 25 February 2013
-- Description:	Obtains the insurance work order from the specified work order identity.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_WorkOrder_Get_Supplier_Reference] ( @OrderId INT )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT	IW.[ORDER_ID], 
			IW.[supplier_ref], 
			IW.[search_code_value] ,
			[job_status] = LTRIM(RTRIM(ISNULL(JS.[name], ''))),
			IW.[authorised_doc],
			IW.[authorised_filename],
			IW.[authorise_template_doc],
			IW.[authorise_template_filename],
			IW.[attach],
			IW.[attach_filename],
			IW.[council_file],
			IW.[council_filename],
			IW.[engineer_filename],
			IW.[engineer_file],
			IW.[makesafe_contents],
			IW.[makesafe_filename],
			IW.[report_contents],
			IW.[report_filename],
			IW.[signed_file],
			IW.[signed_filename],
			IW.[warrantee_file],
			IW.[warrantee_filename]
	FROM	[dbo].[Insurance_WorkOrder] IW
			LEFT JOIN [dbo].[Orders] O ON O.[ORDER_ID] = IW.[ORDER_ID]
			LEFT JOIN [dbo].[InsuranceStatus] JS ON JS.[id] = O.[STATUS]
	WHERE IW.[ORDER_ID] = ISNULL(@OrderId, 0);

	SET NOCOUNT OFF;

END;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'PersistentStore_Clear'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[PersistentStore_Clear];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 1 April 2013
-- Description:	Sets the session state settings within the data warehouse.
-- ============================================================================
CREATE PROCEDURE [dbo].[PersistentStore_Clear]
(
	@Id NVARCHAR(128)
)
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SET @Id = LTRIM(RTRIM(ISNULL(@Id, N'')));

	IF ( LEN(@Id) = 0 )
		RAISERROR(N'The session identity was not provided.', 16, 1) WITH NOWAIT;

	DECLARE @Error INT;

	SET @Error = @@ERROR;

	DECLARE @Transaction INT;

	SET @Transaction = @@TRANCOUNT;

	IF ( @Transaction = 0 ) BEGIN TRANSACTION;

	DECLARE @ErrNumber INT;

	BEGIN TRY

		IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'PersistentStore'), N'IsUserTable'), 0) = 1
			DELETE FROM [dbo].[PersistentStore] WHERE [Id] = @Id;

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

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'PersistentStore_Delete'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[PersistentStore_Delete];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 1 April 2013
-- Description:	Gets the registered session state entry
-- ============================================================================
CREATE PROCEDURE [dbo].[PersistentStore_Delete]
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'PersistentStore'), N'IsUserTable'), 0) = 1
		TRUNCATE TABLE [dbo].[PersistentStore];

	SET NOCOUNT OFF;

END;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'PersistentStore_Get'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[PersistentStore_Get];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 1 April 2013
-- Description:	Gets the registered session state entry
-- ============================================================================
CREATE PROCEDURE [dbo].[PersistentStore_Get] ( @Id NVARCHAR(512), @Key VARCHAR(512) )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT [Id], [Key], [Value], [CreatedBy], [CreatedDate] FROM [dbo].[PersistentStore]
	WHERE [Id] = ISNULL(@Id, N'') -- session identity
	AND (( LEN(ISNULL(@Key, '')) = 0 ) OR ( [Key] = LTRIM(RTRIM(@Key)) ));

	SET NOCOUNT OFF;

END;
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'PersistentStore_Set'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[PersistentStore_Set];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 1 April 2013
-- Description:	Sets the session state settings within the data warehouse.
-- ============================================================================
CREATE PROCEDURE [dbo].[PersistentStore_Set]
(
	@Id NVARCHAR(128),
	@Key NVARCHAR(128),
	@Value NVARCHAR(MAX),
	@CreatedBy VARCHAR(128),
	@CreatedDate DATETIME
)
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SET @Id = LTRIM(RTRIM(ISNULL(@Id, N'')));

	SET @Key = LTRIM(RTRIM(ISNULL(@Key, N'')));

	IF ( LEN(@Id) = 0 ) OR ( LEN(@Key) = 0 ) RAISERROR(N'The session identity and / or the form tab identity has not been provided', 16, 1) WITH NOWAIT;

	SET @CreatedBy = LTRIM(RTRIM(ISNULL(@CreatedBy, N'')));

	IF ( LEN(@CreatedBy) = 0 ) RAISERROR(N'The session user identity has not been authenticated', 16, 1) WITH NOWAIT; 

	IF ( @CreatedDate IS NULL ) SET @CreatedDate = GETDATE();

	DECLARE @Error INT;

	SET @Error = @@ERROR;

	DECLARE @Transaction INT;

	SET @Transaction = @@TRANCOUNT;

	IF ( @Transaction = 0 ) BEGIN TRANSACTION;

	DECLARE @ErrNumber INT;

	BEGIN TRY

		IF EXISTS(SELECT 1 FROM [dbo].[PersistentStore] WHERE ( [Id] = @Id ) AND ( [Key] = @Key ) AND  ( [CreatedBy] = @CreatedBy ) )
		BEGIN

			UPDATE [dbo].[PersistentStore] WITH (READCOMMITTED) SET
						[Value] = @Value,
						[CreatedDate] = @CreatedDate
			WHERE ( [Id] = @Id ) AND ( [Key] = @Key ) AND ( [CreatedBy] = @CreatedBy );

		END
		ELSE
		BEGIN

			INSERT INTO [dbo].[PersistentStore]
			(
				[Id],
				[Key],
				[Value],
				[CreatedBy],
				[CreatedDate]
			)
			VALUES
			(
				@Id,
				@Key,
				@Value,
				@CreatedBy,
				@CreatedDate
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

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Estimator_Item_Import'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Estimator_Item_Import];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 11 April 2013
-- Description:	Bulk inserts the comma separated value spreadsheet, residing on
--              the web server, into the data warehouse.
-- Assumption:  The production database server and the production web server resides
--              on the same Windows Server device.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Estimator_Item_Import] ( @resource VARCHAR(2048), @formatfile VARCHAR(2048), @errorfile VARCHAR(2048), @username VARCHAR(50), @clientAddress VARCHAR(32), @firstrow INT = 2, @maxerrors INT = 20 )
WITH EXECUTE AS CALLER
AS
BEGIN

	DECLARE @retval INT;

	SET @retval = 1; -- error indication

	IF ( LEN(@resource) = 0 ) OR ( LEN(@formatfile) = 0 ) 
		RAISERROR( 'The text based resource and the format file must be specified', 16, 2 ) WITH NOWAIT;

	SET @resource = LTRIM(RTRIM(ISNULL(@resource, '')));

	IF ( CHARINDEX( '\\', @resource, 1 ) > 0 )
		SET @resource = REPLACE( @resource, '\\', '\' );

	IF ( CHARINDEX( '"', @resource, 1) > 0 )
		SET @resource = REPLACE( @resource, '"', '');

	SET @formatfile = LTRIM(RTRIM(ISNULL(@formatfile, '')));

	IF ( CHARINDEX( '\\', @formatfile, 1 ) > 0 )
		SET @formatfile = REPLACE( @formatfile, '\\', '\' );

	IF ( CHARINDEX( '"', @formatfile, 1) > 0 )
		SET @formatfile = REPLACE( @formatfile, '"', '');

	SET @errorfile = LTRIM(RTRIM(ISNULL(@errorfile, '')));

	SET @username = LTRIM(RTRIM(ISNULL(@username, '')));

	SET @clientAddress = LTRIM(RTRIM(ISNULL(@clientAddress, '')));

	DECLARE @sqlCommand VARCHAR(MAX);

	SET @sqlCommand = 'INSERT INTO [dbo].[Insurance_Estimator_Entry_Import] ( [room_category], [width], [length], [height], [trade_name], [is_extra_item], ';

	SET @sqlCommand = @sqlCommand + '[description], [l_qty], [l_measure], [l_rate], [l_margin], [m_qty], [m_measure], [m_rate], [m_margin], ';

	SET @sqlCommand = @sqlCommand + '[username], [client_address] ) ';

	SET @sqlCommand = @sqlCommand + 'SELECT  ISNULL(REPLACE(T.[room_category], ''"'', ''''), '''') AS [room_category], ISNULL(T.[width], 0) AS [width], ';

	SET @sqlCommand = @sqlCommand + 'ISNULL(T.[length], 0) AS [length], ISNULL(T.[height], 0) AS [height], LTRIM(RTRIM(ISNULL(T.[trade_name], ''''))) AS [trade_name], ';
	
	SET @sqlCommand = @sqlCommand + 'ISNULL(T.[is_extra_item], 0) AS [is_extra_item], LTRIM(RTRIM(ISNULL(T.[description] , ''''))) AS [description], ';

	SET @sqlCommand = @sqlCommand + 'ISNULL(T.[l_qty], 0) AS [l_qty], LTRIM(RTRIM(ISNULL(T.[l_measure], ''''))) AS [l_measure], ISNULL(T.[l_rate], 0) AS [l_rate], ';

	SET @sqlCommand = @sqlCommand + 'ISNULL(T.[l_margin], 0) AS [l_margin], ISNULL(T.[m_qty], 0) AS [m_qty], LTRIM(RTRIM(ISNULL(T.[m_measure], ''''))) AS [m_measure], ';

	SET @sqlCommand = @sqlCommand + 'ISNULL(T.[m_rate], 0) AS [m_rate], ISNULL(T.[m_margin], 0) AS [m_margin], ';

	SET @sqlCommand = @sqlCommand + '''' + @username + ''' AS [username], ''' + @clientAddress + ''' AS [client_address] ';

	SET @sqlCommand = @sqlCommand + 'FROM OPENROWSET( BULK ''' + @resource + ''', FORMATFILE = ''' + REPLACE(@formatfile, '"', '') + ''', ';
	
	SET @sqlCommand = @sqlCommand + 'FIRSTROW = ' + LTRIM(RTRIM(CAST(@firstrow AS VARCHAR(8)))) + ', ';

	IF ( LEN(@errorfile) > 0 ) SET @sqlCommand = @sqlCommand + 'ERRORFILE = ''' + @errorfile + ''', ';
	
	SET @sqlCommand = @sqlCommand + 'MAXERRORS = ' + LTRIM(RTRIM(CAST(@maxerrors AS VARCHAR(8)))) + ' ) ';

	SET @sqlCommand = @sqlCommand + 'AS T( [room_category], [width], [length], [height], [trade_name], [is_extra_item], [description], [l_qty], [l_measure], [l_rate], [l_margin], ';

	SET @sqlCommand = @sqlCommand + '[m_qty], [m_measure], [m_rate], [m_margin] );';

	BEGIN TRY

		EXEC ( @sqlCommand );

		SET @retval = @@ERROR;

	END TRY
	BEGIN CATCH

		SET @retval = @@ERROR;

		DECLARE @ErrMessage VARCHAR(2048);

		SET @ErrMessage = ERROR_MESSAGE();

		DECLARE @ErrSeverity INT;

		SET @ErrSeverity = ERROR_SEVERITY();

		DECLARE @ErrStatus INT;

		SET @ErrStatus = ERROR_STATE();

		RAISERROR ( @ErrMessage, @ErrSeverity,  @ErrStatus ) WITH NOWAIT;

	END CATCH

	RETURN @retval;

END;
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
				SET @InterimJobCostEstimate = @InterimJobCostEstimate + @JobCostEstimate;
				SET @InterimJobSalePriceEstimate = @InterimJobSalePriceEstimate + @JobSalePriceEstimate;
			END
			ELSE
			BEGIN
				SET @InterimJobCostEstimate = @InterimJobCostEstimate - @JobCostEstimate;
				SET @InterimJobSalePriceEstimate = @InterimJobSalePriceEstimate - @JobSalePriceEstimate;
			END;

			SET @RowCount = @RowCount + 1;

			FETCH NEXT FROM cvReader INTO @JobCostEstimate, @JobSalePriceEstimate, @QuoteStatus, @NegativeQuoteId;

		END;

		CLOSE cvReader;

		DEALLOCATE cvReader;

		IF ( @RowCount > 0 )
		BEGIN

			IF ( @Transaction = 0 ) BEGIN TRANSACTION;

			UPDATE [dbo].[Insurance_WorkOrder] WITH (ROWLOCK) SET
				[est_cost] = CAST(@InterimJobCostEstimate AS DECIMAL(9, 2)),
				[est_sale] = CAST(@InterimJobSalePriceEstimate AS DECIMAL(9, 2)),
				[est_profit] = CAST((@InterimJobSalePriceEstimate - @InterimJobCostEstimate) AS DECIMAL(9, 2)),
				[est_profit_percent] = CAST((100 - (( CAST(@InterimJobCostEstimate AS DECIMAL(9, 2)) * CAST(100 AS DECIMAL(9, 2))) / CAST(@InterimJobSalePriceEstimate AS DECIMAL(9, 2)))) AS DECIMAL(9, 2))
			WHERE [ORDER_ID] IN ( SELECT [Order_id] FROM [dbo].[Insurance_Quote] WHERE [Insurance_Quote_id] = @insurancequoteid );

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

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Damage_Get'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Damage_Get];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 1 March 2013
-- Description:	Obtains the registered insurance damages.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Damage_Get]
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT [ID], [Name] FROM [dbo].[Insurance_Damage_Cause];

	SET NOCOUNT OFF;

END;
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Damage_Get_By_Id'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Damage_Get_By_Id];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 1 March 2013
-- Description:	Obtains the registered insurance damage that is identified by the
--              specified identity.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Damage_Get_By_Id] ( @Id INT )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT [ID], [Name] FROM [dbo].[Insurance_Damage_Cause] WHERE [ID] = ISNULL(@Id, 0);

	SET NOCOUNT OFF;

END;
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Damage_Get_By_Name'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Damage_Get_By_Name];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 1 March 2013
-- Description:	Obtains the registered insurance damage that is identified by the
--              specified identity.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Damage_Get_By_Name] ( @Name VARCHAR(50) )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	SELECT [ID], [Name] FROM [dbo].[Insurance_Damage_Cause] WHERE [Name] = ISNULL(@Name, '');

	SET NOCOUNT OFF;

END;
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