use Chest35;
go

-- first import scaffold data into _tmp_Skaffold
-- then:
/*
insert into tblScaffold(Code,Decision)
select IDNUMBER, Decision 
from dbo._tmp_Skaffold
order by IDNUMBER
*/
go

--не вказано хіміка. навіть віртуального.
select s.*, t.Chemist, t.Other_Chemists, p.Код, p.Код_поставщика, p.Фамилия, p.Имя, p.Отчество, p.Email
from tblScaffold s
	inner join _tmp_Skaffold t on t.IDNUMBER = s.Code
	left join tblПоставщики_full p on t.Chemist like '%'+p.Код_поставщика+'%' or t.Other_Chemists like '%'+p.Код_поставщика+'%'
where p.Код is null and t.Chemist != 'Virtual'
	
SELECT [Код]
      ,[Код_поставщика]
      ,[Категория]
      ,[Отчет]
      ,[Фамилия]
      ,[Имя]
      ,[Отчество]
      ,[Обращение]
      ,[РабочийТелефон]
      ,[ВторойТелефон]
      ,[ВнутреннийТелефон]
      ,[ДомашнийТелефон]
      ,[Факс]
      ,[Email]
      ,[Страна]
      ,[Индекс]
      ,[Область]
      ,[Город]
      ,[УлицаДомКвартира]
      ,[Примечание]
  FROM [Chest35].[dbo].[tblПоставщики_full]
GO

--не вказано email
select --s.*, t.Chemist, t.Other_Chemists, p.Код, 
	distinct p.Код_поставщика, p.Фамилия, p.Имя, p.Отчество, p.Email, COUNT(*)
from tblScaffold s
	inner join _tmp_Skaffold t on t.IDNUMBER = s.Code
	inner join tblПоставщики_full p on t.Chemist like '%'+p.Код_поставщика+'%' or t.Other_Chemists like '%'+p.Код_поставщика+'%'
where 	p.Email is null
group by p.Код_поставщика, p.Фамилия, p.Имя, p.Отчество, p.Email
order by COUNT(*) desc
--update 	[tblПоставщики_full] set [Email] = 'Alexandr.Mandzhulo@lifechemicals.com' where [Код] = 291;

-- додаємо зв'язки з хіміками
/*
insert into dbo.tblScaffoldChemist(ScaffoldID,ChemistID)
select s.ID, p.Код
from tblScaffold s
	inner join _tmp_Skaffold t on t.IDNUMBER = s.Code
	inner join tblПоставщики_full p on t.Chemist like '%'+p.Код_поставщика+'%' or t.Other_Chemists like '%'+p.Код_поставщика+'%'
where not exists(select * from tblScaffoldChemist where ScaffoldID = s.ID and ChemistID = p.Код)
*/

select s.Code, c.Код_поставщика, c.Фамилия, c.Имя, c.Отчество 
from tblScaffold s
	left join tblScaffoldChemist sc on sc.ScaffoldID = s.ID
	left join tblПоставщики_full c on c.Код = sc.ChemistID
order by  s.Code desc