declare @TableOne table(ID int, FCode varchar(20), ZCode varchar(max));

insert into @TableOne 
values (1,'F0777-0781', '050-z0001')
	, (2,'F0777-0781', '050-z0002')
	, (3,'F0777-0781', '050-z0003')
	, (4,'F0880-0042', '030-z0001')
	, (5,'F0880-0042', '030-z0010')
	, (6,'F0880-0042', '030-z0012')
	, (7,'F0880-0042', '030-z0013')
	, (8,'F0880-0042', '030-z0016')
	, (9,'F1905-0062', '030-z0016');
	
with oter_z(FNumber, ZNumber, OtherZ, cnt)
as
(
select t1.FCode, t1.ZCode, min(t2.ZCode), 1  
from @TableOne t1
	left join @TableOne t2 on t2.FCode = t1.FCode and t2.ZCode != t1.ZCode 
group by t1.FCode, t1.ZCode
union all
select  t1.FNumber, t1.ZNumber
		, t1.OtherZ + ' ' + t2.ZCode, t1.cnt + 1  
from oter_z t1
	inner join @TableOne t2 on t2.FCode = t1.FNumber 
		and t2.ZCode != t1.ZNumber 
		and not t1.OtherZ like '%'+t2.ZCode+'%'
)
	
select * from 	oter_z;
	
/*
select o.FNumber, o.ZNumber, MIN(o.OtherZ) as Other
from oter_z o
	inner join (select FNumber, ZNumber, MAX(cnt) as cnt 
				from oter_z 
				group by FNumber, ZNumber)y on y.FNumber = o.FNumber and y.ZNumber = o.ZNumber and y.cnt = o.cnt
group by o.FNumber, o.ZNumber ;
*/
go


