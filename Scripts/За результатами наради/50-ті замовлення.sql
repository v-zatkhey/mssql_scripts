-- �� ������ ������� 50-� ���������
select distinct ���_��������� 
from tbl������ 
where ���_��������� like '_0050';

select *
from tbl������ 
where ���_��������� = '00050'
	and ���_������ = 'z01672'
order by ���� desc;

select *
from tbl������������� 
where ���_��������� = '00050'
	and ���_������ = 'z01672';
	
select top 100 *
from tbl����������������� 
where ���_��������� = '00050'
	and ���_������ = 'z01672'
order by ���_ID desc;
-------------------

select *
from tbl������ 
where ���_��������� in ( '10050','30050')
order by ���� desc;

select s.ID--, p.�����������
from tbl������������� s
--	 left join tbl_����������_���� p on p.ID = s.ID   
where ���_��������� in ( '10050','30050')
	and ���_������ in ( 'z00188','z00105')
	and not exists(select * from tbl_����������_���� where ID = s.ID)
;