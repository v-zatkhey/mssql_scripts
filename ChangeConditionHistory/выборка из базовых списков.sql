SELECT [���_ID]
      ,[ID]
      ,[�������_�����������]
      ,[����_�������_�����������]
      ,[���_�������_�����������]
  FROM [Chest35].[dbo].[tbl�������������]
  where [�������_�����������] is not null 
	and [���_�������_�����������] is not null;
GO

insert into dbo.tblChangeConditionHistory(
				BaseListID ,
				NewCondition ,
				ChangeDate,
				UserName)
SELECT [���_ID]
      ,[�������_�����������]
      ,[����_�������_�����������]
      ,[���_�������_�����������]
  FROM [Chest35].[dbo].[tbl�������������] t
  where t.[�������_�����������] is not null 
	and t.[���_�������_�����������] is not null
	and not exists(select * from tblChangeConditionHistory where BaseListID = t.[���_ID]);