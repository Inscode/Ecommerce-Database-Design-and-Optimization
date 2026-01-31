USE ecommerce_db;

/* (1) DATA VERIFICATION */

/* PRODUCTS WHICH HAS NULL VALUES */
SELECT * FROM Products WHERE ProductName IS NULL OR PRICE IS NULL OR StockQuantity IS NULL;

/* USERS WHICH HAVE NULL VALUES */

SELECT * FROM Users WHERE Email IS NULL OR UserName IS NULL;

/* (2) VALIDATE DATA FORMATS */

SELECT * FROM Users WHERE Email NOT LIKE '%_@_%._%';

/* (3) STANDARDIZE DATA FORMATS */
-- Check all dates in the orders table are within a reasonable range
-- This query checks that the orderDate field contains realistic dates, ensuring no dates are in the distant past or in future

DESC Orders;
SELECT * FROM Orders WHERE OrderDate < '2000-01-01' OR OrderDate > CURDATE();

/* (4) CHECK FOR DUPLICATE ENTRIES */
-- Check for duplicate UserIDs in the users table
-- This query looks for any duplicate UserIDs, which should be unique for each user.alter

DESC Users;
SELECT UserID, COUNT(*) FROM Users GROUP BY UserID HAVING COUNT(*) > 1;

-- IF Duplicates are found we should remove them or merge them
-- Below is the example of deleting them

DELETE FROM Users WHERE UserID = '999';


/* (5) ENFORCING CONSTRAINTS */

-- Enusure unrealistic values 
-- Negative prices cannot exist

ALTER TABLE Products ADD CONSTRAINT chk_price CHECK ( Price >= 0);

-- Ensure emails follow a basic format

ALTER TABLE Users ADD CONSTRAINT chk_email CHECK ( email LIKE '%_@_%._%');

/* CASCADING DELETES */
-- If a user is deleted, ensure that their asscociated orders are also deleted to avoid orpahned records
-- This foreign key constraint ensures that related order to that user is deleted when the user is deleted

ALTER TABLE Orders ADD CONSTRAINT fk_check FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE;


/* USING TRANSACTION TO MAINTAIN INTEGRITY */

-- To process and order that affects both the orders and products tables
-- Transactions allow you to ensure that all parts of the multi step operation are completed successfully before making changes

START TRANSACTION;
-- Insert a new order
-- This steps adds a new order to the orders table

INSERT INTO Orders (OrderID, UserID, OrderDate, TotalAmount) VALUES (1008, 286, '2024-08-17', 99.99);

-- Update stock quantity
-- This step reduces the stock for the particular item
UPDATE Products SET StockQuantity = StockQuantity - 1 WHERE ProductID = 1677;

-- If everything is successful 
-- Commit finalizes the transaction, saving all changes made in the transaction

COMMIT;

-- If something goes wrong 
-- ROllback undoes all changes made in the transaction ensuring the database stays consistent

ROLLBACK;
