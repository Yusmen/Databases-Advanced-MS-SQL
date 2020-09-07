CREATE DATABASE PEOPLE 
GO
CREATE TABLE Persons(
PersonId int Primary Key Not Null,
FirstName nvarchar(50) NOT NULL,
Salary DECIMAL(15,2) Not NULL,
PassportId int NOT NULL

)
GO

Create Table Passports(
PassportId int Primary Key NOT NULL,
PassportNumber CHAR(8) NOT NULL

)


Alter Table Persons
ADD Constraint FK_Persons_Passports Foreign Key (PassportId) References Passports(PassportId)

ALTER TABLE Persons
ADD UNIQUE(PassportId) 

Alter Table Passports
Add Unique(PassportNumber)


Create Table Models(

ModellId int Primary Key NOT NULL,
Name Char(8),
ManufacturerId int NOT NULL

 
)

CREATE TABLE Manufacturers(

ManufacturerId int Primary Key NOT NULL,
Name char(10) NOT NULL,
EstablishedOn DATE
)

Alter Table Models
ADD Constraint FK_Models_Manufacturers Foreign Key (ManufacturerId) References Manufacturers(ManufacturerId)

GO
Create Table Students(
StudentId int Primary Key Not NULL,
Name Char(10)

)
GO
Create Table Exams(
ExamID int Primary Key NOT NULL,
Name char(10) NOT NULL
)
GO

Create Table StudentsExams(

StudentID INT,
ExamID INT,
Constraint PK_StudentsExams Primary Key(StudentID,ExamID),
Constraint FK_StudentsExams_Stuedents Foreign Key (StudentID) References Students(StudentID),
Constraint FK_StudentsExams_Exams Foreign Key (ExamID) References Exams(ExamID)

) 

Create Table Teachers(
TeacherID int PRIMARY KEY NOT NULL,
Name VARCHAR(30),
ManagerID int Foreign Key References Teachers(TeacherID)
)



