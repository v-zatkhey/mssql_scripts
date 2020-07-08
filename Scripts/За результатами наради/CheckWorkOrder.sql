set nocount on;
go

select distinct det.ID 
from tbl����������������� wo
	inner join tbl�������������������1 det 
		on det.��������� = wo.��������� and det.����� = wo.�����
	inner join Materials m on m.MatName = det.ID
	left join MaterialCalculatedParams cp on cp.MatID = m.MatID
where wo.����_��� = cast(GETDATE()as DATE)
	and cp.ID is null;
go
