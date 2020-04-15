USE [visionary]; -- change if required
GO

IF ISNULL(OBJECTPROPERTY(OBJECT_ID(N'Insurance_Work_Order_Item_Update'), N'IsProcedure'), 0) = 1
	DROP PROCEDURE [dbo].[Insurance_Work_Order_Item_Update];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING OFF;
GO

-- ============================================================================
-- Author:		Paul Djimritsch
-- Create date: 23 October 2013
-- Description:	Creates a new work order main entry within the data warehouse.
-- ============================================================================
CREATE PROCEDURE [dbo].[Insurance_Work_Order_Item_Update] ( @WorkOrderMainId INT, @WorkOrderItemId INT, @EntityId INT, @username VARCHAR(20) )
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;

	-- Validation

	IF NOT EXISTS(SELECT 1 FROM [dbo].[Insurance_WorkOrderMain] WITH (READCOMMITTED) WHERE [Insurance_WorkOrderMain_Id] = ISNULL(@WorkOrderMainId, -1)) 
	BEGIN

		SET NOCOUNT OFF;
	
		RAISERROR( 'The identity for the insurance work order main was not provided', 16, 1) WITH NOWAIT;

	END;

	-- Processing

	DECLARE @ErrMessage VARCHAR(2048);

	SET @ErrMessage = '';

	DECLARE @ErrNumber INT;

	SET @ErrNumber = @@ERROR;

	DECLARE @ErrSeverity INT;

	SET @ErrSeverity = 0;

	DECLARE @ErrStatus INT;

	SET @ErrStatus = 0;

	DECLARE @Transaction INT;

	SET @Transaction = @@TRANCOUNT;

	BEGIN TRY

		IF ( @Transaction = 0 ) BEGIN TRANSACTION;

		IF ( @username IS NULL )
			UPDATE [dbo].[Insurance_WorkOrderItems] WITH (READCOMMITTED) SET 
				[Insurance_WorkOrderMain_Id] = @WorkOrderMainId,
				[be_id] = @EntityId,
				[create_date] = GETDATE()
			WHERE [Insurance_WorkOrderItems_Id] = @WorkOrderItemId;
		ELSE
			UPDATE [dbo].[Insurance_WorkOrderItems] WITH (READCOMMITTED) SET 
				[Insurance_WorkOrderMain_Id] = @WorkOrderMainId,
				[be_id] = @EntityId,
				[created_by] = LTRIM(RTRIM(@username)),
				[create_date] = GETDATE()
			WHERE [Insurance_WorkOrderItems_Id] = @WorkOrderItemId;

		SET @ErrNumber = @@ERROR;

		IF ( @ErrNumber = 0 )
		BEGIN

			IF ( @Transaction = 0 ) COMMIT TRANSACTION;

		END
		ELSE
		BEGIN

			IF ( @Transaction = 0 ) ROLLBACK TRANSACTION;

		END;


	END TRY
	BEGIN CATCH

		SET @ErrMessage = ERROR_MESSAGE();

		SET @ErrSeverity = ERROR_SEVERITY();

		SET @ErrStatus = ERROR_STATE();

		IF ( @Transaction = 0 ) ROLLBACK TRANSACTION;

		RAISERROR ( @ErrMessage, @ErrSeverity,  @ErrStatus ) WITH NOWAIT;

	END CATCH;

	SET NOCOUNT OFF;

	RETURN @ErrNumber;

END;
GO
