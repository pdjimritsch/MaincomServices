USE [visionary]; -- change the database name if required
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