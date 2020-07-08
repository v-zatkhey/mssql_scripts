select s.IDNUMBER0, s.CAS,p.���_ID, p.���_ID_��������, v.* 
from __������ v
	inner join __������� p on p.���_ID = v.���_ID_�������
	inner join __�������� s on s.���_ID = p.���_ID_��������
where s.CAS = '811-98-3' -- in  ('811-98-3','1076-43-3','865-49-6')	
	and v.���_ID_������� in (38929,40322,36610,40321)
order by v.���� desc

/*
 ([���_������������], [���_ID_��������], [CAS2], [���], [���-��], [��� SKB], [��_���]
							  , [���_ID_���������], [����_end], [����������], [Session_ID], [���_�], [���_���������]
							  , [���_������], [�������_��������]) 
*/

select top 10 c.���_������������, p.���_ID_��������, null, pl.�������� as [���], 0 --, l.OrderQnt, p.UM 
	, null, null, '������ ������������ �������������', v.Session_ID, v.���_�, '00000'
	, null, s.�������_��������
	, v.*
--s.IDNUMBER0, s.CAS, p.���_ID, p.���_ID_��������, p.Qty, p.Size, p.UM, v.������
from  __������ v
	inner join __������� p on p.���_ID = v.���_ID_������� 
--	inner join LowerLimit l on l.StoreID = v.���_� and l.SubstanceID = p.���_ID_��������
	inner join __�������� s on s.���_ID = p.���_ID_��������
	inner join ������ c on c.��� = v.Session_ID
	inner join ������������ pl on pl.��� = c.���_������������
where p.���_ID_�������� = 13290
order by v.���� desc

select top 5 * from __������ where ���_ID_�������� = 13290
select top  * from __������ where ���_��������� like  '%00000%'

select * from ������������ where ��� = 165
select * from ������ where ���_������������ = 165


select * from __���������
SELECT [���_ID]
      ,[������]
      ,[����������]
  FROM [SKLAD30].[dbo].[__������_�������]
GO

select top 20 * from __������ where ���_ID_�������� = 13290 and ������ < 50

select *
from  __�������� s 
where s.CAS in ('811-98-3','1076-43-3','865-49-6')	

select *
from  ������ s 

select ������, * from  __������ v where v.���_ID = 150526;
update  v set ������ = ������ from __������ v where v.���_ID = 150526;

		select c.���_������������, p.���_ID_��������, null, pl.�������� as [���]
			, 0, l.OrderQnt, p.UM 
			, '������ ������������ �������������', v.Session_ID, v.���_�, '00000'
			, s.�������_��������
		from  __������ v
			inner join __������� p on p.���_ID = v.���_ID_������� 
			inner join LowerLimit l on l.StoreID = v.���_� and l.SubstanceID = p.���_ID_��������
			inner join __�������� s on s.���_ID = p.���_ID_��������
			inner join ������ c on c.��� = v.Session_ID
			inner join ������������ pl on pl.��� = c.���_������������
			left join
				( select pr.���_� as StoreID, p.[���_ID_��������] as SubstanceID, sum(p.[�������_0]) as Qnt
				  from [�������_��_��������] p
					inner join __������� pr on pr.���_ID = p.���_ID
				  where [�������_0]<>0
				  group by p.[���_ID_��������], pr.���_�)x on x.SubstanceID = l.SubstanceID and l.StoreID = x.StoreID
		where v.���_ID = 150526
			and l.LimitQnt > isnull(x.Qnt,0)
			and not exists(	select * from [__������] z 
							where z.���_� = v.���_� 
									and z.���_ID_�������� = p.���_ID_��������
									and z.������ < 50
							)