--delete from [_tmp_List_z305] where N = ''

SELECT t.[N] as Code
      ,t.[IDNUMBER]
      ,s.[����]
      ,t.[���_����������]
      ,t.[���_��������]
      ,s.����
      ,s.��������� 
  FROM [Chest35].[dbo]._tmp_List_z305 t
	left join tbl������ s on s.ID = t.IDNUMBER 
							and t.[���_����������] = s.[���_����������] 
							and t.[���_��������] = s.[���_��������] 
							and s.���_�������_��� = 1
	inner join (
				SELECT t.[N]
					  ,t.[IDNUMBER]
					  ,t.[����]
					  ,t.[���_����������]
					  ,t.[���_��������]
					  , max(s.����) as SpDate
				  FROM [Chest35].[dbo]._tmp_List_z305 t
					left join tbl������ s on s.ID = t.IDNUMBER 
											and t.[���_����������] = s.[���_����������] 
											and t.[���_��������] = s.[���_��������] 
											and s.���_�������_��� = 1	
					group by t.[N]
					  ,t.[IDNUMBER]
					  ,t.[����]
					  ,t.[���_����������]
					  ,t.[���_��������]	
				) x	on 	x.IDNUMBER = t.IDNUMBER 
						and t.[���_����������] = x.[���_����������] 
					    and t.[���_��������] = x.[���_��������]
					    and x.SpDate = s.����  	
	where s.��������� = 'OK'					    			
GO


