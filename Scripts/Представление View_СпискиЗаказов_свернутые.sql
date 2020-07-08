/* Для отчёта по складу Спектрум-Инфо в разрезе заказов за период */

USE Chest35;
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--Create 
ALTER VIEW [dbo].[View_СпискиЗаказов_свернутые]
AS
select x.Код_заказчика
	, x.Код_Заказа
	, sum(x.ID_Count) as ID_Count
	, case when sum(x.ID_Count)=1
		then MAX(max_ID)
		else '*'
		end as IDNUMBER
from
	(select  Код_заказчика, Код_Заказа
			, count(ID)  as ID_Count
			, MAX(ID) as max_ID
	from  tblВыполненныеЗаказы 
	group by Код_заказчика, Код_Заказа
	UNION ALL 
	select  Код_заказчика, Код_Заказа
			, count(ID)  as ID_Count
			, MAX(ID) as max_ID
	from tblСписокЗаказов
	group by Код_заказчика, Код_Заказа) x
group by x.Код_заказчика, x.Код_Заказа
GO

grant select on [dbo].[View_СпискиЗаказов_свернутые] to	  [Chest_Zakazi]
														, [Chest_Postavki]
														, [Chest_Wes_Chief]
														, [Chest50]
														, [Chest_Wesovschiki]
														, [Chest_public]
														, [Sklad30Chest]
														, [Chest_Admins]
														, [Chest_Otpravki]
														, [Chest_Rukovodstvo]
														, [Chest_Postavki_really];
go														
