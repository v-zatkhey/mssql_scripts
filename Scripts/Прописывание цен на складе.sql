/*** всего в работе **/ -- 415
select COUNT(*) as Quantity
from dbo._tmp_SetPrice t ; 

/**дубли**/
select t.CAS, COUNT(*)
from dbo._tmp_SetPrice t  
group by t.CAS
having COUNT(*)> 1;

select t.*
from dbo._tmp_SetPrice t  
where t.CAS in ('1313-13-9','5936-14-1','723294-72-2')
order by CAS, Price;

go

/* не найдены */ -- 7
select t.*
from dbo._tmp_SetPrice t 
	left join __Вещества v on v.CAS = t.CAS --and v.Код_с = 8
where v.Код_ID is  null 
order by v.CAS desc

/*по следам бременских музыкантов*/
/*

135-76-2   это "Sodium 6-hydroxynaphthalene-2-sulfonate", синоним - "Sodium 2-Naphthol-6-sulfonate" или "2-Naphthol-6-sulfonic acid sodium salt". У этого вещества есть второй КАС (такое бывает иногда!) - это 15883-56-4, так что можете эту запись отнести к этому второму КАС. Или в базе указать оба эти КАС номера.
63995-75-5  Название в-ва с таким КАС "Sodium Diphenylphosphinobenzene-3-sulfonate". Этот КАС-номер имеют в-ва, отмеченные в базе как S02192, F9995-0058
723294-72-2 Название в-ва - "4,4,4,4,3,3-Pentafluoro-2-hydroxy-2-phenyl-buturic acid methyl ester", то же самое, как с кодом 
*/
select * from _tmp_SetPrice where CAS = '135-76-2' -- ID = 158
--update _tmp_SetPrice set CAS = '15883-56-4' where ID = 158;
select * from _tmp_SetPrice where CAS = '63995-75-5' -- ID = 195
--update _tmp_SetPrice set CAS = 'S2192,F9995-0058' where ID = 195;
select * from _tmp_SetPrice where CAS = '723294-72-2' -- ID = 226,254
--update _tmp_SetPrice set CAS = 'O-0539' where ID = 226;
go


/**********  без приёмок *******/ -- 6
select t.CAS, t.Unit, t.Price, v.ProdName, * 
from dbo._tmp_SetPrice t 
	inner join __Вещества v on v.CAS = t.CAS
	left join dbo.__Приемка  pr on pr.Код_ID_вещества = v.Код_ID and pr.Код_с = v.Код_с
where  v.Код_с in (8)
		and pr.Код_ID is null;
go

/**********  с приёмками *******/ -- 402
select * 
from dbo._tmp_SetPrice t 
	inner join __Вещества v on v.CAS = t.CAS
	inner join dbo.__Приемка  pr on pr.Код_ID_вещества = v.Код_ID and pr.Код_с = v.Код_с
where  v.Код_с in (8)
		and pr.Код_ID = (
					select MAX(pr2.Код_ID) 
					from dbo.__Приемка  pr2
						inner join dbo.__Поставки pst2 on pst2.Код_ID = pr2.Код_ID_поставки
					where pr2.Код_ID_вещества = v.Код_ID 
							and pr2.Код_с = v.Код_с
							and pst2.Дата = (select MAX(pst3.Дата) 
											from dbo.__Приемка  pr3
												inner join dbo.__Поставки pst3 on pst3.Код_ID = pr3.Код_ID_поставки
											where pr3.Код_ID_вещества = v.Код_ID 
													and pr3.Код_с = v.Код_с)
					)
		 ;
go


/****** различные единицы ******/
select distinct t.Unit, pr.UM 
from dbo._tmp_SetPrice t 
	inner join __Вещества v on v.CAS = t.CAS
	inner join dbo.__Приемка  pr on pr.Код_ID_вещества = v.Код_ID and pr.Код_с = v.Код_с
where pr.Код_ID = (
					select MAX(pr2.Код_ID) 
					from dbo.__Приемка  pr2
						inner join dbo.__Поставки pst2 on pst2.Код_ID = pr2.Код_ID_поставки
					where pr2.Код_ID_вещества = v.Код_ID 
							and pr2.Код_с = v.Код_с
							and pst2.Дата = (select MAX(pst3.Дата) 
											from dbo.__Приемка  pr3
												inner join dbo.__Поставки pst3 on pst3.Код_ID = pr3.Код_ID_поставки
											where pr3.Код_ID_вещества = v.Код_ID 
													and pr3.Код_с = v.Код_с)
					)
		and v.Код_с in (8);

