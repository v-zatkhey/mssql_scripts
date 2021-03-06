/****** Сценарий для команды SelectTopNRows среды SSMS  ******/
use Chest35;

SELECT p.Чистота, z.Требования_по_чистоте, p.*
  FROM --Materials m inner join 
	tblПоставки p  -- on p.ID = m.MatName
	inner join tblЗаказы z on z.Код_заказчика + '-' + z.Код_заказа = p.Примечание
  where p.Чистота is null -- MatName = 'F2185-0013' 
	and z.Требования_по_чистоте is not null;


SELECT z.Требования_по_чистоте, COUNT(*) as Qnt
  FROM --Materials m inner join 
	tblПоставки p  -- on p.ID = m.MatName
	inner join tblЗаказы z on z.Код_заказчика + '-' + z.Код_заказа = p.Примечание
  where p.Чистота is null -- MatName = 'F2185-0013' 
	and z.Требования_по_чистоте is not null
group by z.Требования_по_чистоте
order by COUNT(*) desc ;
go
 
 /* 
 -- на всякий случай - бекап
select *
into _tmp_tblПоставки_bak_20181112
from   tblПоставки p 
where p.Чистота is null  -- (строк обработано: 1182651)
 */
 SELECT  COUNT(*) as Qnt
  FROM 
	tblПоставки p  -- on p.ID = m.MatName
	inner join tblЗаказы z on z.Код_заказчика + '-' + z.Код_заказа = p.Примечание
  where p.Чистота is null -- MatName = 'F2185-0013' 
	and z.Требования_по_чистоте is not null
	AND z.Требования_по_чистоте like '%90%'
	and Not z.Требования_по_чистоте like '%95%' ; --320412

select p.Код, 0 as IsUpd
--into _tmp_tblПоставки_upd
from  	tblПоставки p  -- on p.ID = m.MatName
	inner join tblЗаказы z on z.Код_заказчика + '-' + z.Код_заказа = p.Примечание
where p.Чистота is null -- MatName = 'F2185-0013' 
	and z.Требования_по_чистоте is not null
	AND z.Требования_по_чистоте like '%90%'
	and Not z.Требования_по_чистоте like '%95%'
group by  p.Код; --304272

/*
declare @upd_portion table(ID int);

while exists(select * from _tmp_tblПоставки_upd where IsUpd = 0)
	begin
	insert into @upd_portion  select top 100 Код from dbo._tmp_tblПоставки_upd where IsUpd = 0

	-- select *  FROM 	tblПоставки p inner join @upd_portion t on t.ID = p.Код;	

	update p set Чистота = '90'
	  FROM 
		tblПоставки p  
		inner join @upd_portion t on t.ID = p.Код
	where p.Чистота is null ;	
	update t set IsUpd = 1 from _tmp_tblПоставки_upd t inner join @upd_portion p on p.ID = t.Код
	
	end

go


 SELECT z.Требования_по_чистоте, COUNT(*) as Qnt
  FROM --Materials m inner join 
	tblПоставки p  -- on p.ID = m.MatName
	inner join tblЗаказы z on z.Код_заказчика + '-' + z.Код_заказа = p.Примечание
  where p.Чистота is null -- MatName = 'F2185-0013' 
	and z.Требования_по_чистоте is not null
	AND z.Требования_по_чистоте like '%90%'
	and Not z.Требования_по_чистоте like '%95%' 
group by

*/
  
SELECT z.Требования_по_чистоте, COUNT(*) as Qnt
  FROM --Materials m inner join 
	tblПоставки p  -- on p.ID = m.MatName
	inner join tblЗаказы z on z.Код_заказчика + '-' + z.Код_заказа = p.Примечание
  where p.Чистота is null -- MatName = 'F2185-0013' 
	and z.Требования_по_чистоте is not null
	AND z.Требования_по_чистоте like '%95%'
	and Not z.Требования_по_чистоте like '%90%' 
	and Not z.Требования_по_чистоте like '%98%' 
group by 	z.Требования_по_чистоте

select p.Код, 0 as IsUpd
into _tmp_tblПоставки_upd
from  	tblПоставки p  -- on p.ID = m.MatName
	inner join tblЗаказы z on z.Код_заказчика + '-' + z.Код_заказа = p.Примечание
where p.Чистота is null 
	and z.Требования_по_чистоте is not null
	AND z.Требования_по_чистоте like '%95%'
	and Not z.Требования_по_чистоте like '%90%' 
	and Not z.Требования_по_чистоте like '%98%' -- 13298

declare @upd_portion table(ID int);

while exists(select * from _tmp_tblПоставки_upd where IsUpd = 0)
	begin
	insert into @upd_portion  select top 100 Код from dbo._tmp_tblПоставки_upd where IsUpd = 0

	-- select *  FROM 	tblПоставки p inner join @upd_portion t on t.ID = p.Код;	

	update p set Чистота = '95'
	  FROM 
		tblПоставки p  
		inner join @upd_portion t on t.ID = p.Код
	where p.Чистота is null ;	
	update t set IsUpd = 1 from _tmp_tblПоставки_upd t inner join @upd_portion p on p.ID = t.Код
	
	end

