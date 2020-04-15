BEGIN

	SELECT * FROM [dbo].[Insurance_WorkOrder] WHERE [ORDER_ID] IN (SELECT [Order_id] FROM [dbo].[Insurance_Quote] WHERE [Insurance_Quote_id] = 4228) /* NSY2145 */

END;
GO