/****** совпавшие единицы ******/
select distinct t.Unit, pr.UM 
from dbo._tmp_SetPrice t 
	inner join __Вещества v on v.CAS = t.CAS
	inner join dbo.__Приемка  pr on pr.Код_ID_вещества = v.Код_ID and pr.Код_с = v.Код_с
where pr.Код_ID = (
					select MAX(pr2.Код_ID) 
					from dbo.__Приемка  pr2
						inner join dbo.__Поставки pst2 on pst2.Код_ID = pr2.Код_ID_поставки
					where pr2.Код_ID_вещества = v.Код_ID 
							and pr2.Код_с = v.Код_с
							and pst2.Дата = (select MAX(pst3.Дата) 
											from dbo.__Приемка  pr3
												inner join dbo.__Поставки pst3 on pst3.Код_ID = pr3.Код_ID_поставки
											where pr3.Код_ID_вещества = v.Код_ID 
													and pr3.Код_с = v.Код_с)
					)
		and v.Код_с in (8) --,1
		and (UPPER(t.Unit) = UPPER(pr.UM) 
			or (t.Unit = 'mL' and  pr.UM = 'мл')) ;

/** переводимые **/	
select distinct t.Unit, pr.UM
	, case when  t.Unit = 'g' and  pr.UM = 'kg'
		then 1000.0
		else
		case when t.Unit = 'g' and  pr.UM = 'mg'
			then 1.0/1000
			else
			case when t.Unit = 'kg' and  pr.UM = 'g'
				then 1.0/1000
				else
				case when t.Unit = 'L' and  pr.UM = 'ml'
					then 1.0/1000
					else
					case when t.Unit = 'L' and  pr.UM = 'мл'
						then 1.0/1000
						else 1.0
						end
					end
				end
			end
		end  as MutiFactor
--into _tmp_SetPrice_Factor
from dbo._tmp_SetPrice t 
	inner join __Вещества v on v.CAS = t.CAS
	inner join dbo.__Приемка  pr on pr.Код_ID_вещества = v.Код_ID and pr.Код_с = v.Код_с
where ( (t.Unit = 'g' and  pr.UM = 'kg') 	
		or (t.Unit = 'g' and  pr.UM = 'mg') 	
		or (t.Unit = 'kg' and  pr.UM = 'g') 	
		or (t.Unit = 'L' and  pr.UM = 'ml') 	
		or (t.Unit = 'L' and  pr.UM = 'мл') 
		or (t.Unit = 'mL' and  pr.UM = 'мл')
		or (UPPER(t.Unit) = UPPER(pr.UM))
		)

/** непереводимые **/	
select distinct t.Unit, pr.UM, t.*, v.ProdName
from dbo._tmp_SetPrice t 
	inner join __Вещества v on v.CAS = t.CAS
	inner join dbo.__Приемка  pr on pr.Код_ID_вещества = v.Код_ID and pr.Код_с = v.Код_с
 where pr.Код_ID = (
					select MAX(pr2.Код_ID) 
					from dbo.__Приемка  pr2
						inner join dbo.__Поставки pst2 on pst2.Код_ID = pr2.Код_ID_поставки
					where pr2.Код_ID_вещества = v.Код_ID 
							and pr2.Код_с = v.Код_с
							and pst2.Дата = (select MAX(pst3.Дата) 
											from dbo.__Приемка  pr3
												inner join dbo.__Поставки pst3 on pst3.Код_ID = pr3.Код_ID_поставки
											where pr3.Код_ID_вещества = v.Код_ID 
													and pr3.Код_с = v.Код_с)
					)
		and v.Код_с in (8) --,1
		and pr.USD_CostPrice is null 
		and not( (t.Unit = 'g' and  pr.UM = 'kg') 	
				or (t.Unit = 'g' and  pr.UM = 'mg') 	
				or (t.Unit = 'kg' and  pr.UM = 'g') 	
				or (t.Unit = 'L' and  pr.UM = 'ml') 	
				or (t.Unit = 'L' and  pr.UM = 'мл') 
				or (t.Unit = 'mL' and  pr.UM = 'мл')
				or UPPER(t.Unit) = UPPER(pr.UM)
				)
go


/********** которые уже есть и равны ******/ --34
select pr.USD_CostPrice 
	, t.Price*f.MutiFactor*POWER(isnull(ro.Ro,1),isnull(f.RoFactor,0)) - pr.USD_CostPrice as NewPriceUp
	, t.*
	, v.Код_ID
	, v.Код_с
	, v.RusName
	, v.ProdName
	, pr.UM
