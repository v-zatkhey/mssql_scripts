/*
-- test case
select * from  tblChangeConditionHistory where BaseListID = 477418 -- Стандартные условия  -- F0007-0961
--exec wr_BaseListChangeCondition 477418, 'Стандартные условия2'
select * from  tblChangeConditionHistory where BaseListID = 477418 

select [Условия_взвешивания] , [Дата_условия_взвешивания], [Кто_условия_взвешивания]  from  [tblБазовыеСписки] where Код_ID = 477418 

begin tran

delete from tblChangeConditionHistory where BaseListID = 477418 ;

update [tblБазовыеСписки]
set [Условия_взвешивания] = 'Стандартные условия'
				, [Дата_условия_взвешивания] = null
				, [Кто_условия_взвешивания] = null
where Код_ID = 477418; 


commit

*/
/**********************************************************************************************************/
/********процедура для одновременного внесения изменений в условия взвешивания и в историю изменений*******/
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

select @OldCondition = t.[Условия_взвешивания]  from  dbo.[tblБазовыеСписки] t where t.[Код_ID] = @BaseListID;
if ISNULL(@OldCondition,'') = ISNULL(@NewCondition,'') return 0;

if @ChangeDate is null select @ChangeDate = getdate();
if @UserName is null select @UserName = SYSTEM_USER;

begin tran
	begin try
	
			update dbo.[tblБазовыеСписки] 
			set [Условия_взвешивания] = @NewCondition 
				, [Дата_условия_взвешивания] = @ChangeDate
				, [Кто_условия_взвешивания] = @UserName
			where [Код_ID] = @BaseListID;
			
			insert into tblChangeConditionHistory(BaseListID, OldCondition, NewCondition, ChangeDate, UserName)
			values(@BaseListID,@OldCondition,@NewCondition,@ChangeDate,@UserName);
		
	end try
	begin catch										-- если что-то пощло не так
	    DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT 
			@ErrorMessage = ERROR_MESSAGE(),
			@ErrorSeverity = ERROR_SEVERITY(),
			@ErrorState = ERROR_STATE();

		if  @@TRANCOUNT > 0 rollback;				-- откатываем транзакцию

	    RAISERROR (@ErrorMessage, -- Message text.	-- выбрасываем ошибку приложению/процедуре
				   @ErrorSeverity, -- Severity.
				   @ErrorState -- State.
				   );

	end catch
	
if @@TRANCOUNT > 0 commit;							-- если не откатились, подтверждаем изменения

END


GRANT execute
		ON [dbo].wr_BaseListChangeCondition TO [Chest_Admins],[Chest_Wes_Chief], [Chest_Wesovschiki]
GO