---------------------------------------------------------------------------------------
USE OrderSystem;
GO
---------------------------------------------------------------------------------------
IF OBJECT_ID('OrderSystem.dbo.Categories') IS NOT NULL
   BEGIN
      RAISERROR('Dropping table: OrderSystem.dbo.Categories...',0,0) WITH NOWAIT;
      DROP TABLE OrderSystem.dbo.Categories;
   END
GO
---------------------------------------------------------------------------------------
RAISERROR('Creating table: OrderSystem.dbo.Categories...',0,0) WITH NOWAIT;
GO
---------------------------------------------------------------------------------------
CREATE TABLE OrderSystem.dbo.Categories
(
 CategoryId                                         INT             IDENTITY(1,1)   -- The primary key of this table.
,Name                                               VARCHAR(50)     NOT NULL        -- The category name.
,Description                                        VARCHAR(50)         NULL        -- The optional exteneded description of the category.
	
 -- Audit Columns
,TimeInserted                                       DATETIME        NOT NULL
      CONSTRAINT Categories_Default_TimeInserted  
      DEFAULT    (GETDATE())
,TimeUpdated                                        DATETIME        NOT NULL
      CONSTRAINT Categories_Default_TimeUpdated
      DEFAULT    (GETDATE())
	
 -- Constraints
,CONSTRAINT Categories_PrimaryKey_CategoryId
      PRIMARY KEY CLUSTERED (CategoryId ASC)

,CONSTRAINT Categories_UniqueKey_Name 
      UNIQUE NONCLUSTERED   (Name ASC)
)
GO
---------------------------------------------------------------------------------------
--GRANT INSERT, UPDATE, DELETE, SELECT ON OrderSystem.dbo.Categories TO Public;
--GO
---------------------------------------------------------------------------------------
EXECUTE sys.sp_AddExtendedProperty 
        @name=N'MS_Description'
       ,@value=N'The list of categories used to classify products.'
       ,@level0type=N'SCHEMA'
       ,@level0name=N'dbo'
       ,@level1type=N'TABLE'
       ,@level1name=N'Categories'
GO
---------------------------------------------------------------------------------------
EXECUTE sys.sp_AddExtendedProperty 
        @name=N'MS_Description'
       ,@value=N'The primary key of this table.'
       ,@level0type=N'SCHEMA'
       ,@level0name=N'dbo'
       ,@level1type=N'TABLE'
       ,@level1name=N'Categories'
       ,@level2type=N'COLUMN'
       ,@level2name=N'CategoryId'
GO
---------------------------------------------------------------------------------------
EXECUTE sys.sp_AddExtendedProperty 
        @name=N'MS_Description'
       ,@value=N'The category name.'
       ,@level0type=N'SCHEMA'
       ,@level0name=N'dbo'
       ,@level1type=N'TABLE'
       ,@level1name=N'Categories'
       ,@level2type=N'COLUMN'
       ,@level2name=N'Name'
GO
---------------------------------------------------------------------------------------
EXECUTE sys.sp_AddExtendedProperty 
        @name=N'MS_Description'
       ,@value=N'The optional exteneded description of the category.'
       ,@level0type=N'SCHEMA'
       ,@level0name=N'dbo'
       ,@level1type=N'TABLE'
       ,@level1name=N'Categories'
       ,@level2type=N'COLUMN'
       ,@level2name=N'Description'
GO
---------------------------------------------------------------------------------------
GO
