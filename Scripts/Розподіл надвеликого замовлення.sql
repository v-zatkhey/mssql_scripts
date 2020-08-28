-- розподіл надвеликого заказа
-- заказ 01136-z00123

use Chest35;
go

/*
select ID, Box_номер , Box_строка , Box_колонка 
	, ROW_NUMBER() over( order by ID) as Num
	, char((ROW_NUMBER() over( order by ID) -1)%8+65) as RowIndx  
	, ((ROW_NUMBER() over( order by ID) -1)/8)%10+2 as ColNum  
	, ((ROW_NUMBER() over( order by ID) -1)/80) + 1 as BoxNum
from tblСписокЗаказов 
where Код_заказчика = '01136' and Код_заказа  = 'z00123'
order by ID;


select *
into _tmp_СписокЗаказа_01136_z00123_back
from tblСписокЗаказов 
where Код_заказчика = '01136' and Код_заказа  = 'z00123'
order by ID;
*/
/*
declare @Discrim table(ID varchar(10), RowIndx char(1), ColIndx int, BoxNum int)

begin tran

	insert into @Discrim
	select ID
	--	, ROW_NUMBER() over( order by ID) as Num
		, char((ROW_NUMBER() over( order by ID) -1)%8+65) as RowIndx  
		, ((ROW_NUMBER() over( order by ID) -1)/8)%10+2 as ColIndx  
		, ((ROW_NUMBER() over( order by ID) -1)/80) + 1 as BoxNum
	from tblСписокЗаказов
	where Код_заказчика = '01136' and Код_заказа  = 'z00123'
	order by ID;
	
	--update tblСписокЗаказов
	--, 
	
	update s
	set Box_номер = d.BoxNum
		, Box_строка = d.RowIndx 
		, Box_колонка = d.ColIndx 
	from @Discrim d
		inner join tblСписокЗаказов s on  s.Код_заказчика = '01136' 
										and s.Код_заказа  = 'z00123' 
										and s.ID = d.ID; 

commit
*/

select ID, Box_номер , Box_строка , Box_колонка 
	, ROW_NUMBER() over( order by ID) as Num
	, *
from tblСписокЗаказов s 
where Код_заказчика = '01136' and Код_заказа  = 'z00123'
order by s.ID;

select  *
from tblВзвешивание s 
where s.Заказ = '01136-z00123' and s.PickedLotCode =0
order by s.ID;


select s.ID 
	, s.Box_номер 
	, s.Box_строка 
	, s.Box_колонка 
	, s.Код_поставщика 
	, s.Код_поставки 
	, v.PickedLotCode 
	, p.Код_поставщика
	, p.Код_поставки 
from tblСписокЗаказов s 
	inner join tblВзвешивание v on v.Заказ =  s.Код_заказчика + '-' + s.Код_заказа
		and v.ID = s.ID 
	inner join tblПоставки p on p.Код = v.PickedLotCode 
where s.Код_заказчика = '01136' and s.Код_заказа = 'z00123'
order by s.ID;

/*
update s
set Код_поставщика = p.Код_поставщика
	, Код_поставки = p.Код_поставки 
from tblСписокЗаказов s 
	inner join tblВзвешивание v on v.Заказ =  s.Код_заказчика + '-' + s.Код_заказа
		and v.ID = s.ID 
	inner join tblПоставки p on p.Код = v.PickedLotCode 
where s.Код_заказчика = '01136' and s.Код_заказа = 'z00123'
;
*/