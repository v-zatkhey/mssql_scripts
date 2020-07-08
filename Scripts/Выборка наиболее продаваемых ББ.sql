select COUNT(*) from [dbo].[_tmp_LIFECHEM_BB] ; --75025

select *
from tbl����������������� vz
	inner join _tmp_LIFECHEM_BB t on t.IDNUMBER = vz.ID 
	inner join tbl������ z on z.���_��������� = vz.���_��������� and z.���_������ = vz.���_������
where vz.���_�������� not in ('s997', 's998', 's999')
	and z.���� > '20140101'
	and t.IDNUMBER = 'F6170-0039'
order by t.IDNUMBER	
	;
go	
	
with SaleCount(ID , Cnt , SumMass ) 
as 	(
select 
	t.IDNUMBER
	, COUNT(*) as Cnt
	, round(SUM(vz.�����),2) as SumMass
--	, round(sum(vz.����_���������),2)  as Amount
from tbl����������������� vz
	inner join _tmp_LIFECHEM_BB t on t.IDNUMBER = vz.ID 
	inner join tbl������ z on z.���_��������� = vz.���_��������� and z.���_������ = vz.���_������
where vz.���_�������� not in ('s997', 's998', 's999')
	and z.���_��������� not in ('90122','00122','00794','00795',
								'00401',
								'00402',
								'00403',
								'00404',
								'00405',
								'00406',
								'00407',
								'00408',
								'00409',
								'00410'
								)
	and z.���� > '20140101'
	and vz.����� >= 250
group by t.IDNUMBER	
)

select top 1000 
	s.ID
	, m.CASNumber
	, m.IUPAC_Name
	, lc.����� as LC_mass
	, s.Cnt as SaleCount 
	, s.SumMass as SaleMass
from  SaleCount s
	inner join Materials m on m.MatName = s.ID
	left join tbl�����_LC lc on lc.ID = s.ID 
where ISNULL(lc.�����,0)>0	
order by 	s.Cnt desc;
			
