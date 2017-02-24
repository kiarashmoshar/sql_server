USE [Chicken]
GO

/****** Object:  StoredProcedure [dbo].[costwithKnownPeriodDatemeetsHazineJujeYekRuzeArborikerzAvg]    Script Date: 2/23/2017 11:20:00 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[costwithKnownPeriodDatemeetsHazineJujeYekRuzeArborikerzAvg]
@startDate date,
@finisheddate date
as
select avg(cms.[hazine juje yek ruze arborikerz]) as [مقدار متوسط هزینه جوجه یک روزه آربوریکرز در مرغ گوشتی] from ProductionCostEstimatedate p
inner join productionUnitAction pua on pua.productionunitactioncode=p.productionunitaction
inner join costsmeets cms on cms.idpce=p.IDPCE

where datep between @startDate and @finisheddate
GO


