SELECT [ID]
      ,[�����] as Mass
      , YEAR( z.����) as Yr
	, COUNT(*) as Cnt	
  FROM [Chest35].[dbo].[tbl�����������������] v
	inner join dbo.tbl������ z on z.���_��������� = v.���_��������� and z.���_������ = v.���_������
  WHERE ID like 'F1957%'
	and  z.���� > '20170101'
	and v.����� >= 250
	and z.���_��������� <> '00122'
  GROUP by 	[ID]
      ,[�����]
      , YEAR( z.����)
  order by 	[ID], YEAR( z.����)
GO

SELECT [ID]
      ,[�����] as Mass
      , YEAR( z.����) as Yr
	, COUNT(*) as Cnt	
  FROM [Chest35].[dbo].[tbl�����������������] v
	inner join dbo.tbl������ z on z.���_��������� = v.���_��������� and z.���_������ = v.���_������
  WHERE ID like 'F1957%'
	and  z.���� > '20170101'
	and v.����� >= 250
	and z.���_��������� = '00122'
  GROUP by 	[ID]
      ,[�����]
      , YEAR( z.����)
  order by 	[ID], YEAR( z.����)
GO
