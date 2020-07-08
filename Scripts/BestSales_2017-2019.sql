/****** ББ, що найбільше продавалися з 2017 року*/
select v.ID, m.CASNumber,  COUNT(*) as Cnt 
from tblВыполненныеЗаказы v
		inner join tblЗаказы z on z.Код_заказчика = v.Код_заказчика and z.Код_заказа = v.Код_заказа 
		inner join Materials m on m.MatName = v.ID
		left join tblБазовыеСписки bl on bl.ID = v.ID 
where v.Масса >= 100
	and z.Дата >= '20170101'	
	and bl.Дата_окончания_Эксклюзивности is null
group by v.ID, m.CASNumber
having COUNT(*)>=5
order by COUNT(*) desc,ID

