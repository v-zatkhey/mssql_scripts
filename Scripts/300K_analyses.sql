--id_list_fixed

SELECT	COUNT(distinct m.MatName)
FROM OPENROWSET(
		BULK       N'M:\Private_sh\Zatkhey Volodymyr\diversity_300K_by_BMS_frequency_ID.TXT',
		FORMATFILE=N'M:\Private_sh\Zatkhey Volodymyr\id_list_fixed.xml', 
		FIRSTROW = 1 
			   ) AS c
	inner join Materials m on m.MatName = c.idnumber collate SQL_Ukrainian_CP1251_CI_AS;

select x.Вид, COUNT(*) as Cnt, SUM(x.SpecWeight) as CntSpecW
from
(
	SELECT c.IDNUMBER
		, m.Вид
		, case when exists(	select t.Код 
								from dbo.tblТипы_условий_взвешивания t 
									inner join dbo.tblBaseListCondition blc on blc.ConditionID = t.Код
								where blc.BaseListID = m.Код_ID and t.NoSpecWeigh = 0)
				then 1
				else 0
				end as SpecWeight
	FROM OPENROWSET(
			BULK       N'M:\Private_sh\Zatkhey Volodymyr\diversity_300K_by_BMS_frequency_ID.TXT',
			FORMATFILE=N'M:\Private_sh\Zatkhey Volodymyr\id_list_fixed.xml', 
			FIRSTROW = 1 
				   ) AS c
		inner join dbo.tblБазовыеСписки m on m.ID = c.idnumber collate SQL_Ukrainian_CP1251_CI_AS
) x 
group by x.Вид 
;
