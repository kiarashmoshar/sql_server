USE [Chicken]
GO

/****** Object:  StoredProcedure [dbo].[costwithKnownPeriodDateEggsAzmayeshgaAvg]    Script Date: 2/23/2017 11:19:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[costwithKnownPeriodDateEggsAzmayeshgaAvg]
@startDate date,
@finisheddate date
as
select avg(ce.[azmayeshga]) as [مقدار متوسط آزمایشگاه در مرغ تخم گذار] from ProductionCostEstimatedate p
inner join productionUnitAction pua on pua.productionunitactioncode=p.productionunitaction
inner join costsEgg ce on ce.idpce=p.IDPCE

where p.dateP between @startDate and @finisheddate
GO


