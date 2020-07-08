use SKLAD30;

/*
select s.*, v.* 
from __�������� v inner join ������ s on s.��� = v.���_�
where CAS = '7664-93-9'
	and s.��� in (1,8)
*/	
	
declare @beg_date date, @end_date date;
declare @store_id int = 8;	
declare @material_id  int;	
declare @rests table(Y int, M int, BegRest int, VIn int, VOut int, EndRest int);

select 	@beg_date = '20180701', @end_date = '20181231'
select @material_id = v.���_ID from __�������� v where CAS = '7647-01-0' and v.���_�  = @store_id;
select * from __�������� v where CAS = '7647-01-0' and v.���_�  = @store_id;
/*	
select YEAR(ps.����) as Y, MONTH(ps.����) as M, ps.����, p.���_ID, p.Size * p.Qty as Volume
from __������� p left join __�������� ps on ps.���_ID = p.���_ID_��������
where p.���_ID_�������� = @material_id
	and ps.���� between @beg_date and @end_date;
*/	
--select * from [�������_��_��������]	where ���_ID_�������� = @material_id;

/*	

SELECT  dbo.__������.���� AS ����_������, 
		CASE WHEN (dbo.__������.���_�������� = 6) THEN - 1 ELSE 1 END * dbo.__������.������  AS ������,
		dbo.__������.���_���������, 
		dbo.__������.���_������,
		dbo.__�����������.�����������
		, dbo.__�����������.[������ �������� �����������]
FROM       
  dbo.[__�������] 
  LEFT OUTER JOIN dbo.[__������] ON (dbo.[__�������].[���_ID] = dbo.[__������].[���_ID_�������])
  LEFT OUTER JOIN dbo.[__�����������] ON (dbo.[__������].[���_ID_�����������] = dbo.[__�����������].[���_ID])
where ���_ID_�������� = @material_id and dbo.__�������.���_� = @store_id;	
*/
-- ��������
-- �����������

with cteMoves(Y,M,DateMove,ID,Volume,VolIn,VolOut,[GUID])
as
(
	select YEAR(ps.����) as Y
		, MONTH(ps.����) as M
		, ps.����
		, ps.���_ID
		, p.Size * p.Qty as Volume
		, p.Size * p.Qty as VolIn
		, 0 as VolOut
		, NEWID() as [GUID]
	from __������� p left join __�������� ps on ps.���_ID = p.���_ID_��������
	where p.���_ID_�������� = @material_id
	union all	
	-- ������	
	SELECT  YEAR(dbo.__������.����) as Y
		, MONTH(dbo.__������.����) as M
		, dbo.__������.����  
		, dbo.__������.���_ID
		, -CASE WHEN (dbo.__������.���_�������� = 6) THEN - 1 ELSE 1 END * dbo.__������.������  AS Volume
		, 0 as VolIn
		, CASE WHEN (dbo.__������.���_�������� = 6) THEN - 1 ELSE 1 END * dbo.__������.������  AS VolOut
		, NEWID() as [GUID]

	FROM       
	  dbo.[__�������] 
	  LEFT OUTER JOIN dbo.[__������] ON (dbo.[__�������].[���_ID] = dbo.[__������].[���_ID_�������])
	  LEFT OUTER JOIN dbo.[__�����������] ON (dbo.[__������].[���_ID_�����������] = dbo.[__�����������].[���_ID])
	where ���_ID_�������� = @material_id 
		and dbo.__�������.���_� = @store_id
)

insert into @rests
select 
	x.Y
	, x.M
	, x.BegRest
	, SUM(x.VolIn) as VIn
	, SUM(x.VolOut) as VOut
	, x.BegRest + (SUM(x.Volume)) as EndRest
from
	(select m.Y
			,m.M
			,m.DateMove
			,m.ID
			,m.Volume
			,m.VolIn
			,m.VolOut
			, SUM(x.Volume) as BegRest
	from cteMoves m
		inner join  cteMoves x on x.DateMove < CAST(cast(m.Y as varchar(4)) + right(('0'+ cast(m.M as varchar(2))),2)+'01' AS date)
	group by m.Y
			,m.M
			,m.DateMove
			,m.ID
			,m.Volume
			,m.VolIn
			,m.VolOut
			,m.[GUID] 
	)x
group by x.Y, x.M, x.BegRest
order by x.Y, x.M
;

select * from @rests;

--sp_helplanguage 
--SET LANGUAGE Ukranian;

with cteMoves(Y,M,DateMove,ID,ClientCode,OrderCode,SInfoNUMBER,CustName,Volume,VolIn,VolOut)
as
(
	select YEAR(ps.����) as Y
		, MONTH(ps.����) as M
		, ps.����
		, ps.���_ID
		, null as ClientCode
		, null as OrderCode
		, null as SInfoNUMBER
		, null as CustName
		, p.Size * p.Qty as Volume
		, p.Size * p.Qty as VolIn
		, 0 as VolOut
	from __������� p 
		left join __�������� ps on ps.���_ID = p.���_ID_��������
	where p.���_ID_�������� = @material_id
	union all	
	-- ������	
	SELECT  YEAR(v.����) as Y
		, MONTH(v.����) as M
		, v.����  
		, v.���_ID
		, v.���_��������� as ClientCode
		, v.���_������ as OrderCode
		, v.SInfoNUMBER
		, pt.[������ �������� �����������] as CustName
		, -CASE WHEN (v.���_�������� = 6) THEN - 1 ELSE 1 END * v.������  AS Volume
		, 0 as VolIn
		, CASE WHEN (v.���_�������� = 6) THEN - 1 ELSE 1 END * v.������  AS VolOut
	FROM       
	  [__�������] p
	  LEFT OUTER JOIN [__������] v  ON p.[���_ID] = v.[���_ID_�������]
	  LEFT OUTER JOIN dbo.[__�����������] pt ON (v.[���_ID_�����������] = pt.[���_ID])
	where ���_ID_�������� = @material_id 
		and p.���_� = @store_id
)

