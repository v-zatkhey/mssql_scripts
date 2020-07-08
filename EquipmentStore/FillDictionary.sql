use SKLAD30;
go

/*** ������ *******/
--select * from dbo.������

if not exists(select * from dbo.eqsStorePointType)
begin
	insert into eqsStorePointType(ID, Name) values (1, '�����')
													,(2, '���������� ����������� �����');											
end;
if not exists(select * from dbo.eqsStorePoint where StorePointTypeID = 1)
begin

set identity_insert eqsStorePoint on
	insert into eqsStorePoint(ID, StorePointTypeID, Name) values (1, 1, 'C���� ���������� ��� ����������')
													,(2, 1, '����� ������������� ������ �� ����')	;										
set identity_insert eqsStorePoint off
end;
go

/*************** ���.������������� **************/
/*
  SELECT [�����������]
      ,max([������ �������� �����������]) as [������ �������� �����������]
      ,COUNT(*)
  FROM [SKLAD30].[dbo].[__�����������]
  where [���_�]in (11,13) and [������ �������� �����������]is not null
  group by [�����������];
 */ 
--select * from eqsStorePoint where StorePointTypeID = 2
--delete from eqsStorePoint where ID = 18 and Name = '������� ����� �����������';
--delete from eqsStorePoint where ID = 54 and Name = '������������ ������ �����������';
if not exists(select * from eqsStorePoint where StorePointTypeID = 2)
begin
declare @MaxID bigint =isnull( (select max(ID) from eqsStorePoint),0);
set identity_insert eqsStorePoint on
	insert into eqsStorePoint(ID, StorePointTypeID, Name)
	 SELECT @MaxID + ROW_NUMBER() over(order by max([������ �������� �����������]) asc)
	 , 2
     ,max([������ �������� �����������]) as [������ �������� �����������]
	  FROM [SKLAD30].[dbo].[__�����������]
	  where [���_�]in (11,13) and [������ �������� �����������]is not null
	  group by [�����������]; 											
set identity_insert eqsStorePoint off
end;
go

if not exists(select * from eqsFinRespPerson)
begin
	insert into eqsFinRespPerson(ID, InitialsName)
	select sp.ID, x.�����������
	from eqsStorePoint sp
	 inner join
	 (SELECT max([������ �������� �����������]) as [������ �������� �����������]
		, [�����������]
	  FROM [SKLAD30].[dbo].[__�����������]
	  where [���_�]in (11,13) and [������ �������� �����������]is not null and [�����������]<> 'GIR'and [�����������]<>'SAL'
	  group by [�����������]) x on x.[������ �������� �����������] = sp.Name
	where sp.StorePointTypeID = 2
	order by sp.Name; 											
end;
go

/******** ������� ��������� ***************/
if not exists(select * from eqsUnitFactor)
begin
	delete from  eqsUnit;
	set identity_insert eqsUnit on;
	insert into eqsUnit(ID, Name, ShortName)
	values (1, '�����', '��.'); 											
	set identity_insert eqsUnit off;
end;
go

