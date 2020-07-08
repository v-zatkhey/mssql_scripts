/*** ����� � ������ **/ -- 415
select COUNT(*) as Quantity
from dbo._tmp_SetPrice t ; 

/**�����**/
select t.CAS, COUNT(*)
from dbo._tmp_SetPrice t  
group by t.CAS
having COUNT(*)> 1;

select t.*
from dbo._tmp_SetPrice t  
where t.CAS in ('1313-13-9','5936-14-1','723294-72-2')
order by CAS, Price;

go

/* �� ������� */ -- 7
select t.*
from dbo._tmp_SetPrice t 
	left join __�������� v on v.CAS = t.CAS --and v.���_� = 8
where v.���_ID is  null 
order by v.CAS desc

/*�� ������ ���������� ����������*/
/*

135-76-2   ��� "Sodium 6-hydroxynaphthalene-2-sulfonate", ������� - "Sodium 2-Naphthol-6-sulfonate" ��� "2-Naphthol-6-sulfonic acid sodium salt". � ����� �������� ���� ������ ��� (����� ������ ������!) - ��� 15883-56-4, ��� ��� ������ ��� ������ ������� � ����� ������� ���. ��� � ���� ������� ��� ��� ��� ������.
63995-75-5  �������� �-�� � ����� ��� "Sodium Diphenylphosphinobenzene-3-sulfonate". ���� ���-����� ����� �-��, ���������� � ���� ��� S02192, F9995-0058
723294-72-2 �������� �-�� - "4,4,4,4,3,3-Pentafluoro-2-hydroxy-2-phenyl-buturic acid methyl ester", �� �� �����, ��� � ����� 
*/
select * from _tmp_SetPrice where CAS = '135-76-2' -- ID = 158
--update _tmp_SetPrice set CAS = '15883-56-4' where ID = 158;
select * from _tmp_SetPrice where CAS = '63995-75-5' -- ID = 195
--update _tmp_SetPrice set CAS = 'S2192,F9995-0058' where ID = 195;
select * from _tmp_SetPrice where CAS = '723294-72-2' -- ID = 226,254
--update _tmp_SetPrice set CAS = 'O-0539' where ID = 226;
go


/**********  ��� ������ *******/ -- 6
select t.CAS, t.Unit, t.Price, v.ProdName, * 
from dbo._tmp_SetPrice t 
	inner join __�������� v on v.CAS = t.CAS
	left join dbo.__�������  pr on pr.���_ID_�������� = v.���_ID and pr.���_� = v.���_�
where  v.���_� in (8)
		and pr.���_ID is null;
go

/**********  � �������� *******/ -- 402
select * 
from dbo._tmp_SetPrice t 
	inner join __�������� v on v.CAS = t.CAS
	inner join dbo.__�������  pr on pr.���_ID_�������� = v.���_ID and pr.���_� = v.���_�
where  v.���_� in (8)
		and pr.���_ID = (
					select MAX(pr2.���_ID) 
					from dbo.__�������  pr2
						inner join dbo.__�������� pst2 on pst2.���_ID = pr2.���_ID_��������
					where pr2.���_ID_�������� = v.���_ID 
							and pr2.���_� = v.���_�
							and pst2.���� = (select MAX(pst3.����) 
											from dbo.__�������  pr3
												inner join dbo.__�������� pst3 on pst3.���_ID = pr3.���_ID_��������
											where pr3.���_ID_�������� = v.���_ID 
													and pr3.���_� = v.���_�)
					)
		 ;
go


/****** ��������� ������� ******/
select distinct t.Unit, pr.UM 
from dbo._tmp_SetPrice t 
	inner join __�������� v on v.CAS = t.CAS
	inner join dbo.__�������  pr on pr.���_ID_�������� = v.���_ID and pr.���_� = v.���_�
where pr.���_ID = (
					select MAX(pr2.���_ID) 
					from dbo.__�������  pr2
						inner join dbo.__�������� pst2 on pst2.���_ID = pr2.���_ID_��������
					where pr2.���_ID_�������� = v.���_ID 
							and pr2.���_� = v.���_�
							and pst2.���� = (select MAX(pst3.����) 
											from dbo.__�������  pr3
												inner join dbo.__�������� pst3 on pst3.���_ID = pr3.���_ID_��������
											where pr3.���_ID_�������� = v.���_ID 
													and pr3.���_� = v.���_�)
					)
		and v.���_� in (8);

