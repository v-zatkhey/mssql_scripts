SELECT	t.Название_типа as [Решение по поставке]
	, COUNT(*) as [Количество]
FROM OPENROWSET(
		BULK       N'C:\Users\v.zatkhey\Documents\SQL Server Management Studio\Projects\CheckLotStatus\LCMS-949cmpds.txt',
		FORMATFILE=N'C:\Users\v.zatkhey\Documents\SQL Server Management Studio\Projects\CheckLotStatus\list.xml', 
		FIRSTROW = 1 
			   ) AS c
	inner join [tblПоставки] p on p.ID = c.idnumber collate SQL_Ukrainian_CP1251_CI_AS
							and p.Код_поставщика = LEFT(c.PostCode,3)collate SQL_Ukrainian_CP1251_CI_AS
							and p.Код_поставки = SUBSTRING(c.PostCode,5, LEN(c.PostCode) - 4) collate SQL_Ukrainian_CP1251_CI_AS
	inner join Типы_решений_по_поставкам t on t.Код = p.Решение_по_поставке 
group by t.Код, t.Название_типа 	
order by t.Код
;


SELECT	c.*
	--, p.Код 
	, t.Название_типа as [Решение по поставке]
FROM OPENROWSET(
		BULK       N'C:\Users\v.zatkhey\Documents\SQL Server Management Studio\Projects\CheckLotStatus\LCMS-949cmpds.txt',
		FORMATFILE=N'C:\Users\v.zatkhey\Documents\SQL Server Management Studio\Projects\CheckLotStatus\list.xml', 
		FIRSTROW = 1 
			   ) AS c
--	inner join Materials m on m.MatName = c.idnumber collate SQL_Ukrainian_CP1251_CI_AS
	inner join [tblПоставки] p on p.ID = c.idnumber collate SQL_Ukrainian_CP1251_CI_AS
							and p.Код_поставщика = LEFT(c.PostCode,3)collate SQL_Ukrainian_CP1251_CI_AS
							and p.Код_поставки = SUBSTRING(c.PostCode,5, LEN(c.PostCode) - 4) collate SQL_Ukrainian_CP1251_CI_AS
	inner join Типы_решений_по_поставкам t on t.Код = p.Решение_по_поставке 
where 	p.Решение_по_поставке != 1
;

