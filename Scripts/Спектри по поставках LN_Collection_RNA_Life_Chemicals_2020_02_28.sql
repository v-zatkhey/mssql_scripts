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


SELECT t.*, s.����, s.���������, s.[���������� ����������], YEAR(s.����_�������) as YEAR_����_�������, p.�����_���� as [�������], p.�������, r.��������_���� as �������_��_��������
  FROM _tmp_LN_Collection_RNA_Life_Chemicals_2020_02_28 t
	left join dbo.tbl�������� p on p.���_���������� +'-'+p.���_�������� = t.[Batch-3-5mg] and p.ID = t.IDNUMBER
	left join tbl������ s on s.���_tbl��������_rev = p.��� and s.���_������� in ('S','M','G')
	left join ����_�������_��_��������� r on r.��� = p.�������_��_��������
 ORDER BY cast(t.ID as int)
GO

exec sp_who active;