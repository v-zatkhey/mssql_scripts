use SKLAD30;
go

select v1.���_ID as ID, v1.CAS,  v2.���_ID as ID2 , v2.CAS as CAS2
--into #RecodeTable
from __�������� v1
	inner join __�������� v2 on v2.CAS = v1.CAS +'_' and v1.���_� = v2.���_�

select v1.���_ID, v1.���_�,  v1.CAS, *
from __�������� v1
where v1.CAS in (select CAS from #RecodeTable)

select * 
from __������� p
	inner join #RecodeTable t on t.ID2 = p.���_ID_��������
select * 
from __����������  p
	inner join #RecodeTable t on t.ID2 = p.���_ID_��������
select * 
from __������  p
	inner join #RecodeTable t on t.ID2 = p.���_ID_��������		
	
begin tran
update p set ���_ID_�������� = t.ID
from __������� p
	inner join #RecodeTable t on t.ID2 = p.���_ID_��������	
	
delete from __�������� where ���_ID	in (select ID2 from #RecodeTable)
commit -- rollback
	
---------------
--update __�������� set [(0)RusName] = '1-', RusName = '����-2-��������' where ���_ID = 23753
--update __�������� set  RusName = '�������� ���� ������������� �������' where ���_ID = 17652