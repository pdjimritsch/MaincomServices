USE [visionary] -- CHANGE IF REQUIRED
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