USE [visionary];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

BEGIN

	DECLARE @Keyword VARCHAR(50);

	SET @Keyword = 'NSY2345';

	SELECT IQ.* FROM [dbo].[Insurance_Quote] IQ WHERE [Order_id] IN (SELECT [ORDER_ID] FROM [dbo].[Insurance_WorkOrder] WHERE [search_code_value] = @Keyword);

END;
GO

BEGIN

	SELECT IQ.[Insurance_Quote_id], IQ.[Order_id], COUNT(IQ.[Insurance_Quote_id]) AS [#Relations] FROM [dbo].[Insurance_Quote] IQ 
	WHERE IQ.[Order_id] IN (SELECT [ORDER_ID] FROM [dbo].[Insurance_WorkOrder])
	GROUP BY [Insurance_Quote_id], [Order_id]
	HAVING COUNT([Insurance_Quote_id]) > 0;

END;
GO

BEGIN

	SELECT * FROM [dbo].[Insurance_Quote] WHERE [Insurance_Quote_id] >= 12646;
	SELECT * FROM [dbo].[Insurance_Estimator_Item] WHERE [Insurance_Quote_id] >= 12646;
	SELECT * FROM [dbo].[PersistentStore];

END;
GO

BEGIN

	DECLARE @quoteId AS INT;

	SET @quoteId = 0; -- CHANGE IF REQUIRED

	DECLARE @validateEntry AS BIT;

	SET @validateEntry = 1;

	DECLARE @ErrNumber AS INT;

	--EXEC @ErrNumber = [dbo].[Insurance_Quote_Delete] @quoteId, @validateEntry;

END;
GO

BEGIN

	DECLARE @Count INT;

	DECLARE @Max INT;

	DELETE FROM [dbo].[PersistentStore];

	SELECT @Count = COUNT(*) FROM [dbo].[Insurance_Estimator_Item] WHERE [Insurance_Quote_id] >= 12646;

	SELECT @Max = MAX([Insurance_Estimator_Item_id]) from [dbo].[Insurance_Estimator_Item];

	DELETE FROM [dbo].[Insurance_Estimator_Item] WHERE [Insurance_Quote_id] >= 12646;
	DELETE FROM [dbo].[Insurance_Quote] WHERE [Insurance_Quote_id] >= 12646;

	UPDATE [dbo].[SEQUENCE_TABLE] SET [MAX_ID] = 12645 WHERE [SEQUENCE_NAME] = 'Insurance_Quote';
	UPDATE [dbo].[SEQUENCE_TABLE] SET [MAX_ID] = @Max - @Count WHERE [SEQUENCE_NAME] = 'Insurance_Estimator_Item';

END;
GO