/****** ��, �� �������� ����������� � 2017 ����*/
select v.ID, m.CASNumber,  COUNT(*) as Cnt 
from tbl����������������� v
		inner join tbl������ z on z.���_��������� = v.���_��������� and z.���_������ = v.���_������ 
		inner join Materials m on m.MatName = v.ID
		left join tbl������������� bl on bl.ID = v.ID 
where v.����� >= 100
	and z.���� >= '20170101'	
	and bl.����_���������_�������������� is null
group by v.ID, m.CASNumber
having COUNT(*)>=5
order by COUNT(*) desc,ID

