USE [Chest35]
GO

/****** Object:  View [dbo].[������_�������_0]    Script Date: 03/16/2020 11:27:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[������_�������_0]
AS
SELECT     dbo.tbl�������������.���_���������, dbo.tbl�������������.���_������, dbo.tbl�������������.ID, dbo.tbl������.����_�����������_������, 
                      dbo.tbl������.��������_����_������, 
                      CASE WHEN dbo.[tbl�������������].[���_��������] = 's99999' 
                       THEN 
                      	CASE WHEN (dbo.[tbl�������������].[�����_1] > 0) OR (dbo.[tbl�������������].[�����_1] > 0) 
                      		THEN 7 
	                      	ELSE 6 
    	                END 
                       ELSE 
                      	CASE WHEN isnull(dbo.tbl�����_LC.[�����],0) >= (  dbo.[tbl������].[�����_1] 
                      													 + dbo.[tbl������].[�����_2] 
                      													 + dbo.[tbl������].[�����_3] 
                      													 + dbo.[tbl������].[�����_4]
                       													 + dbo.[tbl������].[�����_5] 
                       													 + dbo.[tbl������].[�����_1] 
                       													 + dbo.[tbl������].[�����_2] 
                       													 + dbo.[tbl������].[�����_3] 
                       													 + dbo.[tbl������].[�����_4] 
                       													 + dbo.[tbl������].[�����_5])
                       		THEN 22
                        	ELSE 
                            	CASE WHEN dbo.tbl�����_LC.[�����] > 0
                        			THEN 21
                        			ELSE                        
                        				CASE WHEN [dbo].[fn_present_na_analize](dbo.[tbl�������������].ID) > 0 
                      						THEN 12
        	                    			ELSE 1 
            	                		END
                            	END
                        END 
                       END AS Status
FROM         dbo.tbl������������� 
                LEFT OUTER JOIN  dbo.tbl�����_LC ON dbo.tbl�������������.ID = dbo.tbl�����_LC.ID						-- �� ������� �706 �� �.����'��� ������ tbl����� �� tbl�����_LC
                LEFT OUTER JOIN  dbo.tbl������ ON     dbo.tbl�������������.���_��������� = dbo.tbl������.���_��������� 
												  AND dbo.tbl�������������.���_������ = dbo.tbl������.���_������


GO

