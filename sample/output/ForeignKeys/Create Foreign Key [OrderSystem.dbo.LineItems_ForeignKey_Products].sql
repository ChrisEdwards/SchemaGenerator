-----------------------------------------------------------------------------------------
USE OrderSystem
GO
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- Create Foreign Key: LineItems => Products
-----------------------------------------------------------------------------------------
IF OBJECT_ID('LineItems_ForeignKey_Products') IS NOT NULL
   BEGIN
      RAISERROR('Dropping foreign key: LineItems_ForeignKey_Products...',0,0) WITH NOWAIT;
      ALTER TABLE OrderSystem.dbo.LineItems
         DROP CONSTRAINT LineItems_ForeignKey_Products;
   END
GO
-----------------------------------------------------------------------------------------
RAISERROR('Creating foreign key: LineItems_ForeignKey_Products...',0,0) WITH NOWAIT;
ALTER TABLE OrderSystem.dbo.LineItems
   ADD CONSTRAINT LineItems_ForeignKey_Products  FOREIGN KEY (ProductId) 
       REFERENCES OrderSystem.dbo.Products (ProductId);
GO
-----------------------------------------------------------------------------------------	
