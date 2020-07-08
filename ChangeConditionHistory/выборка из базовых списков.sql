SELECT [Код_ID]
      ,[ID]
      ,[Условия_взвешивания]
      ,[Дата_условия_взвешивания]
      ,[Кто_условия_взвешивания]
  FROM [Chest35].[dbo].[tblБазовыеСписки]
  where [Условия_взвешивания] is not null 
	and [Кто_условия_взвешивания] is not null;
GO

insert into dbo.tblChangeConditionHistory(
				BaseListID ,
				NewCondition ,
				ChangeDate,
				UserName)
SELECT [Код_ID]
      ,[Условия_взвешивания]
      ,[Дата_условия_взвешивания]
      ,[Кто_условия_взвешивания]
  FROM [Chest35].[dbo].[tblБазовыеСписки] t
  where t.[Условия_взвешивания] is not null 
	and t.[Кто_условия_взвешивания] is not null
	and not exists(select * from tblChangeConditionHistory where BaseListID = t.[Код_ID]);