USE [Chest35]
GO
/****** Object:  Trigger [dbo].[TR_UPDATE_tblБазовыеСписки_new21]    Script Date: 09/28/2018 09:22:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[TR_UPDATE_tblБазовыеСписки_new21] ON [dbo].[tblБазовыеСписки]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN



INSERT INTO [TableLogs]  ([ActionID], [TableID], [TableKodID], 
		[IDNUMBER_old], [IDNUMBER_new],
		[DOC_old], [DOC_new],
		[DateTime_], [User_], 
		[Fields_])
select 2 /*'UPDATE'*/,  2 /*'tblБазовыеСписки'*/, I.Код_ID, 
		D.[ID], I.[ID], D.[Код_поставщика], I.[Код_поставщика],
		getdate(), system_user,
		(case When isnull(D.[Список],'-')<>isnull(I.[Список],'-') then 'Список=' + isnull(D.[Список],'null') + '->' + isnull(I.[Список],'null') else '' end)+ 
           (case When isnull(D.[Регистрация],'-')<>isnull(I.[Регистрация],'-') then ', Рег.=' + isnull(D.[Регистрация],'null') + '->' + isnull(I.[Регистрация],'null') else '' end)+ 
           (case When isnull(D.[Код],'-')<>isnull(I.[Код],'-') then ', Код=' + isnull(D.[Код],'null') + '->' + isnull(I.[Код],'null') else '' end)+ 
           (case When isnull(D.[Эксклюзив],'-')<>isnull(I.[Эксклюзив],'-') then ', Экскл.=' + isnull(D.[Эксклюзив],'null') + '->' + isnull(I.[Эксклюзив],'null') else '' end)+ 
           (case When isnull(D.[Наличие],'-')<>isnull(I.[Наличие],'-') then ', Наличие=' + isnull(D.[Наличие],'null') + '->' + isnull(I.[Наличие],'null') else '' end)+ 
           (case When isnull(D.[Вид],'-')<>isnull(I.[Вид],'-') then ', Вид=' + isnull(D.[Вид],'null') + '->' + isnull(I.[Вид],'null') else '' end)
from INSERTED as I  left join DELETED as D on (D.Код_ID=I.Код_ID)

/*
INSERT INTO [TableLogs]  
select 'UPDATE',  'tblБазовыеСписки',  getdate(), system_user,
      'Код_ID=' + isnull(Convert(varchar,I.Код_ID),'null') + 
           (case When isnull(D.[ID],'-')<>isnull(I.[ID],'-') then ', ID=' + isnull(D.[ID],'null') + '->' + isnull(I.[ID],'null') else ', ID=' + isnull(I.[ID],'null') end)+ 
           (case When isnull(D.[Код_поставщика],'-')<>isnull(I.[Код_поставщика],'-') then ', Пост-к=' + isnull(D.[Код_поставщика],'null') + '->' + isnull(I.[Код_поставщика],'null') else '' end)+ 
           (case When isnull(D.[Список],'-')<>isnull(I.[Список],'-') then ', Список=' + isnull(D.[Список],'null') + '->' + isnull(I.[Список],'null') else '' end)+ 
           (case When isnull(D.[Регистрация],'-')<>isnull(I.[Регистрация],'-') then ', Рег.=' + isnull(D.[Регистрация],'null') + '->' + isnull(I.[Регистрация],'null') else '' end)+ 
           (case When isnull(D.[Код],'-')<>isnull(I.[Код],'-') then ', Код=' + isnull(D.[Код],'null') + '->' + isnull(I.[Код],'null') else '' end)+ 
           (case When isnull(D.[Эксклюзив],'-')<>isnull(I.[Эксклюзив],'-') then ', Экскл.=' + isnull(D.[Эксклюзив],'null') + '->' + isnull(I.[Эксклюзив],'null') else '' end)+ 
           (case When isnull(D.[Наличие],'-')<>isnull(I.[Наличие],'-') then ', Наличие=' + isnull(D.[Наличие],'null') + '->' + isnull(I.[Наличие],'null') else '' end)+ 
           (case When isnull(D.[Вид],'-')<>isnull(I.[Вид],'-') then ', Вид=' + isnull(D.[Вид],'null') + '->' + isnull(I.[Вид],'null') else '' end)
from INSERTED as I  left join DELETED as D on (D.Код_ID=I.Код_ID)
*/

DECLARE @Zakazchik_old as varchar(255)
DECLARE @Zakazchik_new as varchar(255)
DECLARE @zakazchik as varchar(255)
DECLARE @exclusive as varchar(255)
DECLARE @event_exclusive varchar(255)
DECLARE @date_0 smalldatetime
DECLARE @date_1 smalldatetime
DECLARE @date_2 smalldatetime
DECLARE @myKod as int
DECLARE @Post_old as varchar(255)
DECLARE @Post_new as varchar(255)
DECLARE @Cust_ID as int
DECLARE @Mat_ID as int
DECLARE @MInfo_ID as int
DECLARE @my_ID as varchar(255)
DECLARE @my_Date as SMALLDATETIME
DECLARE @Protocol_old as bit
DECLARE @Protocol_new as bit
DECLARE @Uslovia_Vzvesh_old as varchar(255)
DECLARE @Uslovia_Vzvesh_new as varchar(255)

