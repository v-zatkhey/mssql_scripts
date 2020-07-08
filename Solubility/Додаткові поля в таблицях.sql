USE [Chest35]
GO

alter table dbo.Типы_растворимости_в_DMSO add Method varchar(50);
go

update Типы_растворимости_в_DMSO set Method = 'T. m.' where [Код] in (1,2,3);
if not exists(select * from Типы_растворимости_в_DMSO where [Код] = 4)  insert into Типы_растворимости_в_DMSO values(4,'>=200 mM','K.m.');
go

alter table dbo.Materials add Solubility_DMSO_Km int; 
go

SELECT *  FROM [Chest35].[dbo].[Типы_растворимости_в_DMSO]
GO