/****** ��������� ������� ******/
select distinct t.Unit, pr.UM 
from dbo._tmp_SetPrice t 
	inner join __�������� v on v.CAS = t.CAS
	inner join dbo.__�������  pr on pr.���_ID_�������� = v.���_ID and pr.���_� = v.���_�
where pr.���_ID = (
					select MAX(pr2.���_ID) 
					from dbo.__�������  pr2
						inner join dbo.__�������� pst2 on pst2.���_ID = pr2.���_ID_��������
					where pr2.���_ID_�������� = v.���_ID 
							and pr2.���_� = v.���_�
							and pst2.���� = (select MAX(pst3.����) 
											from dbo.__�������  pr3
												inner join dbo.__�������� pst3 on pst3.���_ID = pr3.���_ID_��������
											where pr3.���_ID_�������� = v.���_ID 
													and pr3.���_� = v.���_�)
					)
		and v.���_� in (8) --,1
		and (UPPER(t.Unit) = UPPER(pr.UM) 
			or (t.Unit = 'mL' and  pr.UM = '��')) ;

/** ����������� **/	
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
					case when t.Unit = 'L' and  pr.UM = '��'
						then 1.0/1000
						else 1.0
						end
					end
				end
			end
		end  as MutiFactor
--into _tmp_SetPrice_Factor
from dbo._tmp_SetPrice t 
	inner join __�������� v on v.CAS = t.CAS
	inner join dbo.__�������  pr on pr.���_ID_�������� = v.���_ID and pr.���_� = v.���_�
where ( (t.Unit = 'g' and  pr.UM = 'kg') 	
		or (t.Unit = 'g' and  pr.UM = 'mg') 	
		or (t.Unit = 'kg' and  pr.UM = 'g') 	
		or (t.Unit = 'L' and  pr.UM = 'ml') 	
		or (t.Unit = 'L' and  pr.UM = '��') 
		or (t.Unit = 'mL' and  pr.UM = '��')
		or (UPPER(t.Unit) = UPPER(pr.UM))
		)

/** ������������� **/	
select distinct t.Unit, pr.UM, t.*, v.ProdName
from dbo._tmp_SetPrice t 
	inner join __�������� v on v.CAS = t.CAS
	inner join dbo.__�������  pr on pr.���_ID_�������� = v.���_ID and pr.���_� = v.���_�
 where pr.���_ID = (
					select MAX(pr2.���_ID) 
					from dbo.__�������  pr2
						inner join dbo.__�������� pst2 on pst2.���_ID = pr2.���_ID_��������
					where pr2.���_ID_�������� = v.���_ID 
							and pr2.���_� = v.���_�
							and pst2.���� = (select MAX(pst3.����) 
											from dbo.__�������  pr3
												inner join dbo.__�������� pst3 on pst3.���_ID = pr3.���_ID_��������
											where pr3.���_ID_�������� = v.���_ID 
													and pr3.���_� = v.���_�)
					)
		and v.���_� in (8) --,1
		and pr.USD_CostPrice is null 
		and not( (t.Unit = 'g' and  pr.UM = 'kg') 	
				or (t.Unit = 'g' and  pr.UM = 'mg') 	
				or (t.Unit = 'kg' and  pr.UM = 'g') 	
				or (t.Unit = 'L' and  pr.UM = 'ml') 	
				or (t.Unit = 'L' and  pr.UM = '��') 
				or (t.Unit = 'mL' and  pr.UM = '��')
				or UPPER(t.Unit) = UPPER(pr.UM)
				)
go


/********** ������� ��� ���� � ����� ******/ --34
select pr.USD_CostPrice 
	, t.Price*f.MutiFactor*POWER(isnull(ro.Ro,1),isnull(f.RoFactor,0)) - pr.USD_CostPrice as NewPriceUp
	, t.*
	, v.���_ID
	, v.���_�
	, v.RusName
	, v.ProdName
	, pr.UM
from dbo._tmp_SetPrice t 
	inner join __�������� v on v.CAS = t.CAS
	inner join dbo.__�������  pr on pr.���_ID_�������� = v.���_ID and pr.���_� = v.���_�
	inner join  dbo._tmp_SetPrice_Factor f on f.Unit = t.Unit and f.UM = pr.UM
	left join dbo._tmp_SetPrice_Ro ro on ro.ID = t.ID
