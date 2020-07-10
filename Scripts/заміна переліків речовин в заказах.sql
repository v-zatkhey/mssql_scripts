-- 00050-z01694   исправить на   30050-z00150 

use Chest35 ;
go

select * 
from tblЗаказы s
where (s.Код_заказчика = '00050' and s.Код_заказа = 'z01694')
	or 
	  (s.Код_заказчика = '30050' and s.Код_заказа = 'z00150')

select * 
into _tmp_tblСписокЗаказов_back_20200709
from tblСписокЗаказов s
where (s.Код_заказчика = '00050' and s.Код_заказа = 'z01694')
	or 
	  (s.Код_заказчика = '30050' and s.Код_заказа = 'z00150');

begin tran
--update sp
--set Код_заказчика = x.New_Код_заказчика, Код_заказа = x.New_Код_заказа 
select x.*, sp.ID, sp.Код_заказчика, sp.Код_заказа 
from tblСписокЗаказов sp
	inner join
			(
			select s.Код_ID
					, s.Код_заказчика
					, s.Код_заказа
					, s.ID
					, s.Код
					, case when (s.Код_заказчика = '00050' and s.Код_заказа = 'z01694')
						then '30050'
						else '00050' 
						end as New_Код_заказчика
					, case when (s.Код_заказчика = '00050' and s.Код_заказа = 'z01694')
						then 'z00150'
						else 'z01694' 
						end as New_Код_заказа
			from tblСписокЗаказов s
			where (s.Код_заказчика = '00050' and s.Код_заказа = 'z01694')
				or 
				  (s.Код_заказчика = '30050' and s.Код_заказа = 'z00150')
			) x on x.ID = sp.ID 
				and x.Код_заказчика = sp.Код_заказчика
				and x.Код_заказа = sp.Код_заказа
;

--update z
--set Количество = y.cnt
select y.*, z.Количество
from tblЗаказы z
inner join (	  
			select s.Код_заказчика, s.Код_заказа, count(*) as cnt 
			from tblСписокЗаказов s
			where (s.Код_заказчика = '00050' and s.Код_заказа = 'z01694')
				or 
				  (s.Код_заказчика = '30050' and s.Код_заказа = 'z00150')
			group by s.Код_заказчика, s.Код_заказа
			) y on y.Код_заказа = z.Код_заказа and y.Код_заказчика = z.Код_заказчика
;

commit -- rollback


select s.Код
	,  s.Заказ
	,  s.ID
	,  case when (s.Заказ = '00050-z01694')
						then '30050-z00150'
						else '00050-z01694'
						end as New_Заказ
	, z.ID, z.Код_заказчика, z.Код_заказа
from dbo.tblЗаказыПоставщикамСп1 s
	left join tblСписокЗаказов z on z.ID = s.ID
		and z.Код_заказчика + '-' + z.Код_заказа = s.Заказ
				  /* case when (s.Заказ = '00050-z01694')
						then '30050-z00150'
						else '00050-z01694'
						end */
where (s.Заказ = '00050-z01694')
	or 
	  (s.Заказ = '30050-z00150')
;

/*
select s.*
into _tmp_tblЗаказыПоставщикамСп1_back_20200710_1305
from dbo.tblЗаказыПоставщикамСп1 s
where (s.Заказ = '00050-z01694')
	or 
	  (s.Заказ = '30050-z00150')	
*/

begin tran

-- update x set Заказ = y.New_Заказ
--select x.ID, x.Заказ, y.New_Заказ
from tblЗаказыПоставщикамСп1 x
	inner join (
				select s.Код
					,  s.Заказ
					,  s.ID
					,  case when (s.Заказ = '00050-z01694')
										then '30050-z00150'
										else '00050-z01694'
										end as New_Заказ
				from dbo.tblЗаказыПоставщикамСп1 s
				where (s.Заказ = '00050-z01694')
					or 
					  (s.Заказ = '30050-z00150')	
				) y on x.Код = y.Код
;

commit -- rollback