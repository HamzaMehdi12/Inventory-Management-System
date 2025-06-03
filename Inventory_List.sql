-- This is the Inventory Management System
-- We have the following tables for the database

-- The product list, contains all th products on display that can be boght
-- There is no order here
-- Bulk ID is the foreign ID that would be defined in the Inventory Item table

CREATE TABLE Product_List(
    item_ID INT PRIMARY KEY UNIQUE,
    Descr VARCHAR(20),
    Item_price INT,
    Expiry_Date DATE,
    BULK_ID INT,
    Trans_ID INT 
);


CREATE TABLE Transactions(
    trans_ID INT PRIMARY KEY,
    Item_ID INT,
    Item_Price INT
);  
ALTER TABLE Transactions
    ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
ALTER TABLE Transactions
    ADD UNIQUE (created_at)

ALTER TABLE Transactions
    ADD FOREIGN KEY(Item_ID) REFERENCES Product_List(Item_ID);


ALTER TABLE Transactions
    DROP FOREIGN KEY transactions_ibfk_1; 

ALTER TABLE Transactions
    MODIFY COLUMN Item_ID INT NULL;

ALTER TABLE Transactions
ADD CONSTRAINT transactions_ibfk_1
FOREIGN KEY(Item_ID) REFERENCES Product_List(Item_ID)
ON DELETE SET NULL;

CREATE TABLE Inventory_Items(
    BULK_ID INT PRIMARY KEY,
    Item_ID INT,
    Descr VARCHAR(20),
    Item_price INT,
    Quantity INT,
    Supplier_ID INT,
    Restock VARCHAR(2)
);

ALTER TABLE Product_List
    ADD FOREIGN KEY(BULK_ID) REFERENCES Inventory_Items(BULK_ID);


CREATE TABLE Suppliers(
    Supplier_ID INT PRIMARY KEY,
    BULK_ID INT,
    Descr VARCHAR(20),
    Quantity INT 
);

ALTER TABLE Inventory_Items
    ADD FOREIGN KEY(Supplier_ID) REFERENCES Suppliers(Supplier_ID);

CREATE TABLE Orders(
    Item_ID INT PRIMARY KEY,
    Order_ID INT,
    trans_ID INT,
    Order_date DATE,
    Status_ID INT
);

ALTER TABLE Orders
    ADD COLUMN created_at TIMESTAMP UNIQUE DEFAULT CURRENT_TIMESTAMP

ALTER TABLE Orders
    ADD FOREIGN KEY(Item_ID) REFERENCES Product_List(Item_ID);

ALTER TABLE Orders
    ADD UNIQUE(Order_ID);

CREATE TABLE Order_Status(
    Order_ID INT PRIMARY KEY,
    trans_ID INT,
    Order_Date DATE,
    Dispatch_ID INT,
    Status VARCHAR(10)
);

ALTER TABLE Order_Status
    ADD FOREIGN KEY(Order_ID) REFERENCES Orders(Order_ID);

DESC Suppliers;
SELECT * FROM Suppliers;

INSERT INTO Suppliers(Supplier_ID, BULK_ID, Descr, Quantity)
VALUES
    (10001001, 11002010, 'Cat Food', 30),
    (10001002, 11002040, 'Dog Food', 50),
    (10001003, 11002090, 'Bird Seed', 20),
    (10001004, 11002110, 'Fish Flakes', 15),
    (10001005, 11002125, 'Hamster Pellets', 25),
    (10001006, 11002150, 'Rabbit Mix', 35),
    (10001007, 11002185, 'Turtle Sticks', 10),
    (20001008, 11002225, 'Flea Shampoo', 40),
    (200001009, 11002285, 'Pet Treats', 60),
    (20001010, 11002330, 'Cat Litter', 45),
    (20001011, 1100348, 'Dog Leash', 18),
    (20001012, 11002366, 'Bird Cage', 8),
    (20001013, 11002374, 'Fish Tank', 12),
    (20001014, 11002386, 'Hamster Wheel', 6),
    (20001015, 11002392, 'Rabbit Hutch', 4),
    (20001016, 11002396, 'Pet Carrier', 14);

DESC Inventory_Items;

