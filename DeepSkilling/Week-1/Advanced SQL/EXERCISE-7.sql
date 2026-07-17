USE EmployeeManagementSystem;
GO
DROP TRIGGER IF EXISTS trg_UpdateAnnualSalary;
GO
DROP TRIGGER IF EXISTS trg_PreventEmployeeDelete;
GO
DELETE FROM Employees;
GO
DELETE FROM Departments;
GO
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES (1, 'HR'), (2, 'IT'), (3, 'Finance');
GO
INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID, Salary, JoinDate) VALUES
(1, 'John', 'Doe', 1, 5000.00, '2020-01-15'), (2, 'Jane', 'Smith', 2, 6000.00, '2019-03-22'), (3, 'Bob', 'Johnson', 3, 5500.00, '2021-07-30');
GO
DECLARE @EmployeeID INT;
DECLARE @FirstName VARCHAR(50);
DECLARE @LastName VARCHAR(50);
DECLARE @DepartmentID INT;
DECLARE @Salary DECIMAL(10,2);
DECLARE @JoinDate DATE;
DECLARE EmployeeCursor CURSOR FOR
SELECT EmployeeID, FirstName, LastName, DepartmentID, Salary, JoinDate
FROM Employees;
OPEN EmployeeCursor;
FETCH NEXT FROM EmployeeCursor
INTO @EmployeeID, @FirstName, @LastName, @DepartmentID, @Salary, @JoinDate;
WHILE @@FETCH_STATUS = 0 BEGIN 
    PRINT 'Employee ID: ' + CAST(@EmployeeID AS VARCHAR(10)) + ', Name: ' + @FirstName + ' ' + @LastName + ', Department ID: ' + CAST(@DepartmentID AS VARCHAR(10))
        + ', Salary: ' + CAST(@Salary AS VARCHAR(20)) + ', Join Date: ' + CONVERT(VARCHAR(10), @JoinDate, 120);
    FETCH NEXT FROM EmployeeCursor
    INTO @EmployeeID, @FirstName, @LastName, @DepartmentID, @Salary, @JoinDate;
END;
CLOSE EmployeeCursor;
DEALLOCATE EmployeeCursor;
GO