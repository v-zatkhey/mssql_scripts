USE [Chest35]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_get_dupl_string]    Script Date: 03/20/2020 17:30:57 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO



/*
CREATE   FUNCTION [dbo].[fn_get_fshift_string] (@SpectrumKod varchar(12))  
RETURNS varchar(255) AS  
BEGIN 
DECLARE @FShift varchar(255), @cur_shift_value as decimal(18,3)

	SET @FShift = ''
	
	DECLARE curFShift CURSOR
	FOR
	  SELECT f.Value 
	  FROM tbl_Фторные_сдвиги f
	  WHERE f.Kod_Spectra  = @SpectrumKod
	FOR READ ONLY

	OPEN curFShift

	FETCH NEXT FROM curFShift INTO @cur_shift_value
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
	  IF @FShift='' 
	    BEGIN
			select @FShift = cast(@cur_shift_value as varchar(255))
	    END
	  else
		begin
			select @FShift = @FShift + ';' + cast(@cur_shift_value as varchar(255))
		end
	  FETCH NEXT FROM curFShift INTO @cur_shift_value
	END
	CLOSE curFShift
	DEALLOCATE curFShift

	IF @FShift = '' SET @FShift = NULL
RETURN (@FShift)
END
GO
*/
select * 
from [dbo].[_tmp_Packing_list_s1492-006];
go

select ID, COUNT(*) as cnt 
from [dbo].[_tmp_Packing_list_s1492-006] 
group by ID
having COUNT(*) > 1;

select distinct s.[Растворитель для спектра] from  tblСпектр s 
where s.Тип_спектра = 'F'
	and s.Результат = 'OK'

select b.* , f.Value 
from [_tmp_Packing_list_s1492-006_batch] b 
	inner join tblПоставки p 
		on	p.Код_поставщика = b.POS 
			and p.Код_поставки = b.post 
			and p.ID =  b.idnumber
			and p.Решение_по_поставке = 1
	inner join tblСпектр s 
		on	s.Код_tblПоставки_rev = p.Код 
			and s.Тип_спектра = 'F' 
			and s.Результат = 'OK'
			and s.[Растворитель для спектра] like '%DMSO%'
	inner join tbl_Фторные_сдвиги f on  f.Kod_Spectra = s.Код
order by b.idnumber;

-- drop table #selected_fshift;	
select t.ID
	, t.N
	, x.Код as PostSpectraID
	, y.Код as OtherSpectraID
	, case when COUNT(*) <=1
		then cast(MIN(isnull(x.Value,y.Value)) AS varchar(255))
		else [dbo].fn_get_fshift_string(isnull(x.Код,y.Код))
		end as FShift
into #selected_fshift
from [dbo].[_tmp_Packing_list_s1492-006] t
	left join (	select b.IDNUMBER as ID , z.Код , f.Value
				from [_tmp_Packing_list_s1492-006_batch] b 
					inner join tblПоставки p 
						on	p.Код_поставщика = b.POS 
							and p.Код_поставки = b.post 
							and p.ID =  b.idnumber
							and p.Решение_по_поставке = 1
					inner join (select s.Код
									,s.Код_tblПоставки_rev
									, ROW_NUMBER() over( partition by s.ID order by s.[Дата] desc, s.[Код] desc) as rn 
								from  tblСпектр s 
								where s.Тип_спектра = 'F' 
										and s.Результат = 'OK'
										and s.[Растворитель для спектра] like '%DMSO%'
								) z
						on	z.Код_tblПоставки_rev = p.Код  and z.rn = 1
					inner join tbl_Фторные_сдвиги f on  f.Kod_Spectra = z.Код
				) x on x.ID = t.ID
	left join ( select zz.ID , zz.Код , f.Value
				from (	select s.Код
							, s.ID 
							, s.Код_tblПоставки_rev
							, ROW_NUMBER() over( partition by s.ID order by s.[Дата] desc, s.[Код] desc) as rn 
						from  tblСпектр s 
						where s.Тип_спектра = 'F' 
								and s.Результат = 'OK'
								and s.[Растворитель для спектра] like '%DMSO%'
						) zz  
					inner join tbl_Фторные_сдвиги f on  f.Kod_Spectra = zz.Код and zz.rn = 1
					inner join tblПоставки p on p.Код = zz.Код_tblПоставки_rev 
				 where  p.Решение_по_поставке = 1									-- Склад
				) y on y.ID = t.ID 
