USE [SKLAD30]
GO

/****** Object:  View [dbo].[Users]    Script Date: 09/11/2019 11:21:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

if OBJECT_ID('Chest35_����_��������') is not null drop view Chest35_����_��������;
go

Create VIEW [dbo].Chest35_����_��������
AS
	select top 100 ���, ���, ����������,  ���������, POWER(2,���) as Mask
	from Chest35.dbo.tbl����_��������
	where  ���_������ in (2,1)
	order by ����������; 
GO


GRANT SELECT, REFERENCES ON [dbo].[Chest35_����_��������] TO [SKLAD30]
GO

-- select OBJECT_ID('Chest35_����_��������') 