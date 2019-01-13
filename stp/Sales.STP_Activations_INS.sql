--IF ( OBJECT_ID('Sales.STP_Customers_INS') IS NOT NULL ) 
  -- DROP PROCEDURE Sales.STP_Customers_INS
--GO

ALTER PROCEDURE Sales.STP_Activations_INS
       (
		@GiftCardID INT ,
		@LineItem INT		
	   )	 
	AS
BEGIN 
   
	DECLARE @ErrorMessage VARCHAR(1000),
			@UserName SYSNAME = SYSTEM_USER,
			@ServerName NVARCHAR(50) = @@SERVERNAME,
			@DatabaseName NVARCHAR(50) = DB_NAME(),
			@ProcessName NVARCHAR(50) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID),
			@TableName NVARCHAR(50) = 'Sales.Activations',
			@StartTime DATETIME = GETDATE(),
			@EndTime DATETIME,
			@InsertRows INT = 0,
			@UpdateRows INT = 0,
			@DeleteRows INT = 0,
			@Status NVARCHAR(20) = 'SUCCESS',  
			@Message NVARCHAR (MAX) = NULL,
			@TransactionID BIGINT = (SELECT TOP(1) transaction_id FROM sys.dm_tran_current_transaction),
			@RegistrationDate DATETIME = GETDATE();

	BEGIN TRANSACTION
			
			BEGIN TRY
		IF @GiftCardID IS NULL OR @GiftCardID = 0 OR @GiftCardID NOT IN (SELECT GiftCardID FROM Sales.InvoiceDetails
							WHERE GiftCardID = @GiftCardID)
				
			BEGIN
				SET @ErrorMessage = 'Field GiftCard is null or doesnt exist';
				RAISERROR(@ErrorMessage,16,1);
			END
		ELSE IF @GiftCardID IN ( SELECT GiftCardID FROM Sales.Activations
							WHERE GiftCardID = @GiftCardID)
			BEGIN
				SET @ErrorMessage = 'Alredy activated GiftCard';
				RAISERROR(@ErrorMessage,16,1);
			END
		ELSE IF @GiftCardID IN (SELECT GiftCardID FROM Sales.ReturnedOrders
							WHERE GiftCardID = @GiftCardID)
			BEGIN
				SET @ErrorMessage = 'Doest exist selected GiftCard';
				RAISERROR(@ErrorMessage,16,1);
			END
				

		 ELSE IF NOT EXISTS ( SELECT csd.LineItem FROM Sales.GiftCardDetails csd
							INNER JOIN Sales.InvoiceDetails id ON  id.GiftCardID = csd.GiftCardID
							INNER JOIN Sales.Invoices i ON i.InvoiceID=id.InvoiceID
							WHERE i.StatusID = 4 AND csd.GiftCardID = @GiftCardID
							AND csd.LineItem = @LineItem
						 )
			BEGIN
				SET @ErrorMessage = 'No LineItem in choosen GiftCard';
				RAISERROR(@ErrorMessage,16,1);
			END

		INSERT INTO Sales.Activations
					  ( 
						GiftCardID,
						LineItem,
						RegistrationDate          
					  ) 
				VALUES(	
						@GiftCardID,
						@LineItem,
						@RegistrationDate		
					  )
SET @Message = CONCAT('Data succesful inserted in ', @TableName)
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
		@TableName,
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



--Test data 
/*EXEC Sales.STP_Activations_INS @GiftCardID = 90000000,
							@LineItem = 3
EXEC Sales.STP_Activations_INS @GiftCardID = 90001005,
							@LineItem = 1
							GO

DELETE FROM Sales.Activations
WHERE GiftCardID = 90000000
*/

--SELECT * FROM Sales.GiftCards
--SELECT * FROM Sales.GiftCardDetails
--SELECT * FROM Sales.Activations
--SELECT * FROM Sales.GiftCardDetails
--SELECT * FROM Administration.Logs





		