go



/*
select distinct z.Требования_по_чистоте, p.Чистота --, *
from tblПоставки p 
inner join _tmp_tblПоставки_upd t on t.Код = p.Код
	inner join tblЗаказы z on z.Код_заказчика + '-' + z.Код_заказа = p.Примечание
where t.IsUpd = 1;
*/
go

-- анализ поставок с пустой чистотой
-- различные требования
SELECT z.Требования_по_чистоте, COUNT(*) as Qnt
  FROM --Materials m inner join 
	tblПоставки p  -- on p.ID = m.MatName
	left join tblЗаказы z on (z.Код_заказчика + '-' + z.Код_заказа = p.Примечание) or (z.Код_заказа = p.Примечание)
  where p.Чистота is null -- MatName = 'F2185-0013' 
	and p.Решение_по_поставке = 1 --склад
	and p.Масса <=250
	and z.Требования_по_чистоте is not null
group by z.Требования_по_чистоте
order by COUNT(*) desc ;
go

-- нет заказа
SELECT p.Примечание, COUNT(*) as Qnt
  FROM --Materials m inner join 
	tblПоставки p  -- on p.ID = m.MatName
	left join tblЗаказы z on z.Код_заказчика + '-' + z.Код_заказа = p.Примечание -- or (z.Код_заказа = p.Примечание)
  where p.Чистота is null
	and p.Решение_по_поставке = 1 --склад
	and p.Масса <=250
	and z.Код is null
group by 	p.Примечание
order by COUNT(*) desc ;
go

SELECT *
  FROM --Materials m inner join 
	tblПоставки p  -- on p.ID = m.MatName
	left join tblЗаказы z on z.Код_заказчика + '-' + z.Код_заказа = p.Примечание -- or (z.Код_заказа = p.Примечание)
  where p.Чистота is null
	and p.Решение_по_поставке = 1 --склад
	and p.Масса <=250
	and z.Код is null;
go

SELECT *
  FROM --Materials m inner join 
	tblПоставки p  -- on p.ID = m.MatName
	left join tblЗаказы z on z.Код_заказчика + '-' + z.Код_заказа = p.Примечание -- or (z.Код_заказа = p.Примечание)
  where p.Чистота is null
	and p.Решение_по_поставке = 1 --склад
	and p.Масса >=700
	and p.Код_поставщика <> 'USA' and p.Код_поставщика <> 'EUR' and p.Код_поставщика <> 'JPN'
	and z.Код is null;
go


SELECT p.Чистота,p.Решение_по_поставке, p.Масса, z.Требования_по_чистоте  --склад
FROM 	tblПоставки p 
		left join tblЗаказы z on z.Код_заказчика + '-' + z.Код_заказа = p.Примечание -- or (z.Код_заказа = p.Примечание)
where p.ID = 'F6658-6037' and p.Код_поставщика = 'SZV' and p.Код_поставки = '3833';


/*********/
-- всего поставок 751978
SELECT COUNT(*) as Qnt
  FROM 
	tblПоставки p  
  where p.Решение_по_поставке = 1 --склад
	and p.Код_поставщика <> 'USA' and p.Код_поставщика <> 'EUR' and p.Код_поставщика <> 'JPN';
go
--веществ в этих поставках 621719
SELECT COUNT(distinct p.ID) as Qnt
  FROM 
	tblПоставки p  
  where p.Решение_по_поставке = 1 --склад
	and p.Код_поставщика <> 'USA' and p.Код_поставщика <> 'EUR' and p.Код_поставщика <> 'JPN';
go

-- чистота в поставке проставлена 250293
SELECT COUNT(*) as Qnt
  FROM 
	tblПоставки p  
  where p.Чистота is not null
	and p.Решение_по_поставке = 1 --склад
	and p.Код_поставщика <> 'USA' and p.Код_поставщика <> 'EUR' and p.Код_поставщика <> 'JPN';
go

--нет чистоты в поставке 501685
SELECT COUNT(*) as Qnt
  FROM 
	tblПоставки p  
  where p.Чистота is null
	and p.Решение_по_поставке = 1 --склад
	and p.Код_поставщика <> 'USA' and p.Код_поставщика <> 'EUR' and p.Код_поставщика <> 'JPN';
go

-- нет заказа или требуемой чистоты в заказе 501682
SELECT COUNT(*) as Qnt
  FROM  
	tblПоставки p  
	left join tblЗаказы z on z.Код_заказчика + '-' + z.Код_заказа = p.Примечание 
  where p.Чистота is null
	and p.Решение_по_поставке = 1 --склад
	and (z.Требования_по_чистоте is null or   not z.Требования_по_чистоте like '%90%' or not z.Требования_по_чистоте like '%95%' ) --
	and p.Код_поставщика <> 'USA' and p.Код_поставщика <> 'EUR' and p.Код_поставщика <> 'JPN';
go

