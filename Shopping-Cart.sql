--Create tables

-- Products Menu Table
CREATE TABLE ProductsMenu (
    id bigserial PRIMARY KEY,
    "name" VARCHAR(50),
    price DECIMAL(10, 2)
);

-- Users Table
CREATE TABLE Users (
    id bigserial PRIMARY KEY,
    name VARCHAR(50)
);

-- Cart Table
CREATE TABLE Cart (
    Product bigserial,
    Qty integer
);

-- OrderHeader Table
CREATE TABLE OrderHeader (
    OrderID bigserial PRIMARY KEY,
    "User" integer,
    Orderdate TIMESTAMP
);

-- OrderDetails Table
CREATE TABLE OrderDetails (
    OrderHeader bigserial,
    ProdID integer,
    Qty integer
);


SELECT * FROM ProductsMenu
SELECT * FROM Users
SELECT * FROM Cart
SELECT * FROM OrderHeader
SELECT * FROM OrderDetails

--Adding Products to the Cart

-- Add Coke to the Cart
INSERT INTO Cart (Product, Qty) VALUES (1, 1);

-- Add Chips to the Cart
INSERT INTO Cart (Product, Qty) VALUES (2, 1);

-- Add another Coke (update quantity)
IF EXISTS (SELECT * FROM Cart WHERE Product = 1)
THEN
    UPDATE Cart SET Qty = Qty + 1 WHERE Product = 1;
ELSE
    INSERT INTO Cart (Product, Qty) VALUES (1, 1);
END IF;


--Deleting Products from the Cart:

-- Delete Chips from the Cart
DELETE FROM Cart WHERE Product = 2;


--Checking Out (Creating Multiple Orders):
-- Checkout (Create Order)
INSERT INTO OrderHeader (OrderID, User, Orderdate)
VALUES (1, 1, '2023-04-15 15:30:00');

-- Copy Cart to OrderDetails
INSERT INTO OrderDetails (OrderHeader, ProdID, Qty)
SELECT 1, Product, Qty FROM Cart;

-- Clear Cart after Checkout
DELETE FROM Cart;


--Printing Orders

-- Print a Single Order
SELECT O.OrderID, U.name AS UserName, O.Orderdate, PM.name AS ProductName, OD.Qty
FROM OrderHeader AS O
INNER JOIN Users AS U ON O.User = U.id
INNER JOIN OrderDetails AS OD ON O.OrderID = OD.OrderHeader
INNER JOIN ProductsMenu AS PM ON OD.ProdID = PM.id
WHERE O.OrderID = 1;


-- Print All Orders for a Day's Shopping
SELECT O.OrderID, U.name AS UserName, O.Orderdate, PM.name AS ProductName, OD.Qty
FROM OrderHeader AS O
INNER JOIN Users AS U ON O.User = U.id
INNER JOIN OrderDetails AS OD ON O.OrderID = OD.OrderHeader
INNER JOIN ProductsMenu AS PM ON OD.ProdID = PM.id
WHERE DATE(O.Orderdate) = '2023-04-15';
