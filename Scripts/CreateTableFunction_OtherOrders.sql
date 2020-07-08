-- ================================================
-- Template generated from Template Explorer using:
-- Create Multi-Statement Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		V.Zatkhey
-- Create date: 20.02.2020
-- Description:	������� ���� ����� ������
-- =============================================
CREATE FUNCTION ft_OtherOrders 
(
)
RETURNS 
@OtherZ TABLE 
(
	id int
	, IDNUMBER nvarchar(10)
	, CustomerCode nvarchar(5)
	, OrderCode nvarchar(6)
	, OtherOrders nvarchar(max)
)
AS
BEGIN
	declare @cnt int;

	insert into  @OtherZ
	select ���_ID, ID, ���_���������, ���_������
	 , ''
	from tbl������������� sz
	where exists(select * from tbl������������� where ID = sz.ID and (���_��������� != sz.���_��������� or ���_������ != sz.���_������));

	select @cnt=COUNT(*) from @OtherZ;

	while @cnt > 0
		begin
		
		update @OtherZ
		set OtherOrders = OtherOrders +' '+ x.OrderCode
		from @OtherZ o
			inner join (
						select t1.id, sz.ID as IDNUMBER
							, sz.���_��������� + '-' + sz.���_������ as OrderCode
							, ROW_NUMBER() over(PARTITION by t1.id, t1.IDNUMBER order by sz.���_���������, sz.���_������) as num
						from @OtherZ t1
							 inner join tbl������������� sz on sz.ID = t1.IDNUMBER 
								and( sz.���_��������� != t1.CustomerCode or sz.���_������ != t1.OrderCode)
								and t1.OtherOrders not like '%'+ sz.���_��������� + '-' + sz.���_������ +'%'
						) x on x.id = o.id and x.num = 1;
						
		select @cnt = COUNT(*) 
		from @OtherZ o 
		where exists(select * 
					 from	tbl������������� 
					 where	ID = o.IDNUMBER 
							and ���_ID != o.id
							and o.OtherOrders not like '%'+ ���_��������� + '-' + ���_������ +'%');
							
		end
	RETURN 
END
GO