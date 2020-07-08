select * from [_tmp_list_from_zhanna]; --51

select distinct right(CODE,LEN(CODE) - PATINDEX('%F%',CODE) + 1) as IDNUMBER
into #_tmp_list_from_zhanna 
from [_tmp_list_from_zhanna]; -- 46

select t.IDNUMBER
	, case bl.��� 
		when 's' then 'solid'
		when 'o' then 'oil'
		when 'l' then 'liquid'
		end as [State]
	, p.���_����������
	, p.���_��������
from #_tmp_list_from_zhanna t
	left join tbl�������� p on p.ID = t.IDNUMBER
	left join tbl������������� bl on bl.ID = t.IDNUMBER
order by t.IDNUMBER, p.����_����

select t.IDNUMBER
	,  'solid' as [State]
	, p.���_����������
	, p.���_��������
	, s.�����
from #_tmp_list_from_zhanna t
	left join tbl�������� p on p.ID = t.IDNUMBER
	left join tbl������������� bl on bl.ID = t.IDNUMBER
	inner join tbl����� s on s.ID = t.IDNUMBER
where bl.��� = 's'
order by t.IDNUMBER, p.����_����;

select t.IDNUMBER
	,  'oil' as [State]
	, p.���_����������
	, p.���_��������
	, s.�����
from #_tmp_list_from_zhanna t
	left join tbl�������� p on p.ID = t.IDNUMBER
	left join tbl������������� bl on bl.ID = t.IDNUMBER
	inner join tbl����� s on s.ID = t.IDNUMBER
where bl.��� = 'o'
order by t.IDNUMBER, p.����_����;