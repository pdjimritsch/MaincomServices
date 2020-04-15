USE [master];
GO

ALTER DATABASE [visionary] SET ENABLE_BROKER;
GO

USE [visionary]; -- CHANGE IF REQUIRED
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

CREATE MESSAGE TYPE [//MaincomServices/Messages/Incoming] VALIDATION = NONE;
GO

CREATE MESSAGE TYPE [//MaincomServices/Messages/Outgoing] VALIDATION = NONE;
GO

CREATE CONTRACT [//MaincomServices/Contracts] (
	[//MaincomServices/Messages/Incoming] SENT BY INITIATOR
);
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'MyServiceQueue'), N'IsQueue'), 0) = 1
	DROP QUEUE [dbo].[MyServiceQueue];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 13 April 2013
-- Description:	Creates the communication queue that provides a communication
--              channel for data transmission from this database.
-- ============================================================================
CREATE QUEUE [dbo].[MyServiceQueue] WITH 
	STATUS=ON,
	ACTIVATION
	(
		PROCEDURE_NAME=[dbo].[Activate_Service_Queue],
		MAX_QUEUE_READERS = 250,
		EXECUTE AS 'visionaryuser' -- CHANGE IF REQUIRED
	)
ON [DEFAULT];
GO


CREATE SERVICE [//MaincomServices/Services] 
ON QUEUE [MyServiceQueue] ( [//MaincomServices/Contracts] );
GO
