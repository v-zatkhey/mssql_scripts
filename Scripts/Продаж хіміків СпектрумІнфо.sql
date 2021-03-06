/***
Володя, от список хіміків Спектрум. Я хотів би мати статистику продажів (за останні 5 років) всіх речовин, що синтезували ці хіміки. 

SKP
BSB
SUA
MNB
GER
ADA
DEU
OAM
JTG
MEM

Дякую,
Сергій Попов
*/

declare @InnerOrd table(CustomerCode char(5));
insert into @InnerOrd values('00050')  
 , ('00105')  
 , ('00022')  
 , ('00122')  
 , ('00429')  
 , ('00430')  
 , ('00014')  
 , ('00279')  
 , ('00606')  
 , ('90122')  
 , ('10122')  
 , ('40122')  
 , ('90429')  
 , ('01000')  
 , ('01070')  
 , ('01170')  
 , ('10022')  
 , ('50050')  
 , ('50122')  
 , ('50406')  
 , ('50429')  
 , ('01160')  
 , ('10050')  
 , ('30050')  
 , ('10429')  
 , ('40022')  
 , ('00401')  
 , ('00402')  
 , ('00403')  
 , ('00404')  
 , ('00405')  
 , ('00406')  
 , ('00407')  
 , ('00408')  
 , ('00409')  
 , ('00410') ;

declare @ChemList as table(Abbr char(3));
insert into @ChemList values('SKP')
,('BSB')
,('SUA')
,('MNB')
,('GER')
,('ADA')
,('DEU')
,('OAM')
,('JTG')
,('MEM')
, ('MLG')
, ('DNF')
, ('BEV')
, ('PSV')
, ('KEV')

--select Abbr from @ChemList;
declare @BegDate as date = '20140101', @EndDate as date = getdate();
--declare @BegDate as date = '20090101', @EndDate as date = '20131231';


select v.Код_поставщика 
	--, v.*
	-- , v.Код_заказчика
--	 , COUNT(*) AllCnt
	 , COUNT(case when v.Код_заказчика like '9____' then null else v.Код_заказчика end) as CntLC
--	 , COUNT(case when v.Код_заказчика like '9____' then v.Код_заказчика else null end) as CntSp
	 
from tblВыполненныеЗаказы v
	inner join dbo.tblОтправкаЗаказов o on o.Код_заказчика = v.Код_заказчика and o.Код_отправки = v.Код_отправки
--	inner join dbo.tblЗаказы o on o.Код_заказчика = v.Код_заказчика and o.Код_заказа = v.Код_заказа
	inner join @ChemList l on l.Abbr = v.Код_поставщика 
where o.Дата between @BegDate and @EndDate 
--	and v.Код_заказчика not like '__122'	
--	and v.Код_заказчика not like '__050'	
--	and v.Код_заказчика not like '9____'	
	and not exists(select * from @InnerOrd where CustomerCode = v.Код_заказчика)
	and v.Масса < 250
	and l.Abbr in ('GER', 'KEV', 'MEM')
group by v.Код_поставщика --, v.Код_заказчика
order by v.Код_поставщика --, v.Код_заказчика
;


select v.ID
	, v.Код_поставщика
	, v.Код_заказчика
	, v.Код_заказа
	, replace(cast(v.Масса	as varchar(32)),'.',',') as Масса
	, replace(cast(v.Цена_заказчику	as varchar(32)),'.',',') as Цена_заказчику
from tblВыполненныеЗаказы v
	inner join dbo.tblОтправкаЗаказов o on o.Код_заказчика = v.Код_заказчика and o.Код_отправки = v.Код_отправки
	inner join @ChemList l on l.Abbr = v.Код_поставщика 
where o.Дата between @BegDate and @EndDate 
	and v.Код_заказчика not like '__122'	
	and v.Код_заказчика not like '__050'	
	and v.Код_заказчика not like '9____'	
	and not exists(select * from @InnerOrd where CustomerCode = v.Код_заказчика)
	and v.Масса < 250
	and l.Abbr in ('GER', 'KEV', 'MEM')
order by v.ID, v.Код_заказчика, v.Код_заказа	

go

/*
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
*/