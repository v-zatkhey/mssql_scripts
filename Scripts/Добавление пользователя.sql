use SKLAD30;

go

/*
������ ����.

�������� ����������� ������ �� ������� ���� ��� ������ ����� - ������� ������� ������������� (Yaroslav Melnyk)
������� � �������� ���������.
����� ������� �� � ��������� ������.

����.

Regards,
Maksim Shchegelskiy

select * from Chest35.dbo.tbl����������_full
*/
/*
14/03/2019
From: Sergey Babiy 
������������, ����� ��������� ��� ����� ������ ������������.
����������� 705
���. ��� BSB

��������� ���������� �������
��� 093-745-21-14
���. ���������, ������� ���., �4������������ �-� ���.������� 13

� ����� ������ �� �����...

��������, MSO!!!!

� ��. ������ �.


*/

declare @SampleUserID int = 170 --������� ��������� ��������
	  , @UserName varchar(255) = '��������� ���������� �������'
	  , @ParentID int = 75 --����� ������ ����������
	  , @Password varchar(32) = 'MS143752'
	  , @SupllierCode varchar(10) = 'MSO'
	  , @Login varchar(32) = 'S.Melnychuk'
	  , @NewUserID int;
	  
-- sample
select * 
from dbo.������������ u --where u.Parent_Id = 75
where u.��� = @SampleUserID ;

select d.* , l.��������
from dbo.������������ u
	inner join dbo.������������_�_������ d on d.���_������������ = u.���
	inner join dbo.������_������� l on l.��� = d.���_������_�������
where u.��� = @SampleUserID and d.���_������ != 11; ---- ��. ������ ;

--- new
INSERT INTO [SKLAD30].[dbo].[������������]
           ([��������]
           ,[������]
           ,[Order]
           ,[Enabled]
           ,[Date]
           ,[Parent_Id]  
           ,[���_����������]
           ,[Winlogin] 
           ,[Prefer_Sklad_Id])
     select
           @UserName as �������� 
           ,@Password as ������
           ,[Order] 
           ,[Enabled]
           ,getdate() as [Date] 
           ,@ParentID -- Parent_Id 
           ,@SupllierCode as ���_���������� 
           ,@Login
           ,Prefer_Sklad_Id 
     from SKLAD30.dbo.������������ u
	 where u.��� = @SampleUserID 
		and not exists(select * from  SKLAD30.[dbo].������������ where [��������] = @UserName);

select @NewUserID = u.��� 
from dbo.������������ u
where [��������] = @UserName ;


INSERT INTO [SKLAD30].[dbo].[������������_�_������]
           ([���_������������]
           ,[���_������]
           ,[���_������_�������])
     select
           @NewUserID as ���_������������ 
           , ���_������
           , ���_������_�������
		from [SKLAD30].dbo.������������_�_������ d 
		where d.���_������������ = @SampleUserID
			and d.���_������ != 11 ---- ��. ������
			and not exists(	select * from [SKLAD30].[dbo].[������������_�_������] 
							where ���_������������ = @NewUserID
								and ���_������ = d.���_������
								and ���_������_������� = d.���_������_�������
								)
			;

-- result
select * 
from dbo.������������ u
where u.��� = @NewUserID ;

select d.* , l.��������
from dbo.������������ u
	inner join dbo.������������_�_������ d on d.���_������������ = u.���
	inner join dbo.������_������� l on l.��� = d.���_������_�������
where u.��� = @NewUserID;
go

--update dbo.������������ set ������ = 'lah9173' where ��� = 172;

/*
use Chest35;

select * from dbo.tbl������������ where ��� = 30; -- ����� ������ ������������
INSERT INTO [Chest35].[dbo].[tbl������������]
           ([������������]
           ,[������������]
           ,[����������]
           ,[����_�������]
           ,[����_��������]
           ,[�����_��_��������]
           ,[�������_��_��������]
           ,[Enabled]
           ,[����_�_���������_��������]
           ,[�����������_����������_��_��������]
           ,[�����_���������_��_�������])
SELECT 'SAI' as [������������]
      ,'��� ��������� ��������' as [������������]
      ,[����������]
      ,[����_�������]
      ,[����_��������]
      ,[�����_��_��������]
      ,[�������_��_��������]
      ,[Enabled]
      ,[����_�_���������_��������]
      ,[�����������_����������_��_��������]
      ,[�����_���������_��_�������]
  FROM [Chest35].[dbo].[tbl������������] 
  WHERE ��� = 30 
	and not exists(select * from  [Chest35].[dbo].[tbl������������] where [������������] = '��� ��������� ��������')
GO





select * from Chest35.dbo.tbl������������ where ��� = 75
select * from Chest35.dbo.tbl������������ where ��� = 37

select * from Chest35.dbo.tbl������������_� where ���_������������ = 81

*/


