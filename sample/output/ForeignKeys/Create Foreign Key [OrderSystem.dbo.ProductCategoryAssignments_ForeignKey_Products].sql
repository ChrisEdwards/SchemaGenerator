-----------------------------------------------------------------------------------------
USE HomeOfficeBilling
GO
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- Create Foreign Key: ProductCategoryAssignments => Products
-----------------------------------------------------------------------------------------
IF OBJECT_ID('ProductCategoryAssignments_ForeignKey_Products') IS NOT NULL
   BEGIN
      RAISERROR('Dropping foreign key: ProductCategoryAssignments_ForeignKey_Products...',0,0) WITH NOWAIT;
      ALTER TABLE OrderSystem.dbo.ProductCategoryAssignments
         DROP CONSTRAINT ProductCategoryAssignments_ForeignKey_Products;
   END
GO
-----------------------------------------------------------------------------------------
RAISERROR('Creating foreign key: ProductCategoryAssignments_ForeignKey_Products...',0,0) WITH NOWAIT;
ALTER TABLE OrderSystem.dbo.ProductCategoryAssignments
   ADD CONSTRAINT ProductCategoryAssignments_ForeignKey_Products  FOREIGN KEY (ProductId)
       REFERENCES OrderSystem.dbo.Products (ProductId);
GO
-----------------------------------------------------------------------------------------
