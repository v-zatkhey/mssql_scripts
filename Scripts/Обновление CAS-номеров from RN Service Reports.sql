select m.* 
from MaterialInfo i
	inner join Materials m on m.MatID = i.MatID
where m.MatName = 'F3409-1319'

select * from tblСпектр 
where Тип_спектра = 'T'
order by Дата_спектра desc;

------------------
select t.ID, t.CAS, m.MatName , m.CASNumber  
from dbo._tmp_RN_Service_Report_LC_BB_1_7_20 t
	left  join Materials m on m.MatName = t.ID
where	 m.MatName is null;

select COUNT(*) as Cnt 
from dbo._tmp_RN_Service_Report_LC_BB_1_7_20 t
	inner  join Materials m on m.MatName = t.ID
where m.CASNumber is  null

/*
update m set CASNumber = t.CAS 
from dbo._tmp_RN_Service_Report_LC_BB_1_7_20 t
	inner  join Materials m on m.MatName = t.ID
where  m.CASNumber is null;
*/
--insert into tblID_CAS(IDNUMBER , CAS )
select t.ID, t.CAS --, m.MatName , m.CASNumber  
from dbo._tmp_RN_Service_Report_LC_BB_1_7_20 t
	inner  join Materials m on m.MatName = t.ID
where  isnull(m.CASNumber,'') <> isnull(t.CAS,'') 
--72
	and Not exists(select * from tblID_CAS x where x.CAS = t.CAS) --x.IDNUMBER = t.ID and 
--6
------------------------------------------------------------------------------------------
select t.ID, t.CAS, m.MatName , m.CASNumber  
from dbo._tmp_RN_Service_Report_LC_HTC_1_7_20 t
	left  join Materials m on m.MatName = t.ID
where	 m.MatName is null;

select COUNT(*) as Cnt 
from dbo._tmp_RN_Service_Report_LC_HTC_1_7_20 t
	inner  join Materials m on m.MatName = t.ID
where  m.CASNumber is null;
--19821
/*
update m set CASNumber = t.CAS 
from dbo._tmp_RN_Service_Report_LC_HTC_1_7_20 t
	inner  join Materials m on m.MatName = t.ID
where  m.CASNumber is null;
*/

--insert into tblID_CAS(IDNUMBER , CAS )
select t.ID, t.CAS --, m.MatName , m.CASNumber  
into #tmp_ID
from dbo._tmp_RN_Service_Report_LC_HTC_1_7_20 t
	inner  join Materials m on m.MatName = t.ID
where  isnull(m.CASNumber,'') <> isnull(t.CAS,'')
	and Not exists(select * from tblID_CAS x where x.CAS = t.CAS)--x.IDNUMBER = t.ID and 
--23

select * 
from dbo.ISISHOST_change_log l
	inner join #tmp_ID t on t.ID = l.IDNUMBER 
order by l.IDNUMBER , l.Date_ desc