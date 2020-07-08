use SKLAD30;

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		V.Zatkhey
-- Create date: 02.11.2018
-- Description:	���� ������ ������� ������� ���� ����������, ������� ������ (���� � ��� ���) �� ������� ��������
-- =============================================
--CREATE TRIGGER TR_LowerLimit_Sklad30__������ 
alter TRIGGER TR_LowerLimit_Sklad30__������ 
   ON  [__������] 
   AFTER INSERT,UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

--print 'TR_LowerLimit. I"m here!';

if exists(	select * 
			from inserted i
				inner join __������� p on p.���_ID = i.���_ID_������� 
				inner join LowerLimit l on l.StoreID = p.���_� and  l.SubstanceID = p.���_ID_��������
		  )
	begin
	
--	print 'TR_LowerLimit. Go!';

	if exists(	
				select l.ID
				from dbo.LowerLimit l 
					left join
					( select pr.���_� as StoreID, p.[���_ID_��������] as SubstanceID
						  , sum(p.[�������_0]) as Qnt
					   from [�������_��_��������] p
						inner join __������� pr on pr.���_ID = p.���_ID
					  where [�������_0]<>0
					  group by p.[���_ID_��������], pr.���_�)x on x.SubstanceID = l.SubstanceID and l.StoreID = x.StoreID
				where l.LimitQnt > x.Qnt
			 )	
		begin
		
--		print 'TR_LowerLimit. Insert!';
		--insert into
		INSERT INTO [__������] ([���_������������], [���_ID_��������], [CAS2], [���]
							  , [���-��], [��� SKB], [��_���]
							  , [����������], [Session_ID], [���_�], [���_���������]
							  , [�������_��������]) 
		select c.���_������������, p.���_ID_��������, null, pl.�������� as [���]
			, 0, l.OrderQnt, p.UM 
			, '������ ������������ �������������', v.Session_ID, v.���_�, '00000'
			, s.�������_��������
		from  inserted v
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
		where l.LimitQnt > isnull(x.Qnt,0)
			and not exists(	select * from [__������] z 
							where z.���_� = v.���_� 
									and z.���_ID_�������� = p.���_ID_��������
									and z.������ < 50 -- "��������" - ������ ������� ��� �� ������ ���� � ���� ���������� 
							)
		end
	end
	

END
GO
