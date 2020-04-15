USE [visionary]; -- change the database name if required
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
