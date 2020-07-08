SELECT  dbo.tbl�������������.ID
		, dbo.tbl�������������.���
		, ISNULL(dbo.tbl�����_LC_Set.LC, 0) AS LC
		, dbo.fn_get_post_po_base_all(dbo.tbl�������������.ID) AS Post
		, dbo.tbl�������������.��������_��������������
		, dbo.fn_get_all_zakaz_string(dbo.tbl�������������.ID) AS OtherZakaz
		, dbo.fn_get_dupl_string_w_LC(dbo.tbl�������������.ID) AS ���������
		, ISNULL(dbo.tbl�����_LC_Set.count_post, 0) AS count_post
		, ISNULL(dbo.tbl�����_LC_Set.min_post, 0) AS min_massa
		, ISNULL(dbo.tbl�����_LC_Set.LC_Really, 0) AS LC_Really
		, (CASE WHEN ((LEN(RTRIM(LTRIM(�������_�����������))) > 0) 
				  AND (RTRIM(LTRIM(�������_�����������)) <> '����������� �������') 
				  AND (RTRIM(LTRIM(�������_�����������)) <> '�������� ��������� ����� �� �������!')) 
				THEN CAST(1 AS bit) 
				ELSE CAST(0 AS bit) 
				END) AS �����_����������
		, (CASE WHEN dbo.tbl_Reactive_compounds.ID IS NULL 
				THEN (CASE WHEN �������_����������� LIKE '%�������%' THEN CAST(1 AS bit) ELSE CAST(0 AS bit) END)
                ELSE CAST(1 AS bit) 
                END) AS Reactive_compound
       , (CASE WHEN dbo.tbl_����������_����.ID IS NULL THEN 1 ELSE dbo.tbl_����������_����.����������� END) AS ����������_����
		, ISNULL(dbo.tbl�����_LC_Set.min_post, 0) AS max_massa 
FROM dbo.tbl������������� WITH (nolock) 
	inner JOIN dbo.tbl�����_LC_Set ON dbo.tbl�������������.ID = dbo.tbl�����_LC_Set.ID 
	LEFT OUTER JOIN dbo.tbl_Reactive_compounds ON dbo.tbl�������������.ID = dbo.tbl_Reactive_compounds.ID 
	LEFT OUTER JOIN dbo.tbl_����������_���� ON dbo.tbl�������������.ID = dbo.tbl_����������_����.ID
union all
SELECT  dbo.tbl�������������.ID
		, dbo.tbl�������������.���
		, 0 AS LC
		, dbo.fn_get_post_po_base_all(dbo.tbl�������������.ID) AS Post
		, dbo.tbl�������������.��������_��������������
		, dbo.fn_get_all_zakaz_string(dbo.tbl�������������.ID) AS OtherZakaz
		, dbo.fn_get_dupl_string_w_LC(dbo.tbl�������������.ID) AS ���������
		, 0 AS count_post
		, 0 AS min_massa
		, 0 AS LC_Really
		, (CASE WHEN ((LEN(RTRIM(LTRIM(�������_�����������))) > 0) 
				  AND (RTRIM(LTRIM(�������_�����������)) <> '����������� �������') 
				  AND (RTRIM(LTRIM(�������_�����������)) <> '�������� ��������� ����� �� �������!')) 
				THEN CAST(1 AS bit) 
				ELSE CAST(0 AS bit) 
				END) AS �����_����������
		, (CASE WHEN dbo.tbl_Reactive_compounds.ID IS NULL 
				THEN (CASE WHEN �������_����������� LIKE '%�������%' THEN CAST(1 AS bit) ELSE CAST(0 AS bit) END)
                ELSE CAST(1 AS bit) 
                END) AS Reactive_compound
       , (CASE WHEN dbo.tbl_����������_����.ID IS NULL THEN 1 ELSE dbo.tbl_����������_����.����������� END) AS ����������_����
	   ,  0 AS max_massa 
FROM dbo.tbl������������� WITH (nolock) 
	LEFT OUTER JOIN dbo.tbl_Reactive_compounds ON dbo.tbl�������������.ID = dbo.tbl_Reactive_compounds.ID 
	LEFT OUTER JOIN dbo.tbl_����������_���� ON dbo.tbl�������������.ID = dbo.tbl_����������_����.ID
where not exists(select * from dbo.tbl�����_LC_Set where ID = dbo.tbl�������������.ID)	
	
--where dbo.tbl�������������.ID = 'F0000-0022'