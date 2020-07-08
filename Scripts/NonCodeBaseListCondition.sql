/************************/
-- ��������� ������������
declare @LongCondition table(id int, idnumber char(10), condition  varchar(255));
insert into @LongCondition
select bl.���_ID, bl.ID, bl.�������_����������� 
from tbl������������� bl
	left join tblBaseListCondition c on c.BaseListID = bl.���_ID
	left join tbl����_�������_����������� t on t.��� = c.ConditionID
where bl.�������_����������� is not null
	and isnull(bl.�������_�����������, '') <> ISNULL(t.[������� �����������],'') 
group by bl.���_ID, bl.ID, bl.�������_�����������; 


declare @id int, @cond varchar(255);
declare Conditions cursor forward_only 
for  select [���], [������� �����������] from tbl����_�������_����������� where [������� �����������] is not null;
open Conditions;
fetch next from Conditions into @id, @cond;
while @@FETCH_STATUS=0
	begin
	
	update @LongCondition 
	set condition = REPLACE(condition, @cond, '');
	
	fetch next from Conditions into @id, @cond;
	end 
close Conditions;
deallocate Conditions;

update @LongCondition 
set condition = ltrim(rtrim(REPLACE(condition, ',', '')));

delete from @LongCondition where condition = '';

select l.*, bl.�������_����������� from @LongCondition l left join tbl������������� bl on bl.ID = l.idnumber;
select distinct condition from @LongCondition;

go

/****************/