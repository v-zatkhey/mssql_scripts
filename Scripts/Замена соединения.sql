/****** Сценарий для команды SelectTopNRows среды SSMS  ******/
SELECT [Правильный номер]
      ,[Старый номер]
      , p.Код_поставщика
      , p.Код_поставки
      , sp.Блок
  FROM [_tmp_Соответствие номеров] sn
	inner join tblПоставки p on p.ID = sn.[Старый номер]
	inner join tblСпектр sp on sp.Код_поставки = p.Код_поставки and sp.ID =  p.ID
 where sp.Тип_спектра = 'M'
 group by sn.[Правильный номер]
      ,sn.[Старый номер]
      , p.Код_поставщика
      , p.Код_поставки
      , sp.Блок
 order by sn.[Старый номер]
 
 
select * from  tblСпектр sp where Блок = 'M28952' and ID = 'F6681-8614'

SELECT [Правильный номер]
      ,[Старый номер]
      , ps.*
  FROM [_tmp_Соответствие номеров] sn
	inner join Materials p on p.MatName = sn.[Старый номер]
 	inner join tblПоставки ps on ps.ID = sn.[Старый номер]

 order by sn.[Старый номер]
 
 SELECT [Правильный номер]
      ,[Старый номер]
      , ps.Решение_по_поставке
      , ps.*
  FROM [_tmp_Соответствие номеров] sn
 	inner join tblПоставки ps on ps.ID = sn.[Старый номер]
 	where sn.[Старый номер] in ('F6681-8623','F6681-8625');

 --update ps set Решение_по_поставке = 8   FROM [_tmp_Соответствие номеров] sn  	inner join tblПоставки ps on ps.ID = sn.[Старый номер];

SELECT [Код]
      ,[Название_типа]
      ,[Комментарий]
      ,[Сортировка]
      ,[Visibled]
  FROM [Chest35].[dbo].[Типы_решений_по_поставкам]
GO

--23 00050-z01612
--25 00050-z01612


select * from tblЗаказы where Код_заказчика = '00050' and Код_заказа = 'z01612' -- 49299
select * from tblЗаказыПоставщикамСп1 where Поставщик = 'GER' and Пачка = 448 and ID in ('F6681-8623','F6681-8625')

select * from dbo.tblЗаказыСтатус
-- прописать в заказ поставщикам статус "принято"
--update t set Статус = 2 from tblЗаказыПоставщикамСп1 t where Поставщик = 'GER' and Пачка = 448 and ID in ('F6681-8623','F6681-8625');
