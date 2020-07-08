/*
Просьба сделать доп. колонки:
Рез-т лмс (т. е. уни), дата спектра,  вторая рядом колонка рез-т спектра S (тоже с датой). 
Третья колонка решение оп поставке.
Спасибо.

From: Volodymyr Zatkhey 
Похоже на то, что нужно?

From: Zhanna Pavlenko 
Subject: выборка рез-ты 

Просьба сделать выборку в виде таблички для любых веществ, где  за последний год снимали оба спектра и при условии, что 
Блок М-uni
Результат блок S – любой.
+ колонка-решение по веществу.
Спасибо, Жанна.
*/

select * from tblСпектр 
where Дата_спектра > DATEADD(yyyy,-1,getdate()) 
	and Тип_спектра  = 'M' 
	and Результат = 'UNI'
	
select p.ID
	, p.Код_поставщика
	, p.Код_поставки
	, P.Дата_пост   
	, sm.Результат as Результат_M
	, sm.Дата_спектра as Дата_спектра_M
	, ss.Результат as Результат_S
	, ss.Дата_спектра as Дата_спектра_S
	, t.Название_типа as [решение по поставке]
from tblПоставки p
	inner join Типы_решений_по_поставкам t  on t.Код = p.Решение_по_поставке 
	inner join Типы_решений_по_анализу ta on ta.Код = p.Решение_по_анализу 
	inner join tblСпектр sm on sm.Код_tblПоставки_rev = p.Код and sm.Тип_спектра  = 'M' and sm.Результат = 'UNI' and sm.Дата_спектра  > DATEADD(yyyy,-1,getdate()) 
	inner join tblСпектр ss on ss.Код_tblПоставки_rev = p.Код and ss.Тип_спектра  = 'S' and ss.Дата_спектра  > DATEADD(yyyy,-1,getdate()) 
where exists(select * from tblСпектр 
			where Код_tblПоставки_rev  = p.Код
				and ID = p.ID 
				and Дата_спектра > DATEADD(yyyy,-1,getdate()) 
				and Тип_спектра  = 'M' 
				and Результат = 'UNI')	
 and exists(select * from tblСпектр 
			where Код_tblПоставки_rev  = p.Код
				and ID = p.ID 
				and Дата_спектра > DATEADD(yyyy,-1,getdate()) 
				and Тип_спектра  = 'S')					
order by p.ID, p.Дата_пост; -- F1900-3048

/*
select distinct s.[Растворитель для спектра]  from tblСпектр s where s.Тип_спектра = 'S' and s.[Растворитель для спектра] like '%DMSO%чист%'
select distinct s.[Растворитель для спектра]  from tblСпектр s where s.Тип_спектра = 'S' and s.[Растворитель для спектра] like '%DMSO%CCl4%'
select distinct s.[Растворитель для спектра]  from tblСпектр s where s.Тип_спектра = 'M' and s.[Растворитель для спектра] like '%CDCl3%'

*/