USE [Chest35]
GO

/****** Object:  View [dbo].[tbl������_���������_�������]    Script Date: 01/22/2019 13:01:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

alter VIEW [dbo].[tbl������_���������_�������]
AS
SELECT     dbo.tbl������.���, dbo.tbl������.ID, dbo.tbl������.���������, dbo.tbl������.����, dbo.tbl������.����, dbo.tbl������.���_����������, 
                      dbo.tbl������.���_��������, dbo.tbl������.����������, dbo.tbl������.����_�������, dbo.tbl������.[������������ ��� �������], 
                      dbo.tbl������.���������, dbo.tbl������.���_tbl��������_rev, dbo.tbl������.[������� ���������� �������], 
                      dbo.tbl������.[���������� ����������], dbo.tbl������.�����_LCMS, dbo.tbl������.�������, dbo.tbl������.Molweight, dbo.tbl������.Mikromoli, 
                      dbo.tbl������_�������.����������_��_�������, dbo.tbl������_�������.����������_��_�������_2, dbo.fn_is_Tamozhnya(dbo.tbl������.ID) 
                      AS �������, dbo.tbl������.�����������,
                      dbo.[fn_Get_Last_NMR_by_Kod_tbl��������] (dbo.tbl������.���_tbl��������_rev) as NMR_Last,
                      dbo.[fn_Get_Last_LCMS_by_Kod_tbl��������] (dbo.tbl������.���_tbl��������_rev) as LCMS_Last,
                      dbo.tbl������.S30_���_�,
                      dbo.tbl��������.�������_��_��������,
                      case when dbo.tbl������_�������.����������_��_������� IS null   -- ��������� ��� ��������������� ������������ ������� �� ��������
						then case when  dbo.tbl��������.����� < 250 then null else '95' end
						else dbo.tbl������_�������.����������_��_�������
						end as ����������_��_�������_3,
					  case when dbo.tbl������_�������.����������_��_������� IS null and  dbo.tbl��������.����� >= 250
						then 1
						else 0
						end as RrequiredPurityByMass
FROM         dbo.tbl������_������� RIGHT OUTER JOIN
                      dbo.tbl�������� ON dbo.tbl������_�������.����� = dbo.tbl��������.���������� RIGHT OUTER JOIN
                      dbo.tbl������ ON dbo.tbl��������.���_�������� = dbo.tbl������.���_�������� AND 
                      dbo.tbl��������.���_���������� = dbo.tbl������.���_���������� AND dbo.tbl��������.ID = dbo.tbl������.ID
GROUP BY dbo.tbl������.���, dbo.tbl������.ID, dbo.tbl������.���������, dbo.tbl������.����, dbo.tbl������.����, dbo.tbl������.���_����������, 
                      dbo.tbl������.���_��������, dbo.tbl������.����������, dbo.tbl������.����_�������, dbo.tbl������.[������������ ��� �������], 
                      dbo.tbl������.���_tbl��������_rev, dbo.tbl������.[������� ���������� �������], dbo.tbl������.[���������� ����������], 
                      dbo.tbl������.�����_LCMS, dbo.tbl������.�������, dbo.tbl������.Molweight, dbo.tbl������.Mikromoli, 
                      dbo.tbl������_�������.����������_��_�������, dbo.tbl������_�������.����������_��_�������_2, dbo.tbl������.���������, 
                      dbo.tbl������.�����������, dbo.tbl������.S30_���_�, dbo.tbl��������.�������_��_��������, dbo.tbl��������.�����

GO



/*
select distinct [tbl������_���������_�������].����������_��_������� , RrequiredPurityByMass , COUNT(*)
from [tbl������_���������_�������]
where ����������_��_�������_3 = '95'
group by [tbl������_���������_�������].����������_��_������� , RrequiredPurityByMass 
*/