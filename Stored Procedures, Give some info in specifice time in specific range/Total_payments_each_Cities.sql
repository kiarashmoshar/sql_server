USE [Chicken]
GO

/****** Object:  StoredProcedure [dbo].[Total_payments_each_cities]    Script Date: 2/23/2017 11:20:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[Total_payments_each_cities]
@cityid int
as
select sum(p.payamount) as [Å—œ«Œ  ò· œ— «” «‰],Name from CityPartnerShipRecord cpr
inner join Cities c on c.CityId=cpr.CityId
inner join payments p on p.PersonId=cpr.PersonId
where cpr.CityId=@cityid
group by c.Name

GO