INSERT INTO Inventory_Items(Supplier_ID, BULK_ID, Descr, Quantity)
SELECT Supplier_ID, BULK_ID, Descr, Quantity
FROM Suppliers
WHERE Suppliers.Supplier_ID = 20001012;


UPDATE Inventory_Items
SET
    Item_ID = CASE
        WHEN BULK_ID = 11002010 THEN 60102594
        ELSE Item_ID
    END,
    Item_price = CASE
        WHEN Item_ID = 60102594 THEN 1
        ELSE Item_price
    END,
    Restock = CASE
        WHEN BULK_ID = 11002010 AND Quantity > 0 THEN 'N'
        ELSE Restock
    END;

UPDATE Inventory_Items
SET
    Item_ID = CASE
        WHEN BULK_ID = 11002040 THEN 60105871
        ELSE Item_ID
    END,
    Item_price = CASE
        WHEN Item_ID = 60105871 THEN 5
        ELSE Item_price
    END,
    Restock = CASE
        WHEN BULK_ID = 11002040 AND Quantity > 0 THEN 'N'
        ELSE Restock
    END;
UPDATE Inventory_Items
SET
    Item_ID = CASE
        WHEN BULK_ID = 11002125 THEN 60107894
        ELSE Item_ID
    END,
    Item_price = CASE
        WHEN Item_ID = 60107894 THEN 4
        ELSE Item_price
    END,
    Restock = CASE
        WHEN BULK_ID = 60107894 AND Quantity > 0 THEN 'N'
        ELSE Restock
    END;

UPDATE Inventory_Items
SET
    Item_ID = CASE
        WHEN BULK_ID = 11002225 THEN 60103874
        ELSE Item_ID
    END,
    Item_price = CASE
        WHEN Item_ID = 60103874 THEN 10
        ELSE Item_price
    END,
    Restock = CASE
        WHEN BULK_ID = 11002225 AND Quantity > 0 THEN 'N'
        ELSE Restock
    END;

UPDATE Inventory_Items
SET
    Item_ID = CASE
        WHEN BULK_ID = 11002366 THEN 60105861
        ELSE Item_ID
    END,
    Item_price = CASE
        WHEN Item_ID = 60105861 THEN 30
        ELSE Item_price
    END,
    Restock = CASE
        WHEN BULK_ID = 11002366 AND Quantity > 0 THEN'N'
        ELSE Restock
    END;

SELECT * FROM Inventory_Items;
SELECT * FROM Product_List;



CREATE TABLE Inventory_Items_Lim(
    BULK_ID INT PRIMARY KEY,
    Item_ID INT,
    Descr VARCHAR(20),
    Item_price INT,
    Quantity INT,
    Supplier_ID INT,
    Restock VARCHAR(2)
);

INSERT INTO Inventory_Items_Lim SELECT * FROM Inventory_Items

SELECT * FROM Inventory_Items_Lim

WITH RECURSIVE item_gen AS (
    SELECT 
        BULK_ID,
        Item_ID,
        Descr,
        Item_price,
        Quantity,
        1 AS counter
    FROM Inventory_Items_Lim

    UNION ALL

    SELECT
        BULK_ID,
        Item_ID + 1,
        Descr,
        Item_price,
        Quantity,
        counter + 1
    FROM item_gen
    WHERE counter + 1 <= Quantity
)
SELECT
    BULK_ID,
    Item_ID,
    Descr,
    Item_price
FROM item_gen
ORDER BY BULK_ID, Item_ID;

INSERT INTO Product_List (BULK_ID, Item_ID, Descr, Item_price)
SELECT
    BULK_ID,
    Item_ID,
    Descr,
    Item_price
FROM (
    WITH RECURSIVE item_gen AS (
        SELECT 
            BULK_ID,
            Item_ID,
            Descr,
            Item_price,
            Quantity,
            1 AS counter
        FROM Inventory_Items_Lim

        UNION ALL

        SELECT
            BULK_ID,
            Item_ID + 1,
            Descr,
            Item_price,
            Quantity,
            counter + 1
        FROM item_gen
        WHERE counter + 1 <= Quantity
    )
    SELECT
        BULK_ID,
        Item_ID,
        Descr,
        Item_price
    FROM item_gen
) AS generated_rows
ORDER BY BULK_ID, Item_ID;

