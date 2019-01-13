--IF ( OBJECT_ID('Sales.STP_Customers_INS') IS NOT NULL ) 
  -- DROP PROCEDURE Sales.STP_Customers_INS
--GO

ALTER PROCEDURE Sales.STP_Customers_INS
       (
	   @FirstName	NVARCHAR(50), 
       @LastName	NVARCHAR(50),
	   @Phone		CHAR(17),
	   @Email		varchar(100),
	   @BirthDate	DATE ,
	   @Gender		varchar(10),
	   @CityID		CHAR(5),
	   @CustomerID INT OUTPUT
	   )
	 
	AS
BEGIN 
     --SET NOCOUNT ON 
	DECLARE @ErrorMessage VARCHAR(1000),
			@UserName SYSNAME = SYSTEM_USER,
			@ServerName NVARCHAR(50) = @@SERVERNAME,
			@DatabaseName NVARCHAR(50) = DB_NAME(),
			@ProcessName NVARCHAR(50) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID),
			@TableName NVARCHAR(50) = 'Sales.Customers',
			@StartTime DATETIME = GETDATE(),
			@EndTime DATETIME,
			@InsertRows INT = 0,
			@UpdateRows INT = 0,
			@DeleteRows INT = 0,
			@Status NVARCHAR(20) = 'SUCCESS',  
			@Message NVARCHAR (MAX) = NULL,
			@TransactionID BIGINT = (SELECT TOP(1) transaction_id FROM sys.dm_tran_current_transaction),
			@CustID		INT  = 0,
			@Balance	DECIMAL(19,2) = 0.00,
			@DiscountID	INT = NULL,
			@CID INT ;

	BEGIN TRANSACTION
			
			BEGIN TRY

			IF EXISTS (SELECT CustomerID, Phone, Email from Sales.Customers
						WHERE 
								Phone = @Phone AND 
								Email = @Email )
							--	BirthDate = @BirthDate)
			BEGIN
					SET @CustID = (SELECT CustomerID  from Sales.Customers
						WHERE 
								Phone = @Phone AND 
								Email = @Email)
							--	BirthDate = @BirthDate)

					SET @Message = CONCAT('The customer alredy exist with ID = ',@CustID)
					SET @CustomerID = @CustID
					PRINT @Message
			END


		ELSE IF LEN(@FirstName) > 50 OR LEN(@LastName) > 50
			BEGIN
				SET @ErrorMessage = 'Error in First';
				RAISERROR(@ErrorMessage,16,1);
			END

		 ELSE IF EXISTS (SELECT  Phone
			from Sales.Customers 
			WHERE	
					Phone = @Phone 					
					) 
			BEGIN
				SET @ErrorMessage = CONCAT('Customer with Phone ', @Phone, ' alredy exist');
				RAISERROR(@ErrorMessage,16,1);
			END

		ELSE  IF EXISTS (SELECT Email
			from Sales.Customers 
			WHERE	
					Email = @Email 
					) 
			BEGIN
				SET @ErrorMessage = CONCAT('Customer with Email ', @Email, ' alredy exist');
				RAISERROR(@ErrorMessage,16,1);
			END

	ELSE IF (YEAR(GETDATE()) - YEAR(@BirthDate)) <= 18 OR (YEAR(GETDATE()) - YEAR(@BirthDate)) >= 90
			BEGIN
				SET @ErrorMessage = CONCAT('BirthDate ', @BirthDate, ' is out of range from (18 to 90)');
				RAISERROR(@ErrorMessage,16,1);
			END 

		ELSE IF @Gender NOT IN ('Male','Female','Nonbinary')
			BEGIN
				SET @ErrorMessage = 'Please select Male,Female,Nonbinary';
				RAISERROR(@ErrorMessage,16,1);
			END

		ELSE  IF @CityID NOT IN (SELECT CityID from Basics.Cities )
			BEGIN
				SET @ErrorMessage = 'Please select norm City';
				RAISERROR(@ErrorMessage,16,1);
			END
		ELSE
				INSERT INTO Sales.Customers
					  ( 
						FirstName,
						LastName,
						Phone,
						Email,
						BirthDate,
						Gender,
						Balance,
						DiscountID,
						CityID             
					  ) 
				VALUES(	@FirstName,
						@LastName,
						@Phone,
						@Email,
						@BirthDate,
						@Gender,
						@Balance,
						@DiscountID,
						@CityID			
					  )
SET @CustomerID = (SELECT CustomerID FROM Sales.Customers
							where @Phone = Phone 
									AND @Email = Email)
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

declare @CID INT
exec Sales.STP_Customers_INS @FirstName = 'Hi',
							@LastName = 'Lo',
							@Phone = '+38(020)667-11-00',
							@Email ='li@ffsi.org',
							@BirthDate ='1990-01-02',
							@Gender ='Male',
							@CityID = '01001',
							@CustomerID = @CID OUTPUT

SELECT @CID
							GO 



select * from Sales.Customers where CustomerID > 6196396
select * from  Administration.Logs




		/*IF @Phone IN (SELECT CustomerID  from Sales.Customers
						WHERE 
								Phone = @Phone AND 
								Email = @Email AND
								BirthDate = @BirthDate)
			BEGIN
					SET @CustID = (SELECT CustomerID  from Sales.Customers
						WHERE 
								Phone = @Phone AND 
								Email = @Email AND
								BirthDate = @BirthDate)

				SET @ErrorMessage = CONCAT('Already Exist customer with ID', @CustID);
				RAISERROR(@ErrorMessage,16,1);
			--	SELECT @CustID
				 
			END*/

--	IF NOT EXISTS (Select Email From Sales.Customers where Email = @Email) AND 
--	NOT EXISTS (Select Phone From Sales.Customers where Phone = @Phone)
--BEGIN TRY 
				