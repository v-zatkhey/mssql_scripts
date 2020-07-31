
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		V.Zatkhey
-- Create date: 27.07.2020
-- Description:	��=��������� ������ ������.
-- =============================================
--CREATE TRIGGER dbo.TR_tblClientRequests_INS 
ALTER TRIGGER dbo.TR_tblClientRequests_INS 
   ON  dbo.tblClientRequests
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	
	declare @LastRqNumByClient table(ClientCode nvarchar(5), RqNum int);
	declare @NewRqNum table(ID int, RqNum int);
	declare @UserID int;

	-- nubbering by client
	insert into @LastRqNumByClient
	select ClientCode, MAX(Number)
	from dbo.tblClientRequests
	where isnull(ClientCode,'') in (select isnull(ClientCode,'') from inserted group by isnull(ClientCode,''))
	group by ClientCode;
	
	insert into @NewRqNum(ID, RqNum)
	select i.ID, NewNumber = isnull(l.RqNum,0) + ROW_NUMBER() over(partition by isnull(i.ClientCode,'') order by i.ID)
	from inserted i 
		left join @LastRqNumByClient l on isnull(l.ClientCode,'')  = isnull(i.ClientCode,'');
		
	update x
	set Number = t.RqNum
	from tblClientRequests x
		inner join @NewRqNum t on t.ID = x.ID; 
	
	-- fill ClientName
	update x
	set ClientName = c.�����������
	from tblClientRequests x
		inner join inserted i on i.ID = x.ID
		inner join dbo.tbl���������_full c on c.������������ = x.ClientCode
	where x.ClientName is null;  
		
	-- add_empl_id
	select @UserID = (select top 1 ��� from dbo.tbl������������ where SYSTEM_USER = 'IFLAB\'+ WinLogin);
	
	update x
	set AddEmployee = @UserID
	from tblClientRequests x
		inner join inserted i on i.ID = x.ID
	where x.AddEmployee is null;  

	update x
	set AnswerEmployee = @UserID
	from tblClientRequests x
		inner join inserted i on i.ID = x.ID
	where x.AnswerEmployee is null and x.HasAnswer !=0 ;  
	
	-- timestamp
	update x
	set AddDate = GETDATE()
	from tblClientRequests x
		inner join inserted i on i.ID = x.ID
	where x.AddDate is null;  

	update x
	set AnswerDate = GETDATE()
	from tblClientRequests x
		inner join inserted i on i.ID = x.ID
	where x.AnswerDate is null and x.HasAnswer !=0 ;  
				
	    
END
GO


