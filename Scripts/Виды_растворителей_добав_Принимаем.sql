select * from tbl����_�������� where ��� in ('S', 'M' ,'G');
select * from [tbl����_�������������] v where  v.��� in (1,2,25) and Category = 2 order by v.���, v.Sorting;


SELECT t.���, v.���, v.Name, v.Sorting  
FROM [Chest35].[dbo].[tbl����_�������������] v
	inner join tbl����_�������� t on t.��� = v.���
where v.��� in (1,2,25)
	and Category = 2
order by v.���, Sorting;

select len('�������� ��������� � ����� ��������!')

/*
insert into [tbl����_�������������](Name,Comments,Category,Sorting,���)
values ('���������!','�������� ��������� � ����� ��������!',2,500,1)
	,  ('���������!','�������� ��������� � ����� ��������!',2,500,2)
	,  ('���������!','�������� ��������� � ����� ��������!',2,500,25)
*/
--UPDATE [tbl����_�������������] SET Sorting = 500 WHERE ��� in (224,236,232,220,231,219)

select i.* 
from dbo.MaterialInfo i inner join Materials m on m.MatID = i.MatID
where m.MatName = 'F6782-0635';
--update MaterialInfo set DateFailure = getdate() where MInfoID = 7063397;