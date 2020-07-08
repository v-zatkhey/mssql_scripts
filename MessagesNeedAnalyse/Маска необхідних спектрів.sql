declare @mask bigint;

select @mask = SUM( POWER(2,Код)) 
from dbo.tblТипы_спектров
where Тип_склада in (2,1)
;

select @mask

select Код, Тип,Пояснение
from dbo.tblТипы_спектров
where  @mask & POWER(2,Код)<>0 
order by Сортировка;
go


select Код, Тип,Пояснение
from dbo.tblТипы_спектров
where  2020 & POWER(2,Код)<>0 
order by Сортировка;
go

select Код, Тип,Пояснение, POWER(2,Код) as Mask
from dbo.tblТипы_спектров
where  Тип_склада in (2,1) 
order by Сортировка;
