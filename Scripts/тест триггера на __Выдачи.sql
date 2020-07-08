select s.IDNUMBER0, s.CAS,p.Код_ID, p.Код_ID_вещества, v.* 
from __Выдачи v
	inner join __Приемка p on p.Код_ID = v.Код_ID_приемки
	inner join __Вещества s on s.Код_ID = p.Код_ID_вещества
where s.CAS = '811-98-3' -- in  ('811-98-3','1076-43-3','865-49-6')	
	and v.Код_ID_приемки in (38929,40322,36610,40321)
order by v.Дата desc

/*
 ([Код_пользователя], [Код_ID_Вещества], [CAS2], [ФИО], [Кол-во], [для SKB], [Ед_изм]
							  , [Код_ID_Источника], [Дата_end], [Примечание], [Session_ID], [Код_с], [для_Заказчика]
							  , [для_Заказа], [Условия_хранения]) 
*/

select top 10 c.Код_пользователя, p.Код_ID_вещества, null, pl.Название as [ФИО], 0 --, l.OrderQnt, p.UM 
	, null, null, 'заявка сформирована автоматически', v.Session_ID, v.Код_с, '00000'
	, null, s.Условия_хранения
	, v.*
--s.IDNUMBER0, s.CAS, p.Код_ID, p.Код_ID_поставки, p.Qty, p.Size, p.UM, v.Выдано
from  __Выдачи v
	inner join __Приемка p on p.Код_ID = v.Код_ID_приемки 
--	inner join LowerLimit l on l.StoreID = v.Код_с and l.SubstanceID = p.Код_ID_вещества
	inner join __Вещества s on s.Код_ID = p.Код_ID_вещества
	inner join Сессии c on c.Код = v.Session_ID
	inner join Пользователи pl on pl.Код = c.Код_пользователя
where p.Код_ID_вещества = 13290
order by v.Дата desc

select top 5 * from __Заявки where Код_ID_вещества = 13290
select top  * from __Заявки where для_Заказчика like  '%00000%'

select * from Пользователи where Код = 165
select * from Сессии where Код_пользователя = 165


select * from __Источники
SELECT [Код_ID]
      ,[Статус]
      ,[Сортировка]
  FROM [SKLAD30].[dbo].[__Заявки_Статусы]
GO

select top 20 * from __Заявки where Код_ID_вещества = 13290 and Статус < 50

select *
from  __Вещества s 
where s.CAS in ('811-98-3','1076-43-3','865-49-6')	

select *
from  Склады s 

select Выдано, * from  __Выдачи v where v.Код_ID = 150526;
update  v set Выдано = Выдано from __Выдачи v where v.Код_ID = 150526;

		select c.Код_пользователя, p.Код_ID_вещества, null, pl.Название as [ФИО]
			, 0, l.OrderQnt, p.UM 
			, 'заявка сформирована автоматически', v.Session_ID, v.Код_с, '00000'
			, s.Условия_хранения
		from  __Выдачи v
			inner join __Приемка p on p.Код_ID = v.Код_ID_приемки 
			inner join LowerLimit l on l.StoreID = v.Код_с and l.SubstanceID = p.Код_ID_вещества
			inner join __Вещества s on s.Код_ID = p.Код_ID_вещества
			inner join Сессии c on c.Код = v.Session_ID
			inner join Пользователи pl on pl.Код = c.Код_пользователя
			left join
				( select pr.Код_с as StoreID, p.[Код_ID_вещества] as SubstanceID, sum(p.[Остаток_0]) as Qnt
				  from [Остатки_по_Приемкам] p
					inner join __Приемка pr on pr.Код_ID = p.Код_ID
				  where [Остаток_0]<>0
				  group by p.[Код_ID_вещества], pr.Код_с)x on x.SubstanceID = l.SubstanceID and l.StoreID = x.StoreID
		where v.Код_ID = 150526
			and l.LimitQnt > isnull(x.Qnt,0)
			and not exists(	select * from [__Заявки] z 
							where z.Код_с = v.Код_с 
									and z.Код_ID_Вещества = p.Код_ID_вещества
									and z.Статус < 50
							)