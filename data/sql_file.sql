CREATE DATABASE InventoryDB;
USE InventoryDB;
CREATE TABLE Supplier_Master (
    Supplier_ID VARCHAR(10) PRIMARY KEY,
    Supplier_Name VARCHAR(100),
    City VARCHAR(50)
);
CREATE TABLE SKU_Master (
    SKU_ID VARCHAR(10) PRIMARY KEY,
    SKU_Name VARCHAR(100),
    Category VARCHAR(50),
    Unit_Cost DECIMAL(10,2),
    Selling_Price DECIMAL(10,2),
    Reorder_Level INT,
    Supplier_ID VARCHAR(10),
    FOREIGN KEY (Supplier_ID) REFERENCES Supplier_Master(Supplier_ID)
);
CREATE TABLE Inventory_Transactions (
    Transaction_ID INT AUTO_INCREMENT PRIMARY KEY,
    Date DATE,
    SKU_ID VARCHAR(10),
    Transaction_Type VARCHAR(50),
    Quantity INT,
    Warehouse VARCHAR(20),
    FOREIGN KEY (SKU_ID) REFERENCES SKU_Master(SKU_ID)
);
CREATE TABLE External_Stock (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Date DATE,
    SKU_ID VARCHAR(10),
    Quantity INT,
    Source_System VARCHAR(50)
);
TRUNCATE TABLE Inventory_Transactions;
ALTER TABLE Inventory_Transactions 
DROP COLUMN Transaction_ID;
ALTER TABLE Inventory_Transactions 
ADD Transaction_ID INT AUTO_INCREMENT PRIMARY KEY FIRST;
DROP TABLE Inventory_Transactions;
CREATE TABLE Inventory_Transactions (
    Transaction_ID INT AUTO_INCREMENT PRIMARY KEY,
    Date DATE,
    SKU_ID VARCHAR(10),
    Transaction_Type VARCHAR(50),
    Quantity INT,
    Warehouse VARCHAR(20),
    FOREIGN KEY (SKU_ID) REFERENCES SKU_Master(SKU_ID)
);
SELECT * FROM SKU_Master LIMIT 10;
SELECT * FROM Inventory_Transactions LIMIT 10;
SELECT 
    SKU_ID,
    SUM(Quantity) AS Current_Stock
FROM Inventory_Transactions
GROUP BY SKU_ID;
SELECT 
    s.SKU_ID,
    s.SKU_Name,
    SUM(t.Quantity) AS Current_Stock,
    SUM(t.Quantity) * s.Unit_Cost AS Inventory_Value
FROM Inventory_Transactions t
JOIN SKU_Master s ON t.SKU_ID = s.SKU_ID
GROUP BY s.SKU_ID, s.SKU_Name, s.Unit_Cost;
SELECT COUNT(*) FROM external_stock;
ALTER TABLE Inventory_Transactions
ADD COLUMN Source_System VARCHAR(50);
UPDATE Inventory_Transactions
SET Source_System =
CASE
    WHEN RAND() < 0.33 THEN 'SAP'
    WHEN RAND() < 0.66 THEN 'Oracle'
    ELSE 'Tally'
END;
SELECT DISTINCT Source_System FROM Inventory_Transactions;
