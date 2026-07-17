USE EmployeeManagementSystem;
GO
DROP TRIGGER IF EXISTS trg_UpdateAnnualSalary;
GO
IF COL_LENGTH('Employees', 'AnnualSalary') IS NOT NULL BEGIN ALTER TABLE Employees DROP COLUMN AnnualSalary;
END;
GO
ALTER TABLE Employees ADD AnnualSalary DECIMAL(12,2);
GO
UPDATE Employees SET AnnualSalary = Salary * 12;
GO
CREATE TRIGGER trg_UpdateAnnualSalary ON Employees AFTER UPDATE AS BEGIN SET NOCOUNT ON;
    IF UPDATE(Salary) BEGIN UPDATE e SET e.AnnualSalary = i.Salary * 12 FROM Employees e INNER JOIN inserted i 
    ON e.EmployeeID = i.EmployeeID;
    END;
END;
GO
UPDATE Employees SET Salary = 6000.00 WHERE EmployeeID = 1;
GO
SELECT EmployeeID, FirstName, Salary, AnnualSalary FROM Employees;
GO