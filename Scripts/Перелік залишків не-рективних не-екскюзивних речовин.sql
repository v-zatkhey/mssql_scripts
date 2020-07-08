select s.*
from dbo.tblСклад_LC s
	left join dbo.tblБазовыеСписки bl on bl.ID = s.ID
where not exists(select * from tbl_Reactive_compounds where ID = s.ID)
	and s.Масса >= 4
	and (bl.Дата_ввода_Эксклюзивности is null or bl.Дата_окончания_Эксклюзивности < GETDATE())
