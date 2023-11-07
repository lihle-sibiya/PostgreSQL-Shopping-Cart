--Create tables

-- Products Menu Table
CREATE TABLE ProductsMenu (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    price DECIMAL(10, 2)
);

-- Users Table
CREATE TABLE Users (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

-- Cart Table
CREATE TABLE Cart (
    Product INT,
    Qty INT
);

-- OrderHeader Table
CREATE TABLE OrderHeader (
    OrderID INT PRIMARY KEY,
    User INT,
    Orderdate TIMESTAMP
);

-- OrderDetails Table
CREATE TABLE OrderDetails (
    OrderHeader INT,
    ProdID INT,
    Qty INT
);
