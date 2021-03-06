
  SELECT s.ID
		, s.Блок
		, s.Дата_спектра
		, round(m.MW_without_Salt,2) as MMol
        ,[Value] as Fshift
      , p.Масса
  FROM [Chest35].[dbo].[tbl_Фторные_сдвиги] f
	inner join [Chest35].dbo.tblСпектр s on s.Код = f.Kod_Spectra
	inner join [Chest35].dbo.tblПоставки p on p.Код = s.Код_tblПоставки_rev 
	inner join [Chest35].dbo.Materials m on m.MatName = s.ID
 where s.Результат = 'OK' 
	and s.Дата_спектра between '20180926' and '20190227'	
 order by s.Дата_спектра, s.Блок, s.ID 
GO



  SELECT s.ID
		, s.Блок
		, s.Дата_спектра
        ,[Value] as Fshift
        , s.Код 
  FROM [Chest35].[dbo].[tbl_Фторные_сдвиги] f
	inner join [Chest35].dbo.tblСпектр s on s.Код = f.Kod_Spectra
 where s.Результат = 'OK' and s.ID = 'F1913-0932' -- 'F6619-2161'
 order by s.Дата_спектра, s.Блок, s.ID 
GO

select x.ID, COUNT(*)
from
(
  SELECT s.ID
		, s.Блок as Block
		, s.Дата_спектра
  FROM [Chest35].[dbo].[tbl_Фторные_сдвиги] f
	inner join [Chest35].dbo.tblСпектр s on s.Код = f.Kod_Spectra
 where s.Результат = 'OK' 
 group by s.Блок, s.ID 
) x
group by x.ID
having COUNT(*)>1
order by COUNT(*) desc
/*************************************************************************/
/*18/12/2019*/
select f.*, s.ID , s.Блок as Block, s.Дата_спектра as SpextraDate
	, COUNT(*) over( partition by s.ID, s.Блок ) as PeakCount
into #res
from [Chest35].[dbo].[tbl_Фторные_сдвиги] f
	inner join [Chest35].dbo.tblСпектр s on s.Код = f.Kod_Spectra
	inner join
(
  SELECT s.ID
		,MAX(s.Код ) as LastCode
  FROM [Chest35].[dbo].[tbl_Фторные_сдвиги] f
	inner join [Chest35].dbo.tblСпектр s on s.Код = f.Kod_Spectra
	inner join(
		  SELECT s.ID
				,MAX(s.Дата_спектра) as LastSpextraDate
		  FROM [Chest35].[dbo].[tbl_Фторные_сдвиги] f
			inner join [Chest35].dbo.tblСпектр s on s.Код = f.Kod_Spectra
		 where s.Результат = 'OK' 
		 group by  s.ID 
		) y on s.ID = y.ID  and y.LastSpextraDate = s.Дата_спектра 	
 where s.Результат = 'OK' 
 group by  s.ID 
) x on s.ID = x.ID and s.Код = x.LastCode 
where s.Результат = 'OK' 
order by s.ID ;

select ID, Value, convert(varchar(10), SpextraDate, 104) as SpextraDate  from #res where PeakCount=1; --3260
select ID, Value,convert(varchar(10), SpextraDate, 104) as SpextraDate from #res where PeakCount>1;   --1485

select * from #res where ID = 'F1911-3477';
select * from #res where ID = 'F1967-0266';
select * from #res where ID = 'F1967-0684';
select * from #res where ID = 'F6437-5806';
select * from #res where ID = 'F0001-3817';


select COUNT(*) from #res; --4745

select * from #res where SpextraDate >= '20191218';

select ID,PeakCount,COUNT(*) 
from #res 
group by ID,PeakCount  
having PeakCount != COUNT(*) ;

drop table #res

select * from tblСпектр where Код in (1294937,1294984)

