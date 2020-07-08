/*
USE [Chest35]
GO
*/
/****** Object:  Table [dbo].[_tmp_20200206_z30050]    Script Date: 02/06/2020 12:45:23 ******/
/*
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[_tmp_20200206_z30050](
	[IDNUMBER] [varchar](10) NOT NULL,
	[ZakCODE] [varchar](3) NOT NULL,
	[MassZak] [smallint] NULL,
	[PriceZak] [smallint] NULL,
	[ChemistCODE] [varchar](3) NULL,
	[MassChem] [smallint] NULL,
	[PriceChem] [smallint] NULL,
	[LocalRowNum] [int] NULL,
 CONSTRAINT [PK__tmp_20200206_z30050] PRIMARY KEY CLUSTERED 
(
	[IDNUMBER] ASC,
	[ZakCODE] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

*/


/*
update dbo._tmp_20200206_z30050 
set LocalRowNum = x.r_n
from dbo._tmp_20200206_z30050 t
	inner join (select IDNUMBER, ZakCODE, ROW_NUMBER() over(partition by ZakCode order by IDNUMBER) as r_n
				from dbo._tmp_20200206_z30050
				) x on x.IDNUMBER = t.IDNUMBER and x.ZakCODE = t.ZakCODE
*/
/*
SELECT *
FROM tblЗаказы 
where [Код_заказчика]='30050'
order BY [Код_заказа] desc

SELECT top 100 *
FROM tblСписокЗаказов
where [Код_заказчика]='30050'
order BY [Код_заказа] desc

SELECT Max((Right([Код_заказа],len([Код_заказа])-1)))+1 AS ttt 
FROM tblЗаказы 
where [Код_заказчика]='30050'
GROUP BY [Код_заказчика] 


select ChemistCODE
from dbo._tmp_20200206_z30050
group by ChemistCODE
order by ChemistCODE


select ChemistCODE, MIN(LocalRowNum), MAX(LocalRowNum), case when (LocalRowNum-1) / 5000 > 15 then 15 else (LocalRowNum-1)/ 5000 end
from dbo._tmp_20200206_z30050
group by ChemistCODE, case when (LocalRowNum-1) / 5000 > 15 then 15 else  (LocalRowNum-1) / 5000 end
order by ChemistCODE,MIN(LocalRowNum)	

	
*/

declare @ChemistCode varchar(3)
	, @ZakCODE varchar(5)='30050'
	, @OrderDate date = '20200206'
	, @OrderEndDate date = '20210206'
	, @RegistratorName varchar(255) = 'Кравец Наталья Владимировна'
	, @QualityDemand varchar(50) = '90'
	, @MethodDemand varchar(255) = 'S,M'
	, @ZakFirstNum int
	, @ZakCurrentNum int
	, @BegIdx int
	, @EndIdx int	
	, @OrderCode varchar(6);	 
	
declare by_Chemist cursor forward_only
for select ChemistCODE
	from dbo._tmp_20200206_z30050
	group by ChemistCODE
	order by ChemistCODE;
open by_Chemist;
fetch next from by_Chemist into @ChemistCode;
while @@FETCH_STATUS = 0
	BEGIN
		
	select @ZakFirstNum =  Max((Right([Код_заказа],len([Код_заказа])-1)))+1  
	FROM tblЗаказы 
	where [Код_заказчика]=@ZakCODE
	GROUP BY [Код_заказчика] 
	
	declare by_Order cursor forward_only
	for select MIN(LocalRowNum), MAX(LocalRowNum), case when (LocalRowNum-1) / 5000 > 15 then 15 else (LocalRowNum-1)/ 5000 end
		from dbo._tmp_20200206_z30050
		where ChemistCODE = @ChemistCode
		group by ChemistCODE, case when (LocalRowNum-1) / 5000 > 15 then 15 else  (LocalRowNum-1) / 5000 end
		order by ChemistCODE,MIN(LocalRowNum)
	open by_Order	
	fetch next from by_Order into @BegIdx,@EndIdx,@ZakCurrentNum;
	while @@FETCH_STATUS = 0
		BEGIN
		select @OrderCode = 'z' + RIGHT('00000'+ CAST(@ZakFirstNum + @ZakCurrentNum as varchar(10)),5)

		begin tran
			-- insert order
			INSERT INTO tblЗаказы ([Код_заказчика], [Код_заказа], [Дата],
				   [Конечная_Дата_Заказа], [Конечная_Дата_Заказа_для_Поставщиков], 
				   [Требования_по_чистоте], [Требования_по_методам_исследования], 
				   [Дата_Поступления_заказа], [Кто_вводил_заказ])
				   VALUES (@ZakCODE, @OrderCode, @OrderDate,
				   @OrderEndDate, @OrderEndDate,
				   @QualityDemand,@MethodDemand,
				   @OrderDate,@RegistratorName) ;

			-- insert list
			INSERT INTO [tblСписокЗаказов] 
						([Код_заказчика], [Код_заказа], [ID], [Код], 
						[Need_Massa_1], [Масса_Синтетику], [Исполнитель], [Зарплата_синтетику],[Цена_заказчику])
			select  @ZakCODE, @OrderCode, IDNUMBER, IDNUMBER,
					MassZak, MassChem, ChemistCODE, PriceChem, PriceZak
			from  dbo._tmp_20200206_z30050
			where ChemistCODE = @ChemistCODE      
				and LocalRowNum between @BegIdx and @EndIdx;
				
		commit
		print @OrderCode;		
		fetch next from by_Order into @BegIdx,@EndIdx,@ZakCurrentNum;
		END
	close by_Order;
	deallocate by_Order;
	fetch next from by_Chemist into @ChemistCode;
	END
close by_Chemist;
deallocate by_Chemist;

select [Код_заказа] from tblЗаказы where [Код_заказчика]=@ZakCODE and [Дата] = @OrderDate;
select [Код_заказа], Нужен_синтез from tblЗаказы where [Код] between 54881 and 54912;
--update tblЗаказы set Нужен_синтез = 0 where [Код] between 54881 and 54912;

select * from [Инфо_по_заказам_для_Отдела_Поставок] where [заказчик]= '30050' and [Дата]> '20200205'

declare @OrdID int = 54881
while @OrdID <= 54912
begin
	--update  tblЗаказы set [Требования_по_методам_исследования] = 'M' where [Код] = @OrdID;
	select @OrdID = @OrdID + 1;
end

--delete from [Инфо_по_заказам_для_Отдела_Поставок] where Код between  12751 and 12782

--update  tblЗаказы set [Требования_по_методам_исследования] = 'M,S' where [Код] between 54881 and 54912;