USE [hospital]
GO

/****** Object:  StoredProcedure [dbo].[GetAllBimBi]    Script Date: 2/23/2017 10:37:46 PM ******/
/*Kiarash Moshar*/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetAllBimBi] @FileCode Int,@IsGlobal Int, @BimOpRatio Float
As
Begin
 SELECT A.FileCode,
        Tad.TadBimValue,
        Tad.TadAllBimValue - Tad.TadBimValue As TadSickValue,
        Tad.TadExceptValue,
        Tad.FullTimeTadUnitPrice,
        Tad.FullTimeGogTadUnitPrice,
        Tad.BiTime,
        Tad.TadFranshisSickValue,
        Tad.TadAllBimValue,
        Tad.TadAllBimValueOverGL -  Tad.TadBimValueOverGL As TadSickValueOverGL ,  
        Tad.TadBimValueOverGL,
        Tad.TadAllBimValueOverGL,
        Bi.OpBiBimValue,
        Bi.OpBiSickValue,
        Bi.OPBiExceptValue,
        Bi.FullTimeOpBiPrice,
        Bi.OpBiAllBimValue,
        Bi.OpBiFranshizSickValue,
       Bi.FullTimeGogOpBiPrice
 FROM   Adm A
       OUTER APPLY
          (SELECT 
                   SUM(CASE WHEN (@IsGlobal = 0)  THEN OT.BimValue END )  TadBimValue,
                  
                   SUM(CASE WHEN (@IsGlobal = 0)  THEN
		                (Case When @BimOpRatio>0 Then OT.BimValue/@BimOpRatio Else 0 End) END ) TadAllBimValue,

                   SUM(CASE WHEN (@IsGlobal = 0) THEN
		              (Case When @BimOpRatio>0 Then OT.BimValue/@BimOpRatio - OT.BimValue Else 0 End) END )  TadFranshisSickValue,
                       
                    SUM(CASE WHEN (@IsGlobal = 1 AND TT.State = 1) THEN
		                (Case When @BimOpRatio>0 Then OT.BimValue Else 0 End) END ) TadBimValueOverGL, 	
		                          
                   SUM(CASE WHEN (@IsGlobal = 1 AND TT.State = 1) THEN
		                (Case When @BimOpRatio>0 Then OT.BimValue/@BimOpRatio Else 0 End) END ) TadAllBimValueOverGL,                       

                   TadExceptValue = SUM(CASE WHEN OT.BimValue = 0 THEN OT.SickValue ELSE 0 END),
                 
				   SUM(Case When (@IsGlobal = 0) OR ((@IsGlobal = 1) AND TT.[STATE] = 1)
				                  Then OT.TadValue * OT.BiUnitPrice * OM.Ratio * (OM.FullTimeRatio -1) End) AS FullTimeTadUnitPrice,
                 
				   SUM(Case When (@IsGlobal = 0) OR ((@IsGlobal = 1) AND TT.[STATE] = 1)
				    Then OT.TadValue * OT.BiUnitPrice * OM.Ratio * (OM.FullTimeGeographicRatio -1) End)  AS FullTimeGogTadUnitPrice,
                
                   BiTime = SUM(CASE WHEN TT.TadCode = 1 THEN OT.TadValue END)
              FROM   OpTad OT
                     INNER JOIN TadType TT    ON  TT.TadCode = OT.TadCode
                     INNER JOIN SickBi SB     ON  SB.BiCode = OT.BiCode
                     INNER JOIN SckOEtr SO    ON  SO.EnterORoomCode = SB.EnterORoomCode
                     LEFT OUTER JOIN OpMBi OM ON  OM.BiCode = SB.BiCode
              WHERE  SO.FileCode = A.FileCode And OT.BimValue>0
          )  AS Tad

 OUTER APPLY
        ( SELECT      SUM(SP.BiBimValue)   AS OpBiBimValue,
                      SUM(SP.BiSickValue)  AS OpBiSickValue,
                      SUM(CASE WHEN SP.BimOpRatio = 0 THEN SP.BiBimValue ELSE 0 END)         As OPBiExceptValue,
	   				  SUM(Case When SP.BimOpRatio >0 Then SP.BiBimValue/SP.BimOpRatio End)   AS OpBiAllBimValue,
                      SUM(Case When SP.BimOpRatio >0 Then SP.BiBimValue/SP.BimOpRatio
					                                                   - SP.BiBimValue End)  AS OpBiFranshizSickValue,


					  SUM( (CASE WHEN NBI.OpCode IS NULL THEN 1 ELSE 0 END ) *
					  	   SP.BiUnit * SP.BiUnitPrice * SP.BiRatio *
                           OM.Ratio * (OM.FullTimeRatio -1) )  AS FullTimeOpBiPrice,

                      SUM( SP.BiUnit * SP.BiUnitPrice * SP.BiRatio *
                           OM.Ratio * (OM.FullTimeGeographicRatio -1) )  AS FullTimeGogOpBiPrice
                           
               FROM   SickOp SP
                       INNER JOIN SckOEtr SO      ON  SO.EnterORoomCode = SP.EnterORoomCode
                       LEFT OUTER JOIN SickBi SB  ON  SB.EnterORoomCode = SO.EnterORoomCode
                       LEFT OUTER JOIN OpMBi OM   ON  OM.BiCode = SB.BiCode
                       LEFT OUTER JOIN NotFullTimeBi NBI ON NBI.OpCode = SP.OpCode AND NBI.IsGlobal = SP.IsGlobal 
                    WHERE  SO.FileCode = A.FileCode And SP.BimOpRatio>0
        )  AS Bi
 WHERE  A.FileCode = @FileCode
End;




GO