where pr.���_ID = (
					select MAX(pr2.���_ID) 
					from dbo.__�������  pr2
						inner join dbo.__�������� pst2 on pst2.���_ID = pr2.���_ID_��������
					where pr2.���_ID_�������� = v.���_ID 
							and pr2.���_� = v.���_�
							and pst2.���� = (select MAX(pst3.����) 
											from dbo.__�������  pr3
												inner join dbo.__�������� pst3 on pst3.���_ID = pr3.���_ID_��������
											where pr3.���_ID_�������� = v.���_ID 
													and pr3.���_� = v.���_�)
					)
		and v.���_� in (8) --,1
		and pr.USD_CostPrice is not null
		and abs( t.Price*f.MutiFactor*POWER(isnull(ro.Ro,1),isnull(f.RoFactor,0)) - pr.USD_CostPrice) < 1E-6
order by v.CAS desc;

/********** ������� ��� ���� � �� ����� ******/ --13
select t.CAS
	, t.Price 
	, t.Price*f.MutiFactor*POWER(isnull(ro.Ro,1),isnull(f.RoFactor,0)) as NewPrice
	, pr.USD_CostPrice 
	, t.Price*f.MutiFactor*POWER(isnull(ro.Ro,1),isnull(f.RoFactor,0)) - pr.USD_CostPrice as NewPriceUp
	, t.Unit
	, pr.UM
	, v.���_ID
	, v.ProdName
from dbo._tmp_SetPrice t 
	inner join __�������� v on v.CAS = t.CAS
	inner join dbo.__�������  pr on pr.���_ID_�������� = v.���_ID and pr.���_� = v.���_�
	inner join  dbo._tmp_SetPrice_Factor f on f.Unit = t.Unit and f.UM = pr.UM
	left join dbo._tmp_SetPrice_Ro ro on ro.ID = t.ID
where pr.���_ID = (
					select MAX(pr2.���_ID) 
					from dbo.__�������  pr2
						inner join dbo.__�������� pst2 on pst2.���_ID = pr2.���_ID_��������
					where pr2.���_ID_�������� = v.���_ID 
							and pr2.���_� = v.���_�
							and pst2.���� = (select MAX(pst3.����) 
											from dbo.__�������  pr3
												inner join dbo.__�������� pst3 on pst3.���_ID = pr3.���_ID_��������
											where pr3.���_ID_�������� = v.���_ID 
													and pr3.���_� = v.���_�)
					)
		and v.���_� in (8) --,1
		and pr.USD_CostPrice is not null
		and abs(t.Price*f.MutiFactor*POWER(isnull(ro.Ro,1),isnull(f.RoFactor,0)) - pr.USD_CostPrice) > 1E-6
order by v.CAS desc;

	
/********** ������� ��� � ������� �� ���������� ******/ --25
select t.ID
	, t.CAS 
	,  t.Price 
	, t.Unit
	, pr.UM
	, ro.Ro
	, ROUND( t.Price*f.MutiFactor*POWER(isnull(ro.Ro,1),isnull(f.RoFactor,0)), 6)  as NewPrice	
	, v.���_ID
	, v.ProdName
from dbo._tmp_SetPrice t 
	inner join __�������� v on v.CAS = t.CAS
	inner join dbo.__�������  pr on pr.���_ID_�������� = v.���_ID and pr.���_� = v.���_�
	inner join dbo._tmp_SetPrice_Factor f on f.Unit = t.Unit and f.UM = pr.UM
	left join dbo._tmp_SetPrice_Ro ro on ro.ID = t.ID
where pr.���_ID = (
					select MAX(pr2.���_ID) 
					from dbo.__�������  pr2
						inner join dbo.__�������� pst2 on pst2.���_ID = pr2.���_ID_��������
					where pr2.���_ID_�������� = v.���_ID 
							and pr2.���_� = v.���_�
							and pst2.���� = (select MAX(pst3.����) 
											from dbo.__�������  pr3
												inner join dbo.__�������� pst3 on pst3.���_ID = pr3.���_ID_��������
											where pr3.���_ID_�������� = v.���_ID 
													and pr3.���_� = v.���_�)
					)
		and v.���_� in (8) --,1
		and pr.USD_CostPrice is null
		and f.RoFactor != 0
order by v.CAS desc;