-- ���������� ���� �� �����
declare @SampleUserID int = 57 --�������� ��������� �������
	  , @UserID int = 170 -- ������� ��������� ��������
	  , @StoreID int = 1;
	  
-- sample
select * 
from dbo.������������ u 
where u.��� = @SampleUserID ;

select d.* , l.��������
from dbo.������������ u
	inner join dbo.������������_�_������ d on d.���_������������ = u.���
	inner join dbo.������_������� l on l.��� = d.���_������_�������
where u.��� = @SampleUserID and d.���_������ = @StoreID; ---- ��. ������ ;

INSERT INTO [SKLAD30].[dbo].[������������_�_������]
           ([���_������������]
           ,[���_������]
           ,[���_������_�������])
     select
           @UserID as ���_������������ 
           , ���_������
           , ���_������_�������
		from [SKLAD30].dbo.������������_�_������ d 
		where d.���_������������ = @SampleUserID
			and d.���_������ = @StoreID
			and not exists(	select * from [SKLAD30].[dbo].[������������_�_������] 
							where ���_������������ = @UserID
								and ���_������ = d.���_������
								and ���_������_������� = d.���_������_�������
								)
			;
go
			
/***************************/
/* 2019-06-10 �� Zoreslav Stepanenko:
����� �������� ������ � ��������� ��������� ������ ���������� ������������ � 4 (���������� ���������� �.�.)
�������� ��������� ������������� (���������� ��� ������� ��� ���������� ��� ������)?
*/

declare @SampleUserID int = 143 --��������� �������� ��������
	  , @UserName varchar(255) = '������� �������� ������������'
	  , @ParentID int = 36 -- ���������� �������� ����������
	  , @Password varchar(32) = 'pparmg1967'
	  , @SupllierCode varchar(10) = 'AVV'
	  , @Login varchar(32) = 'V.Arkhipov'
	  , @NewUserID int;
	  
-- sample
select * 
from dbo.������������ u --where u.Parent_Id = 75
where u.��� = @SampleUserID ;

select d.* , l.��������
from dbo.������������ u
	inner join dbo.������������_�_������ d on d.���_������������ = u.���
	inner join dbo.������_������� l on l.��� = d.���_������_�������
where u.��� = @SampleUserID and d.���_������ != 11; ---- ��. ������ ;

--- new
INSERT INTO [SKLAD30].[dbo].[������������]
           ([��������]
           ,[������]
           ,[Order]
           ,[Enabled]
           ,[Date]
           ,[Parent_Id]  
           ,[���_����������]
           ,[Winlogin] 
           ,[Prefer_Sklad_Id])
     select
           @UserName as �������� 
           ,@Password as ������
           ,[Order] 
           ,[Enabled]
           ,getdate() as [Date] 
           ,@ParentID -- Parent_Id 
           ,@SupllierCode as ���_���������� 
           ,@Login
           ,Prefer_Sklad_Id 
     from SKLAD30.dbo.������������ u
	 where u.��� = @SampleUserID 
		and not exists(select * from  SKLAD30.[dbo].������������ where [��������] = @UserName);

select @NewUserID = u.��� 
from dbo.������������ u
where [��������] = @UserName ;


INSERT INTO [SKLAD30].[dbo].[������������_�_������]
           ([���_������������]
           ,[���_������]
           ,[���_������_�������])
     select
           @NewUserID as ���_������������ 
           , ���_������
           , ���_������_�������
		from [SKLAD30].dbo.������������_�_������ d 
		where d.���_������������ = @SampleUserID
			and d.���_������ != 11 ---- ��. ������
			and not exists(	select * from [SKLAD30].[dbo].[������������_�_������] 
							where ���_������������ = @NewUserID
								and ���_������ = d.���_������
								and ���_������_������� = d.���_������_�������
								)
			;

-- result
select * 
from dbo.������������ u
where u.��� = @NewUserID ;

select d.* , l.��������
from dbo.������������ u
	inner join dbo.������������_�_������ d on d.���_������������ = u.���
	inner join dbo.������_������� l on l.��� = d.���_������_�������
