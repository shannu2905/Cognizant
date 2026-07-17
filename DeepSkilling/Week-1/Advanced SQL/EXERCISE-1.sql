DROP DATABASE IF EXISTS OnlineRetailStore;
CREATE DATABASE OnlineRetailStore;
USE OnlineRetailStore;
CREATE TABLE Customers(CustomerID INT PRIMARY KEY,Name VARCHAR(100),Region VARCHAR(50));
CREATE TABLE Products(ProductID INT PRIMARY KEY,ProductName VARCHAR(100),Category VARCHAR(50),Price DECIMAL(10,2));
CREATE TABLE Orders(OrderID INT PRIMARY KEY,CustomerID INT,OrderDate DATE,FOREIGN KEY(CustomerID)REFERENCES Customers(CustomerID));
CREATE TABLE OrderDetails(OrderDetailID INT PRIMARY KEY,OrderID INT,ProductID INT,Quantity INT,FOREIGN KEY(OrderID)REFERENCES Orders(OrderID),
    FOREIGN KEY(ProductID) REFERENCES Products(ProductID));
INSERT INTO Customers VALUES(1,'Ravi','South'),(2,'Kiran','North'),(3,'Anil','East'),(4,'Suresh','West');
INSERT INTO Products VALUES(101,'Laptop','Electronics',60000),(102,'Mobile','Electronics',25000),(103,'Printer','Electronics',10000),
(104,'Table','Furniture',5000),(105,'Chair','Furniture',3000);
INSERT INTO Orders VALUES (1,1,'2025-01-05'),(2,2,'2025-01-10'),(3,1,'2025-02-15'),(4,3,'2025-03-20'),(5,1,'2025-04-01'),
	(6,1,'2025-04-15');
INSERT INTO OrderDetails VALUES(1,1,101,2),(2,1,104,1),(3,2,102,3),(4,3,103,2),(5,4,105,5),(6,5,101,1),(7,6,102,2);
SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM OrderDetails;

 -- Exercise-1 
SELECT ProductID,ProductName,Category,Price,
    ROW_NUMBER() OVER (PARTITION BY Category ORDER BY Price DESC) AS RowNo,
    RANK() OVER (PARTITION BY Category ORDER BY Price DESC) AS RankNo,
    DENSE_RANK() OVER (PARTITION BY Category ORDER BY Price DESC) AS DenseRankNo FROM Products;

  -- Exercise-2
SELECT c.Region,p.Category,SUM(od.Quantity) AS TotalQuantity FROM Orders o JOIN OrderDetails od ON o.OrderID = od.OrderID JOIN Customers c
ON o.CustomerID = c.CustomerID JOIN Products p ON od.ProductID = p.ProductID GROUP BY c.Region, p.Category WITH ROLLUP;
 
  -- Exercise-3(a)
WITH RECURSIVE Calendar AS(SELECT '2025-01-01' AS DateValue UNION ALL SELECT DATE_ADD(DateValue, INTERVAL 1 DAY)
    FROM Calendar WHERE DateValue < '2025-01-31') SELECT * FROM Calendar; 
CREATE TABLE StagingProducts(ProductID INT PRIMARY KEY,ProductName VARCHAR(100),Category VARCHAR(50),Price DECIMAL(10,2));
INSERT INTO StagingProducts VALUES(101,'Laptop','Electronics',65000),(102,'Mobile','Electronics',28000),(106,'Sofa','Furniture',15000);

-- Exercise-3(b)
UPDATE Products p JOIN StagingProducts s ON p.ProductID = s.ProductID SET p.ProductName = s.ProductName, p.Category = s.Category,
    p.Price = s.Price;
INSERT INTO Products(ProductID, ProductName, Category, Price) SELECT s.ProductID, s.ProductName, s.Category, s.Price FROM StagingProducts s
LEFT JOIN Products p ON s.ProductID = p.ProductID WHERE p.ProductID IS NULL;
SELECT * FROM Products;

-- Exercise-4(1)
SELECT p.ProductName,MONTH(o.OrderDate) AS MonthNo,SUM(od.Quantity) AS TotalQuantity FROM Orders o JOIN OrderDetails od 
ON o.OrderID = od.OrderID JOIN Products p ON od.ProductID = p.ProductID GROUP BY p.ProductName, MONTH(o.OrderDate);

-- Exercise-4(2)
CREATE VIEW PivotSales AS SELECT p.ProductName, SUM(CASE WHEN MONTH(o.OrderDate)=1 THEN od.Quantity ELSE 0 END) AS Jan,
    SUM(CASE WHEN MONTH(o.OrderDate)=2 THEN od.Quantity ELSE 0 END) AS Feb, 
    SUM(CASE WHEN MONTH(o.OrderDate)=3 THEN od.Quantity ELSE 0 END) AS Mar,
    SUM(CASE WHEN MONTH(o.OrderDate)=4 THEN od.Quantity ELSE 0 END) AS Apr FROM Orders o JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID GROUP BY p.ProductName;

-- Exercise-4(3)
SELECT ProductName,'Jan' AS MonthName,Jan AS Quantity FROM PivotSales UNION ALL SELECT ProductName,'Feb',Feb FROM PivotSales UNION ALL
SELECT ProductName,'Mar',Mar FROM PivotSales UNION ALL SELECT ProductName,'Apr',Apr FROM PivotSales;

-- Exercise-5
WITH CustomerOrderCounts AS(SELECT CustomerID,COUNT(OrderID) AS OrderCount FROM Orders GROUP BY CustomerID) SELECT c.CustomerID,
    c.Name,coc.OrderCount FROM CustomerOrderCounts coc JOIN Customers c ON coc.CustomerID = c.CustomerID WHERE coc.OrderCount > 3;

