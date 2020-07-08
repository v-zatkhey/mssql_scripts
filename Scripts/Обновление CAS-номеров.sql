

SELECT DISTINCT IDNUMBER0 , *
FROM SKLAD30.dbo.SKLAD30_Вещества
WHERE CAS = '6790-58-5'


SELECT DISTINCT IDNUMBER0 , *  ----
FROM SKLAD30.dbo.SKLAD30_Вещества
WHERE CAS = '699-97-8'



SELECT DISTINCT MatName , *
FROM Chest35.dbo.Materials
WHERE CASNumber = '6790-58-5'



SELECT DISTINCT MatName , *
FROM Chest35.dbo.Materials
WHERE CASNumber =  '699-97-8'
/**************************************************/
select COUNT(*) from Materials where not CASNumber like ''

select COUNT(*) from dbo._tmp_Life_Chemicals_Building_Blocks_CAS;
select COUNT(*) from dbo._tmp_Life_Chemicals_HTS_Compounds_CAS;

select tS.IDNUMBER as IDNUMBER --_HTS
	, tS.CAS as CAS_HTS
--	, tBB.IDNUMBER as IDNUMBER_BB
	, tBB.CAS as CAS_BB 
from dbo._tmp_Life_Chemicals_HTS_Compounds_CAS tS
	inner join _tmp_Life_Chemicals_Building_Blocks_CAS tBB on tBB.IDNUMBER = tS.IDNUMBER
where tS.CAS != tBB.CAS
	and tS.IDNUMBER in ('F6619-1143',
'F6619-1141',
'F6619-0799',
'F6619-1087',
'F2169-0016',
'F2145-0846');

select IDNUMBER, COUNT(*) from dbo._tmp_Life_Chemicals_Building_Blocks_CAS
group by IDNUMBER
having COUNT(*)>1
;
select IDNUMBER, COUNT(*) from dbo._tmp_Life_Chemicals_HTS_Compounds_CAS
group by IDNUMBER
having COUNT(*)>1;

select m.MatName, m.CASNumber, t.CAS , t2.CAS
from Materials m
	left join _tmp_Life_Chemicals_Building_Blocks_CAS t on t.IDNUMBER = m.MatName
	left join dbo._tmp_Life_Chemicals_HTS_Compounds_CAS t2 on t2.IDNUMBER = m.MatName
where  (t.IDNUMBER is Not null OR   t2.IDNUMBER is Not null)
	and (isnull(m.CASNumber,'') <> t.CAS  or isnull(m.CASNumber,'') <> t2.CAS)
	and (t.CAS is Not null and t2.CAS is Not null and t.CAS <> t2.CAS) -- там, где перебиваются CAS
	and isnull(m.CASNumber,'') <> t2.CAS  
	 ;

--select * from Materials where CASNumber not like '%-%-[0-9]';
--update Materials set CASNumber = '74572-19-3' where MatID = 4668269
--update Materials set CASNumber = null where CASNumber not like '%-%-[0-9]';
--select * from dbo.[tblCS-ID] where CS like '%-%-[0-9]';

/*
insert into dbo.tblID_CAS(IDNUMBER, CAS)
select ID, CS 
from dbo.[tblCS-ID] c
where CS like '%-%-[0-9]'
	and not exists(select * from tblID_CAS where IDNUMBER = c.ID and CAS = c.CS );
*/

/************** резервная копия CAS-номеров ******************/
/* -- 517012
select m.MatID, m.MatName, m.CASNumber
into _tmp_CASNumber_bak_20190425
from Materials m
	left join _tmp_Life_Chemicals_Building_Blocks_CAS t on t.IDNUMBER = m.MatName
	left join dbo._tmp_Life_Chemicals_HTS_Compounds_CAS t2 on t2.IDNUMBER = m.MatName
where  (t.IDNUMBER is Not null OR   t2.IDNUMBER is Not null);
*/

/****** Building Blocks*************/
update m set CASNumber = t.CAS
-- select m.MatName, m.CASNumber, t.CAS -- 2621
from Materials m
	inner join _tmp_Life_Chemicals_Building_Blocks_CAS t on t.IDNUMBER = m.MatName
where isnull(m.CASNumber,'') <> t.CAS;
-- (строк обработано: 2621)

/******HTS*****/
update m set CASNumber = t.CAS
-- select m.MatName, m.CASNumber, t.CAS -- 2365
from Materials m
	inner join _tmp_Life_Chemicals_HTS_Compounds_CAS t on t.IDNUMBER = m.MatName
where isnull(m.CASNumber,'') <> t.CAS;
-- (строк обработано: 2365)

/******** то, что "затёрлось" ************************/
insert into dbo.tblID_CAS(IDNUMBER, CAS)
select m.MatName, t.CAS
from Materials m
	inner join _tmp_Life_Chemicals_Building_Blocks_CAS t on t.IDNUMBER = m.MatName
where isnull(m.CASNumber,'') <> t.CAS
	and not exists(select * from tblID_CAS where IDNUMBER = t.IDNUMBER and CAS = t.CAS );
-- (строк обработано: 43)
