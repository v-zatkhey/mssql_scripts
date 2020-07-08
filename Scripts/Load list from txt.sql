use Chest35;
go

SELECT	m.MatName
into #ID_list
FROM OPENROWSET(
		BULK       N'M:\Private_sh\Zatkhey Volodymyr\30050_SZV.txt',
		FORMATFILE=N'M:\Private_sh\Zatkhey Volodymyr\DataParametersForRating\ID_list.xml', 
		FIRSTROW = 1 
			   ) AS c
	inner join Materials m on m.MatName = c.idnumber collate SQL_Ukrainian_CP1251_CI_AS
--group by m.MatName
--having COUNT(*)>1
select COUNT(*) from #ID_list;
select * from
(select sp.ID, sp.Код_заказа
from tblСписокЗаказов sp
where sp.Код_заказчика = '30050'
	and sp.Код_заказа in ('z00143','z00144')) x
		full join #ID_list l on l.MatName = x.ID
where x.ID is null or l.MatName is null