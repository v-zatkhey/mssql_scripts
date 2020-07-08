select ���_���������, ���_������, count(distinct Box_�����)
from tbl�������������
where ���_��������� = '00807'
group by ���_���������, ���_������  
having count(distinct Box_�����)>1
order by ���_���������, ���_������ ;


select ���_���������, ���_������, Box_Barcode, Box_�����, Box_������� , Box_������ 
from tbl�������������
where ���_��������� = '00807'
	--and ���_������ = 'z00086'
order by ���_������, cast(Box_����� as int);



------------------------------------------------------
declare @CustomerCode varchar(5) = '00807';
declare @OddOrder varchar(6) = 'z00086';
declare @EvenOrder varchar(6) = 'z00087';

 
--update s 
--set   Box_����� = (Box_�����*2-1)
select ���_���������, ���_������, ID, Box_Barcode, Box_�����, Box_������� , Box_������ 
, (Box_�����*2-1) as box_odd
from tbl������������� s
where ���_��������� = @CustomerCode
	and ���_������ = @OddOrder
order by cast(Box_����� as int)
;

 
--update s 
--set   Box_����� = (s.Box_����� - 1)*2 
select ���_���������, ���_������, ID, Box_Barcode, Box_�����, Box_������� , Box_������ 
, (s.Box_����� - 1)*2 as box_even
from tbl������������� s
where ���_��������� = @CustomerCode
	and ���_������ = @EvenOrder
order by cast(Box_����� as int)
;
go

------------------------------------------------------
declare @CustomerCode varchar(5) = '00807';
declare @OddOrder varchar(6) = 'z00088';
declare @EvenOrder varchar(6) = 'z00089';

 
--update s 
--set   Box_����� = ((Box_�����-100)*2-1 + 100)
select ���_���������, ���_������, ID, Box_Barcode, Box_�����, Box_������� , Box_������ 
, ((Box_�����-100)*2-1+100) as box_odd
from tbl������������� s
where ���_��������� = @CustomerCode
	and ���_������ = @OddOrder
order by cast(Box_����� as int)
;

 
--update s 
--set   Box_����� = ((Box_�����-101)*2 + 100)
select ���_���������, ���_������, ID, Box_Barcode, Box_�����, Box_������� , Box_������ 
, ((Box_�����-101)*2 + 100) as box_even
from tbl������������� s
where ���_��������� = @CustomerCode
	and ���_������ = @EvenOrder
order by cast(Box_����� as int)
;