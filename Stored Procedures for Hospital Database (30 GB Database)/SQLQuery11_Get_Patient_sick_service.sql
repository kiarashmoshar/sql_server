USE [hospital]
GO

/****** Object:  StoredProcedure [dbo].[GetPatientSickSrv]    Script Date: 2/23/2017 10:45:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[GetPatientSickSrv]
	@FileCode INT,
	@IsGlobal INT,
	@BillBim BIT,
	@SrvType VARCHAR(5),
	@Act2kForIsGlobal INT = 1
AS
BEGIN

  IF (@BillBim =0) 
	BEGIN---’Ê—  Õ”«» »Ì„«—
       
        IF (@SrvType ='Bed') 
			BEGIN
				 SELECT       
			       ServiceGroupCode= ROW_NUMBER() Over( Order By s.ServiceName ) ,
				    
				    GroupCount = SUM(CASE  WHEN ((@IsGlobal  = 1) AND (OGS.ServiceCode IS NOT NULL)) OR (@IsGlobal  <> 1) THEN
                       s.UseNum ELSE 0 END),
					   ServicePrice =SUM(s.ServicePrice),
					   IncludedBim =SUM(s.InsuranceIncluded),
                       SickPrice = sum(s.PortableSickPrice+s.SickPrice-s.CompPrice-s.CompSubsidyPrice-s.RelativePrice),
                       BimPrice = sum(s.PortableBimPrice+s.BimPrice),
                       FranchisePrice = sum(s.FranchisePrice),
                       CompPrice = sum(s.CompPrice),
                       CompSubsidyPrice = sum(s.CompSubsidyPrice),
                       ExceptPrice =  sum(s.ExceptionPrice),
                       s.ServiceName ServiceName,
                       DecRelativePrice = SUM(s.RelativePrice),
                       PriceWithExcep = Sum(s.ServicePrice)
                 FROM  PatientServiceInfo  s
                 LEFT JOIN OverGlSrv AS ogs ON ogs.ServiceCode = s.ServiceCode
                 WHERE s.FileCode = @FileCode
                   And ( s.BimPrice+s.PortableBimPrice+s.SickPrice+s.PortableSickPrice) <> 0
                   And s.ServiceGroupCode  IN (9)
                 Group BY  s.ServiceName
                 
			END
        IF (@SrvType ='Srv') 
			BEGIN
				 SELECT    
	    	 	       s.ServiceGroupCode            AS ServiceGroupCode, 
					   s.ServiceGroupName            AS ServiceGroup, 			       
					   GroupCount = SUM(CASE  WHEN ((@IsGlobal  = 1) AND (OGS.ServiceCode IS NOT NULL)) OR (@IsGlobal  <> 1) THEN
                       s.UseNum ELSE 0 END),
					   ServicePrice =SUM(s.ServicePrice),
					   IncludedBim =SUM(s.InsuranceIncluded),
                       SickPrice = sum(s.PortableSickPrice+s.SickPrice-s.CompPrice-s.CompSubsidyPrice-s.RelativePrice),
                       BimPrice = sum(s.PortableBimPrice+s.BimPrice),
                       FranchisePrice = sum(s.FranchisePrice),
                       CompPrice = sum(s.CompPrice),
                       CompSubsidyPrice = sum(s.CompSubsidyPrice),
                       ExceptPrice =  sum(s.ExceptionPrice),
                       DecRelativePrice = SUM(s.RelativePrice),
                       PriceWithExcep = Sum(s.ServicePrice)
                 FROM  PatientServiceInfo  s
                 LEFT JOIN OverGlSrv AS ogs ON ogs.ServiceCode = s.ServiceCode
                 WHERE s.FileCode = @FileCode
                   And ( s.BimPrice+s.PortableBimPrice+s.SickPrice+s.PortableSickPrice) <> 0
				   AND   s.ServiceGroupCode IN (1 , 2, 3, 4, 5, 6, 7, 8,  12, 13, 16 ,17, 18, 19, 26)
                 Group BY  
                    s.ServiceGroupCode,     
					   s.ServiceGroupName  
			END

        IF (@SrvType ='Other') 
			BEGIN
				 SELECT       
	    	 	       s.ServiceCode            AS ServiceGroupCode, 
					   s.ServiceName            AS ServiceName, 			       
				       GroupCount = SUM(CASE  WHEN ((@IsGlobal  = 1) AND (OGS.ServiceCode IS NOT NULL)) OR (@IsGlobal  <> 1) THEN
                       s.UseNum ELSE 0 END),
					   ServicePrice =SUM(s.ServicePrice),
					   IncludedBim =SUM(s.InsuranceIncluded),
                       SickPrice = sum(s.PortableSickPrice+s.SickPrice-s.CompPrice-s.CompSubsidyPrice-s.RelativePrice),
                       BimPrice = sum(s.PortableBimPrice+s.BimPrice),
                       FranchisePrice = sum(s.FranchisePrice),
                       CompPrice = sum(s.CompPrice),
                       CompSubsidyPrice = sum(s.CompSubsidyPrice),
                       ExceptPrice =  sum(s.ExceptionPrice),
                       DecRelativePrice = SUM(s.RelativePrice),
                       PriceWithExcep = Sum(s.ServicePrice)
                 FROM  PatientServiceInfo  s
                 LEFT JOIN OverGlSrv AS ogs ON ogs.ServiceCode = s.ServiceCode
                 WHERE s.FileCode = @FileCode
                   And ( s.BimPrice+s.PortableBimPrice+s.SickPrice+s.PortableSickPrice) <> 0
      			   AND   s.ServiceGroupCode NOT IN (1 , 2, 3, 4, 5, 6, 7, 8,9,  12, 13, 16 ,17, 18, 19, 26)
           Group BY  
					s.ServiceCode,
					 s.ServiceName  ,
                       s.ServiceGroupCode,     
  					   s.ServiceGroupName  
  					   union all
		 SELECT       
	          
               ROW_NUMBER() OVER (ORDER BY oc.RecordTime)           AS ServiceGroupCode, 
              oc.Caption       AS ServiceName, 	  
              1                AS GroupCount,  
			isnull(OC.CostSickValue,0)+ISNULL(OC.CostBimValue,0) AS  ServicePrice,	
			CASE WHEN CostBimValue>0 THEN  isnull(CostBimValue,0)+ isnull(CostSickValue,0)   ELSE 0 END   IncludedBim,     
             isnull( OC.CostSickValue,0)- isnull(OC.SubsidyValue,0)- isnull(OC.CompValue,0)  AS SickPrice,  
              OC.CostBimValue  AS BimPrice,  
			CASE   When OC.CostBimValue > 0 Then OC.CostSickValue  
                  Else 0
                 END    AS FranchisePrice,
              isnull(OC.CompValue,0)     AS CompPrice,  
              ISNULL( OC.SubsidyValue,0)  AS CompSubsidyPrice,        
              ExceptPrice = Case  
                  When OC.CostBimValue > 0 Then 0  
                  Else OC.CostSickValue  
                 End,
              0                As DecRelativePrice,     
          
		      isnull(OC.CostSickValue,0)+ISNULL(OC.CostBimValue,0) AS  PriceWithExcep   
    
       FROM   OtherCst OC  
       WHERE  OC.FileCode = @FileCode  
              AND OC.IsCost = 1 
	       ORDER BY ServiceGroupCode ASc
  					     					   
          
     		END

         
        END   	 
     Else
       BEGIN ---’Ê—  Õ”«» »Ì„Â
       
        IF (@SrvType ='Bed') 
			BEGIN
				 SELECT       
			       ServiceGroupCode= ROW_NUMBER() Over( Order By s.ServiceName ) ,
				    GroupCount = SUM(CASE  WHEN ((@IsGlobal  = 1) AND (OGS.ServiceCode IS NOT NULL)) OR (@IsGlobal  <> 1) THEN
                       s.UseNum ELSE 0 END),
					   ServicePrice =SUM(s.ServicePrice),
					   IncludedBim =SUM(s.InsuranceIncluded),
                       SickPrice = sum(s.PortableSickPrice+s.SickPrice-s.CompPrice-s.CompSubsidyPrice-s.RelativePrice),
                       BimPrice = sum(s.PortableBimPrice+s.BimPrice),
                       CompPrice = sum(s.CompPrice),
                       CompSubsidyPrice = sum(s.CompSubsidyPrice),
                       ExceptPrice =  sum(s.ExceptionPrice),
                       s.ServiceName SrvName,
                       DecRelativePrice = SUM(s.RelativePrice),
                       KDoctorPrice = SUM(s.FullTimePrice),
                       KGDoctorPrice = SUM(s.FullTimeGeographiPrice),
                       PrfDrPrice = SUM(s.PreferentialPrice)
                 FROM  PatientServiceInfo  s
                 LEFT JOIN OverGlSrv AS ogs ON ogs.ServiceCode = s.ServiceCode
                 WHERE s.FileCode = @FileCode
                   And ( s.BimPrice+s.PortableBimPrice>0 OR s.CompSubsidyPrice>0 ) 
                   And s.ServiceGroupCode  IN (9)
                 Group BY  s.ServiceName
                 
			END
        IF (@SrvType ='Srv') 
			BEGIN
				 SELECT       
	    	 	       s.ServiceGroupCode            AS ServiceGroupCode, 
					   s.ServiceGroupName            AS ServiceGroup, 			       
				       GroupCount = SUM(CASE  WHEN ((@IsGlobal  = 1) AND (OGS.ServiceCode IS NOT NULL)) OR (@IsGlobal  <> 1) THEN
                       s.UseNum ELSE 0 END),
					   ServicePrice =SUM(s.ServicePrice),
					   IncludedBim =SUM(s.InsuranceIncluded),
                       SickPrice = sum(s.PortableSickPrice+s.SickPrice),
                       BimPrice = sum(s.PortableBimPrice+s.BimPrice),
                       CompPrice = sum(s.CompPrice),
                       CompSubsidyPrice = sum(s.CompSubsidyPrice),
                       ExceptPrice =  sum(s.ExceptionPrice),
                       DecRelativePrice = SUM(s.RelativePrice),
                       KDoctorPrice = SUM(s.FullTimePrice),
                       KGDoctorPrice = SUM(s.FullTimeGeographiPrice),
                       PrfDrPrice = SUM(s.PreferentialPrice)
                 FROM  PatientServiceInfo  s
                 LEFT JOIN OverGlSrv AS ogs ON ogs.ServiceCode = s.ServiceCode
                 WHERE s.FileCode = @FileCode
                   And ( s.BimPrice+s.PortableBimPrice>0 OR s.CompSubsidyPrice>0 ) 
				   AND   s.ServiceGroupCode IN (1 , 2, 3, 4, 5, 6, 7, 8,  12, 13, 16 ,17, 18, 19, 26)
            Group BY  
                       s.ServiceGroupCode,     
  					   s.ServiceGroupName  
                 
			END

        IF (@SrvType ='Other') 
			BEGIN
				 SELECT       
	    	 	       s.ServiceCode            AS ServiceGroupCode, 
					   s.ServiceName            AS SrvName, 			       
				       GroupCount = SUM(CASE  WHEN ((@IsGlobal  = 1) AND (OGS.ServiceCode IS NOT NULL)) OR (@IsGlobal  <> 1) THEN
                       s.UseNum ELSE 0 END),
					   ServicePrice =SUM(s.ServicePrice),
					   IncludedBim =SUM(s.InsuranceIncluded),
                       SickPrice = sum(s.PortableSickPrice+s.SickPrice),
                       BimPrice = sum(s.PortableBimPrice+s.BimPrice),
                       CompPrice = sum(s.CompPrice),
                       CompSubsidyPrice = sum(s.CompSubsidyPrice),
                       ExceptPrice =  sum(s.ExceptionPrice),
                       DecRelativePrice = SUM(s.RelativePrice),
                       KDoctorPrice = SUM(s.FullTimePrice),
                       KGDoctorPrice = SUM(s.FullTimeGeographiPrice),
                       PrfDrPrice = SUM(s.PreferentialPrice)
                 FROM  PatientServiceInfo  s
                 LEFT JOIN OverGlSrv AS ogs ON ogs.ServiceCode = s.ServiceCode
                 WHERE s.FileCode = @FileCode
                   And ( s.BimPrice+s.PortableBimPrice>0 OR s.CompSubsidyPrice>0 ) 
      			   AND   s.ServiceGroupCode NOT IN (1 , 2, 3, 4, 5, 6, 7, 8,9,  12, 13, 16 ,17, 18, 19, 26)
           Group BY  
                      s.ServiceCode,
                      s.ServiceName,
                       s.ServiceGroupCode,     
  					   s.ServiceGroupName  
     		END

  END     

END




GO


