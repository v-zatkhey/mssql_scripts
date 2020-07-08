USE [Chest35]
GO

/****** Object:  View [dbo].[tblСклад_w_Post_n_Excl_new]    Script Date: 07/04/2019 09:02:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[tblСклад_LC_Set]
AS
SELECT ID, 
  CONVERT(decimal(10, 2), SUM(Масса_пост)) AS LC, 
  dbo.fn_get_Ostatok_really_52_decimal(ID,SUM(Масса_пост)) AS LC_Really, 
  COUNT(Код) AS count_post, 
  CONVERT(decimal(10,2),MIN(Масса_пост)) AS min_post,
  CONVERT(decimal(10,2),MAX(Масса_пост)) AS max_post
FROM         dbo.tblПоставки WITH (nolock)
WHERE     (Код_поставщика <> 'USA') AND (Код_поставщика <> 'EUR') AND (Код_поставщика <> 'JPN') AND (Решение_по_поставке = 1) AND 
                      (Склад_принято_после_повторного_спектра = 1) AND (Масса_пост > 0)
GROUP BY ID
HAVING (SUM(Масса_пост) > 0) OR
       (dbo.fn_get_Ostatok_really_52_decimal(ID, SUM(Масса_пост)) > 0)

GO

/**************************************/
USE [Chest35]
GO

/****** Object:  View [dbo].[tblСклад_w_Post_n_Excl_new]    Script Date: 07/04/2019 09:12:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[tblСклад_w_Post_n_Excl_new]
AS
SELECT    dbo.tblБазовыеСписки.ID
		, dbo.tblБазовыеСписки.Вид
		, ISNULL(dbo.tblСклад_LC_Set.LC, 0) AS LC
		, dbo.fn_get_post_po_base_all(dbo.tblБазовыеСписки.ID) AS Post
		, dbo.tblБазовыеСписки.Заказчик_Эксклюзивности
		, dbo.fn_get_all_zakaz_string(dbo.tblБазовыеСписки.ID) AS OtherZakaz
		, dbo.fn_get_dupl_string_w_LC(dbo.tblБазовыеСписки.ID) AS Дубликаты
		, ISNULL(dbo.tblСклад_LC_Set.count_post, 0) AS count_post
		, ISNULL(dbo.tblСклад_LC_Set.min_post, 0) AS min_massa
		, ISNULL(dbo.tblСклад_LC_Set.LC_Really, 0) AS LC_Really
		, (CASE WHEN ((LEN(RTRIM(LTRIM(Условия_взвешивания))) > 0) 
				  AND (RTRIM(LTRIM(Условия_взвешивания)) <> 'Стандартные условия') 
				  AND (RTRIM(LTRIM(Условия_взвешивания)) <> 'Избегать попадания влаги из воздуха!')) 
				THEN CAST(1 AS bit) 
				ELSE CAST(0 AS bit) 
				END) AS Особо_взвешивать
		, (CASE WHEN dbo.tbl_Reactive_compounds.ID IS NULL 
				THEN (CASE WHEN Условия_взвешивания LIKE '%летучее%' THEN CAST(1 AS bit) ELSE CAST(0 AS bit) END)
                ELSE CAST(1 AS bit) 
                END) AS Reactive_compound
        , (CASE WHEN dbo.tbl_Повышенная_цена.ID IS NULL THEN 1 ELSE dbo.tbl_Повышенная_цена.Коэффициент END) AS Повышенная_цена
		, ISNULL(dbo.tblСклад_LC_Set.max_post, 0) AS max_massa
FROM dbo.tblБазовыеСписки WITH (nolock) 
	LEFT OUTER JOIN dbo.tblСклад_LC_Set ON dbo.tblБазовыеСписки.ID = dbo.tblСклад_LC_Set.ID 
	LEFT OUTER JOIN dbo.tbl_Reactive_compounds ON dbo.tblБазовыеСписки.ID = dbo.tbl_Reactive_compounds.ID 
	LEFT OUTER JOIN dbo.tbl_Повышенная_цена ON dbo.tblБазовыеСписки.ID = dbo.tbl_Повышенная_цена.ID

GO


select count(*) from dbo.tblСклад_LC_Set
select count(*) from dbo.tblСклад_LC_Set where min_post<>max_post