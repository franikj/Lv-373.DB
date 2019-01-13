--IF ( OBJECT_ID('Sales.STP_Customers_INS') IS NOT NULL ) 
  -- DROP PROCEDURE Sales.STP_Customers_INS
--GO

CREATE PROCEDURE Sales.STP_Boxes_INS
       (
	   @Price DECIMAL(19,2),
	   @Name  VARCHAR(20)
	   )	 
	AS
BEGIN 
     --SET NOCOUNT ON 
	DECLARE @ErrorMessage VARCHAR(1000),
			@UserName SYSNAME = SYSTEM_USER,
			@ServerName NVARCHAR(50) = @@SERVERNAME,
			@DatabaseName NVARCHAR(50) = DB_NAME(),
			@ProcessName NVARCHAR(50) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID),
			@StartTime DATETIME = GETDATE(),
			@EndTime DATETIME,
			@InsertRows INT = 0,
			@UpdateRows INT = 0,
			@DeleteRows INT = 0,
			@Status NVARCHAR(20) = 'SUCCESS',  
			@Message NVARCHAR (MAX) = NULL,
			@TransactionID BIGINT = (SELECT TOP(1) transaction_id FROM sys.dm_tran_current_transaction)

	BEGIN TRANSACTION
			
			BEGIN TRY
		IF @Price IS NULL
			BEGIN
				SET @ErrorMessage = 'Price is null or error converting data type to decimal';
				RAISERROR(@ErrorMessage,16,1);
			END

		 IF LEN(@Name) > 20 OR @Name IS NULL
			BEGIN
				SET @ErrorMessage = 'Name id null or too many characters in the field Name';
				RAISERROR(@ErrorMessage,16,1);
			END

				INSERT INTO Goods.Boxes
					  ( 
						Price,
						Name             
					  ) 
				VALUES(	@Price,
						@Name		
					  )
SET @InsertRows = @@ROWCOUNT
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		PRINT @ErrorMessage
		SET @Status = 'FAIL'
		SET @Message = @ErrorMessage
	END CATCH
	SET @EndTime = GETDATE()
	EXEC Administration.STP_InsertLogs @UserName,
		@ServerName,
		@DatabaseName,
		@ProcessName,
		@StartTime,
		@EndTime,
		@InsertRows,
		@UpdateRows,
		@DeleteRows,
		@Status,  
		@Message,
		@TransactionID
IF @@TRANCOUNT > 0
COMMIT TRANSACTION
END

GO

EXEC Sales.STP_Boxes_INS @Price = NULL,
							@Name = 'hrhrth'

select * from Goods.Boxes

		