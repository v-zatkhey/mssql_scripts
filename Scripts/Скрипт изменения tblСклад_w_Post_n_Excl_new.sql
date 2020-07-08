USE [Chest35]
GO

/****** Object:  View [dbo].[tbl�����_w_Post_n_Excl_new]    Script Date: 07/04/2019 09:02:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[tbl�����_LC_Set]
AS
SELECT ID, 
  CONVERT(decimal(10, 2), SUM(�����_����)) AS LC, 
  dbo.fn_get_Ostatok_really_52_decimal(ID,SUM(�����_����)) AS LC_Really, 
  COUNT(���) AS count_post, 
  CONVERT(decimal(10,2),MIN(�����_����)) AS min_post,
  CONVERT(decimal(10,2),MAX(�����_����)) AS max_post
FROM         dbo.tbl�������� WITH (nolock)
WHERE     (���_���������� <> 'USA') AND (���_���������� <> 'EUR') AND (���_���������� <> 'JPN') AND (�������_��_�������� = 1) AND 
                      (�����_�������_�����_����������_������� = 1) AND (�����_���� > 0)
GROUP BY ID
HAVING (SUM(�����_����) > 0) OR
       (dbo.fn_get_Ostatok_really_52_decimal(ID, SUM(�����_����)) > 0)

GO

/**************************************/
USE [Chest35]
GO

/****** Object:  View [dbo].[tbl�����_w_Post_n_Excl_new]    Script Date: 07/04/2019 09:12:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[tbl�����_w_Post_n_Excl_new]
AS
SELECT    dbo.tbl�������������.ID
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
		, ISNULL(dbo.tbl�����_LC_Set.max_post, 0) AS max_massa
FROM dbo.tbl������������� WITH (nolock) 
	LEFT OUTER JOIN dbo.tbl�����_LC_Set ON dbo.tbl�������������.ID = dbo.tbl�����_LC_Set.ID 
	LEFT OUTER JOIN dbo.tbl_Reactive_compounds ON dbo.tbl�������������.ID = dbo.tbl_Reactive_compounds.ID 
	LEFT OUTER JOIN dbo.tbl_����������_���� ON dbo.tbl�������������.ID = dbo.tbl_����������_����.ID

GO


select count(*) from dbo.tbl�����_LC_Set
select count(*) from dbo.tbl�����_LC_Set where min_post<>max_post