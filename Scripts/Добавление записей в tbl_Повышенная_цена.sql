use Chest35;
go

-- загальна кількість
select COUNT(*) as Cnt from _tmp_Price_coeff;

-- 
select * from dbo.tbl_Повышенная_цена
where ID in (select ID from dbo._tmp_Price_coeff)

--select * from _tmp_Price_coeff where ID = 'F6616-3373';
-- повтори
select ID, COUNT(*)
from dbo._tmp_Price_coeff
group by ID
having COUNT(*) > 1

/*
insert into dbo.tbl_Повышенная_цена ([ID]
      ,[Коэффициент])
select ID, isnull(CAST(Koeff as real),1.5) 
from dbo._tmp_Price_coeff;
--where ID <> 'F6616-3373';
*/