/******** ��������� � ������������ ********/
/*
select * from dbo.__��������� c
where c.���_� = 11
select * from dbo.__��������� c
where c.���_� = 13

select c.���������,  v.*
from dbo.__�������� v
	inner join dbo.__��������� c on c.���_ID = v.Category_ID
where v.���_� = 11 or v.���_� = 13
order by v.Category_ID


select  v.*
from dbo.__�������� v
where v.���_� = 11 and v.RusName <> v.ProdName
*/
-- delete from eqsSubCategory
-- delete from eqsCategory
set identity_insert eqsSubCategory on;
if not exists(select * from eqsCategory) and not exists(select * from eqsSubCategory)
begin
insert into 	 eqsCategory (ID,Name) 	values	 ( 1, '������������ ������ � ��������������'); 
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (1, 1, '���������� ������������ ������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (2, 1, '������ ������ ���������� � �����������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (3, 1, '����������� ���������� ������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (4, 1, '������������ ������ �� �������������������� �������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (5, 1, '�������������� ������������ �� �����');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (6, 1, '������� �� ������ ��� �����������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (7, 1, '������ ���������� � ����');
insert into 	 eqsCategory (ID,Name) 	values	 ( 2, '������������� ������������ � �������'); 
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (8, 2, '���� ������������ � ������������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (9, 2, '������������, ���������� ��������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (10, 2, '���������������� � ���������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (11, 2, '����������� ����������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (12, 2, '��������� ���������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (13, 2, '��-�����, ��-���������, ������������ ������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (14, 2, '�������������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (15, 2, '��������� ������������� ���������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (16, 2, '�����������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (17, 2, '����� ���� ��� �������������� ��������');
insert into 	 eqsCategory (ID,Name) 	values	 ( 3, '����������� ������������� ������������'); 
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (18, 3, '������������� ���� � ������������ ������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (19, 3, '���������� �����������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (20, 3, '������� ������� ����� ������� ���������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (21, 3, '��������-����� ����������� ���������� �����/����� ������� ����');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (22, 3, '�������� ��� ���������� ����� � ���������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (23, 3, '������������ ��� ����������� �����������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (24, 3, '������������ ��� ������������� ����������');
insert into 	 eqsCategory (ID,Name) 	values	 ( 4, '������������ �������, ��������, ������'); 
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (25, 4, '��������� ������� � ���������� � ��� ���������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (26, 4, '������� ������������ � ������� ��������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (27, 4, '�������� ������������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (28, 4, '������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (29, 4, '�������������� ���� � ������������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (30, 4, '���������� ������������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (31, 4, '������� (�������������), 3D �������, �������');
insert into 	 eqsCategory (ID,Name) 	values	 ( 5, '������������ ��� ������� � ����������'); 
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (32, 5, '���� ������� ������������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (33, 5, '������� ������� ������������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (34, 5, '���������� �������������, ��2-����������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (35, 5, '������������� � ������������� ������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (36, 5, '���� ���������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (37, 5, '������ � ���������������� ������������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (38, 5, '��������� ����� MEMMERT');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (39, 5, '�������������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (40, 5, '���������� ����������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (41, 5, '������������ � ������������ ������������');
insert into 	 eqsCategory (ID,Name) 	values	 ( 6, '�������������� � ������������������ ���������'); 
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (42, 6, '������ �������������� ������������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (43, 6, '�������������� �������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (44, 6, '���������� ������� ��� ������������ �����');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (45, 6, '��������� ���������� �������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (46, 6, '������ ����������� ������������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (47, 6, '������������������ �����, ������� � ������.');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (48, 6, '������������������ ������ (�����������)');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (49, 6, '������� ������������������');
insert into 	 eqsCategory (ID,Name) 	values	 ( 7, '������������������ ������������'); 
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (50, 7, '������������ ��� ���������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (51, 7, '���������� ������ ��� �������������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (52, 7, '������ ���������� � ���������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (53, 7, '������������ ������� �����������');
insert into 	 eqsCategory (ID,Name) 	values	 ( 8, '������������ ������������ �����'); 
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (54, 8, '������� ������������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (55, 8, '�������� ��� ������������ �����');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (56, 8, '�������������� ��� ������ ���� � ����');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (57, 8, '���������� ������������ �������');
insert into 	 eqsCategory (ID,Name) 	values	 ( 9, '����'); 
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (58, 9, '������� ��������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (59, 9, '������ �������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (60, 9, '�����������');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (61, 9, '����');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (62, 9, '����');

end
set identity_insert eqsSubCategory off;

-- select c.*, s.* from eqsCategory c inner join eqsSubCategory s on s.CategoryID = c.ID
go
/********* ������ **********************/
if not exists(select * from eqsGroup)	
begin
	set identity_insert eqsGroup on;

	insert into   eqsGroup (ID, SubCategoryID, Name) values  (1,1, '����� ���������� ����� ');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (2,1, '������� �����');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (3,1, '����� �����');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (4,2, '������� ���');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (5,2, '������� ����� �� ��������');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (6,2, '��������� ����� �� ���������');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (7,2, '������� ���');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (8,2, '˳��� ����� �� ���������');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (9,4, '������� �� ���� ����������');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (10,6, '������ �''��������� �� �������');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (11,7, '������ ������');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (12,9, '�������� ������');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (13,11, '����������');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (14,28, '���������� �� �������');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (15,41, '������ ������');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (16,41, '������������ �����');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (17,58, '������� ��������');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (18,59, '������ �������');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (19,60, '�����������');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (20,61, '����');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (21,62, '����� ������');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (22,62, '������ �������� �㳺��');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (23,62, '������ �������');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (24,62, '������ �������� ������');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (25,62, '��������');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (26,62, '���');
		
	set identity_insert eqsGroup off;
end

--select * from eqsGroup
go

-- link to old categories
if not OBJECT_ID(N'eqs_OldCategoryLink') is null drop table eqs_OldCategoryLink;
create table eqs_OldCategoryLink(OldCategoryKodID int, GroupID bigint);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (42,1);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (46,4);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (51,8);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (59,14);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (57,17);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (35,1);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (37,1);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (39,1);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (52,16);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (25,8);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (45,12);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (30,15);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (58,18);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (61,19);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (55,1);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (38,1);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (32,1);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (53,11);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (24,3);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (50,8);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (54,2);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (21,1);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (34,1);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (23,8);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (63,8);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (43,1);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (9,14);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (62,1);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (60,2);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (33,1);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (36,1);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (27,5);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (64,14);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (31,20);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (28,13);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (40,1);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (49,10);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (48,11);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (56,1);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (47,9);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (19,16);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (44,7);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (41,1);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (29,6);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (12,21);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (13,22);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (14,23);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (15,24);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (16,25);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (17,26);
go
/**************** Item ***********************************/
/*
select * from eqsGroup
select  l.GroupID, v.ProdName
		, case when v.SynonName is null and v.Notice is null 
			then null	
			else ISNULL(v.SynonName,'') + case when v.Notice is null then '' else ' ' + v.Notice end
			end as Comments
		, v.���_ID
		, * 
from dbo.__�������� v 
	left join eqs_OldCategoryLink l on l.OldCategoryKodID = v.Category_ID --283
where v.���_� in (11,13) --294 
	and l.OldCategoryKodID is null
*/


if not exists(select * from eqsItem) 
begin
	insert into eqsItem(GroupID,Name, Comments, OldCodeID)
	select  isnull(l.GroupID,24) -- ������ �������� ������
			, v.ProdName
			, case when v.SynonName is null and v.Notice is null 
				then null	
				else ISNULL(v.SynonName,'') + case when v.Notice is null then '' else ' ' + v.Notice end
				end as Comments
			, v.���_ID
	from dbo.__�������� v 
		left join eqs_OldCategoryLink l on l.OldCategoryKodID = v.Category_ID --283
		left join eqsItem i on i.OldCodeID = v.���_ID
	where v.���_� in (11,13) and i.ID is null

end; -- 283 -- +11
go

insert into eqsUnitFactor(UnitID,ItemID,UnitQuantity)
select 1, i.ID, 1
from eqsItem i
where not exists(select * from eqsUnitFactor where ItemID = i.ID and UnitQuantity = 1);
go


/********************���� ����������**********************/
if not exists(select * from eqsDocType)
begin
insert into eqsDocType(ID, Name, IsOuterDoc, TableName)
	values(1, '���������� ��������', 1, 'eqsDocIncoming')
	,(2, '��������� ��������', 1, 'eqsDocOutgoing')	
	,(3, '�������� �� ������� ����������', 0, 'eqsDocMove')
	,(4, '�������� �������', 0, 'eqsDocMove')	
	,(5, '��������', 1, 'eqsDocWriteOff')	
	,(6, '�������� � �����', 1, 'eqsDocArticleIn')	
	,(7, '�����������', 0, 'eqsDocRegrading');
end;

-- delete from eqsStatus
if not exists(select * from eqsStatus)
begin
insert into eqsStatus(ID, Name, Short, Code)
	values(0, '��������', '��', 'DFT')
		 ,(1, '����������', '��', 'FIN')	
end;
go

/********** ����������� *******/

--select * from eqsContractor
/*
insert into eqsContractor(Name, FullName, Comments, OldCodeID)
select ��������, [������ �������� ���������] , ���_����� , ���_ID  
from dbo.__��������� 
where (���_�  = 11 or ���_�  = 13) 
*/

--update c 
--set EDRPOU = LEFT(Comments,10)
--	, Comments = LTRIM( SUBSTRING(Comments, 11, LEN(Comments)-10))
select LEFT(Comments,10), LTRIM ( SUBSTRING(Comments, 11, LEN(Comments)-10)), * 
from eqsContractor c
where LEFT(Comments,10) like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	and ID not in (11,73,106,118) 
	and EDRPOU is null;
	
--update c 
--set EDRPOU = LEFT(Comments,8)
--	, Comments = LTRIM ( SUBSTRING(Comments, 9, LEN(Comments)-8))
select LEFT(Comments,8), LTRIM ( SUBSTRING(Comments, 9, LEN(Comments)-8)), * 
from eqsContractor c
where LEFT(Comments,8) like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	and ID not in (11,73,106,118) 
	and EDRPOU is null;
go	
	