-----------------------------------------------------------------------------------------------------------------------------------------------
-- Script that tests the new database from the YouTube bootcamp

--     Data Analyst Bootcamp for Beginners (SQL, Tableau, Power BI, Python, Excel, Pandas, Projects, more)
--     REF : https://www.youtube.com/watch?v=PSNXoAs2FtQ
--
-- Last updated: 20251231
--
-- © Rob Langnau - rob@langnau.us
-----------------------------------------------------------------------------------------------------------------------------------------------
USE SQLTutor;
GO

-- A LEFT JOIN Example of the Data
SELECT 
    Demographics.EmployeeID, 
    Demographics.FirstName, 
    Demographics.LastName, 
    Salary.JobTitle, 
    Salary.Salary
FROM EmployeeDemographics AS Demographics
-- You could write this as "INNER JOIN" and the results would be the same
LEFT JOIN EmployeeSalary AS Salary
    ON Demographics.EmployeeID = Salary.EmployeeID;