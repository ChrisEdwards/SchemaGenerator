SchemaGen
=========
SchemaGen allows you to define a database schema in YAML and generate the sql scripts to create that schema automatically. It produces scripts to create the tables, unique constratins, foreign keys, and the insertion of seed data.

Check out the /sample/ folder to see an examples of all the features.

Sample Input File (Categories.yml)
----------------------------------

	Categories:
	    description: The list of categories used to classify products.
	    
	    columns:
	        CategoryId:
	            type: int
	            primarykey: true
	            identity: true
	            description: The primary key of this table.
	        
	        Name:
	            type: varchar(50)
	            required: true
	            description: The category name.
	        
	        Description:
	            type: varchar(50)
	            description: The optional exteneded description of the category.
	        
	    constraints:
	        'unique nonclustered':
	            - [ Name ] # No two categories should have the same name.
	    
	    seed_data:
	        -
	            CategoryId: 1
	            Name: Laptops
	            Description: Laptops, Netbooks and Tablets
	        -
	            CategoryId: 2
	            Name: Desktops
	            Description: Desktop computers
	        -
	            CategoryId: 3
	            Name: Servers
	            Description: Enterprise server sytems.

           
Generated Sql Scripts
----------------------

### Create Table Script

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


### Insert Seed Data Script

	---------------------------------------------------------------------------------------
	USE OrderSystem
	GO
	---------------------------------------------------------------------------------------
	SET NOCOUNT ON
	---------------------------------------------------------------------------------------
	IF NOT EXISTS (SELECT 1 
	                 FROM OrderSystem.dbo.Categories
	                WHERE (CategoryId = 1)
	              )
	   BEGIN
	      ---------------------------------------------------------------------------------
	      SET IDENTITY_INSERT Categories ON;
	      ---------------------------------------------------------------------------------
	      INSERT 
	         INTO OrderSystem.dbo.Categories
	             (CategoryId
	             ,Name
	             ,Description
	             )
	       VALUES 
	             (1
	             ,'Laptops'
	             ,'Laptops, Netbooks and Tablets'
	             );
	      ---------------------------------------------------------------------------------
	      SET IDENTITY_INSERT Categories OFF;
	      ---------------------------------------------------------------------------------
	   END
	---------------------------------------------------------------------------------------				
	IF NOT EXISTS (SELECT 1 
	                 FROM OrderSystem.dbo.Categories
	                WHERE (CategoryId = 2)
	              )
	   BEGIN
	      ---------------------------------------------------------------------------------
	      SET IDENTITY_INSERT Categories ON;
	      ---------------------------------------------------------------------------------
	      INSERT 
	         INTO OrderSystem.dbo.Categories
	             (CategoryId
	             ,Name
	             ,Description
	             )
	       VALUES 
	             (2
	             ,'Desktops'
	             ,'Desktop computers'
	             );
	      ---------------------------------------------------------------------------------
	      SET IDENTITY_INSERT Categories OFF;
	      ---------------------------------------------------------------------------------
	   END
	---------------------------------------------------------------------------------------				
	IF NOT EXISTS (SELECT 1 
	                 FROM OrderSystem.dbo.Categories
	                WHERE (CategoryId = 3)
	              )
	   BEGIN
	      ---------------------------------------------------------------------------------
	      SET IDENTITY_INSERT Categories ON;
	      ---------------------------------------------------------------------------------
	      INSERT 
	         INTO OrderSystem.dbo.Categories
	             (CategoryId
	             ,Name
	             ,Description
	             )
	       VALUES 
	             (3
	             ,'Servers'
	             ,'Enterprise server sytems.'
	             );
	      ---------------------------------------------------------------------------------
	      SET IDENTITY_INSERT Categories OFF;
	      ---------------------------------------------------------------------------------
	   END
	---------------------------------------------------------------------------------------				