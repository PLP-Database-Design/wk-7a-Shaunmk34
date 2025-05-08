-- We will create a new 1NF table structure
CREATE TABLE OrderProducts_1NF (
OrderID INT,
CustomerName VARCHAR(100),
Product VARCHAR(50)
);

-- Insert data in 1NF format
INSERT INTO OrderProducts_1NF (OrderID, CustomerName, Product)
VALUES
(101, 'John Doe', 'Laptop'),
(101, 'John Doe', 'Mouse'),
(102, 'Jane Smith', 'Tablet'),
(102, 'Jane Smith', 'Keyboard'),
(102, 'Jane Smith', 'Mouse'),
(103, 'Emily Clark', 'Phone');

Question 2

-- We will state by creating normalized tables.
CREATE TABLE Customers (
CustomerID INT IDENTITY(1,1) PRIMARY KEY,
CustomerName VARCHAR(100)
);

CREATE TABLE Orders (
OrderID INT PRIMARY KEY,
CustomerID INT,
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Products (
ProductID INT IDENTITY(1,1) PRIMARY KEY,
ProductName VARCHAR(50)
);

CREATE TABLE OrderItems (
OrderItemID INT IDENTITY(1,1) PRIMARY KEY,
OrderID INT,
ProductID INT,
Quantity INT,
FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Then we populate the tables
-- First insert unique customers
INSERT INTO Customers (CustomerName)
SELECT DISTINCT CustomerName FROM OrderDetails;

-- Then insert orders with customer references
INSERT INTO Orders (OrderID, CustomerID)
SELECT DISTINCT o.OrderID, c.CustomerID
FROM OrderDetails o
JOIN Customers c ON o.CustomerName = c.CustomerName;

-- Insert unique products
INSERT INTO Products (ProductName)
SELECT DISTINCT Product FROM OrderDetails;

-- And finally insert order items
INSERT INTO OrderItems (OrderID, ProductID, Quantity)
SELECT o.OrderID, p.ProductID, od.Quantity
FROM OrderDetails od
JOIN Orders o ON od.OrderID = o.OrderID
JOIN Products p ON od.Product = p.ProductName;