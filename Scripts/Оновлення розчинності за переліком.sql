-- M:\Private_sh\Zatkhey Volodymyr\UndissolvedCompaunds
SELECT	c.* 
FROM OPENROWSET(
		BULK       N'M:\Private_sh\Zatkhey Volodymyr\UndissolvedCompaunds\UndisolvedMarch2020.txt',
		FORMATFILE=N'M:\Private_sh\Zatkhey Volodymyr\UndissolvedCompaunds\ID_list.xml', 
		FIRSTROW = 1 
			   ) AS c;
			   
SELECT	c.*, m.PBS, m.Solubility_DMSO, t.���_������������� 
-- UPDATE m SET Solubility_DMSO = 9
FROM OPENROWSET(
		BULK       N'M:\Private_sh\Zatkhey Volodymyr\UndissolvedCompaunds\UndisolvedMarch2020.txt',
		FORMATFILE=N'M:\Private_sh\Zatkhey Volodymyr\UndissolvedCompaunds\ID_list.xml', 
		FIRSTROW = 1 
			   ) AS c
	inner join Materials m on m.MatName = c.idnumber collate SQL_Ukrainian_CP1251_CI_AS
	left join ����_�������������_�_DMSO t on t.��� = m.Solubility_DMSO
where m.Solubility_DMSO is null	
;			   

SELECT	c.*, m.PBS, m.Solubility_DMSO, t.���_������������� 
FROM OPENROWSET(
		BULK       N'M:\Private_sh\Zatkhey Volodymyr\UndissolvedCompaunds\FulList_Unsoluble-10mM-DMSO_mar2020.txt',
		FORMATFILE=N'M:\Private_sh\Zatkhey Volodymyr\UndissolvedCompaunds\ID_list.xml', 
		FIRSTROW = 1 
			   ) AS c
	inner join Materials m on m.MatName = c.idnumber collate SQL_Ukrainian_CP1251_CI_AS
	left join ����_�������������_�_DMSO t on t.��� = m.Solubility_DMSO
where m.Solubility_DMSO != 9 	
;

SELECT	c.*, m.PBS, m.Solubility_DMSO, t.���_������������� 
-- UPDATE m SET Solubility_DMSO = 9
FROM OPENROWSET(
		BULK       N'M:\Private_sh\Zatkhey Volodymyr\UndissolvedCompaunds\FulList_Unsoluble-10mM-DMSO_mar2020.txt',
		FORMATFILE=N'M:\Private_sh\Zatkhey Volodymyr\UndissolvedCompaunds\ID_list.xml', 
		FIRSTROW = 1 
			   ) AS c
	inner join Materials m on m.MatName = c.idnumber collate SQL_Ukrainian_CP1251_CI_AS
	left join ����_�������������_�_DMSO t on t.��� = m.Solubility_DMSO
where m.Solubility_DMSO != 9 and m.PBS = 0	
