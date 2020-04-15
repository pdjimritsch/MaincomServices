USE [visionary]; -- CHANGE IF REQUIRED
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Activate_Service_Queue'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE[dbo].[Activate_Service_Queue];
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 13 April 2013
-- Description:	Creates the communication queue activator that listens to the
--              communication channel messages.
-- ============================================================================
CREATE PROCEDURE [dbo].[Activate_Service_Queue]
WITH EXECUTE AS CALLER
AS
BEGIN

	DECLARE @Queue TABLE
	(
		[ServiceId] UNIQUEIDENTIFIER,
		[Handle] UNIQUEIDENTIFIER,
		[MessageSequenceNumber] BIGINT,
		[ServiceName] NVARCHAR(512),
		[ServiceContractName] NVARCHAR(256),
		[MessageTypeName] NVARCHAR(256),
		[Validation] NCHAR,
		[MessageBody] VARBINARY(MAX)
	);

	WAITFOR 
	( 
		RECEIVE TOP (1)
				[conversation_group_id],
				[conversation_handle],
				[message_sequence_handle],
				[service_name],
				[service_contract_name],
				[message_type_name],
				[validation],
				[message_body]
		FROM [dbo].[MyServiceQueue] 
		INTO @Queue 
	);



END;
GO