SELECT p.Примечание, COUNT(*) as Qnt
  FROM 
	tblПоставки p  
	left join tblЗаказы z on z.Код_заказчика + '-' + z.Код_заказа = p.Примечание 
  where p.Чистота is null
	and p.Решение_по_поставке = 1 --склад
	and (z.Требования_по_чистоте is null or   not z.Требования_по_чистоте like '%90%' or not z.Требования_по_чистоте like '%95%' ) 
	and p.Код_поставщика <> 'USA' and p.Код_поставщика <> 'EUR' and p.Код_поставщика <> 'JPN'
	--and LEN(p.Примечание) = 5
group by 	p.Примечание
order by COUNT(*) desc ;
go

-- 

-- drop table  #customerPurityRequest
select x.Код_заказчика , x.Требования_по_чистоте 
into #customerPurityRequest
from
(select  ROW_NUMBER() over (partition by Код_заказчика order by Код_заказчика, COUNT(*)desc) as Place
	, Код_заказчика
	, replace(Требования_по_чистоте,'%','') as Требования_по_чистоте 
	, COUNT(*) as Qnt
from tblЗаказы 
where Требования_по_чистоте is not null
	and Код_заказчика in ('00022'
						, '00050'
						, '00105'
						, '00122'
						, '00429'
						, '01000'
						, '10022'
						, '10050'
						, '10122'
						, '10429'
						, '50050'
						, '50122'
						, '50429'
						)
group by 	Код_заказчика, replace(Требования_по_чистоте,'%','')
--order by Код_заказчика, COUNT(*) desc
) x
where x.Place  = 1;



SELECT  pr.Требования_по_чистоте, COUNT(*) as Qnt
  FROM tblПоставки p  -- on p.ID = m.MatName
	--left join tblЗаказы z on z.Код_заказчика + '-' + z.Код_заказа = p.Примечание 
	left join #customerPurityRequest pr on pr.Код_заказчика = left(p.Примечание,5) 
  where p.Чистота is null
	and p.Решение_по_поставке = 1 --склад
	--and z.Требования_по_чистоте is null
	and p.Код_поставщика <> 'USA' and p.Код_поставщика <> 'EUR' and p.Код_поставщика <> 'JPN'
group by pr.Требования_по_чистоте ;
go

/**
Требования_по_чистоте	Qnt
NULL	278109
90		213481
95		863

Требования_по_чистоте	Qnt
NULL	283355
90	217442
95	893
*/

--214344
SELECT  p.Примечание, pr.Требования_по_чистоте,  *
  FROM tblПоставки p  -- on p.ID = m.MatName
	left join tblЗаказы z on z.Код_заказчика + '-' + z.Код_заказа = p.Примечание 
	left join #customerPurityRequest pr on pr.Код_заказчика = left(p.Примечание,5) 
  where p.Чистота is null
	and p.Решение_по_поставке = 1 --склад
	and z.Требования_по_чистоте is null
	and p.Код_поставщика <> 'USA' and p.Код_поставщика <> 'EUR' and p.Код_поставщика <> 'JPN'
	and pr.Требования_по_чистоте is not null;
go

/* 
 -- на всякий случай - бекап
select *
into _tmp_tblПоставки_bak_20190124
from   tblПоставки p 
where p.Чистота is null  -- (строк обработано: 855437)
 */
 
-- drop table _tmp_tblПоставки_upd;
select p.Код, 0 as IsUpd
--into _tmp_tblПоставки_upd
  FROM tblПоставки p  -- on p.ID = m.MatName
	left join tblЗаказы z on z.Код_заказчика + '-' + z.Код_заказа = p.Примечание 
	left join #customerPurityRequest pr on pr.Код_заказчика = left(p.Примечание,5) 
  where p.Чистота is null
	and p.Решение_по_поставке = 1 --склад
	and z.Требования_по_чистоте is null
	and p.Код_поставщика <> 'USA' and p.Код_поставщика <> 'EUR' and p.Код_поставщика <> 'JPN'
	and pr.Требования_по_чистоте is not null; 
-- (строк обработано: 214344)	

declare @upd_portion table(ID int);

while exists(select * from _tmp_tblПоставки_upd where IsUpd = 0)
	begin
	insert into @upd_portion  select top 100 Код from dbo._tmp_tblПоставки_upd where IsUpd = 0

	-- select *  FROM 	tblПоставки p inner join @upd_portion t on t.ID = p.Код;	

	update p set Чистота = pr.Требования_по_чистоте 
	  FROM 
		tblПоставки p  
		inner join @upd_portion t on t.ID = p.Код
		inner join #customerPurityRequest pr on pr.Код_заказчика = left(p.Примечание,5) 
	  where p.Чистота is null
		and p.Решение_по_поставке = 1 --склад
		and p.Код_поставщика <> 'USA' and p.Код_поставщика <> 'EUR' and p.Код_поставщика <> 'JPN' ;	
	
	update t set IsUpd = 1 from _tmp_tblПоставки_upd t inner join @upd_portion p on p.ID = t.Код;
	delete from @upd_portion;
	
	end

go
