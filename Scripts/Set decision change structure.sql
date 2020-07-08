use Chest35;
go

declare @ShiftIDNUMBER table(OldID varchar(10), NewID varchar(10));

insert into @ShiftIDNUMBER values ('F3377-0038', 'F3377-1051')
, ('F6033-0079', 'F5940-2230')
, ('F6033-0227', 'F5940-2409')
, ('F6033-0716', 'F5940-2554')
, ('F6033-0721', 'F5940-2559')
, ('F6033-0732', 'F5940-2570')
, ('F6033-0733', 'F5940-2571')
, ('F6112-0013', 'F5940-2670')
, ('F6112-0025', 'F5940-2671')
, ('F6112-0028', 'F5940-2672')
, ('F6112-0047', 'F5940-2673')
, ('F6112-0049', 'F5940-2674')
, ('F6112-0061', 'F5940-2675')
, ('F6112-0071', 'F5940-2676')
, ('F6112-0072', 'F5940-2677')
, ('F6112-0073', 'F5940-2678')
, ('F6112-0075', 'F5940-2679')
, ('F6112-0083', 'F5940-2680')
, ('F6112-0092', 'F5940-2681')
, ('F6112-0096', 'F5940-2682')
, ('F6112-0098', 'F5940-2683')
, ('F6112-0101', 'F5940-2684')
, ('F6112-0104', 'F5940-2685')
, ('F6112-0106', 'F5940-2686')
, ('F6112-0112', 'F5940-2687')
, ('F6112-0114', 'F5940-2688')
, ('F6112-0121', 'F5940-2689');

-- select * from @ShiftIDNUMBER;
-- SELECT * FROM [Chest35].[dbo].[Типы_решений_по_поставкам] where Код = 8
/*
begin tran
	update p set Решение_по_поставке = 8, Причина_решения = t.NewID
	from tblПоставки p
		inner join @ShiftIDNUMBER t on t.OldID = p.ID;
commit;


select p.ID, p.Код_поставщика, p.Код_поставки, p.Масса_пост, s.Блок, s.Результат 
from tblПоставки p
	inner join @ShiftIDNUMBER t on t.OldID = p.ID
	left join tblСпектр s on s.ID = p.ID and s.Код_tblПоставки_rev = p.Код and s.Тип_спектра in ('S','M')
order by p.ID;



begin tran
	update p set Дата_решения_по_поставке = CAST(getdate() as DATE)
	from tblПоставки p
		inner join @ShiftIDNUMBER t on t.OldID = p.ID;
commit;

*/

select t.*
	, m.Solubility_DMSO, m.PBS 
	, m2.Solubility_DMSO, m2.PBS
from Materials m 
	inner join @ShiftIDNUMBER t on t.OldID = m.MatName
	inner join Materials m2 on m2.MatName = t.[NewID]
where m.Solubility_DMSO is not null 

select t.*, m.Solubility_DMSO_Km, m2.Solubility_DMSO_Km 
from Materials m 
	inner join @ShiftIDNUMBER t on t.OldID = m.MatName
	inner join Materials m2 on m2.MatName = t.[NewID]
where m.Solubility_DMSO_Km is not null 

-- reset solubility
/*
update m2
set Solubility_DMSO = m.Solubility_DMSO
  , PBS = m.PBS 
from Materials m 
	inner join @ShiftIDNUMBER t on t.OldID = m.MatName
	inner join Materials m2 on m2.MatName = t.[NewID]
where m.Solubility_DMSO is not null 

update m2
set Solubility_DMSO_Km = m.Solubility_DMSO_Km
from Materials m 
	inner join @ShiftIDNUMBER t on t.OldID = m.MatName
	inner join Materials m2 on m2.MatName = t.[NewID]
where m.Solubility_DMSO_Km is not null 
*/

-- clear solubility

select t.*
	, m.MatName
	  , m.Solubility_DMSO
	  , m.PBS
	  , m.Solubility_DMSO_Km
from Materials m 
	inner join @ShiftIDNUMBER t on t.OldID = m.MatName
where m.Solubility_DMSO is not null
	or m.PBS is not null
	or m.Solubility_DMSO_Km is not null;
	
/*	
begin tran
	update m
	set Solubility_DMSO = null
	  , PBS =null
	  , Solubility_DMSO_Km = null
	from Materials m 
		inner join @ShiftIDNUMBER t on t.OldID = m.MatName
	where m.Solubility_DMSO is not null
		or m.PBS is not null
		or m.Solubility_DMSO_Km is not null;
commit; -- rollback
*/
