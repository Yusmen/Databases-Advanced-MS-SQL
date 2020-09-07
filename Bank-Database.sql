CREATE DATABASE Bank
GO
USE Bank
GO
CREATE TABLE AccountHolders
(
Id INT NOT NULL,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
SSN CHAR(10) NOT NULL
CONSTRAINT PK_AccountHolders PRIMARY KEY (Id)
)

CREATE TABLE Accounts
(
Id INT NOT NULL,
AccountHolderId INT NOT NULL,
Balance MONEY DEFAULT 0
CONSTRAINT PK_Accounts PRIMARY KEY (Id)
CONSTRAINT FK_Accounts_AccountHolders FOREIGN KEY (AccountHolderId) REFERENCES AccountHolders(Id)
)

INSERT INTO AccountHolders (Id, FirstName, LastName, SSN) VALUES (1, 'Susan', 'Cane', '1234567890');
INSERT INTO AccountHolders (Id, FirstName, LastName, SSN) VALUES (2, 'Kim', 'Novac', '1234567890');
INSERT INTO AccountHolders (Id, FirstName, LastName, SSN) VALUES (3, 'Jimmy', 'Henderson', '1234567890');
INSERT INTO AccountHolders (Id, FirstName, LastName, SSN) VALUES (4, 'Steve', 'Stevenson', '1234567890');
INSERT INTO AccountHolders (Id, FirstName, LastName, SSN) VALUES (5, 'Bjorn', 'Sweden', '1234567890');
INSERT INTO AccountHolders (Id, FirstName, LastName, SSN) VALUES (6, 'Kiril', 'Petrov', '1234567890');
INSERT INTO AccountHolders (Id, FirstName, LastName, SSN) VALUES (7, 'Petar', 'Kirilov', '1234567890');
INSERT INTO AccountHolders (Id, FirstName, LastName, SSN) VALUES (8, 'Michka', 'Tsekova', '1234567890');
INSERT INTO AccountHolders (Id, FirstName, LastName, SSN) VALUES (9, 'Zlatina', 'Pateva', '1234567890');
INSERT INTO AccountHolders (Id, FirstName, LastName, SSN) VALUES (10, 'Monika', 'Miteva', '1234567890');
INSERT INTO AccountHolders (Id, FirstName, LastName, SSN) VALUES (11, 'Zlatko', 'Zlatyov', '1234567890');
INSERT INTO AccountHolders (Id, FirstName, LastName, SSN) VALUES (12, 'Petko', 'Petkov Junior', '1234567890');

INSERT INTO Accounts (Id, AccountHolderId, Balance) VALUES (1, 1, 123.12);
INSERT INTO Accounts (Id, AccountHolderId, Balance) VALUES (2, 3, 4354.23);
INSERT INTO Accounts (Id, AccountHolderId, Balance) VALUES (3, 12, 6546543.23);
INSERT INTO Accounts (Id, AccountHolderId, Balance) VALUES (4, 9, 15345.64);
INSERT INTO Accounts (Id, AccountHolderId, Balance) VALUES (5, 11, 36521.20);
INSERT INTO Accounts (Id, AccountHolderId, Balance) VALUES (6, 8, 5436.34);
INSERT INTO Accounts (Id, AccountHolderId, Balance) VALUES (7, 10, 565649.20);
INSERT INTO Accounts (Id, AccountHolderId, Balance) VALUES (8, 11, 999453.50);
INSERT INTO Accounts (Id, AccountHolderId, Balance) VALUES (9, 1, 5349758.23);
INSERT INTO Accounts (Id, AccountHolderId, Balance) VALUES (10, 2, 543.30);
INSERT INTO Accounts (Id, AccountHolderId, Balance) VALUES (11, 3, 10.20);
INSERT INTO Accounts (Id, AccountHolderId, Balance) VALUES (12, 7, 245656.23);
INSERT INTO Accounts (Id, AccountHolderId, Balance) VALUES (13, 5, 5435.32);
INSERT INTO Accounts (Id, AccountHolderId, Balance) VALUES (14, 4, 1.23);
INSERT INTO Accounts (Id, AccountHolderId, Balance) VALUES (15, 6, 0.19);
INSERT INTO Accounts (Id, AccountHolderId, Balance) VALUES (16, 2, 5345.34);
INSERT INTO Accounts (Id, AccountHolderId, Balance) VALUES (17, 11, 76653.20);
INSERT INTO Accounts (Id, AccountHolderId, Balance) VALUES (18, 1, 235469.89);

Go
Create Proc usp_GetHoldersFullName
AS

Select FirstName + ' ' + LastName AS [Full Name] From AccountHolders
Go

exec usp_GetHoldersFullName

Go


Select FirstName,LastName,SUM(Balance) AS Total From Accounts AS a
JOIN AccountHolders As ah ON ah.Id=a.AccountHolderId
Group By FirstName,LastName
Go

Create Function ufn_CalculateFutureValue(@sum DECIMAL(18,4),@yearlyInterestRate FLOAT,@numberOfYears INT)
Returns DECIMAL(18,4)
BEGIN

