use SKLAD30;

/*
select s.*, v.* 
from __Вещества v inner join Склады s on s.Код = v.Код_с
where CAS = '7664-93-9'
	and s.Код in (1,8)
*/	
	
declare @beg_date date, @end_date date;
declare @store_id int = 8;	
declare @material_id  int;	
declare @rests table(Y int, M int, BegRest int, VIn int, VOut int, EndRest int);

select 	@beg_date = '20180701', @end_date = '20181231'
select @material_id = v.Код_ID from __Вещества v where CAS = '7647-01-0' and v.Код_с  = @store_id;
select * from __Вещества v where CAS = '7647-01-0' and v.Код_с  = @store_id;
/*	
select YEAR(ps.Дата) as Y, MONTH(ps.Дата) as M, ps.Дата, p.Код_ID, p.Size * p.Qty as Volume
from __Приемка p left join __Поставки ps on ps.Код_ID = p.Код_ID_поставки
where p.Код_ID_вещества = @material_id
	and ps.Дата between @beg_date and @end_date;
*/	
--select * from [Остатки_по_Приемкам]	where Код_ID_вещества = @material_id;

/*	

SELECT  dbo.__Выдачи.Дата AS Дата_выдачи, 
		CASE WHEN (dbo.__Выдачи.Код_движения = 6) THEN - 1 ELSE 1 END * dbo.__Выдачи.Выдано  AS Выдано,
		dbo.__Выдачи.Код_заказчика, 
		dbo.__Выдачи.Код_заказа,
		dbo.__Потребители.Потребитель
		, dbo.__Потребители.[Полное название потребителя]
FROM       
  dbo.[__Приемка] 
  LEFT OUTER JOIN dbo.[__Выдачи] ON (dbo.[__Приемка].[Код_ID] = dbo.[__Выдачи].[Код_ID_приемки])
  LEFT OUTER JOIN dbo.[__Потребители] ON (dbo.[__Выдачи].[Код_ID_потребителя] = dbo.[__Потребители].[Код_ID])
where Код_ID_вещества = @material_id and dbo.__Приемка.Код_с = @store_id;	
*/
-- движения
-- поступления

