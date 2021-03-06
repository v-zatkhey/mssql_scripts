USE [Chest35]
GO
/****** Object:  Trigger [dbo].[TR_INSERT_tblСписокЗаказов_new212]    Script Date: 01/11/2020 12:16:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[TR_INSERT_tblСписокЗаказов_new212] ON [dbo].[tblСписокЗаказов]
WITH EXECUTE AS CALLER
FOR INSERT
AS
BEGIN

DECLARE @zakaz varchar(6)
DECLARE @zakazchik varchar(5)
select @zakaz=[Код_заказа], @zakazchik=[Код_заказчика] from INSERTED


INSERT INTO [TableLogs]  ([ActionID], [TableID], [TableKodID], 
		[IDNUMBER_old], [IDNUMBER_new],
		[DOC_old], [DOC_new],
		[DateTime_], [User_], 
		[Fields_])
select 1 /*'INSERT'*/,  16 /*'tblСписокЗаказов'*/, Код_ID, 
		Null, [ID], Null, [Код_заказчика] + '-' + [Код_заказа],
		getdate(), system_user,
		'Код_отправки=' + isnull([Код_отправки],'null') + 
           ', П.=' + Convert(varchar,[Масса_1]+[Масса_2]+[Масса_3]+[Масса_4]+[Масса_5]) +
           ', М.=' + Convert(varchar,[Микро_1]+[Микро_2]+[Микро_3]+[Микро_4]+[Микро_5]+[Микро_6]+[Микро_7]+[Микро_8]+[Микро_9]+[Микро_10]) +
           ', Б_№=' + isnull([Box_номер],'null')  +
           ', Б_с=' + isnull([Box_строка],'null') + 
           ', Б_к=' + isnull([Box_колонка],'null') + 
           ', Бар-код=' + isnull([Barcode],'null') + 
           ', Пост-ка=' + isnull([Код_поставщика] + '-' + [Код_поставки],'null') +
           ', Масса_пост=' + isnull(Convert(varchar,[Масса_пост]),'null') 
from INSERTED

/*
INSERT INTO [TableLogs]  
select 'INSERT',  'tblСписокЗаказов',  getdate(), system_user,
      'Код_ID=' + isnull(Convert(varchar,Код_ID),'null') + 
           ', Заказ=' + isnull([Код_заказчика] + '-' + [Код_заказа],'null') +
           ', ID=' + isnull([ID],'null') + 
           ', Код_отправки=' + isnull([Код_отправки],'null') + 
           ', П.=' + Convert(varchar,[Масса_1]+[Масса_2]+[Масса_3]+[Масса_4]+[Масса_5]) +
           ', М.=' + Convert(varchar,[Микро_1]+[Микро_2]+[Микро_3]+[Микро_4]+[Микро_5]+[Микро_6]+[Микро_7]+[Микро_8]+[Микро_9]+[Микро_10]) +
           ', Б_№=' + isnull([Box_номер],'null')  +
           ', Б_с=' + isnull([Box_строка],'null') + 
           ', Б_к=' + isnull([Box_колонка],'null') + 
           ', Бар-код=' + isnull([Barcode],'null') + 
           ', Пост-ка=' + isnull([Код_поставщика] + '-' + [Код_поставки],'null') +
           ', Масса_пост=' + isnull(Convert(varchar,[Масса_пост]),'null') 
from INSERTED
*/

UPDATE dbo.[tblЗаказы] SET Opened = 1 WHERE ([Код_заказчика] = @zakazchik) AND ([Код_заказа] = @zakaz) AND (Opened = 0)

/*
DECLARE @myIDxxx varchar(50)
select @myIDxxx = I.[ID] from INSERTED as I
EXEC [dbo].[tblСклад_GB_Update] @myIDxxx
*/

IF @@NESTLEVEL = 3
 BEGIN
 	DECLARE @myKodID4 int
    DECLARE @myID4 varchar(50)
    DECLARE @mySaltID4 int
	select @myKodID4 = I.[Код_ID], @myID4 = I.[ID] from INSERTED as I
    select @mySaltID4 = [SaltID] from [Materials] where [MatName] = @myID4
    UPDATE tblСписокЗаказов SET [SaltID_0] = isnull(@mySaltID4,0) WHERE [Код_ID] = @myKodID4 
 END

END
