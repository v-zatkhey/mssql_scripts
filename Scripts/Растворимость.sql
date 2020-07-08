use Chest35 ;
go

select * from dbo.����_�������������_�_DMSO

-- MatName	PBS	Solubility_DMSO	���_�������������
select 
	[MatName]
	, cast(PBS as varchar(8)) as  [Solubility_PBS]
	, Solubility_DMSO	as [Solubility_type]
	/*, case Solubility_DMSO 
			when 1 then '>= 150 mM'
			when 2 then '>= 15 mM AND < 150 mM'
			when 3 then '<15 mM'
			else ''
			end as [Solubility_DMSO]*/
	, t.���_������������� as Solubility_DMSO
from [Materials] m
	left join dbo.����_�������������_�_DMSO t on t.��� = m.Solubility_DMSO
where (Solubility_DMSO is not null or [PBS] is not null)
order by m.[MatName];



select x.*, z.�������, z.���, z.��������
from
(select t.IDNUMBER, p.���_���������� 
from _tmp_ID_list t 
	left join tbl�������� p on p.ID = t.IDNUMBER
where p.�������_��_�������� = 1
	and not p.���_���������� in ('USA','EUR','JPN')
group by t.IDNUMBER,p.���_����������  
) x
left join tbl����������_full z on x.���_���������� = z.���_����������
order by x.IDNUMBER, x.���_����������;


/****************/
-- �� ��������
select 
	[MatName]
	--, cast(PBS as varchar(8)) as  [Solubility_PBS]
--	, Solubility_DMSO	as [Solubility_type]
	, t.���_������������� as Solubility_DMSO
	, t2.���_������������� as Solubility_DMSO_Km
from [Materials] m 
	left join dbo.����_�������������_�_DMSO t on t.��� = m.Solubility_DMSO
	left join dbo.����_�������������_�_DMSO t2 on t2.��� = m.Solubility_DMSO_Km
where t.��� is not null or t2.��� is not null
;
/*******************  "200mM � ����" ****************/