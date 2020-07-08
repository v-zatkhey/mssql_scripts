USE [Chest35]
GO

/****** Object:  View [dbo].[View_Блок_Спектра_список]    Script Date: 03/28/2019 13:38:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[View_Блок_Спектра_список]
AS
/*
SELECT     Блок, Тип_спектра_Код, Тип_спектра, Номер_блока, 
	dbo.fn_get_present_NO_result(Тип_спектра, Номер_блока) as With_NO
FROM         dbo.[tblСпектр] WITH (nolock)
GROUP BY Блок, Тип_спектра_Код, Тип_спектра, Номер_блока
*/
SELECT     Блок, Тип_спектра_Код, Тип_спектра, Номер_блока, 
	case when(SUM(case when Результат = 'NO' then 1 else 0 end)) > 0 then 1 else 0 end as With_NO
FROM         dbo.[tblСпектр] WITH (nolock)
GROUP BY Блок, Тип_спектра_Код, Тип_спектра, Номер_блока
GO


