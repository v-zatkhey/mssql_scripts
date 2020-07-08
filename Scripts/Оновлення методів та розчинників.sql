SELECT t.[���]
      ,t.[������������]
      ,t.[����������]
      ,t.[���_�������]
      , t.*
  FROM [Chest35].[dbo].[tbl����_�������_LCMS] t
	inner join [Chest35].[dbo].[tbl����_��������] s on s.��� = t.���_�������
  where s.��� in ('M','L')-- ���_������� in (2,15)
GO

update t set [������������] = t.������������ + ', LC/MS'
  FROM [Chest35].[dbo].[tbl����_�������_LCMS] t
  where ���_������� in (2,15)
GO

SELECT [���]
      ,[���]
      ,[����������]
      ,[���������]
      ,[���_������]
      ,[������������_���������]
      ,[������������_��_���������]
      ,[�����_���������]
      ,[�����_��_���������]
      ,[���_�����]
      ,[���_�����_�����]
  FROM [Chest35].[dbo].[tbl����_��������]
  where [���] in ('M','L', 'U', 'S', 'R')
GO

INSERT INTO [Chest35].[dbo].[tbl����_�������_LCMS]
           ([������������]
           ,[����������]
           ,[���_�������])
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
from tbl������ s 
	inner join tbl����_�������� t on t.��� = s.���_�������
where ���� >= '20190501'
	and (s.�����_LCMS is null or s.�����_LCMS = '')
	and t.�����_��_��������� is not null
	
/******************************/
/*
������� �������� ��� ����� F � ������ �����/������� � NMR
� � ������� �������������, ����� ������� ����� �����������  ��� �����  F - 19F.
*/

SELECT t.[���]
      ,t.[������������]
      ,t.[����������]
      ,t.[���_�������]
  FROM [Chest35].[dbo].[tbl����_�������_LCMS] t
	inner join [Chest35].[dbo].[tbl����_��������] s on s.��� = t.���_�������
  where s.��� in ('F')-- 23
GO
SELECT * FROM tbl����_������������� WHERE Category=1 AND ��� in (23) ORDER BY ���, Sorting, ���

SELECT * FROM tbl����_������������� WHERE Category=1 AND ��� in (23) ORDER BY ���, Sorting, ���
SELECT * FROM tbl����_������������� WHERE ��� in (23) ORDER BY ���, Sorting, ���

INSERT INTO [Chest35].[dbo].[tbl����_�������_LCMS]
           ([������������]
           ,[����������]
           ,[���_�������])
     VALUES
           ('NMR'
           ,16
           ,23)
           
update t 
set Name = t.Name + ', 19F', Comments = t.Comments + ', 19F' 
from  tbl����_������������� t WHERE Category=1 AND ��� in (23) ;

/************  ϳ������� #253 ****************************************************/
-- ��������  Lif11, ��������  Infinity 1260.

SELECT ���, Name, Comments, Category, * FROM tbl����_������������� WHERE Category=5 AND ��� in (2,15)

INSERT INTO [Chest35].[dbo].[tbl����_�������_LCMS]
           ([������������]
           ,[����������]
           ,[���_�������])
     VALUES
           ('Infinity 1260, LC/MS'
           ,25
           ,2)
     ,
           ('Infinity 1260, LC/MS'
           ,25
           ,15)
INSERT INTO [Chest35].[dbo].[tbl����_�������������]
           (Name
           ,Comments
           ,Category
           ,Sorting
           ,���)
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
