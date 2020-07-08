/* ��� ������ �� ������ ��������-���� � ������� ������� �� ������ */

USE Chest35;
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--Create 
ALTER VIEW [dbo].[View_�������������_���������]
AS
select x.���_���������
	, x.���_������
	, sum(x.ID_Count) as ID_Count
	, case when sum(x.ID_Count)=1
		then MAX(max_ID)
		else '*'
		end as IDNUMBER
from
	(select  ���_���������, ���_������
			, count(ID)  as ID_Count
			, MAX(ID) as max_ID
	from  tbl����������������� 
	group by ���_���������, ���_������
	UNION ALL 
	select  ���_���������, ���_������
			, count(ID)  as ID_Count
			, MAX(ID) as max_ID
	from tbl�������������
	group by ���_���������, ���_������) x
group by x.���_���������, x.���_������
GO

grant select on [dbo].[View_�������������_���������] to	  [Chest_Zakazi]
														, [Chest_Postavki]
														, [Chest_Wes_Chief]
														, [Chest50]
														, [Chest_Wesovschiki]
														, [Chest_public]
														, [Sklad30Chest]
														, [Chest_Admins]
														, [Chest_Otpravki]
														, [Chest_Rukovodstvo]
														, [Chest_Postavki_really];
go														
