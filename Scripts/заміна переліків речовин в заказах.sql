-- 00050-z01694   ��������� ��   30050-z00150 

use Chest35 ;
go

select * 
from tbl������ s
where (s.���_��������� = '00050' and s.���_������ = 'z01694')
	or 
	  (s.���_��������� = '30050' and s.���_������ = 'z00150')

select * 
into _tmp_tbl�������������_back_20200709
from tbl������������� s
where (s.���_��������� = '00050' and s.���_������ = 'z01694')
	or 
	  (s.���_��������� = '30050' and s.���_������ = 'z00150');

begin tran
--update sp
--set ���_��������� = x.New_���_���������, ���_������ = x.New_���_������ 
select x.*, sp.ID, sp.���_���������, sp.���_������ 
from tbl������������� sp
	inner join
			(
			select s.���_ID
					, s.���_���������
					, s.���_������
					, s.ID
					, s.���
					, case when (s.���_��������� = '00050' and s.���_������ = 'z01694')
						then '30050'
						else '00050' 
						end as New_���_���������
					, case when (s.���_��������� = '00050' and s.���_������ = 'z01694')
						then 'z00150'
						else 'z01694' 
						end as New_���_������
			from tbl������������� s
			where (s.���_��������� = '00050' and s.���_������ = 'z01694')
				or 
				  (s.���_��������� = '30050' and s.���_������ = 'z00150')
			) x on x.ID = sp.ID 
				and x.���_��������� = sp.���_���������
				and x.���_������ = sp.���_������
;

--update z
--set ���������� = y.cnt
select y.*, z.����������
from tbl������ z
inner join (	  
			select s.���_���������, s.���_������, count(*) as cnt 
			from tbl������������� s
			where (s.���_��������� = '00050' and s.���_������ = 'z01694')
				or 
				  (s.���_��������� = '30050' and s.���_������ = 'z00150')
			group by s.���_���������, s.���_������
			) y on y.���_������ = z.���_������ and y.���_��������� = z.���_���������
;

commit -- rollback


select s.���
	,  s.�����
	,  s.ID
	,  case when (s.����� = '00050-z01694')
						then '30050-z00150'
						else '00050-z01694'
						end as New_�����
	, z.ID, z.���_���������, z.���_������
from dbo.tbl�������������������1 s
	left join tbl������������� z on z.ID = s.ID
		and z.���_��������� + '-' + z.���_������ = s.�����
				  /* case when (s.����� = '00050-z01694')
						then '30050-z00150'
						else '00050-z01694'
						end */
where (s.����� = '00050-z01694')
	or 
	  (s.����� = '30050-z00150')
;

/*
select s.*
into _tmp_tbl�������������������1_back_20200710_1305
from dbo.tbl�������������������1 s
where (s.����� = '00050-z01694')
	or 
	  (s.����� = '30050-z00150')	
*/

begin tran

-- update x set ����� = y.New_�����
--select x.ID, x.�����, y.New_�����
from tbl�������������������1 x
	inner join (
				select s.���
					,  s.�����
					,  s.ID
					,  case when (s.����� = '00050-z01694')
										then '30050-z00150'
										else '00050-z01694'
										end as New_�����
				from dbo.tbl�������������������1 s
				where (s.����� = '00050-z01694')
					or 
					  (s.����� = '30050-z00150')	
				) y on x.��� = y.���
;

commit -- rollback