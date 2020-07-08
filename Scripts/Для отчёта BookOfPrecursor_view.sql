USE [SKLAD30]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].repMonthRest_H2SO4
AS

--select v.Код_ID from __Вещества v where CAS = '7664-93-9' and v.Код_с  = 8; -- 15733

with cteMoves(Y,M,DateMove,ID,Volume,VolIn,VolOut)
as
(
	select YEAR(ps.Дата) as Y
		, MONTH(ps.Дата) as M
		, ps.Дата
		, ps.Код_ID
		, p.Size * p.Qty as Volume
		, p.Size * p.Qty as VolIn
		, 0 as VolOut
	from __Приемка p 
		left join __Поставки ps on ps.Код_ID = p.Код_ID_поставки
	where p.Код_ID_вещества = 15733 
		and p.Код_с = 8
	union all	
	-- расход	
	SELECT  YEAR(v.Дата) as Y
		, MONTH(v.Дата) as M
		, v.Дата  
		, v.Код_ID
		, -CASE WHEN (v.Код_движения = 6) THEN - 1 ELSE 1 END * v.Выдано  AS Volume
		, 0 as VolIn
		, CASE WHEN (v.Код_движения = 6) THEN - 1 ELSE 1 END * v.Выдано  AS VolOut
	FROM       
	  __Приемка p 
	  LEFT OUTER JOIN __Выдачи v ON (p.[Код_ID] = v.[Код_ID_приемки])
	where p.Код_ID_вещества = 15733 
		and p.Код_с = 8
)

select top 100 PERCENT 
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
	)x
group by x.Y, x.M, x.BegRest
order by x.Y, x.M
;

GO

grant select on repMonthRest_H2SO4 to SKLAD30;
go
