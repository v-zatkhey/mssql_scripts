USE [Chest35]
GO

alter table dbo.����_�������������_�_DMSO add Method varchar(50);
go

update ����_�������������_�_DMSO set Method = 'T. m.' where [���] in (1,2,3);
if not exists(select * from ����_�������������_�_DMSO where [���] = 4)  insert into ����_�������������_�_DMSO values(4,'>=200 mM','K.m.');
go

alter table dbo.Materials add Solubility_DMSO_Km int; 
go

SELECT *  FROM [Chest35].[dbo].[����_�������������_�_DMSO]
GO

