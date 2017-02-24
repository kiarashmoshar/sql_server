USE [hospital]
GO

/****** Object:  StoredProcedure [dbo].[UpdateDoctKRatio]    Script Date: 2/23/2017 10:47:40 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[UpdateDoctKRatio] @DoctorCode Int,@StartTime DATETIME,@EndTime DATETIME
As
BEGIN
	
 UPDATE DoctSrv
  SET DoctSrv.FullTimeRatio = CASE WHEN IsNull(NF.[State],2) <> 2  THEN 1 ELSE IsNull(DR.FullTimeRatio,1)  +  IsNull(AddRatio.AddedRatio,0) END,
      DoctSrv.FullTimeGeographicRatio = CASE WHEN IsNull(NF.[State],1) <> 1  THEN 1 ELSE IsNull(DR.FullTimeGeographicRatio,1)  END
      
 From DoctSrv DS 
      Inner Join SickSrv SS ON DS.ServiceID = SS.ServiceID 
      OUTER APPLY(SELECT TOP 1 DR.FullTimeRatio,
                              DR.FullTimeGeographicRatio 
                  FROM DoctKRatio DR
                  WHERE DR.DoctorCode = DS.DoctorCode AND 
                        SS.DoTime BETWEEN DR.BeginDate AND DR.EndDate ) AS DR 
      Outer Apply (Select Top 1 State 
                   From NotFullTimeSrv  
                            Where  SectionCode = SS.SectionCode   And  
                                   ServiceCode = SS.ServiceCode  And  
                                   BimCode = DS.BimCode) As NF 
      Outer Apply(Select Top 1 BAR.AddedRatio From 
                         BimDrAddRatio BAR where BAR.DoctorCode = DS.DoctorCode And BAR.BimCode = DS.BimCode) AS AddRatio                                      
      Where SS.DoTime Between @StartTime  And @EndTime And 
            DS.DoctorCode = @DoctorCode;
            
 UPDATE OPSurg
   SET OPSurg.FullTimeRatio = CASE WHEN IsNull(NF.[State],2) <> 2  THEN 1 ELSE IsNull(DR.FullTimeRatio,1)  +  IsNull(AddRatio.AddedRatio,0) END,
       OPSurg.FullTimeGeographicRatio = CASE WHEN IsNull(NF.[State],1) <> 1  THEN 1 ELSE IsNull(DR.FullTimeGeographicRatio,1)  END
  From SickOP SO 
       Inner Join OPSurg OS ON OS.OperCode = SO.OperCode 
       Inner Join SckOEtr SOE ON SOE.EnterORoomCode = SO.EnterORoomCode
       Outer Apply (Select Top 1 IsNull(SB.BimCode,1) AS BimCode 
                          From  SickBim SB 
                           Where SB.FileCode = SOE.FileCode And  
                                 ( IsNull(SB.ExpireBookTime,SO.StartTime + 1) > SO.StartTime ) And  
                                 ( SB.BeginTime <= SO.StartTime ) And  
                                 ( IsNull(SB.EndTime,SO.StartTime) >= SO.StartTime ) ) SB  

      OUTER APPLY(SELECT TOP 1 DR.FullTimeRatio,DR.FullTimeGeographicRatio 
                   FROM DoctKRatio DR WHERE DR.DoctorCode = OS.DoctorCode AND 
                         SO.StartTime BETWEEN DR.BeginDate AND DR.EndDate ) AS DR 
      OUTER APPLY(Select Top 1 State From NoFullTimeOp 
                        Where BimCode = SB.BimCode And OpCode = SO.OpCode And IsGlobal = SO.IsGlobal ) As NF
    
      OUTER APPLY(Select Top 1 BAR.AddedRatio From 
                         BimDrAddRatio BAR where BAR.DoctorCode = OS.DoctorCode And BAR.BimCode = SB.BimCode) AS AddRatio                        
                                                   
     Where SO.StartTime Between @StartTime  And @EndTime
	       And OS.DoctorCode = @DoctorCode     
	       
 UPDATE OPMbi
    SET OPMbi.FullTimeRatio = IsNull(DR.FullTimeRatio,1) + IsNull(DoctAddedRatio.AddedRatio,0),
        OPMbi.FullTimeGeographicRatio = IsNull(DR.FullTimeGeographicRatio,1)
   
    From SickBi SBI 
          Inner Join OPMbi OM ON OM.BiCode = SBI.BiCode 
          Inner Join SckOEtr SOE ON SOE.EnterORoomCode = SBI.EnterORoomCode
          Outer Apply (Select IsNull(SB.BimCode,1) AS BimCode 
                        From  SickBim SB 
                         Where SB.FileCode = SOE.FileCode And  
                             ( SB.ExpireBookTime > SBI.StartTime Or  
                               SB.ExpireBookTime Is Null) And  
                            SB.BeginTime <= SBI.StartTime And  
                            (SB.EndTime >= SBI.StartTime Or  
                             SB.EndTime Is Null)) SB  
     OUTER APPLY(SELECT TOP 1 DR.FullTimeRatio,DR.FullTimeGeographicRatio 
                   FROM DoctKRatio DR WHERE DR.DoctorCode = OM.DoctorCode AND 
                         SBI.StartTime BETWEEN DR.BeginDate AND DR.EndDate ) AS DR 
     OUTER APPLY(Select Top 1 BAR.AddedRatio From 
                         BimDrAddRatio BAR where BAR.DoctorCode = OM.DoctorCode And BAR.BimCode = SB.BimCode) As DoctAddedRatio                           

   Where  SBI.StartTime Between @StartTime And @EndTime And 
          OM.DoctorCode =   @DoctorCode	              
End;




GO


