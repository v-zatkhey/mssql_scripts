/*
������� ������� ���. �������:
���-� ��� (�. �. ���), ���� �������,  ������ ����� ������� ���-� ������� S (���� � �����). 
������ ������� ������� �� ��������.
�������.

From: Volodymyr Zatkhey 
������ �� ��, ��� �����?

From: Zhanna Pavlenko 
Subject: ������� ���-�� 

������� ������� ������� � ���� �������� ��� ����� �������, ���  �� ��������� ��� ������� ��� ������� � ��� �������, ��� 
���� �-uni
��������� ���� S � �����.
+ �������-������� �� ��������.
�������, �����.
*/

select * from tbl������ 
where ����_������� > DATEADD(yyyy,-1,getdate()) 
	and ���_�������  = 'M' 
	and ��������� = 'UNI'
	
select p.ID
	, p.���_����������
	, p.���_��������
	, P.����_����   
	, sm.��������� as ���������_M
	, sm.����_������� as ����_�������_M
	, ss.��������� as ���������_S
	, ss.����_������� as ����_�������_S
	, t.��������_���� as [������� �� ��������]
from tbl�������� p
	inner join ����_�������_��_��������� t  on t.��� = p.�������_��_�������� 
	inner join ����_�������_��_������� ta on ta.��� = p.�������_��_������� 
	inner join tbl������ sm on sm.���_tbl��������_rev = p.��� and sm.���_�������  = 'M' and sm.��������� = 'UNI' and sm.����_�������  > DATEADD(yyyy,-1,getdate()) 
	inner join tbl������ ss on ss.���_tbl��������_rev = p.��� and ss.���_�������  = 'S' and ss.����_�������  > DATEADD(yyyy,-1,getdate()) 
where exists(select * from tbl������ 
			where ���_tbl��������_rev  = p.���
				and ID = p.ID 
				and ����_������� > DATEADD(yyyy,-1,getdate()) 
				and ���_�������  = 'M' 
				and ��������� = 'UNI')	
 and exists(select * from tbl������ 
			where ���_tbl��������_rev  = p.���
				and ID = p.ID 
				and ����_������� > DATEADD(yyyy,-1,getdate()) 
				and ���_�������  = 'S')					
order by p.ID, p.����_����; -- F1900-3048

/*
select distinct s.[������������ ��� �������]  from tbl������ s where s.���_������� = 'S' and s.[������������ ��� �������] like '%DMSO%����%'
select distinct s.[������������ ��� �������]  from tbl������ s where s.���_������� = 'S' and s.[������������ ��� �������] like '%DMSO%CCl4%'
select distinct s.[������������ ��� �������]  from tbl������ s where s.���_������� = 'M' and s.[������������ ��� �������] like '%CDCl3%'

*/