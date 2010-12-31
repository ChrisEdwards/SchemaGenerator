---------------------------------------------------------------------------------------
USE OrderSystem;
GO
---------------------------------------------------------------------------------------
IF OBJECT_ID('OrderSystem.dbo.Customers') IS NOT NULL
   BEGIN
      RAISERROR('Dropping table: OrderSystem.dbo.Customers...',0,0) WITH NOWAIT;
      DROP TABLE OrderSystem.dbo.Customers;
   END
GO
---------------------------------------------------------------------------------------
RAISERROR('Creating table: OrderSystem.dbo.Customers...',0,0) WITH NOWAIT;
GO
---------------------------------------------------------------------------------------
CREATE TABLE OrderSystem.dbo.Customers
(
 CustomerId                                         INT             IDENTITY(1,1)   -- The primary key of this table.
,FirstName                                          VARCHAR(50)     NOT NULL        -- The customers first name
,LastName                                           VARCHAR(50)     NOT NULL        -- The customers last name
,Address1                                           VARCHAR(200)        NULL        -- The first line of the customers address.
,Address2                                           VARCHAR(200)    NOT NULL        -- The second line of the customers address.
,City                                               VARCHAR(50)         NULL        -- The city.
,State                                              VARCHAR(2)          NULL        -- The 2 char abbreviation of the customers state.
,Zip                                                VARCHAR(10)         NULL        -- Customers zip code.

 -- Audit Columns
,TimeInserted                                       DATETIME        NOT NULL
      CONSTRAINT Customers_Default_TimeInserted
      DEFAULT    (GETDATE())
,TimeUpdated                                        DATETIME        NOT NULL
      CONSTRAINT Customers_Default_TimeUpdated
      DEFAULT    (GETDATE())

 -- Constraints
,CONSTRAINT Customers_PrimaryKey_CustomerId
      PRIMARY KEY CLUSTERED (CustomerId ASC)
)
GO
---------------------------------------------------------------------------------------
--GRANT INSERT, UPDATE, DELETE, SELECT ON OrderSystem.dbo.Customers TO Public;
--GO
---------------------------------------------------------------------------------------
EXECUTE sys.sp_AddExtendedProperty
        @name=N'MS_Description'
       ,@value=N'Contains the customer information.'
       ,@level0type=N'SCHEMA'
       ,@level0name=N'dbo'
       ,@level1type=N'TABLE'
       ,@level1name=N'Customers'
GO
---------------------------------------------------------------------------------------
EXECUTE sys.sp_AddExtendedProperty
        @name=N'MS_Description'
       ,@value=N'The primary key of this table.'
       ,@level0type=N'SCHEMA'
       ,@level0name=N'dbo'
       ,@level1type=N'TABLE'
       ,@level1name=N'Customers'
       ,@level2type=N'COLUMN'
       ,@level2name=N'CustomerId'
GO
---------------------------------------------------------------------------------------
EXECUTE sys.sp_AddExtendedProperty
        @name=N'MS_Description'
       ,@value=N'The customers first name'
       ,@level0type=N'SCHEMA'
       ,@level0name=N'dbo'
       ,@level1type=N'TABLE'
       ,@level1name=N'Customers'
       ,@level2type=N'COLUMN'
       ,@level2name=N'FirstName'
GO
---------------------------------------------------------------------------------------
EXECUTE sys.sp_AddExtendedProperty
        @name=N'MS_Description'
       ,@value=N'The customers last name'
       ,@level0type=N'SCHEMA'
       ,@level0name=N'dbo'
       ,@level1type=N'TABLE'
       ,@level1name=N'Customers'
       ,@level2type=N'COLUMN'
       ,@level2name=N'LastName'
GO
---------------------------------------------------------------------------------------
EXECUTE sys.sp_AddExtendedProperty
        @name=N'MS_Description'
       ,@value=N'The first line of the customers address.'
       ,@level0type=N'SCHEMA'
       ,@level0name=N'dbo'
       ,@level1type=N'TABLE'
       ,@level1name=N'Customers'
       ,@level2type=N'COLUMN'
       ,@level2name=N'Address1'
GO
---------------------------------------------------------------------------------------
EXECUTE sys.sp_AddExtendedProperty
        @name=N'MS_Description'
       ,@value=N'The second line of the customers address.'
       ,@level0type=N'SCHEMA'
       ,@level0name=N'dbo'
       ,@level1type=N'TABLE'
       ,@level1name=N'Customers'
       ,@level2type=N'COLUMN'
       ,@level2name=N'Address2'
GO
---------------------------------------------------------------------------------------
EXECUTE sys.sp_AddExtendedProperty
        @name=N'MS_Description'
       ,@value=N'The city.'
       ,@level0type=N'SCHEMA'
       ,@level0name=N'dbo'
       ,@level1type=N'TABLE'
       ,@level1name=N'Customers'
       ,@level2type=N'COLUMN'
       ,@level2name=N'City'
GO
---------------------------------------------------------------------------------------
EXECUTE sys.sp_AddExtendedProperty
        @name=N'MS_Description'
       ,@value=N'The 2 char abbreviation of the customers state.'
       ,@level0type=N'SCHEMA'
       ,@level0name=N'dbo'
       ,@level1type=N'TABLE'
       ,@level1name=N'Customers'
       ,@level2type=N'COLUMN'
       ,@level2name=N'State'
GO
---------------------------------------------------------------------------------------
EXECUTE sys.sp_AddExtendedProperty
        @name=N'MS_Description'
       ,@value=N'Customers zip code.'
       ,@level0type=N'SCHEMA'
       ,@level0name=N'dbo'
       ,@level1type=N'TABLE'
       ,@level1name=N'Customers'
       ,@level2type=N'COLUMN'
       ,@level2name=N'Zip'
GO
---------------------------------------------------------------------------------------
GO
