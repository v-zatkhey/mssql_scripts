SELECT t.[Код]
      ,t.[Растворитель]
      ,t.[Сортировка]
      ,t.[Тип_спектра]
      , t.*
  FROM [Chest35].[dbo].[tblТипы_методов_LCMS] t
	inner join [Chest35].[dbo].[tblТипы_спектров] s on s.Код = t.Тип_спектра
  where s.Тип in ('M','L')-- Тип_спектра in (2,15)
GO

update t set [Растворитель] = t.Растворитель + ', LC/MS'
  FROM [Chest35].[dbo].[tblТипы_методов_LCMS] t
  where Тип_спектра in (2,15)
GO

SELECT [Код]
      ,[Тип]
      ,[Сортировка]
      ,[Пояснение]
      ,[Тип_склада]
      ,[Растворитель_последний]
      ,[Растворитель_по_умолчанию]
      ,[Метод_последний]
      ,[Метод_по_умолчанию]
      ,[Код_формы]
      ,[Код_формы_Метод]
  FROM [Chest35].[dbo].[tblТипы_спектров]
  where [Тип] in ('M','L', 'U', 'S', 'R')
GO

INSERT INTO [Chest35].[dbo].[tblТипы_методов_LCMS]
           ([Растворитель]
           ,[Сортировка]
           ,[Тип_спектра])
     VALUES
           ('x-ray fluorescence analysis'
           ,10
           ,26)
     ,
           ('Specific rotation'
           ,20
           ,26)
     ,
           ('IR'
           ,30
           ,26)
     ,
           ('Refractive index n20/D'
           ,40
           ,26)
GO

/*****************************/

select * 
from tblСпектр s 
	inner join tblТипы_спектров t on t.Тип = s.Тип_спектра
where Дата >= '20190501'
	and (s.Метод_LCMS is null or s.Метод_LCMS = '')
	and t.Метод_по_умолчанию is not null
	
/******************************/
/*
Просьба добавить для блока F в окошке Метод/Элемент – NMR
А в выборке растворителей, через запятую после раствоителя  для блока  F - 19F.
*/

SELECT t.[Код]
      ,t.[Растворитель]
      ,t.[Сортировка]
      ,t.[Тип_спектра]
  FROM [Chest35].[dbo].[tblТипы_методов_LCMS] t
	inner join [Chest35].[dbo].[tblТипы_спектров] s on s.Код = t.Тип_спектра
  where s.Тип in ('F')-- 23
GO
SELECT * FROM tblВиды_Растворителей WHERE Category=1 AND Тип in (23) ORDER BY Тип, Sorting, Код

SELECT * FROM tblВиды_Растворителей WHERE Category=1 AND Тип in (23) ORDER BY Тип, Sorting, Код
SELECT * FROM tblВиды_Растворителей WHERE Тип in (23) ORDER BY Тип, Sorting, Код

INSERT INTO [Chest35].[dbo].[tblТипы_методов_LCMS]
           ([Растворитель]
           ,[Сортировка]
           ,[Тип_спектра])
     VALUES
           ('NMR'
           ,16
           ,23)
           
update t 
set Name = t.Name + ', 19F', Comments = t.Comments + ', 19F' 
from  tblВиды_Растворителей t WHERE Category=1 AND Тип in (23) ;

/************  Підтримка #253 ****************************************************/
-- Добавить  Lif11, добавить  Infinity 1260.

SELECT Код, Name, Comments, Category, * FROM tblВиды_Растворителей WHERE Category=5 AND Тип in (2,15)

INSERT INTO [Chest35].[dbo].[tblТипы_методов_LCMS]
           ([Растворитель]
           ,[Сортировка]
           ,[Тип_спектра])
     VALUES
           ('Infinity 1260, LC/MS'
           ,25
           ,2)
     ,
           ('Infinity 1260, LC/MS'
           ,25
           ,15)
INSERT INTO [Chest35].[dbo].[tblВиды_Растворителей]
           (Name
           ,Comments
           ,Category
           ,Sorting
           ,Тип)
     VALUES
           ('Infinity 1260'
           ,'Infinity 1260'
           ,5
           ,8
           ,2)
     ,
           ('Infinity 1260'
           ,'Infinity 1260'
           ,5
           ,8
           ,15)