UPDATE Product_List
SET
    Expiry_Date = CASE
        WHEN Item_ID BETWEEN 60102594 AND 60102623 THEN '2026-01-01'
        WHEN Item_ID BETWEEN 60103874 AND 60103913 THEN '2029-04-12'
        WHEN Item_ID BETWEEN 60105861 AND 60105868 THEN '2040-04-04'
        WHEN Item_ID BETWEEN 60105871 AND 60105921 THEN '2026-12-12'
        WHEN Item_ID BETWEEN 60107894 AND 60107919 THEN '2026-03-29'
    END
WHERE Item_ID BETWEEN 60102594 AND 60107919;
    
ALTER TABLE Orders
    DROP FOREIGN KEY orders_ibfk_1;
ALTER TABLE Orders
    DROP PRIMARY KEY;

ALTER TABLE Orders
    MODIFY COLUMN Order_ID INT NOT NULL;
ALTER TABLE Orders
    ADD UNIQUE(Order_ID);

ALTER TABLE Orders
    ADD PRIMARY KEY(Order_ID)

ALTER TABLE Orders
    DROP COLUMN Item_ID;
ALTER TABLE Orders
    DROP created_at;

ALTER TABLE Product_List
    DROP COLUMN Trans_ID;

DROP PROCEDURE IF EXISTS Make_Transaction;

CREATE PROCEDURE Make_Transaction(IN Items INT, IN Trans INT, IN O_ID INT, IN S_ID INT, IN D_ID INT, IN ST VARCHAR(20))
BEGIN
    DECLARE p_cat_id INT;

    START TRANSACTION;

    INSERT INTO Transactions(trans_ID, Item_ID, Item_Price)
    SELECT Trans, Item_ID, Item_price
    FROM Product_List
    WHERE Item_ID = Items;
    

    INSERT INTO Orders(Order_ID, Status_ID, trans_ID, Order_Date)
    SELECT O_ID, S_ID, trans_ID, created_at
    FROM Transactions
    WHERE Item_ID = Items;

    SELECT BULK_ID INTO p_cat_id FROM Product_List WHERE Item_ID = Items;



    UPDATE Inventory_Items
    SET Quantity = Quantity - 1,
        Item_ID = Item_ID + 1
    WHERE BULK_ID = p_cat_id;
    
    DELETE FROM Product_List WHERE Item_ID = Items;
    CALL Dispatch(O_ID, D_ID, ST);

    COMMIT;
END;

DROP PROCEDURE IF EXISTS Dispatch;

CREATE PROCEDURE Dispatch(IN ID INT,IN D_ID INT, IN ST VARCHAR(20))
BEGIN

    START TRANSACTION;

    INSERT INTO Order_Status(Dispatch_ID, Status, Order_ID, trans_ID, Order_Date)
    SELECT D_ID, ST, Order_ID, trans_ID, Order_Date
    FROM Orders
    WHERE Orders.Order_ID = ID;
    COMMIT;
END;

DROP PROCEDURE IF EXISTS Update_Inventory;

CREATE PROCEDURE Update_Inventory(IN Expr DATE)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE supp_id INT;
    DECLARE low_counts INT;


    DECLARE low_stock CURSOR FOR
        SELECT DISTINCT Supplier_ID
        FROM Inventory_Items
        WHERE Quantity < 5;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    START TRANSACTION;

    SELECT COUNT(*) INTO low_counts
    FROM Inventory_Items
    WHERE Quantity < 5;

    IF low_counts > 0 THEN
        SELECT 'There are items going to be finished soon! Need to order' AS Message;

        SELECT * 
        FROM Inventory_Items
        WHERE Quantity < 5;

        OPEN low_stock;
        read_loop: LOOP
            FETCH low_stock INTO supp_id;
            IF done THEN
                LEAVE read_loop;
            END IF;
            
            CALL Refil(supp_id, Expr);
        END LOOP;
        CLOSE low_stock;
    ELSE
        SELECT 'All inventory is fully complete and sufficient' AS Message;
    END IF;

    COMMIT;
END;

DROP PROCEDURE IF EXISTS Refil;

