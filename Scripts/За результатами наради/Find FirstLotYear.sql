SELECT m.MatName, Year(min(p.����_����)) as FirstLotYear
FROM OPENROWSET(BULK N'M:\Private_sh\Zatkhey Volodymyr\DataParametersForRating\without_parametrs1_no_quotes.tsv'
					, FORMATFILE=N'M:\Private_sh\Zatkhey Volodymyr\DataParametersForRating\ID_list.xml', FIRSTROW = 1 ) AS c
	inner join Materials m on m.MatName = c.idnumber collate SQL_Ukrainian_CP1251_CI_AS
	inner join tbl�������� p on p.ID = m.MatName
GROUP BY m.MatName