where u.��� = @NewUserID;
go
/*****************************************************************************/
/**
���������, �������� �������� ����������� ��� ����������� ���������� ����.
������� �� �����㳿 � ������������ ��������� �������� ������������� - Svetlana Matyushenko
������ ��� �������� - Yuliia Shtaiura
*/


use Chest35;
go

/*
select * from dbo.tbl������������ where ��� = 76; -- ��������� ��������
INSERT INTO [Chest35].[dbo].[tbl������������]
           ([������������]
           ,[������������]
           ,[����������]
           ,[����_�������]
           ,[����_��������]
           ,[�����_��_��������]
           ,[�������_��_��������]
           ,[Enabled]
           ,[����_�_���������_��������]
           ,[�����������_����������_��_��������]
           ,[�����_���������_��_�������]
           , WinLogin )
SELECT null as [������������]
      ,'������ ��� ���`�����' as [������������]
      ,[����������]
      ,[����_�������]
      ,[����_��������]
      ,[�����_��_��������]
      ,[�������_��_��������]
      ,[Enabled]
      ,[����_�_���������_��������]
      ,[�����������_����������_��_��������]
      ,[�����_���������_��_�������]
      , 'Y.Shtaiura'
  FROM [Chest35].[dbo].[tbl������������] 
  WHERE ��� = 76 
	and not exists(select * from  [Chest35].[dbo].[tbl������������] where [������������] = '������ ��� ���`�����')
GO


select * from Chest35.dbo.tbl������������ where ��� = 84
select * from Chest35.dbo.tbl������������_� where ���_������������ = 84
*/

use SKLAD30;
go


declare @SampleUserID int = 162 -- ��������� �������� �������������
	  , @UserName varchar(255) = '������ ��� ��������'
	  , @ParentID int = 37 -- ���������� ����� ��������
	  , @Password varchar(32) = '607408'
	  , @SupllierCode varchar(10) = null
	  , @Login varchar(32) = 'Y.Shtaiura'
	  , @email varchar(255) = 'Yuliia.Staiura@lifechemicals.com'
	  , @NewUserID int;

	  
-- sample
select * 
from dbo.������������ u --where u.Parent_Id = 75
where u.��� = @SampleUserID ;

select d.* , l.��������
from dbo.������������ u
	inner join dbo.������������_�_������ d on d.���_������������ = u.���
	inner join dbo.������_������� l on l.��� = d.���_������_�������
where u.��� = @SampleUserID and d.���_������ != 11; ---- ��. ������ ;

--- new
INSERT INTO [SKLAD30].[dbo].[������������]
           ([��������]
           ,[������]
           ,[Order]
           ,[Enabled]
           ,[Date]
           ,[Parent_Id]  
           ,[���_����������]
           ,[Winlogin] 
           ,[Prefer_Sklad_Id]
           , Email )
     select
           @UserName as �������� 
           ,@Password as ������
           ,[Order] 
           ,[Enabled]
           ,getdate() as [Date] 
           ,@ParentID -- Parent_Id 
           ,@SupllierCode as ���_���������� 
           ,@Login
           ,Prefer_Sklad_Id
           ,@email 
     from SKLAD30.dbo.������������ u
	 where u.��� = @SampleUserID 
		and not exists(select * from  SKLAD30.[dbo].������������ where [��������] = @UserName);

select @NewUserID = u.��� 
from dbo.������������ u
where [��������] = @UserName ;


INSERT INTO [SKLAD30].[dbo].[������������_�_������]
           ([���_������������]
           ,[���_������]
           ,[���_������_�������])
     select
           @NewUserID as ���_������������ 
           , ���_������
           , ���_������_�������
		from [SKLAD30].dbo.������������_�_������ d 
		where d.���_������������ = @SampleUserID
			and d.���_������ != 11 ---- ��. ������
			and not exists(	select * from [SKLAD30].[dbo].[������������_�_������] 
							where ���_������������ = @NewUserID
								and ���_������ = d.���_������
								and ���_������_������� = d.���_������_�������
								)
			;

-- result
select * 
from dbo.������������ u
where u.��� = @NewUserID ;

select d.* , l.��������
from dbo.������������ u
	inner join dbo.������������_�_������ d on d.���_������������ = u.���
	inner join dbo.������_������� l on l.��� = d.���_������_�������
where u.��� = @NewUserID;
go
/*********************************************************/
/*
� ����� � ����������� �.���� � ��������� � ������ ������ ����������, ������� �.�., 
- �������: �������/������������� ������� ����� (... ������ ������ QManager). 
�������� ����������� "����� ��� ����� ���������� �����".
*/

use Chest35;
go

