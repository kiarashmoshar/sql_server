USE [hospital]
GO

/****** Object:  StoredProcedure [dbo].[GetSickAllBim]    Script Date: 2/23/2017 10:45:40 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[GetSickAllBim] @FileCode INT, @DoTime DATETIME
As
Begin
 Select SB.BimCode             AS BimCode, 
        B.BimName              AS BimName, 
        CompBim.BimCode        As CompBimCode,
        CompSubsidyBim.BimCode AS CompSubsidyBimCode,
        SB.BimRatio            AS BimOpRatio                      
 From  SickBim SB INNER JOIN Bims B ON B.BimCode = SB.BimCode
  OUTER APPLY(SELECT Top 1 CBT.BimCode  FROM CompBimTreaty CBT WHERE CBT.FileCode = @FileCode And CBT.CompBimState = 2) AS CompBim
  OUTER APPLY(SELECT Top 1 CBT.BimCode  FROM CompBimTreaty CBT WHERE CBT.FileCode = @FileCode And CBT.CompBimState = 4) AS CompSubsidyBim 
   Where SB.FileCode = @FileCode And  
        (SB.ExpireBookTime > @DoTime Or  
         SB.ExpireBookTime Is Null) And		
		(SB.BeginTime <= @DoTime) And         
        (SB.EndTime >= @DoTime Or SB.EndTime Is Null)
End;



GO


