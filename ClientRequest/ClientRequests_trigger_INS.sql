
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		V.Zatkhey
-- Create date: 27.07.2020
-- Description:	фр=ормування номеру запиту.
-- =============================================
CREATE TRIGGER dbo.TR_tblClientRequests_INS 
--ALTER TRIGGER dbo.TR_tblClientRequests_INS 
   ON  dbo.tblClientRequests
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	declare @LastRqNumByClient table(ClientName varchar(127), RqNum int);
	declare @NewRqNum table(ID int, RqNum int);

	insert into @LastRqNumByClient
	select ClientName, MAX(Number)
	from dbo.tblClientRequests
	where ClientName in (select ClientName from inserted group by ClientName)
	group by ClientName;
	
	insert into @NewRqNum(ID, RqNum)
	select i.ID, NewNumber = isnull(l.RqNum,0) + ROW_NUMBER() over(partition by i.ClientName order by i.ID)
	from inserted i 
		left join @LastRqNumByClient l on l.ClientName = i.ClientName;
		
	update x
	set Number = t.RqNum
	from tblClientRequests x
		inner join @NewRqNum t on t.ID = x.ID; 
			
	    
END
GO


