use Chest35;
go 

select Код_отправки, count(*)
from tblВыполненныеЗаказы
where Код_отправки like 's99_'
group by Код_отправки;

/*
select Код_отправки, *
from tblВыполненныеЗаказы
where Код_отправки like 's99_'
*/

select Код_отправки,   COUNT(*)
from tblВыполненныеЗаказы
where Код_отправки not like 's99_'
	and Код_отправки like 's[0-9][0-9][0-9]'
group by Код_отправки
order by tblВыполненныеЗаказы.Код_отправки



-------------------------------------------

select Код_отправки,  COUNT(*) 
from tblСписокЗаказов
where Код_отправки like 's99_'
group by Код_отправки;

/*
select top 100 *
from tblСписокЗаказов
where Код_отправки  like 's99%';

select * from [tblСписокЗаказов_w massa_full] where ID = 'F9995-1220'

*/


--select * from tblСписокЗаказов where ([ID] = 'F0856-0478') AND (([Код_заказчика] + '-' + [Код_заказа]) = '00030-z03577')

select Код_отправки,  COUNT(*)
from tblСписокЗаказов
where Код_отправки not like 's99_'
	and Код_отправки like 's[0-9][0-9][0-9]'
group by Код_отправки
order by Код_отправки

-------------------------------------------

select Код_отправки, COUNT(*) 
from tblОтправкаЗаказов
where LEN(Код_отправки) = 4
	and Код_отправки like 's99_'
group by Код_отправки;

select Код_отправки,  COUNT(*)
from tblОтправкаЗаказов
where Код_отправки not like 's99_'
	and Код_отправки like 's[0-9][0-9][0-9]'
group by Код_отправки
order by Код_отправки

----------------------------------------------------------------------------
begin tran

	--select Код_отправки, 's9999' + RIGHT(Код_отправки,1), COUNT(*) 
	update o set Код_отправки = 's9999' + RIGHT(Код_отправки,1)
	from tblОтправкаЗаказов o
	where LEN(Код_отправки) = 4
		and Код_отправки like 's99_';

	--	select Код_отправки, 's00' + RIGHT(Код_отправки,3),  COUNT(*)
	update o set Код_отправки = 's00' + RIGHT(Код_отправки,3)
	from tblОтправкаЗаказов o
	where LEN(Код_отправки) = 4
		and Код_отправки not like 's99_'
		and Код_отправки like 's[0-9][0-9][0-9]';

commit -- rollback
go

/****** оновлення tblВыполненныеЗаказы ******/
begin tran
	IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[View_Otpravleno_Kolvo]'))
	DROP VIEW [dbo].[View_Otpravleno_Kolvo]
	GO

	alter table dbo.tblВыполненныеЗаказы alter column Код_отправки nvarchar(6);
	go

	update v set Код_отправки = 's9999' + RIGHT(Код_отправки,1)	
	from tblВыполненныеЗаказы v
	where Код_отправки like 's99_';


	update v set Код_отправки = 's00' + RIGHT(Код_отправки,3)	
	from tblВыполненныеЗаказы v
	where Код_отправки not like 's99_'
		and Код_отправки like 's[0-9][0-9][0-9]';
	go

	CREATE VIEW [dbo].[View_Otpravleno_Kolvo]
	WITH SCHEMABINDING 
	AS
	SELECT     Код_заказчика, Код_заказа, COUNT(ID) AS Kolvo
	FROM       dbo.tblВыполненныеЗаказы
	WHERE     (Код_отправки <> N's99997' AND Код_отправки <> N's99998')
	GROUP BY Код_заказчика, Код_заказа

	GO
	
commit -- rollback

/****** оновлення tblСписокЗаказов ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

begin tran


	alter table dbo.[tblСписокЗаказов] alter column Код_отправки nvarchar(6);
	go

	ALTER TABLE [dbo].[tblСписокЗаказов] drop CONSTRAINT [DF_dbo.tblСписокЗаказов_new21_Код_отправки]; 
	ALTER TABLE [dbo].[tblСписокЗаказов] ADD  CONSTRAINT [DF_dbo.tblСписокЗаказов_new21_Код_отправки]  DEFAULT (N's00000') FOR [Код_отправки]
	GO

	update s set Код_отправки = 's9999' + RIGHT(Код_отправки,1)	
	from tblСписокЗаказов s
	where Код_отправки like 's99_';

	update s set Код_отправки = 's00' + RIGHT(Код_отправки,3)
	from tblСписокЗаказов s
	where Код_отправки not like 's99_'
		and Код_отправки like 's[0-9][0-9][0-9]';	
	
commit -- rollback


select * from dbo.TableLogs 
where IDNUMBER_old = 'F0920-6402'
select * from dbo.Перечень_таблиц;


select * from dbo.TableLogs 
where TableID = 16
	and DateTime_ > '20200129'
	--and User_ = 'IFLAB\A.Makarova'
	and Fields_ like 'Код_отправки=s99999->%'


select Код_отправки, *
from tblВыполненныеЗаказы
where Код_отправки like 's99_'

select * from dbo.TableLogs 
where TableID = 7
	and DateTime_ > '20200124'
	--and User_ = 'IFLAB\A.Makarova'
	and Fields_ like 'Код_отправки=s998%'
		