CREATE PROCEDURE Refil(IN ID INT, IN Expr DATE)
BEGIN
    START TRANSACTION;

    UPDATE Inventory_Items AS I
    JOIN Suppliers as S
        ON S.Supplier_ID = Supplier_ID
    SET I.Quantity = I.Quantity + S.Quantity
    WHERE I.Supplier_ID = ID;
    
    DROP TEMPORARY TABLE IF EXISTS temp_gen;

    
    TRUNCATE TABLE Inventory_Items_Lim;
    
    INSERT INTO Inventory_Items_Lim(BULK_ID, Item_ID, Descr, Item_price, Quantity, Supplier_ID) 
    SELECT BULK_ID, Item_ID, Descr, Item_price, Quantity, Supplier_ID 
    FROM Inventory_Items
    WHERE Supplier_ID = ID;

    CREATE TEMPORARY TABLE temp_gen(
        BULK_ID INT,
        Item_ID INT,
        Descr VARCHAR(255),
        Item_price INT 
    );

    WITH RECURSIVE item_gen AS (
        SELECT 
            BULK_ID,
            Item_ID,
            Descr,
            Item_price,
            Quantity,
            1 AS counter
        FROM Inventory_Items_Lim

        UNION ALL

        SELECT
            BULK_ID,
            Item_ID + 1 AS Item_ID,
            Descr,
            Item_price,
            Quantity,
            counter + 1 AS counter
        FROM item_gen
        WHERE counter + 1 <= Quantity
        )
        SELECT  BULK_ID, Item_ID, Descr, Item_price
        FROM item_gen;

    INSERT INTO Product_List(BULK_ID, Item_ID, Descr, Item_price)
    SELECT
        BULK_ID,
        Item_ID,
        Descr,
        Item_price
    FROM temp_gen
    ORDER BY BULK_ID, Item_ID;

    UPDATE Product_List PL
    JOIN Inventory_Items_Lim AS IL 
        ON PL.BULK_ID = IL.BULK_ID
    SET PL.Expiry_Date = Expr
    WHERE IL.Supplier_ID = ID;
    COMMIT;
END;

DROP PROCEDURE Update_Order_Status;

CREATE PROCEDURE Update_Order_Status(IN ID INT, IN ID_s INT, IN ST VARCHAR(20))
BEGIN
    START TRANSACTION;
    UPDATE Order_Status
    SET Status = ST,
        Dispatch_ID = ID_s
    WHERE Order_Status.Order_ID = ID;
    COMMIT;

END;


DROP PROCEDURE IF EXISTS Continue_;

CREATE PROCEDURE Continue_(IN flow VARCHAR(10))
BEGIN
    IF flow = 'yes' OR flow = 'Yes' THEN
        SELECT 'Starting adding Transaction';
    ELSEIF flow = 'no' OR flow = 'No' THEN
        SELECT 'No transaction' AS RESULT;
    ELSE 
        SELECT 'Invalid Input' AS RESULT;

    END IF;
END;



SET @user_yes = 'yes';
SET @user_no = 'no';

CALL Continue_(@user_yes);
CALL Make_Transaction(60102596, 60512200, 51000001, 51001001, 99999999, 'Pending');

SELECT * FROM Order_Status;
SELECT * FROM Orders;
SELECT * FROM Transactions;
SELECT * FROM Product_List;
SELECT * FROM Suppliers;
SELECT * FROM Inventory_Items;

CALL Continue_(@user_yes);
CALL Make_Transaction(60102595, 60512201, 51000002, 51001002, 99999999, 'Pending');


SELECT * FROM Order_Status;
SELECT * FROM Orders;
SELECT * FROM Transactions;
SELECT * FROM Product_List;
SELECT * FROM Suppliers;
SELECT * FROM Inventory_Items;

CALL Update_Inventory('2027-12-12');
CALL Update_Order_Status(51000001, 90000001, 'Dispatched');

DELETE FROM Order_Status
WHERE Order_ID = 51000001;


SELECT * FROM Order_Status;
SELECT * FROM Orders;
SELECT * FROM Transactions;
SELECT * FROM Product_List;
SELECT * FROM Suppliers;
SELECT * FROM Inventory_Items;

CALL Update_Order_Status(51000002, 90000002, 'Dispatched');

SELECT *
FROM inventory.Order_Status
LIMIT 100;  