declare @DateLimits table (id int, BegDate date, EndDate date);
/*
1)	� 01,09,2017 �� 7,12,2017
2)	� 01,09,2018 �� 7,12,2018
3)	� 15,01,2017 �� 01,05,2017
4)	� 15,01,2018 �� 01,05,2018
*/
insert into @DateLimits(ID, BegDate , EndDate )
values	(1, '20170901','20171207')
	,	(2, '20180901','20181207')
	,	(3, '20170115','20170501')
	,	(4, '20180115','20180501')

select s.���_�������, d.BegDate, d.EndDate, COUNT(*) as Quantity  
from dbo.tbl������ s
	inner join @DateLimits d on s.���� between d.BegDate and d.EndDate
where s.���_������� = 'R'
	--s.���_������� in ('B', 'N')
	--s.���_������� in ('V', 'T')
	and s.��������� != 'EPO'
group by d.id, d.BegDate, d.EndDate, s.���_�������
order by s.���_�������, d.id;	

-- select * from tbl������ s where s.���_������� in ('V', 'T')	and s.��������� != 'EPO' 

/*
select *
from dbo.tbl������ s
	inner join @DateLimits d on s.���� between d.BegDate and d.EndDate
where s.���_������� = 'R'
	and s.��������� != 'EPO'
	and d.id = 2	
order by s.���_�������, d.id;	

select *
from dbo.tbl������ s
	inner join @DateLimits d on s.���� between d.BegDate and d.EndDate
where s.���_������� = 'R'
	and s.��������� != 'EPO'
	and d.id = 3	
order by s.���_�������, d.id;	
*/