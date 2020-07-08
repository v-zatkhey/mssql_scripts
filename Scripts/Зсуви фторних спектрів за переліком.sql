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
	  FROM tbl_�������_������ f
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

select distinct s.[������������ ��� �������] from  tbl������ s 
where s.���_������� = 'F'
	and s.��������� = 'OK'

select b.* , f.Value 
from [_tmp_Packing_list_s1492-006_batch] b 
	inner join tbl�������� p 
		on	p.���_���������� = b.POS 
			and p.���_�������� = b.post 
			and p.ID =  b.idnumber
			and p.�������_��_�������� = 1
	inner join tbl������ s 
		on	s.���_tbl��������_rev = p.��� 
			and s.���_������� = 'F' 
			and s.��������� = 'OK'
			and s.[������������ ��� �������] like '%DMSO%'
	inner join tbl_�������_������ f on  f.Kod_Spectra = s.���
order by b.idnumber;

-- drop table #selected_fshift;	
select t.ID
	, t.N
	, x.��� as PostSpectraID
	, y.��� as OtherSpectraID
	, case when COUNT(*) <=1
		then cast(MIN(isnull(x.Value,y.Value)) AS varchar(255))
		else [dbo].fn_get_fshift_string(isnull(x.���,y.���))
		end as FShift
into #selected_fshift
from [dbo].[_tmp_Packing_list_s1492-006] t
	left join (	select b.IDNUMBER as ID , z.��� , f.Value
				from [_tmp_Packing_list_s1492-006_batch] b 
					inner join tbl�������� p 
						on	p.���_���������� = b.POS 
							and p.���_�������� = b.post 
							and p.ID =  b.idnumber
							and p.�������_��_�������� = 1
					inner join (select s.���
									,s.���_tbl��������_rev
									, ROW_NUMBER() over( partition by s.ID order by s.[����] desc, s.[���] desc) as rn 
								from  tbl������ s 
								where s.���_������� = 'F' 
										and s.��������� = 'OK'
										and s.[������������ ��� �������] like '%DMSO%'
								) z
						on	z.���_tbl��������_rev = p.���  and z.rn = 1
					inner join tbl_�������_������ f on  f.Kod_Spectra = z.���
				) x on x.ID = t.ID
	left join ( select zz.ID , zz.��� , f.Value
				from (	select s.���
							, s.ID 
							, s.���_tbl��������_rev
							, ROW_NUMBER() over( partition by s.ID order by s.[����] desc, s.[���] desc) as rn 
						from  tbl������ s 
						where s.���_������� = 'F' 
								and s.��������� = 'OK'
								and s.[������������ ��� �������] like '%DMSO%'
						) zz  
					inner join tbl_�������_������ f on  f.Kod_Spectra = zz.��� and zz.rn = 1
					inner join tbl�������� p on p.��� = zz.���_tbl��������_rev 
				 where  p.�������_��_�������� = 1									-- �����
				) y on y.ID = t.ID 
--where t.ID in ('F1826-0052')
group by t.ID, t.N, x.���, y.���
order by t.N
;

select * from tbl_�������_������ --where Kod_Spectra = 1403308;
select b.IDNUMBER as ID , s.��� , f.Value
					  , ROW_NUMBER() over( partition by s.ID order by s.[����] desc, s.[���] desc) as rn 
				from [_tmp_Packing_list_s1492-006_batch] b 
					inner join tbl�������� p 
						on	p.���_���������� = b.POS 
							and p.���_�������� = b.post 
							and p.ID =  b.idnumber
							and p.�������_��_�������� = 1
					inner join tbl������ s 
						on	s.���_tbl��������_rev = p.��� 
							and s.���_������� = 'F' 
							and s.��������� = 'OK'
							and s.[������������ ��� �������] like '%DMSO%'
					inner join tbl_�������_������ f on  f.Kod_Spectra = s.���
where b.idnumber in ('F1826-0052')					
					
