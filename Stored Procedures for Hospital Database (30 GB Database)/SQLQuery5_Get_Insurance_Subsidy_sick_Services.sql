USE [hospital]
GO

/****** Object:  StoredProcedure [dbo].[GetBimSubsidySickSrv]    Script Date: 2/23/2017 10:41:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[GetBimSubsidySickSrv]
	@FileCode INT,
	@IsGlobal INT,
	@SubsidyReservedRatio FLOAT,
	@SubsidyRatioBase FLOAT,
	@Act2kForIsGlobal INT = 1
	
AS
BEGIN
	EXEC (
	        
'SELECT 
       BSS.ServiceGroupCode        AS ServiceGroupCode, 
       BSS.ServiceGroup            AS ServiceGroup, 
       GroupCont = 
       SUM(CASE  
           WHEN ((' + @IsGlobal + 
	         ' = 1) AND (OGS.ServiceCode IS NOT NULL)) OR (' + @IsGlobal + 
	         '<> 1) THEN  
           BSS.UseNum 
           ELSE 0 
       END), 
       SickValue = 
       SUM(CASE  
           WHEN ((' + @IsGlobal + '= 1) AND (OGS.ServiceCode IS NOT NULL)) OR ('
	         + @IsGlobal + 
	         '<> 1) THEN  
           BSS.SickValue 
           ELSE 0 
       END), 
        
       BimValue = 
       SUM(CASE  
           WHEN ((' + @IsGlobal + '= 1) AND (OGS.ServiceCode IS NOT NULL)) OR ('
	         + @IsGlobal + 
	         '<> 1) THEN  
           BSS.BimValue 
           ELSE 0 
       END),        
       CompPrice = 
       SUM(CASE  
           WHEN ((' + @IsGlobal + '= 1) AND (OGS.ServiceCode IS NOT NULL)) OR ('
	         + @IsGlobal + 
	         ' <> 1) THEN  
           BSS.CompPrice 
           ELSE 0 
       END), 
              
       CompSubsidyPrice = 
       SUM(CASE  
           WHEN ((' + @IsGlobal + '= 1) AND (OGS.ServiceCode IS NOT NULL)) OR ('
	               + @IsGlobal + ' <> 1) THEN  
           BSS.CompSubsidyPrice 
           ELSE 0 
       END),        
                      
       ExceptPrice = 
       SUM(CASE  
           WHEN ((' + @IsGlobal + '= 1) AND (OGS.ServiceCode IS NOT NULL)) OR ('
	         + @IsGlobal + 
	         '<> 1) THEN  
           BSS.ExceptPrice 
           ELSE 0 
       END),               
       Sum(Case When (BSS.BimValue > 0) And        
          (  ( '+@Act2kForIsGlobal +'= 1 OR ((' + @IsGlobal + '= 1) AND (OGS.ServiceCode IS NOT NULL)) ) OR ('+ @IsGlobal + ' <> 1)  )                    
        Then BSS.KDoctorPrice Else 0 End)   As KDoctorPrice,     
    
       Sum(Case When (BSS.BimValue > 0) And        
          (  ( '+@Act2kForIsGlobal +'= 1 OR ((' + @IsGlobal + '= 1) AND (OGS.ServiceCode IS NOT NULL)) ) OR ('+ @IsGlobal + ' <> 1)  )                    
        Then BSS.KGDoctorPrice Else 0 End)   As KGDoctorPrice,  
            
       Sum(Case When BSS.BimValue > 0 Then BSS.PrfDrPrice  Else 0 End)    AS PrfDrPrice,
       DecRelativePrice = SUM( 
           CASE  
                WHEN ((' + @IsGlobal + 
	         '= 1) AND (OGS.ServiceCode IS NOT NULL)) 
           OR (' + @IsGlobal + 
	         ' <> 1) THEN ( 
                  CASE  
                       WHEN (BSS.CompSubsidyBimRatio  =' + @SubsidyRatioBase + 
	         ')  THEN ( 
                                ( 
                                    ( 
                                          IsNull(BSS.SickValue,0) - ISNULL(BSS.compprice, 0) 
                                        - IsNull(BSS.CompSubsidyPrice,0) 
                                    ) / (1 - IsNull(BSS.CompSubsidyBimRatio,0)) 
                                ) *  ' + @SubsidyReservedRatio + 
	         '                           ) 
                       ELSE 0 
                  END 
              ) ELSE 0 END 
       ),

       
       PriceWithExcep = 
       SUM(CASE  
           WHEN ((' + @IsGlobal + '= 1) AND (OGS.ServiceCode IS NOT NULL)) OR ('
	               + @IsGlobal + ' <> 1) THEN  
           BSS.PriceWithExcep 
           ELSE 0 
       END)        
       
       
       
 FROM  BimSubsidySickSrv BSS 
       LEFT OUTER JOIN OverGlSrv OGS ON OGS.ServiceCode = BSS.ServiceCode 
          
WHERE  BSS.FileCode = ' + @FileCode + 
      ' And (BSS.BimValue + BSS.SickValue) <> 0   And (BSS.BimValue > 0 OR BSS.CompSubsidyPrice > 0 ) 
        And BSS.ServiceGroupCode  IN (1 , 2, 3, 4, 5, 6, 7, 8,  12, 13, 16 ,17 ,18 ,19 , 26)
	          GROUP BY  BSS.ServiceGroupCode , BSS.ServiceGroup '
	     )
END



GO


