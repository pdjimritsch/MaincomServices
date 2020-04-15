USE [visionary]; -- CHANGE IF REQUIRED
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'MyServiceQueue'), N'IsQueue'), 0) = 1
	DROP QUEUE [MyServiceQueue];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 13 April 2013
-- Description:	Creates the communication queue that provides a communication
--              channel for data transmission from this database.
-- ============================================================================
CREATE QUEUE [MyServiceQueue] WITH 
	STATUS=ON,
	ACTIVATION
	(
		PROCEDURE_NAME=[dbo].[Activate_Service_Queue],
		MAX_QUEUE_READERS = 250,
		EXECUTE AS 'visionaryuser' -- CHANGE IF REQUIRED
	)
ON [DEFAULT];
GO