SELECT	t.��������_���� as [������� �� ��������]
	, COUNT(*) as [����������]
FROM OPENROWSET(
		BULK       N'C:\Users\v.zatkhey\Documents\SQL Server Management Studio\Projects\CheckLotStatus\LCMS-949cmpds.txt',
		FORMATFILE=N'C:\Users\v.zatkhey\Documents\SQL Server Management Studio\Projects\CheckLotStatus\list.xml', 
		FIRSTROW = 1 
			   ) AS c
	inner join [tbl��������] p on p.ID = c.idnumber collate SQL_Ukrainian_CP1251_CI_AS
							and p.���_���������� = LEFT(c.PostCode,3)collate SQL_Ukrainian_CP1251_CI_AS
							and p.���_�������� = SUBSTRING(c.PostCode,5, LEN(c.PostCode) - 4) collate SQL_Ukrainian_CP1251_CI_AS
	inner join ����_�������_��_��������� t on t.��� = p.�������_��_�������� 
group by t.���, t.��������_���� 	
order by t.���
;


SELECT	c.*
	--, p.��� 
	, t.��������_���� as [������� �� ��������]
FROM OPENROWSET(
		BULK       N'C:\Users\v.zatkhey\Documents\SQL Server Management Studio\Projects\CheckLotStatus\LCMS-949cmpds.txt',
		FORMATFILE=N'C:\Users\v.zatkhey\Documents\SQL Server Management Studio\Projects\CheckLotStatus\list.xml', 
		FIRSTROW = 1 
			   ) AS c
--	inner join Materials m on m.MatName = c.idnumber collate SQL_Ukrainian_CP1251_CI_AS
	inner join [tbl��������] p on p.ID = c.idnumber collate SQL_Ukrainian_CP1251_CI_AS
							and p.���_���������� = LEFT(c.PostCode,3)collate SQL_Ukrainian_CP1251_CI_AS
							and p.���_�������� = SUBSTRING(c.PostCode,5, LEN(c.PostCode) - 4) collate SQL_Ukrainian_CP1251_CI_AS
	inner join ����_�������_��_��������� t on t.��� = p.�������_��_�������� 
where 	p.�������_��_�������� != 1
;

