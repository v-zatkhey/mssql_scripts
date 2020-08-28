use Chest35
go

select *  from tblClientRequests;
select * 
from tblClientRequests cr 
	inner join tblClientRequestDetails d on d.RequestID = cr.ID
where d.IDNumber = 'F6545-4035'
;

--
/* 
select * from tblClientRequestDetails
select * from tblClientRequests
update tblClientRequests set AnswerDate = null, AnswerText = null, AnswerEmployee = null , HasAnswer =0 where ID = 3; 
*/


/*
begin tran

	delete from d
	from tblClientRequestDetails d 
		inner join tblClientRequests r on r.ID = d.RequestID 
	where r.ID < 13;	

	delete from tblClientRequests where ID < 13;
	
commit	
*/