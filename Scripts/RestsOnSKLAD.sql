USE [SKLAD30]
GO

/****** Object:  View [dbo].[�������]    Script Date: 07/30/2020 21:49:17 ******/

select o.CAS
	, o.IDNUMBER0 as IDNumber 
	, s.ShortName as Store
	, o.�������
from [�������] o 
	inner join dbo.SKLAD30_������ s on s.��� = o.���_�
where o.���_� in (1,8)
	and o.������� > 0
order by  o.���_�, CAS ;