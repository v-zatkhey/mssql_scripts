use Chest35;
go

-- first import scaffold data into _tmp_Skaffold
-- then:
/*
insert into tblScaffold(Code,Decision)
select IDNUMBER, Decision 
from dbo._tmp_Skaffold
order by IDNUMBER
*/
go

--�� ������� �����. ����� �����������.
select s.*, t.Chemist, t.Other_Chemists, p.���, p.���_����������, p.�������, p.���, p.��������, p.Email
from tblScaffold s
	inner join _tmp_Skaffold t on t.IDNUMBER = s.Code
	left join tbl����������_full p on t.Chemist like '%'+p.���_����������+'%' or t.Other_Chemists like '%'+p.���_����������+'%'
where p.��� is null and t.Chemist != 'Virtual'
	
SELECT [���]
      ,[���_����������]
      ,[���������]
      ,[�����]
      ,[�������]
      ,[���]
      ,[��������]
      ,[���������]
      ,[��������������]
      ,[�������������]
      ,[�����������������]
      ,[���������������]
      ,[����]
      ,[Email]
      ,[������]
      ,[������]
      ,[�������]
      ,[�����]
      ,[����������������]
      ,[����������]
  FROM [Chest35].[dbo].[tbl����������_full]
GO

--�� ������� email
select --s.*, t.Chemist, t.Other_Chemists, p.���, 
	distinct p.���_����������, p.�������, p.���, p.��������, p.Email, COUNT(*)
from tblScaffold s
	inner join _tmp_Skaffold t on t.IDNUMBER = s.Code
	inner join tbl����������_full p on t.Chemist like '%'+p.���_����������+'%' or t.Other_Chemists like '%'+p.���_����������+'%'
where 	p.Email is null
group by p.���_����������, p.�������, p.���, p.��������, p.Email
order by COUNT(*) desc
--update 	[tbl����������_full] set [Email] = 'Alexandr.Mandzhulo@lifechemicals.com' where [���] = 291;

-- ������ ��'���� � �������
/*
insert into dbo.tblScaffoldChemist(ScaffoldID,ChemistID)
select s.ID, p.���
from tblScaffold s
	inner join _tmp_Skaffold t on t.IDNUMBER = s.Code
	inner join tbl����������_full p on t.Chemist like '%'+p.���_����������+'%' or t.Other_Chemists like '%'+p.���_����������+'%'
where not exists(select * from tblScaffoldChemist where ScaffoldID = s.ID and ChemistID = p.���)
*/

select s.Code, c.���_����������, c.�������, c.���, c.�������� 
from tblScaffold s
	left join tblScaffoldChemist sc on sc.ScaffoldID = s.ID
	left join tbl����������_full c on c.��� = sc.ChemistID
order by  s.Code desc