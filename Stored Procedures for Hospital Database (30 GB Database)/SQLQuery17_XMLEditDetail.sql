USE [hospital]
GO

/****** Object:  StoredProcedure [dbo].[XMLEditDetail2]    Script Date: 2/23/2017 10:48:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[XMLEditDetail2]
	@WhereStr NVARCHAR(Max),
	@GruopStr NVARCHAR(Max)

AS
BEGIN
	EXEC ('ALTER View AllParaOpSrvDetailView AS Select Top 100 Percent '+
		'  dbo.GetXmlSrvBimCode(LSV.FileCode, LSV.OpServiceCode, SB.BeginTime, GetDate() ) AS  ' 
       + '       ServiceCode, ' 
       + '       SUM(LSV.UseNum) UseNum, ' 
       + '       0 AS RequestdNum, ' 
       + '       SUM(LSV.UnitNum) UnitNum, ' 
       + '       LSV.UnitPrice, ' 
       + '       SUM(LSV.SickValue) AS SickValue, ' 
       + '       Sum(LSV.BimValue)  AS BimValue, ' 
       + '       SUM(LSV.FullTimeGeographicPrice ) AS FullTimeGeographicPrice, ' 
       + '       SUM(LSV.FullTimePrice ) AS  FullTimePrice ,' 
       + '       (SUM(LSV.FullTimePrice ) +  SUM(LSV.FullTimeGeographicPrice ) + SUM(LSV.BimPrice)) AS AllPrice,'        
       + '       SUM(LSV.BimPrice) AS BimPrice, ' 
       + '       SUM(LSV.BimValue + (ISNULL(LSV.FullTimePrice , 0 ) * B.KRatio) + (IsNull(LSV.FullTimeGeographicPrice,0) * B.KRatio) )   AS SBimValue, ' 
       + '       LSV.OpServiceGroupCode ServiceGroupCode,        ' 
       + '       LSV.BimRatio, ' 
       + '       SUM(LSV.UnitPrice + LSV.UseNum + LSV.UnitNum) + SUM(LSV.FullTimeGeographicPrice ) + SUM(LSV.FullTimePrice )   AS MP, ' 
       + '       B.BimOpRatio ,' 
       + '       LSV.OrderRecordTime '         

   +' From SickOpSrvDetails LSV '+
        ' Inner Join SickBim SB On SB.FileCode = LSV.FileCode '+
               ' Inner Join Bims     B On B.BimCode   = SB.BimCode ' + @WhereStr + @GruopStr 
	     )
END;


GO