from dbo._tmp_SetPrice t 
	inner join __Вещества v on v.CAS = t.CAS
	inner join dbo.__Приемка  pr on pr.Код_ID_вещества = v.Код_ID and pr.Код_с = v.Код_с
	inner join  dbo._tmp_SetPrice_Factor f on f.Unit = t.Unit and f.UM = pr.UM
	left join dbo._tmp_SetPrice_Ro ro on ro.ID = t.ID
where pr.Код_ID = (
					select MAX(pr2.Код_ID) 
					from dbo.__Приемка  pr2
						inner join dbo.__Поставки pst2 on pst2.Код_ID = pr2.Код_ID_поставки
					where pr2.Код_ID_вещества = v.Код_ID 
							and pr2.Код_с = v.Код_с
							and pst2.Дата = (select MAX(pst3.Дата) 
											from dbo.__Приемка  pr3
												inner join dbo.__Поставки pst3 on pst3.Код_ID = pr3.Код_ID_поставки
											where pr3.Код_ID_вещества = v.Код_ID 
													and pr3.Код_с = v.Код_с)
					)
		and v.Код_с in (8) --,1
		and pr.USD_CostPrice is not null
		and abs( t.Price*f.MutiFactor*POWER(isnull(ro.Ro,1),isnull(f.RoFactor,0)) - pr.USD_CostPrice) < 1E-6
order by v.CAS desc;

/********** которые уже есть и не равны ******/ --13
select t.CAS
	, t.Price 
	, t.Price*f.MutiFactor*POWER(isnull(ro.Ro,1),isnull(f.RoFactor,0)) as NewPrice
	, pr.USD_CostPrice 
	, t.Price*f.MutiFactor*POWER(isnull(ro.Ro,1),isnull(f.RoFactor,0)) - pr.USD_CostPrice as NewPriceUp
	, t.Unit
	, pr.UM
	, v.Код_ID
	, v.ProdName
from dbo._tmp_SetPrice t 
	inner join __Вещества v on v.CAS = t.CAS
	inner join dbo.__Приемка  pr on pr.Код_ID_вещества = v.Код_ID and pr.Код_с = v.Код_с
	inner join  dbo._tmp_SetPrice_Factor f on f.Unit = t.Unit and f.UM = pr.UM
	left join dbo._tmp_SetPrice_Ro ro on ro.ID = t.ID
where pr.Код_ID = (
					select MAX(pr2.Код_ID) 
					from dbo.__Приемка  pr2
						inner join dbo.__Поставки pst2 on pst2.Код_ID = pr2.Код_ID_поставки
					where pr2.Код_ID_вещества = v.Код_ID 
							and pr2.Код_с = v.Код_с
							and pst2.Дата = (select MAX(pst3.Дата) 
											from dbo.__Приемка  pr3
												inner join dbo.__Поставки pst3 on pst3.Код_ID = pr3.Код_ID_поставки
											where pr3.Код_ID_вещества = v.Код_ID 
													and pr3.Код_с = v.Код_с)
					)
		and v.Код_с in (8) --,1
		and pr.USD_CostPrice is not null
		and abs(t.Price*f.MutiFactor*POWER(isnull(ro.Ro,1),isnull(f.RoFactor,0)) - pr.USD_CostPrice) > 1E-6
order by v.CAS desc;

	
/********** которых нет и единицы не приводимые ******/ --25
select t.ID
	, t.CAS 
	,  t.Price 
	, t.Unit
	, pr.UM
	, ro.Ro
	, ROUND( t.Price*f.MutiFactor*POWER(isnull(ro.Ro,1),isnull(f.RoFactor,0)), 6)  as NewPrice	
	, v.Код_ID
	, v.ProdName
from dbo._tmp_SetPrice t 
	inner join __Вещества v on v.CAS = t.CAS
	inner join dbo.__Приемка  pr on pr.Код_ID_вещества = v.Код_ID and pr.Код_с = v.Код_с
	inner join dbo._tmp_SetPrice_Factor f on f.Unit = t.Unit and f.UM = pr.UM
	left join dbo._tmp_SetPrice_Ro ro on ro.ID = t.ID
where pr.Код_ID = (
					select MAX(pr2.Код_ID) 
					from dbo.__Приемка  pr2
						inner join dbo.__Поставки pst2 on pst2.Код_ID = pr2.Код_ID_поставки
					where pr2.Код_ID_вещества = v.Код_ID 
							and pr2.Код_с = v.Код_с
							and pst2.Дата = (select MAX(pst3.Дата) 
											from dbo.__Приемка  pr3
												inner join dbo.__Поставки pst3 on pst3.Код_ID = pr3.Код_ID_поставки
											where pr3.Код_ID_вещества = v.Код_ID 
													and pr3.Код_с = v.Код_с)
					)
		and v.Код_с in (8) --,1
		and pr.USD_CostPrice is null
		and f.RoFactor != 0
