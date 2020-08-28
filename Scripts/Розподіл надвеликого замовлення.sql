-- ������� ����������� ������
-- ����� 01136-z00123

use Chest35;
go

/*
select ID, Box_����� , Box_������ , Box_������� 
	, ROW_NUMBER() over( order by ID) as Num
	, char((ROW_NUMBER() over( order by ID) -1)%8+65) as RowIndx  
	, ((ROW_NUMBER() over( order by ID) -1)/8)%10+2 as ColNum  
	, ((ROW_NUMBER() over( order by ID) -1)/80) + 1 as BoxNum
from tbl������������� 
where ���_��������� = '01136' and ���_������  = 'z00123'
order by ID;


select *
into _tmp_������������_01136_z00123_back
from tbl������������� 
where ���_��������� = '01136' and ���_������  = 'z00123'
order by ID;
*/
/*
declare @Discrim table(ID varchar(10), RowIndx char(1), ColIndx int, BoxNum int)

begin tran

	insert into @Discrim
	select ID
	--	, ROW_NUMBER() over( order by ID) as Num
		, char((ROW_NUMBER() over( order by ID) -1)%8+65) as RowIndx  
		, ((ROW_NUMBER() over( order by ID) -1)/8)%10+2 as ColIndx  
		, ((ROW_NUMBER() over( order by ID) -1)/80) + 1 as BoxNum
	from tbl�������������
	where ���_��������� = '01136' and ���_������  = 'z00123'
	order by ID;
	
	--update tbl�������������
	--, 
	
	update s
	set Box_����� = d.BoxNum
		, Box_������ = d.RowIndx 
		, Box_������� = d.ColIndx 
	from @Discrim d
		inner join tbl������������� s on  s.���_��������� = '01136' 
										and s.���_������  = 'z00123' 
										and s.ID = d.ID; 

commit
*/

select ID, Box_����� , Box_������ , Box_������� 
	, ROW_NUMBER() over( order by ID) as Num
	, *
from tbl������������� s 
where ���_��������� = '01136' and ���_������  = 'z00123'
order by s.ID;

select  *
from tbl����������� s 
where s.����� = '01136-z00123' and s.PickedLotCode =0
order by s.ID;


select s.ID 
	, s.Box_����� 
	, s.Box_������ 
	, s.Box_������� 
	, s.���_���������� 
	, s.���_�������� 
	, v.PickedLotCode 
	, p.���_����������
	, p.���_�������� 
from tbl������������� s 
	inner join tbl����������� v on v.����� =  s.���_��������� + '-' + s.���_������
		and v.ID = s.ID 
	inner join tbl�������� p on p.��� = v.PickedLotCode 
where s.���_��������� = '01136' and s.���_������ = 'z00123'
order by s.ID;

/*
update s
set ���_���������� = p.���_����������
	, ���_�������� = p.���_�������� 
from tbl������������� s 
	inner join tbl����������� v on v.����� =  s.���_��������� + '-' + s.���_������
		and v.ID = s.ID 
	inner join tbl�������� p on p.��� = v.PickedLotCode 
where s.���_��������� = '01136' and s.���_������ = 'z00123'
;
*/