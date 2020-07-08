USE [SKLAD30]
GO

/****** Object:  View [dbo].[Users]    Script Date: 09/11/2019 11:21:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

if OBJECT_ID('Chest35_Типы_спектров') is not null drop view Chest35_Типы_спектров;
go

Create VIEW [dbo].Chest35_Типы_спектров
AS
	select top 100 Код, Тип, Сортировка,  Пояснение, POWER(2,Код) as Mask
	from Chest35.dbo.tblТипы_спектров
	where  Тип_склада in (2,1)
	order by Сортировка; 
GO


GRANT SELECT, REFERENCES ON [dbo].[Chest35_Типы_спектров] TO [SKLAD30]
GO

-- select OBJECT_ID('Chest35_Типы_спектров') 