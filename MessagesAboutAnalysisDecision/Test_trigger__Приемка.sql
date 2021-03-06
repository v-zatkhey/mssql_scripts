/****** Сценарий для команды SelectTopNRows среды SSMS  ******/
use SKLAD30 ;
go

select v.CAS --, p.*
		, post.Номер_поставки  
		, i.Источник
from __Приемка p 
	inner join __Вещества v on v.Код_ID = p.Код_ID_вещества 
	inner join __Поставки post on post.Код_ID = p.Код_ID_поставки
	inner join __Источники i on i.Код_ID = post.Код_ID_источника 
	--inner join 
	
select distinct Оформлено, Утверждено_завлабом, Подписано, Подобрано, Выдано 
from 	dbo.__Требования
order by Оформлено, Утверждено_завлабом, Подписано, Подобрано, Выдано 
select * from dbo.Типы_решений_по_требованиям

select Оформлено, Утверждено_завлабом, Подписано, Подобрано, Выдано , На_руках , *
from 	dbo.__Требования
where Оформлено = 1
	and Утверждено_завлабом < 2
	and Подписано < 2
	and Подобрано < 2
	and Выдано = 0
	AND (На_руках = 0)   
and Код_с = 8

select Код_с, COUNT(*)
from 	dbo.__Требования
where Оформлено = 1
	and Утверждено_завлабом < 2
	and Подписано < 2
	and Подобрано < 2
	and Выдано = 0
group by Код_с	

SELECT * FROM __Тр2_Подбор ORDER BY [__Тр2_Подбор].Код_ID;

SELECT * FROM [__Тр2_Подбор]  
WHERE [Оформлено] = 1  
	AND (Подобрано = 0)   
	AND (На_руках = 0)   
	AND [Подписано] = 1  
	AND [Утверждено_завлабом] = 1  
AND (Код_с = 8)   
ORDER BY [Логин] 

SELECT * FROM [__Тр2_Утверждение]  
WHERE Parent_Id = 165 
	AND [Оформлено] = 1  
	AND (Утверждено_завлабом = 0)   
	AND (Код_с = 8)   ORDER BY [Код_ID] 


select  t.Код_пользователя
	, u.Название
	, u.Email
from __Приемка p 
--	inner join __Вещества v on v.Код_ID = p.Код_ID_вещества 
	inner join __Требования t on t.Код_ID_Вещества = p.Код_ID_вещества 
	inner join dbo.Пользователи u on u.Код = t.Код_пользователя 
where p.Решение_по_анализу != 0
	and t.Оформлено = 1
	and t.Утверждено_завлабом < 2
	and t.Подписано < 2
	and t.Подобрано < 2
	and t.Выдано = 0	
	and t.На_руках = 0
	--and pf.Email is not null
group by  t.Код_пользователя, u.Email, u.Название	

/*****************************/
/******* test for trigger ***/

select Код, Название, Email from Пользователи where Enabled = 1;

select * from __Требования t where t.Код_пользователя = 165
select * from __Приемка p where p.Код_ID = 38929 -- реш. - 0
select * from __Вещества v where v.Код_ID = 13290

begin tran
update __Требования set Выдано = 0, Подобрано = 0 where Код_ID = 45206

update __Приемка set Решение_по_анализу = 1 where Код_ID = 38929

update __Требования set Выдано = 1, Подобрано = 1 where Код_ID = 45206
update __Приемка set Решение_по_анализу = 0 where Код_ID = 38929
commit

select * from __Требования t where t.Код_пользователя = 165
select * from __Приемка p where p.Код_ID = 38929 -- реш. - 0

