-- QUESTION 1
-- Step 1 : Original table
CREATE TABLE ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(100),
    Products VARCHAR(200)
);

INSERT INTO ProductDetail VALUES 
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');

-- Step 2 : Solution
CREATE TEMPORARY TABLE numbers (
    n INT
);

INSERT INTO numbers VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10);

SELECT 
    p.OrderID,
    p.CustomerName,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(p.Products, ',', n.n), ',', -1)) AS Product
FROM ProductDetail AS p
JOIN numbers AS n 
    ON n.n <= (LENGTH(p.Products) - LENGTH(REPLACE(p.Products, ',', '')) + 1)
ORDER BY p.OrderID, Product;

-- Step 3 : 1NF Table
CREATE TABLE OrderProducts_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100)
);

INSERT INTO OrderProducts_1NF 
SELECT 
    p.OrderID,
    p.CustomerName,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(p.Products, ',', n.n), ',', -1)) AS Product
FROM ProductDetail AS p
JOIN numbers AS n 
    ON n.n <= (LENGTH(p.Products) - LENGTH(REPLACE(p.Products, ',', '')) + 1);
    

-- QUESTION 2
-- Step 1 : 1NF Table
CREATE TABLE OrderDetails_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT
);

INSERT INTO OrderDetails_1NF VALUES 
(101, 'John Doe', 'Laptop', 2),
(101, 'John Doe', 'Mouse', 1),
(102, 'Jane Smith', 'Tablet', 3),
(102, 'Jane Smith', 'Keyboard', 1),
(102, 'Jane Smith', 'Mouse', 2),
(103, 'Emily Clark', 'Phone', 1);

-- Step 2 : 2NF Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    OrderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE
);    

-- Step 3 
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName 
FROM OrderDetails_1NF;

INSERT INTO OrderItems (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails_1NF;