use Chest35;
go

-- select * from dbo.param_for_chest_buff
--select cast(cast('4.00' as decimal)as int);

truncate table dbo.param_for_chest_buff; 
  
INSERT INTO param_for_chest_buff
           ([idnumber]
--           ,[param_smiles]
--           ,[param_chemical_name]
           ,[param_mw]
           ,[param_clogp]
           ,[param_rotbonds]
           ,[param_donor]
           ,[param_acceptor]
           ,[param_tpsa]
           ,[param_fsp3]
           ,[param_rings]
           ,[param_aromrings]
           ,[param_hac]
           ,[param_logbb]
           ,[param_logs]
           ,[param_rating])
 SELECT	idnumber            
--			,cast(param_smiles as varchar(2000)) as param_smiles           
--			,cast(param_chemical_name as nvarchar(2000)) as param_chemical_name           
			,cast(param_mw as decimal(18,2)) as param_tpsa          
			,cast(param_clogp as decimal(18,5)) as param_clogp         
			,cast(cast(param_rotbonds as decimal) as int) as param_rotbonds      
			,cast(cast(param_donor as decimal) as int) as param_donor        
			,cast(cast(param_acceptor as decimal) as int) as param_acceptor     
			,cast(param_tpsa as decimal(18,2)) as param_tpsa          
			,cast(param_fsp3 as decimal(18,2)) as param_fsp3          
			,cast(cast(param_rings as decimal) as int) as param_rings         
			,cast(cast(param_aromrings as decimal) as int) as param_aromrings     
			,cast(cast(param_hac as decimal) as int) as param_hac           
			,cast(param_logbb as decimal(18,5)) as param_logbb         
			,cast(param_logs as decimal(18,5)) as  param_logs         
			,cast(param_rating as decimal(18,2)) as param_rating  
   FROM OPENROWSET(BULK N'M:\Private_sh\Zatkhey Volodymyr\DataParametersForRating\Rating_site_01.txt'
					, FORMATFILE=N'M:\Private_sh\Zatkhey Volodymyr\DataParametersForRating\rating_site.fmt', FIRSTROW = 2 ) AS Document
GO

/*
   FROM OPENROWSET(BULK N'\\serge710\c$\Users\v.zatkhey\Documents\without_param_chest_tbl.txt'
					, FORMATFILE=N'M:\Private_sh\Zatkhey Volodymyr\DataParametersForRating\rating_site_smile.fmt', FIRSTROW = 2 ) AS Document
*/

select top 100 *
from param_for_chest_buff b
--where IDNUMBER in ('F0001-0053','F0001-0069')
;
-- скільки?
select COUNT(*) from dbo.param_for_chest_buff;
select COUNT(*) from dbo.MaterialCalculatedParams;
-- повтори?
select idnumber 
from dbo.param_for_chest_buff
group by idnumber
having count(*)>1
-- чи всі з Materials
select COUNT(*)
from param_for_chest_buff b
	inner join Materials m on m.MatName = b.idnumber
--скільки треба оновити?
select COUNT(*)
from param_for_chest_buff b
	inner join Materials m on m.MatName = b.idnumber
	inner join MaterialCalculatedParams mcp on mcp.MatID = m.MatID;
--скільки треба додати?
select COUNT(*)
from param_for_chest_buff b
	inner join Materials m on m.MatName = b.idnumber
where not exists(select * from MaterialCalculatedParams where MatID = m.MatID);