SET @myKod = -1
SET @my_ID = 'non-ID'
SET @my_Date = convert(smalldatetime,convert(varchar,getdate(),4),4)

select @Zakazchik_old = isnull([Заказчик_Эксклюзивности],'-'),
	   @Protocol_old = [Протокол],
       @Post_old = isnull([Код_поставщика],'-'),
       @Uslovia_Vzvesh_old = [Условия_взвешивания] 
       FROM DELETED
select @Zakazchik_new = isnull([Заказчик_Эксклюзивности],'-'),
	   @exclusive = isnull([Эксклюзив],'-'),
	   @myKod = [Код_ID],
	   @Protocol_new = [Протокол],
	   @Post_new = isnull([Код_поставщика],'-'),
	   @my_ID = isnull([ID],'non-ID'),
       @Uslovia_Vzvesh_new = [Условия_взвешивания]
	   FROM INSERTED

IF @Zakazchik_old <> @Zakazchik_new
BEGIN
	INSERT INTO [tblИстория_эксклюзивности]  
	select  I.[ID], getdate(), I.[Эксклюзив], I.[Заказчик_Эксклюзивности], I.[Событие_Эксклюзивности],
			I.[Длительность_Эксклюзивности], I.[Дата_окончания_Эксклюзивности],
			I.[Временная_Эксклюзивность], system_user
	from INSERTED as I  left join DELETED as D on (D.Код_ID=I.Код_ID)
END

IF @Post_old <> @Post_new
BEGIN
     SET @Cust_ID = -1
     SET @Mat_ID = -1
     SET @MInfo_ID = -1
     IF @Post_new = 'NOT'
     BEGIN
          SELECT @Cust_ID = isnull([CustID],-1) FROM [dbo].[Customers] WHERE [CustName]=@Post_old
          SELECT @Mat_ID = isnull([MatID],-1) FROM [dbo].[Materials] WHERE [MatName]=@my_ID
          UPDATE [dbo].[MaterialInfo]
                 SET [DateFailure] = @my_Date, [Note] = 'Auto'
                 WHERE ([CustID] = @Cust_ID) AND
                       ([MatID] = @Mat_ID) AND
                       ([DateFailure] is Null)
     END
     IF @Post_old = 'NOT'
     BEGIN
          SELECT @Cust_ID = isnull([CustID],-1) FROM [dbo].[Customers] WHERE [CustName]=@Post_new
          SELECT @Mat_ID = isnull([MatID],-1) FROM [dbo].[Materials] WHERE [MatName]=@my_ID
          SELECT TOP 1 @MInfo_ID = isnull([MInfoID],-1) FROM [dbo].[MaterialInfo]
                 WHERE ([MatID] = @Mat_ID) AND
                       ([CustID] = @Cust_ID)
                 ORDER BY [MInfoID] DESC
          UPDATE [dbo].[MaterialInfo]
                 SET [DateFailure] = Null, [Note] = 'Auto'
                 WHERE [MInfoID] = @MInfo_ID AND
                       ([DateFailure] Is Not Null)
     END
END

IF @@NESTLEVEL = 3
BEGIN
	IF (Len(@exclusive) > 1) AND (@Zakazchik_new = '-')
	BEGIN
		SET @event_exclusive = LEFT(@exclusive,1)
		SET @date_0 = CONVERT(DATETIME,RIGHT(@exclusive,8),4)
		SET @date_1 = @date_0
		SET @date_2 = DATEADD(m,600,@date_0)
		IF LEN(@exclusive) = 14
		BEGIN
			SET @zakazchik = SUBSTRING(@exclusive,3,3)
		END
		ELSE
		BEGIN
			IF LEN(@exclusive) = 16
			BEGIN
				SET @zakazchik = SUBSTRING(@exclusive,3,5)
			END
		END
		UPDATE dbo.tblБазовыеСписки
		SET [Заказчик_Эксклюзивности] = @zakazchik,
			[Событие_Эксклюзивности] = @event_exclusive,
			[Дата_ввода_Эксклюзивности] = @date_0,
			[Дата_продления_Эксклюзивности] = @date_1,
			[Длительность_Эксклюзивности] = 600,
			[Дата_окончания_Эксклюзивности] = @date_2,
			[Временная_Эксклюзивность] = 0
		WHERE [Код_ID] = @myKod
	END

	IF (@Protocol_old = 0) AND (@Protocol_new = 1)
	BEGIN		
		UPDATE dbo.tblБазовыеСписки
		SET [Дата_протокола] = @my_Date
		WHERE [Код_ID] = @myKod
	END
    
    IF (isnull(@Uslovia_Vzvesh_old,'') <> isnull(@Uslovia_Vzvesh_new,''))
	BEGIN		
		UPDATE dbo.tblБазовыеСписки
		SET [Дата_условия_взвешивания] = GETDATE(),
        	[Кто_условия_взвешивания] = system_user
		WHERE [Код_ID] = @myKod
		
		-- строка в историю изменений
		insert into tblChangeConditionHistory(BaseListID, OldCondition, NewCondition, ChangeDate, UserName)
			values(@myKod,@Uslovia_Vzvesh_old,@Uslovia_Vzvesh_new,GETDATE(),system_user);
	END

END

END
