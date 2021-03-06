select m.[SINFO-ID], v.ID , v.Масса , o.Дата , v.*
from tblВыполненныеЗаказы v
	inner join Materials m on m.MatName = v.ID 
	inner join dbo.tblОтправкаЗаказов o on o.Код_заказчика = v.Код_заказчика and o.Код_отправки = v.Код_отправки
where v.Код_заказчика like '9%'
	and v.Код_заказчика != '90122'
	and o.Дата between '20190101' and '20191130'
order by m.[SINFO-ID], o.Дата;
go


with SaledMaterials(SInfoNumber,IDNUMBER) as 
(select  m.[SINFO-ID],v.ID  
from tblВыполненныеЗаказы v
	inner join Materials m on m.MatName = v.ID 
	inner join dbo.tblОтправкаЗаказов o on o.Код_заказчика = v.Код_заказчика and o.Код_отправки = v.Код_отправки
where v.Код_заказчика like '9%'
	and v.Код_заказчика != '90122'
	and o.Дата between '20190101' and '20191130'
group by m.[SINFO-ID],v.ID	
 )

select sm.*, p.Код_поставщика , p.Код_поставки, convert(varchar(10),p.Дата_пост,104) As PartDate, p.Масса as StartMass
from tblПоставки p
	inner join  SaledMaterials sm on sm.IDNUMBER = p.ID 
order by sm.SInfoNumber, p.Дата_пост;


with SaledMaterials(SInfoNumber,IDNUMBER, Mass, [Date], Supplier, Part) as 
(select  m.[SINFO-ID],v.ID, v.Масса , o.Дата, v.Код_поставщика , v.Код_поставки   
from tblВыполненныеЗаказы v
	inner join Materials m on m.MatName = v.ID 
	inner join dbo.tblОтправкаЗаказов o on o.Код_заказчика = v.Код_заказчика and o.Код_отправки = v.Код_отправки
where v.Код_заказчика like '9%'
	and v.Код_заказчика != '90122'
	and o.Дата between '20190101' and '20191130'
group by m.[SINFO-ID],v.ID, v.Масса , o.Дата, v.Код_поставщика , v.Код_поставки)

select sm.*, convert(varchar(10),p.Дата_пост,104) As PartDate, p.Масса as StartMass
from tblПоставки p
	inner join  SaledMaterials sm on sm.IDNUMBER = p.ID and  sm.Supplier = p.Код_поставщика and sm.Part = p.Код_поставки
order by sm.SInfoNumber, sm.Date ;