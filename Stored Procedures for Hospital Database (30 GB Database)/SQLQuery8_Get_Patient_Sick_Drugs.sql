USE [hospital]
GO

/****** Object:  StoredProcedure [dbo].[GetPatientSickDrug]    Script Date: 2/23/2017 10:43:30 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[GetPatientSickDrug]  
(
 	@FileCode INT,
	@BillBim BIT,
	@ActExceptionInGlobal BIT	
)

AS
BEGIN

  IF (@BillBim =0) 
	BEGIN---’Ê—  Õ”«» »Ì„«—
	IF (  @ActExceptionInGlobal=0 )   
		BEGIN
              SELECT 
			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode<>7 THEN drg.DrugPriceWithOutGlobal ELSE  0 END) AS SDPrice, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode<>7 THEN drg.DrugPriceWithOutGlobal ELSE  0 END) AS SUPrice, 
			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode=7 THEN drg.DrugPriceWithOutGlobal ELSE  0 END) AS ODPrice, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode=7 THEN drg.DrugPriceWithOutGlobal ELSE  0 END) AS OUPrice, 

			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode<>7 THEN drg.BimPrice ELSE  0 END) AS SDBimPrice, 
			SUM(  CASE WHEN   (drg.GroupTypeCode<>1) AND drg.SectionTypeCode<>7 THEN drg.BimPrice ELSE  0 END) AS SUBimPrice, 
			SUM(  CASE WHEN   (drg.GroupTypeCode=1) AND drg.SectionTypeCode=7 THEN drg.BimPrice ELSE  0 END) AS ODBimPrice, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode=7 THEN drg.BimPrice ELSE  0 END) AS OUBimPrice, 

			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode<>7 THEN drg.SickPriceWithOutGlobal  ELSE  0 END)  AS SDSickPrice, 
			SUM(  CASE WHEN   (drg.GroupTypeCode<>1) AND drg.SectionTypeCode<>7 THEN drg.SickPriceWithOutGlobal ELSE  0 END)  AS SUSickPrice, 
			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode=7 THEN drg.SickPriceWithOutGlobal ELSE  0 END)  AS ODSickPrice, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode=7 THEN drg.SickPriceWithOutGlobal ELSE  0 END)  AS OUSickPrice, 

			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode<>7   THEN 1 ELSE  0 END) AS SDCount, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode<>7  THEN 1 ELSE  0 END) AS SUCount, 
			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode=7   THEN 1 ELSE  0 END) AS ODCount, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode=7  THEN 1 ELSE  0 END) AS OUCount, 

			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode<>7  THEN drg.CompPriceWithOutGlobal ELSE  0 END) AS  SDCompDrg, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode<>7  THEN drg.CompPriceWithOutGlobal ELSE  0 END) AS SUCompDrg, 
			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode=7   THEN drg.CompPriceWithOutGlobal ELSE  0 END) AS ODCompDrg, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode=7  THEN drg.CompPriceWithOutGlobal ELSE  0 END) AS OUCompDrg, 

			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode<>7   THEN drg.CompSubsidyPriceWithOutGlobal ELSE  0 END) AS SDCompSubDrg, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode<>7  THEN drg.CompSubsidyPriceWithOutGlobal ELSE  0 END) AS SUCompSubDrg, 
			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode=7   THEN drg.CompSubsidyPriceWithOutGlobal ELSE  0 END) AS ODCompSubDrg, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode=7  THEN drg.CompSubsidyPriceWithOutGlobal ELSE  0 END) AS OUCompSubDrg, 

			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode<>7   THEN drg.IncludedBim ELSE  0 END) AS SDInclude, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode<>7  THEN drg.IncludedBim ELSE  0 END) AS SUInclude, 
			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode=7   THEN drg.IncludedBim ELSE  0 END) AS ODInclude, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode=7  THEN drg.IncludedBim ELSE  0 END) AS OUInclude, 

			SUM(CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode<>7    THEN drg.ExceptionPrice ELSE  0 END) AS SDExceptDrg, 
			SUM(CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode<>7    THEN drg.ExceptionPrice ELSE  0 END) AS SUExceptDrg, 
			SUM(CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode=7    THEN drg.ExceptionPrice ELSE  0 END) AS ODExceptDrg, 
			SUM(CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode=7    THEN drg.ExceptionPrice ELSE  0 END) AS OUExceptDrg 

           FROM  PatientDrugInfo Drg 
           WHERE Drg.FileCode=@FileCode 
           AND   Drg.Bag IS NULL	 
           AND  ( Drg.OverGlSickPrice>0 
           OR   Drg.ExceptionPrice >5 )
        END   	 
     Else
       BEGIN
      
        SELECT 

			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode<>7 THEN drg.DrugPrice ELSE  0 END) AS SDPrice, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode<>7 THEN drg.DrugPrice ELSE  0 END) AS SUPrice, 
			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode=7 THEN drg.DrugPrice ELSE  0 END) AS ODPrice, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode=7 THEN drg.DrugPrice ELSE  0 END) AS OUPrice, 

			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode<>7 THEN drg.BimPrice ELSE  0 END) AS SDBimPrice, 
			SUM(  CASE WHEN   (drg.GroupTypeCode<>1) AND drg.SectionTypeCode<>7 THEN drg.BimPrice ELSE  0 END) AS SUBimPrice, 
			SUM(  CASE WHEN   (drg.GroupTypeCode=1) AND drg.SectionTypeCode=7 THEN drg.BimPrice ELSE  0 END) AS ODBimPrice, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode=7 THEN drg.BimPrice ELSE  0 END) AS OUBimPrice, 

			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode<>7 THEN drg.SickPrice  ELSE  0 END)  AS SDSickPrice, 
			SUM( CASE WHEN   (drg.GroupTypeCode<>1) AND drg.SectionTypeCode<>7 THEN drg.SickPrice ELSE  0 END)  AS SUSickPrice, 
			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode=7 THEN drg.SickPrice ELSE  0 END)  AS ODSickPrice, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode=7 THEN drg.SickPrice ELSE  0 END)  AS OUSickPrice, 

			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode<>7 AND (drg.ISglobal=0 OR (drg.ISglobal=1 AND drg.OverGlSickPrice>0 )  ) THEN 1 ELSE  0 END) AS SDCount, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode<>7 AND (drg.ISglobal=0 OR (drg.ISglobal=1 AND drg.OverGlSickPrice>0 )  ) THEN 1 ELSE  0 END) AS SUCount, 
			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode=7  AND (drg.ISglobal=0 OR (drg.ISglobal=1 AND drg.OverGlSickPrice>0 )  ) THEN 1 ELSE  0 END) AS ODCount, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode=7 AND (drg.ISglobal=0 OR (drg.ISglobal=1 AND drg.OverGlSickPrice>0 )  ) THEN 1 ELSE  0 END) AS OUCount, 

			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode<>7  THEN drg.CompPrice ELSE  0 END) AS  SDCompDrg, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode<>7  THEN drg.CompPrice ELSE  0 END) AS SUCompDrg, 
			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode=7   THEN drg.CompPrice ELSE  0 END) AS ODCompDrg, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode=7  THEN drg.CompPrice ELSE  0 END) AS OUCompDrg, 

			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode<>7  THEN drg.CompSubsidyPrice ELSE  0 END) AS SDCompSubDrg, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode<>7  THEN drg.CompSubsidyPrice ELSE  0 END) AS SUCompSubDrg, 
			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode=7   THEN drg.CompSubsidyPrice ELSE  0 END) AS ODCompSubDrg, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode=7  THEN drg.CompSubsidyPrice ELSE  0 END) AS OUCompSubDrg, 

			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode<>7   THEN drg.IncludedBim ELSE  0 END) AS SDInclude, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode<>7  THEN drg.IncludedBim ELSE  0 END) AS SUInclude, 
			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode=7   THEN drg.IncludedBim ELSE  0 END) AS ODInclude, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode=7  THEN drg.IncludedBim ELSE  0 END) AS OUInclude, 

			SUM(CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode<>7 AND (drg.ISglobal=0 OR (drg.ISglobal=1 AND drg.OverGlSickPrice>0 )  )    THEN drg.ExceptionPrice ELSE  0 END) AS SDExceptDrg, 
			SUM(CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode<>7 AND (drg.ISglobal=0 OR (drg.ISglobal=1 AND drg.OverGlSickPrice>0 )  )    THEN drg.ExceptionPrice ELSE  0 END) AS SUExceptDrg, 
			SUM(CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode=7 AND (drg.ISglobal=0 OR (drg.ISglobal=1 AND drg.OverGlSickPrice>0 )  )    THEN drg.ExceptionPrice ELSE  0 END) AS ODExceptDrg, 
			SUM(CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode=7 AND (drg.ISglobal=0 OR (drg.ISglobal=1 AND drg.OverGlSickPrice>0 )  )    THEN drg.ExceptionPrice ELSE  0 END) AS OUExceptDrg 
     FROM  PatientDrugInfo Drg 
     WHERE Drg.FileCode=@FileCode 
     AND   Drg.Bag IS NULL	;
     
  END     
 END	
ELSE---’Ê—  Õ”«» »Ì„Â
	BEGIN
	IF (  @ActExceptionInGlobal=0 )  
		BEGIN
              SELECT 
			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode<>7 THEN drg.DrugPriceWithOutGlobal ELSE  0 END) AS SDPrice, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode<>7 THEN drg.DrugPriceWithOutGlobal ELSE  0 END) AS SUPrice, 
			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode=7 THEN drg.DrugPriceWithOutGlobal ELSE  0 END) AS ODPrice, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode=7 THEN drg.DrugPriceWithOutGlobal ELSE  0 END) AS OUPrice, 

			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode<>7 THEN drg.BimPrice ELSE  0 END) AS SDBimPrice, 
			SUM(  CASE WHEN   (drg.GroupTypeCode<>1) AND drg.SectionTypeCode<>7 THEN drg.BimPrice ELSE  0 END) AS SUBimPrice, 
			SUM(  CASE WHEN   (drg.GroupTypeCode=1) AND drg.SectionTypeCode=7 THEN drg.BimPrice ELSE  0 END) AS ODBimPrice, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode=7 THEN drg.BimPrice ELSE  0 END) AS OUBimPrice, 

			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode<>7 THEN drg.SickPriceWithOutGlobal  ELSE  0 END)  AS SDSickPrice, 
			SUM(  CASE WHEN   (drg.GroupTypeCode<>1) AND drg.SectionTypeCode<>7 THEN drg.SickPriceWithOutGlobal ELSE  0 END)  AS SUSickPrice, 
			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode=7 THEN drg.SickPriceWithOutGlobal ELSE  0 END)  AS ODSickPrice, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode=7 THEN drg.SickPriceWithOutGlobal ELSE  0 END)  AS OUSickPrice, 

			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode<>7   THEN 1 ELSE  0 END) AS SDCount, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode<>7  THEN 1 ELSE  0 END) AS SUCount, 
			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode=7   THEN 1 ELSE  0 END) AS ODCount, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode=7  THEN 1 ELSE  0 END) AS OUCount, 

			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode<>7  THEN drg.CompPriceWithOutGlobal ELSE  0 END) AS  SDCompDrg, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode<>7  THEN drg.CompPriceWithOutGlobal ELSE  0 END) AS SUCompDrg, 
			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode=7   THEN drg.CompPriceWithOutGlobal ELSE  0 END) AS ODCompDrg, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode=7  THEN drg.CompPriceWithOutGlobal ELSE  0 END) AS OUCompDrg, 

			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode<>7   THEN drg.CompSubsidyPriceWithOutGlobal ELSE  0 END) AS SDCompSubDrg, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode<>7  THEN drg.CompSubsidyPriceWithOutGlobal ELSE  0 END) AS SUCompSubDrg, 
			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode=7   THEN drg.CompSubsidyPriceWithOutGlobal ELSE  0 END) AS ODCompSubDrg, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode=7  THEN drg.CompSubsidyPriceWithOutGlobal ELSE  0 END) AS OUCompSubDrg, 

			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode<>7   THEN drg.IncludedBim ELSE  0 END) AS SDInclude, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode<>7  THEN drg.IncludedBim ELSE  0 END) AS SUInclude, 
			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode=7   THEN drg.IncludedBim ELSE  0 END) AS ODInclude, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode=7  THEN drg.IncludedBim ELSE  0 END) AS OUInclude, 

			SUM(CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode<>7    THEN drg.ExceptionPrice ELSE  0 END) AS SDExceptDrg, 
			SUM(CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode<>7    THEN drg.ExceptionPrice ELSE  0 END) AS SUExceptDrg, 
			SUM(CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode=7    THEN drg.ExceptionPrice ELSE  0 END) AS ODExceptDrg, 
			SUM(CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode=7    THEN drg.ExceptionPrice ELSE  0 END) AS OUExceptDrg 

           FROM  PatientDrugInfo Drg 
           WHERE Drg.FileCode=@FileCode 
           AND   Drg.Bag IS NULL	 
           AND  (Drg.BimPriceWithOutGlobal + Drg.SickPriceWithOutGlobal) > 0
           AND (Drg.BimPriceWithOutGlobal > 0 OR Drg.CompSubsidyPriceWithOutGlobal > 0 ) 
	       AND Drg.ExceptionPrice>0
        END   	 
     Else
       BEGIN
      
        SELECT 

			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode<>7 THEN drg.DrugPrice ELSE  0 END) AS SDPrice, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode<>7 THEN drg.DrugPrice ELSE  0 END) AS SUPrice, 
			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode=7 THEN drg.DrugPrice ELSE  0 END) AS ODPrice, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode=7 THEN drg.DrugPrice ELSE  0 END) AS OUPrice, 

			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode<>7 THEN drg.BimPrice ELSE  0 END) AS SDBimPrice, 
			SUM(  CASE WHEN   (drg.GroupTypeCode<>1) AND drg.SectionTypeCode<>7 THEN drg.BimPrice ELSE  0 END) AS SUBimPrice, 
			SUM(  CASE WHEN   (drg.GroupTypeCode=1) AND drg.SectionTypeCode=7 THEN drg.BimPrice ELSE  0 END) AS ODBimPrice, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode=7 THEN drg.BimPrice ELSE  0 END) AS OUBimPrice, 

			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode<>7 THEN drg.SickPrice  ELSE  0 END)  AS SDSickPrice, 
			SUM( CASE WHEN   (drg.GroupTypeCode<>1) AND drg.SectionTypeCode<>7 THEN drg.SickPrice ELSE  0 END)  AS SUSickPrice, 
			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode=7 THEN drg.SickPrice ELSE  0 END)  AS ODSickPrice, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode=7 THEN drg.SickPrice ELSE  0 END)  AS OUSickPrice, 

			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode<>7 AND (drg.ISglobal=0 OR (drg.ISglobal=1 AND drg.OverGlSickPrice>0 )  ) THEN 1 ELSE  0 END) AS SDCount, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode<>7 AND (drg.ISglobal=0 OR (drg.ISglobal=1 AND drg.OverGlSickPrice>0 )  ) THEN 1 ELSE  0 END) AS SUCount, 
			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode=7  AND (drg.ISglobal=0 OR (drg.ISglobal=1 AND drg.OverGlSickPrice>0 )  ) THEN 1 ELSE  0 END) AS ODCount, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode=7 AND (drg.ISglobal=0 OR (drg.ISglobal=1 AND drg.OverGlSickPrice>0 )  ) THEN 1 ELSE  0 END) AS OUCount, 

			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode<>7  THEN drg.CompPrice ELSE  0 END) AS  SDCompDrg, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode<>7  THEN drg.CompPrice ELSE  0 END) AS SUCompDrg, 
			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode=7   THEN drg.CompPrice ELSE  0 END) AS ODCompDrg, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode=7  THEN drg.CompPrice ELSE  0 END) AS OUCompDrg, 

			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode<>7  THEN drg.CompSubsidyPrice ELSE  0 END) AS SDCompSubDrg, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode<>7  THEN drg.CompSubsidyPrice ELSE  0 END) AS SUCompSubDrg, 
			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode=7   THEN drg.CompSubsidyPrice ELSE  0 END) AS ODCompSubDrg, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode=7  THEN drg.CompSubsidyPrice ELSE  0 END) AS OUCompSubDrg, 

			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode<>7   THEN drg.IncludedBim ELSE  0 END) AS SDInclude, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode<>7  THEN drg.IncludedBim ELSE  0 END) AS SUInclude, 
			SUM(  CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode=7   THEN drg.IncludedBim ELSE  0 END) AS ODInclude, 
			SUM(  CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode=7  THEN drg.IncludedBim ELSE  0 END) AS OUInclude, 

			SUM(CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode<>7 AND (drg.ISglobal=0 OR (drg.ISglobal=1 AND drg.OverGlSickPrice>0 )  )    THEN drg.ExceptionPrice ELSE  0 END) AS SDExceptDrg, 
			SUM(CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode<>7 AND (drg.ISglobal=0 OR (drg.ISglobal=1 AND drg.OverGlSickPrice>0 )  )    THEN drg.ExceptionPrice ELSE  0 END) AS SUExceptDrg, 
			SUM(CASE WHEN  (drg.GroupTypeCode=1) AND drg.SectionTypeCode=7 AND (drg.ISglobal=0 OR (drg.ISglobal=1 AND drg.OverGlSickPrice>0 )  )    THEN drg.ExceptionPrice ELSE  0 END) AS ODExceptDrg, 
			SUM(CASE WHEN  (drg.GroupTypeCode<>1) AND drg.SectionTypeCode=7 AND (drg.ISglobal=0 OR (drg.ISglobal=1 AND drg.OverGlSickPrice>0 )  )    THEN drg.ExceptionPrice ELSE  0 END) AS OUExceptDrg 
     FROM  PatientDrugInfo Drg 
     WHERE Drg.FileCode=@FileCode 
     AND  (Drg.BimPriceWithOutGlobal + Drg.SickPriceWithOutGlobal) > 0
     AND (Drg.CompSubsidyPrice>0 OR Drg.BimPrice>0 )
     AND   Drg.Bag IS NULL	;
     
  END     
 END






 
 
 
END       
       




GO


