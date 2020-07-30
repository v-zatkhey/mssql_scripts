use Chest35;
go


--select top 10 * from MaterialInfo;

--select top 10 * from tblПоставки;

--insert into MaterialInfo(MatID,CustID,CustMatName,DateInsert,Note)
select --top 10  
	m.MatID 
	,c.CustID
	,m.MatName 
	,cast(MIN(p.Дата_пост) as DATE) as LotDate
	,'auto'
from tblПоставки p
	inner join dbo.Customers c on c.CustName = p.Код_поставщика
	inner join Materials m on m.MatName = p.ID
where Решение_по_поставке = 1
	and not exists(select * from MaterialInfo where MatID = m.MatID and CustID = c.CustID)
group by 
	c.CustID
	,m.MatID
	,m.MatName
;
-- (строк обработано: 235323)
