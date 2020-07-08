USE [Chest35]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_get_like_postavka_string]    Script Date: 06/30/2020 17:50:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





ALTER FUNCTION [dbo].[fn_get_like_postavka_string] (@myID varchar(12), @mymassa float)  
RETURNS varchar(255) AS  
BEGIN 
DECLARE @my_other_zakaz varchar(255)

	SET @my_other_zakaz = ''
	IF @myID is null goto lb1

	DECLARE #myCURSOR CURSOR
	FOR
	  SELECT [ID], [Масса_пост], ([Код_поставщика] + '-' + [Код_поставки]) AS [Поставка], [Примечание]
	  FROM dbo.[tblПоставки]
	  WHERE ([Масса_пост] > 0) AND ([ID] = @myID) AND ([Масса_пост]>=@mymassa)
				AND ([Склад_принято_после_повторного_спектра]=1)
                /*AND ([На_повторном_спектре]=0)*/
	  ORDER BY [Масса_пост]
	FOR READ ONLY

	OPEN #myCURSOR

	DECLARE @myID2 varchar(12), @myMassa2 decimal(10), @myPostavka2 varchar(12), @myPrimechanie varchar(50)

	FETCH NEXT FROM #myCURSOR INTO @myID2, @myMassa2, @myPostavka2, @myPrimechanie
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
	  IF @myPostavka2 is not null
	    BEGIN
  	      /* SET @my_other_zakaz = @my_other_zakaz + CONVERT(varchar,@myMassa2) + ' - ' + isnull(@myPostavka2,'null') */
		  SET @my_other_zakaz = @my_other_zakaz + CONVERT(varchar,@myMassa2) + ' - ' + isnull(@myPostavka2,'null') + ' (' + isnull(@myPrimechanie,'') + ')'
	      BREAK	
	    END
	  FETCH NEXT FROM #myCURSOR INTO @myID2, @myMassa2, @myPostavka2, @myPrimechanie
	END
	CLOSE #myCURSOR
	DEALLOCATE #myCURSOR

	lb1:
	IF @my_other_zakaz = '' SET @my_other_zakaz = NULL

RETURN (@my_other_zakaz)
END







GO


