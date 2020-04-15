USE [visionary]; -- change the database name if required
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Scope_Get_Scope_By_Id'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Scope_Get_Scope_By_Id];
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
