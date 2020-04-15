USE [visionary];
GO

BEGIN

	SELECT * FROM [dbo].[Insurance_Quote]
	WHERE [dbo].[AddBit]([dbo].[AddBit]([dbo].[AddBit]([dbo].[AddBit]([dbo].[AddBit]([dbo].[AddBit]([dbo].[AddBit]([dbo].[AddBit]([dbo].[AddBit]([dbo].[AddBit]([dbo].[AddBit]([dbo].[AddBit]([dbo].[AddBit]([dbo].[AddBit]([dbo].[AddBit]([dbo].[AddBit]([dbo].[AddBit]([dbo].[AddBit]([dbo].[AddBit]([dbo].[AddBit]([dbo].[AddBit]([dbo].[AddBit]([dbo].[AddBit]([ob_bungalow], [ob_fibro_shed]), [ob_brick_shed]), [ob_metal_shed]), [ob_metal_garage]), [ob_above_ground_pool]), [ob_pergola]), [ob_timber_carport]), [ob_brick_carport]), [ob_dog_kennel]), [ob_external_laundry]), [ob_below_ground_pool]), [ob_external_wc]), [ob_bbq_area]), [ob_pool_room]), [ob_store_room]), [ob_cubby_house]), [ob_pump_room]), [ob_granny_flat]), [ob_brick_garage]), [ob_fibro_garage]), [ob_carport_metal]), [ob_screen_enclosures]), [ob_fence]) > 1;

END;
GO

BEGIN

	SELECT IW.[search_code_value], 
		   IW.[ORDER_ID], 
		   (SELECT COUNT(*) FROM [dbo].[Insurance_Quote] IQ WHERE IQ.[Order_id] = IW.[ORDER_ID]) AS [#Quotes],
		   (SELECT COUNT(*) FROM [dbo].[Insurance_Estimator_Item] WHERE [Insurance_Quote_id] IN (SELECT [Insurance_Quote_id] FROM [Insurance_Quote] WHERE [Order_id] = IW.[ORDER_ID])) AS [#LineItems]
	FROM [dbo].[Insurance_WorkOrder] IW
	WHERE (SELECT COUNT(*) FROM [dbo].[Insurance_Quote] IQ WHERE IQ.[Order_id] = IW.[ORDER_ID]) > 1
	ORDER BY IW.[search_code_value];

END;
GO

BEGIN

	DECLARE @OrderId INT, @InsuranceQuoteId INT;

	SET @OrderId = 215262; /* NSY3290 */

	SET @InsuranceQuoteId = 10748; /* Matching Revision R1 */

	EXEC  [dbo].[Insurance_Estimator_Item_Get_Partial_Reader] @InsuranceQuoteId;

END;
GO

BEGIN

	DECLARE @OrderId INT, @InsuranceQuoteId INT;

	SET @OrderId = 211765; /* VML2124 */

	SET @InsuranceQuoteId = 11125; /* Negative insurance work order quote variation */

	EXEC  [dbo].[Insurance_Estimator_Item_Get_Partial_Reader] @InsuranceQuoteId;

END;
GO

BEGIN

	SELECT * FROM [dbo].[Insurance_Estimator_Item] 
	WHERE [Insurance_Quote_id] IN 
	(
		SELECT [Insurance_Quote_id] FROM [dbo].[Insurance_Quote]
		WHERE [Order_ID] IN 
		(
			SELECT [ORDER_ID] FROM [dbo].[Insurance_WorkOrder] WHERE [search_code_value] = 'NSY2333'
		)
	)
	ORDER BY [Insurance_Estimator_Item_id];

END;
GO

BEGIN
	SELECT * FROM [dbo].[Insurance_Estimator_Item] WHERE [Insurance_Quote_id] = 4228 /* NSY2145 */ ORDER BY [Insurance_Estimator_Item_Id];
END;
GO

BEGIN

	SELECT * FROM [dbo].[Insurance_Scope_Item]
	WHERE [Insurance_Scope_Item_id] IN 
	(
		SELECT [Insurance_Scope_Item_Id] FROM [dbo].[Insurance_Estimator_Item]
		WHERE [Insurance_Quote_id] IN
		(
			SELECT [Insurance_Quote_id] FROM [dbo].[Insurance_Quote]
			WHERE [Order_id] IN 
			(
				SELECT [ORDER_ID] FROM [dbo].[Insurance_WorkOrder]
				WHERE UPPER([search_code_value]) = 'NSY3381'
			)
		)
	);

END;
GO

BEGIN

	SELECT * FROM [dbo].[Insurance_Quote] WHERE [Insurance_Quote_id] = 5116;

	SELECT [search_code_value] FROM [dbo].[Insurance_WorkOrder] 
	WHERE [ORDER_ID] IN 
	( 
		SELECT [Order_id] FROM [dbo].[Insurance_Quote] WHERE [Insurance_Quote_id] = 5116
	);

END;
GO

BEGIN

	SELECT IW.[search_code_value], IW.[ORDER_ID], IQ.[Insurance_Quote_id] 
	FROM [dbo].[Insurance_WorkOrder] IW 
	INNER JOIN [dbo].[Insurance_Quote] IQ ON ( IQ.[Order_id] = IW.[ORDER_ID] ) AND ( IQ.[home_warranty_required] IS NULL )
	ORDER BY IW.[search_code_value];

	SELECT IW.[search_code_value], IW.[ORDER_ID]
	FROM [dbo].[Insurance_WorkOrder] IW 
	WHERE IW.[search_code_value] = 'NSY2145';

END;
GO
