USE [hospital]
GO

/****** Object:  StoredProcedure [dbo].[ShowTest]    Script Date: 2/23/2017 10:47:14 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



Create PROCEDURE [dbo].[ShowTest] @OrderCode Int,@GroupIndex Int, @SectionCoe INT,@TestTypeCode Int
As
BEGIN
IF(@TestTypeCode = 0)
BEGIN
	SELECT STT.TestType,
       S.ServiceName,
       S.ServiceCode,
       (
           SELECT TOP 1 MinValue
           FROM   TestSrvCalc
           WHERE  ServiceCode = S.ServiceCode
       )                         AS MinValue,
       Su.SubServiceCode,
       Su.ServiceName            AS SubServiceName,
       SO.RecordTime             AS OrderRecordTime,
       TR.KitCode,
       TR.Result,
       TR.RecordTime,
       ST.TestTypeCode,
       Us.NickName,
       ReqUS.NickName            AS ReqNickName,
       STT.InOrder,
       ST.InOrder,
       NST.InOrder,
       SO.UseWay,
       TR.RecordTime             AS ResTime,
       TR.UserCode,
       SO.Emergency,
       ISNULL(Su.TestOrder, 99)  AS TestOrder,
       TR.ReChecked
FROM   SrvTest                      ST,
       SrvTestType                  STT,
       
       SrvOrder SO INNER JOIN Services S ON S.ServiceCode = SO.ServiceCode
       LEFT OUTER JOIN UsersView ReqUS
            ON  SO.UserCode = ReqUS.UserCode
       LEFT OUTER JOIN (
                SELECT S2.ServiceName,
                       SS.SubServiceCode,
                       SS.ServiceCode,
                       SS.TestOrder
                FROM   Services S2
                       INNER JOIN SubSrv SS
                            ON  S2.ServiceCode = SS.SubServiceCode
            ) Su
       LEFT OUTER JOIN SrvTest NST
            ON  Su.SubServiceCode = NST.ServiceCode
            ON  SO.ServiceCode = Su.ServiceCode
       LEFT OUTER JOIN TestRes TR
       LEFT OUTER JOIN UsersView Us
            ON  TR.UserCode = Us.UserCode
            ON  SO.OrderCode = TR.OrderCode
            AND SO.GroupIndex = TR.GroupIndex
            AND SO.ServiceCode = TR.ServiceCode
            AND SO.RecordTime = TR.OrderRecordTime
            AND (
                    (
                        Su.SubServiceCode IS NULL
                        AND SO.ServiceCode = TR.SubServiceCode
                    )
                    OR Su.SubServiceCode = TR.SubServiceCode
                )
WHERE  SO.OrderCode = @OrderCode
       AND SO.GroupIndex = @GroupIndex
       AND SO.TargetSectionCode = @SectionCoe
       AND (
               (Su.ServiceCode IS NULL AND ST.ServiceCode = SO.ServiceCode)
               OR ST.ServiceCode = Su.ServiceCode
           )
       AND STT.TestTypeCode = ST.TestTypeCode   	
       Order By STT.InOrder, ST.InOrder,Su.TestOrder , NST.InOrder
END
ELSE
	BEGIN
	SELECT STT.TestType,
       S.ServiceName,
       S.ServiceCode,
       (
           SELECT TOP 1 MinValue
           FROM   TestSrvCalc
           WHERE  ServiceCode = S.ServiceCode
       )                         AS MinValue,
       Su.SubServiceCode,
       Su.ServiceName            AS SubServiceName,
       SO.RecordTime             AS OrderRecordTime,
       TR.KitCode,
       TR.Result,
       TR.RecordTime,
       ST.TestTypeCode,
       Us.NickName,
       ReqUS.NickName            AS ReqNickName,
       STT.InOrder,
       ST.InOrder,
       NST.InOrder,
       SO.UseWay,
       TR.RecordTime             AS ResTime,
       TR.UserCode,
       SO.Emergency,
       ISNULL(Su.TestOrder, 99)  AS TestOrder,
       TR.ReChecked
FROM   SrvTest                      ST,
       SrvTestType                  STT,       
       SrvOrder SO INNER JOIN Services S ON S.ServiceCode = SO.ServiceCode
       LEFT OUTER JOIN UsersView ReqUS
            ON  SO.UserCode = ReqUS.UserCode
       LEFT OUTER JOIN (
                SELECT S2.ServiceName,
                       SS.SubServiceCode,
                       SS.ServiceCode,
                       SS.TestOrder
                FROM   Services S2
                       INNER JOIN SubSrv SS
                            ON  S2.ServiceCode = SS.SubServiceCode
            ) Su
       LEFT OUTER JOIN SrvTest NST
            ON  Su.SubServiceCode = NST.ServiceCode
            ON  SO.ServiceCode = Su.ServiceCode
       LEFT OUTER JOIN TestRes TR
       LEFT OUTER JOIN UsersView Us
            ON  TR.UserCode = Us.UserCode
            ON  SO.OrderCode = TR.OrderCode
            AND SO.GroupIndex = TR.GroupIndex
            AND SO.ServiceCode = TR.ServiceCode
            AND SO.RecordTime = TR.OrderRecordTime
            AND (
                    (
                        Su.SubServiceCode IS NULL
                        AND SO.ServiceCode = TR.SubServiceCode
                    )
                    OR Su.SubServiceCode = TR.SubServiceCode
                )
WHERE  SO.OrderCode = @OrderCode
       AND SO.GroupIndex = @GroupIndex
       AND SO.TargetSectionCode = @SectionCoe
       AND (
               (Su.ServiceCode IS NULL AND ST.ServiceCode = SO.ServiceCode)
               OR ST.ServiceCode = Su.ServiceCode
           )
       AND STT.TestTypeCode = ST.TestTypeCode 
       And ST.TestTypeCode= @TestTypeCode
       Order By STT.InOrder, ST.InOrder,Su.TestOrder , NST.InOrder	
	END
	
END       
	

GO


