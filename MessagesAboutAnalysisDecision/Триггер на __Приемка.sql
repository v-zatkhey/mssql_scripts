USE [SKLAD30]
GO
/****** Object:  Trigger [dbo].[TR_UPDATE_Sklad30_Приемка_send_msg]    Script Date: 11/28/2019 12:52:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		V. Zatkhey
-- Create date: 10/09/2019
-- Description:	send analyse decision message
-- =============================================
ALTER TRIGGER [dbo].[TR_UPDATE_Sklad30_Приемка_send_msg] 
   ON [dbo].[__Приемка]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

/*
Покращення 277
Прохання зробити повідомлення хіміку у вигляді листа, коли замовленний їм аналіз реактива готовий.
Тобто, коли ставиться рішення по реактиву, тоді генерується лист тому, хто його замовив, кас-номер, назва і номер поставки.
Можна додати статус реактива.
*/
	IF UPDATE([Решение_по_анализу])
		BEGIN
			declare @message varchar(255) = ''
				  , @CAS varchar(25), @ProdName varchar(255)
				  , @EMailAddress varchar(255), @UserID int
				  , @PostCode varchar(255), @PostDecision varchar(255) ;

			declare curEMail cursor forward_only
			for select  t.Код_пользователя
						, u.Email
					from inserted p 
						inner join __Требования t on t.Код_ID_Вещества = p.Код_ID_вещества 
						inner join dbo.Пользователи u on u.Код = t.Код_пользователя 
					where p.Решение_по_анализу != 0
						and t.Оформлено = 1
						and t.Утверждено_завлабом < 2
						and t.Подписано < 2
						and t.Подобрано < 2
						and t.Выдано = 0	
						and t.На_руках = 0
						and u.Email is not null
					group by  t.Код_пользователя, u.Email
					
			OPEN curEMail;
			FETCH NEXT FROM curEMail INTO  @UserID,  @EMailAddress;
			WHILE @@FETCH_STATUS = 0
			BEGIN
				SELECT @message = ''
				declare curSolution cursor forward_only
				for select  v.CAS
							, isnull(v.ProdName,'')
							, isnull(i.Источник,'')
								+ case when i.Источник is not null and post.Номер_поставки is not null
									then '-'
									else ''
									end
								+ isnull(post.Номер_поставки,'') as PostCode  
							, isnull(r.Название_типа,'')  as Решение_по_анализу
						from inserted p 
							inner join __Вещества v on v.Код_ID = p.Код_ID_вещества 
							inner join __Требования t on t.Код_ID_Вещества = p.Код_ID_вещества 
							inner join __Поставки post on post.Код_ID = p.Код_ID_поставки
							inner join __Источники i on i.Код_ID = post.Код_ID_источника 
							inner join Типы_решений_по_поставкам_реактивов r on r.Код = p.Решение_по_анализу 
						where p.Решение_по_анализу != 0
							and t.Код_пользователя = @UserID
							and t.Оформлено = 1
							and t.Утверждено_завлабом < 2
							and t.Подписано < 2
							and t.Подобрано < 2
							and t.Выдано = 0	
							and t.На_руках = 0
			
				OPEN curSolution;
				FETCH NEXT FROM curSolution INTO  @CAS,  @ProdName, @PostCode, @PostDecision;
				WHILE @@FETCH_STATUS = 0
				BEGIN

					SELECT @message = @message + @CAS + ' ' + @ProdName + ' из поставки ' + @PostCode + ' - ' + @PostDecision + '.' + CHAR(13) + CHAR(10);

					FETCH NEXT FROM curSolution INTO  @CAS,  @ProdName, @PostCode, @PostDecision;
				END
				CLOSE curSolution;
				DEALLOCATE curSolution;


				if @message != ''
					begin
					select @message =  'Готово решение по анализу для реактива: '  + CHAR(13) + CHAR(10) + @message
					exec sendMessage @recipients = @EMailAddress
								, @subject = 'Склад реактивов. Готов анализ.'
								,  @message = @message;
					end	
				
				FETCH NEXT FROM curEMail INTO  @UserID,  @EMailAddress;
			END
			CLOSE curEMail;
			DEALLOCATE curEMail;
/*
GLPI #0000432
Назва :Автоматичне формування листа-сповіщення про негативний результат аналізу з якості реагенту 
Заявники : Dmitrenko Tatyana 
Дата відкриття :2019-11-28 11:25

Прошу зробити мені додаткову опцію - якщо рішення по якості купленого реагенту відмінне від "ОК", мені має надійти лист-сповіщення про цей факт. 
У листі має бути зазначено cas, назва та поставка. 
У поле зору мають потрапити реагенти, для яких з моменту внесення прийомки в склад минув навіть місяць 
(про всяк випадок, бо інколи певні аналізи (елементні аналізи по каталізаторам) виконуються в ІОХ, 
і це може збільшити часовий інтервал від моменту внесення прийомки в склад до виставлення рішення).
*/			
			declare  @ChiefSkbEMailAddress varchar(255) = 'Tatyana.Dmitrenko@lifechemicals.com'		
			SELECT @message = ''
			declare curSolution cursor forward_only
			for select  v.CAS
						, isnull(v.ProdName,'') as ProdName
						, isnull(i.Источник,'')
							+ case when i.Источник is not null and post.Номер_поставки is not null
								then '-'
								else ''
								end
							+ isnull(post.Номер_поставки,'') as PostCode  
						, isnull(r.Название_типа,'')  as Решение_по_анализу
					from inserted p 
						inner join __Вещества v on v.Код_ID = p.Код_ID_вещества 
						inner join __Поставки post on post.Код_ID = p.Код_ID_поставки
						inner join __Источники i on i.Код_ID = post.Код_ID_источника 
						inner join Типы_решений_по_поставкам_реактивов r on r.Код = p.Решение_по_анализу 
					where p.Решение_по_анализу != 0   -- аналіз вже зроблено
						and p.Решение_по_анализу != 1 -- але він не є позитивним
						and post.Дата  >= cast(DATEADD(month, -1, GETDATE()) as date)
		
			OPEN curSolution;
			FETCH NEXT FROM curSolution INTO  @CAS,  @ProdName, @PostCode, @PostDecision;
			WHILE @@FETCH_STATUS = 0
			BEGIN

				SELECT @message = @message + @CAS + ' ' + @ProdName + ' из поставки ' + @PostCode + ' - ' + @PostDecision + '.' + CHAR(13) + CHAR(10);

				FETCH NEXT FROM curSolution INTO  @CAS,  @ProdName, @PostCode, @PostDecision;
			END
			CLOSE curSolution;
			DEALLOCATE curSolution;

			IF @message != ''
				begin
				select @message =  'Готово решение по анализу для реактива: '  + CHAR(13) + CHAR(10) + @message
				exec sendMessage @recipients = @ChiefSkbEMailAddress
							, @subject = 'Склад реактивов. Решение по анализу не ОК!'
							, @message = @message;
			END	
		END
END