with cteMoves(Y,M,DateMove,ID,Volume,VolIn,VolOut,[GUID])
as
(
	select YEAR(ps.Дата) as Y
		, MONTH(ps.Дата) as M
		, ps.Дата
		, ps.Код_ID
		, p.Size * p.Qty as Volume
		, p.Size * p.Qty as VolIn
		, 0 as VolOut
		, NEWID() as [GUID]
	from __Приемка p left join __Поставки ps on ps.Код_ID = p.Код_ID_поставки
	where p.Код_ID_вещества = @material_id
	union all	
	-- расход	
	SELECT  YEAR(dbo.__Выдачи.Дата) as Y
		, MONTH(dbo.__Выдачи.Дата) as M
		, dbo.__Выдачи.Дата  
		, dbo.__Выдачи.Код_ID
		, -CASE WHEN (dbo.__Выдачи.Код_движения = 6) THEN - 1 ELSE 1 END * dbo.__Выдачи.Выдано  AS Volume
		, 0 as VolIn
		, CASE WHEN (dbo.__Выдачи.Код_движения = 6) THEN - 1 ELSE 1 END * dbo.__Выдачи.Выдано  AS VolOut
		, NEWID() as [GUID]

	FROM       
	  dbo.[__Приемка] 
	  LEFT OUTER JOIN dbo.[__Выдачи] ON (dbo.[__Приемка].[Код_ID] = dbo.[__Выдачи].[Код_ID_приемки])
	  LEFT OUTER JOIN dbo.[__Потребители] ON (dbo.[__Выдачи].[Код_ID_потребителя] = dbo.[__Потребители].[Код_ID])
	where Код_ID_вещества = @material_id 
		and dbo.__Приемка.Код_с = @store_id
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
	select YEAR(ps.Дата) as Y
		, MONTH(ps.Дата) as M
		, ps.Дата
		, ps.Код_ID
		, null as ClientCode
		, null as OrderCode
		, null as SInfoNUMBER
		, null as CustName
		, p.Size * p.Qty as Volume
		, p.Size * p.Qty as VolIn
		, 0 as VolOut
	from __Приемка p 
		left join __Поставки ps on ps.Код_ID = p.Код_ID_поставки
	where p.Код_ID_вещества = @material_id
	union all	
	-- расход	
	SELECT  YEAR(v.Дата) as Y
		, MONTH(v.Дата) as M
		, v.Дата  
		, v.Код_ID
		, v.Код_заказчика as ClientCode
		, v.Код_заказа as OrderCode
		, v.SInfoNUMBER
		, pt.[Полное название потребителя] as CustName
		, -CASE WHEN (v.Код_движения = 6) THEN - 1 ELSE 1 END * v.Выдано  AS Volume
		, 0 as VolIn
		, CASE WHEN (v.Код_движения = 6) THEN - 1 ELSE 1 END * v.Выдано  AS VolOut
	FROM       
	  [__Приемка] p
	  LEFT OUTER JOIN [__Выдачи] v  ON p.[Код_ID] = v.[Код_ID_приемки]
	  LEFT OUTER JOIN dbo.[__Потребители] pt ON (v.[Код_ID_потребителя] = pt.[Код_ID])
	where Код_ID_вещества = @material_id 
		and p.Код_с = @store_id
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
select @material_id = v.Код_ID from __Вещества v where CAS = @CAS and v.Код_с  = @store_id;

with cteMoves(Y,M,DateMove,ID,Volume,VolIn,VolOut,[GUID])
as
(
	select YEAR(ps.Дата) as Y
		, MONTH(ps.Дата) as M
		, ps.Дата
		, ps.Код_ID
		, p.Size * p.Qty as Volume
		, p.Size * p.Qty as VolIn
		, 0 as VolOut
		, NEWID() as [GUID]
	from __Приемка p 
		left join __Поставки ps on ps.Код_ID = p.Код_ID_поставки
	where p.Код_ID_вещества = @material_id
	union all	
	-- расход	
	SELECT  YEAR(v.Дата) as Y
		, MONTH(v.Дата) as M
		, v.Дата  
		, v.Код_ID
		, -CASE WHEN (v.Код_движения = 6) THEN - 1 ELSE 1 END * v.Выдано  AS Volume
		, 0 as VolIn
		, CASE WHEN (v.Код_движения = 6) THEN - 1 ELSE 1 END * v.Выдано  AS VolOut
		, NEWID() as [GUID]
	FROM       
	  __Приемка p 
	  LEFT OUTER JOIN __Выдачи v ON (p.[Код_ID] = v.[Код_ID_приемки])
	where p.Код_ID_вещества = @material_id 
		and p.Код_с = @store_id
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
exec sp_helptext 'SKLAD30_Склады'
exec sp_helptext 'SKLAD30_Выдачи'
exec sp_helptext 'SKLAD30_Выдачи_full'
exec sp_helptext 'SKLAD30_Поставки'
exec sp_helptext 'SKLAD30_Приемки'

exec sp_helptext 'Остатки'
exec sp_helptext 'Остатки_1'
exec sp_helptext 'Остатки_0_g'
exec sp_helptext '__Выдачи_2'

exec sp_helptext 'Остатки_по_Приемкам'
exec sp_helptext 'Отчет_по_выдачам_0'
exec sp_helptext '__Выдачи_2'

*/	
/*
	select YEAR(ps.Дата) as Y
		, MONTH(ps.Дата) as M
		, ps.Дата
		, ps.Код_ID
		, p.Size * p.Qty as Volume
		, p.Size * p.Qty as VolIn
		, 0 as VolOut
	from __Приемка p left join __Поставки ps on ps.Код_ID = p.Код_ID_поставки
	where p.Код_ID_вещества = 15727
	union all	
	-- расход	
	SELECT  YEAR(dbo.__Выдачи.Дата) as Y
		, MONTH(dbo.__Выдачи.Дата) as M
		, dbo.__Выдачи.Дата  
		, dbo.__Выдачи.Код_ID
		, -CASE WHEN (dbo.__Выдачи.Код_движения = 6) THEN - 1 ELSE 1 END * dbo.__Выдачи.Выдано  AS Volume
		, 0 as VolIn
		, CASE WHEN (dbo.__Выдачи.Код_движения = 6) THEN - 1 ELSE 1 END * dbo.__Выдачи.Выдано  AS VolOut
	FROM       
	  dbo.[__Приемка] 
	  LEFT OUTER JOIN dbo.[__Выдачи] ON (dbo.[__Приемка].[Код_ID] = dbo.[__Выдачи].[Код_ID_приемки])
	  LEFT OUTER JOIN dbo.[__Потребители] ON (dbo.[__Выдачи].[Код_ID_потребителя] = dbo.[__Потребители].[Код_ID])
	where Код_ID_вещества = 15727 
		and dbo.__Приемка.Код_с = 8
	order by ps.Дата,  ps.Код_ID	
	/*