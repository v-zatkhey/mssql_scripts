SELECT ���,���, Name, Comments, Category FROM tbl����_������������� WHERE Category=2
SELECT * FROM tbl����_������������� WHERE Category=2 AND ��� in (1,2,7,15,23,25) ORDER BY Sorting, ���
select * from tbl����_�������� where ��� in (1,2,7,15,23,25)
SELECT ��� FROM tbl����_������������� WHERE Category=2 group by  ���

-- insert into  tbl����_������������� (Name,Comments,Category,Sorting,[���])
select '������!' 
	, '������!'
	, 2 as Category
	, 555 as Sorting
	, ��� as [���]
from tbl����_�������� 
where ��� in (1,2,7,15,23,25)


/*
������, ������� �������� ������ �������� ��� ���������.

...

� ��. ������ �[�����������]
*/
-- insert into  tbl����_������������� (Name,Comments,Category,Sorting,[���])
select '�� ��������!' 
	, '�� ��������!'
	, 2 as Category
	, 555 as Sorting
	, ��� as [���]
from tbl����_�������� 
where ��� in (1,2,7,15,23,25);

--------------------------------------
SELECT * FROM tbl����_������������� WHERE Category=1 AND ��� in (1,7) ORDER BY ���, Sorting, ���
select * from tbl����_�������� where ��� in (1,2,7,15,23,25)

--insert into tbl����_������������� (Name,Comments,Category,Sorting,[���])values ('D2O+TFA','D2O+TFA',1,140,1),('D2O+TFA','D2O+TFA',1,140,7);


/*****/
select * from tbl����_�������� where ��� in (2,15)
SELECT * FROM tbl����_������������� 
WHERE Category=2 AND ��� in (2,15) 
ORDER BY [���], Sorting, ���
