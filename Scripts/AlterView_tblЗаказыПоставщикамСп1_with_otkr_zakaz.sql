USE [Chest35]
GO

/****** Object:  View [dbo].[tblЗаказыПоставщикамСп1_with_otkr_zakaz]    Script Date: 07/31/2020 16:40:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[tblЗаказыПоставщикамСп1_with_otkr_zakaz]
AS
SELECT     p.Код, p.Код_заказа, p.Поставщик, 
                      p.Код_поставки, p.Пачка, p.ID, 
                      p.Статус, p.Дата_отп, 
                      --p.Дата_кон, 
                      z.Конечная_Дата_Заказа_для_Поставщиков as Дата_кон,
                      p.Дата_пол, p.Заказано, p.Заказано_all, 
                      p.Получено, p.Заказ, p.На_поставке, 
                      p.Приход, p.Примечание, p.A, 
                      p.[Растворитель для спектра], ISNULL(z.Opened, 0) AS Откр, 
                      --p.Дата_кон_0, 
                      z.Конечная_Дата_Заказа_для_Поставщиков_0 as Дата_кон_0,
                      p.ЗарпХимику, [dbo].[fn_get_CUR_ID](p.ID) as [CUR_ID]
FROM         tblЗаказыПоставщикамСп1 p WITH (nolock) 
			 LEFT OUTER JOIN tblЗаказы z WITH (nolock) ON p.Заказ = z.Код_заказчика + '-' + z.Код_заказа

GO


