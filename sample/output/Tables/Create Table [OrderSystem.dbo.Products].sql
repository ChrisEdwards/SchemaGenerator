---------------------------------------------------------------------------------------
USE OrderSystem;
GO
---------------------------------------------------------------------------------------
IF OBJECT_ID('OrderSystem.dbo.Products') IS NOT NULL
   BEGIN
      RAISERROR('Dropping table: OrderSystem.dbo.Products...',0,0) WITH NOWAIT;
      DROP TABLE OrderSystem.dbo.Products;
   END
GO
---------------------------------------------------------------------------------------
RAISERROR('Creating table: OrderSystem.dbo.Products...',0,0) WITH NOWAIT;
GO
---------------------------------------------------------------------------------------
CREATE TABLE OrderSystem.dbo.Products
(
 ProductId                                          INT             IDENTITY(1,1)   -- The primary key of this table.
,Name                                               VARCHAR(50)     NOT NULL        -- The name of this product.
,Description                                        VARCHAR(500)        NULL        -- The optional extended description of this product.
,Price                                              MONEY           NOT NULL        -- The current price of this product.
	
 -- Audit Columns
,TimeInserted                                       DATETIME        NOT NULL
      CONSTRAINT Products_Default_TimeInserted  
      DEFAULT    (GETDATE())
,TimeUpdated                                        DATETIME        NOT NULL
      CONSTRAINT Products_Default_TimeUpdated
      DEFAULT    (GETDATE())
	
 -- Constraints
,CONSTRAINT Products_PrimaryKey_ProductId
      PRIMARY KEY CLUSTERED (ProductId ASC)

,CONSTRAINT Products_UniqueKey_Name 
      UNIQUE NONCLUSTERED   (Name ASC)
)
GO
---------------------------------------------------------------------------------------
--GRANT INSERT, UPDATE, DELETE, SELECT ON OrderSystem.dbo.Products TO Public;
--GO
---------------------------------------------------------------------------------------
EXECUTE sys.sp_AddExtendedProperty 
        @name=N'MS_Description'
       ,@value=N'Contains the products available for order.'
       ,@level0type=N'SCHEMA'
       ,@level0name=N'dbo'
       ,@level1type=N'TABLE'
       ,@level1name=N'Products'
GO
---------------------------------------------------------------------------------------
EXECUTE sys.sp_AddExtendedProperty 
        @name=N'MS_Description'
       ,@value=N'The primary key of this table.'
       ,@level0type=N'SCHEMA'
       ,@level0name=N'dbo'
       ,@level1type=N'TABLE'
       ,@level1name=N'Products'
       ,@level2type=N'COLUMN'
       ,@level2name=N'ProductId'
GO
---------------------------------------------------------------------------------------
EXECUTE sys.sp_AddExtendedProperty 
        @name=N'MS_Description'
       ,@value=N'The name of this product.'
       ,@level0type=N'SCHEMA'
       ,@level0name=N'dbo'
       ,@level1type=N'TABLE'
       ,@level1name=N'Products'
       ,@level2type=N'COLUMN'
       ,@level2name=N'Name'
GO
---------------------------------------------------------------------------------------
EXECUTE sys.sp_AddExtendedProperty 
        @name=N'MS_Description'
       ,@value=N'The optional extended description of this product.'
       ,@level0type=N'SCHEMA'
       ,@level0name=N'dbo'
       ,@level1type=N'TABLE'
       ,@level1name=N'Products'
       ,@level2type=N'COLUMN'
       ,@level2name=N'Description'
GO
---------------------------------------------------------------------------------------
EXECUTE sys.sp_AddExtendedProperty 
        @name=N'MS_Description'
       ,@value=N'The current price of this product.'
       ,@level0type=N'SCHEMA'
       ,@level0name=N'dbo'
       ,@level1type=N'TABLE'
       ,@level1name=N'Products'
       ,@level2type=N'COLUMN'
       ,@level2name=N'Price'
GO
---------------------------------------------------------------------------------------
GO
