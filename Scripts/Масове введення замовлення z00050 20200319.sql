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

CREATE TABLE [dbo].[_tmp_20200319_z00050](
	[IDNUMBER] [varchar](10) NOT NULL,
	[ZakCODE] [varchar](3) NOT NULL,
	[MassZak] [smallint] NULL,
	[PriceZak] [smallint] NULL,
	[ChemistCODE] [varchar](3) NULL,
	[MassChem] [smallint] NULL,
	[PriceChem] [smallint] NULL,
	[LocalRowNum] [int] NULL,
 CONSTRAINT [PK__tmp_20200319_z00050] PRIMARY KEY CLUSTERED 
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
update dbo._tmp_20200319_z00050 
set LocalRowNum = x.r_n
from dbo._tmp_20200319_z00050 t
	inner join (select IDNUMBER, ZakCODE, ROW_NUMBER() over(partition by ZakCode order by IDNUMBER) as r_n
				from dbo._tmp_20200319_z00050
				) x on x.IDNUMBER = t.IDNUMBER and x.ZakCODE = t.ZakCODE
*/
/*
-- �������� �� �������
select IDNUMBER, COUNT(*) 
from _tmp_20200319_z00050
group by IDNUMBER
having COUNT(*)>1
*/
/*
SELECT *
FROM tbl������ 
where [���_���������]='00050'
order BY [���_������] desc

SELECT top 100 *
FROM tbl�������������
where [���_���������]='00050'
order BY [���_������] desc

SELECT Max((Right([���_������],len([���_������])-1)))+1 AS ttt 
FROM tbl������ 
where [���_���������]='00050'
GROUP BY [���_���������] 


select ChemistCODE
from dbo._tmp_20200319_z00050
group by ChemistCODE
order by ChemistCODE


select ChemistCODE, MIN(LocalRowNum), MAX(LocalRowNum), case when (LocalRowNum-1) / 5000 > 15 then 15 else (LocalRowNum-1)/ 5000 end
from dbo._tmp_20200319_z00050
group by ChemistCODE, case when (LocalRowNum-1) / 5000 > 15 then 15 else  (LocalRowNum-1) / 5000 end
order by ChemistCODE,MIN(LocalRowNum)	

	
*/

declare @ChemistCode varchar(3)
	, @ZakCODE varchar(5)='00050'
	, @OrderDate date = '20200319'
	, @OrderEndDate date = '20200319'
	, @RegistratorName varchar(255) = '������ ������� ������������'
	, @QualityDemand varchar(50) = '90'
	, @MethodDemand varchar(255) = 'M'
	, @ZakFirstNum int
	, @ZakCurrentNum int
	, @BegIdx int
	, @EndIdx int	
	, @OrderCode varchar(6);	 
	
declare by_Chemist cursor forward_only
for select ChemistCODE
	from dbo._tmp_20200319_z00050
	group by ChemistCODE
	order by ChemistCODE;
open by_Chemist;
fetch next from by_Chemist into @ChemistCode;
while @@FETCH_STATUS = 0
	BEGIN
		
	select @ZakFirstNum =  Max((Right([���_������],len([���_������])-1)))+1  
	FROM tbl������ 
	where [���_���������]=@ZakCODE
	GROUP BY [���_���������] 
	
	declare by_Order cursor forward_only
	for select MIN(LocalRowNum), MAX(LocalRowNum), case when (LocalRowNum-1) / 5000 > 15 then 15 else (LocalRowNum-1)/ 5000 end
		from dbo._tmp_20200319_z00050
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
			
			INSERT INTO tbl������ ([���_���������], [���_������], [����],
				   [��������_����_������], [��������_����_������_���_�����������], 
				   [����������_��_�������], [����������_��_�������_������������], 
				   [�����_������], [����_�����������_������], [���_������_�����])
				   VALUES (@ZakCODE, @OrderCode, @OrderDate,
				   @OrderEndDate, @OrderEndDate,
				   @QualityDemand,@MethodDemand,
				   1, @OrderDate,@RegistratorName) ;

			-- insert list
			INSERT INTO [tbl�������������] 
						([���_���������], [���_������], [ID], [���], 
						[Need_Massa_1], [�����_���������], [�����������], [��������_���������],[����_���������])
			select  @ZakCODE, @OrderCode, IDNUMBER, IDNUMBER,
					MassZak, MassChem, ChemistCODE, PriceChem, PriceZak
			from  dbo._tmp_20200319_z00050
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

select [���_������] from tbl������ where [���_���������]=@ZakCODE and [����] = @OrderDate;

select * from tbl������ where [���_���������]='00050' and [����] = '20200319';

--select [���_������], [��������_����_������], �����_������ from tbl������ where [���] between 55363 and 55368;
--update tbl������ set [��������_����_������_���_�����������] = '20210320' where [���] between 55363 and 55368;
/*
declare @OrdID int = 55363
while @OrdID <= 55368
begin
	update tbl������ set �����_������ = 1 where [���] = @OrdID;
	select @OrdID = @OrdID + 1;
end
*/

select * from [����_��_�������_���_������_��������] where [��������]= '00050' and [����]>= '20200319'
--update [����_��_�������_���_������_��������] set [����_���_����������] = '20210320' where [��������]= '00050' and [����]>= '20200319'

/*
declare @OrdID int = 54881
while @OrdID <= 54912
begin
	--update  tbl������ set [����������_��_�������_������������] = 'M' where [���] = @OrdID;
	select @OrdID = @OrdID + 1;
end
*/
--delete from [����_��_�������_���_������_��������] where ��� between  12751 and 12782

--update  tbl������ set [����������_��_�������_������������] = 'M,S' where [���] between 54881 and 54912;