--select * from cteMoves

select datename(m, cast((cast(m.Y as varchar(4)) +  right('0'+cast(m.M as varchar(2)),2) + '01') as Date))
	+ ' ' + cast(m.Y as varchar(4)) as Period
	, r.BegRest
	, m.*
	, r.EndRest 
from @rests r
	inner join cteMoves m on m.Y = r.Y and m.M = r.M
where 	m.DateMove between @beg_date and @end_date
order by m.DateMove;	


go	


if OBJECT_ID(N'getMonthRests') is not null drop procedure getMonthRests
go

create procedure getMonthRests @CAS varchar(64), @store_id int
as
begin
 
declare @material_id  int;	
select @material_id = v.���_ID from __�������� v where CAS = @CAS and v.���_�  = @store_id;

with cteMoves(Y,M,DateMove,ID,Volume,VolIn,VolOut,[GUID])
as
(
	select YEAR(ps.����) as Y
		, MONTH(ps.����) as M
		, ps.����
		, ps.���_ID
		, p.Size * p.Qty as Volume
		, p.Size * p.Qty as VolIn
		, 0 as VolOut
		, NEWID() as [GUID]
	from __������� p 
		left join __�������� ps on ps.���_ID = p.���_ID_��������
	where p.���_ID_�������� = @material_id
	union all	
	-- ������	
	SELECT  YEAR(v.����) as Y
		, MONTH(v.����) as M
		, v.����  
		, v.���_ID
		, -CASE WHEN (v.���_�������� = 6) THEN - 1 ELSE 1 END * v.������  AS Volume
		, 0 as VolIn
		, CASE WHEN (v.���_�������� = 6) THEN - 1 ELSE 1 END * v.������  AS VolOut
		, NEWID() as [GUID]
	FROM       
	  __������� p 
	  LEFT OUTER JOIN __������ v ON (p.[���_ID] = v.[���_ID_�������])
	where p.���_ID_�������� = @material_id 
		and p.���_� = @store_id
)

select 
	x.Y
	, x.M
	, x.BegRest
	, SUM(x.VolIn) as VIn
	, SUM(x.VolOut) as VOut
	, x.BegRest + (SUM(x.Volume)) as EndRest
from
	(select m.Y
			,m.M
			,m.DateMove
			, m.ID
			,m.Volume
			,m.VolIn
			,m.VolOut
			, SUM(x.Volume) as BegRest
	from cteMoves m
		inner join  cteMoves x on x.DateMove < CAST(cast(m.Y as varchar(4)) + right(('0'+ cast(m.M as varchar(2))),2)+'01' AS date)
	group by m.Y
			,m.M
			,m.DateMove
			, m.ID
			,m.Volume
			,m.VolIn
			,m.VolOut
			, m.[GUID] 
	)x
group by x.Y, x.M, x.BegRest
order by x.Y, x.M
;

end
go

grant exec on getMonthRests to SKLAD30;
--grant exec on getMonthRests to [IFLAB\v.zatkhey];
go

exec getMonthRests '7664-93-9', 8;
exec getMonthRests '67-64-1', 8;
exec getMonthRests '67-64-1', 1;
exec getMonthRests '67-64-1', 0;
exec getMonthRests '7647-01-0', 8;
select * from repMonthRest_H2SO4;
 /*==========================================================*/
/*
exec sp_helptext 'SKLAD30_������'
exec sp_helptext 'SKLAD30_������'
exec sp_helptext 'SKLAD30_������_full'
exec sp_helptext 'SKLAD30_��������'
exec sp_helptext 'SKLAD30_�������'

exec sp_helptext '�������'
exec sp_helptext '�������_1'
exec sp_helptext '�������_0_g'
exec sp_helptext '__������_2'

exec sp_helptext '�������_��_��������'
exec sp_helptext '�����_��_�������_0'
exec sp_helptext '__������_2'

*/	
/*
	select YEAR(ps.����) as Y
		, MONTH(ps.����) as M
		, ps.����
		, ps.���_ID
		, p.Size * p.Qty as Volume
		, p.Size * p.Qty as VolIn
		, 0 as VolOut
	from __������� p left join __�������� ps on ps.���_ID = p.���_ID_��������
	where p.���_ID_�������� = 15727
	union all	
	-- ������	
	SELECT  YEAR(dbo.__������.����) as Y
		, MONTH(dbo.__������.����) as M
		, dbo.__������.����  
		, dbo.__������.���_ID
		, -CASE WHEN (dbo.__������.���_�������� = 6) THEN - 1 ELSE 1 END * dbo.__������.������  AS Volume
		, 0 as VolIn
		, CASE WHEN (dbo.__������.���_�������� = 6) THEN - 1 ELSE 1 END * dbo.__������.������  AS VolOut
	FROM       
	  dbo.[__�������] 
	  LEFT OUTER JOIN dbo.[__������] ON (dbo.[__�������].[���_ID] = dbo.[__������].[���_ID_�������])
	  LEFT OUTER JOIN dbo.[__�����������] ON (dbo.[__������].[���_ID_�����������] = dbo.[__�����������].[���_ID])
	where ���_ID_�������� = 15727 
		and dbo.__�������.���_� = 8
	order by ps.����,  ps.���_ID	
	/*