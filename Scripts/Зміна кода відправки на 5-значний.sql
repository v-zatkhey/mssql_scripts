use Chest35;
go 

select ���_��������, count(*)
from tbl�����������������
where ���_�������� like 's99_'
group by ���_��������;

/*
select ���_��������, *
from tbl�����������������
where ���_�������� like 's99_'
*/

select ���_��������,   COUNT(*)
from tbl�����������������
where ���_�������� not like 's99_'
	and ���_�������� like 's[0-9][0-9][0-9]'
group by ���_��������
order by tbl�����������������.���_��������



-------------------------------------------

select ���_��������,  COUNT(*) 
from tbl�������������
where ���_�������� like 's99_'
group by ���_��������;

/*
select top 100 *
from tbl�������������
where ���_��������  like 's99%';

select * from [tbl�������������_w massa_full] where ID = 'F9995-1220'

*/


--select * from tbl������������� where ([ID] = 'F0856-0478') AND (([���_���������] + '-' + [���_������]) = '00030-z03577')

select ���_��������,  COUNT(*)
from tbl�������������
where ���_�������� not like 's99_'
	and ���_�������� like 's[0-9][0-9][0-9]'
group by ���_��������
order by ���_��������

-------------------------------------------

select ���_��������, COUNT(*) 
from tbl���������������
where LEN(���_��������) = 4
	and ���_�������� like 's99_'
group by ���_��������;

select ���_��������,  COUNT(*)
from tbl���������������
where ���_�������� not like 's99_'
	and ���_�������� like 's[0-9][0-9][0-9]'
group by ���_��������
order by ���_��������

----------------------------------------------------------------------------
begin tran

	--select ���_��������, 's9999' + RIGHT(���_��������,1), COUNT(*) 
	update o set ���_�������� = 's9999' + RIGHT(���_��������,1)
	from tbl��������������� o
	where LEN(���_��������) = 4
		and ���_�������� like 's99_';

	--	select ���_��������, 's00' + RIGHT(���_��������,3),  COUNT(*)
	update o set ���_�������� = 's00' + RIGHT(���_��������,3)
	from tbl��������������� o
	where LEN(���_��������) = 4
		and ���_�������� not like 's99_'
		and ���_�������� like 's[0-9][0-9][0-9]';

commit -- rollback
go

/****** ��������� tbl����������������� ******/
begin tran
	IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[View_Otpravleno_Kolvo]'))
	DROP VIEW [dbo].[View_Otpravleno_Kolvo]
	GO

	alter table dbo.tbl����������������� alter column ���_�������� nvarchar(6);
	go

	update v set ���_�������� = 's9999' + RIGHT(���_��������,1)	
	from tbl����������������� v
	where ���_�������� like 's99_';


	update v set ���_�������� = 's00' + RIGHT(���_��������,3)	
	from tbl����������������� v
	where ���_�������� not like 's99_'
		and ���_�������� like 's[0-9][0-9][0-9]';
	go

	CREATE VIEW [dbo].[View_Otpravleno_Kolvo]
	WITH SCHEMABINDING 
	AS
	SELECT     ���_���������, ���_������, COUNT(ID) AS Kolvo
	FROM       dbo.tbl�����������������
	WHERE     (���_�������� <> N's99997' AND ���_�������� <> N's99998')
	GROUP BY ���_���������, ���_������

	GO
	
commit -- rollback

/****** ��������� tbl������������� ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

begin tran


	alter table dbo.[tbl�������������] alter column ���_�������� nvarchar(6);
	go

	ALTER TABLE [dbo].[tbl�������������] drop CONSTRAINT [DF_dbo.tbl�������������_new21_���_��������]; 
	ALTER TABLE [dbo].[tbl�������������] ADD  CONSTRAINT [DF_dbo.tbl�������������_new21_���_��������]  DEFAULT (N's00000') FOR [���_��������]
	GO

	update s set ���_�������� = 's9999' + RIGHT(���_��������,1)	
	from tbl������������� s
	where ���_�������� like 's99_';

	update s set ���_�������� = 's00' + RIGHT(���_��������,3)
	from tbl������������� s
	where ���_�������� not like 's99_'
		and ���_�������� like 's[0-9][0-9][0-9]';	
	
commit -- rollback


select * from dbo.TableLogs 
where IDNUMBER_old = 'F0920-6402'
select * from dbo.��������_������;


select * from dbo.TableLogs 
where TableID = 16
	and DateTime_ > '20200129'
	--and User_ = 'IFLAB\A.Makarova'
	and Fields_ like '���_��������=s99999->%'


select ���_��������, *
from tbl�����������������
where ���_�������� like 's99_'

select * from dbo.TableLogs 
where TableID = 7
	and DateTime_ > '20200124'
	--and User_ = 'IFLAB\A.Makarova'
	and Fields_ like '���_��������=s998%'
		