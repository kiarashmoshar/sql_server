USE [hospital]
GO

/****** Object:  StoredProcedure [dbo].[GetPatientSickOp]    Script Date: 2/23/2017 10:44:38 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetPatientSickOp]  
(
 	@FileCode INT,
	@IsGlobal INT,
	@BillBim BIT,
	@Act2kForIsGlobal INT = 1
)

AS
BEGIN

  IF (@BillBim =0) 
	BEGIN---ÕæÑÊ ÍÓÇÈ ÈíãÇÑ
            	          SELECT 
                                 JaPrice,  
                                 JaIncluded,  
                                 JaSickPrice,  
                                 JaBimPrice,  
                                 jaFranchis,  
                                 JaFullTimePrice,  
                                 JaFullTimeGeographiPrice,  
                                 JaPreferentialPrice,  
                                 JaCompPrice,  
                                 JaCompSubsidyPrice,  
                                 JaRelataive,  
                                 JaFinalSickPrice  ,  
                                 jaException ,

                                 JaHelpPrice,  
                                 JaHelpIncluded,  
                                 JaHelpSickPrice,  
                                 JaHelpBimPrice,  
                                 JaHelpFranchis,  
                                 JaHelpFullTimePrice,  
                                 JaHelpFullTimeGeographiPrice,  
                                 JaHelpPreferentialPrice,  
                                 JaHelpCompPrice,  
                                 JaHelpCompSubsidyPrice,  
                                 JaHelpRelataive,  
                                 JaHelpFinalSickPrice  ,  
                                 JaHelpException ,

                                 BiPrice + isnull(TadPrice,0) AS BiPrice,  
                                 BiIncluded +ISNULL(TadIncluded,0) AS  BiIncluded    ,  
                                 BiSickPrice +ISNULL(TadSickPrice,0) AS  BiSickPrice    ,  
                                 BiBimPrice + ISNULL(TadBimPrice,0) AS   BiBimPrice    ,  
                                 BiFranchis+ISNULL(TadFranchis,0) AS  BiFranchis    ,  
                                 BiFullTimePrice+ISNULL(TadFullTimePrice,0) AS BiFullTimePrice     ,  
                                 BiFullTimeGeographiPrice+ ISNULL(TadFullTimeGeographiPrice,0) AS BiFullTimeGeographiPrice     ,  
                                 BiPreferentialPrice+ISNULL(TadPreferentialPrice,0) AS  BiPreferentialPrice    ,  
                                 BiCompPrice+ISNULL(TadCompPrice,0) AS    BiCompPrice  ,  
                                 BiCompSubsidyPrice+ISNULL(TadCompSubsidyPrice,0) AS   BiCompSubsidyPrice   ,  
                                 BiRelataive+ ISNULL(TadRelataive,0) AS  BiRelataive     ,  
                                 BiFinalSickPrice  + ISNULL(TadFinalSickPrice,0) AS  BiFinalSickPrice    ,  
                                 BiException +ISNULL(TadException,0) AS   BiException   ,

                                 JaTechPrice,  
                                 JaTechIncluded,  
                                 JaTechSickPrice,  
                                 JaTechBimPrice,  
                                 JaTechFranchis,  
                                 JaTechCompPrice,  
                                 JaTechCompSubsidyPrice,  
                                 JaTechRelataive,  
                                 JaTechFinalSickPrice  ,  
                                 JaTechException 

                 
               FROM   Adm A  
            	         
                      OUTER APPLY(  
                   SELECT
                   
						  SUM(ot.TadPrice) TadPrice,
                          SUM(OT.IncludeBim  )  TadIncluded,  
						  SUM(OT.BimPrice  )  TadBimPrice,  
						  SUM(OT.Franchis  )  TadFranchis, 
						  SUM(OT.FullTimePrice  )  TadFullTimePrice,  
						  SUM(OT.FullTimeGeographiPrice  )  TadFullTimeGeographiPrice,  
						  SUM(OT.PrefrentialPrice  )  TadPreferentialPrice,  
                          SUM(OT.SickPrice ) TadSickPrice,  
						  SUM(ot.CompPrice) TadCompPrice,
						  SUM(ot.CompSubsidyPrice) TadCompSubsidyPrice,
						  SUM(ot.RelativeValue) TadRelataive,
                          SUM(ot.TadPrice-ot.BimPrice-ot.CompPrice-ot.CompSubsidyPrice-ot.RelativeValue) AS TadFinalSickPrice  ,  
                          SUM(ot.Exception)  TadException  
                   FROM   PatientTadInfo AS OT 
                   WHERE  OT.FileCode = a.FileCode
                  AND ( OT.BimPrice +ot.SickPrice>0) 
               )  AS Tad  
               
               OUTER APPLY (  
                   SELECT 

						  Sum(o.JaPrice)			AS JaPrice,  
                          Sum(o.JaInsuranceIncluded)   AS JaIncluded,  
                          Sum(o.JaSickPrice)		AS JaSickPrice,  
                          Sum(o.JaBimPrice)	     	AS JaBimPrice,  
						  Sum(o.jaFranchis)		    AS jaFranchis,  
                          Sum(o.JaFullTimePrice)	     	AS JaFullTimePrice,  
                          Sum(o.JaFullTimeGeographiPrice)	     	AS JaFullTimeGeographiPrice,  
                          Sum(o.JaPreferentialPrice)	     	AS JaPreferentialPrice,  
                          Sum(o.JaCompPrice)		AS  JaCompPrice,  
                          Sum(o.JaCompSubsidyPrice) AS  JaCompSubsidyPrice,  
                          Sum(o.JaRelataive)		AS  JaRelataive,  
                          SUM(o.JaPrice-o.JaBimPrice-o.JaCompPrice-o.JaCompSubsidyPrice-o.JaRelataive) AS JaFinalSickPrice  ,  
                          Sum(o.jaException) AS jaException ,

                          Sum(o.JaHelpPrice)			AS JaHelpPrice,  
                          Sum(o.jaHelpFranchis)		    AS jaHelpFranchis,  
                          Sum(o.JaHelpSickPrice)		AS JaHelpSickPrice,  
                          Sum(o.JaHelpBimPrice)	     	AS JaHelpBimPrice,  
                          Sum(o.JaHelpInsuranceIncluded)	     	AS JaHelpIncluded, 
                          Sum(o.JaHelpFullTimePrice)	     	AS JaHelpFullTimePrice,  
                          Sum(o.JaHelpFullTimeGeographiPrice)	     	AS JaHelpFullTimeGeographiPrice,  
                          Sum(o.JaHelpPreferentialPrice)	     	AS JaHelpPreferentialPrice,  
                          Sum(o.JaHelpCompPrice)		AS  JaHelpCompPrice,  
                          Sum(o.JaHelpCompSubsidyPrice) AS  JaHelpCompSubsidyPrice,  
                          Sum(o.JaHelpRelataive)		AS  JaHelpRelataive,  
                          SUM(o.JaHelpPrice-o.JaHelpBimPrice-o.JaHelpCompPrice-o.JaHelpCompSubsidyPrice-o.JaHelpRelataive) AS JaHelpFinalSickPrice  ,  
                          Sum(o.jaHelpException) AS jaHelpException ,

						  SUM(o.BiPrice+o.BiHelpPrice) BiPrice,                  
                          SUM(o.BiInsuranceIncluded+o.BiHelpInsuranceIncluded)   AS BiIncluded,  
                          SUM(o.BiBimPrice+o.BiHelpBimPrice)   AS BiBimPrice,  
                          SUM(o.BiSickPrice+o.BiHelpSickPrice)  AS BiSickPrice, 
						  SUM(o.BiFullTimePrice+o.BiHelpFullTimePrice)  AS BiFullTimePrice, 
						  SUM(o.BiFullTimeGeographiPrice+o.BiHelpFullTimeGeographiPrice)  AS BiFullTimeGeographiPrice, 
						  SUM(o.BiPreferentialPrice+o.BiHelpPreferentialPrice)  AS BiPreferentialPrice, 
						  SUM(o.BiFranchis+o.BiHelpFranchis) BiFranchis,
						  SUM(o.BiCompPrice+o.BiHelpCompPrice) BiCompPrice,
						  SUM(o.BiCompSubsidyPrice+o.BiHelpCompSubsidyPrice) BiCompSubsidyPrice,
						  SUM(o.BiRelataive+o.BiRelataive) BiRelataive,
					      SUM(o.BiPrice+o.BiHelpPrice-o.BiBimPrice-o.BiHelpBimPrice-o.BiCompPrice-o.BiHelpCompPrice- o.BiCompSubsidyPrice-o.BiHelpCompSubsidyPrice-o.BiRelataive-o.BiHelpRelataive) AS BiFinalSickPrice  ,  
                          SUM(o.BiException+o.BiHelpException)  BiException ,
                  	
                          Sum(o.JaTechnicalPrice) AS JaTechPrice ,
                          SUM(o.JaTechInsuranceIncluded) AS  JaTechIncluded ,
                          Sum(o.JaTechnicalBimPrice) AS JaTechBimPrice,
						  Sum(o.jaTechFranchis) AS jaTechFranchis,  
                          Sum(o.JaTechCompPrice) AS JaTechCompPrice ,  
                          Sum(o.JaTechCompSubsidyPrice) AS  JaTechCompSubsidyPrice,  
                          Sum(o.JaTechnicalSickPrice) AS JaTechSickPrice,  
                          Sum(o.jaTechException) AS  jaTechException,  
                          Sum(o.JaTechRelataive) AS  JaTechRelataive,  
                          Sum(o.JaTechnicalPrice-o.JaTechnicalBimPrice-o.JaTechRelataive-o.JaTechCompSubsidyPrice-o.JaTechCompPrice) AS JaTechFinalSickPrice, 
						    max( gr.RowNO )  AS RowNO
						
      			   FROM PatientOpInfo AS o LEFT JOIN GlOpRows gr ON gr.OpCode = o.OpCode
			      	 Where o.Filecode= a.FileCode
			      	 AND O.JaPrice>0		
                 )  AS oP  
                 
            	          WHERE a.FileCode=@FileCode
        END   	 
     Else
       BEGIN ---ÕæÑÊ ÍÓÇÈ Èíãå
            	          SELECT 
                                 JaPrice,  
                                 JaIncluded,  
                                 JaSickPrice,  
                                 JaBimPrice,  
                                 jaFranchis,  
                                 JaFullTimePrice,  
                                 JaFullTimeGeographiPrice,  
                                 JaPreferentialPrice,  
                                 JaCompPrice,  
                                 JaCompSubsidyPrice,  
                                 JaRelataive,  
                                 JaFinalSickPrice  ,  
                                 jaException ,


                                 JaHelpPrice,  
                                 JaHelpIncluded,  
                                 JaHelpSickPrice,  
                                 JaHelpBimPrice,  
                                 JaHelpFranchis,  
                                 JaHelpFullTimePrice,  
                                 JaHelpFullTimeGeographiPrice,  
                                 JaHelpPreferentialPrice,  
                                 JaHelpCompPrice,  
                                 JaHelpCompSubsidyPrice,  
                                 JaHelpRelataive,  
                                 JaHelpFinalSickPrice  ,  
                                 JaHelpException ,

                                 BiPrice + isnull(TadPrice,0) AS BiPrice,  
                                 BiIncluded +isnull(TadIncluded,0) AS  BiIncluded    ,  
                                 BiSickPrice +isnull(TadSickPrice,0) AS  BiSickPrice    ,  
                                 BiBimPrice + isnull(TadBimPrice,0) AS   BiBimPrice    ,  
                                 BiFranchis+isnull(TadFranchis,0) AS  BiFranchis    ,  
                                 BiFullTimePrice+isnull(TadFullTimePrice,0) AS BiFullTimePrice     ,  
                                 BiFullTimeGeographiPrice+ isnull(TadFullTimeGeographiPrice,0) AS BiFullTimeGeographiPrice     ,  
                                 BiPreferentialPrice+isnull(TadPreferentialPrice,0) AS  BiPreferentialPrice    ,  
                                 BiCompPrice+ISNULL(TadCompPrice,0) AS    BiCompPrice  ,  
                                 BiCompSubsidyPrice+ISNULL(TadCompSubsidyPrice,0) AS   BiCompSubsidyPrice   ,  
                                 BiRelataive+ isnull(TadRelataive,0) AS  BiRelataive     ,  
                                 BiFinalSickPrice  + isnull(TadFinalSickPrice,0) AS  BiFinalSickPrice    ,  
                                 BiException +isnull(TadException,0) AS   BiException   ,

                                 JaTechPrice,  
                                 JaTechIncluded,  
                                 JaTechSickPrice,  
                                 JaTechBimPrice,  
                                 JaTechFranchis,  
                                 JaTechCompPrice,  
                                 JaTechCompSubsidyPrice,  
                                 JaTechRelataive,  
                                 JaTechFinalSickPrice  ,  
                                 JaTechException 

                 
               FROM   Adm A  
                      OUTER APPLY(  
                   SELECT
                   
						  SUM(ot.TadPrice) TadPrice,
                          SUM(OT.IncludeBim  )  TadIncluded,  
						  SUM(OT.BimPrice  )  TadBimPrice,  
						  SUM(OT.Franchis  )  TadFranchis, 
						  SUM(OT.FullTimePrice  )  TadFullTimePrice,  
						  SUM(OT.FullTimeGeographiPrice  )  TadFullTimeGeographiPrice,  
						  SUM(OT.PrefrentialPrice  )  TadPreferentialPrice,  
                          SUM(OT.SickPrice ) TadSickPrice,  
						  SUM(ot.CompPrice) TadCompPrice,
						  SUM(ot.CompSubsidyPrice) TadCompSubsidyPrice,
						  SUM(ot.RelativeValue) TadRelataive,
                          SUM(ot.TadPrice-ot.BimPrice-ot.CompPrice-ot.CompSubsidyPrice-ot.RelativeValue) AS TadFinalSickPrice  ,  
                          SUM(ot.Exception)  TadException  
                   FROM   PatientTadInfo AS OT 
                   WHERE  OT.FileCode = A.FileCode
                  AND ( OT.BimPrice >0  OR ot.CompSubsidyPrice>0) 
               )  AS Tad  
               
               OUTER APPLY (  
                   SELECT 

						  Sum(o.JaPrice)			AS JaPrice,  
                          Sum(o.JaInsuranceIncluded)   AS JaIncluded,  
                          Sum(o.JaSickPrice)		AS JaSickPrice,  
                          Sum(o.JaBimPrice)	     	AS JaBimPrice,  
						  Sum(o.jaFranchis)		    AS jaFranchis,  
                          Sum(o.JaFullTimePrice)	     	AS JaFullTimePrice,  
                          Sum(o.JaFullTimeGeographiPrice)	     	AS JaFullTimeGeographiPrice,  
                          Sum(o.JaPreferentialPrice)	     	AS JaPreferentialPrice,  
                          Sum(o.JaCompPrice)		AS  JaCompPrice,  
                          Sum(o.JaCompSubsidyPrice) AS  JaCompSubsidyPrice,  
                          Sum(o.JaRelataive)		AS  JaRelataive,  
                          SUM(o.JaPrice-o.JaBimPrice-o.JaCompPrice-o.JaCompSubsidyPrice-o.JaRelataive) AS JaFinalSickPrice  ,  
                          Sum(o.jaException) AS jaException ,

                          Sum(o.JaHelpPrice)			AS JaHelpPrice,  
                          Sum(o.jaHelpFranchis)		    AS jaHelpFranchis,  
                          Sum(o.JaHelpSickPrice)		AS JaHelpSickPrice,  
                          Sum(o.JaHelpBimPrice)	     	AS JaHelpBimPrice,  
                          Sum(o.JaHelpInsuranceIncluded)	     	AS JaHelpIncluded, 
                          Sum(o.JaHelpFullTimePrice)	     	AS JaHelpFullTimePrice,  
                          Sum(o.JaHelpFullTimeGeographiPrice)	     	AS JaHelpFullTimeGeographiPrice,  
                          Sum(o.JaHelpPreferentialPrice)	     	AS JaHelpPreferentialPrice,  
                          Sum(o.JaHelpCompPrice)		AS  JaHelpCompPrice,  
                          Sum(o.JaHelpCompSubsidyPrice) AS  JaHelpCompSubsidyPrice,  
                          Sum(o.JaHelpRelataive)		AS  JaHelpRelataive,  
                          SUM(o.JaHelpPrice-o.JaHelpBimPrice-o.JaHelpCompPrice-o.JaHelpCompSubsidyPrice-o.JaHelpRelataive) AS JaHelpFinalSickPrice  ,  
                          Sum(o.jaHelpException) AS jaHelpException ,

						  SUM(o.BiPrice+o.BiHelpPrice) BiPrice,                  
                          SUM(o.BiInsuranceIncluded+o.BiHelpInsuranceIncluded)   AS BiIncluded,  
                          SUM(o.BiBimPrice+o.BiHelpBimPrice)   AS BiBimPrice,  
                          SUM(o.BiSickPrice+o.BiHelpSickPrice)  AS BiSickPrice, 
						  SUM(o.BiFullTimePrice+o.BiHelpFullTimePrice)  AS BiFullTimePrice, 
						  SUM(o.BiFullTimeGeographiPrice+o.BiHelpFullTimeGeographiPrice)  AS BiFullTimeGeographiPrice, 
						  SUM(o.BiPreferentialPrice+o.BiHelpPreferentialPrice)  AS BiPreferentialPrice, 
						  SUM(o.BiFranchis+o.BiHelpFranchis) BiFranchis,
						  SUM(o.BiCompPrice+o.BiHelpCompPrice) BiCompPrice,
						  SUM(o.BiCompSubsidyPrice+o.BiHelpCompSubsidyPrice) BiCompSubsidyPrice,
						  SUM(o.BiRelataive+o.BiRelataive) BiRelataive,
					      SUM(o.BiPrice+o.BiHelpPrice-o.BiBimPrice-o.BiHelpBimPrice-o.BiCompPrice-o.BiHelpCompPrice- o.BiCompSubsidyPrice-o.BiHelpCompSubsidyPrice-o.BiRelataive-o.BiHelpRelataive) AS BiFinalSickPrice  ,  
                          SUM(o.BiException+o.BiHelpException)  BiException ,
                  	
                          Sum(o.JaTechnicalPrice) AS JaTechPrice ,
                          SUM(o.JaTechInsuranceIncluded) AS  JaTechIncluded ,
                          Sum(o.JaTechnicalBimPrice) AS JaTechBimPrice,
						  Sum(o.jaTechFranchis) AS jaTechFranchis,  
                          Sum(o.JaTechCompPrice) AS JaTechCompPrice ,  
                          Sum(o.JaTechCompSubsidyPrice) AS  JaTechCompSubsidyPrice,  
                          Sum(o.JaTechnicalSickPrice) AS JaTechSickPrice,  
                          Sum(o.jaTechException) AS  jaTechException,  
                          Sum(o.JaTechRelataive) AS  JaTechRelataive,  
                          Sum(o.JaTechnicalPrice-o.JaTechnicalBimPrice-o.JaTechRelataive-o.JaTechCompSubsidyPrice-o.JaTechCompPrice) AS JaTechFinalSickPrice, 
						    max( gr.RowNO )  AS RowNO
						
      			   FROM PatientOpInfo AS o LEFT JOIN GlOpRows gr ON gr.OpCode = o.OpCode
			      	 Where o.Filecode= a.FileCode
			      	  AND ( o.JaBimPrice >0  OR o.JaCompSubsidyPrice>0) 
                 )  AS oP  
            	          WHERE a.FileCode=@FileCode

     
  END     

END




GO


