-- Exercise-1
DELIMITER //
CREATE PROCEDURE sp_GetEmployeesByDepartment(IN DeptID INT) BEGIN SELECT * FROM Employees WHERE DepartmentID = DeptID;
END // DELIMITER ;
CALL sp_GetEmployeesByDepartment(1);

-- Exercise-2
DROP PROCEDURE IF EXISTS sp_GetEmployeesByDepartment;
DELIMITER //
CREATE PROCEDURE sp_GetEmployeesByDepartment(IN DeptID INT) BEGIN SELECT EmployeeID,FirstName,LastName,DepartmentID,Salary
    FROM Employees WHERE DepartmentID = DeptID;	
END // DELIMITER ;

-- Exercise-3
DROP PROCEDURE sp_GetEmployeesByDepartment;

-- Exercise-4
CALL sp_GetEmployeesByDepartment(1);

-- Exercise-5
DELIMITER //
CREATE PROCEDURE sp_TotalEmployees(IN DeptID INT) BEGIN SELECT COUNT(*) AS TotalEmployees FROM Employees WHERE DepartmentID = DeptID;
END // DELIMITER ;
CALL sp_TotalEmployees(1);

-- Exercise-6
DELIMITER //
CREATE PROCEDURE sp_TotalSalary(IN DeptID INT,OUT TotalSalary DECIMAL(10,2)) BEGIN SELECT SUM(Salary) INTO TotalSalary FROM Employees
    WHERE DepartmentID = DeptID;
END // DELIMITER ;
CALL sp_TotalSalary(1,@Total);
SELECT @Total;

-- Exercise-7
DELIMITER //

CREATE PROCEDURE sp_UpdateEmployeeSalary(IN EmpID INT,IN NewSalary DECIMAL(10,2)) BEGIN UPDATE Employees SET Salary = NewSalary 
WHERE EmployeeID = EmpID;
END // DELIMITER ;
CALL sp_UpdateEmployeeSalary(1,5500.00);
	
-- Exercise-8
DELIMITER //
CREATE PROCEDURE sp_GiveBonus(IN DeptID INT,IN BonusAmount DECIMAL(10,2)) BEGIN UPDATE Employees SET Salary = Salary + BonusAmount
    WHERE DepartmentID = DeptID;
END // DELIMITER ;
CALL sp_GiveBonus(1,500.00);

-- Exercise-9
DELIMITER //
CREATE PROCEDURE sp_UpdateSalaryTransaction(IN EmpID INT,IN NewSalary DECIMAL(10,2)) BEGIN START TRANSACTION;
    UPDATE Employees SET Salary = NewSalary WHERE EmployeeID = EmpID;
    COMMIT;
END // DELIMITER ;
CALL sp_UpdateSalaryTransaction(1,6000.00);

-- Exercise-10
DELIMITER //
CREATE PROCEDURE sp_SearchEmployee(IN ColumnName VARCHAR(50),IN ValueData VARCHAR(50))
BEGIN SET @query = CONCAT('SELECT * FROM Employees WHERE ',ColumnName,' = ''',ValueData,'''');
    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END // DELIMITER ;
CALL sp_SearchEmployee('FirstName','John');

-- Exercise-11 
DELIMITER //
CREATE PROCEDURE sp_UpdateSalaryWithError(IN EmpID INT,IN NewSalary DECIMAL(10,2))BEGIN DECLARE EXIT HANDLER FOR SQLEXCEPTION 
BEGIN SELECT 'Error occurred while updating salary' AS Message;
    END;
    UPDATE Employees SET Salary = NewSalary WHERE EmployeeID = EmpID;
    SELECT 'Salary updated successfully' AS Message;
END // DELIMITER ;

