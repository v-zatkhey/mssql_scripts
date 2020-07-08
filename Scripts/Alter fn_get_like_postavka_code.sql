USE [Chest35]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_get_like_postavka_code]    Script Date: 06/30/2020 17:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[fn_get_like_postavka_code] (@myID varchar(12), @mymassa float)  
RETURNS int AS  
BEGIN 
DECLARE @my_postavka_code int

 SET @my_postavka_code = null

 SELECT top 1 @my_postavka_code = [Код]  
 FROM dbo.[tblПоставки]
 WHERE ([Масса_пост] > 0) 
		AND ([ID] = @myID) 
		AND ([Масса_пост]>=@mymassa)
		AND ([Склад_принято_после_повторного_спектра]=1 )
		AND ([Код_поставщика] <> 'EUR') 
		AND ([Код_поставщика] <> 'USA') 
		AND ([Код_поставщика] <> 'JPN')
 ORDER BY [Масса_пост];

RETURN (@my_postavka_code)
END




GO