--where t.ID in ('F1826-0052')
group by t.ID, t.N, x.Код, y.Код
order by t.N
;

select * from tbl_Фторные_сдвиги --where Kod_Spectra = 1403308;
select b.IDNUMBER as ID , s.Код , f.Value
					  , ROW_NUMBER() over( partition by s.ID order by s.[Дата] desc, s.[Код] desc) as rn 
				from [_tmp_Packing_list_s1492-006_batch] b 
					inner join tblПоставки p 
						on	p.Код_поставщика = b.POS 
							and p.Код_поставки = b.post 
							and p.ID =  b.idnumber
							and p.Решение_по_поставке = 1
					inner join tblСпектр s 
						on	s.Код_tblПоставки_rev = p.Код 
							and s.Тип_спектра = 'F' 
							and s.Результат = 'OK'
							and s.[Растворитель для спектра] like '%DMSO%'
					inner join tbl_Фторные_сдвиги f on  f.Kod_Spectra = s.Код
where b.idnumber in ('F1826-0052')					
					
select b.IDNUMBER , b.BATCH , COUNT(*) 
from [_tmp_Packing_list_s1492-006_diff] b 
	inner join tblПоставки p 
		on	p.Код_поставщика + '-'+ p.Код_поставки = b.BATCH 
			and p.ID =  b.idnumber
			and p.Решение_по_поставке = 1
	inner join tblСпектр s 
		on	s.Код_tblПоставки_rev = p.Код 
			and s.Тип_спектра = 'F' 
			and s.Результат = 'OK'
			and s.[Растворитель для спектра] like '%DMSO%'
	inner join tbl_Фторные_сдвиги f on  f.Kod_Spectra = s.Код
group by b.IDNUMBER , b.BATCH, b.n
having COUNT(*) > 1
order by b.n;

select b.IDNUMBER , b.BATCH , b.n, s.Блок, f.Value as FShift 
from [_tmp_Packing_list_s1492-006_diff] b 
	inner join tblПоставки p 
		on	p.Код_поставщика + '-'+ p.Код_поставки = b.BATCH 
			and p.ID = b.idnumber
			and p.Решение_по_поставке = 1
	left join (tblСпектр s 	
					inner join (select ID , Код, ROW_NUMBER() over( partition by ID order by [Дата] desc, [Код] desc) as rn
								from tblСпектр 
								where Тип_спектра ='F'
									   and Результат = 'OK' 
									   and ID in (select ID from [_tmp_Packing_list_s1492-006_diff])
								) x on x.Код = s.Код and x.rn = 1
		  )
		on	s.Код_tblПоставки_rev = p.Код 
			and s.Тип_спектра = 'F' 
			and s.Результат = 'OK'
			and s.[Растворитель для спектра] like '%DMSO%'
	left join tbl_Фторные_сдвиги f on  f.Kod_Spectra = s.Код
order by b.n;

-- нема зсувів, але є F-спектри
select * from #selected_fshift where ID = 'F1826-0052'
select t.ID,  s.Блок 
from #selected_fshift t
	inner join tblСпектр s on s.ID = t.ID 
	inner join tblПоставки p on p.Код = s.Код_tblПоставки_rev 
	left join tbl_Фторные_сдвиги f on  f.Kod_Spectra = s.Код
 where  t.FShift is null
	 and s.Тип_спектра = 'F'
	 and s.Результат = 'OK'
	 and p.Решение_по_поставке = 1			
	 and s.[Растворитель для спектра] like '%DMSO%'
	 and f.Kod_Spectra is null
order by s.Блок  ;

