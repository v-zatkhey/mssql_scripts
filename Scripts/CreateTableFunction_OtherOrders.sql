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
-- Description:	повертає коди інших заказів
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
	select Код_ID, ID, Код_заказчика, Код_заказа
	 , ''
	from tblСписокЗаказов sz
	where exists(select * from tblСписокЗаказов where ID = sz.ID and (Код_заказчика != sz.Код_заказчика or Код_заказа != sz.Код_заказа));

	select @cnt=COUNT(*) from @OtherZ;

	while @cnt > 0
		begin
		
		update @OtherZ
		set OtherOrders = OtherOrders +' '+ x.OrderCode
		from @OtherZ o
			inner join (
						select t1.id, sz.ID as IDNUMBER
							, sz.Код_заказчика + '-' + sz.Код_заказа as OrderCode
							, ROW_NUMBER() over(PARTITION by t1.id, t1.IDNUMBER order by sz.Код_заказчика, sz.Код_заказа) as num
						from @OtherZ t1
							 inner join tblСписокЗаказов sz on sz.ID = t1.IDNUMBER 
								and( sz.Код_заказчика != t1.CustomerCode or sz.Код_заказа != t1.OrderCode)
								and t1.OtherOrders not like '%'+ sz.Код_заказчика + '-' + sz.Код_заказа +'%'
						) x on x.id = o.id and x.num = 1;
						
		select @cnt = COUNT(*) 
		from @OtherZ o 
		where exists(select * 
					 from	tblСписокЗаказов 
					 where	ID = o.IDNUMBER 
							and Код_ID != o.id
							and o.OtherOrders not like '%'+ Код_заказчика + '-' + Код_заказа +'%');
							
		end
	RETURN 
END
GO