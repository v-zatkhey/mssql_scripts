
SELECT tblБазовыеСписки.Заказчик_Эксклюзивности, tbl_Reactive_compounds.ID, Materials.MatID, Materials.MatName
FROM Materials
		inner join tblБазовыеСписки on tblБазовыеСписки.ID = Materials.MatName 
		INNER JOIN tblСклад ON Materials.MatName = tblСклад.ID
		LEFT JOIN tbl_Reactive_compounds ON Materials.MatName = tbl_Reactive_compounds.ID
WHERE (tblБазовыеСписки.Заказчик_Эксклюзивности Is Null 
			Or 
			tblБазовыеСписки.Заказчик_Эксклюзивности in ('01001','90122')) 
	  AND tbl_Reactive_compounds.ID Is Null
ORDER BY tblБазовыеСписки.Заказчик_Эксклюзивности DESC;
--485598

SELECT  Materials.MatName, MaterialCalculatedParams.*
FROM Materials  INNER JOIN tblБазовыеСписки  ON tblБазовыеСписки.ID = Materials.MatName 
	INNER JOIN tblСклад ON Materials.MatName = tblСклад.ID
	INNER JOIN MaterialCalculatedParams ON Materials.MatID = MaterialCalculatedParams.ID
	--LEFT JOIN tbl_Reactive_compounds ON Materials.MatName = tbl_Reactive_compounds.ID
WHERE (tblБазовыеСписки.Заказчик_Эксклюзивности Is Null 
			Or 
			tblБазовыеСписки.Заказчик_Эксклюзивности in ('01001','90122')) 
	  AND Not exists(select * 
					 from dbo.tblБазовыеСписки l 
						inner join dbo.tblBaseListCondition c on c.BaseListID = l.Код_ID and c.ConditionID not IN (6,14) 
					 where l.ID = Materials.MatName)
ORDER BY tblБазовыеСписки.Заказчик_Эксклюзивности DESC;

select * from dbo.tblТипы_условий_взвешивания

/*
SELECT [ID]
      ,[Условия_взвешивания]
  FROM [Chest35].[dbo].[tbl_Reactive_compounds_add]
GO

exec sp_helptext tbl_Reactive_compounds_add

CREATE VIEW dbo.tbl_Reactive_compounds_add
AS
SELECT     ID, Условия_взвешивания
FROM         dbo.tblБазовыеСписки
WHERE     (LEN(RTRIM(LTRIM(Условия_взвешивания))) > 0)
  AND (RTRIM(LTRIM(Условия_взвешивания)) <> 'Стандартные условия')
  AND (RTRIM(LTRIM(Условия_взвешивания)) <> 'Избегать попадания влаги из воздуха!')
*/