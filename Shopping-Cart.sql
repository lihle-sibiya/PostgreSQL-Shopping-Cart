--1. Create tables

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

--3) Add an item to the cart:

-- Inserting products into ProductsMenu
INSERT INTO ProductsMenu ("name", price) VALUES ('Coke', 10);
INSERT INTO ProductsMenu ("name", price) VALUES ('Chips', 5);

--test it
SELECT * FROM ProductsMenu

-- Inserting users into Users
INSERT INTO Users (name) VALUES ('Arnold');
INSERT INTO Users (name) VALUES ('Sheryl');

SELECT * FROM Users

-- Adding Products to the Cart using INSERT INTO

-- Add Coke to the Cart
INSERT INTO Cart (Product, Qty) VALUES (1, 2);

--test it
SELECT * FROM Cart

-- Add a Coke (if product exists, update qty by 1; otherwise, insert with qty 1)
DO $$ 
BEGIN
      IF EXISTS (SELECT * FROM Cart WHERE Product = 1) THEN
        UPDATE Cart SET Qty = Qty + 1 WHERE Product = 1;
    ELSE
        INSERT INTO Cart (Product, Qty) VALUES (1, 1);
    END IF;
END $$;

-- Add Chips to the Cart
INSERT INTO Cart (Product, Qty) VALUES (2, 1);

-- Add another Chips (update quantity)
DO $$ 
BEGIN
    -- Add another Chips (if product exists, update qty by 1; otherwise, insert with qty 1)
    IF EXISTS (SELECT * FROM Cart WHERE Product = 2) THEN
        UPDATE Cart SET Qty = Qty + 1 WHERE Product = 2;
    ELSE
        INSERT INTO Cart (Product, Qty) VALUES (2, 1);
    END IF;
END $$;

-- 4) Remove an item from the cart:

-- If the quantity is more than one - subtract one from it
-- Subtract Coke
UPDATE Cart SET Qty = Qty - 1 WHERE Product = 1 AND Qty > 1;

--test it
SELECT * FROM Cart

-- Remove the whole item if the quantity is 1
--Remove coke
DELETE FROM Cart WHERE Product = 1 AND Qty = 1;

--test it
SELECT * FROM Cart

-- 5) Checkout to place the order
-- A - insert into the order header table (userid (1 or a 2) , dae and time)
INSERT INTO OrderHeader ("User", orderdate)
VALUES (1, '2023-04-15 15:30:00');

-- Copy Cart to OrderDetails
--B - user the above order ID to insert the cart contents into the order details table
INSERT INTO OrderDetails (OrderHeader, ProdID, Qty)
SELECT 1, Product, Qty FROM Cart;

-- Clear Cart after checkout
DELETE FROM Cart;

-- Test it
SELECT * FROM OrderHeader;
SELECT * FROM OrderDetails;

--test it
SELECT * FROM Cart

--4) Remove an item from the cart:

-- Subtract one from the quantity if it's more than 1
UPDATE Cart SET Qty = Qty - 1 WHERE Product = 1 AND Qty > 1;

-- Remove the whole item if the quantity is 1
DELETE FROM Cart WHERE Product = 1 AND Qty = 1;

--test it
SELECT * FROM Cart;

--5) Checkout to place the order
-- A - insert into the order header table (userid (1 or a 2) , date and time
INSERT INTO OrderHeader ("User", orderdate)
VALUES (1, '2023-04-15 15:30:00');

--test it
SELECT * FROM OrderHeader

--Again another user
INSERT INTO OrderHeader ("User", orderdate)
VALUES (2, '2023-04-15 16:00:00');

--test it
SELECT * FROM OrderHeader

--B - user the above order ID to insert the cart contents into the order details table
-- Copy Cart to OrderDetails
INSERT INTO OrderDetails (OrderHeader, ProdID, Qty)
SELECT currval(pg_get_serial_sequence('orderheader', 'orderid')), Product, Qty FROM Cart;

--test it
SELECT * FROM OrderDetails



-- B...delete the cart contents
DELETE FROM Cart;


--Test it
SELECT * FROM OrderHeader;
SELECT * FROM OrderDetails;

--Printing Orders

-- Printing a single order (SELECT STATEMENT)
SELECT O.orderid, U.name AS UserName, O.orderdate, PM.name AS ProductName, OD.Qty
FROM OrderHeader AS O
INNER JOIN Users AS U ON O."User" = U.id
INNER JOIN OrderDetails AS OD ON O.orderid = OD.orderHeader
INNER JOIN ProductsMenu AS PM ON OD.prodid = PM.id
WHERE O.Orderid = 1;

SELECT * FROM ProductsMenu
SELECT * FROM Users
SELECT * FROM Cart
SELECT * FROM OrderHeader
SELECT * FROM OrderDetails

-- Printing all orders for a days shopping (SELECT STATEMENT)
SELECT O.OrderID, U.name AS UserName, O.Orderdate, PM.name AS ProductName, OD.Qty
FROM OrderHeader AS O
INNER JOIN Users AS U ON O."User" = U.id
INNER JOIN OrderDetails AS OD ON O.OrderID = OD.OrderHeader
INNER JOIN ProductsMenu AS PM ON OD.ProdID = PM.id
WHERE DATE(O.Orderdate) = '2023-04-15';

--Bonus
--Function: Add an item
CREATE OR REPLACE FUNCTION add_item(product_id INTEGER, quantity INTEGER)
RETURNS VOID AS $$
BEGIN
    -- Check if the product is already in the cart
    IF EXISTS (SELECT 1 FROM Cart WHERE Product = product_id) THEN
        -- Update the quantity if the product is already in the cart
        UPDATE Cart SET Qty = Qty + quantity WHERE Product = product_id;
    ELSE
        -- Insert the product into the cart if it doesn't exist
        INSERT INTO Cart (Product, Qty) VALUES (product_id, quantity);
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Test it: Add 2 units of product with ID 1 (coke) to the cart
SELECT add_item(1, 3);

--Test Table
SELECT * FROM Cart;

--Bonus
--Function: remove an item