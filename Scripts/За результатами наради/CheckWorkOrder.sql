set nocount on;
go

select distinct det.ID 
from tblЗаказыПоставщикам wo
	inner join tblЗаказыПоставщикамСп1 det 
		on det.Поставщик = wo.Поставщик and det.Пачка = wo.Пачка
	inner join Materials m on m.MatName = det.ID
	left join MaterialCalculatedParams cp on cp.MatID = m.MatID
where wo.Дата_отп = cast(GETDATE()as DATE)
	and cp.ID is null;
go
