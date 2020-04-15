USE [visionary]; -- CHANGE IF REQUIRED
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

CREATE SERVICE [//MaincomServices/Services] 
ON QUEUE [MyServiceQueue] ( [//MaincomServices/Contracts] );
GO