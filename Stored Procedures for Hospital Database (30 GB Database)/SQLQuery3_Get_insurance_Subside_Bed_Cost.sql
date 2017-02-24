USE [hospital]
GO

/****** Object:  StoredProcedure [dbo].[GetBimSubsidyBedCost]    Script Date: 2/23/2017 10:39:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetBimSubsidyBedCost]
	@FileCode INT,
	@IsGlobal INT,
	@SubsidyReservedRatio FLOAT,
	@SubsidyRatioBase FLOAT,
	@Act2kForIsGlobal INT = 1
AS
BEGIN
	EXEC (
	         '
SELECT        ROW_NUMBER() Over( Order By BSS.ServiceName )  As ServiceGroupCode,        GroupCont = 
       SUM(CASE  
           WHEN ((' + @IsGlobal +
	         ' = 1) AND (OGS.ServiceCode IS NOT NULL)) OR (' + @IsGlobal +
	         ' <> 1) THEN  
           BSS.UseNum 
           ELSE 0 
       END), 
       SickValue = 
       SUM(CASE  
           WHEN ((' + @IsGlobal +
	         ' = 1) AND (OGS.ServiceCode IS NOT NULL)) OR (' + @IsGlobal +
	         ' <> 1) THEN  
           BSS.SickValue 
           ELSE 0 
       END), 
        
       BimValue = 
       SUM(CASE  
           WHEN ((' + @IsGlobal +
	         ' = 1) AND (OGS.ServiceCode IS NOT NULL)) OR (' + @IsGlobal +
	         ' <> 1) THEN  
           BSS.BimValue 
           ELSE 0 
       END),        
         
       CompPrice = 
       SUM(CASE  
           WHEN ((' + @IsGlobal +
	         ' = 1) AND (OGS.ServiceCode IS NOT NULL)) OR (' + @IsGlobal +
	         ' <> 1) THEN  
           BSS.CompPrice 
           ELSE 0 
       END), 
              
       CompSubsidyPrice = 
       SUM(CASE  
           WHEN ((' + @IsGlobal +
	         ' = 1) AND (OGS.ServiceCode IS NOT NULL)) OR (' + @IsGlobal +
	         ' <> 1) THEN  
           BSS.CompSubsidyPrice 
           ELSE 0 
       END),        
                      
       ExceptPrice = 
       SUM(CASE  
           WHEN ((' + @IsGlobal +
	         ' = 1) AND (OGS.ServiceCode IS NOT NULL)) OR (' + @IsGlobal +
	         ' <> 1) THEN  
           BSS.ExceptPrice 
           ELSE 0 
       END),               
       
	   Sum(BSS.KDoctorPrice)    As KDoctorPrice,        
       Sum(BSS.KGDoctorPrice)   As KGDoctorPrice,          
      
       Sum(Case When BSS.BimValue > 0 Then BSS.PrfDrPrice   Else 0 End)    AS PrfDrPrice,  
       BSS.ServiceName SrvName,         
       DecRelativePrice = SUM( 
           CASE  
                WHEN ((' + @IsGlobal +
	         ' = 1) AND (OGS.ServiceCode IS NOT NULL)) 
           OR (' + @IsGlobal +
	         ' <> 1) THEN ( 
                  CASE  
                       WHEN BSS.CompSubsidyBimRatio  =' + @SubsidyRatioBase +
	         ' THEN ( 
                                ( 
                                    ( 
                                        isNull(BSS.sickvalue,0) - ISNULL(BSS.compprice, 0) 
                                        -isnull(BSS.CompSubsidyPrice,0) 
                                    ) / (1 - isnull(BSS.CompSubsidyBimRatio,0)) 
                                ) *  ' + @SubsidyReservedRatio +
	         '                            ) 
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
 WHERE BSS.FileCode = ' + @FileCode +
	         '   And ( BSS.BimValue + BSS.SickValue ) <> 0   And ( BSS.BimValue > 0 OR BSS.CompSubsidyPrice > 0 )   And BSS.ServiceGroupCode  IN (
	         9) 
 Group BY  BSS.ServiceName  '
	     )
END;


GO


