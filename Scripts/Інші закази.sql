/*
select Код_ID, ID, Код_заказчика, Код_заказа
 , dbo.fn_get_all_zakaz_string(ID) AS OtherZakaz
from tblСписокЗаказов sz
where exists(select * from tblСписокЗаказов where ID = sz.ID and (Код_заказчика != sz.Код_заказчика or Код_заказа != sz.Код_заказа));
go
*/

declare @OtherZ table(id int, IDNUMBER nvarchar(10), CustomerCode nvarchar(5), OrderCode nvarchar(6), OtherCode nvarchar(max));
declare @cnt int;

insert into  @OtherZ
select Код_ID, ID, Код_заказчика, Код_заказа
 , ''
from tblСписокЗаказов sz
where exists(select * from tblСписокЗаказов where ID = sz.ID and (Код_заказчика != sz.Код_заказчика or Код_заказа != sz.Код_заказа));

select @cnt=COUNT(*) from @OtherZ;

while @cnt > 0
	begin
	update O
	set OtherCode = OtherCode +' '+ x.OrderCode
	from @OtherZ o
		inner join (
					select t1.id, sz.ID as IDNUMBER
						, sz.Код_заказчика + '-' + sz.Код_заказа as OrderCode
						, ROW_NUMBER() over(PARTITION by t1.id, t1.IDNUMBER order by sz.Код_заказчика, sz.Код_заказа) as num
					from @OtherZ t1
						 inner join tblСписокЗаказов sz on sz.ID = t1.IDNUMBER 
							and( sz.Код_заказчика != t1.CustomerCode or sz.Код_заказа != t1.OrderCode)
							and t1.OtherCode not like '%'+ sz.Код_заказчика + '-' + sz.Код_заказа +'%'
					) x on x.id = o.id and x.num = 1;
					
	select @cnt = COUNT(*) 
	from @OtherZ o 
	where exists(select * 
				 from	tblСписокЗаказов 
				 where	ID = o.IDNUMBER 
						and Код_ID != o.id
						and o.OtherCode not like '%'+ Код_заказчика + '-' + Код_заказа +'%');
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
	from tblСписокЗаказов sz
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
							, sz.Код_заказчика + '-' + sz.Код_заказа as OrderCode
							, sz.Код_отправки as SendCode 
							, ROW_NUMBER() over(PARTITION by t1.IDNUMBER order by sz.Код_заказчика, sz.Код_заказа) as num
						from @OtherZ t1
							 inner join tblСписокЗаказов sz on sz.ID = t1.IDNUMBER 
								and t1.OtherOrders not like '%'+ sz.Код_заказчика + '-' + sz.Код_заказа +'%'
						) x on x.IDNUMBER = o.IDNUMBER and x.num = 1;
						
		select @cnt = COUNT(*) 
		from @OtherZ o 
		where exists(select * 
					 from	tblСписокЗаказов 
					 where	ID = o.IDNUMBER 
							and o.OtherOrders not like '%'+ Код_заказчика + '-' + Код_заказа +'%');
							
							
		select 	@cnt;				
		end

		