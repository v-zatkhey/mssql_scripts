use Chest35;
go

select ID, s.Код_поставщика + '-' + s.Код_поставки as [Код_поставки] --, COUNT( *)
from tblСпектр s
where Тип_спектра = 'S' 
	and  Результат = 'OK'
	and [Растворитель для спектра] like '%D2%'
	and ID like 'F____-____'
group by ID, s.Код_поставщика , s.Код_поставки	;