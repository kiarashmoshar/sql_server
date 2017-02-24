USE [hospital]
GO

/****** Object:  StoredProcedure [dbo].[GetBimSubsidyOtherCost]    Script Date: 2/23/2017 10:40:30 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetBimSubsidyOtherCost]
	@FileCode INT,
	@IsGlobal INT,
	@SubsidyReservedRatio FLOAT,
	@SubsidyRatioBase FLOAT,
	@Act2kForIsGlobal INT = 1
AS
BEGIN
EXEC (
 'Select ROW_NUMBER() Over(order By ISNull(SG.Sort, 10000)) ServiceGroupCode, SR.ServiceGroupCode SrvGrpCode  ,
 SR.ServiceName SrvName,SR.GroupCont,SR.SickValue,SR.BimValue,SR.CompPrice,
  SR.CompSubsidyPrice CompSubsidyPrice,SR.ExceptPrice ExceptPrice,SR.KDoctorPrice KDoctorPrice,
  SR.KGDoctorPrice,SR.PrfDrPrice,SR.DecRelativePrice , SR.PriceWithExcep ,ISNULL (SG.Sort , 1000000) AS Sort
          
   From (SELECT        BSS.ServiceName,        BSS.ServiceGroupCode, 
       Sum(BSS.UseNum)         AS GroupCont, 
       SickValue = 
       SUM(CASE  
           WHEN (('+@IsGlobal+' = 1) AND (OGS.ServiceCode IS NOT NULL)) OR ('+@IsGlobal+' <> 1) THEN  
           BSS.SickValue 
           ELSE 0 
       END), 
       BimValue = 
       SUM(CASE  
           WHEN (('+@IsGlobal+' = 1) AND (OGS.ServiceCode IS NOT NULL)) OR ('+@IsGlobal+' <> 1) THEN  
           BSS.BimValue 
           ELSE 0 
       END),        
       CompPrice = 
       SUM(CASE  
           WHEN (('+@IsGlobal+' = 1) AND (OGS.ServiceCode IS NOT NULL)) OR ('+@IsGlobal+' <> 1) THEN  
           BSS.CompPrice 
           ELSE 0 
       END), 
       CompSubsidyPrice = 
       SUM(CASE  
           WHEN (('+@IsGlobal+' = 1) AND (OGS.ServiceCode IS NOT NULL)) OR ('+@IsGlobal+' <> 1) THEN  
           BSS.CompSubsidyPrice 
           ELSE 0 
       END),   
            
       ExceptPrice = 
       SUM(CASE  
           WHEN (('+@IsGlobal+' = 1) AND (OGS.ServiceCode IS NOT NULL)) OR ('+@IsGlobal+' <> 1) THEN  
           BSS.ExceptPrice 
           ELSE 0 
       END),   
                                    
       Sum(Case When (BSS.BimValue > 0) And 
       
          (  ( '+@Act2kForIsGlobal +'= 1 OR ((' + @IsGlobal + '= 1) AND (OGS.ServiceCode IS NOT NULL)) ) OR ('+ @IsGlobal + ' <> 1)  )               
           Then BSS.KDoctorPrice Else 0 End)   As KDoctorPrice,  
       
       Sum(Case When (BSS.BimValue > 0) And        
          (  ( '+@Act2kForIsGlobal +'= 1 OR ((' + @IsGlobal + '= 1) AND (OGS.ServiceCode IS NOT NULL)) ) OR ('+ @IsGlobal + ' <> 1)  )               
           Then BSS.KGDoctorPrice Else 0 End)   As KGDoctorPrice,         
       
       
       
       
       2                   AS SrvType, 
       Sum(Case When BSS.BimValue > 0 Then BSS.PrfDrPrice   Else 0 End)    AS PrfDrPrice,               
       DecRelativePrice = SUM( 
           CASE  
                WHEN (('+@IsGlobal+ ' = 1) AND (OGS.ServiceCode IS NOT NULL)) 
                     OR ('+@IsGlobal+ ' <> 1) THEN ( 
                       CASE  
                       WHEN BSS.CompSubsidyBimRatio = '+@SubsidyRatioBase+
                      ' THEN ( ( ( IsNull(BSS.sickvalue,0) - ISNULL(BSS.compprice, 0) 
                                        - IsNull(BSS.CompSubsidyPrice,0) 
                                    ) / (1 - IsNull(BSS.CompSubsidyBimRatio,0)) 
                                ) *  '+@SubsidyReservedRatio+                          
                            ') 
                       ELSE 0 
                  END 
              ) ELSE 0 END 
       ),
       
       PriceWithExcep = 
       SUM(CASE  
           WHEN (('+@IsGlobal+' = 1) AND (OGS.ServiceCode IS NOT NULL)) OR ('+@IsGlobal+' <> 1) THEN  
           BSS.PriceWithExcep 
           ELSE 0 
       END)       
       
  
       FROM  BimSubsidySickSrv BSS 
       LEFT OUTER JOIN OverGlSrv OGS ON OGS.ServiceCode = BSS.ServiceCode 
          
 WHERE BSS.FileCode = '+@FileCode+
      'And (BSS.BimValue + BSS.SickValue) <> 0   AND ( BSS.BimValue > 0 OR BSS.CompSubsidyPrice > 0 )  
       AND BSS.ServiceGroupCode NOT  IN ( 1 , 2, 3, 4, 5, 6, 7, 8, 9, 12, 13, 16, 17, 18, 19, 26 ) 
 GROUP BY  BSS.ServiceName,BSS.ServiceCode,BSS.ServiceGroupCode  
 UNION ALL
 SELECT  
       OC.Caption          AS ServiceName, 
       1000000             AS ServiceGroupCode, 
       1                   AS GroupCont, 
       (OC.CostSickValue)  AS SickValue, 
       (OC.CostBimValue)   AS BimValue, 
       (OC.CompValue)      AS CompPrice, 
       (OC.SubsidyValue)   AS CompSubsidyPrice, 
        ExceptPrice = Case When OC.CostBimValue > 0 Then 0 
                      Else OC.CostSickValue 
                      End, 
       0                   AS KDoctorPrice,
       0                   AS KGDoctorPrice,  
       1                   AS SrvType, 
       0                   AS PrfDrPrice, 
       0                   AS DecRelativePrice, 
       (OC.CostSickValue + OC.CostBimValue) As PriceWithExcep
       
        FROM   OtherCst OC 
 WHERE   OC.FileCode = '+@FileCode+
       ' And OC.IsCost = 1 AND (OC.CostBimValue >0 OR OC.SubsidyValue>0) 
     ) As SR LEFT JOIN SrvGroup SG ON SR.ServiceGroupCode = SG.ServiceGroupCode 
  ORDER BY Sort '
         )
END

GO


