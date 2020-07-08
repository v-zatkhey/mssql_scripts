USE [Chest35]
GO

/****** Object:  View [dbo].[View_����_�������_������]    Script Date: 03/28/2019 13:38:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[View_����_�������_������]
AS
/*
SELECT     ����, ���_�������_���, ���_�������, �����_�����, 
	dbo.fn_get_present_NO_result(���_�������, �����_�����) as With_NO
FROM         dbo.[tbl������] WITH (nolock)
GROUP BY ����, ���_�������_���, ���_�������, �����_�����
*/
SELECT     ����, ���_�������_���, ���_�������, �����_�����, 
	case when(SUM(case when ��������� = 'NO' then 1 else 0 end)) > 0 then 1 else 0 end as With_NO
FROM         dbo.[tbl������] WITH (nolock)
GROUP BY ����, ���_�������_���, ���_�������, �����_�����
GO


