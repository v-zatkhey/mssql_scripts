select COUNT(*) -- 3324288	-- 2401682
from dbo._tmp_Scaffold_IDNUMBER t
	inner join dbo.tblScaffold s on s.Code = t.LCT -- 2401860	-- 2015_10 - 3323836
	inner join dbo.Materials m on m.MatName = t.IDNUMBER -- 3324102  --without LCT09262,LCT09468,LCT01319,LCT06424  

select t.LCT, count(distinct m.MatName), count(distinct s.Code)
from dbo._tmp_Scaffold_IDNUMBER t
	left join dbo.tblScaffold s on s.Code = t.LCT 
	left join dbo.Materials m on m.MatName = t.IDNUMBER  
where m.MatID is null or s.ID is null
group by t.LCT

select t.LCT, COUNT(m.MatName), COUNT(st.ID) -- 3324288	-- 2401682
from dbo._tmp_Scaffold_IDNUMBER t
	inner join dbo.tblScaffold s on s.Code = t.LCT -- 2401860	
	inner join dbo.Materials m on m.MatName = t.IDNUMBER -- 3324102  --without LCT09262,LCT09468,LCT01319,LCT06424  
	left join dbo.tbl����� st on st.ID = m.MatName
group by t.LCT
order by COUNT(*) desc
----------------------------------
select COUNT(*)
from dbo._tmp_scaffold_2015_10 -- 12875


select COUNT(*)
from dbo._tmp_scaffold_2015_10 t
	left join tblScaffold s on s.Code = t.LCT
where s.ID is null	-- 6817

--insert into dbo.tblScaffold(Code)
select t.LCT
from dbo._tmp_scaffold_2015_10 t
	left join tblScaffold s on s.Code = t.LCT
where s.ID is null	-- 6817
order by t.LCT

--insert into tblScaffold(Code) values('LCT12946');

--insert into dbo.tblScaffoldMaterials(ScaffoldID, MatID)  -- (����� ����������: 3324102)
select s.ID, m.MatID
from dbo._tmp_Scaffold_IDNUMBER t
	inner join dbo.tblScaffold s on s.Code = t.LCT 
	inner join dbo.Materials m on m.MatName = t.IDNUMBER -- 3324102  --without LCT09262,LCT09468,LCT01319,LCT06424  
	
/********************************/
-- ������� �������� ����� ������ 00050-z01680,30050-z00139, ��� ���������� �� ��������� LCT13693.

select * 
from tbl������ l
where (l.���_��������� = '00050'and l.���_������ = 'z01680')
	or (l.���_��������� = '30050'and l.���_������ = 'z00139')

select l.���_���������, l.���_������, l.�����������, COUNT(*) as cnt 
from tbl������������� l
where (l.���_��������� = '00050'and l.���_������ = 'z01680')
	or (l.���_��������� = '30050'and l.���_������ = 'z00139')
group by l.���_���������, l.���_������, l.�����������

select * 
from tbl����������������� l
where (l.���_��������� = '00050'and l.���_������ = 'z01680')
	or (l.���_��������� = '30050'and l.���_������ = 'z00139')
	
	
	select * from tblScaffold where Code = 'LCT13693';
--update tblScaffoldChemist set NeedMsgSend = 1 where ID = 3641;
	select sc.*
		, t.���_���������� 
	from tblScaffoldChemist sc 
		inner join  t on t.��� = sc.ChemistID
	where ScaffoldID = 6769 and needmsgsend <> 0;
	select sm.*, m.MatName 
	from dbo.tblScaffoldMaterials sm
		inner join Materials m on m.MatID = sm.MatID 
	where sm.ScaffoldID = 6769;
	
	--insert into tblScaffoldMaterials(ScaffoldID,	MatID)
	select 6769, mat.MatID
	from tbl������������� l
		inner join Materials mat on mat.MatName = l.ID
	where ( (l.���_��������� = '00050'and l.���_������ = 'z01680')
		or (l.���_��������� = '30050'and l.���_������ = 'z00139'))
		and not exists(select sm.*, m.MatName 
						from dbo.tblScaffoldMaterials sm
							inner join Materials m on m.MatID = sm.MatID 
						where sm.ScaffoldID = 6769 and m.MatName = l.ID)
	
select s.Code as ScaffoldCode, m.MatName as IDNUMBER, p.���_����������, p.Email, f.���_����������, f.���_��������, f.�����_����, f.�������_��_��������
from tblScaffold s
	inner join tblScaffoldChemist sc on sc.ScaffoldID = s.ID 
	inner join tbl����������_full p on p.��� = sc.ChemistID
	inner join tblScaffoldMaterials sm on sm.ScaffoldID  = s.ID
	inner join Materials m on m.MatID = sm.MatID
	inner join tbl�������� f on f.ID = m.MatName
where sc.NeedMsgSend <> 0

	
select sc.ScaffoldID, s.Code as ScaffoldCode, sc.ChemistID, p.���_����������, p.Email, count(*) as AllCount
from tblScaffold s
	inner join tblScaffoldChemist sc on sc.ScaffoldID = s.ID 
	inner join tbl����������_full p on p.��� = sc.ChemistID
	inner join tblScaffoldMaterials sm on sm.ScaffoldID  = s.ID
	inner join Materials m on m.MatID = sm.MatID
	inner join tbl�������� f on f.ID = m.MatName
where sc.NeedMsgSend <> 0 and f.�������_��_�������� = 1
group by sc.ScaffoldID, s.Code, sc.ChemistID, p.���_����������, p.Email
having count(*)>=20;