USE Chest35;

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--CREATE PROCEDURE sendMessage 
ALTER PROCEDURE sendMessage 	-- Add the parameters for the stored procedure here
	 @recipients varchar(max) = 'Volodymyr.Zatkhey@lifechemicals.com', 
	 @subject varchar(max) = 'call proc with empty subject',
	 @message varchar(max) = 'NULL message.'
AS
BEGIN

	SET NOCOUNT ON;

--	select system_user ; 

	EXEC msdb.dbo.sp_send_dbmail  
		@profile_name = 'sql_mail_profile',  
		@recipients = @recipients,  
		@body = @message,  
		@subject = @subject ; 
	    
END
GO
GRANT EXECUTE ON [dbo].[sendMessage] TO  [Chest_Admins]
GO
