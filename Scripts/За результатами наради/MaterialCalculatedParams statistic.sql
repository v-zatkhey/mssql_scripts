/****** Сценарий для команды SelectTopNRows среды SSMS  ******/
declare @row_count int;
select @row_count = COUNT(*) from [MaterialCalculatedParams]
SELECT COUNT(*) as [RowCount]
	, cast( round(100*cast(count([MatID]) as numeric(12,2))/@row_count,2) as numeric(5,2)) as [MatID_percent]
	, cast( round(100*cast(count([Smiles]) as numeric(12,2))/@row_count,2) as numeric(5,2)) as [Smiles_percent]
	, cast( round(100*cast(count([ChemicalName]) as numeric(12,2))/@row_count,2) as numeric(5,2)) as [ChemicalName_percent]
	, cast( round(100*cast(count([MW]) as numeric(12,2))/@row_count,2) as numeric(5,2)) as [MW_percent]
	, cast( round(100*cast(count([Acceptor]) as numeric(12,2))/@row_count,2) as numeric(5,2)) as [Acceptor_percent]
	, cast( round(100*cast(count([Donor]) as numeric(12,2))/@row_count,2) as numeric(5,2)) as [Donor_percent]
	, cast( round(100*cast(count([cLogP]) as numeric(12,2))/@row_count,2) as numeric(5,2)) as [cLogP_percent]
	, cast( round(100*cast(count([RotBond]) as numeric(12,2))/@row_count,2) as numeric(5,2)) as [RotBond_percent]
	, cast( round(100*cast(count([TPSA]) as numeric(12,2))/@row_count,2) as numeric(5,2)) as [TPSA_percent]
	, cast( round(100*cast(count([Fsp3]) as numeric(12,2))/@row_count,2) as numeric(5,2)) as [Fsp3_percent]
--	, cast( round(100*cast(count([VendorCnt]) as numeric(12,2))/@row_count,2) as numeric(5,2)) as [VendorCnt_percent]
	, cast( round(100*cast(count([Yr]) as numeric(12,2))/@row_count,2) as numeric(5,2)) as [Yr_percent]
	, cast( round(100*cast(count([Ring]) as numeric(12,2))/@row_count,2) as numeric(5,2)) as [Ring_percent]
	, cast( round(100*cast(count([AromRing]) as numeric(12,2))/@row_count,2) as numeric(5,2)) as [AromRing_percent]
--	, cast( round(100*cast(count([Benzene]) as numeric(12,2))/@row_count,2) as numeric(5,2)) as [Benzene_percent]
--	, cast( round(100*cast(count([Amide]) as numeric(12,2))/@row_count,2) as numeric(5,2)) as [Amide_percent]
	, cast( round(100*cast(count([LogBB]) as numeric(12,2))/@row_count,2) as numeric(5,2)) as [LogBB_percent]
	, cast( round(100*cast(count([cLogS]) as numeric(12,2))/@row_count,2) as numeric(5,2)) as [cLogS_percent]
	, cast( round(100*cast(count([HAC]) as numeric(12,2))/@row_count,2) as numeric(5,2)) as [HAC_percent]
	, cast( round(100*cast(count([Rate]) as numeric(12,2))/@row_count,2) as numeric(5,2)) as [Rate_percent]
  FROM [MaterialCalculatedParams] m;
  go
  
  select COUNT(*) from [MaterialCalculatedParams];
  go
  
/***************************************************/
SELECT COUNT(*) as [RowCount]
	, cast( round(100*cast(count([MatID]) as numeric(12,2))/COUNT(*),2) as numeric(5,2)) as [MatID_percent]
	, cast( round(100*cast(count([Smiles]) as numeric(12,2))/COUNT(*),2) as numeric(5,2)) as [Smiles_percent]
	, cast( round(100*cast(count([ChemicalName]) as numeric(12,2))/COUNT(*),2) as numeric(5,2)) as [ChemicalName_percent]
	, cast( round(100*cast(count([MW]) as numeric(12,2))/COUNT(*),2) as numeric(5,2)) as [MW_percent]
	, cast( round(100*cast(count([Acceptor]) as numeric(12,2))/COUNT(*),2) as numeric(5,2)) as [Acceptor_percent]
	, cast( round(100*cast(count([Donor]) as numeric(12,2))/COUNT(*),2) as numeric(5,2)) as [Donor_percent]
	, cast( round(100*cast(count([cLogP]) as numeric(12,2))/COUNT(*),2) as numeric(5,2)) as [cLogP_percent]
	, cast( round(100*cast(count([RotBond]) as numeric(12,2))/COUNT(*),2) as numeric(5,2)) as [RotBond_percent]
	, cast( round(100*cast(count([TPSA]) as numeric(12,2))/COUNT(*),2) as numeric(5,2)) as [TPSA_percent]
	, cast( round(100*cast(count([Fsp3]) as numeric(12,2))/COUNT(*),2) as numeric(5,2)) as [Fsp3_percent]
	, cast( round(100*cast(count([Yr]) as numeric(12,2))/COUNT(*),2) as numeric(5,2)) as [Yr_percent]
	, cast( round(100*cast(count([Ring]) as numeric(12,2))/COUNT(*),2) as numeric(5,2)) as [Ring_percent]
	, cast( round(100*cast(count([AromRing]) as numeric(12,2))/COUNT(*),2) as numeric(5,2)) as [AromRing_percent]
	, cast( round(100*cast(count([LogBB]) as numeric(12,2))/COUNT(*),2) as numeric(5,2)) as [LogBB_percent]
	, cast( round(100*cast(count([cLogS]) as numeric(12,2))/COUNT(*),2) as numeric(5,2)) as [cLogS_percent]
	, cast( round(100*cast(count([HAC]) as numeric(12,2))/COUNT(*),2) as numeric(5,2)) as [HAC_percent]
	, cast( round(100*cast(count([Rate]) as numeric(12,2))/COUNT(*),2) as numeric(5,2)) as [Rate_percent]
  FROM [MaterialCalculatedParams] m;