/*
������� �������� ���� �� ����� ����������:
������ ������:
1)	�������� ���
2)	���: OIL
3)	������: 1,06,2019-30,06,2019
4)	�������: �����
5)	���� ���� S

������ ������:
6)	�������� KIS
7)	���: OIL
8)	������: 1,06,2019-30,06,2019
9)	�������: �����
10)	���� ���� S

������ ������:
11)	�������� LSA
12)	���: OIL
13)	������: 1,06,2019-30,06,2019
14)	�������: �����
15)	���� ���� S
*/

use Chest35;
go

select distinct ID
from tbl�������� p 
where [�����] = 1
		and ����_����� between '20190601' and '20190630'	
		and exists(select * from tbl������ s where s.���_tbl��������_rev = p.��� and s.���_������� = 'S' and s.��������� = 'OK')
		and ����������_��������� = 'o'	
		and p.���_���������� = 'MEM';
select distinct ID
from tbl�������� p 
where [�����] = 1
		and ����_����� between '20190601' and '20190630'	
		and exists(select * from tbl������ s where s.���_tbl��������_rev = p.��� and s.���_������� = 'S' and s.��������� = 'OK')
		and ����������_��������� = 'o'	
		and p.���_���������� = 'KIS';
select distinct ID
from tbl�������� p 
where [�����] = 1
		and ����_����� between '20190601' and '20190630'	
		and exists(select * from tbl������ s where s.���_tbl��������_rev = p.��� and s.���_������� = 'S' and s.��������� = 'OK')
		and ����������_��������� = 'o'	
		and p.���_���������� = 'LSA';
				
				