/********** ������� ����� ��������� ******/ -- 353
/*
-- backup
select pr.*
into dbo._tmp_SetPrice__�������_bak
from dbo._tmp_SetPrice t 
	inner join __�������� v on v.CAS = t.CAS
	inner join dbo.__�������  pr on pr.���_ID_�������� = v.���_ID and pr.���_� = v.���_�
	inner join  dbo._tmp_SetPrice_Factor f on f.Unit = t.Unit and f.UM = pr.UM
	left join dbo._tmp_SetPrice_Ro ro on ro.ID = t.ID
where pr.���_ID = (
					select MAX(pr2.���_ID) 
					from dbo.__�������  pr2
						inner join dbo.__�������� pst2 on pst2.���_ID = pr2.���_ID_��������
					where pr2.���_ID_�������� = v.���_ID 
							and pr2.���_� = v.���_�
							and pst2.���� = (select MAX(pst3.����) 
											from dbo.__�������  pr3
												inner join dbo.__�������� pst3 on pst3.���_ID = pr3.���_ID_��������
											where pr3.���_ID_�������� = v.���_ID 
													and pr3.���_� = v.���_�)
					)
		and v.���_�  = 8
		and pr.USD_CostPrice is null
		and t.ID not in (223,248)
;

*/
go


select pr.���_ID
	, ROUND( t.Price*f.MutiFactor*POWER(isnull(ro.Ro,1),isnull(f.RoFactor,0)), 6)   as NewPriceUp
	, t.*
	, v.���_ID
	, v.���_�
	, v.RusName
	, v.ProdName
	, pr.UM
from dbo._tmp_SetPrice t 
	inner join __�������� v on v.CAS = t.CAS
	inner join dbo.__�������  pr on pr.���_ID_�������� = v.���_ID and pr.���_� = v.���_�
	inner join  dbo._tmp_SetPrice_Factor f on f.Unit = t.Unit and f.UM = pr.UM
	left join dbo._tmp_SetPrice_Ro ro on ro.ID = t.ID
where pr.���_ID = (
					select MAX(pr2.���_ID) 
					from dbo.__�������  pr2
						inner join dbo.__�������� pst2 on pst2.���_ID = pr2.���_ID_��������
					where pr2.���_ID_�������� = v.���_ID 
							and pr2.���_� = v.���_�
							and pst2.���� = (select MAX(pst3.����) 
											from dbo.__�������  pr3
												inner join dbo.__�������� pst3 on pst3.���_ID = pr3.���_ID_��������
											where pr3.���_ID_�������� = v.���_ID 
													and pr3.���_� = v.���_�)
					)
		and v.���_�  = 8
		and pr.USD_CostPrice is null
		--and  t.CAS in ('1313-13-9','5936-14-1','723294-72-2')
		and t.ID not in (223,248)
order by v.CAS desc;


/*
-- update
begin tran

alter table __������� disable trigger TR_UPDATE_Sklad30_�������;

update pr
set USD_CostPrice = ROUND( t.Price*f.MutiFactor*POWER(isnull(ro.Ro,1),isnull(f.RoFactor,0)), 6) 
from dbo._tmp_SetPrice t 
	inner join __�������� v on v.CAS = t.CAS
	inner join dbo.__�������  pr on pr.���_ID_�������� = v.���_ID and pr.���_� = v.���_�
	inner join  dbo._tmp_SetPrice_Factor f on f.Unit = t.Unit and f.UM = pr.UM
	left join dbo._tmp_SetPrice_Ro ro on ro.ID = t.ID
where pr.���_ID = (
					select MAX(pr2.���_ID) 
					from dbo.__�������  pr2
						inner join dbo.__�������� pst2 on pst2.���_ID = pr2.���_ID_��������
					where pr2.���_ID_�������� = v.���_ID 
							and pr2.���_� = v.���_�
							and pst2.���� = (select MAX(pst3.����) 
											from dbo.__�������  pr3
												inner join dbo.__�������� pst3 on pst3.���_ID = pr3.���_ID_��������
											where pr3.���_ID_�������� = v.���_ID 
													and pr3.���_� = v.���_�)
					)
		and v.���_�  = 8
		and pr.USD_CostPrice is null
		and t.ID not in (223,248);
		
alter table __������� enable trigger TR_UPDATE_Sklad30_�������;

commit -- rollback		
*/
