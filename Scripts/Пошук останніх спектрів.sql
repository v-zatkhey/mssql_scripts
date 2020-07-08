--delete from [_tmp_List_z305] where N = ''

SELECT t.[N] as Code
      ,t.[IDNUMBER]
      ,s.[Блок]
      ,t.[Код_поставщика]
      ,t.[Код_поставки]
      ,s.Дата
      ,s.Результат 
  FROM [Chest35].[dbo]._tmp_List_z305 t
	left join tblСпектр s on s.ID = t.IDNUMBER 
							and t.[Код_поставщика] = s.[Код_поставщика] 
							and t.[Код_поставки] = s.[Код_поставки] 
							and s.Тип_спектра_Код = 1
	inner join (
				SELECT t.[N]
					  ,t.[IDNUMBER]
					  ,t.[Блок]
					  ,t.[Код_поставщика]
					  ,t.[Код_поставки]
					  , max(s.Дата) as SpDate
				  FROM [Chest35].[dbo]._tmp_List_z305 t
					left join tblСпектр s on s.ID = t.IDNUMBER 
											and t.[Код_поставщика] = s.[Код_поставщика] 
											and t.[Код_поставки] = s.[Код_поставки] 
											and s.Тип_спектра_Код = 1	
					group by t.[N]
					  ,t.[IDNUMBER]
					  ,t.[Блок]
					  ,t.[Код_поставщика]
					  ,t.[Код_поставки]	
				) x	on 	x.IDNUMBER = t.IDNUMBER 
						and t.[Код_поставщика] = x.[Код_поставщика] 
					    and t.[Код_поставки] = x.[Код_поставки]
					    and x.SpDate = s.Дата  	
	where s.Результат = 'OK'					    			
GO


