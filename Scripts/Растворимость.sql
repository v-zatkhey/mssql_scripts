use Chest35 ;
go

select * from dbo.Типы_растворимости_в_DMSO

-- MatName	PBS	Solubility_DMSO	Тип_растворимости
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
	, t.Тип_растворимости as Solubility_DMSO
from [Materials] m
	left join dbo.Типы_растворимости_в_DMSO t on t.Код = m.Solubility_DMSO
where (Solubility_DMSO is not null or [PBS] is not null)
order by m.[MatName];



select x.*, z.Фамилия, z.Имя, z.Отчество
from
(select t.IDNUMBER, p.Код_поставщика 
from _tmp_ID_list t 
	left join tblПоставки p on p.ID = t.IDNUMBER
where p.Решение_по_поставке = 1
	and not p.Код_поставщика in ('USA','EUR','JPN')
group by t.IDNUMBER,p.Код_поставщика  
) x
left join tblПоставщики_full z on x.Код_поставщика = z.Код_поставщика
order by x.IDNUMBER, x.Код_поставщика;


/****************/
-- за переліком
select 
	[MatName]
	--, cast(PBS as varchar(8)) as  [Solubility_PBS]
--	, Solubility_DMSO	as [Solubility_type]
	, t.Тип_растворимости as Solubility_DMSO
	, t2.Тип_растворимости as Solubility_DMSO_Km
from [Materials] m 
	left join dbo.Типы_растворимости_в_DMSO t on t.Код = m.Solubility_DMSO
	left join dbo.Типы_растворимости_в_DMSO t2 on t2.Код = m.Solubility_DMSO_Km
where t.Код is not null or t2.Код is not null
;
/*******************  "200mM і ДМСО" ****************/