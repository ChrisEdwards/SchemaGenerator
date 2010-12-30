-----------------------------------------------------------------------------------------
USE HomeOfficeBilling
GO
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- Create Foreign Key: Orders => Customers
-----------------------------------------------------------------------------------------
IF OBJECT_ID('Orders_ForeignKey_Customers') IS NOT NULL
   BEGIN
      RAISERROR('Dropping foreign key: Orders_ForeignKey_Customers...',0,0) WITH NOWAIT;
      ALTER TABLE OrderSystem.dbo.Orders
         DROP CONSTRAINT Orders_ForeignKey_Customers;
   END
GO
-----------------------------------------------------------------------------------------
RAISERROR('Creating foreign key: Orders_ForeignKey_Customers...',0,0) WITH NOWAIT;
ALTER TABLE OrderSystem.dbo.Orders
   ADD CONSTRAINT Orders_ForeignKey_Customers  FOREIGN KEY (CustomerId)
       REFERENCES OrderSystem.dbo.Customers (CustomerId);
GO
-----------------------------------------------------------------------------------------
