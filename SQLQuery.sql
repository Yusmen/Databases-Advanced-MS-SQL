CREATE TABLE Towns
(
Id INT PRIMARY KEY IDENTITY,
Name VARCHAR(20) NOT NULL,


)
CREATE TABLE Adresses
(
Id INT PRIMARY KEY IDENTITY,
AdressText VARCHAR(20) NOT NULL,
TownId INT FOREIGN KEY REFERENCES Towns(Id)

)
CREATE TABLE Departments
(
Id INT PRIMARY KEY IDENTITY,
Name VARCHAR(50) NOT NULL,


)
--Id, FirstName, MiddleName, LastName, JobTitle, DepartmentId, HireDate, Salary, AddressId
CREATE TABLE Employees
(
Id INT PRIMARY KEY IDENTITY,
FirstName VARCHAR(50),
MiddleName VARCHAR(30),
LastName VARCHAR(30),
JobTitle VARCHAR(20),
DepartmentId INT FOREIGN KEY REFERENCES Departments(Id),
HireDate DATE,
Salary DECIMAL(15,2),
AddressId INT FOREIGN KEY REFERENCES Adresses(Id)


)


INSERT INTO Towns(Name)
VALUES
('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas')


INSERT INTO Departments(Name)
VALUES 
('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance')

GO

SET IDENTITY_INSERT  Employees ON
 INSERT INTO Employees(Id,FirstName,JobTitle,DepartmentId,HireDate,Salary)
 VALUES
(1,'Ivan Ivanov Ivanov','.NET Developer',4,'01/02/2013',3500.00),
 (2,'Petar Petrov Petrov','Senior Engineer',1,'02/03/2004',4000.00),
 (3,'Maria Petrova Ivanchova','Intern',5,'02/03/2004',525.25),
 (4,'Georgi Teziev Ivanov','CEO',2,'09/12/2007',3000.00),
 (5,'Peter Pan Pan','Intern',3,'02/03/2004',599.88)

 SELECT*FROM Employees



