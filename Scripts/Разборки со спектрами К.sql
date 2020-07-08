select * from dbo.tblВиды_Растворителей where Тип = 12
select * from dbo.tblТипы_спектров

select * 
from tblПоставки p
	inner join tblСпектр s on s.Код_tblПоставки_rev  = p.Код and s.Тип_спектра = 'K'
where p.ID = 'F9995-1185' order by Дата_пост 

select * from Materials where Brutto_Formula like '%F%' and MW_without_Salt < 100 -- F0001-3662
select MW_without_Salt from Materials where MatName = 'F0001-3662'

SELECT * FROM ISISHOST_IFLAB_w_Salt where MOLFORMULA like '%F%'
SELECT * FROM ISISHOST_IFLAB_w_Salt where MOLFORMULA like '%Fe%'
