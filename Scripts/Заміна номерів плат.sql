select Код_заказчика, Код_заказа, count(distinct Box_номер)
from tblСписокЗаказов
where Код_заказчика = '00807'
group by Код_заказчика, Код_заказа  
having count(distinct Box_номер)>1
order by Код_заказчика, Код_заказа ;


select Код_заказчика, Код_заказа, Box_Barcode, Box_номер, Box_колонка , Box_строка 
from tblСписокЗаказов
where Код_заказчика = '00807'
	--and Код_заказа = 'z00086'
order by Код_заказа, cast(Box_номер as int);



------------------------------------------------------
declare @CustomerCode varchar(5) = '00807';
declare @OddOrder varchar(6) = 'z00086';
declare @EvenOrder varchar(6) = 'z00087';

 
--update s 
--set   Box_номер = (Box_номер*2-1)
select Код_заказчика, Код_заказа, ID, Box_Barcode, Box_номер, Box_колонка , Box_строка 
, (Box_номер*2-1) as box_odd
from tblСписокЗаказов s
where Код_заказчика = @CustomerCode
	and Код_заказа = @OddOrder
order by cast(Box_номер as int)
;

 
--update s 
--set   Box_номер = (s.Box_номер - 1)*2 
select Код_заказчика, Код_заказа, ID, Box_Barcode, Box_номер, Box_колонка , Box_строка 
, (s.Box_номер - 1)*2 as box_even
from tblСписокЗаказов s
where Код_заказчика = @CustomerCode
	and Код_заказа = @EvenOrder
order by cast(Box_номер as int)
;
go

------------------------------------------------------
declare @CustomerCode varchar(5) = '00807';
declare @OddOrder varchar(6) = 'z00088';
declare @EvenOrder varchar(6) = 'z00089';

 
--update s 
--set   Box_номер = ((Box_номер-100)*2-1 + 100)
select Код_заказчика, Код_заказа, ID, Box_Barcode, Box_номер, Box_колонка , Box_строка 
, ((Box_номер-100)*2-1+100) as box_odd
from tblСписокЗаказов s
where Код_заказчика = @CustomerCode
	and Код_заказа = @OddOrder
order by cast(Box_номер as int)
;

 
--update s 
--set   Box_номер = ((Box_номер-101)*2 + 100)
select Код_заказчика, Код_заказа, ID, Box_Barcode, Box_номер, Box_колонка , Box_строка 
, ((Box_номер-101)*2 + 100) as box_even
from tblСписокЗаказов s
where Код_заказчика = @CustomerCode
	and Код_заказа = @EvenOrder
order by cast(Box_номер as int)
;