-- нема зсувів, нема F-спектрів
select t.ID, c.*
from #selected_fshift t
	left join (tblСпектр s 
	inner join tblПоставки p on p.Код = s.Код_tblПоставки_rev )on s.ID = t.ID 
		 and s.Тип_спектра = 'F'
		 and s.Результат = 'OK'
		 and p.Решение_по_поставке = 1			
		 and s.[Растворитель для спектра] like '%DMSO%' 
	left join  dbo.[_tmp_Packing_list_s1492-006_coctail2017] c on c.ID = t.ID
where  t.FShift is null
	and s.Блок is null;
	
select * from dbo.[_tmp_Packing_list_s1492-006_coctail2017]	
go

/********************* Final countdown ************************/
/***
1) Сдвиги в ДМСО для приложенного списка 1050 поставок.
2) Остальные сдвиги (т.е. не в ДМСО) для приложенного списка 1050 поставок.
3) Сдвиги в ДМСО для последней/свежайшей поставки (но только для поставок, которые имели или имеют решение Склад).
4) Остальные сдвиги (т.е. не в ДМСО) для последней/свежайшей поставки (но только для поставок, которые имели или имеют решение Склад).
*/
declare @ShiftTablePostDMSO table(ID varchar(10), N int, FShift varchar(255));
declare @ShiftTablePostNotDMSO table(ID varchar(10), N int, FShift varchar(255));
declare @ShiftTableOtherDMSO table(ID varchar(10), N int, FShift varchar(255));
declare @ShiftTableOtherNotDMSO table(ID varchar(10), N int, FShift varchar(255));

insert into @ShiftTablePostDMSO
select t.ID
	, t.N
	, case when COUNT(*) <=1
		then cast(MIN(x.Value) AS varchar(255))
		else [dbo].fn_get_fshift_string(x.Код)
		end as FShift
from [_tmp_Packing_list_s1492-006] t
	inner join (select b.IDNUMBER as ID , z.Код , z.Value
				from [_tmp_Packing_list_s1492-006_batch] b 
					inner join tblПоставки p 
						on	p.Код_поставщика = b.POS 
							and p.Код_поставки = b.post 
							and p.ID =  b.idnumber
--							and p.Решение_по_поставке = 1
					inner join (select s.Код
									, s.Код_tblПоставки_rev
									, ROW_NUMBER() over( partition by Код_tblПоставки_rev, s.ID order by s.[Дата] desc, s.[Код] desc) as rn 
									, f.Value
								from  tblСпектр s 
									inner join tbl_Фторные_сдвиги f on  f.Kod_Spectra = s.Код
								where s.Тип_спектра = 'F' 
										and s.Результат = 'OK'
										and s.[Растворитель для спектра] like '%DMSO%'
										and f.Value is not null
								) z
						on	z.Код_tblПоставки_rev = p.Код  and z.rn = 1
				) x on x.ID = t.ID
group by t.ID, t.N, x.Код
order by t.N							
;
	
insert into @ShiftTablePostNotDMSO
select t.ID
	, t.N
	, case when COUNT(*) <=1
		then cast(MIN(x.Value) AS varchar(255))
		else [dbo].fn_get_fshift_string(x.Код)
		end as FShift
from [_tmp_Packing_list_s1492-006] t
	inner join (	select b.IDNUMBER as ID , z.Код , z.Value
				from [_tmp_Packing_list_s1492-006_batch] b 
					inner join tblПоставки p 
						on	p.Код_поставщика = b.POS 
							and p.Код_поставки = b.post 
							and p.ID =  b.idnumber
--							and p.Решение_по_поставке = 1
					inner join (select s.Код
									, s.Код_tblПоставки_rev
									, ROW_NUMBER() over( partition by Код_tblПоставки_rev, s.ID order by s.[Дата] desc, s.[Код] desc) as rn 
									, f.Value
								from  tblСпектр s 
									inner join tbl_Фторные_сдвиги f on  f.Kod_Spectra = s.Код
								where s.Тип_спектра = 'F' 
										and s.Результат = 'OK'
										and s.[Растворитель для спектра] not like '%DMSO%'
										and f.Value is not null
								) z
						on	z.Код_tblПоставки_rev = p.Код  and z.rn = 1
				) x on x.ID = t.ID
