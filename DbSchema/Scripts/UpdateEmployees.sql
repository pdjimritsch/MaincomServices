USE [visionary]; -- CHANGE IF REQUIRED
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Employee'), N'IsUserTable'), 0) = 1
	UPDATE [dbo].[Employee]
		SET [Description] = U.[description]
	FROM [sessions].[dbo].[User] U
	WHERE [login_code] = U.[user_name];
GO