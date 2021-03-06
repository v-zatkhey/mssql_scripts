/****** Сценарий для команды SelectTopNRows среды SSMS  ******/
SELECT TOP 1000 [Код]
      ,[ActionID]
      ,[TableID]
      ,[TableKodID]
      ,[IDNUMBER_old]
      ,[IDNUMBER_new]
      ,[DOC_old]
      ,[DOC_new]
      ,[DateTime_]
      ,[User_]
      ,[Fields_]
      ,[SortID]
  FROM [Chest35].[dbo].[TableLogs]
  
  select COUNT(*) from [Chest35].[dbo].[TableLogs] -- 162187188
  where -- [IDNUMBER_old]!= [IDNUMBER_new] -- 117
		[DOC_old]!= [DOC_new] -- 14418


  select YEAR([DateTime_]), COUNT(*) 
  from [Chest35].[dbo].[TableLogs] 
  group by YEAR([DateTime_])
		