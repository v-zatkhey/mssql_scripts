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

 SELECT top 1 @my_postavka_code = [���]  
 FROM dbo.[tbl��������]
 WHERE ([�����_����] > 0) 
		AND ([ID] = @myID) 
		AND ([�����_����]>=@mymassa)
		AND ([�����_�������_�����_����������_�������]=1 )
		AND ([���_����������] <> 'EUR') 
		AND ([���_����������] <> 'USA') 
		AND ([���_����������] <> 'JPN')
 ORDER BY [�����_����];

RETURN (@my_postavka_code)
END




GO


