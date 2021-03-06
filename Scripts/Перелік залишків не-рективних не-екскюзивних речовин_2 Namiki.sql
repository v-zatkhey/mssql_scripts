/****for Ayaka Izu <ayaka.izu@namiki-s.co.jp>**/

use Chest35;
go

set ANSI_WARNINGS  off;

select 
	  s.ID 
	, cast(round(s.[Масса],0) as int) as StockAmount
	, isnull(cast(pr.Коэффициент as decimal(5,1)), 1.0) as PriceCoef
from tblСклад_LC s
	left join dbo.tbl_Повышенная_цена  pr on pr.ID = s.ID
where not exists (select * from dbo.tbl_Reactive_compounds where ID = s.ID)
	and not exists(	select * 
					from tblБазовыеСписки bl
						left join tblBaseListCondition bc on bc.BaseListID = bl.Код_ID
					where bl.ID = s.ID 
						and (bl.Дата_окончания_Эксклюзивности > GETDATE()
							or bc.ConditionID in (18,22,28,29,30) 
							)
					)
	and cast(round(s.[Масса],0) as int)>0
