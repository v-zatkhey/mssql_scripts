USE [Chest35]
GO

/****** Object:  View [dbo].[tbl�������������������1_with_otkr_zakaz]    Script Date: 07/31/2020 16:40:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[tbl�������������������1_with_otkr_zakaz]
AS
SELECT     p.���, p.���_������, p.���������, 
                      p.���_��������, p.�����, p.ID, 
                      p.������, p.����_���, 
                      --p.����_���, 
                      z.��������_����_������_���_����������� as ����_���,
                      p.����_���, p.��������, p.��������_all, 
                      p.��������, p.�����, p.��_��������, 
                      p.������, p.����������, p.A, 
                      p.[������������ ��� �������], ISNULL(z.Opened, 0) AS ����, 
                      --p.����_���_0, 
                      z.��������_����_������_���_�����������_0 as ����_���_0,
                      p.����������, [dbo].[fn_get_CUR_ID](p.ID) as [CUR_ID]
FROM         tbl�������������������1 p WITH (nolock) 
			 LEFT OUTER JOIN tbl������ z WITH (nolock) ON p.����� = z.���_��������� + '-' + z.���_������

GO


