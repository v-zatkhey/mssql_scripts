/****** Сценарий для команды SelectTopNRows среды SSMS  ******/
select * from [Chest35].[dbo].[_tmp_param_for_chest] where [param_clogp] like '%e%' ; 

SELECT [ID]
      ,[MatID]
      ,[Smiles]
      ,[ChemicalName]
      ,[MV]
      ,[Acceptor]
      ,[Donor]
      ,[cLogP]
      ,[RotBond]
      ,[TPSA]
      ,[Fsp3]
      ,[VendorCnt]
      ,[Yr]
      ,[Ring]
      ,[AromRing]
      ,[Benzene]
      ,[Amide]
      ,[LogBB]
      ,[cLogS]
      ,[HAC]
      ,[Rate]
  FROM [Chest35].[dbo].[MaterialCalculatedParams]
GO


truncate table dbo.MaterialCalculatedParams;
insert into MaterialCalculatedParams(
      [MatID]
      ,[Smiles]
      ,[ChemicalName]
      ,[Acceptor]
      ,[Donor]
      ,[cLogP]
      ,[LogBB]
      ,[MV]
      ,[TPSA]
      ,[Fsp3]
      ,[cLogS]
      ,[RotBond]
--      ,[VendorCnt]
--      ,[Yr]
--      ,[Ring]
--      ,[AromRing]
--      ,[Benzene]
--      ,[Amide]
      ,[HAC]
      ,[Rate])
SELECT m.MatID 
      ,t.[param_smiles]
      ,t.[param_chemical_name]
      ,t.[param_acceptor]
      ,t.[param_donor]
      ,cast(convert(float,t.[param_clogp]) as numeric(18,5)) as clogp
      ,cast(convert(float,t.[param_logbb]) as numeric(18,5)) as logbb
      ,cast(convert(float,t.[param_mw]) as numeric(18,2)) as mw
      ,cast(convert(float,t.[param_tpsa]) as numeric(18,2)) as tpsa
      ,cast(convert(float,t.[param_fsp3]) as numeric(18,2)) as  fsp3
      ,cast(convert(float,t.[param_logs]) as numeric(18,5)) as logs
      ,cast(convert(float,t.[param_rotbonds])as int) as rotbonds
      ,case when [param_hac]=''
			then null
			else cast(convert(float,t.[param_hac])as int) 
			end as HAC
      ,cast(convert(float,t.[param_rating]) as numeric(18,2)) as rating
  FROM [Chest35].[dbo].[_tmp_param_for_chest] t
  inner join [Chest35]..Materials m on m.MatName = t.idnumber
  where ([param_hac] like '%.00' or [param_hac] not like '%.%') --and [param_hac]!=''

-- incorrect [param_hac]  
  SELECT t.idnumber --, param_hac
  FROM [Chest35].[dbo].[_tmp_param_for_chest] t
		inner join [Chest35]..Materials m on m.MatName = t.idnumber
  where [param_hac] not like '%.00' 
		and [param_hac] like '%.%' 

select COUNT(*) from _tmp_param_for_chest_year;
--delete from _tmp_param_for_chest_year where IDNUMBER = 'IDNUMBER'

--роки для речовин, яких нема в парамс (?)
select t.* --count(*) 
from dbo._tmp_param_for_chest_year t
	left join Materials m on m.MatName = t.IDNUMBER
	left join dbo.MaterialCalculatedParams mcp on mcp.MatID = m.MatID
where mcp.MatID is null

-- проставляємо рік
select COUNT(*) from MaterialCalculatedParams where Yr is not null;

update mcp
set Yr = t.first_year_post 
from dbo._tmp_param_for_chest_year t
	inner join Materials m on m.MatName = t.IDNUMBER
	inner join dbo.MaterialCalculatedParams mcp on mcp.MatID = m.MatID;
	
