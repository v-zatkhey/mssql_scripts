use AutoLot;
 
select * from  dbo.[_Older2010-LCMS-repeat];
select * from dbo._CrossMatrixLarge where ID is not null;

select * 
from  dbo.[_Older2010-LCMS-repeat] r
	inner join dbo._CrossMatrixLarge m on m.ID = r.IDNUMBER
where m.BATCH <> r.Batch;	

select r.*, LEFT(r.Batch,3) as SupplierCode 
from  dbo.[_Older2010-LCMS-repeat] r
	left join dbo._CrossMatrixLarge m on m.ID = r.IDNUMBER and m.BATCH = r.Batch
where m.ID is null	
order by LEFT(r.Batch,3), r.IDNUMBER;