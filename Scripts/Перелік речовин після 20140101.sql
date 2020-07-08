use Chest35;
go

select m.MatName, mi.DateInsert, MIN(p.Дата_пост) as FirstDate
from Materials m inner join MaterialInfo mi on mi.MatID = m.MatID
	left join tblПоставки p on p.ID = m.MatName
where mi.DateInsert >= '20140101'
	and m.MatName = 'F2205-0031'
group by m.MatName, mi.DateInsert
order by m.MatName
go


-- main
select p.ID, CONVERT(varchar(10),MIN(p.Дата_пост),104) as FirstDate
from tblПоставки p
	left join [tblБазовыеСписки] bl on bl.ID = p.ID
	left join tblСклад_LC s on s.ID = p.ID
where (bl.Событие_Эксклюзивности is null or bl.Дата_окончания_Эксклюзивности < GETDATE())
	and not exists(select * from dbo.tbl_Reactive_compounds where ID = p.ID)
	and s.Масса > 1
group by p.ID
having min(p.Дата_пост) >= '20140101'
order by MIN(p.Дата_пост)
go