RETURN @sum*POWER((1+@yearlyInterestRate),@numberOfYears) 
END
GO

SELECT dbo.ufn_CalculateFutureValue(1000,0.1,5)

Go 

Create Proc usp_CalculateFutureValueForAccount
AS
Select a.Id,ah.FirstName,ah.LastName,a.Balance As [Current Balance],dbo.ufn_CalculateFutureValue(a.Balance,0.1,5)
 AS [Balance in 5 years] From Accounts AS a 
Join AccountHolders AS ah On ah.Id=a.AccountHolderId
Go

exec usp_CalculateFutureValueForAccount


Create Table Logs(

 LogId INT NOT NULL,
 AccountId INT NOT NULL,
 OldSum Decimal(15,2),
 NewSum Decimal(15,2),
 Constraint FK_Logs_Accounts  Foreign Key (AccountId) References  Accounts(Id)

)


GO
Alter Trigger tr_InsertAccountInfo On Accounts For Update
AS
Declare @newSum DEcimal(15,2)=(Select Balance From inserted)
Declare @oldSum DEcimal(15,2)=(Select Balance From deleted)
Declare @accountId Int=(Select Id From inserted)

Insert Into Logs (AccountId,NewSum,OldSum)  Values
(@accountId,@newSum,@oldSum)

Update Accounts
Set Balance+=10
Where Id=2

Select * From Logs

Select * From Accounts Where Id=1

Create Table NotificationEmails(
Id INT IDENTITY,
Recipient INT Foreign Key References Accounts(Id),
[Subject] VARCHAR(50),
Body VARChAR(max)
)
Go
Alter Trigger tr_LogEmails On Logs For Insert
As
Declare @accountId INT=(Select Top 1 AccountId From inserted)
Declare @oldsum Decimal(15,2)=(Select Top 1 OldSum From inserted)
Declare @newSum DEcimal(15,2)=(Select Top 1 NewSum From inserted)

Insert Into NotificationEmails(Recipient,Subject,Body) Values
(@accountId,'Balance change for account: ' + CONVERT(varchar(2),@accountId),'On '+CONVERT(varchar(50),GETDATE(),103)+' your balance was changed

from '+ CONVERT(varchar(10),@oldsum)+ ' to '  + CONVERT(varchar(10),@newSum)) 

Go

Select * From NotificationEmails


Update Accounts
SET Balance+=100
Where Id=2


Go 

Create proc usp_DepositMoney @accountId INT ,@moneyAmount Decimal(15,4)
AS
Begin Transaction

Declare @account INT=(Select Id From accounts Where Id=@accountId )

IF(@account IS NULL)
BEGIN
   ROLLBACK
   RAISERROR('Invalid Id!!',16,1)
   RETURN
END
IF(@moneyAmount <0)
BEGIN
   ROLLBACK
   RAISERROR('Money amount cannot be negative!!',16,1)
   RETURN
END
 UPDATE Accounts
 SET Balance+=@moneyAmount
 where Id=@accountId
 COMMIT
 Go


 exec  usp_DepositMoney @accountId= 1 ,@moneyAmount= 100
Go
Select * From Accounts Where Id=1

Go

Create Proc usp_WithdrawMoney @accountId INT ,@moneyAmount DECIMAL(15,4)
As
BEGIN TRANSACTION

DECLARE @account INT=(Select Id From Accounts Where Id=@accountId)

IF(@account IS NULL)
BEGIN
   ROLLBACK
   RAISERROR('Invalid account Id!!',16,1)
   RETURN 
END

IF(@moneyAmount<0)
BEGIN

   ROLLBACK
   RAISERROR('Money amount cannont be negative',16,1)
   RETURN 
END
UPDATE Accounts
SET Balance-=@moneyAmount
Where Id=@accountId
COMMIT 


exec usp_WithdrawMoney 1,10

Select*From Accounts Where Id=1
Go
 Alter Proc usp_TransferMoney @senderId INT,@receiverID INT,@amount DECIMAL(15,4)
AS
BEGIN TRANSACTION
Declare @sender INT=(Select Id From Accounts Where Id=@senderId)
Declare @receiver INT=(Select Id From Accounts Where Id=@senderId)

IF((Select Balance FROM Accounts where Id=@senderId)<@amount)
BEGIN
    ROLLBACK
   RAISERROR('Not enough money in the sender',16,1) 
   RETURN

END

IF(@sender IS NULL)
BEGIN
   ROLLBACK
   RAISERROR('Invalid sender Id!!',16,1) 
   RETURN
END
IF(@receiver IS NULL)
BEGIN
    
   ROLLBACK
   RAISERROR('Invalid receiver Id!!',16,1) 
   RETURN
END
IF(@amount <0)
BEGIN

   ROLLBACK
   RAISERROR('Money amount cannot be negative!',16,1) 
   RETURN
END

UPDATE Accounts
SET Balance-=@amount
Where Id=@senderId

UPDATE Accounts
SET Balance+=@amount
Where Id=@receiverID

COMMIT
 
 exec usp_TransferMoney 5,1,10000000
  Select * From Accounts Where Id=1

						