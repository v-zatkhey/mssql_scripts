use Chest35_test;
go

select * from tbl�������� p
				inner join dbo.Customers c on c.CustName = p.���_����������
				inner join Materials m on m.MatName = p.ID
			where �������_��_�������� =0
				and not exists(select  * from MaterialInfo where MatID = m.MatID and CustID = c.CustID)  ;

--select �������_��_��������, * from tbl�������� p where ��� = 1246046;
--select * from Materials where MatName = 'F0074-0090';
--select * from Customers where CustName = 'DNF';

begin tran

	select m.MatName , c.CustName, mi.* 
	from MaterialInfo mi
		inner join Customers c on c.CustID = mi.CustID 
		inner join Materials m on m.MatID = mi.MatID 
	where mi.MatID = 487168;

	update tbl�������� set �������_��_�������� = 1  where ��� = 1246046;

	select m.MatName , c.CustName, mi.* 
	from MaterialInfo mi
		inner join Customers c on c.CustID = mi.CustID 
		inner join Materials m on m.MatID = mi.MatID 
	where mi.MatID = 487168;

	update tbl�������� set �������_��_�������� = 0  where ��� = 1246046;
	delete from MaterialInfo where CustID = 468 and MatID = 487168;

commit