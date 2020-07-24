use Chest35;
go


--select top 10 * from MaterialInfo;

--select top 10 * from tbl��������;

--insert into MaterialInfo(MatID,CustID,CustMatName,DateInsert,Note)
select --top 10  
	m.MatID 
	,c.CustID
	,m.MatName 
	,cast(MIN(p.����_����) as DATE) as LotDate
	,'auto'
from tbl�������� p
	inner join dbo.Customers c on c.CustName = p.���_����������
	inner join Materials m on m.MatName = p.ID
where �������_��_�������� = 1
	and not exists(select * from MaterialInfo where MatID = m.MatID and CustID = c.CustID)
group by 
	c.CustID
	,m.MatID
	,m.MatName
;
-- (����� ����������: 235323)
