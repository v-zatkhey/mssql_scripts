/****** Сценарий для команды SelectTopNRows среды SSMS  ******/
SELECT COUNT(*)
  FROM [Chest35].[dbo].[_tmp_Price_coeff] t
  --where exists(select * from dbo.tbl_Повышенная_цена where ID = t.ID)
  ;
 
 SELECT COUNT(*)
  FROM  dbo.tbl_Повышенная_цена p
	inner join [Chest35].[dbo].[_tmp_Price_coeff] t on t.ID = p.ID;
  
 insert into  tbl_Повышенная_цена(ID, Коэффициент)
 select t.[ID], 1.5
--  select [ID], [Koeff]
 from [_tmp_Price_coeff] t
 where not exists(select * from dbo.tbl_Повышенная_цена where ID = t.ID);
  
 SELECT  COUNT(*)
  FROM  dbo.tbl_Повышенная_цена p
	inner join [Chest35].[dbo].[_tmp_Price_coeff] t on t.ID = p.ID;
  
  /********* на F3395-1646 поставить PriceCoef=10.0.***********/
   
 SELECT *
  FROM  dbo.tbl_Повышенная_цена p
  WHERE p.ID = 'F3395-1646';
  
 if not exists(SELECT * FROM dbo.tbl_Повышенная_цена p WHERE p.ID = 'F3395-1646') 
  insert into  tbl_Повышенная_цена(ID, Коэффициент)
  values('F3395-1646',10.0);
  
     
 SELECT *
  FROM  dbo.tbl_Повышенная_цена p
  WHERE p.ID = 'F3395-1646';
  
  /********* відмітка що речовину обраховано  *****************/
select p.Коэффициент, COUNT(*) as cnt
from dbo.tbl_Повышенная_цена p 
group by p.Коэффициент;
  
select p.Коэффициент, COUNT(*) as cnt
from [_tmp_Price_coeff]  t
	inner join dbo.tbl_Повышенная_цена p on p.ID = t.ID
group by p.Коэффициент;
  
 insert into  tbl_Повышенная_цена(ID, Коэффициент)
 select distinct t.ID, 1.0
--  select distinct [ID]
 from [_tmp_Price_coeff]  t
 where not exists(select * from dbo.tbl_Повышенная_цена where ID = t.ID); -- rollback
 
 /********17.02.2020***********/
 --1.5  F6754-6978
 /*
  if not exists(SELECT * FROM dbo.tbl_Повышенная_цена p WHERE p.ID = 'F6754-6978') 
  insert into  tbl_Повышенная_цена(ID, Коэффициент)
  values('F6754-6978',1.5);
  */
 select p.Коэффициент, COUNT(*) as cnt
 from [_tmp_Price_coeff]  t 
	left join  dbo.tbl_Повышенная_цена p on p.ID = t.[ID]
 group by p.Коэффициент; -- rollback
 
 insert into  tbl_Повышенная_цена(ID, Коэффициент)
 select distinct t.ID, 1.0
--  select distinct [ID]
 from [_tmp_Price_coeff]  t
 where not exists(select * from dbo.tbl_Повышенная_цена where ID = t.ID); -- rollback
 
 /****************** 16.03.2020 *******************/
 select * 
 into tbl_Повышенная_цена_back_20200316
 from tbl_Повышенная_цена;
 
 begin tran
 --insert into  tbl_Повышенная_цена(ID, Коэффициент)
 select distinct t.ID, 1.5
--  select distinct [ID]
 from tblВыполненныеЗаказы  t
 where t.Код_заказчика in ('10050', '30050')
	and not exists(select * from dbo.tbl_Повышенная_цена where ID = t.ID); -- rollback
	
 --insert into  tbl_Повышенная_цена(ID, Коэффициент)
 select distinct t.ID, 1.5
--  select distinct [ID]
 from tblСписокЗаказов  t
 where t.Код_заказчика in ('10050', '30050')
	and not exists(select * from dbo.tbl_Повышенная_цена where ID = t.ID); -- rollback
	
--insert into  tbl_Повышенная_цена(ID, Коэффициент)
 select distinct t.ID, 1.0
--  select distinct [ID]
 from tblВыполненныеЗаказы  t
 where t.Код_заказчика = '00050'
	and not exists(select * from dbo.tbl_Повышенная_цена where ID = t.ID); -- rollback
	
 --insert into  tbl_Повышенная_цена(ID, Коэффициент)
 select distinct t.ID, 1.0
--  select distinct [ID]
 from tblСписокЗаказов  t
 where t.Код_заказчика = '00050'
	and not exists(select * from dbo.tbl_Повышенная_цена where ID = t.ID); -- rollback
	
commit

-- завантаження PriceCoeff з файла
-- insert into  tbl_Повышенная_цена(ID, Коэффициент)
SELECT	m.MatName, 1.0 as Coeff
FROM OPENROWSET(
		BULK       N'M:\Private_sh\Zatkhey Volodymyr\DataParametersForRating\low_price.csv',
		FORMATFILE=N'M:\Private_sh\Zatkhey Volodymyr\DataParametersForRating\ID_list.xml', 
		FIRSTROW = 1 
			   ) AS c
	inner join Materials m on m.MatName = c.idnumber collate SQL_Ukrainian_CP1251_CI_AS
where not exists(select * from dbo.tbl_Повышенная_цена where ID = m.MatName); -- rollback
go

