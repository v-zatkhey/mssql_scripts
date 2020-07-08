select MAX(LEN(IUPAC_Name)) from dbo.Materials where IUPAC_Name is not null
select COUNT(*) from dbo.Materials where IUPAC_Name is not null

select LEN(IUPAC_Name), COUNT(*) 
from dbo.Materials where IUPAC_Name is not null
group by LEN(IUPAC_Name)
order by LEN(IUPAC_Name)

select AVG(LEN(IUPAC_Name)), COUNT(*), SQRT( VAR(LEN(IUPAC_Name)) )
from dbo.Materials where IUPAC_Name is not null

select LEN(IUPAC_Name), *  from dbo.Materials where LEN(IUPAC_Name)>255 --577

select 100.0 *
(select COUNT(*) from dbo.Materials where IUPAC_Name is not null and LEN(IUPAC_Name)<256)/(select COUNT(*) from dbo.Materials where IUPAC_Name is not null )
-- 99.989949901040

select IUPAC_Name, * 
from dbo.Materials 
where MatName = 'F2147-1694'

---MolWeight

select round(MW_without_Salt,-1) as MW, COUNT(*) as Cnt
	--AVG(MW_without_Salt) as averg, SQRT( VAR(MW_without_Salt)) as Q
from dbo.Materials 
--where IUPAC_Name is not null
group by round(MW_without_Salt,-1)
order by round(MW_without_Salt,-1)

select  m.MatName, MW_without_Salt--	AVG(MW_without_Salt) as averg, SQRT( VAR(MW_without_Salt)) as Q
from dbo.Materials  m
where MW_without_Salt between 79 and 135
order by MW_without_Salt