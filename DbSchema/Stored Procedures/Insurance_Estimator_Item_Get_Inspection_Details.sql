USE [visionary]; -- change the database name if required
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