group by t.ID, t.N, x.Код
order by t.N							
;
insert into @ShiftTableOtherDMSO
select t.ID
	, t.N
	, case when COUNT(*) <=1
		then cast(MIN(x.Value) AS varchar(255))
		else [dbo].fn_get_fshift_string(x.Код)
		end as FShift
from [_tmp_Packing_list_s1492-006] t
	inner join (select b.IDNUMBER as ID , z.Код , z.Value
				from [_tmp_Packing_list_s1492-006_batch] b 
					inner join tblПоставки p 
						on	p.ID =  b.idnumber 
							and p.Решение_по_поставке = 1
							and (p.Код_поставщика != b.POS 
								or p.Код_поставки != b.post
								)
					inner join (select s.Код
									, s.Код_tblПоставки_rev
									, ROW_NUMBER() over( partition by Код_tblПоставки_rev, s.ID order by s.[Дата] desc, s.[Код] desc) as rn 
									, f.Value
								from  tblСпектр s 
									inner join tbl_Фторные_сдвиги f on  f.Kod_Spectra = s.Код
								where s.Тип_спектра = 'F' 
										and s.Результат = 'OK'
										and s.[Растворитель для спектра] like '%DMSO%'
										and f.Value is not null
								) z
						on	z.Код_tblПоставки_rev = p.Код  and z.rn = 1
				) x on x.ID = t.ID
group by t.ID, t.N, x.Код
order by t.N							
;
insert into @ShiftTableOtherNotDMSO
select t.ID
	, t.N
	, case when COUNT(*) <=1
		then cast(MIN(x.Value) AS varchar(255))
		else [dbo].fn_get_fshift_string(x.Код)
		end as FShift
from [_tmp_Packing_list_s1492-006] t
	inner join (select b.IDNUMBER as ID , z.Код , z.Value
				from [_tmp_Packing_list_s1492-006_batch] b 
					inner join tblПоставки p 
						on	p.ID =  b.idnumber 
							and p.Решение_по_поставке = 1
							and (p.Код_поставщика != b.POS 
								or p.Код_поставки != b.post
								)
					inner join (select s.Код
									, s.Код_tblПоставки_rev
									, ROW_NUMBER() over( partition by Код_tblПоставки_rev, s.ID order by s.[Дата] desc, s.[Код] desc) as rn 
									, f.Value
								from  tblСпектр s 
									inner join tbl_Фторные_сдвиги f on  f.Kod_Spectra = s.Код
								where s.Тип_спектра = 'F' 
										and s.Результат = 'OK'
										and s.[Растворитель для спектра] not like '%DMSO%'
										and f.Value is not null
								) z
						on	z.Код_tblПоставки_rev = p.Код  and z.rn = 1
				) x on x.ID = t.ID
group by t.ID, t.N, x.Код
order by t.N							
;

select pl.ID, pb.BATCH
	, x1.FShift as FShiftPostDMSO
	, x2.FShift as FShiftPostNotDMSO
	, x3.FShift as FShiftOtherDMSO
	, x4.FShift as FShiftOtherNotDMSO
from [_tmp_Packing_list_s1492-006] pl
	inner join [_tmp_Packing_list_s1492-006_batch] pb on pb.IDNUMBER = pl.ID 
	left join @ShiftTablePostDMSO x1 on x1.ID = pl.ID and x1.N = pl.N	
	left join @ShiftTablePostNotDMSO x2 on x2.ID = pl.ID and x2.N = pl.N	
	left join @ShiftTableOtherDMSO x3 on x3.ID = pl.ID and x3.N = pl.N	
	left join @ShiftTableOtherNotDMSO x4 on x4.ID = pl.ID and x4.N = pl.N	
order by pl.N ;