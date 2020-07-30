--id_list_fixed

SELECT	COUNT(distinct m.MatName)
FROM OPENROWSET(
		BULK       N'M:\Private_sh\Zatkhey Volodymyr\diversity_300K_by_BMS_frequency_ID.TXT',
		FORMATFILE=N'M:\Private_sh\Zatkhey Volodymyr\id_list_fixed.xml', 
		FIRSTROW = 1 
			   ) AS c
	inner join Materials m on m.MatName = c.idnumber collate SQL_Ukrainian_CP1251_CI_AS;

select x.���, COUNT(*) as Cnt, SUM(x.SpecWeight) as CntSpecW
from
(
	SELECT c.IDNUMBER
		, m.���
		, case when exists(	select t.��� 
								from dbo.tbl����_�������_����������� t 
									inner join dbo.tblBaseListCondition blc on blc.ConditionID = t.���
								where blc.BaseListID = m.���_ID and t.NoSpecWeigh = 0)
				then 1
				else 0
				end as SpecWeight
	FROM OPENROWSET(
			BULK       N'M:\Private_sh\Zatkhey Volodymyr\diversity_300K_by_BMS_frequency_ID.TXT',
			FORMATFILE=N'M:\Private_sh\Zatkhey Volodymyr\id_list_fixed.xml', 
			FIRSTROW = 1 
				   ) AS c
		inner join dbo.tbl������������� m on m.ID = c.idnumber collate SQL_Ukrainian_CP1251_CI_AS
) x 
group by x.��� 
;