order by v.CAS desc;

/********** которые будут обновлены ******/ -- 353
/*
-- backup
select pr.*
into dbo._tmp_SetPrice__Приемка_bak
from dbo._tmp_SetPrice t 
	inner join __Вещества v on v.CAS = t.CAS
	inner join dbo.__Приемка  pr on pr.Код_ID_вещества = v.Код_ID and pr.Код_с = v.Код_с
	inner join  dbo._tmp_SetPrice_Factor f on f.Unit = t.Unit and f.UM = pr.UM
	left join dbo._tmp_SetPrice_Ro ro on ro.ID = t.ID
where pr.Код_ID = (
					select MAX(pr2.Код_ID) 
					from dbo.__Приемка  pr2
						inner join dbo.__Поставки pst2 on pst2.Код_ID = pr2.Код_ID_поставки
					where pr2.Код_ID_вещества = v.Код_ID 
							and pr2.Код_с = v.Код_с
							and pst2.Дата = (select MAX(pst3.Дата) 
											from dbo.__Приемка  pr3
												inner join dbo.__Поставки pst3 on pst3.Код_ID = pr3.Код_ID_поставки
											where pr3.Код_ID_вещества = v.Код_ID 
													and pr3.Код_с = v.Код_с)
					)
		and v.Код_с  = 8
		and pr.USD_CostPrice is null
		and t.ID not in (223,248)
;

*/
go


select pr.Код_ID
	, ROUND( t.Price*f.MutiFactor*POWER(isnull(ro.Ro,1),isnull(f.RoFactor,0)), 6)   as NewPriceUp
	, t.*
	, v.Код_ID
	, v.Код_с
	, v.RusName
	, v.ProdName
	, pr.UM
from dbo._tmp_SetPrice t 
	inner join __Вещества v on v.CAS = t.CAS
	inner join dbo.__Приемка  pr on pr.Код_ID_вещества = v.Код_ID and pr.Код_с = v.Код_с
	inner join  dbo._tmp_SetPrice_Factor f on f.Unit = t.Unit and f.UM = pr.UM
	left join dbo._tmp_SetPrice_Ro ro on ro.ID = t.ID
where pr.Код_ID = (
					select MAX(pr2.Код_ID) 
					from dbo.__Приемка  pr2
						inner join dbo.__Поставки pst2 on pst2.Код_ID = pr2.Код_ID_поставки
					where pr2.Код_ID_вещества = v.Код_ID 
							and pr2.Код_с = v.Код_с
							and pst2.Дата = (select MAX(pst3.Дата) 
											from dbo.__Приемка  pr3
												inner join dbo.__Поставки pst3 on pst3.Код_ID = pr3.Код_ID_поставки
											where pr3.Код_ID_вещества = v.Код_ID 
													and pr3.Код_с = v.Код_с)
					)
		and v.Код_с  = 8
		and pr.USD_CostPrice is null
		--and  t.CAS in ('1313-13-9','5936-14-1','723294-72-2')
		and t.ID not in (223,248)
order by v.CAS desc;


/*
-- update
begin tran

alter table __Приемка disable trigger TR_UPDATE_Sklad30_Приемка;

update pr
set USD_CostPrice = ROUND( t.Price*f.MutiFactor*POWER(isnull(ro.Ro,1),isnull(f.RoFactor,0)), 6) 
from dbo._tmp_SetPrice t 
	inner join __Вещества v on v.CAS = t.CAS
	inner join dbo.__Приемка  pr on pr.Код_ID_вещества = v.Код_ID and pr.Код_с = v.Код_с
	inner join  dbo._tmp_SetPrice_Factor f on f.Unit = t.Unit and f.UM = pr.UM
	left join dbo._tmp_SetPrice_Ro ro on ro.ID = t.ID
where pr.Код_ID = (
					select MAX(pr2.Код_ID) 
					from dbo.__Приемка  pr2
						inner join dbo.__Поставки pst2 on pst2.Код_ID = pr2.Код_ID_поставки
					where pr2.Код_ID_вещества = v.Код_ID 
							and pr2.Код_с = v.Код_с
							and pst2.Дата = (select MAX(pst3.Дата) 
											from dbo.__Приемка  pr3
												inner join dbo.__Поставки pst3 on pst3.Код_ID = pr3.Код_ID_поставки
											where pr3.Код_ID_вещества = v.Код_ID 
													and pr3.Код_с = v.Код_с)
					)
		and v.Код_с  = 8
		and pr.USD_CostPrice is null
		and t.ID not in (223,248);
		
alter table __Приемка enable trigger TR_UPDATE_Sklad30_Приемка;

commit -- rollback		
*/
