select * from ������ 

select * 
from dbo.������� o
	left join dbo.eqsItem i on i.OldCodeID = o.���_ID 
where ���_� = 13 and ������� != 0 and i.ID is null

select * from __�������� v where v.���_ID in (23196,
23213,
21698,
23250,
22855,
22876,
22966,
23021) 

select * from eqsDocType 
select * from eqsDocument where DocTypeID = 4 -- 15

select * from eqsDetail where DocID = 15
go

--declare @DocID int = 15, @kod_c int = 11;
declare @DocID int =26, @kod_c int = 13;

insert into eqsDetail(DocID,ItemID,Quantity)
select @DocID, i.ID , o.�������  
from dbo.������� o
	left join dbo.eqsItem i on i.OldCodeID = o.���_ID 
where ���_� = @kod_c and ������� != 0

