use Chest35;
go

select ID, s.���_���������� + '-' + s.���_�������� as [���_��������] --, COUNT( *)
from tbl������ s
where ���_������� = 'S' 
	and  ��������� = 'OK'
	and [������������ ��� �������] like '%D2%'
	and ID like 'F____-____'
group by ID, s.���_���������� , s.���_��������	;