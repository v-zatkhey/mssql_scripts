select c.Название, p.*
from tblПоставщики_full p
	left join tblКатегории_Поставщиков c on c.Код = p.Категория 
where p.Код_поставщика in ('BLV', 'SRV', 'ZOV')

	SELECT	pf.Категория, kp.Название, COUNT(*) as cnt -- cst.CustName ,m.MatName,  , mi.*
	FROM OPENROWSET(
			BULK       N'M:\Public_sh\Zatkhey Volodymyr\SIM-200507\SIM-all.txt',
			FORMATFILE=N'M:\Private_sh\Zatkhey Volodymyr\DataParametersForRating\ID_list.xml', 
			FIRSTROW = 3 
				   ) AS c
		inner join Materials m on m.MatName = c.idnumber collate SQL_Ukrainian_CP1251_CI_AS
		inner join MaterialInfo mi on mi.MatID = m.MatID
		inner join Customers cst on cst.CustID = mi.CustID
		inner join tblПоставщики_full pf on pf.Код_поставщика = cst.CustName 
		left join tblКатегории_Поставщиков kp on kp.Код = pf.Категория 
	WHERE mi.DateFailure is null
		--and pf.Категория not in( 1, 2, 9, 16)
	group by pf.Категория, kp.Название;
go

	SELECT	 COUNT(*) as cnt -- cst.CustName ,m.MatName,  , mi.*
	FROM OPENROWSET(
			BULK       N'M:\Public_sh\Zatkhey Volodymyr\SIM-200507\SIM-all.txt',
			FORMATFILE=N'M:\Private_sh\Zatkhey Volodymyr\DataParametersForRating\ID_list.xml', 
			FIRSTROW = 3 
				   ) AS c
		inner join Materials m on m.MatName = c.idnumber collate SQL_Ukrainian_CP1251_CI_AS
		inner join MaterialInfo mi on mi.MatID = m.MatID
		inner join Customers cst on cst.CustID = mi.CustID
		inner join tblПоставщики_full pf on pf.Код_поставщика = cst.CustName 
	WHERE mi.DateFailure is null
		and pf.Категория not in( 1, 2, 9, 16)
	;

--  172028
--  183991
--  183583
--    9834
	-- drop table #tmpIdCustomer;
	SELECT	 m.MatName
		, cst.CustName
		, mi.DateInsert 
		, ROW_NUMBER() over (partition by MatName order by CustName) as idx
		-- , COUNT(*) as cnt
	into #tmpIdCustomer
	FROM OPENROWSET(
			BULK       N'M:\Public_sh\Zatkhey Volodymyr\SIM-200507\SIM-all.txt',
			FORMATFILE=N'M:\Private_sh\Zatkhey Volodymyr\DataParametersForRating\ID_list.xml', 
			FIRSTROW = 3 
				   ) AS c
		inner join Materials m on m.MatName = c.idnumber collate SQL_Ukrainian_CP1251_CI_AS
		inner join MaterialInfo mi on mi.MatID = m.MatID
		inner join Customers cst on cst.CustID = mi.CustID
		inner join tblПоставщики_full pf on pf.Код_поставщика = cst.CustName 
	WHERE mi.DateFailure is null
		and pf.Категория not in( 1, 2, 3, 9, 16)
		--and pf.Категория = 3
--	GROUP BY pf.Категория
	ORDER BY m.MatName
	;
	
	select MatName
		, CustName
		, cast(DateInsert as Date)
		, idx
	from #tmpIdCustomer t;
	
	with concat_CustName(IDNUMBER, CustInfo, cnt)
	as
	(
	select MatName
		, CAST(CustName as varchar(max)) 
		 + ' ' 
		 +CAST( cast(DateInsert as Date) as varchar(10))
		 , idx as cnt 
	from #tmpIdCustomer t1
	where idx = 1
	union all
	select  t1.IDNUMBER
		  , t1.CustInfo + ', ' 
		  + CAST(t2.CustName as varchar(max)) 
		  + ' ' 
		  +CAST( cast(t2.DateInsert as Date) as varchar(10))
		  , t1.cnt + 1  
	from concat_CustName t1
		inner join #tmpIdCustomer t2 on t2.MatName = t1.IDNUMBER 
			and t2.idx = t1.cnt+1 
	)
		
	select t.IDNUMBER, t.CustInfo 
	from 	concat_CustName t
		inner join(
			select MatName, COUNT(*) as cnt 
			from #tmpIdCustomer
			group by MatName) x on x.MatName = t.IDNUMBER and x.cnt = t.cnt
	order by t.IDNUMBER;
	
	select MatName as IDNUMBER, CustName 
	from #tmpIdCustomer t
	order by t.MatName;