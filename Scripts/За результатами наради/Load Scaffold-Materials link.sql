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
	left join dbo.tblСклад st on st.ID = m.MatName
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

--insert into dbo.tblScaffoldMaterials(ScaffoldID, MatID)  -- (строк обработано: 3324102)
select s.ID, m.MatID
from dbo._tmp_Scaffold_IDNUMBER t
	inner join dbo.tblScaffold s on s.Code = t.LCT 
	inner join dbo.Materials m on m.MatName = t.IDNUMBER -- 3324102  --without LCT09262,LCT09468,LCT01319,LCT06424  
	
/********************************/
-- Сегодня оформили новые заказы 00050-z01680,30050-z00139, все соединения на скаффолде LCT13693.

select * 
from tblЗаказы l
where (l.Код_заказчика = '00050'and l.Код_заказа = 'z01680')
	or (l.Код_заказчика = '30050'and l.Код_заказа = 'z00139')

select l.Код_заказчика, l.Код_заказа, l.Исполнитель, COUNT(*) as cnt 
from tblСписокЗаказов l
where (l.Код_заказчика = '00050'and l.Код_заказа = 'z01680')
	or (l.Код_заказчика = '30050'and l.Код_заказа = 'z00139')
group by l.Код_заказчика, l.Код_заказа, l.Исполнитель

select * 
from tblВыполненныеЗаказы l
where (l.Код_заказчика = '00050'and l.Код_заказа = 'z01680')
	or (l.Код_заказчика = '30050'and l.Код_заказа = 'z00139')
	
	
	select * from tblScaffold where Code = 'LCT13693';
--update tblScaffoldChemist set NeedMsgSend = 1 where ID = 3641;
	select sc.*
		, t.Код_поставщика 
	from tblScaffoldChemist sc 
		inner join  t on t.Код = sc.ChemistID
	where ScaffoldID = 6769 and needmsgsend <> 0;
	select sm.*, m.MatName 
	from dbo.tblScaffoldMaterials sm
		inner join Materials m on m.MatID = sm.MatID 
	where sm.ScaffoldID = 6769;
	
	--insert into tblScaffoldMaterials(ScaffoldID,	MatID)
	select 6769, mat.MatID
	from tblСписокЗаказов l
		inner join Materials mat on mat.MatName = l.ID
	where ( (l.Код_заказчика = '00050'and l.Код_заказа = 'z01680')
		or (l.Код_заказчика = '30050'and l.Код_заказа = 'z00139'))
		and not exists(select sm.*, m.MatName 
						from dbo.tblScaffoldMaterials sm
							inner join Materials m on m.MatID = sm.MatID 
						where sm.ScaffoldID = 6769 and m.MatName = l.ID)
	
select s.Code as ScaffoldCode, m.MatName as IDNUMBER, p.Код_поставщика, p.Email, f.Код_поставщика, f.Код_поставки, f.Масса_пост, f.Решение_по_поставке
from tblScaffold s
	inner join tblScaffoldChemist sc on sc.ScaffoldID = s.ID 
	inner join tblПоставщики_full p on p.Код = sc.ChemistID
	inner join tblScaffoldMaterials sm on sm.ScaffoldID  = s.ID
	inner join Materials m on m.MatID = sm.MatID
	inner join tblПоставки f on f.ID = m.MatName
where sc.NeedMsgSend <> 0

	
select sc.ScaffoldID, s.Code as ScaffoldCode, sc.ChemistID, p.Код_поставщика, p.Email, count(*) as AllCount
from tblScaffold s
	inner join tblScaffoldChemist sc on sc.ScaffoldID = s.ID 
	inner join tblПоставщики_full p on p.Код = sc.ChemistID
	inner join tblScaffoldMaterials sm on sm.ScaffoldID  = s.ID
	inner join Materials m on m.MatID = sm.MatID
	inner join tblПоставки f on f.ID = m.MatName
where sc.NeedMsgSend <> 0 and f.Решение_по_поставке = 1
group by sc.ScaffoldID, s.Code, sc.ChemistID, p.Код_поставщика, p.Email
having count(*)>=20;