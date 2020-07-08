SELECT [ID]
      ,[Масса] as Mass
      , YEAR( z.Дата) as Yr
	, COUNT(*) as Cnt	
  FROM [Chest35].[dbo].[tblВыполненныеЗаказы] v
	inner join dbo.tblЗаказы z on z.Код_заказчика = v.Код_заказчика and z.Код_заказа = v.Код_заказа
  WHERE ID like 'F1957%'
	and  z.Дата > '20170101'
	and v.Масса >= 250
	and z.Код_заказчика <> '00122'
  GROUP by 	[ID]
      ,[Масса]
      , YEAR( z.Дата)
  order by 	[ID], YEAR( z.Дата)
GO

SELECT [ID]
      ,[Масса] as Mass
      , YEAR( z.Дата) as Yr
	, COUNT(*) as Cnt	
  FROM [Chest35].[dbo].[tblВыполненныеЗаказы] v
	inner join dbo.tblЗаказы z on z.Код_заказчика = v.Код_заказчика and z.Код_заказа = v.Код_заказа
  WHERE ID like 'F1957%'
	and  z.Дата > '20170101'
	and v.Масса >= 250
	and z.Код_заказчика = '00122'
  GROUP by 	[ID]
      ,[Масса]
      , YEAR( z.Дата)
  order by 	[ID], YEAR( z.Дата)
GO