select b.IDNUMBER , b.BATCH , COUNT(*) 
from [_tmp_Packing_list_s1492-006_diff] b 
	inner join tbl�������� p 
		on	p.���_���������� + '-'+ p.���_�������� = b.BATCH 
			and p.ID =  b.idnumber
			and p.�������_��_�������� = 1
	inner join tbl������ s 
		on	s.���_tbl��������_rev = p.��� 
			and s.���_������� = 'F' 
			and s.��������� = 'OK'
			and s.[������������ ��� �������] like '%DMSO%'
	inner join tbl_�������_������ f on  f.Kod_Spectra = s.���
group by b.IDNUMBER , b.BATCH, b.n
having COUNT(*) > 1
order by b.n;

select b.IDNUMBER , b.BATCH , b.n, s.����, f.Value as FShift 
from [_tmp_Packing_list_s1492-006_diff] b 
	inner join tbl�������� p 
		on	p.���_���������� + '-'+ p.���_�������� = b.BATCH 
			and p.ID = b.idnumber
			and p.�������_��_�������� = 1
	left join (tbl������ s 	
					inner join (select ID , ���, ROW_NUMBER() over( partition by ID order by [����] desc, [���] desc) as rn
								from tbl������ 
								where ���_������� ='F'
									   and ��������� = 'OK' 
									   and ID in (select ID from [_tmp_Packing_list_s1492-006_diff])
								) x on x.��� = s.��� and x.rn = 1
		  )
		on	s.���_tbl��������_rev = p.��� 
			and s.���_������� = 'F' 
			and s.��������� = 'OK'
			and s.[������������ ��� �������] like '%DMSO%'
	left join tbl_�������_������ f on  f.Kod_Spectra = s.���
order by b.n;

-- ���� �����, ��� � F-�������
select * from #selected_fshift where ID = 'F1826-0052'
select t.ID,  s.���� 
from #selected_fshift t
	inner join tbl������ s on s.ID = t.ID 
	inner join tbl�������� p on p.��� = s.���_tbl��������_rev 
	left join tbl_�������_������ f on  f.Kod_Spectra = s.���
 where  t.FShift is null
	 and s.���_������� = 'F'
	 and s.��������� = 'OK'
	 and p.�������_��_�������� = 1			
	 and s.[������������ ��� �������] like '%DMSO%'
	 and f.Kod_Spectra is null
order by s.����  ;

-- ���� �����, ���� F-�������
select t.ID, c.*
from #selected_fshift t
	left join (tbl������ s 
	inner join tbl�������� p on p.��� = s.���_tbl��������_rev )on s.ID = t.ID 
		 and s.���_������� = 'F'
		 and s.��������� = 'OK'
		 and p.�������_��_�������� = 1			
		 and s.[������������ ��� �������] like '%DMSO%' 
	left join  dbo.[_tmp_Packing_list_s1492-006_coctail2017] c on c.ID = t.ID
where  t.FShift is null
	and s.���� is null;
	
select * from dbo.[_tmp_Packing_list_s1492-006_coctail2017]	
go

