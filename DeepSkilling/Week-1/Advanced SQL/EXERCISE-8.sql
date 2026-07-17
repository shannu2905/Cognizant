USE EmployeeManagementSystem;
GO

DROP TABLE IF EXISTS AuditLog;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Departments;
GO
CREATE TABLE Departments(DepartmentID INT PRIMARY KEY, DepartmentName VARCHAR(100) NOT NULL);
GO
CREATE TABLE Employees(EmployeeID INT PRIMARY KEY,FirstName VARCHAR(50),LastName VARCHAR(50),Email VARCHAR(100) UNIQUE,
    Salary DECIMAL(10,2),DepartmentID INT, FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID));
GO

CREATE TABLE AuditLog(LogID INT IDENTITY(1,1) PRIMARY KEY, Action VARCHAR(100), ErrorMessage VARCHAR(4000),
    ActionDate DATETIME DEFAULT GETDATE());
GO
INSERT INTO Departments VALUES(1, 'HR'),(2, 'IT'),(3, 'Finance');
GO

-- Exercise-1

CREATE PROCEDURE AddEmployee @EmployeeID INT,@FirstName VARCHAR(50),@LastName VARCHAR(50),@Email VARCHAR(100),@Salary DECIMAL(10,2),
    @DepartmentID INT AS BEGIN BEGIN TRY 
        INSERT INTO Employees VALUES(@EmployeeID,@FirstName,@LastName,@Email,@Salary,@DepartmentID);
        PRINT 'Employee added successfully';
    END TRY
    BEGIN CATCH
        INSERT INTO AuditLog(Action, ErrorMessage) VALUES('Add Employee Error', ERROR_MESSAGE());
        PRINT 'Error occurred';
    END CATCH
END;
GO
EXEC AddEmployee 1, 'John', 'Doe', 'john@gmail.com', 5000, 1;
GO
EXEC AddEmployee 2, 'Jane', 'Smith', 'john@gmail.com', 6000, 2;
GO
SELECT * FROM Employees;
SELECT * FROM AuditLog;
GO

-- Exercise-2

ALTER PROCEDURE AddEmployee @EmployeeID INT,@FirstName VARCHAR(50),@LastName VARCHAR(50),@Email VARCHAR(100),@Salary DECIMAL(10,2),
    @DepartmentID INT AS BEGIN BEGIN TRY
        INSERT INTO Employees VALUES(@EmployeeID,@FirstName,@LastName,@Email,@Salary,@DepartmentID);
        PRINT 'Employee added successfully';
    END TRY
    BEGIN CATCH
        INSERT INTO AuditLog(Action, ErrorMessage) VALUES('Add Employee Error', ERROR_MESSAGE());
        THROW;
    END CATCH
END;
GO
EXEC AddEmployee 3, 'Bob', 'Johnson', 'john@gmail.com', 5500, 3;
GO
SELECT * FROM AuditLog;
GO

-- Exercise-3

ALTER PROCEDURE AddEmployee @EmployeeID INT,@FirstName VARCHAR(50),@LastName VARCHAR(50),@Email VARCHAR(100),@Salary DECIMAL(10,2),
    @DepartmentID INT AS BEGIN BEGIN TRY
        IF @Salary <= 0 BEGIN
            RAISERROR('Salary must be greater than zero.',16,1);
        END;
        INSERT INTO Employees  VALUES(@EmployeeID,@FirstName,@LastName,@Email,@Salary,@DepartmentID);
        PRINT 'Employee added successfully';
    END TRY
    BEGIN CATCH
        INSERT INTO AuditLog(Action, ErrorMessage)VALUES('Add Employee Error', ERROR_MESSAGE());
        THROW;
    END CATCH
END;
GO

-- Exercise-4

CREATE PROCEDURE TransferEmployee @EmployeeID INT,@NewDepartmentID INT
AS BEGIN BEGIN TRY
        BEGIN TRY
            IF NOT EXISTS(SELECT * FROM Departments WHERE DepartmentID = @NewDepartmentID)
            BEGIN RAISERROR('Department does not exist.',16,1);
            END;
            UPDATE Employees SET DepartmentID = @NewDepartmentID WHERE EmployeeID = @EmployeeID;
            PRINT 'Employee transferred successfully';
        END TRY
        BEGIN CATCH
            INSERT INTO AuditLog(Action, ErrorMessage) VALUES('Transfer Inner Error', ERROR_MESSAGE());
            THROW;
        END CATCH
    END TRY
    BEGIN CATCH
        PRINT 'Error received by outer CATCH';
        THROW;
    END CATCH
END;
GO
EXEC TransferEmployee 1, 10;
GO
SELECT * FROM AuditLog;
GO

-- Exercise-5

CREATE PROCEDURE BatchInsertEmployees AS BEGIN BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO Employees VALUES(10, 'Ram', 'Kumar', 'ram@gmail.com', 5000, 1);
        INSERT INTO Employees VALUES(11, 'Ravi', 'Kumar', 'ravi@gmail.com', 6000, 2);
        INSERT INTO Employees VALUES (12, 'Sam', 'Kumar', 'ram@gmail.com', 7000, 3);
        COMMIT TRANSACTION;
        PRINT 'All employees inserted successfully';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        INSERT INTO AuditLog(Action, ErrorMessage) VALUES('Batch Insert Error', ERROR_MESSAGE());
        PRINT 'Transaction rolled back';
    END CATCH
END;
GO
EXEC BatchInsertEmployees;
GO
SELECT * FROM Employees;
SELECT * FROM AuditLog;
GO


-- Exercise-6

ALTER PROCEDURE AddEmployee @EmployeeID INT,@FirstName VARCHAR(50),@LastName VARCHAR(50),@Email VARCHAR(100),@Salary DECIMAL(10,2),@DepartmentID INT
AS BEGIN
    BEGIN TRY
        IF @Salary < 0 BEGIN RAISERROR('Salary cannot be negative.',16,1);
        END;
        IF @Salary < 1000 BEGIN RAISERROR('Warning: Salary is too low.',10,1);
        END;
        INSERT INTO Employees VALUES(@EmployeeID,@FirstName,@LastName,@Email,@Salary,@DepartmentID);
        PRINT 'Employee added successfully';
    END TRY
    BEGIN CATCH
        INSERT INTO AuditLog(Action, ErrorMessage)VALUES('Add Employee Error', ERROR_MESSAGE());
        THROW;
    END CATCH
END;
GO 
EXEC AddEmployee 20, 'Arun', 'Kumar', 'arun@gmail.com', 500, 1;
GO
EXEC AddEmployee 21, 'Kiran', 'Rao', 'kiran@gmail.com', -500, 2;
GO
SELECT * FROM Employees;
SELECT * FROM AuditLog;
GO