select COUNT(*) from MaterialCalculatedParams where Yr is not null;
select cast((select COUNT(*) from MaterialCalculatedParams where Yr is not null) as numeric)*100/(select COUNT(*) from MaterialCalculatedParams);

------- update from D.Samofalova
select COUNT(*) from dbo._tmp_param_RATING_SITE_0120;
SELECT m.MatID
	  ,t.[ID]
      ,t.[MW]
      ,t.[cLogP]
      ,t.[RotB]
      ,t.[Hdon]
      ,t.[Hacc]
      ,t.[TPSA]
      ,t.[Fsp3]
      ,t.[Rings]
      ,t.[AromRings]
      ,t.[LogBB]
      ,t.[cLogS]
      ,t.[Hac]
      ,t.[RATING]
  FROM [Chest35].[dbo].[_tmp_param_RATING_SITE_0120] t
	inner join Materials m on m.MatName = t.ID
  where Not exists(select * from dbo.MaterialCalculatedParams where MatID = m.MatID)
GO

SELECT m.MatID
	  ,t.[ID]
      ,t.[MW] - mcp.MW 
      ,t.[cLogP]- mcp.[cLogP]
      ,t.[RotB]-mcp.RotBond
      ,t.[Hdon]-mcp.Donor
      ,t.[Hacc]-mcp.Acceptor
      ,t.[TPSA]-mcp.TPSA
      ,t.[Fsp3]-mcp.Fsp3
      ,t.[Rings]-mcp.Ring
      ,t.[AromRings]-mcp.AromRing
      ,t.[LogBB]-mcp.LogBB
      ,t.[cLogS]-mcp.cLogS
      ,t.[Hac]-mcp.HAC
      ,t.[RATING]-mcp.Rate
      --, mcp.*
  FROM [Chest35].[dbo].[_tmp_param_RATING_SITE_0120] t
	inner join Materials m on m.MatName = t.ID
	inner join dbo.MaterialCalculatedParams mcp on mcp.MatID = m.MatID
 -- where Not exists(select * from dbo.MaterialCalculatedParams where MatID = m.MatID)
GO

--оновлення за даними Д.Самофалової
update mcp
set		MW = t.[MW]
      ,[cLogP] = t.[cLogP]
      ,RotBond = t.[RotB]
      ,Donor = t.[Hdon]
      ,Acceptor = t.[Hacc]
      ,TPSA = t.[TPSA]
      ,Fsp3 = t.[Fsp3]
      ,Ring = t.[Rings]
      ,AromRing = t.[AromRings]
      ,LogBB = t.[LogBB]
      ,cLogS = t.[cLogS]
      ,HAC = t.[Hac]
      ,Rate = t.[RATING]
  FROM [Chest35].[dbo].[_tmp_param_RATING_SITE_0120] t
	inner join Materials m on m.MatName = t.ID
	inner join dbo.MaterialCalculatedParams mcp on mcp.MatID = m.MatID
GO

-- додавання даних Д.Самофалової
insert into MaterialCalculatedParams           
		   ([MatID]
           ,[MW]
           ,[Acceptor]
           ,[Donor]
           ,[cLogP]
           ,[RotBond]
           ,[TPSA]
           ,[Fsp3]
           ,[Ring]
           ,[AromRing]
           ,[LogBB]
           ,[cLogS]
           ,[HAC]
           ,[Rate])
SELECT m.MatID
      ,t.[MW]
      ,t.[Hacc]
      ,t.[Hdon]
      ,t.[cLogP]
      ,t.[RotB]
      ,t.[TPSA]
      ,t.[Fsp3]
      ,t.[Rings]
      ,t.[AromRings]
      ,t.[LogBB]
      ,t.[cLogS]
      ,t.[Hac]
      ,t.[RATING]
  FROM [Chest35].[dbo].[_tmp_param_RATING_SITE_0120] t
	inner join Materials m on m.MatName = t.ID
  where Not exists(select * from dbo.MaterialCalculatedParams where MatID = m.MatID)
GO
