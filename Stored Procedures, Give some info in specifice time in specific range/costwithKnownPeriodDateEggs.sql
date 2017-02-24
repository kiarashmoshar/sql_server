USE [Chicken]
GO

/****** Object:  StoredProcedure [dbo].[costwithKnownPeriodDateEggs]    Script Date: 2/23/2017 11:18:32 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[costwithKnownPeriodDateEggs]
@startDate date,
@finisheddate date

as
select * from ProductionCostEstimatedate p
inner join productionUnitAction pua on pua.productionunitactioncode=p.productionunitaction
inner join costsegg cm on cm.idpce=p.IDPCE

where datep between @startDate and @finisheddate
GO


