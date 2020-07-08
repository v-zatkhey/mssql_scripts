
SELECT tbl�������������.��������_��������������, tbl_Reactive_compounds.ID, Materials.MatID, Materials.MatName
FROM Materials
		inner join tbl������������� on tbl�������������.ID = Materials.MatName 
		INNER JOIN tbl����� ON Materials.MatName = tbl�����.ID
		LEFT JOIN tbl_Reactive_compounds ON Materials.MatName = tbl_Reactive_compounds.ID
WHERE (tbl�������������.��������_�������������� Is Null 
			Or 
			tbl�������������.��������_�������������� in ('01001','90122')) 
	  AND tbl_Reactive_compounds.ID Is Null
ORDER BY tbl�������������.��������_�������������� DESC;
--485598

SELECT  Materials.MatName, MaterialCalculatedParams.*
FROM Materials  INNER JOIN tbl�������������  ON tbl�������������.ID = Materials.MatName 
	INNER JOIN tbl����� ON Materials.MatName = tbl�����.ID
	INNER JOIN MaterialCalculatedParams ON Materials.MatID = MaterialCalculatedParams.ID
	--LEFT JOIN tbl_Reactive_compounds ON Materials.MatName = tbl_Reactive_compounds.ID
WHERE (tbl�������������.��������_�������������� Is Null 
			Or 
			tbl�������������.��������_�������������� in ('01001','90122')) 
	  AND Not exists(select * 
					 from dbo.tbl������������� l 
						inner join dbo.tblBaseListCondition c on c.BaseListID = l.���_ID and c.ConditionID not IN (6,14) 
					 where l.ID = Materials.MatName)
ORDER BY tbl�������������.��������_�������������� DESC;

select * from dbo.tbl����_�������_�����������

/*
SELECT [ID]
      ,[�������_�����������]
  FROM [Chest35].[dbo].[tbl_Reactive_compounds_add]
GO

exec sp_helptext tbl_Reactive_compounds_add

CREATE VIEW dbo.tbl_Reactive_compounds_add
AS
SELECT     ID, �������_�����������
FROM         dbo.tbl�������������
WHERE     (LEN(RTRIM(LTRIM(�������_�����������))) > 0)
  AND (RTRIM(LTRIM(�������_�����������)) <> '����������� �������')
  AND (RTRIM(LTRIM(�������_�����������)) <> '�������� ��������� ����� �� �������!')
*/