USE [SKLAD30]
GO
/****** Object:  Trigger [dbo].[TR_INSERT_Sklad30___Требования]    Script Date: 03/06/2019 13:51:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[TR_INSERT_Sklad30___Требования] ON [dbo].[__Требования]
FOR INSERT
AS
BEGIN

DECLARE @myKod_Veschestva int
DECLARE @myCAS varchar(255)
SELECT @myKod_Veschestva = [Код_ID_Вещества] FROM INSERTED
SET @myKod_Veschestva = isnull(@myKod_Veschestva,0)
SELECT @myCAS = [CAS] FROM [__Вещества] WHERE [Код_ID] = @myKod_Veschestva
SET @myCAS = isnull(@myCAS,' ')

INSERT INTO [TableLogs]  
select getdate(), [Session_ID], [Код_с], 
1 /*добавлено*/,
10 /*__Требования*/,
[Код_ID], Null, @myCAS,
'Дата=' + isnull(convert(varchar,[Дата],4),'')
from INSERTED

/*...мы говорили об этом с Жанной, она просила, чтобы для ее отдела генерировалось письмо – «Просьба проанализировать». 
Чтобы назначить анализы им нужен в этом письме cas, название и поставка. */
	declare @message varchar(255) = '', @CAS varchar(25),  @ProdName varchar(255), @Post varchar(255);

	declare curIns cursor forward_only
	for select  distinct v.CAS 
				, v.ProdName 
				, isnull(ist.[Источник],'') 
					+ case when ist.[Источник] is not null and pst.[Номер_поставки] is not null then  '-' else '' end
					+ ISNULL(pst.[Номер_поставки],'') as Post
	from inserted i 
			inner join dbo.__Вещества v on v.Код_ID = i.Код_ID_Вещества  and i.Код_с = i.Код_с 
			inner join dbo.__Приемка p on p.Код_ID = i.Код_ID_Приемки 
			inner join dbo.__Поставки pst on pst.Код_ID = p.Код_ID_поставки 
			left join dbo.__Источники ist on ist.Код_ID = pst.Код_ID_источника 
	where i.Требуется_анализ != 0

	OPEN curIns;

	FETCH NEXT FROM curIns INTO  @CAS,  @ProdName, @Post;

	WHILE @@FETCH_STATUS = 0
	BEGIN

		SELECT @message = @CAS + ' ' + @ProdName + ' из поставки ' + @Post + '.' + CHAR(13) + CHAR(10);

		FETCH NEXT FROM curIns INTO  @CAS,  @ProdName, @Post;
	END
	CLOSE curIns;
	DEALLOCATE curIns;

	if @message != ''
		begin
		select @message =  'Просьба проанализировать: '  + CHAR(13) + CHAR(10) + @message
		exec sendMessage @recipients = 'analytics_department@lifechemicals.com'
					, @subject = 'Склад реактивов. Необходим анализ.'
					,  @message = @message;

		end
END
