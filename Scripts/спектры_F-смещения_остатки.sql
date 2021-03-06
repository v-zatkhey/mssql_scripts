/****** Сценарий для команды SelectTopNRows среды SSMS  ******/
SELECT s.[Код]
      , s.[ID]
      ,[Блок]
      ,[Дата_спектра]
      , m.MW_without_Salt
      , f.Value
      , v.Масса
  FROM [Chest35].[dbo].[tblСпектр] s 
		inner join [Chest35].dbo.[tbl_Фторные_сдвиги] f on f.Kod_Spectra = s.[Код]
		inner join [Chest35].dbo.Materials m on m.MatName = s.[ID]
		left join [Chest35].dbo.tblСклад  v on v.ID = s.[ID]
  where [Тип_спектра]= 'F'
	and [Дата_спектра]>= '20180101'
	--and [Блок]='F00581'
  order by  4,3