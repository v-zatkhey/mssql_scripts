/****** Сценарий для команды SelectTopNRows среды SSMS  ******/

execute as login = 'SKLAD30'
select SYSTEM_USER ;
SELECT *
  FROM [SKLAD30].[dbo].[Chest35_Типы_спектров]
  
revert  