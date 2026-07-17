CREATE DATABASE EmployeeManagement;
USE EmployeeManagement;
CREATE TABLE Departments (DepartmentID INT PRIMARY KEY,DepartmentName VARCHAR(100));
CREATE TABLE Employees (EmployeeID INT PRIMARY KEY,FirstName VARCHAR(50),LastName VARCHAR(50),DepartmentID INT,Salary DECIMAL(10,2),
    JoinDate DATE,FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID));
INSERT INTO Departments VALUES(1,'HR'),(2,'IT'),(3,'Finance'),(4,'Marketing');
INSERT INTO Employees VALUES (101,'Rahul','Sharma',1,35000,'2022-01-15'),(102,'Priya','Reddy',2,50000,'2021-06-10'),
(103,'Kiran','Kumar',3,45000,'2020-03-20'),(104,'Sneha','Patel',4,40000,'2023-02-05');

-- Exercise-1
CREATE VIEW vw_EmployeeBasicInfo AS SELECT e.EmployeeID,e.FirstName,e.LastName,d.DepartmentName FROM Employees e JOIN Departments d
ON e.DepartmentID = d.DepartmentID;
SELECT * FROM vw_EmployeeBasicInfo;

-- Exercise-2
CREATE VIEW vw_EmployeeFullName AS SELECT EmployeeID,CONCAT(FirstName,' ',LastName) AS FullName,DepartmentID,Salary FROM Employees;
SELECT * FROM vw_EmployeeFullName;

-- Exercise-3
CREATE VIEW vw_EmployeeAnnualSalary AS SELECT EmployeeID,FirstName,LastName,Salary,Salary * 12 AS AnnualSalary FROM Employees;
SELECT * FROM vw_EmployeeAnnualSalary;

-- Exercise-4
CREATE VIEW vw_EmployeeReport AS SELECT e.EmployeeID,CONCAT(e.FirstName,' ',e.LastName) AS FullName,d.DepartmentName,
    e.Salary * 12 AS AnnualSalary,(e.Salary * 12) * 0.10 AS Bonus FROM Employees e JOIN Departments d ON e.DepartmentID = d.DepartmentID;
SELECT * FROM vw_EmployeeReport;