use Chest35;
go

select m.MatName, mi.DateInsert, MIN(p.����_����) as FirstDate
from Materials m inner join MaterialInfo mi on mi.MatID = m.MatID
	left join tbl�������� p on p.ID = m.MatName
where mi.DateInsert >= '20140101'
	and m.MatName = 'F2205-0031'
group by m.MatName, mi.DateInsert
order by m.MatName
go


-- main
select p.ID, CONVERT(varchar(10),MIN(p.����_����),104) as FirstDate
from tbl�������� p
	left join [tbl�������������] bl on bl.ID = p.ID
	left join tbl�����_LC s on s.ID = p.ID
where (bl.�������_�������������� is null or bl.����_���������_�������������� < GETDATE())
	and not exists(select * from dbo.tbl_Reactive_compounds where ID = p.ID)
	and s.����� > 1
group by p.ID
having min(p.����_����) >= '20140101'
order by MIN(p.����_����)
go