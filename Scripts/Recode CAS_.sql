use SKLAD30;
go

select v1.Код_ID as ID, v1.CAS,  v2.Код_ID as ID2 , v2.CAS as CAS2
--into #RecodeTable
from __Вещества v1
	inner join __Вещества v2 on v2.CAS = v1.CAS +'_' and v1.Код_с = v2.Код_с

select v1.Код_ID, v1.Код_с,  v1.CAS, *
from __Вещества v1
where v1.CAS in (select CAS from #RecodeTable)

select * 
from __Приемка p
	inner join #RecodeTable t on t.ID2 = p.Код_ID_вещества
select * 
from __Требования  p
	inner join #RecodeTable t on t.ID2 = p.Код_ID_вещества
select * 
from __Заявки  p
	inner join #RecodeTable t on t.ID2 = p.Код_ID_вещества		
	
begin tran
update p set Код_ID_вещества = t.ID
from __Приемка p
	inner join #RecodeTable t on t.ID2 = p.Код_ID_вещества	
	
delete from __Вещества where Код_ID	in (select ID2 from #RecodeTable)
commit -- rollback
	
---------------
--update __Вещества set [(0)RusName] = '1-', RusName = 'Бром-2-хлорэтан' where Код_ID = 23753
--update __Вещества set  RusName = 'Этиловый эфир аминоуксусной кислоты' where Код_ID = 17652