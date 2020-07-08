USE [SKLAD30]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].repMonthRest_H2SO4
AS

--select v.���_ID from __�������� v where CAS = '7664-93-9' and v.���_�  = 8; -- 15733

with cteMoves(Y,M,DateMove,ID,Volume,VolIn,VolOut)
as
(
	select YEAR(ps.����) as Y
		, MONTH(ps.����) as M
		, ps.����
		, ps.���_ID
		, p.Size * p.Qty as Volume
		, p.Size * p.Qty as VolIn
		, 0 as VolOut
	from __������� p 
		left join __�������� ps on ps.���_ID = p.���_ID_��������
	where p.���_ID_�������� = 15733 
		and p.���_� = 8
	union all	
	-- ������	
	SELECT  YEAR(v.����) as Y
		, MONTH(v.����) as M
		, v.����  
		, v.���_ID
		, -CASE WHEN (v.���_�������� = 6) THEN - 1 ELSE 1 END * v.������  AS Volume
		, 0 as VolIn
		, CASE WHEN (v.���_�������� = 6) THEN - 1 ELSE 1 END * v.������  AS VolOut
	FROM       
	  __������� p 
	  LEFT OUTER JOIN __������ v ON (p.[���_ID] = v.[���_ID_�������])
	where p.���_ID_�������� = 15733 
		and p.���_� = 8
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
