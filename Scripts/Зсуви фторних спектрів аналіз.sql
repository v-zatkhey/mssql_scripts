exec sp_help 'tbl������'

select s.����, s.����, s.ID, s.���������,   f.* 
from tbl������ s left join tbl_�������_������ f on f.Kod_Spectra = s.���
where s.���_������� = 'F'
order by s.���� desc;

select ID, COUNT(*) as cnt, AVG(x.LnCnt) as aLnCnt
from (
	select s.����, s.����, s.ID, s.���������,  COUNT( *) as LnCnt
	from tbl������ s inner join tbl_�������_������ f on f.Kod_Spectra = s.���
	where s.���_������� = 'F'
	group by s.����, s.����, s.ID, s.���������
	) x
group by ID
order by COUNT(*) desc;

select s.����, s.����, s.ID, s.���������,   f.* 
from tbl������ s left join tbl_�������_������ f on f.Kod_Spectra = s.���
where s.���_������� = 'F'
	and exists(	select * 
				from tbl������ 
				where ID = s.ID	
					and [���_�������] = 'F'
					and [������������ ��� �������] = s.[������������ ��� �������]
					and [���������]='OK' 
					and ��� < s.���)
--	and s.ID = 'F1913-0932'
order by s.���� desc;