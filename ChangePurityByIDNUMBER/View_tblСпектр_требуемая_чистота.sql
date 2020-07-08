USE [Chest35]
GO

/****** Object:  View [dbo].[tblСпектр_требуемая_чистота]    Script Date: 01/22/2019 13:01:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

alter VIEW [dbo].[tblСпектр_требуемая_чистота]
AS
SELECT     dbo.tblСпектр.Код, dbo.tblСпектр.ID, dbo.tblСпектр.Результат, dbo.tblСпектр.Блок, dbo.tblСпектр.Дата, dbo.tblСпектр.Код_поставщика, 
                      dbo.tblСпектр.Код_поставки, dbo.tblСпектр.Примечание, dbo.tblСпектр.Дата_спектра, dbo.tblСпектр.[Растворитель для спектра], 
                      dbo.tblСпектр.Повторный, dbo.tblСпектр.Код_tblПоставки_rev, dbo.tblСпектр.[Причина повторного спектра], 
                      dbo.tblСпектр.[Процентное содержание], dbo.tblСпектр.Метод_LCMS, dbo.tblСпектр.Навеска, dbo.tblСпектр.Molweight, dbo.tblСпектр.Mikromoli, 
                      dbo.tblЗаказы_чистота.Требования_по_чистоте, dbo.tblЗаказы_чистота.Требования_по_чистоте_2, dbo.fn_is_Tamozhnya(dbo.tblСпектр.ID) 
                      AS Таможня, dbo.tblСпектр.Комментарии,
                      dbo.[fn_Get_Last_NMR_by_Kod_tblПоставки] (dbo.tblСпектр.Код_tblПоставки_rev) as NMR_Last,
                      dbo.[fn_Get_Last_LCMS_by_Kod_tblПоставки] (dbo.tblСпектр.Код_tblПоставки_rev) as LCMS_Last,
                      dbo.tblСпектр.S30_Код_с,
                      dbo.tblПоставки.Решение_по_поставке,
                      case when dbo.tblЗаказы_чистота.Требования_по_чистоте IS null   -- добавлено для автоматического проставления решений по спектрам
						then case when  dbo.tblПоставки.Масса < 250 then null else '95' end
						else dbo.tblЗаказы_чистота.Требования_по_чистоте
						end as Требования_по_чистоте_3,
					  case when dbo.tblЗаказы_чистота.Требования_по_чистоте IS null and  dbo.tblПоставки.Масса >= 250
						then 1
						else 0
						end as RrequiredPurityByMass
FROM         dbo.tblЗаказы_чистота RIGHT OUTER JOIN
                      dbo.tblПоставки ON dbo.tblЗаказы_чистота.Заказ = dbo.tblПоставки.Примечание RIGHT OUTER JOIN
                      dbo.tblСпектр ON dbo.tblПоставки.Код_поставки = dbo.tblСпектр.Код_поставки AND 
                      dbo.tblПоставки.Код_поставщика = dbo.tblСпектр.Код_поставщика AND dbo.tblПоставки.ID = dbo.tblСпектр.ID
GROUP BY dbo.tblСпектр.Код, dbo.tblСпектр.ID, dbo.tblСпектр.Результат, dbo.tblСпектр.Блок, dbo.tblСпектр.Дата, dbo.tblСпектр.Код_поставщика, 
                      dbo.tblСпектр.Код_поставки, dbo.tblСпектр.Примечание, dbo.tblСпектр.Дата_спектра, dbo.tblСпектр.[Растворитель для спектра], 
                      dbo.tblСпектр.Код_tblПоставки_rev, dbo.tblСпектр.[Причина повторного спектра], dbo.tblСпектр.[Процентное содержание], 
                      dbo.tblСпектр.Метод_LCMS, dbo.tblСпектр.Навеска, dbo.tblСпектр.Molweight, dbo.tblСпектр.Mikromoli, 
                      dbo.tblЗаказы_чистота.Требования_по_чистоте, dbo.tblЗаказы_чистота.Требования_по_чистоте_2, dbo.tblСпектр.Повторный, 
                      dbo.tblСпектр.Комментарии, dbo.tblСпектр.S30_Код_с, dbo.tblПоставки.Решение_по_поставке, dbo.tblПоставки.Масса

GO



/*
select distinct [tblСпектр_требуемая_чистота].Требования_по_чистоте , RrequiredPurityByMass , COUNT(*)
from [tblСпектр_требуемая_чистота]
where Требования_по_чистоте_3 = '95'
group by [tblСпектр_требуемая_чистота].Требования_по_чистоте , RrequiredPurityByMass 
*/