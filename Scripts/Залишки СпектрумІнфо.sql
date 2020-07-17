/*
������, ������ ����, ������ ���, ����������, ������� �� ���� ��������� ��������, ������� ������� ������ 50�. 
�������� � �������� ������ ���� �� BSB, SUA, PSV, ADA, JTG, OAM, GER, VAP, MSO, DAO.

�������,
������ �����
*/
use Chest35;
go

declare @ChemList as table(Abbr char(3));
insert into @ChemList values
('BSB')
,('SUA')
,('PSV')
,('ADA')
,('JTG')
,('OAM')
,('GER')
,('VAP')
,('MSO')
,('DAO')
--,('SKP')
--,('MNB')
--,('DEU')
--,('MEM')
--, ('MLG')
--, ('DNF')
--, ('BEV')
--, ('KEV')

--select Abbr from @ChemList;

select --p.���_����������,
distinct
	 p.ID 
	, m.[SINFO-ID]
	--, p.���_��������
	--, p.�����_����
	--, * 
from tbl�������� p
	inner join @ChemList cl on p.���_���������� = cl.Abbr
	inner join Materials m on m.MatName = p.ID
where [�����_����]>=50000
order by --p.���_����������,
	 p.ID;