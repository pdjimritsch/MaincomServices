﻿USE [visionary]; -- CHANGE IF REQUIRED
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