---------------------------------------------------------------------------------------
USE OrderSystem;
GO
---------------------------------------------------------------------------------------
IF OBJECT_ID('OrderSystem.dbo.LineItems') IS NOT NULL
   BEGIN
      RAISERROR('Dropping table: OrderSystem.dbo.LineItems...',0,0) WITH NOWAIT;
      DROP TABLE OrderSystem.dbo.LineItems;
   END
GO
---------------------------------------------------------------------------------------
RAISERROR('Creating table: OrderSystem.dbo.LineItems...',0,0) WITH NOWAIT;
GO
---------------------------------------------------------------------------------------
CREATE TABLE OrderSystem.dbo.LineItems
(
 LineItemId                                         INT             IDENTITY(1,1)   -- The primary key of this table.
,OrderId                                            INT             NOT NULL        -- The order this line item belongs to. This is a foreign key that references Orders.OrderId. 
,ProductId                                          INT             NOT NULL        -- The product this line item is for. This is a foreign key that references Products.ProductId. 
,Quantity                                           INT             NOT NULL        -- The quantity of this product that was ordered.
,ItemPrice                                          MONEY           NOT NULL        -- The price of each item.

 -- Audit Columns
,TimeInserted                                       DATETIME        NOT NULL
      CONSTRAINT LineItems_Default_TimeInserted
      DEFAULT    (GETDATE())
,TimeUpdated                                        DATETIME        NOT NULL
      CONSTRAINT LineItems_Default_TimeUpdated
      DEFAULT    (GETDATE())

 -- Constraints
,CONSTRAINT LineItems_PrimaryKey_LineItemId
      PRIMARY KEY CLUSTERED (LineItemId ASC)

,CONSTRAINT LineItems_UniqueKey_ProductIdOrderId
      UNIQUE NONCLUSTERED   (ProductId ASC, OrderId ASC)
)
GO
---------------------------------------------------------------------------------------
--GRANT INSERT, UPDATE, DELETE, SELECT ON OrderSystem.dbo.LineItems TO Public;
--GO
---------------------------------------------------------------------------------------
EXECUTE sys.sp_AddExtendedProperty
        @name=N'MS_Description'
       ,@value=N'Contains the line items for each order.'
       ,@level0type=N'SCHEMA'
       ,@level0name=N'dbo'
       ,@level1type=N'TABLE'
       ,@level1name=N'LineItems'
GO
---------------------------------------------------------------------------------------
EXECUTE sys.sp_AddExtendedProperty
        @name=N'MS_Description'
       ,@value=N'The primary key of this table.'
       ,@level0type=N'SCHEMA'
       ,@level0name=N'dbo'
       ,@level1type=N'TABLE'
       ,@level1name=N'LineItems'
       ,@level2type=N'COLUMN'
       ,@level2name=N'LineItemId'
GO
---------------------------------------------------------------------------------------
EXECUTE sys.sp_AddExtendedProperty
        @name=N'MS_Description'
       ,@value=N'The order this line item belongs to. This is a foreign key that references Orders.OrderId. '
       ,@level0type=N'SCHEMA'
       ,@level0name=N'dbo'
       ,@level1type=N'TABLE'
       ,@level1name=N'LineItems'
       ,@level2type=N'COLUMN'
       ,@level2name=N'OrderId'
GO
---------------------------------------------------------------------------------------
EXECUTE sys.sp_AddExtendedProperty
        @name=N'MS_Description'
       ,@value=N'The product this line item is for. This is a foreign key that references Products.ProductId. '
       ,@level0type=N'SCHEMA'
       ,@level0name=N'dbo'
       ,@level1type=N'TABLE'
       ,@level1name=N'LineItems'
       ,@level2type=N'COLUMN'
       ,@level2name=N'ProductId'
GO
---------------------------------------------------------------------------------------
EXECUTE sys.sp_AddExtendedProperty
        @name=N'MS_Description'
       ,@value=N'The quantity of this product that was ordered.'
       ,@level0type=N'SCHEMA'
       ,@level0name=N'dbo'
       ,@level1type=N'TABLE'
       ,@level1name=N'LineItems'
       ,@level2type=N'COLUMN'
       ,@level2name=N'Quantity'
GO
---------------------------------------------------------------------------------------
EXECUTE sys.sp_AddExtendedProperty
        @name=N'MS_Description'
       ,@value=N'The price of each item.'
       ,@level0type=N'SCHEMA'
       ,@level0name=N'dbo'
       ,@level1type=N'TABLE'
       ,@level1name=N'LineItems'
       ,@level2type=N'COLUMN'
       ,@level2name=N'ItemPrice'
GO
---------------------------------------------------------------------------------------
GO
