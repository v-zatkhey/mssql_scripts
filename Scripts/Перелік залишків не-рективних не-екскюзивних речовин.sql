select s.*
from dbo.tbl�����_LC s
	left join dbo.tbl������������� bl on bl.ID = s.ID
where not exists(select * from tbl_Reactive_compounds where ID = s.ID)
	and s.����� >= 4
	and (bl.����_�����_�������������� is null or bl.����_���������_�������������� < GETDATE())
