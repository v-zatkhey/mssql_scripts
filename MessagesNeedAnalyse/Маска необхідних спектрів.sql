declare @mask bigint;

select @mask = SUM( POWER(2,���)) 
from dbo.tbl����_��������
where ���_������ in (2,1)
;

select @mask

select ���, ���,���������
from dbo.tbl����_��������
where  @mask & POWER(2,���)<>0 
order by ����������;
go


select ���, ���,���������
from dbo.tbl����_��������
where  2020 & POWER(2,���)<>0 
order by ����������;
go

select ���, ���,���������, POWER(2,���) as Mask
from dbo.tbl����_��������
where  ���_������ in (2,1) 
order by ����������;
