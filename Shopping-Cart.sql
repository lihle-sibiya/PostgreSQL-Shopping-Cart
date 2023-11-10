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
    Product bigserial REFERENCES ProductsMenu(id),
    Qty integer
);

-- OrderHeader Table
CREATE TABLE OrderHeader (
    OrderID bigserial PRIMARY KEY,
    "User" integer REFERENCES Users(id),
    Orderdate TIMESTAMP
);

-- OrderDetails Table
CREATE TABLE OrderDetails (
    OrderHeader bigserial REFERENCES OrderHeader(OrderID),
    ProdID integer REFERENCES ProductsMenu(id),
    Qty integer
);


SELECT * FROM ProductsMenu
SELECT * FROM Users
SELECT * FROM Cart
SELECT * FROM OrderHeader
SELECT * FROM OrderDetails

-- Inserting products into ProductsMenu
INSERT INTO ProductsMenu ("name", price) VALUES ('Coke', 10);
INSERT INTO ProductsMenu ("name", price) VALUES ('Chips', 5);

--test it
SELECT * FROM ProductsMenu

-- Inserting users into Users
INSERT INTO Users (name) VALUES ('Arnold');
INSERT INTO Users (name) VALUES ('Sheryl');

SELECT * FROM Users

--Adding Products to the Cart usign INSERT INTO

-- Adding Products to the Cart using INSERT INTO

-- Add Coke to the Cart
INSERT INTO Cart (Product, Qty) VALUES (1, 2);

-- Add a Coke (if product exists, update qty by 1)
DO $$ 
BEGIN
    -- Add a Coke (if product exists, update qty by 1; otherwise, insert with qty 1)
    IF EXISTS (SELECT * FROM Cart WHERE Product = 1) THEN
        UPDATE Cart SET Qty = Qty + 1 WHERE Product = 1;
    ELSE
        INSERT INTO Cart (Product, Qty) VALUES (1, 1);
    END IF;
END $$;

-- Add Chips to the Cart
INSERT INTO Cart (Product, Qty) VALUES (2, 1);

-- Add another Coke (update quantity)
DO $$ 
BEGIN
    -- Add another Coke (if product exists, update qty by 1; otherwise, insert with qty 1)
    IF EXISTS (SELECT * FROM Cart WHERE Product = 1) THEN
        UPDATE Cart SET Qty = Qty + 1 WHERE Product = 1;
    ELSE
        INSERT INTO Cart (Product, Qty) VALUES (1, 1);
    END IF;
END $$;

-- Deleting Products from the Cart:

-- Subtract one from the quantity if it's more than 1
UPDATE Cart SET Qty = Qty - 1 WHERE Product = 1 AND Qty > 1;

-- Remove the whole item if the quantity is 1
DELETE FROM Cart WHERE Product = 1 AND Qty = 1;

-- Checking Out (Creating Multiple Orders):
-- Checkout (Create Order)
INSERT INTO OrderHeader ("User", orderdate)
VALUES (1, '2023-04-15 15:30:00');

-- Copy Cart to OrderDetails
INSERT INTO OrderDetails (OrderHeader, ProdID, Qty)
SELECT 1, Product, Qty FROM Cart;

-- Clear Cart after checkout
DELETE FROM Cart;

-- Test it
SELECT * FROM OrderHeader;
SELECT * FROM OrderDetails;

--test it
SELECT * FROM Cart

--Deleting Products from the Cart:

-- Subtract one from the quantity if it's more than 1
UPDATE Cart SET Qty = Qty - 1 WHERE Product = 1 AND Qty > 1;

-- Remove the whole item if the quantity is 1
DELETE FROM Cart WHERE Product = 1 AND Qty = 1;

--test it
SELECT * FROM Cart;

--Checking Out (Creating Multiple Orders):
-- Checkout (Create Order)
INSERT INTO OrderHeader ("User", orderdate)
VALUES (1, '2023-04-15 15:30:00');

--test it
SELECT * FROM OrderHeader

-- Copy Cart to OrderDetails
INSERT INTO OrderDetails (OrderHeader, ProdID, Qty)
SELECT 1, Product, Qty FROM Cart;

--test it
SELECT * FROM OrderDetails

-- Clear Cart after checkout
DELETE FROM Cart;


--Test it
SELECT * FROM OrderHeader;
SELECT * FROM OrderDetails;

--Printing Orders

-- Print a Single Order
SELECT O.orderid, U.name AS UserName, O.orderdate, PM.name AS ProductName, OD.Qty
FROM OrderHeader AS O
JOIN Users AS U ON O."User" = U.id
JOIN OrderDetails AS OD ON O.orderid = OD.orderHeader
JOIN ProductsMenu AS PM ON OD.prodid = PM.id
WHERE O.Orderid = 1;

SELECT * FROM ProductsMenu
SELECT * FROM Users
SELECT * FROM Cart
SELECT * FROM OrderHeader
SELECT * FROM OrderDetails

-- Print All Orders for a Day's Shopping
SELECT O.OrderID, U.name AS UserName, O.Orderdate, PM.name AS ProductName, OD.Qty
FROM OrderHeader AS O
INNER JOIN Users AS U ON O."User" = U.id
INNER JOIN OrderDetails AS OD ON O.OrderID = OD.OrderHeader
INNER JOIN ProductsMenu AS PM ON OD.ProdID = PM.id
WHERE DATE(O.Orderdate) = '2023-04-15';
