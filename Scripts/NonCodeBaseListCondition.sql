/************************/
-- виявляємо непрокодовані
declare @LongCondition table(id int, idnumber char(10), condition  varchar(255));
insert into @LongCondition
select bl.Код_ID, bl.ID, bl.Условия_взвешивания 
from tblБазовыеСписки bl
	left join tblBaseListCondition c on c.BaseListID = bl.Код_ID
	left join tblТипы_условий_взвешивания t on t.Код = c.ConditionID
where bl.Условия_взвешивания is not null
	and isnull(bl.Условия_взвешивания, '') <> ISNULL(t.[Условие взвешивания],'') 
group by bl.Код_ID, bl.ID, bl.Условия_взвешивания; 


declare @id int, @cond varchar(255);
declare Conditions cursor forward_only 
for  select [Код], [Условие взвешивания] from tblТипы_условий_взвешивания where [Условие взвешивания] is not null;
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

select l.*, bl.Условия_взвешивания from @LongCondition l left join tblБазовыеСписки bl on bl.ID = l.idnumber;
select distinct condition from @LongCondition;

go

/****************/