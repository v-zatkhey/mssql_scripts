select COUNT(*) from [dbo].[_tmp_LIFECHEM_BB] ; --75025

select *
from tblВыполненныеЗаказы vz
	inner join _tmp_LIFECHEM_BB t on t.IDNUMBER = vz.ID 
	inner join tblЗаказы z on z.Код_заказчика = vz.Код_заказчика and z.Код_заказа = vz.Код_заказа
where vz.Код_отправки not in ('s997', 's998', 's999')
	and z.Дата > '20140101'
	and t.IDNUMBER = 'F6170-0039'
order by t.IDNUMBER	
	;
go	
	
with SaleCount(ID , Cnt , SumMass ) 
as 	(
select 
	t.IDNUMBER
	, COUNT(*) as Cnt
	, round(SUM(vz.Масса),2) as SumMass
--	, round(sum(vz.Цена_заказчику),2)  as Amount
from tblВыполненныеЗаказы vz
	inner join _tmp_LIFECHEM_BB t on t.IDNUMBER = vz.ID 
	inner join tblЗаказы z on z.Код_заказчика = vz.Код_заказчика and z.Код_заказа = vz.Код_заказа
where vz.Код_отправки not in ('s997', 's998', 's999')
	and z.Код_заказчика not in ('90122','00122','00794','00795',
								'00401',
								'00402',
								'00403',
								'00404',
								'00405',
								'00406',
								'00407',
								'00408',
								'00409',
								'00410'
								)
	and z.Дата > '20140101'
	and vz.Масса >= 250
group by t.IDNUMBER	
)

select top 1000 
	s.ID
	, m.CASNumber
	, m.IUPAC_Name
	, lc.Масса as LC_mass
	, s.Cnt as SaleCount 
	, s.SumMass as SaleMass
from  SaleCount s
	inner join Materials m on m.MatName = s.ID
	left join tblСклад_LC lc on lc.ID = s.ID 
where ISNULL(lc.Масса,0)>0	
order by 	s.Cnt desc;
			
