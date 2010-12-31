---------------------------------------------------------------------------------------
USE OrderSystem;
GO
---------------------------------------------------------------------------------------
IF OBJECT_ID('OrderSystem.dbo.ProductCategoryAssignments') IS NOT NULL
   BEGIN
      RAISERROR('Dropping table: OrderSystem.dbo.ProductCategoryAssignments...',0,0) WITH NOWAIT;
      DROP TABLE OrderSystem.dbo.ProductCategoryAssignments;
   END
GO
---------------------------------------------------------------------------------------
RAISERROR('Creating table: OrderSystem.dbo.ProductCategoryAssignments...',0,0) WITH NOWAIT;
GO
---------------------------------------------------------------------------------------
CREATE TABLE OrderSystem.dbo.ProductCategoryAssignments
(
 ProductCategoryAssignmentId                        INT             IDENTITY(1,1)   -- The primary key of this table.
,ProductId                                          INT             NOT NULL        -- The product assigned to the specified category This is a foreign key that references Products.ProductId. 
,CategoryId                                         INT             NOT NULL        -- The category this product is assigned to. This is a foreign key that references Categories.CategoryId. 

 -- Audit Columns
,TimeInserted                                       DATETIME        NOT NULL
      CONSTRAINT ProductCategoryAssignments_Default_TimeInserted
      DEFAULT    (GETDATE())
,TimeUpdated                                        DATETIME        NOT NULL
      CONSTRAINT ProductCategoryAssignments_Default_TimeUpdated
      DEFAULT    (GETDATE())

 -- Constraints
,CONSTRAINT ProductCategoryAssignments_PrimaryKey_ProductCategoryAssignmentId
      PRIMARY KEY CLUSTERED (ProductCategoryAssignmentId ASC)

,CONSTRAINT ProductCategoryAssignments_UniqueKey_CategoryIdProductId
      UNIQUE NONCLUSTERED   (CategoryId ASC, ProductId ASC)
)
GO
---------------------------------------------------------------------------------------
--GRANT INSERT, UPDATE, DELETE, SELECT ON OrderSystem.dbo.ProductCategoryAssignments TO Public;
--GO
---------------------------------------------------------------------------------------
EXECUTE sys.sp_AddExtendedProperty
        @name=N'MS_Description'
       ,@value=N'The category to product associations.'
       ,@level0type=N'SCHEMA'
       ,@level0name=N'dbo'
       ,@level1type=N'TABLE'
       ,@level1name=N'ProductCategoryAssignments'
GO
---------------------------------------------------------------------------------------
EXECUTE sys.sp_AddExtendedProperty
        @name=N'MS_Description'
       ,@value=N'The primary key of this table.'
       ,@level0type=N'SCHEMA'
       ,@level0name=N'dbo'
       ,@level1type=N'TABLE'
       ,@level1name=N'ProductCategoryAssignments'
       ,@level2type=N'COLUMN'
       ,@level2name=N'ProductCategoryAssignmentId'
GO
---------------------------------------------------------------------------------------
EXECUTE sys.sp_AddExtendedProperty
        @name=N'MS_Description'
       ,@value=N'The product assigned to the specified category This is a foreign key that references Products.ProductId. '
       ,@level0type=N'SCHEMA'
       ,@level0name=N'dbo'
       ,@level1type=N'TABLE'
       ,@level1name=N'ProductCategoryAssignments'
       ,@level2type=N'COLUMN'
       ,@level2name=N'ProductId'
GO
---------------------------------------------------------------------------------------
EXECUTE sys.sp_AddExtendedProperty
        @name=N'MS_Description'
       ,@value=N'The category this product is assigned to. This is a foreign key that references Categories.CategoryId. '
       ,@level0type=N'SCHEMA'
       ,@level0name=N'dbo'
       ,@level1type=N'TABLE'
       ,@level1name=N'ProductCategoryAssignments'
       ,@level2type=N'COLUMN'
       ,@level2name=N'CategoryId'
GO
---------------------------------------------------------------------------------------
GO
