-- select * from _NumbValue -- J - 3
-- exec getSpectrumBlockNumber 	@NumeratorID = 1, @Seria = 'R'  
-- update n set Value = 3 	from _NumbValue n where  n.Seria = 'J'

select *, n.Value - x.BlockNumber as [��������� ��������� ��] 
	--update n set Value = x.BlockNumber
	from _NumbValue n
	full join (
				select ���_������� as SpectrumSeria, MAX(�����_�����) BlockNumber
				from tbl������
				group by ���_�������
				) x on x.SpectrumSeria = n.Seria and n.NumeratorID = 1
	where ISNULL(n.Value,0) <> ISNULL(x.blockNumber,0)
	

select * 
from 	tbl������	 
where ���_������� in ( 'R')
	and �����_����� >= 1575
order by ��� desc
	

select * 
from 	tbl������	 
where ���_������� in ( 'G')
	and �����_����� > 530
order by ��� desc

select * 
from 	tbl������	 
where ���_������� in ( 'L')
	and �����_����� > 530
order by ���



select * 
from 	tbl������	 
where ���_������� in ( 'S')
	and �����_����� > 28580
order by ���


select * 
from 	tbl������	 
where ���_������� in ( 'F')
	and �����_����� > 1015
order by ���


select * 
from 	tbl������	 
where ���_������� in ( 'U')
	and �����_����� > 60
order by ���

select * 
from 	tbl������	 
where ���_������� in ( 'R')
	and �����_����� > 1504
order by ��� desc

select * 
from 	tbl������	 
where ���_������� in ( 'L')
	and �����_����� > 500
order by ���

select * 
from 	tbl������	 
where ���_������� in ( 'G')
	and �����_����� > 560
order by ���

--exec getSpectrumBlockNumber 1, 'Y'
/*
select top 1000 ���_������� as SpectrumSeria, �����_����� BlockNumber, *
from tbl������
where �����_����� = ''
*/
select top 1000 ���_������� as SpectrumSeria, �����_����� BlockNumber, *
from tbl������
where �����_����� = '28988'  -- 1321352
							-- 1321354
select top 1000 ���_������� as SpectrumSeria, �����_����� BlockNumber, *
from tbl������	where ��� in (1321352,1321354)	;					
							
select * 
from dbo.tbl�������� 
where  ���_����������='KEV' and ���_�������� = '0985' and ID = 'F6543-0674' 
	or ���_����������= 'VIG' and ���_�������� = '4178'and ID = 'F3409-1086';

/*
exec getSpectrumBlockNumber 1, 'Y';

select * from _NumbValue

update n set Value = x.BlockNumber
from _NumbValue n
full join (
			select ���_������� as SpectrumSeria, MAX(�����_�����) BlockNumber
			from tbl������
			group by ���_�������
			) x on x.SpectrumSeria = n.Seria and n.NumeratorID = 1
where n.Seria = 'K' and ISNULL(n.Value,0) <> ISNULL(x.blockNumber,0);

*/
			select ���_������� as SpectrumSeria, MAX(�����_�����) BlockNumber
			from tbl������
			group by ���_�������
			
select * 
from 	tbl������	 
where ���_������� = 'M'
	and �����_����� > 28993
order by ��� 	
	--���� > '22/10/2018'	
select * 
from 	tbl������	 
where ���_������� = 'H'
	and �����_����� > 4600
order by ��� 

select * from 	tbl������ where ���������� = 'BEM-1229'

select * 
from 	tbl������	 
where ���_������� = 'V'
	and �����_����� > 1115
order by ��� 


SELECT top 100 * FROM tbl������ WHERE (ID = 'F0850-6795') ORDER BY ��� DESC