/********************* Final countdown ************************/
/***
1) ������ � ���� ��� ������������ ������ 1050 ��������.
2) ��������� ������ (�.�. �� � ����) ��� ������������ ������ 1050 ��������.
3) ������ � ���� ��� ���������/��������� �������� (�� ������ ��� ��������, ������� ����� ��� ����� ������� �����).
4) ��������� ������ (�.�. �� � ����) ��� ���������/��������� �������� (�� ������ ��� ��������, ������� ����� ��� ����� ������� �����).
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
		else [dbo].fn_get_fshift_string(x.���)
		end as FShift
from [_tmp_Packing_list_s1492-006] t
	inner join (select b.IDNUMBER as ID , z.��� , z.Value
				from [_tmp_Packing_list_s1492-006_batch] b 
					inner join tbl�������� p 
						on	p.���_���������� = b.POS 
							and p.���_�������� = b.post 
							and p.ID =  b.idnumber
--							and p.�������_��_�������� = 1
					inner join (select s.���
									, s.���_tbl��������_rev
									, ROW_NUMBER() over( partition by ���_tbl��������_rev, s.ID order by s.[����] desc, s.[���] desc) as rn 
									, f.Value
								from  tbl������ s 
									inner join tbl_�������_������ f on  f.Kod_Spectra = s.���
								where s.���_������� = 'F' 
										and s.��������� = 'OK'
										and s.[������������ ��� �������] like '%DMSO%'
										and f.Value is not null
								) z
						on	z.���_tbl��������_rev = p.���  and z.rn = 1
				) x on x.ID = t.ID
group by t.ID, t.N, x.���
order by t.N							
;
	
insert into @ShiftTablePostNotDMSO
select t.ID
	, t.N
	, case when COUNT(*) <=1
		then cast(MIN(x.Value) AS varchar(255))
		else [dbo].fn_get_fshift_string(x.���)
		end as FShift
from [_tmp_Packing_list_s1492-006] t
	inner join (	select b.IDNUMBER as ID , z.��� , z.Value
				from [_tmp_Packing_list_s1492-006_batch] b 
					inner join tbl�������� p 
						on	p.���_���������� = b.POS 
							and p.���_�������� = b.post 
							and p.ID =  b.idnumber
--							and p.�������_��_�������� = 1
					inner join (select s.���
									, s.���_tbl��������_rev
									, ROW_NUMBER() over( partition by ���_tbl��������_rev, s.ID order by s.[����] desc, s.[���] desc) as rn 
									, f.Value
								from  tbl������ s 
									inner join tbl_�������_������ f on  f.Kod_Spectra = s.���
								where s.���_������� = 'F' 
										and s.��������� = 'OK'
										and s.[������������ ��� �������] not like '%DMSO%'
										and f.Value is not null
								) z
						on	z.���_tbl��������_rev = p.���  and z.rn = 1
				) x on x.ID = t.ID
group by t.ID, t.N, x.���
order by t.N							
;
insert into @ShiftTableOtherDMSO
select t.ID
	, t.N
	, case when COUNT(*) <=1
		then cast(MIN(x.Value) AS varchar(255))
		else [dbo].fn_get_fshift_string(x.���)
		end as FShift
from [_tmp_Packing_list_s1492-006] t
	inner join (select b.IDNUMBER as ID , z.��� , z.Value
				from [_tmp_Packing_list_s1492-006_batch] b 
					inner join tbl�������� p 
						on	p.ID =  b.idnumber 
							and p.�������_��_�������� = 1
							and (p.���_���������� != b.POS 
								or p.���_�������� != b.post
								)
					inner join (select s.���
									, s.���_tbl��������_rev
									, ROW_NUMBER() over( partition by ���_tbl��������_rev, s.ID order by s.[����] desc, s.[���] desc) as rn 
									, f.Value
								from  tbl������ s 
									inner join tbl_�������_������ f on  f.Kod_Spectra = s.���
								where s.���_������� = 'F' 
										and s.��������� = 'OK'
										and s.[������������ ��� �������] like '%DMSO%'
										and f.Value is not null
								) z
						on	z.���_tbl��������_rev = p.���  and z.rn = 1
				) x on x.ID = t.ID
group by t.ID, t.N, x.���
order by t.N							
;
insert into @ShiftTableOtherNotDMSO
select t.ID
	, t.N
	, case when COUNT(*) <=1
		then cast(MIN(x.Value) AS varchar(255))
		else [dbo].fn_get_fshift_string(x.���)
		end as FShift
from [_tmp_Packing_list_s1492-006] t
	inner join (select b.IDNUMBER as ID , z.��� , z.Value
				from [_tmp_Packing_list_s1492-006_batch] b 
					inner join tbl�������� p 
						on	p.ID =  b.idnumber 
							and p.�������_��_�������� = 1
							and (p.���_���������� != b.POS 
								or p.���_�������� != b.post
								)
					inner join (select s.���
									, s.���_tbl��������_rev
									, ROW_NUMBER() over( partition by ���_tbl��������_rev, s.ID order by s.[����] desc, s.[���] desc) as rn 
									, f.Value
								from  tbl������ s 
									inner join tbl_�������_������ f on  f.Kod_Spectra = s.���
								where s.���_������� = 'F' 
										and s.��������� = 'OK'
										and s.[������������ ��� �������] not like '%DMSO%'
										and f.Value is not null
								) z
						on	z.���_tbl��������_rev = p.���  and z.rn = 1
				) x on x.ID = t.ID
group by t.ID, t.N, x.���
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