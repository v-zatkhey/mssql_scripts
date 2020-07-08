declare @DateLimits table (id int, BegDate date, EndDate date);
/*
1)	с 01,09,2017 по 7,12,2017
2)	с 01,09,2018 по 7,12,2018
3)	с 15,01,2017 по 01,05,2017
4)	с 15,01,2018 по 01,05,2018
*/
insert into @DateLimits(ID, BegDate , EndDate )
values	(1, '20170901','20171207')
	,	(2, '20180901','20181207')
	,	(3, '20170115','20170501')
	,	(4, '20180115','20180501')

select s.Тип_спектра, d.BegDate, d.EndDate, COUNT(*) as Quantity  
from dbo.tblСпектр s
	inner join @DateLimits d on s.Дата between d.BegDate and d.EndDate
where s.Тип_спектра = 'R'
	--s.Тип_спектра in ('B', 'N')
	--s.Тип_спектра in ('V', 'T')
	and s.Результат != 'EPO'
group by d.id, d.BegDate, d.EndDate, s.Тип_спектра
order by s.Тип_спектра, d.id;	

-- select * from tblСпектр s where s.Тип_спектра in ('V', 'T')	and s.Результат != 'EPO' 

/*
select *
from dbo.tblСпектр s
	inner join @DateLimits d on s.Дата between d.BegDate and d.EndDate
where s.Тип_спектра = 'R'
	and s.Результат != 'EPO'
	and d.id = 2	
order by s.Тип_спектра, d.id;	

select *
from dbo.tblСпектр s
	inner join @DateLimits d on s.Дата between d.BegDate and d.EndDate
where s.Тип_спектра = 'R'
	and s.Результат != 'EPO'
	and d.id = 3	
order by s.Тип_спектра, d.id;	
*/