select * from dbo.tbl������������ where ��� = 37; -- ���� ��������� ���������
INSERT INTO [Chest35].[dbo].[tbl������������]
           ([������������]
           ,[������������]
           ,[����������]
           ,[����_�������]
           ,[����_��������]
           ,[�����_��_��������]
           ,[�������_��_��������]
           ,[Enabled]
           ,[����_�_���������_��������]
           ,[�����������_����������_��_��������]
           ,[�����_���������_��_�������]
           , WinLogin )
SELECT null as [������������]
      ,'̳���� ��������� ����������' as [������������]
      ,[����������]
      ,[����_�������]
      ,[����_��������]
      ,[�����_��_��������]
      ,[�������_��_��������]
      ,[Enabled]
      ,[����_�_���������_��������]
      ,[�����������_����������_��_��������]
      ,[�����_���������_��_�������]
      , 'K.Michkov'
  FROM [Chest35].[dbo].[tbl������������] 
  WHERE ��� = 37
	and not exists(select * from  [Chest35].[dbo].[tbl������������] where [������������] = '̳���� ��������� ����������')
GO


select * from Chest35.dbo.tbl������������ where ��� = 85
select * from Chest35.dbo.tbl������������_� where ���_������������ = 85


--update [tbl������������] set [������������] = 'SUM'  where ��� =  84
------------------------------------------------------------------------------------------------------------
-- ͳ���� ��������� ����������� ������ - ID 214 (�������)
use Chest35;
go


select * from dbo.tbl������������ where ��� = 76; -- ��������� ��������
select * from tbl����������_full
INSERT INTO [Chest35].[dbo].[tbl������������]
           ([������������]
           ,[������������]
           ,[����������]
           ,[����_�������]
           ,[����_��������]
           ,[�����_��_��������]
           ,[�������_��_��������]
           ,[Enabled]
           ,[����_�_���������_��������]
           ,[�����������_����������_��_��������]
           ,[�����_���������_��_�������]
           , WinLogin )
SELECT 'NOA' as [������������]
      ,'ͳ���� ��������� �����������' as [������������]
      ,[����������]
      ,[����_�������]
      ,[����_��������]
      ,[�����_��_��������]
      ,[�������_��_��������]
      ,[Enabled]
      ,[����_�_���������_��������]
      ,[�����������_����������_��_��������]
      ,[�����_���������_��_�������]
      , 'O.Nikulin'
  FROM [Chest35].[dbo].[tbl������������] 
  WHERE ��� = 76 
	and not exists(select * from  [Chest35].[dbo].[tbl������������] where [������������] = 'ͳ���� ��������� �����������')
GO


select * from Chest35.dbo.tbl������������ where ��� = 86
select * from Chest35.dbo.tbl������������_� where ���_������������ = 86
go

--update tbl����������_full set Email = 'Oleksandr.Nikulin@spec-info.com' where ���  = 680;
--update tbl����������_full set Email = 'Yuliia.Staiura@lifechemicals.com' where ���  = 681;


use SKLAD30;
go


declare @SampleUserID int = 170 -- ������� ��������� ��������
	  , @UserName varchar(255) = 'ͳ���� ��������� �����������'
	  , @ParentID int = 75 -- ����� ������ ����������
	  , @Password varchar(32) = '41031107'
	  , @SupllierCode varchar(10) = 'NOA'
	  , @Login varchar(32) = 'O.Nikulin'
	  , @email varchar(255) = 'Oleksandr.Nikulin@spec-info.com'
	  , @NewUserID int;

	  
-- sample
select * 
from dbo.������������ u --where u.Parent_Id = 75
where u.��� = @SampleUserID ;

/*
select d.* , l.��������
from dbo.������������ u
	inner join dbo.������������_�_������ d on d.���_������������ = u.���
	inner join dbo.������_������� l on l.��� = d.���_������_�������
where u.��� = @SampleUserID and d.���_������ != 11; ---- ��. ������ ;
*/
--- new
INSERT INTO [SKLAD30].[dbo].[������������]
           ([��������]
           ,[������]
           ,[Order]
           ,[Enabled]
           ,[Date]
           ,[Parent_Id]  
           ,[���_����������]
           ,[Winlogin] 
           ,[Prefer_Sklad_Id]
           , Email )
     select
           @UserName as �������� 
           ,@Password as ������
           ,[Order] 
           ,[Enabled]
           ,getdate() as [Date] 
           ,@ParentID -- Parent_Id 
           ,@SupllierCode as ���_���������� 
           ,@Login
           ,Prefer_Sklad_Id
           ,@email 
     from SKLAD30.dbo.������������ u
	 where u.��� = @SampleUserID 
		and not exists(select * from  SKLAD30.[dbo].������������ where [��������] = @UserName);

