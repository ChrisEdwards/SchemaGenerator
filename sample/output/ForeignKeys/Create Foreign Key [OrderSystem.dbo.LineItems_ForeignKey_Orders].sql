-----------------------------------------------------------------------------------------
USE HomeOfficeBilling
GO
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- Create Foreign Key: LineItems => Orders
-----------------------------------------------------------------------------------------
IF OBJECT_ID('LineItems_ForeignKey_Orders') IS NOT NULL
   BEGIN
      RAISERROR('Dropping foreign key: LineItems_ForeignKey_Orders...',0,0) WITH NOWAIT;
      ALTER TABLE OrderSystem.dbo.LineItems
         DROP CONSTRAINT LineItems_ForeignKey_Orders;
   END
GO
-----------------------------------------------------------------------------------------
RAISERROR('Creating foreign key: LineItems_ForeignKey_Orders...',0,0) WITH NOWAIT;
ALTER TABLE OrderSystem.dbo.LineItems
   ADD CONSTRAINT LineItems_ForeignKey_Orders  FOREIGN KEY (OrderId)
       REFERENCES OrderSystem.dbo.Orders (OrderId);
GO
-----------------------------------------------------------------------------------------
