USE [Chest35]
GO



SELECT     Код, ID, Действие, Код_весовщика, Весовщик, CONVERT(varchar, Date_, 3) AS Дата, CONVERT(varchar, Date_, 8) AS Время, 
                      Date_, Spectra_Block
--into _tmp_История_ввода_delete_bak_20180424                      
FROM         dbo.История_ввода
where ID = 'F3409-1155'

GO


delete from dbo.История_ввода where ID = 'F3409-1155'