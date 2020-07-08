-- які взагалі існують 50-ті замовники
select distinct Код_заказчика 
from tblЗаказы 
where Код_заказчика like '_0050';

select *
from tblЗаказы 
where Код_заказчика = '00050'
	and Код_заказа = 'z01672'
order by Дата desc;

select *
from tblСписокЗаказов 
where Код_заказчика = '00050'
	and Код_заказа = 'z01672';
	
select top 100 *
from tblВыполненныеЗаказы 
where Код_заказчика = '00050'
	and Код_заказа = 'z01672'
order by Код_ID desc;
-------------------

select *
from tblЗаказы 
where Код_заказчика in ( '10050','30050')
order by Дата desc;

select s.ID--, p.Коэффициент
from tblСписокЗаказов s
--	 left join tbl_Повышенная_цена p on p.ID = s.ID   
where Код_заказчика in ( '10050','30050')
	and Код_заказа in ( 'z00188','z00105')
	and not exists(select * from tbl_Повышенная_цена where ID = s.ID)
;