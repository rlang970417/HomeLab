-----------------------------------------------------------------------------------------------------------------------------------------------
-- Script that builds and loads the database used by Alex the Analyst in hist YoutTube Guides

--     Data Analyst Bootcamp for Beginners (SQL, Tableau, Power BI, Python, Excel, Pandas, Projects, more)
--     REF : https://www.youtube.com/watch?v=PSNXoAs2FtQ
--     REF : https://github.com/AlexTheAnalyst/SQL-Code/blob/master/SQL%20Basics%20Create%20Table%20and%20Insert%20Into
--
-- Last updated: 20251231
--
-- © Rob Langnau - rob@langnau.us
-----------------------------------------------------------------------------------------------------------------------------------------------
-- Run the following code to create an empty database called SQLTutor
USE master;

-- Drop database
IF DB_ID('SQLTutor') IS NOT NULL DROP DATABASE SQLTutor;

-- If database could not be created due to open connections, abort
IF @@ERROR = 3702
   RAISERROR('Database cannot be dropped because there are still open connections.', 127, 127) WITH NOWAIT, LOG;

-- Create database
CREATE DATABASE SQLTutor;
GO

USE SQLTutor;
GO


-- Create tables
Create Table EmployeeDemographics 
(EmployeeID int, 
FirstName varchar(50), 
LastName varchar(50), 
Age int, 
Gender varchar(50)
)

Create Table EmployeeSalary 
(EmployeeID int, 
JobTitle varchar(50), 
Salary int
)

-- Load data
Insert into EmployeeDemographics VALUES
(1001, 'Jim', 'Halpert', 30, 'Male'),
(1002, 'Pam', 'Beasley', 30, 'Female'),
(1003, 'Dwight', 'Schrute', 29, 'Male'),
(1004, 'Angela', 'Martin', 31, 'Female'),
(1005, 'Toby', 'Flenderson', 32, 'Male'),
(1006, 'Michael', 'Scott', 35, 'Male'),
(1007, 'Meredith', 'Palmer', 32, 'Female'),
(1008, 'Stanley', 'Hudson', 38, 'Male'),
(1009, 'Kevin', 'Malone', 31, 'Male')

Insert Into EmployeeSalary VALUES
(1001, 'Salesman', 45000),
(1002, 'Receptionist', 36000),
(1003, 'Salesman', 63000),
(1004, 'Accountant', 47000),
(1005, 'HR', 50000),
(1006, 'Regional Manager', 65000),
(1007, 'Supplier Relations', 41000),
(1008, 'Salesman', 48000),
(1009, 'Accountant', 42000)