select @NewUserID = u.��� from dbo.������������ u where [��������] = @UserName ;


INSERT INTO [SKLAD30].[dbo].[������������_�_������]
           ([���_������������]
           ,[���_������]
           ,[���_������_�������])
     select
           @NewUserID as ���_������������ 
           , ���_������
           , ���_������_�������
		from [SKLAD30].dbo.������������_�_������ d 
		where d.���_������������ = @SampleUserID
			and d.���_������ != 11 ---- ��. ������
			and not exists(	select * from [SKLAD30].[dbo].[������������_�_������] 
							where ���_������������ = @NewUserID
								and ���_������ = d.���_������
								and ���_������_������� = d.���_������_�������
								)
			;

-- result
select * 
from dbo.������������ u
where u.��� = @NewUserID ;

select d.* , l.��������
from dbo.������������ u
	inner join dbo.������������_�_������ d on d.���_������������ = u.���
	inner join dbo.������_������� l on l.��� = d.���_������_�������
where u.��� = @NewUserID;
go

-- ��� ����
/*
begin tran
delete from  SKLAD30.dbo.������������_�_������ where ���_������������ = 178
delete from  SKLAD30.dbo.������������ where ��� = 178
delete from Chest35.dbo.tbl������������ where ��� = 86
delete from Chest35.dbo.tbl������������_� where ���_������������ = 86
commit
*/
/***********************************************************************/
/* ������ - ID 424 (�������) �� �������� �������� ���������� ������� �������� ������� �� ������ �� ����� �� �����㳿 �� � ��������� ������. */
use SKLAD30 ;
go

declare @SampleUserID int = 65  --��������� ����� ��������
	  , @UserName varchar(255) = '������ ��������� �������������'
	  --, @ParentID int = 36 -- ���������� �������� ����������
	  , @Password varchar(32) = 'hgf6785'
	  , @SupllierCode varchar(10) = null
	  , @Login varchar(32) = 'O.Manziuk'
	  , @email varchar(255) = 'Oleksandr.Manziuk@lifechemicals.com'
	  , @NewUserID int	  
;
-- SKLAD30	  
-- sample
select * 
from dbo.������������ u --where u.Parent_Id = 75
where u.��� = @SampleUserID ;

select d.* , l.��������
from dbo.������������ u
	inner join dbo.������������_�_������ d on d.���_������������ = u.���
	inner join dbo.������_������� l on l.��� = d.���_������_�������
where u.��� = @SampleUserID and d.���_������ != 11; ---- ��. ������ ;

--- new
INSERT INTO [SKLAD30].[dbo].[������������]
           ([��������]
           ,[������]
           ,[Order]
           ,[Enabled]
           ,[Date]
           ,[Parent_Id]  
           ,[���_����������]
           ,[Winlogin] 
           ,[Prefer_Sklad_Id])
     select
           @UserName as �������� 
           ,@Password as ������
           ,[Order] 
           ,[Enabled]
           ,getdate() as [Date] 
           ,Parent_Id 
           ,@SupllierCode as ���_���������� 
           ,@Login
           ,Prefer_Sklad_Id 
     from SKLAD30.dbo.������������ u
	 where u.��� = @SampleUserID 
		and not exists(select * from  SKLAD30.[dbo].������������ where [��������] = @UserName);

select @NewUserID = u.��� 
from dbo.������������ u
where [��������] = @UserName ;


INSERT INTO [SKLAD30].[dbo].[������������_�_������]
           ([���_������������]
           ,[���_������]
           ,[���_������_�������])
     select
           @NewUserID as ���_������������ 
           , ���_������
           , ���_������_�������
		from [SKLAD30].dbo.������������_�_������ d 
		where d.���_������������ = @SampleUserID
			and d.���_������ != 11 ---- ��. ������
			and not exists(	select * from [SKLAD30].[dbo].[������������_�_������] 
							where ���_������������ = @NewUserID
								and ���_������ = d.���_������
								and ���_������_������� = d.���_������_�������
								)
			;

-- result
select * 
from dbo.������������ u
where u.��� = @NewUserID ;

select d.* , l.��������
from dbo.������������ u
	inner join dbo.������������_�_������ d on d.���_������������ = u.���
	inner join dbo.������_������� l on l.��� = d.���_������_�������
where u.��� = @NewUserID;

go

