exec sp_help 'tblСпектр'

select s.Блок, s.Дата, s.ID, s.Результат,   f.* 
from tblСпектр s left join tbl_Фторные_сдвиги f on f.Kod_Spectra = s.Код
where s.Тип_спектра = 'F'
order by s.Дата desc;

select ID, COUNT(*) as cnt, AVG(x.LnCnt) as aLnCnt
from (
	select s.Блок, s.Дата, s.ID, s.Результат,  COUNT( *) as LnCnt
	from tblСпектр s inner join tbl_Фторные_сдвиги f on f.Kod_Spectra = s.Код
	where s.Тип_спектра = 'F'
	group by s.Блок, s.Дата, s.ID, s.Результат
	) x
group by ID
order by COUNT(*) desc;

select s.Блок, s.Дата, s.ID, s.Результат,   f.* 
from tblСпектр s left join tbl_Фторные_сдвиги f on f.Kod_Spectra = s.Код
where s.Тип_спектра = 'F'
	and exists(	select * 
				from tblСпектр 
				where ID = s.ID	
					and [Тип_спектра] = 'F'
					and [Растворитель для спектра] = s.[Растворитель для спектра]
					and [Результат]='OK' 
					and Код < s.Код)
--	and s.ID = 'F1913-0932'
order by s.Дата desc;