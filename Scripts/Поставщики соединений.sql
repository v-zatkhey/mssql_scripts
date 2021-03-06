/****** Сценарий для выборки поставщиков веществ из списка  ******/
-- _tmp_Old_ID - таблица, содержащая F-номера веществ
--select * from _tmp_Old_ID

SELECT m.MatName
  , c.CustName
  , p.Фамилия + case when p.Имя IS not null then ' ' + p.Имя else '' end as CustomerName
  , MAX(mi.DateInsert) as maxDateInsert
FROM [Chest35].[dbo].[MaterialInfo] mi
	inner join Materials m on m.MatID = mi.MatID
	inner join [Customers] c on c.CustID = mi.CustID
	inner join _tmp_Old_ID t on t.ID = m.MatName
	left join dbo.tblПоставщики_full p on p.Код_поставщика = c.CustName
where mi.DateFailure is null 
	--and m.MatName in ('F0001-1307',
	--'F0110-0011',
	--'F0196-0029',
	--'F0196-0530',
	--'F0196-0870'
	--)	
group by m.MatName
      , c.CustName
      , p.Фамилия , p.Имя 
order by 1,2      
GO
