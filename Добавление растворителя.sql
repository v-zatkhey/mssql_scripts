/*
Просьба для выборки растворителей блоков: S, R
Добавить 
CDCl3+TFA
*/

select * from tblТипы_спектров t where t.Тип in ('R','S')

/****** Сценарий для команды SelectTopNRows среды SSMS  ******/
SELECT TOP 1000 [Код]
      ,[Name]
      ,[Comments]
      ,[Category]
      ,[Sorting]
      ,[Тип]
  FROM [Chest35].[dbo].[tblВиды_Растворителей]
  where [Category]=1 and [Тип] in (1,7)
  order by [Тип], [Sorting]
  
  insert into [Chest35].[dbo].[tblВиды_Растворителей](Name,Comments,Category,Тип,Sorting)
  values ('CDCl3+TFA','CDCl3+TFA',1,1,130)
		,('CDCl3+TFA','CDCl3+TFA',1,7,130)
  