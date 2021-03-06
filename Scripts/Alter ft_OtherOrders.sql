USE [Chest35]
GO
/****** Object:  UserDefinedFunction [dbo].[ft_OtherOrders]    Script Date: 02/20/2020 12:37:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		V.Zatkhey
-- Create date: 20.02.2020
-- Description:	повертає коди інших заказів
-- =============================================
ALTER FUNCTION [dbo].[ft_OtherOrders] 
(
)
RETURNS 
@OtherZ TABLE 
(
	 IDNUMBER nvarchar(10)
	, OtherOrders nvarchar(max)
)
AS
BEGIN
	declare @cnt int;

	insert into  @OtherZ
	select sz.ID, ''
	from tblСписокЗаказов sz
	group by sz.ID;

	select @cnt=COUNT(*) from @OtherZ;

	while @cnt > 0
		begin
		
		update @OtherZ
		set OtherOrders = OtherOrders +' '+ x.OrderCode + '('+ x.SendCode+ '),' 
		from @OtherZ o
			inner join (
						select sz.ID as IDNUMBER
							, sz.Код_заказчика + '-' + sz.Код_заказа as OrderCode
							, sz.Код_отправки as SendCode 
							, ROW_NUMBER() over(PARTITION by t1.IDNUMBER order by sz.Код_заказчика, sz.Код_заказа) as num
						from @OtherZ t1
							 inner join tblСписокЗаказов sz on sz.ID = t1.IDNUMBER 
								and t1.OtherOrders not like '%'+ sz.Код_заказчика + '-' + sz.Код_заказа +'%'
						) x on x.IDNUMBER = o.IDNUMBER and x.num = 1;
						
		select @cnt = COUNT(*) 
		from @OtherZ o 
		where exists(select * 
					 from	tblСписокЗаказов 
					 where	ID = o.IDNUMBER 
							and o.OtherOrders not like '%'+ Код_заказчика + '-' + Код_заказа +'%');
							
		end
	RETURN 
END
