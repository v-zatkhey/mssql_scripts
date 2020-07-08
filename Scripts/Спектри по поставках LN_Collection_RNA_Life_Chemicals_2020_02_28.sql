SELECT [ID]
      ,[IDNUMBER]
      ,[STATE]
      ,[Availability]
      ,[PriceCoef]
      ,[BATCHES]
      ,[Batch-3-5mg]
      ,[Purity]
  FROM [Chest35].[dbo].[_tmp_LN_Collection_RNA_Life_Chemicals_2020_02_28]
GO


SELECT t.*, s.Блок, s.Результат, s.[Процентное содержание], YEAR(s.Дата_спектра) as YEAR_Дата_спектра, p.Масса_пост as [Остаток], p.Чистота, r.Название_типа as Решение_по_поставке
  FROM _tmp_LN_Collection_RNA_Life_Chemicals_2020_02_28 t
	left join dbo.tblПоставки p on p.Код_поставщика +'-'+p.Код_поставки = t.[Batch-3-5mg] and p.ID = t.IDNUMBER
	left join tblСпектр s on s.Код_tblПоставки_rev = p.Код and s.Тип_спектра in ('S','M','G')
	left join Типы_решений_по_поставкам r on r.Код = p.Решение_по_поставке
 ORDER BY cast(t.ID as int)
GO

exec sp_who active;