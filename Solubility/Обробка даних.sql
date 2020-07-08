--SELECT [IDNUMBER],[DMSO_200mM] FROM [Chest35].[dbo].[_tmp_Solubility_Km]
--GO

SELECT COUNT(*)FROM [Chest35].[dbo].[_tmp_Solubility_Km]
GO

SELECT [IDNUMBER], COUNT(*)
FROM [Chest35].[dbo].[_tmp_Solubility_Km]
group by [IDNUMBER]
having COUNT(*) > 1
GO

select [DMSO_200mM], COUNT(*) FROM [Chest35].[dbo].[_tmp_Solubility_Km]group by [DMSO_200mM]

SELECT *
FROM [Chest35].[dbo].[_tmp_Solubility_Km] where [IDNUMBER] in (
	SELECT [IDNUMBER]
	FROM [Chest35].[dbo].[_tmp_Solubility_Km]
	--where DMSO_200mM = '+'
	group by [IDNUMBER]
	having COUNT(*) > 1
	)
order by 1	;

--delete from [Chest35].[dbo].[_tmp_Solubility_Km]where [IDNUMBER]=''
GO

select m.MatID, m.MatName, m.Solubility_DMSO, m.Solubility_DMSO_Km,  x.DMSO_200mM
from Materials m
	inner join 
	(SELECT [IDNUMBER], DMSO_200mM
	FROM [Chest35].[dbo].[_tmp_Solubility_Km]
	where DMSO_200mM = '+'
	group by [IDNUMBER], DMSO_200mM
	) x on x.[IDNUMBER] =  m.MatName
--where m.Solubility_DMSO_Km is null	
order by m.MatName

select m.MatID, m.MatName, m.Solubility_DMSO, m.Solubility_DMSO_Km,  x.DMSO_200mM
from Materials m
	inner join [Chest35].[dbo].[_tmp_Solubility_Km]  x on x.[IDNUMBER] =  m.MatName
where m.Solubility_DMSO_Km is null	and x.DMSO_200mM = '+'
order by m.MatName

/*
update m set Solubility_DMSO_Km = 4
--select * 
from Materials m
	inner join 
	(SELECT [IDNUMBER], DMSO_200mM
	FROM [Chest35].[dbo].[_tmp_Solubility_Km]
	where DMSO_200mM = '+'
	group by [IDNUMBER], DMSO_200mM
	) x on x.[IDNUMBER] =  m.MatName
where m.Solubility_DMSO_Km is null	
*/
select * from dbo.Типы_растворимости_в_DMSO

select m.MatName, t.Тип_растворимости as Solubility_DMSO_Tm, t2.Тип_растворимости as Solubility_DMSO_Km
from Materials m
	inner join dbo.Типы_растворимости_в_DMSO t on t.Код = m.Solubility_DMSO
	inner join dbo.Типы_растворимости_в_DMSO t2 on t2.Код = m.Solubility_DMSO_Km
where m.Solubility_DMSO_Km = 4
	and m.Solubility_DMSO in (2,3)	
order by m.MatName

select m.MatName--, t.Тип_растворимости as Solubility_DMSO_Tm, t2.Тип_растворимости as Solubility_DMSO_Km
from Materials m
	--inner join dbo.Типы_растворимости_в_DMSO t on t.Код = m.Solubility_DMSO
	--inner join dbo.Типы_растворимости_в_DMSO t2 on t2.Код = m.Solubility_DMSO_Km
where m.Solubility_DMSO_Km is null
	and m.Solubility_DMSO = 3