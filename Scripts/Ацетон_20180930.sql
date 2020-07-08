use SKLAD30;
go
declare @AcetonCodeID int, @material_id int, @store_id int
select @store_id = 8;
select @AcetonCodeID = ���_ID from __�������� where CAS = '67-64-1' and ���_�  = @store_id;
select @material_id = @AcetonCodeID;

	select ps.*
		, ps.����
		, ps.���_ID
		, p.���_ID  as ���_ID__�������
		, p.Size * p.Qty as Volume
		, p.Size * p.Qty as VolIn
		, p.*
	from __������� p 
		left join __�������� ps on ps.���_ID = p.���_ID_��������
	where p.���_ID_�������� = @material_id
		and ps.���� > '20180901'

	-- ������	
	SELECT  v.����  
		, v.���_ID
		, v.���_��������� as ClientCode
		, v.���_������ as OrderCode
		, v.SInfoNUMBER
		, pt.[������ �������� �����������] as CustName
		, v.*
	FROM       
	  [__�������] p
	  LEFT OUTER JOIN [__������] v  ON p.[���_ID] = v.[���_ID_�������]
	  LEFT OUTER JOIN dbo.[__�����������] pt ON (v.[���_ID_�����������] = pt.[���_ID])
	where ���_ID_�������� = @material_id 
		and p.���_� = @store_id
		and p.[���_ID]= 40130
		and v.���� >= '20181001'
		
	SELECT SUM( v.������ )
	FROM       
	  [__�������] p
	  inner JOIN [__������] v  ON p.[���_ID] = v.[���_ID_�������]
	where p.���_ID_�������� = @material_id 
		and p.���_� = @store_id
		--and p.[���_ID]= 40130
		--and v.���� between '20181001' and '20181005'
		and v.���_ID in (149593,149683,149686,149773,149778)
		
	SELECT p.���_ID 
		, v.����  
		, v.���_ID
		, v.���_��������� as ClientCode
		, v.���_������ as OrderCode
		, v.SInfoNUMBER
		, pt.[������ �������� �����������] as CustName
		, v.*
	FROM       
	  [__�������] p
	  LEFT OUTER JOIN [__������] v  ON p.[���_ID] = v.[���_ID_�������]
	  LEFT OUTER JOIN dbo.[__�����������] pt ON (v.[���_ID_�����������] = pt.[���_ID])
	where ���_ID_�������� = @material_id 
		and p.���_� = @store_id
		and p.[���_ID]= 40544
		

--select @AcetonCodeID;
go

select * from dbo.�������_��_�������� p where p.���_ID in (40130,40544)
begin tran

	alter table [__������] disable trigger TR_UPDATE_Sklad30___������;
	update 	v set [���_ID_�������] = 40544
		FROM  [__������] v  
		where  v.[���_ID_�������] = 40130
			and v.���_ID in (149593,149683,149686,149773,149778)
	alter table [__������] enable trigger TR_UPDATE_Sklad30___������;
commit -- rollback
select * from dbo.�������_��_�������� p where p.���_ID in (40130,40544)
go
