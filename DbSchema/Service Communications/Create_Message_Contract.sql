﻿USE [visionary]; -- CHANGE IF REQUIRED
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

CREATE CONTRACT [//MaincomServices/Contracts] 
(
	[//MaincomServices/Messages/Incoming] SENT BY INITIATOR
);
GO