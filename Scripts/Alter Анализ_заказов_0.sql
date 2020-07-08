USE [Chest35]
GO

/****** Object:  View [dbo].[Анализ_Заказов_0]    Script Date: 03/16/2020 11:27:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[Анализ_Заказов_0]
AS
SELECT     dbo.tblСписокЗаказов.Код_заказчика, dbo.tblСписокЗаказов.Код_заказа, dbo.tblСписокЗаказов.ID, dbo.tblЗаказы.Дата_Поступления_заказа, 
                      dbo.tblЗаказы.Конечная_Дата_Заказа, 
                      CASE WHEN dbo.[tblСписокЗаказов].[Код_отправки] = 's99999' 
                       THEN 
                      	CASE WHEN (dbo.[tblСписокЗаказов].[Масса_1] > 0) OR (dbo.[tblСписокЗаказов].[Микро_1] > 0) 
                      		THEN 7 
	                      	ELSE 6 
    	                END 
                       ELSE 
                      	CASE WHEN isnull(dbo.tblСклад_LC.[Масса],0) >= (  dbo.[tblЗаказы].[Масса_1] 
                      													 + dbo.[tblЗаказы].[Масса_2] 
                      													 + dbo.[tblЗаказы].[Масса_3] 
                      													 + dbo.[tblЗаказы].[Масса_4]
                       													 + dbo.[tblЗаказы].[Масса_5] 
                       													 + dbo.[tblЗаказы].[Микро_1] 
                       													 + dbo.[tblЗаказы].[Микро_2] 
                       													 + dbo.[tblЗаказы].[Микро_3] 
                       													 + dbo.[tblЗаказы].[Микро_4] 
                       													 + dbo.[tblЗаказы].[Микро_5])
                       		THEN 22
                        	ELSE 
                            	CASE WHEN dbo.tblСклад_LC.[Масса] > 0
                        			THEN 21
                        			ELSE                        
                        				CASE WHEN [dbo].[fn_present_na_analize](dbo.[tblСписокЗаказов].ID) > 0 
                      						THEN 12
        	                    			ELSE 1 
            	                		END
                            	END
                        END 
                       END AS Status
FROM         dbo.tblСписокЗаказов 
                LEFT OUTER JOIN  dbo.tblСклад_LC ON dbo.tblСписокЗаказов.ID = dbo.tblСклад_LC.ID						-- за заявкою №706 від А.Черв'юка змініено tblСклад на tblСклад_LC
                LEFT OUTER JOIN  dbo.tblЗаказы ON     dbo.tblСписокЗаказов.Код_заказчика = dbo.tblЗаказы.Код_заказчика 
												  AND dbo.tblСписокЗаказов.Код_заказа = dbo.tblЗаказы.Код_заказа


GO

