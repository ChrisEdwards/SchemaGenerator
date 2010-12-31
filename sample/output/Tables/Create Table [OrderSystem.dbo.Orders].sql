---------------------------------------------------------------------------------------
USE OrderSystem;
GO
---------------------------------------------------------------------------------------
IF OBJECT_ID('OrderSystem.dbo.Orders') IS NOT NULL
   BEGIN
      RAISERROR('Dropping table: OrderSystem.dbo.Orders...',0,0) WITH NOWAIT;
      DROP TABLE OrderSystem.dbo.Orders;
   END
GO
---------------------------------------------------------------------------------------
RAISERROR('Creating table: OrderSystem.dbo.Orders...',0,0) WITH NOWAIT;
GO
---------------------------------------------------------------------------------------
CREATE TABLE OrderSystem.dbo.Orders
(
 OrderId                                            INT             IDENTITY(1,1)   -- The primary key of this table.
,CustomerId                                         INT             NOT NULL        -- The customer who placed this order. This is a foreign key that references Customers.CustomerId. 
,OrderDate                                          DATE            NOT NULL        -- The date the order was placed.

 -- Audit Columns
,TimeInserted                                       DATETIME        NOT NULL
      CONSTRAINT Orders_Default_TimeInserted
      DEFAULT    (GETDATE())
,TimeUpdated                                        DATETIME        NOT NULL
      CONSTRAINT Orders_Default_TimeUpdated
      DEFAULT    (GETDATE())

 -- Constraints
,CONSTRAINT Orders_PrimaryKey_OrderId
      PRIMARY KEY CLUSTERED (OrderId ASC)
)
GO
---------------------------------------------------------------------------------------
--GRANT INSERT, UPDATE, DELETE, SELECT ON OrderSystem.dbo.Orders TO Public;
--GO
---------------------------------------------------------------------------------------
EXECUTE sys.sp_AddExtendedProperty
        @name=N'MS_Description'
       ,@value=N'Contains the orders placed by our customers.'
       ,@level0type=N'SCHEMA'
       ,@level0name=N'dbo'
       ,@level1type=N'TABLE'
       ,@level1name=N'Orders'
GO
---------------------------------------------------------------------------------------
EXECUTE sys.sp_AddExtendedProperty
        @name=N'MS_Description'
       ,@value=N'The primary key of this table.'
       ,@level0type=N'SCHEMA'
       ,@level0name=N'dbo'
       ,@level1type=N'TABLE'
       ,@level1name=N'Orders'
       ,@level2type=N'COLUMN'
       ,@level2name=N'OrderId'
GO
---------------------------------------------------------------------------------------
EXECUTE sys.sp_AddExtendedProperty
        @name=N'MS_Description'
       ,@value=N'The customer who placed this order. This is a foreign key that references Customers.CustomerId. '
       ,@level0type=N'SCHEMA'
       ,@level0name=N'dbo'
       ,@level1type=N'TABLE'
       ,@level1name=N'Orders'
       ,@level2type=N'COLUMN'
       ,@level2name=N'CustomerId'
GO
---------------------------------------------------------------------------------------
EXECUTE sys.sp_AddExtendedProperty
        @name=N'MS_Description'
       ,@value=N'The date the order was placed.'
       ,@level0type=N'SCHEMA'
       ,@level0name=N'dbo'
       ,@level1type=N'TABLE'
       ,@level1name=N'Orders'
       ,@level2type=N'COLUMN'
       ,@level2name=N'OrderDate'
GO
---------------------------------------------------------------------------------------
GO
