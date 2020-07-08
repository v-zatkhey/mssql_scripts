/*
select ���_ID, ID, ���_���������, ���_������
 , dbo.fn_get_all_zakaz_string(ID) AS OtherZakaz
from tbl������������� sz
where exists(select * from tbl������������� where ID = sz.ID and (���_��������� != sz.���_��������� or ���_������ != sz.���_������));
go
*/

declare @OtherZ table(id int, IDNUMBER nvarchar(10), CustomerCode nvarchar(5), OrderCode nvarchar(6), OtherCode nvarchar(max));
declare @cnt int;

insert into  @OtherZ
select ���_ID, ID, ���_���������, ���_������
 , ''
from tbl������������� sz
where exists(select * from tbl������������� where ID = sz.ID and (���_��������� != sz.���_��������� or ���_������ != sz.���_������));

select @cnt=COUNT(*) from @OtherZ;

while @cnt > 0
	begin
	update O
	set OtherCode = OtherCode +' '+ x.OrderCode
	from @OtherZ o
		inner join (
					select t1.id, sz.ID as IDNUMBER
						, sz.���_��������� + '-' + sz.���_������ as OrderCode
						, ROW_NUMBER() over(PARTITION by t1.id, t1.IDNUMBER order by sz.���_���������, sz.���_������) as num
					from @OtherZ t1
						 inner join tbl������������� sz on sz.ID = t1.IDNUMBER 
							and( sz.���_��������� != t1.CustomerCode or sz.���_������ != t1.OrderCode)
							and t1.OtherCode not like '%'+ sz.���_��������� + '-' + sz.���_������ +'%'
					) x on x.id = o.id and x.num = 1;
					
	select @cnt = COUNT(*) 
	from @OtherZ o 
	where exists(select * 
				 from	tbl������������� 
				 where	ID = o.IDNUMBER 
						and ���_ID != o.id
						and o.OtherCode not like '%'+ ���_��������� + '-' + ���_������ +'%');
	end
	
--select * from @OtherZ;

select top 1000000 MatName, MatID, o.OtherCode from Materials m left join @OtherZ o on o.IDNUMBER = m.MatName; 
select top 1000000 MatName, dbo.fn_get_all_zakaz_string(MatName) AS OtherZakaz from Materials order by MatID desc;
select top 1000000 MatName, MatID, o.OtherOrders from Materials m left join ft_OtherOrders() o on o.IDNUMBER = m.MatName; 

select * from  ft_OtherOrders() ;

go


declare @OtherZ TABLE 
(
	 IDNUMBER nvarchar(10)
	, OtherOrders nvarchar(max)
)
declare @cnt int;

	insert into  @OtherZ
	select sz.ID, ''
	from tbl������������� sz
	group by sz.ID;

	select @cnt=COUNT(*) from @OtherZ;

select  @cnt

	while @cnt > 0
		begin
		
		update @OtherZ
		set OtherOrders = OtherOrders +' '+ x.OrderCode + '('+ x.SendCode+ '),' 
		from @OtherZ o
			inner join (
						select sz.ID as IDNUMBER
							, sz.���_��������� + '-' + sz.���_������ as OrderCode
							, sz.���_�������� as SendCode 
							, ROW_NUMBER() over(PARTITION by t1.IDNUMBER order by sz.���_���������, sz.���_������) as num
						from @OtherZ t1
							 inner join tbl������������� sz on sz.ID = t1.IDNUMBER 
								and t1.OtherOrders not like '%'+ sz.���_��������� + '-' + sz.���_������ +'%'
						) x on x.IDNUMBER = o.IDNUMBER and x.num = 1;
						
		select @cnt = COUNT(*) 
		from @OtherZ o 
		where exists(select * 
					 from	tbl������������� 
					 where	ID = o.IDNUMBER 
							and o.OtherOrders not like '%'+ ���_��������� + '-' + ���_������ +'%');
							
							
		select 	@cnt;				
		end

		