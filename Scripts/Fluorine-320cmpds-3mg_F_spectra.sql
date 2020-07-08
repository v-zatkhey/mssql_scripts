select t.* 
	--, p.Код 
	, s.Блок
	, s.Дата_спектра 
	, s.Результат
	, s.[Растворитель для спектра]
from _tmp_Fluorine3mg t
	inner join tblПоставки p 
		on p.ID = t.ID 
			and p.Код_поставщика = t.CustCode 
			and p.Код_поставки = t.PostCode
	left join tblСпектр s 
		on s.Код_tblПоставки_rev = p.Код 
			and s.Тип_спектра = 'F'
			and s.[Растворитель для спектра] like '%DMSO%'
			and s.Результат = 'OK'
order by t.ID	