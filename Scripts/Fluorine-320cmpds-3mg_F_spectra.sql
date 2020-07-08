select t.* 
	--, p.��� 
	, s.����
	, s.����_������� 
	, s.���������
	, s.[������������ ��� �������]
from _tmp_Fluorine3mg t
	inner join tbl�������� p 
		on p.ID = t.ID 
			and p.���_���������� = t.CustCode 
			and p.���_�������� = t.PostCode
	left join tbl������ s 
		on s.���_tbl��������_rev = p.��� 
			and s.���_������� = 'F'
			and s.[������������ ��� �������] like '%DMSO%'
			and s.��������� = 'OK'
order by t.ID	