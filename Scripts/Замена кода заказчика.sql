/****** Сценарий для команды SelectTopNRows среды SSMS  ******/
select * from tblЗаказы z
where z.Код_заказчика = '00863' and z.Код_заказа = 'z00072';

update tblЗаказы set Код_заказчика = '01210' where Код = 50266;

select * from tblЗаказы z
where z.Код_заказчика = '01210' and z.Код_заказа = 'z00072';