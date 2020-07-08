/*
-- test case
select * from  tblChangeConditionHistory where BaseListID = 477418 -- ����������� �������  -- F0007-0961
--exec wr_BaseListChangeCondition 477418, '����������� �������2'
select * from  tblChangeConditionHistory where BaseListID = 477418 

select [�������_�����������] , [����_�������_�����������], [���_�������_�����������]  from  [tbl�������������] where ���_ID = 477418 

begin tran

delete from tblChangeConditionHistory where BaseListID = 477418 ;

update [tbl�������������]
set [�������_�����������] = '����������� �������'
				, [����_�������_�����������] = null
				, [���_�������_�����������] = null
where ���_ID = 477418; 


commit

*/
/**********************************************************************************************************/
/********��������� ��� �������������� �������� ��������� � ������� ����������� � � ������� ���������*******/
/**********************************************************************************************************/

USE [Chest35]
GO
-- drop procedure [wr_BaseListChangeCondition]
/****** Object:  StoredProcedure [dbo].[tbl[wr_BaseListChangeCondition]]    Script Date: 09/27/2018 10:27:50 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--CREATE 
ALTER PROCEDURE [dbo].[wr_BaseListChangeCondition] 
	@BaseListID int
	, @NewCondition varchar(255) 
	, @ChangeDate datetime = null
	, @UserName varchar(255) = null
	
AS
BEGIN
DECLARE @OldCondition varchar(255) = null;

select @OldCondition = t.[�������_�����������]  from  dbo.[tbl�������������] t where t.[���_ID] = @BaseListID;
if ISNULL(@OldCondition,'') = ISNULL(@NewCondition,'') return 0;

if @ChangeDate is null select @ChangeDate = getdate();
if @UserName is null select @UserName = SYSTEM_USER;

begin tran
	begin try
	
			update dbo.[tbl�������������] 
			set [�������_�����������] = @NewCondition 
				, [����_�������_�����������] = @ChangeDate
				, [���_�������_�����������] = @UserName
			where [���_ID] = @BaseListID;
			
			insert into tblChangeConditionHistory(BaseListID, OldCondition, NewCondition, ChangeDate, UserName)
			values(@BaseListID,@OldCondition,@NewCondition,@ChangeDate,@UserName);
		
	end try
	begin catch										-- ���� ���-�� ����� �� ���
	    DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT 
			@ErrorMessage = ERROR_MESSAGE(),
			@ErrorSeverity = ERROR_SEVERITY(),
			@ErrorState = ERROR_STATE();

		if  @@TRANCOUNT > 0 rollback;				-- ���������� ����������

	    RAISERROR (@ErrorMessage, -- Message text.	-- ����������� ������ ����������/���������
				   @ErrorSeverity, -- Severity.
				   @ErrorState -- State.
				   );

	end catch
	
if @@TRANCOUNT > 0 commit;							-- ���� �� ����������, ������������ ���������

END


GRANT execute
		ON [dbo].wr_BaseListChangeCondition TO [Chest_Admins],[Chest_Wes_Chief], [Chest_Wesovschiki]
GO