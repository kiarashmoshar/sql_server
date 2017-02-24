USE [hospital]
GO

/****** Object:  StoredProcedure [dbo].[GetPatientSickBag]    Script Date: 2/23/2017 10:42:46 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[GetPatientSickBag]
	@FileCode INT,
	@BillBim BIT
AS
BEGIN

  IF (@BillBim =0) 
	BEGIN---’Ê—  Õ”«» »Ì„«—
       
	  SELECT 	
               Sum(BG_Count) AS  BG_Count,           		
               Sum(BG_SickPrice) AS   BG_SickPrice,      	 	
               Sum(BG_BimPrice) AS  BG_BimPrice,        	   	
               Sum(BG_Price)     AS BG_Price,	   	
               Sum(BG_Included)  AS BG_Included,	   	
               Sum(BG_Franchise) AS BG_Franchise,	   	
               Sum(BG_CompPrice) AS  BG_CompPrice,       	     	
               Sum(BG_CompSubsidyPrice) AS  BG_CompSubsidyPrice,		
               Sum(BG_ExceptPrice) AS   BG_ExceptPrice  ,
               Sum(BG_DecPrice) AS   BG_DecPrice  ,
               Sum(BG_FinalSickPrice) AS  BG_FinalSickPrice	
     FROM 	

      ( SELECT BG_Count            = ISNULL(SUM(s.UseUnitNum),0),		
               BG_SickPrice         = ISNULL(SUM(s.SickPrice),0),
               BG_BimPrice          = ISNULL(SUM(s.BimPrice),0),	   	
               BG_Price             = ISNULL(SUM(s.DrugPrice),0),	   	
               BG_Included          = ISNULL(SUM(s.IncludedBim),0),	   	
               BG_Franchise         = ISNULL(SUM(s.FranchisePrice),0),	   	
               BG_CompPrice         = ISNULL(SUM(s.CompPrice),0),	     	
               BG_CompSubsidyPrice  = ISNULL(SUM(s.CompSubsidyPrice),0),		
               BG_ExceptPrice       = ISNULL(SUM(s.ExceptionPrice),0)	,
               BG_DecPrice          = ISNULL(SUM(s.DecPrice),0)	,
               BG_FinalSickPrice	= ISNULL(SUM(s.ExceptionPrice+s.FranchisePrice-s.CompPrice-s.CompSubsidyPrice-s.DecPrice),0)		
        FROM   PatientDrugInfo AS  s	                     	
        WHERE      s.FileCode = @FileCode		
              AND (s.SickPrice + s.BimPrice <> 0)		
              AND   s.Bag IS NOT NULL		
    UNION ALL	
        SELECT BG_Count             = ISNULL(SUM(s.UseNum),0),		
               BG_SickPrice         = ISNULL(SUM(s.SickPrice),0),	   	
               BG_BimPrice          = ISNULL(SUM(s.BimPrice),0),	   	
               BG_Price             = ISNULL(SUM(s.ServicePrice),0),	   	
               BG_Included          = ISNULL(SUM(s.InsuranceIncluded),0),	   	
               BG_Franchise         = ISNULL(SUM(s.FranchisePrice),0),	   	
               BG_CompPrice         = ISNULL(SUM(s.CompPrice),0),	    	
               BG_CompSubsidyPrice  = ISNULL(SUM(s.CompSubsidyPrice),0),		
               BG_ExceptPrice       = ISNULL(SUM(s.ExceptionPrice),0),
               BG_DecPrice          = ISNULL(SUM(s.DecValue),0)	,
               BG_FinalSickPrice	= ISNULL(SUM(s.ExceptionPrice+s.FranchisePrice-s.CompPrice-s.CompSubsidyPrice-s.RelativePrice-s.DecValue),0)	
        FROM   PatientServiceInfo AS  s	                     	
        WHERE      s.FileCode = @FileCode		
              AND (s.SickPrice + s.BimPrice <> 0)		
              AND   s.Bag IS NOT NULL		
 			  )Kol
				
    END
  Else
       BEGIN ---’Ê—  Õ”«» »Ì„Â
  	  SELECT 	
               Sum(BG_Count) AS  BG_Count,           		
               Sum(BG_SickPrice) AS   BG_SickPrice,      	 	
               Sum(BG_BimPrice) AS  BG_BimPrice,        	   	
               Sum(BG_Price)     AS BG_Price,	   	
               Sum(BG_Included)  AS BG_Included,	   	
               Sum(BG_Franchise) AS BG_Franchise,	   	
               Sum(BG_CompPrice) AS  BG_CompPrice,       	     	
               Sum(BG_CompSubsidyPrice) AS  BG_CompSubsidyPrice,		
               Sum(BG_ExceptPrice) AS   BG_ExceptPrice  ,
               Sum(BG_DecPrice) AS   BG_DecPrice  ,
               Sum(BG_FinalSickPrice) AS  BG_FinalSickPrice	
                	
     FROM 	

      (  SELECT BG_Count            = ISNULL(SUM(s.UseUnitNum),0),		
               BG_SickPrice         = ISNULL(SUM(s.SickPrice),0),	   	
               BG_BimPrice          = ISNULL(SUM(s.BimPrice),0),	   	
               BG_Price             = ISNULL(SUM(s.DrugPrice),0),	   	
               BG_Included          = ISNULL(SUM(s.IncludedBim),0),	   	
               BG_Franchise         = ISNULL(SUM(s.FranchisePrice),0),	   	
               BG_CompPrice         = ISNULL(SUM(s.CompPrice),0),	     	
               BG_CompSubsidyPrice  = ISNULL(SUM(s.CompSubsidyPrice),0),		
               BG_ExceptPrice       = ISNULL(SUM(s.ExceptionPrice),0),
               BG_DecPrice          = ISNULL(SUM(s.DecPrice),0)	,
               BG_FinalSickPrice	= ISNULL(SUM(s.ExceptionPrice+s.FranchisePrice-s.CompPrice-s.CompSubsidyPrice-s.DecPrice),0)               
        FROM   PatientDrugInfo AS  s	                     	
        WHERE      s.FileCode = @FileCode		
              AND (s.SickPrice + s.BimPrice <> 0)
              AND (s.BimPrice>0 OR s.CompSubsidyPrice>0)		
              AND   s.Bag IS NOT NULL		
    UNION ALL	
        SELECT BG_Count             = ISNULL(SUM(s.UseNum),0),		
               BG_SickPrice         = ISNULL(SUM(s.SickPrice),0),	   	
               BG_BimPrice          = ISNULL(SUM(s.BimPrice),0),	   	
               BG_Price             = ISNULL(SUM(s.ServicePrice),0),	   	
               BG_Included          = ISNULL(SUM(s.InsuranceIncluded),0),	   	
               BG_Franchise          = ISNULL(SUM(s.FranchisePrice),0),	   	
               BG_CompPrice         = ISNULL(SUM(s.CompPrice),0),	    	
               BG_CompSubsidyPrice  = ISNULL(SUM(s.CompSubsidyPrice),0),		
               BG_ExceptPrice       = ISNULL(SUM(s.ExceptionPrice),0),	
               BG_DecPrice          = ISNULL(SUM(s.DecValue),0)	,
               BG_FinalSickPrice	= ISNULL(SUM(s.ExceptionPrice+s.FranchisePrice-s.CompPrice-s.CompSubsidyPrice-s.RelativePrice-s.DecValue),0)               	
        FROM   PatientServiceInfo AS  s	                     	
        WHERE      s.FileCode = @FileCode		
              AND (s.SickPrice + s.BimPrice <> 0)		
              AND (s.BimPrice>0 OR s.CompSubsidyPrice>0)		
              AND   s.Bag IS NOT NULL		
 			  )Kol

       END

      

END


 			  	

GO


