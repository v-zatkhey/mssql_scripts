select bl.Код_ID, bl.Условия_взвешивания 
-- update bl set Условия_взвешивания = replace(Условия_взвешивания, 'Сухой лед!','Сухой  лед!')
from tblБазовыеСписки bl
where bl.Условия_взвешивания like '%Сухой  лед!%';

select bl.Код_ID, bl.Условия_взвешивания 
from tblБазовыеСписки bl
where bl.ID = 'F2158-1528';

select bl.ID, bl.Условия_взвешивания 
from tblБазовыеСписки bl
	inner join tblBaseListCondition c on c.BaseListID = bl.Код_ID
where c.ConditionID = 6

select  bl.Код_ID, bl.Условия_взвешивания 
--update bl set Условия_взвешивания = replace(Условия_взвешивания, 'Сухой лед!','Сухой  лед!')
from tblБазовыеСписки bl
	inner join tblBaseListCondition c on c.BaseListID = bl.Код_ID
where  bl.Код_ID = 4434946

select  bl.ID, bl.Условия_взвешивания 
--update bl set Условия_взвешивания = Условия_взвешивания
from tblБазовыеСписки bl
	inner join tblBaseListCondition c on c.BaseListID = bl.Код_ID
where  c.ConditionID = 26

select bl.ID, bl.Условия_взвешивания
from tblБазовыеСписки bl
	inner join tblBaseListCondition c on c.BaseListID = bl.Код_ID
where c.ConditionID  = 23
order by c.ConditionID

select bl.ID, bl.Условия_взвешивания, t.[Условие взвешивания] 
from tblБазовыеСписки bl
	inner join dbo.tblТипы_условий_взвешивания t on t.Код = c.ConditionID
where bl.Условия_взвешивания not like '%'+ t.[Условие взвешивания] + '%' 

--update tblБазовыеСписки set Условия_взвешивания = Условия_взвешивания where ID = 'F0001-3152'

select bl.ID, bl.Условия_взвешивания
--update  bl set Условия_взвешивания = replace(Условия_взвешивания,  '!,','!')
from tblБазовыеСписки bl
where Условия_взвешивания like '%!,%';

/*************************/
select * 
into tblБазовыеСписки_BACK_20200227
from tblБазовыеСписки

select bl.ID, bl.Условия_взвешивания
--update  bl set Условия_взвешивания = replace(Условия_взвешивания,  'Избегать попадания влаги!','')
from tblБазовыеСписки bl
where  exists(	select * 
				from tblBaseListCondition c 
				where c.BaseListID = bl.Код_ID 
					and c.ConditionID = 7)
	and exists(	select * 
				from tblBaseListCondition c 
				where c.BaseListID = bl.Код_ID 
					and c.ConditionID = 6)


select bl.ID, bl.Условия_взвешивания
--update  bl set Условия_взвешивания = replace(Условия_взвешивания,  'Гигроскопичное!','')
from tblБазовыеСписки bl
where  exists(	select * 
				from tblBaseListCondition c 
				where c.BaseListID = bl.Код_ID 
					and c.ConditionID = 19)
	and exists(	select * 
				from tblBaseListCondition c 
				where c.BaseListID = bl.Код_ID 
					and c.ConditionID = 6);
					
--update  bl set Условия_взвешивания =replace(Условия_взвешивания,  'Отправка - сухой лед!','') from tblБазовыеСписки bl	where ID = 'F0001-3939';	
begin tran
update  bl set Условия_взвешивания =replace(Условия_взвешивания,  'Отправка без льда!','')
from tblБазовыеСписки bl	where ID = 'F0001-3939';	
update  bl set Условия_взвешивания = Условия_взвешивания + 'Отправка - сухой лед!'
from tblБазовыеСписки bl	where ID = 'F0001-3939';	
commit
			
select bl.ID, bl.Условия_взвешивания
--update  bl set Условия_взвешивания = Условия_взвешивания + ' Отправка без льда!'
from tblБазовыеСписки bl
where bl.ID in ('F0001-1134',
'F0001-1308',
'F0001-2076',
'F0001-2208',
'F0001-3038',
'F0001-3334',
'F0001-3451',
'F0001-3467',
'F0001-3493',
'F0001-3777',
'F0001-3842',
'F0001-3873',
'F0001-3939',
'F0001-4073',
'F0341-0597',
'F0896-0475',
'F1371-0211',
'F1386-0111',
'F1386-0121',
'F1901-3535',
'F1905-0072',
'F1905-0073',
'F1905-0490',
'F1905-6598',
'F1963-0010',
'F2111-0063',
'F2135-0618',
'F2135-1153',
'F2147-0624',
'F2147-0855',
'F2147-0977',
'F2147-1321',
'F2147-1347',
'F2147-1654',
'F2147-2341',
'F2147-5450',
'F2147-6362',
'F2147-8792',
'F2169-1116',
'F2173-1393',
'F2191-0027',
'F2191-0155',
'F2191-0254',
'F2199-0022',
'F2199-0127',
'F5608-0082',
'F5618-0102',
'F6492-1001',
'F6492-1002',
'F8880-6552',
'F8881-0782',
'F8881-5214',
'F8881-8955',
'F8882-1383',
'F8883-0482',
'F8883-7724',
'F8885-1734',
'F8885-8849',
'F9994-0362',
'F9994-5183',
'F9994-5244')

Отправка-сухой лед!
F8885-0863 
F8882-5933        
F8882-5938        
F8882-5939        
F8883-6038        
F8884-5395      

select bl.ID, bl.Условия_взвешивания
from tblБазовыеСписки bl
where bl.ID in ('F8885-0863', 
'F8882-5933',        
'F8882-5938',        
'F8882-5939',        
'F8883-6038',        
'F8884-5395')

begin tran
update  bl set Условия_взвешивания =replace(Условия_взвешивания,  'Сухой  лед!','')
from tblБазовыеСписки bl	where ID = 'F8885-0863';	
update  bl set Условия_взвешивания = Условия_взвешивания + 'Отправка - сухой лед!'
from tblБазовыеСписки bl	where ID = 'F8885-0863';	
commit

select bl.ID, bl.Условия_взвешивания
from tblБазовыеСписки bl
where  exists(	select * 
				from tblBaseListCondition c 
				where c.BaseListID = bl.Код_ID 
					and c.ConditionID = 14)
		and bl.Условия_взвешивания <> 'Стандартные условия';
		
select bl.ID, bl.Условия_взвешивания
from tblБазовыеСписки bl
where   bl.Условия_взвешивания like '%,%';		

select bl.ID, bl.Условия_взвешивания
from tblБазовыеСписки bl
where   bl.Условия_взвешивания like '%!,%';	

select bl.ID, bl.Условия_взвешивания
--update  bl set Условия_взвешивания = replace(Условия_взвешивания,  '!  ,','! ')
from tblБазовыеСписки bl
where Условия_взвешивания like '%!  ,%';

select * from Перечень_таблиц
select * from TableLogs where TableID = 2 and IDNUMBER_old = 'F1905-0034'
