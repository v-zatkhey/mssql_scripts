USE [SKLAD30]
GO

/****** Object:  View [dbo].[Остатки]    Script Date: 07/30/2020 21:49:17 ******/

select o.CAS
	, o.IDNUMBER0 as IDNumber 
	, s.ShortName as Store
	, o.Остаток
from [Остатки] o 
	inner join dbo.SKLAD30_Склады s on s.Код = o.Код_с
where o.Код_с in (1,8)
	and o.Остаток > 0
order by  o.Код_с, CAS ;