SELECT [���]
      ,[������������]
  FROM [Chest35].[dbo].[tbl������������]
  where [Enabled]=1
  order by 2
GO

SELECT [���]
      ,[��������] as [������������]
  FROM [SKLAD30].[dbo].[������������]
  where [Enabled]=1
		and ��� not in (93,151,94,155)
  order by 2
  
GO

-- 1234567
SELECT *
  FROM tbl������������_� pw
	inner join [tbl������������] p on p.��� = pw.���_������������
  where [���_������������]=62
  
update tbl������������_� set [������] = '1234567' where [���_������������]=62;

exec sp_helptext sp_who

