USE [hospital]
GO

/****** Object:  StoredProcedure [dbo].[GetOpAssistantPrice]    Script Date: 2/23/2017 10:42:09 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create PROCEDURE [dbo].[GetOpAssistantPrice]  @FileCode INT,@BimCode INT
As
Begin
 Select 
   HelpJaPrice = Case When So.ISGlobal = 1 Then 
                           (OS.Ratio * (Case When SO.BimOpRatio = 0 Then 0  
                                              Else SO.JaBimValue/SO.BimOpRatio  
                                         End)) 
                          Else 
                          (OS.Ratio * (SO.JaUnit * SO.JaUnitPrice * SO.JaRatio)) End
   ,SO.OpCode,SO.BimOpRatio, 
   ISNULL((SELECT SHT.SubsidyRatio FROM SubsidyHealthBimOpType SHT 
             WHERE SHT.OpCode = SO.OpCode AND SHT.IsGlobal = SO.IsGlobal And SHT.BimCode =  SB.BimCode ),SHB.SubsidyRatio) SubsidyRatio 

  From  OpSurg OS 
        Inner Join SickOP  SO  On SO.OperCode = OS.OperCode
        Inner Join SckOEtr SE  On SE.EnterORoomCode = SO.EnterORoomCode 
        Inner Join SickBim SB  On SB.FileCode  = SE.FileCode And 
                                  SB.BimCode   = @BimCode And                               
                                  ((So.StartTime Between  SB.BeginTime And SB.EndTime) OR 
                                  (So.StartTime >= SB.BeginTime And SB.EndTime IS Null)) 
        LEFT JOIN SubsidyHealthBim SHB ON SHB.BimCode = SB.BimCode 
    Where  SO.BimOPRatio > 0 And 
           (SO.BiSickValue+SO.BiBimValue+SO.JaSickValue+SO.JaBimValue) <> 0 And  
           SE.FileCode = @FileCode And            
           Os.Ratio < (Select Max(Ratio) From OPSurg 
                        Where OperCode = OS.OperCode) 
     Order By SO.OpCode 
End;   
GO


