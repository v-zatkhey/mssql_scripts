SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		V.Zatkhey
-- Create date: 29.07.2020
-- Description:	update default fields
-- =============================================
--CREATE TRIGGER dbo.TR_tblClientRequests_UPD 
ALTER TRIGGER dbo.TR_tblClientRequests_UPD 
   ON  dbo.tblClientRequests 
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	declare @UserID int;
	select @UserID = (select top 1 Код from dbo.tblПользователи where SYSTEM_USER = 'IFLAB\'+ WinLogin);
	
    if update(AnswerText)
    begin
		update c
		set HasAnswer = 1
			,AnswerEmployee = @UserID
			,AnswerDate = GETDATE()
		from tblClientRequests c 
			inner join deleted d on d.ID = c.ID
		where d.HasAnswer = 0;
    end;

    if update(HasAnswer)
    begin
    
		-- add_answer_id and timestamp
		update x
		set AnswerEmployee = @UserID
			,AnswerDate = GETDATE()
		from tblClientRequests x
			inner join inserted i on i.ID = x.ID
			inner join deleted d on d.ID = x.ID
		where d.HasAnswer = 0 and i.HasAnswer = 1;  
    end;

END
GO
