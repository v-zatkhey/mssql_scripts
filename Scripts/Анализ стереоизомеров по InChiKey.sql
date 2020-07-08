exec sp_who active

--kill 203

select * from dbo.MaterialChiral where MatID1 = 4456296
select MatID1, COUNT(*) from dbo.MaterialChiral 
group by MatID1
order by COUNT(*) desc

select mc.* , m1.MatName as ID1, m2.MatName as ID2, m1.InChiKey_without_Salt as inch1, m2.InChiKey_without_Salt as inch2
from dbo.MaterialChiral mc
	inner join Materials m1 on m1.MatID = mc.MatID1
	inner join Materials m2 on m2.MatID = mc.MatID2
where mc.MatID1 = 4456296

select * from Materials where InChiKey_without_Salt = 'YRGRLZXBOJQQDP-ZXZARUISNA-N'

select LEFT(InChiKey_without_Salt,14), count(*)
from Materials 
group by LEFT(InChiKey_without_Salt,14)
having COUNT(*) > 1
order by COUNT(*) desc

select LEFT(InChiKey_with_Salt,14), count(*) as Cnt
from Materials 
group by LEFT(InChiKey_with_Salt,14)
having COUNT(*) > 1
order by COUNT(*) desc


select *
from Materials 
where LEFT(InChiKey_without_Salt,14) = 'OVKIDXBGVUQFFC'
select *
from Materials 
where LEFT(InChiKey_with_Salt,14) = 'UBNFFYBUWLQVGW'

select *
from Materials 
where InChiKey_with_Salt is null


select *
--delete 
from Materials 
where not MatName like 'F____-____'

select  mc.*
from Materials m1
	inner join (select  LEFT(InChiKey_without_Salt,14) as InChiKey_without_Salt
					, count(*) as Cnt
				from Materials 
				group by  LEFT(InChiKey_without_Salt,14)
				having COUNT(*) > 1) x on x.InChiKey_without_Salt = LEFT(m1.InChiKey_without_Salt,14)
	inner join Materials m2 on  x.InChiKey_without_Salt = LEFT(m2.InChiKey_without_Salt,14) and m1.MatID<>m2.MatID ---????
	right outer join dbo.MaterialChiral mc on mc.MatID1 = m1.MatID and mc.MatID2 = m2.MatID 
where m1.MatID is null
order by x.Cnt desc, m1.MatID, m2.MatID


select m1.MatID as MatID1, m2.MatID as MatID2, m1.MatName as ID1, m2.MatName as ID2, m1.ChiralName, m2.ChiralName
	, x.Cnt 
--	, mc.*, count(mc.MaterialChiralID) over(partition by 1)
from Materials m1
	inner join (select  LEFT(InChiKey_without_Salt,14) as InChiKey_without_Salt
					, count(*) as Cnt
				from Materials 
				group by  LEFT(InChiKey_without_Salt,14)
				having COUNT(*) > 1) x on x.InChiKey_without_Salt = LEFT(m1.InChiKey_without_Salt,14)
	inner join Materials m2 on  x.InChiKey_without_Salt = LEFT(m2.InChiKey_without_Salt,14) and m1.InChiKey_without_Salt != m2.InChiKey_without_Salt
	left outer join dbo.MaterialChiral mc on mc.MatID1 = m1.MatID and mc.MatID2 = m2.MatID 
where ISNULL( m1.ChiralName,'') != ISNULL( m2.ChiralName,'')
	and mc.MaterialChiralID is null
order by x.Cnt desc, x.InChiKey_without_Salt, m1.MatID, m2.MatID

select InChiKey_without_Salt, InChiKey_with_Salt
	, count(*) as Cnt
from Materials 
group by  InChiKey_without_Salt, InChiKey_with_Salt
having COUNT(*) > 1
order by COUNT(*)desc

select *
from Materials 
where InChiKey_with_Salt = 'RPEJKVRRTJDBSN-UHFFFAOYSA-N'