-- оновлення
begin tran
	UPDATE mcp
	   SET --[Smiles] = <Smiles, varchar(2000),>
		   --,[ChemicalName] = <ChemicalName, nvarchar(2000),>
		  [MW] = b.[param_mw]
		  ,[Acceptor] = b.[param_acceptor]
		  ,[Donor] = b.[param_donor]
		  ,[cLogP] = b.[param_clogp]
		  ,[RotBond] = b.[param_rotbonds]
		  ,[TPSA] = b.[param_tpsa]
		  ,[Fsp3] = b.[param_fsp3]
		  --,[VendorCnt] = <VendorCnt, int,>
		  --,[Yr] = <Yr, int,>
		  ,[Ring] = b.[param_rings]
		  ,[AromRing] = b.[param_aromrings]
		  --,[Benzene] = <Benzene, int,>
		  --,[Amide] = <Amide, int,>
		  ,[LogBB] = b.[param_logbb]
		  ,[cLogS] = b.[param_logs]
		  ,[HAC] = b.[param_hac]
		  ,[Rate] = b.[param_rating]
	from param_for_chest_buff b
		inner join Materials m on m.MatName = b.idnumber
		inner join MaterialCalculatedParams mcp on mcp.MatID = m.MatID;
commit
GO

-- додавання
INSERT INTO MaterialCalculatedParams
           ([MatID]
           ,[Smiles]
           ,[ChemicalName]
           ,[MW]
           ,[Acceptor]
           ,[Donor]
           ,[cLogP]
           ,[RotBond]
           ,[TPSA]
           ,[Fsp3]
--           ,[VendorCnt]
--           ,[Yr]
           ,[Ring]
           ,[AromRing]
--           ,[Benzene]
--           ,[Amide]
           ,[LogBB]
           ,[cLogS]
           ,[HAC]
           ,[Rate])
select     m.MatID
           , b.param_smiles
           , b.param_chemical_name
           , b.[param_mw]
           , b.[param_acceptor]
           , b.[param_donor]
           , b.[param_clogp]
           , b.[param_rotbonds]
           , b.[param_tpsa]
           , b.[param_fsp3]
--           ,<VendorCnt, int,>
--           ,<Yr, int,>
           , b.[param_rings]
           , b.[param_aromrings]
--           ,<Benzene, int,>
--           ,<Amide, int,>
           , b.[param_logbb]
           , b.[param_logs]
           , b.[param_hac]
           , b.[param_rating]
from param_for_chest_buff b
	inner join Materials m on m.MatName = b.idnumber
where not exists(select * from MaterialCalculatedParams where MatID = m.MatID);

GO

--=====================================

-- drop table #tmp_consignation
SELECT	c.idnumber  
into _tmp_consignation          
FROM OPENROWSET(BULK N'M:\Private_sh\Zatkhey Volodymyr\DataParametersForRating\Consignation.txt'
					, FORMATFILE=N'M:\Private_sh\Zatkhey Volodymyr\DataParametersForRating\ID_list.fmt', FIRSTROW = 1 ) AS c

select c.*
from _tmp_consignation c
	inner join Materials m on m.MatName = c.idnumber
where not exists(select * from MaterialCalculatedParams where MatID = m.MatID);

SELECT	c.* 
FROM OPENROWSET(
		BULK       N'M:\Private_sh\Zatkhey Volodymyr\DataParametersForRating\Consignation.txt',
		FORMATFILE=N'M:\Private_sh\Zatkhey Volodymyr\DataParametersForRating\ID_list.xml', 
		FIRSTROW = 1 
			   ) AS c
	inner join Materials m on m.MatName = c.idnumber collate SQL_Ukrainian_CP1251_CI_AS
	left join MaterialCalculatedParams mcp on mcp.MatID = m.MatID
where mcp.MatID is null;

---
-- завантаження PriceCoeff
SELECT	m.MatName, 1.0 as Coeff
FROM OPENROWSET(
		BULK       N'M:\Private_sh\Zatkhey Volodymyr\DataParametersForRating\low_price.csv',
		FORMATFILE=N'M:\Private_sh\Zatkhey Volodymyr\DataParametersForRating\ID_list.xml', 
		FIRSTROW = 1 
			   ) AS c
	inner join Materials m on m.MatName = c.idnumber collate SQL_Ukrainian_CP1251_CI_AS
;

