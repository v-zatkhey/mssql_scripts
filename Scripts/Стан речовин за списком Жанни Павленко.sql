select * from [_tmp_list_from_zhanna]; --51

select distinct right(CODE,LEN(CODE) - PATINDEX('%F%',CODE) + 1) as IDNUMBER
into #_tmp_list_from_zhanna 
from [_tmp_list_from_zhanna]; -- 46

select t.IDNUMBER
	, case bl.Вид 
		when 's' then 'solid'
		when 'o' then 'oil'
		when 'l' then 'liquid'
		end as [State]
	, p.Код_поставщика
	, p.Код_поставки
from #_tmp_list_from_zhanna t
	left join tblПоставки p on p.ID = t.IDNUMBER
	left join tblБазовыеСписки bl on bl.ID = t.IDNUMBER
order by t.IDNUMBER, p.Дата_пост

select t.IDNUMBER
	,  'solid' as [State]
	, p.Код_поставщика
	, p.Код_поставки
	, s.Масса
from #_tmp_list_from_zhanna t
	left join tblПоставки p on p.ID = t.IDNUMBER
	left join tblБазовыеСписки bl on bl.ID = t.IDNUMBER
	inner join tblСклад s on s.ID = t.IDNUMBER
where bl.Вид = 's'
order by t.IDNUMBER, p.Дата_пост;

select t.IDNUMBER
	,  'oil' as [State]
	, p.Код_поставщика
	, p.Код_поставки
	, s.Масса
from #_tmp_list_from_zhanna t
	left join tblПоставки p on p.ID = t.IDNUMBER
	left join tblБазовыеСписки bl on bl.ID = t.IDNUMBER
	inner join tblСклад s on s.ID = t.IDNUMBER
where bl.Вид = 'o'
order by t.IDNUMBER, p.Дата_пост;