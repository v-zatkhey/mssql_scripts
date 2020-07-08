SELECT  dbo.tblБазовыеСписки.ID
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
		, ISNULL(dbo.tblСклад_LC_Set.min_post, 0) AS max_massa 
FROM dbo.tblБазовыеСписки WITH (nolock) 
	inner JOIN dbo.tblСклад_LC_Set ON dbo.tblБазовыеСписки.ID = dbo.tblСклад_LC_Set.ID 
	LEFT OUTER JOIN dbo.tbl_Reactive_compounds ON dbo.tblБазовыеСписки.ID = dbo.tbl_Reactive_compounds.ID 
	LEFT OUTER JOIN dbo.tbl_Повышенная_цена ON dbo.tblБазовыеСписки.ID = dbo.tbl_Повышенная_цена.ID
union all
SELECT  dbo.tblБазовыеСписки.ID
		, dbo.tblБазовыеСписки.Вид
		, 0 AS LC
		, dbo.fn_get_post_po_base_all(dbo.tblБазовыеСписки.ID) AS Post
		, dbo.tblБазовыеСписки.Заказчик_Эксклюзивности
		, dbo.fn_get_all_zakaz_string(dbo.tblБазовыеСписки.ID) AS OtherZakaz
		, dbo.fn_get_dupl_string_w_LC(dbo.tblБазовыеСписки.ID) AS Дубликаты
		, 0 AS count_post
		, 0 AS min_massa
		, 0 AS LC_Really
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
	   ,  0 AS max_massa 
FROM dbo.tblБазовыеСписки WITH (nolock) 
	LEFT OUTER JOIN dbo.tbl_Reactive_compounds ON dbo.tblБазовыеСписки.ID = dbo.tbl_Reactive_compounds.ID 
	LEFT OUTER JOIN dbo.tbl_Повышенная_цена ON dbo.tblБазовыеСписки.ID = dbo.tbl_Повышенная_цена.ID
where not exists(select * from dbo.tblСклад_LC_Set where ID = dbo.tblБазовыеСписки.ID)	
	
--where dbo.tblБазовыеСписки.ID = 'F0000-0022'