-- Exercise-1
DELIMITER //
CREATE FUNCTION fn_CalculateAnnualSalary(Salary DECIMAL(10,2))
RETURNS DECIMAL(10,2) DETERMINISTIC BEGIN RETURN Salary * 12;
END // DELIMITER ;
SELECT EmployeeID,FirstName,Salary,fn_CalculateAnnualSalary(Salary) AS AnnualSalary FROM Employees;

-- Exercise-2
SELECT * FROM Employees WHERE DepartmentID = 2;

-- Exercise-3
DELIMITER //
CREATE FUNCTION fn_CalculateBonus(Salary DECIMAL(10,2)) RETURNS DECIMAL(10,2) DETERMINISTIC BEGIN RETURN Salary * 0.10;
END // DELIMITER ;
SELECT EmployeeID,FirstName,Salary,fn_CalculateBonus(Salary) AS Bonus FROM Employees;

-- Exercise-4
DROP FUNCTION IF EXISTS fn_CalculateBonus;

DELIMITER //
CREATE FUNCTION fn_CalculateBonus(Salary DECIMAL(10,2)) RETURNS DECIMAL(10,2) DETERMINISTIC BEGIN RETURN Salary * 0.15;
END // DELIMITER ;
SELECT EmployeeID,FirstName,Salary,fn_CalculateBonus(Salary) AS Bonus FROM Employees;

-- Exercise-5
DROP FUNCTION fn_CalculateBonus;
SHOW FUNCTION STATUS WHERE Db = DATABASE();

-- Exercise-6
SELECT EmployeeID,FirstName,fn_CalculateAnnualSalary(Salary) AS AnnualSalary FROM Employees;

-- Exercise-7
SELECT EmployeeID,FirstName,fn_CalculateAnnualSalary(Salary) AS AnnualSalary FROM Employees WHERE EmployeeID = 1;

-- Exercise-8
SELECT * FROM Employees WHERE DepartmentID = 3;

-- Exercise-9
DELIMITER //
CREATE FUNCTION fn_CalculateBonus(Salary DECIMAL(10,2)) RETURNS DECIMAL(10,2) DETERMINISTIC BEGIN RETURN Salary * 0.15;
END // DELIMITER ;
SELECT EmployeeID,FirstName,fn_CalculateTotalCompensation(Salary) AS TotalCompensation FROM Employees;

-- Exercise-10
DROP FUNCTION IF EXISTS fn_CalculateTotalCompensation;
DELIMITER //
CREATE FUNCTION fn_CalculateTotalCompensation(Salary DECIMAL(10,2))RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN (Salary * 12) + (Salary * 0.15);
END //

DELIMITER ;