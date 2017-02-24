USE [hospital]
GO

/****** Object:  StoredProcedure [dbo].[Azm_Sel_Ins_NotSavePaziresh]    Script Date: 2/23/2017 10:35:46 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






create procedure [dbo].[Azm_Sel_Ins_NotSavePaziresh]---peymani
  @UserCode int
as
----- bims khadamat 517 roze 2 be bad -------------                                       
select distinct ap.filecode into #paziresazm2 from AdmPara ap 
                         inner join Adm a1 on a1.FileCode=ap.FileCode and a1.AdmitTypeCode=1 
                         inner join SickBim sb on sb.FileCode=ap.FileCode 
                         inner join bims b on b.BimCode=sb.BimCode 
                         where b.BimGroupCode =1 and ap.SectionCode=12 and DATEDIFF(DAY, ap.BeginTime,GETDATE())=0
                         and ap.FileCode in
                         (select ss.FileCode  from SickSrv ss where ss.FileCode =ap.FileCode 
                                  and ss.ServiceCode =699 and DATEDIFF(DAY, ss.DoTime ,GETDATE())<>0)      
                          and ap.FileCode not in 
                          ((select ss.FileCode  from SickSrv ss where ss.FileCode =ap.FileCode 
                                  and ss.ServiceCode =517  and DATEDIFF(DAY, ss.DoTime ,GETDATE())=0))        
DECLARE tempcur2 CURSOR FOR
select filecode from #paziresazm2 
OPEN tempcur2;
declare @tempfilecode2 int;
FETCH NEXT FROM tempcur2 into @tempfilecode2
WHILE @@FETCH_STATUS = 0
   BEGIN
      declare @MAxSer2 int;
      select @MAxSer2=max(a.ServiceID) from SickSrv a
      insert into SickSrv (FileCode,ServiceCode,DoTime,OrderRecordTime,OrderCode,SectionCode,UserCode,PersonelCode,UseNum,
                       UnitNum,UnitPrice,BimValue,SickValue,DecValue,AllocBedTime,BimRatio,DoStateCode,ServiceID) 
             values (@tempfilecode2,517,GETDATE(),GETDATE(),null,12,2147483647,1,1,1,dbo.GetSrvPrice(517),dbo.GetSrvPrice(517) * dbo.GetSickSrvBimRatio(@tempfilecode2, 517)
                     ,dbo.GetSrvPrice(517) - (dbo.GetSrvPrice(517) * dbo.GetSickSrvBimRatio(@tempfilecode2, 517)),0,GETDATE(),
                     dbo.GetSickSrvBimRatio(@tempfilecode2, 517),null,@MAxSer2+1)
      FETCH NEXT FROM tempcur2 into @tempfilecode2
   END;
CLOSE tempcur2;
DEALLOCATE tempcur2;                         

------------- bims not khadamat 699 roz 1 ----------------                         
--select distinct ap.filecode into #paziresazm4 from AdmPara ap 
--                        inner join Adm a1 on a1.FileCode=ap.FileCode and a1.AdmitTypeCode=1 
--                        inner join SickBim sb on sb.FileCode=ap.FileCode 
--                        inner join bims b on b.BimCode=sb.BimCode 
--                         where b.BimGroupCode  in (3,4) and ap.SectionCode=12 and DATEDIFF(DAY, ap.BeginTime,GETDATE())=0
--                         and ap.FileCode not in
--                         (select ss.FileCode  from SickSrv ss where ss.FileCode =ap.FileCode and ss.ServiceCode =699 )
--                         and ap.FileCode in (select ss.FileCode  from SickSrv ss inner join Services s on ss.ServiceCode=s.ServiceCode 
--                                              and s.ServiceGroupCode=1 where DATEDIFF(DAY, ss.OrderRecordTime,GETDATE())=0)
--DECLARE tempcur4 CURSOR FOR
--select filecode from #paziresazm4 
--OPEN tempcur4;
--declare @tempfilecode4 int;
--FETCH NEXT FROM tempcur4 into @tempfilecode4
--WHILE @@FETCH_STATUS = 0
--   BEGIN
--      declare @MAxSer4 int;
--      select @MAxSer4=max(a.ServiceID) from SickSrv a
--      insert into SickSrv (FileCode,ServiceCode,DoTime,OrderRecordTime,OrderCode,SectionCode,UserCode,PersonelCode,UseNum,
--                       UnitNum,UnitPrice,BimValue,SickValue,DecValue,AllocBedTime,BimRatio,DoStateCode,ServiceID) 
--             values (@tempfilecode4,699,GETDATE(),GETDATE(),null,12,2147483647,1,1,1,dbo.GetSrvPrice(699),dbo.GetSrvPrice(699)
--                     ,0 ,0,GETDATE(),dbo.GetSickSrvBimRatio(@tempfilecode4, 699),null,@MAxSer4+1)
--      FETCH NEXT FROM tempcur4 into @tempfilecode4
--   END;
--CLOSE tempcur4;
--DEALLOCATE tempcur4;

----------- bims not khadamat 699 ----------------                         
select distinct ap.filecode into #paziresazm3 from AdmPara ap 
                        inner join Adm a1 on a1.FileCode=ap.FileCode and a1.AdmitTypeCode=1 
                        inner join SickBim sb on sb.FileCode=ap.FileCode 
                        inner join bims b on b.BimCode=sb.BimCode 
                         where b.BimGroupCode  in (3,4) and ap.SectionCode=12 and DATEDIFF(DAY, ap.BeginTime,GETDATE())=0
                         and ap.FileCode not in
                         (select ss.FileCode  from SickSrv ss where ss.FileCode =ap.FileCode and ss.ServiceCode =699 and DATEDIFF(DAY, ap.BeginTime,GETDATE())=0)
                         and ap.FileCode in (select ss.FileCode  from SickSrv ss inner join Services s on ss.ServiceCode=s.ServiceCode 
                                              and s.ServiceGroupCode=1 where DATEDIFF(DAY, ss.OrderRecordTime,GETDATE())=0)
DECLARE tempcur3 CURSOR FOR
select filecode from #paziresazm3 
OPEN tempcur3;
declare @tempfilecode3 int;
FETCH NEXT FROM tempcur3 into @tempfilecode3
WHILE @@FETCH_STATUS = 0
   BEGIN
      declare @MAxSer3 int;
      select @MAxSer3=max(a.ServiceID) from SickSrv a
      insert into SickSrv (FileCode,ServiceCode,DoTime,OrderRecordTime,OrderCode,SectionCode,UserCode,PersonelCode,UseNum,
                       UnitNum,UnitPrice,BimValue,SickValue,DecValue,AllocBedTime,BimRatio,DoStateCode,ServiceID) 
             values (@tempfilecode3,699,GETDATE(),GETDATE(),null,12,2147483647,1,1,1,dbo.GetSrvPrice(699),0
                     ,dbo.GetSrvPrice(699) ,0,GETDATE(),
                     dbo.GetSickSrvBimRatio(@tempfilecode3, 699),null,@MAxSer3+1)
      FETCH NEXT FROM tempcur3 into @tempfilecode3
   END;
CLOSE tempcur3;
DEALLOCATE tempcur3;




GO


