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
