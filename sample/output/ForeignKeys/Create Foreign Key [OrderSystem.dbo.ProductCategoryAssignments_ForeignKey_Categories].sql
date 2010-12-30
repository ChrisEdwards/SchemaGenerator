-----------------------------------------------------------------------------------------
USE OrderSystem
GO
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- Create Foreign Key: ProductCategoryAssignments => Categories
-----------------------------------------------------------------------------------------
IF OBJECT_ID('ProductCategoryAssignments_ForeignKey_Categories') IS NOT NULL
   BEGIN
      RAISERROR('Dropping foreign key: ProductCategoryAssignments_ForeignKey_Categories...',0,0) WITH NOWAIT;
      ALTER TABLE OrderSystem.dbo.ProductCategoryAssignments
         DROP CONSTRAINT ProductCategoryAssignments_ForeignKey_Categories;
   END
GO
-----------------------------------------------------------------------------------------
RAISERROR('Creating foreign key: ProductCategoryAssignments_ForeignKey_Categories...',0,0) WITH NOWAIT;
ALTER TABLE OrderSystem.dbo.ProductCategoryAssignments
   ADD CONSTRAINT ProductCategoryAssignments_ForeignKey_Categories  FOREIGN KEY (CategoryId) 
       REFERENCES OrderSystem.dbo.Categories (CategoryId);
GO
-----------------------------------------------------------------------------------------	