/************ прописування за переліком **************/
--\\serge710\c$\Users\v.zatkhey\Documents\z01124-excl-88cmpds_set_coeff_2_0.txt
--\\serge710\c$\Users\v.zatkhey\Documents\PriceCoef_1_5.txt
declare @coeff float = 1.0;

-- для оновлення розблокувати
begin tran

	--update p set [Коэффициент] = @coeff
	SELECT	m.MatName, @coeff as Coeff, p.[Коэффициент]
	FROM OPENROWSET(
			BULK       N'M:\Group_Sh\Calculated_Params_for_ComputationalChemistryLAB\In\low_price.csv',
			FORMATFILE=N'M:\Group_Sh\Calculated_Params_for_ComputationalChemistryLAB\Script\ID_list.xml', 
			FIRSTROW = 1 
				   ) AS c
		inner join Materials m on m.MatName = c.idnumber collate SQL_Ukrainian_CP1251_CI_AS
		inner join tbl_Повышенная_цена p on p.ID = m.MatName
	WHERE isnull(p.Коэффициент,0) <> @coeff; -- rollback

	--insert into  tbl_Повышенная_цена(ID, Коэффициент)
	SELECT	m.MatName, @coeff as Coeff
	FROM OPENROWSET(
			BULK       N'M:\Group_Sh\Calculated_Params_for_ComputationalChemistryLAB\In\low_price.csv',
			FORMATFILE=N'M:\Group_Sh\Calculated_Params_for_ComputationalChemistryLAB\Script\ID_list.xml', 
			FIRSTROW = 1 
				   ) AS c
		inner join Materials m on m.MatName = c.idnumber collate SQL_Ukrainian_CP1251_CI_AS
	where not exists(select * from dbo.tbl_Повышенная_цена where ID = m.MatName); -- rollback
	
commit;

go

/*
Привет, Володя,
Поставь, пожалуйста, PriceCoef=1.5 на F2417-0253 и F5534-0058 -- это был дорогой синтез.

Привет, Володя,
Поставь, пожалуйста, PriceCoef=1.5 на F6170-0452 -- это был дорогой синтез.

*/
 use Chest35;
 go
 
  SELECT *
  FROM  dbo.tbl_Повышенная_цена p
  WHERE p.ID in( 'F2417-0253', 'F5534-0058');
 /*
  declare @coeff float = 1.5; 
  update  tbl_Повышенная_цена
  set Коэффициент = @coeff
  where ID in( 'F2417-0253', 'F5534-0058');
 */    
  SELECT *
  FROM  dbo.tbl_Повышенная_цена p
  WHERE p.ID in( 'F2417-0253', 'F5534-0058');
  go
  -------------
  SELECT *
  FROM  dbo.tbl_Повышенная_цена p
  WHERE p.ID in( 'F6170-0452');
 
  declare @coeff float = 1.5; 
  if not exists(SELECT * FROM dbo.tbl_Повышенная_цена p WHERE p.ID = 'F6170-0452') 
  insert into  tbl_Повышенная_цена(ID, Коэффициент) values('F6170-0452', @coeff);
     
  SELECT *
  FROM  dbo.tbl_Повышенная_цена p
  --WHERE p.ID in( 'F6170-0452')
  order by Kod desc
  ;
  go
  
  /*
	Привет, да, поставь коэффициент 6 для F2417-0253 и 4 для F5534-0058.
	Спасибо,
	ВП
  */
 /* 
    update  tbl_Повышенная_цена
  set Коэффициент = 6
  where ID = 'F2417-0253';
  
    update  tbl_Повышенная_цена
  set Коэффициент = 4
  where ID = 'F5534-0058';
  */
  select top 100 * from tblСписокЗаказов s 
  where s.Код_заказчика like '_0050'
  order by Код_ID desc;
  
  SELECT top 100 *
  FROM  dbo.tbl_Повышенная_цена p
  --WHERE p.ID in( 'F6170-0452')
  order by Kod desc
  ;
  ----------------------------------
  -- з CalculatedParams
  ----------------------------------
  -- завантаження PriceCoeff з файла
--insert into  tbl_Повышенная_цена(ID, Коэффициент)
SELECT	m.MatName, 1.0 as Coeff
FROM OPENROWSET(
		BULK       N'M:\Group_Sh\Calculated_Params_for_ComputationalChemistryLAB\In\low_price.csv',
		FORMATFILE=N'M:\Group_Sh\Calculated_Params_for_ComputationalChemistryLAB\Script\ID_list.xml', 
		FIRSTROW = 1 
			   ) AS c
	inner join Materials m on m.MatName = c.idnumber collate SQL_Ukrainian_CP1251_CI_AS
where not exists(select * from dbo.tbl_Повышенная_цена where ID = m.MatName); -- rollback
go

  /********* на F9995-4365 поставить PriceCoef=6.0.***********/
 -- A.Chervyuk 28.07.2020  
 
  SELECT *
  FROM  dbo.tbl_Повышенная_цена p
  WHERE p.ID = 'F9995-4365'; -- 1.0
  
  --update dbo.tbl_Повышенная_цена set Коэффициент = 6.0 WHERE ID = 'F9995-4365';
     
 SELECT *
  FROM  dbo.tbl_Повышенная_цена p
  WHERE p.ID = 'F9995-4365';