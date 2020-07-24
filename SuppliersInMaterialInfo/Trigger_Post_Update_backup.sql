USE [Chest35]
GO

/****** Object:  Trigger [dbo].[TR_UPDATE_tblПоставки_new212]    Script Date: 07/21/2020 14:51:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER TRIGGER [dbo].[TR_UPDATE_tblПоставки_new212] ON [dbo].[tblПоставки]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN



INSERT INTO [TableLogs]  ([ActionID], [TableID], [TableKodID], 
		[IDNUMBER_old], [IDNUMBER_new],
		[DOC_old], [DOC_new],
		[DateTime_], [User_], 
		[Fields_])
select 2 /*'UPDATE'*/,  1 /*'tblПоставки'*/, I.Код, 
		D.[ID], I.[ID], D.[Код_поставщика] + '-' + D.[Код_поставки], I.[Код_поставщика] + '-' + I.[Код_поставки],
		getdate(), system_user,                                       
           (case When isnull(D.[Масса],-1)<>isnull(I.[Масса],-1) then 'М.=' + isnull(Convert(varchar,D.[Масса]),'null')  + '->' + isnull(Convert(varchar,I.[Масса]),'null') else '' end) +
           (case When isnull(D.[Масса10],-1)<>isnull(I.[Масса10],-1) then ', М10=' + isnull(Convert(varchar,D.[Масса10]),'null')  + '->' + isnull(Convert(varchar,I.[Масса10]),'null') else '' end) +
           (case When isnull(D.[Масса_пост],-1)<>isnull(I.[Масса_пост],-1) then ', Ост.=' + isnull(Convert(varchar,D.[Масса_пост]),'null') + '->' + isnull(Convert(varchar,I.[Масса_пост]),'null') else '' end) +
           (case When isnull(Convert(varchar,D.[Дата_пост],3), 'null')<>isnull(Convert(varchar,I.[Дата_пост],3), 'null') then ', Дата_пост.=' + isnull(Convert(varchar,D.[Дата_пост],3), 'null') + '->' +  isnull(Convert(varchar,I.[Дата_пост],3), 'null') else '' end) +
           (case When isnull(D.[Код_спектра],-1)<>isnull(I.[Код_спектра],-1) then ', Код_сп.=' + isnull(Convert(varchar,D.[Код_спектра]),'null') + '->' + isnull(Convert(varchar,I.[Код_спектра]),'null') else '' end) +
           (case When D.[Решение_по_поставке]<>I.[Решение_по_поставке] then ', Решение=' + isnull(Convert(varchar,D.[Решение_по_поставке]),'null') + '->' + Convert(varchar,I.[Решение_по_поставке]) else '' end) +
           (case When isnull(Convert(varchar,D.[Дата_решения_по_поставке],3), 'null')<>isnull(Convert(varchar,I.[Дата_решения_по_поставке],3), 'null') then ', Дата_решения=' + isnull(Convert(varchar,D.[Дата_решения_по_поставке],3), 'null') + '->' +  isnull(Convert(varchar,I.[Дата_решения_по_поставке],3), 'null') else '' end) +
           (case When isnull(D.[Консигнация],-9)<>isnull(I.[Консигнация],-9) then ', К.=' + isnull(Convert(varchar,D.[Консигнация]),'null') + '->' + isnull(Convert(varchar,I.[Консигнация]),'null') else '' end) +
           (case When isnull(D.[Консигнация_заказана],-9)<>isnull(I.[Консигнация_заказана],-9) then ', К.з.=' + isnull(Convert(varchar,D.[Консигнация_заказана]),'null') + '->' + isnull(Convert(varchar,I.[Консигнация_заказана]),'null') else '' end) +
           (case When isnull(D.[Расчет],-9)<>isnull(I.[Расчет],-9) then ', Расчет=' + isnull(Convert(varchar,D.[Расчет]),'null') + '->' +  isnull(Convert(varchar,I.[Расчет]),'null') else '' end) +
           (case When isnull(D.[Инвентаризация],-9)<>isnull(I.[Инвентаризация],-9) then ', Инвент-ция=' + isnull(Convert(varchar,D.[Инвентаризация]),'null') + '->' +  isnull(Convert(varchar,I.[Инвентаризация]),'null') else '' end)
from INSERTED as I  left join DELETED as D on (D.Код=I.Код)

DECLARE @ostatoktt_old as float
DECLARE @ostatoktt_new as float
DECLARE @Netto_old as float
DECLARE @Netto_new as float
DECLARE @Status_olds as int
DECLARE @Status_news as int
-- Заявка ID 492 изменение причины должно попадать в журнал остатков
DECLARE @Reason_old as varchar(255)
DECLARE @Reason_new as varchar(255)

select @ostatoktt_old = isnull(D.[Масса_пост],-1), @ostatoktt_new = isnull(I.[Масса_пост],-1),
	   @Netto_old = isnull(D.[Масса_нетто],-1), @Netto_new = isnull(I.[Масса_нетто],-1),	
	   @Status_olds = D.[Решение_по_поставке], @Status_news = I.[Решение_по_поставке],
	   @Reason_old = D.[Причина_решения] , @Reason_new = I.[Причина_решения]
from INSERTED as I  left join DELETED as D on (D.Код=I.Код)

/*'UPDATE'*/
IF ((@ostatoktt_new <> @ostatoktt_old) or (@Status_news <> @Status_olds) or (@Reason_old <> @Reason_new ))
BEGIN	 	
     INSERT INTO [tbl_Журнал_остатков]
     select I.[Код], I.[ID], I.[Код_поставщика], I.[Код_поставки], D.[Масса_пост], I.[Масса_пост],
            D.[Решение_по_поставке], I.[Решение_по_поставке],
            getdate(), system_user,
            2 ,
            Null, Null, I.[Причина_решения]
     from INSERTED as I  left join DELETED as D on (D.Код=I.Код)     
END


IF (@Netto_new <> @Netto_old)
BEGIN	 	
     INSERT INTO [tbl_Журнал_остатков]
     select I.[Код], I.[ID], I.[Код_поставщика], I.[Код_поставки], D.[Масса_нетто], I.[Масса_нетто],
            D.[Решение_по_поставке], I.[Решение_по_поставке],
            getdate(), system_user,
            2 /*'UPDATE'*/,
            Null, Null, I.[Причина_решения]
     from INSERTED as I  left join DELETED as D on (D.Код=I.Код)     
END

/*
DECLARE @myIDxxx varchar(50)
select @myIDxxx = I.[ID] from INSERTED as I
EXEC [dbo].[tblСклад_GB_Update] @myIDxxx
*/

DECLARE @Decision_old_2 as int, @Decision_2 as int, @Kod_zak_post_2 as int
DECLARE @Date_kon_2 as smalldatetime
DECLARE @FlagAuto_0 as bit
DECLARE @Post1_0 as varchar(50), @Post2_0 as varchar(50), @Zak1_0 as varchar(50), @Zak2_0 as varchar(50)
DECLARE @Prim_0 as varchar(255)
DECLARE @myID_0 as varchar(50)
DECLARE @massa_tt as float
DECLARE @Sklad_prinato_0 as bit, @Sklad_prinato_old_0 as bit
DECLARE @mykolvo as int, @mykolvo_2 as int
DECLARE @otpravka as varchar(50), @s_tmp as varchar(50)
DECLARE @i_otpravka as int
DECLARE @my_Date as SMALLDATETIME
DECLARE @Protocol_old as bit
DECLARE @Protocol_new as bit

SET @my_Date = convert(smalldatetime,convert(varchar,getdate(),4),4)
SET @Kod_zak_post_2 = -1
SET @myID_0 = '-'
select	@Decision_2 = I.[Решение_по_поставке], @Decision_old_2 = D.[Решение_по_поставке],
        @Kod_zak_post_2 = I.[Код_зак_пост],
		@Post1_0 = isnull(I.[Код_поставщика],'-'), @Post2_0 = isnull(I.[Код_поставки],'-'),
		@Prim_0 =  isnull(I.[Примечание],'-'),
		@myID_0 =  isnull(I.[ID],'-'),
		@Sklad_prinato_0 = I.[Склад_принято],
		@Sklad_prinato_old_0 = D.[Склад_принято],
		@Protocol_old = D.[Протокол],
		@Protocol_new = I.[Протокол]
	from INSERTED as I  left join DELETED as D on (D.Код=I.Код)

SET @FlagAuto_0 = 0
SET @Post1_0 = LTrim(RTrim(@Post1_0))
SET @Post2_0 = LTrim(RTrim(@Post2_0))
SET @Prim_0 = LTrim(RTrim(@Prim_0))
SET @Zak1_0 = '-'
SET @Zak2_0 = '-'
SET @massa_tt = 0
IF (Len(@Prim_0)>=6) 
	SET @Zak1_0 = Left(@Prim_0,5)
IF (Len(@Prim_0)=12) 
	SET @Zak2_0 = Right(@Prim_0,6)
/*
Автоматически закрываться при поставке с синтеза на склад - должны также следующие внутренние заказы:
z30050, z10122, z10022

В то время как z00401, z00402, z00403…z00409 лучше бы исключить (сейчас функциональность не работает, но если в будущем кто-то решит провести так синтез - то соотв.LabHead заказ не попадёт, а закроется до отгрузки).

ТАКЖЕ - 10070 тут по ошибке, т.к. это номер для Кастом Синтезов от z00070=F.Hoffmann-La Roche-Switzerland - и (вполне вероятно) синтезированные вещества им надо будет отправлять (если/когда снова закажут)!

Спасибо. С уважением,
Антон
*/	
IF (((@Zak1_0 = '00050') or (@Zak1_0 = '00105') or (@Zak1_0 = '00022') or (@Zak1_0 = '00606') or 
	 (@Zak1_0 = '00122') or (@Zak1_0 = '90122') or (@Zak1_0 = '01000') or (@Zak1_0 = '01070') or 
	 (@Zak1_0 = '00400') or 
	 (@Zak1_0 = '30050') or (@Zak1_0 = '10122') or (@Zak1_0 = '10022') or 
	 --(@Zak1_0 = '00401') or (@Zak1_0 = '00402') or (@Zak1_0 = '00403') or (@Zak1_0 = '00404') or 
	 --(@Zak1_0 = '00405') or (@Zak1_0 = '00406') or (@Zak1_0 = '00407') or (@Zak1_0 = '00408') or (@Zak1_0 = '00409') or 
	 (@Zak1_0 = '50050') or (@Zak1_0 = '50122') or 
     (@Zak1_0 = '10050') or  -- (@Zak1_0 = '10070') or
     (@Zak1_0 = '50406')) 
	  AND (Len(@Post1_0)>0)) 
	SET @FlagAuto_0 = 1

SET @i_otpravka = 65 + CONVERT(int,Right(Year(getdate()),1))
SET @s_tmp = Left(Month(getdate()),2)
IF (LEN(@s_tmp) < 2) SET @s_tmp = '0' + @s_tmp
SET @otpravka = 's' + CHAR(@i_otpravka) + @s_tmp
IF (@Sklad_prinato_old_0 <> @Sklad_prinato_0)
  BEGIN
	IF (@Sklad_prinato_0 = 1)
	  BEGIN
		IF (@FlagAuto_0 = 1)
		  BEGIN
			
			SET @massa_tt = 0
			select @massa_tt = isnull([Масса10],0) FROM dbo.tblПоставки
				   where ([ID] = @myID_0) AND 
						 ([Код_поставщика] = @Post1_0) AND 
						 ([Код_поставки] = @Post2_0) AND 
						 ([Примечание] = @Zak1_0 + '-' + @Zak2_0)

			INSERT INTO dbo.tblВыполненныеЗаказы ( 
				Код_заказчика, Код_заказа, ID, Код, Масса, Код_отправки, 
				Код_поставщика, Код_поставки,
                SaltID_0,
                Need_Massa_1, Масса_Синтетику, Исполнитель, Зарплата_синтетику, 
                Зарплата_завлабу, Цена_заказчику, Применяется_ли_формула )
				(SELECT Код_заказчика, Код_заказа, ID, Код, @massa_tt /*Масса_1*/, @otpravka, 
					    Код_поставщика, Код_поставки,
                        SaltID_0,
                        Need_Massa_1, Масса_Синтетику, Исполнитель, Зарплата_синтетику, 
                        Зарплата_завлабу, Цена_заказчику, Применяется_ли_формула
                  FROM dbo.tblСписокЗаказов WHERE ID = @myID_0 AND 
												  [Код_поставщика] = @Post1_0 AND 
												  [Код_поставки] = @Post2_0 AND 
												  [Код_заказчика] = @Zak1_0 AND
												  [Код_заказа] = @Zak2_0 )
			DELETE FROM dbo.tblСписокЗаказов WHERE ID = @myID_0 AND 
												   [Код_поставщика] = @Post1_0 AND 
												   [Код_поставки] = @Post2_0 AND 
												   [Код_заказчика] = @Zak1_0 AND
												   [Код_заказа] = @Zak2_0
			SET @mykolvo = 0
			SELECT @mykolvo = isnull(Count(Код_ID),0) FROM dbo.tblВыполненныеЗаказы 
				WHERE [Код_заказчика] = @Zak1_0 AND [Код_отправки] = @otpravka
			SET @mykolvo_2 = 0
			SELECT @mykolvo_2 = isnull(count([Код]),0) FROM dbo.tblОтправкаЗаказов
				WHERE [Код_заказчика] = @Zak1_0 AND [Код_отправки] = @otpravka
			IF (@mykolvo_2 > 0)
			  BEGIN
				UPDATE dbo.tblОтправкаЗаказов SET [Количество] = @mykolvo
					WHERE ([Код_заказчика] = @Zak1_0) AND ([Код_отправки] = @otpravka) AND ([Количество] <> @mykolvo)
			  END
			ELSE
			  BEGIN
				IF (@mykolvo > 0)
				  BEGIN
					INSERT INTO dbo.tblОтправкаЗаказов 
							   ([Код_заказчика], Код_отправки, [Количество])
						VALUES (@Zak1_0, @otpravka, @mykolvo)
				  END
			  END
		  END
	  END
  END

--- 23.01.2020 перехід на 6-символьний код відправки
IF (@Decision_2 <> @Decision_old_2)
  BEGIN
	   IF (@Decision_2 = 1)
        BEGIN
		  IF (@FlagAuto_0 = 1)
			BEGIN
			  SET @massa_tt = 0
			  IF (Len(@Prim_0)=12)
			    BEGIN
				  select @massa_tt = isnull([Масса],0) FROM dbo.tblЗаказы_2 
				   where [Код_заказчика] = @Zak1_0 and [Код_заказа] = @Zak2_0
			    END			
			  UPDATE dbo.tblСписокЗаказов 
				SET [Код_отправки] = 's99999', [Масса_1] = @massa_tt,
                    [Код_поставщика] = @Post1_0, [Код_поставки] = @Post2_0
              WHERE ([ID] = @myID_0) and ([Код_заказчика] = @Zak1_0) and ([Код_заказа] = @Zak2_0)			  
			END		  
		END
	   ELSE
		BEGIN
		  IF (@FlagAuto_0 = 1)
			BEGIN			  
			  UPDATE dbo.tblСписокЗаказов 
				SET [Код_отправки] = 's00000', [Масса_1] = 0,
                    [Код_поставщика] = Null, [Код_поставки] = Null
              WHERE ([ID] = @myID_0) and ([Код_заказчика] = @Zak1_0) and ([Код_заказа] = @Zak2_0) and
					([Код_поставщика] = @Post1_0) and ([Код_поставки] = @Post2_0)
			END		  
		END
  END    

IF (@Decision_2 <> @Decision_old_2) AND (@Kod_zak_post_2 > 0) AND (@Sklad_prinato_0 = 0)
BEGIN
  IF (@Decision_2 = 1)
  BEGIN
	/*prinjato*/
	UPDATE [dbo].[tblЗаказыПоставщикамСп1] SET [Статус] = 2, [Получено] = [Заказано], [На_поставке] = 'Да' WHERE [Код] = @Kod_zak_post_2
  END
  ELSE
  BEGIN
	/*ne prinjato*/
	SET @Date_kon_2 = NULL
	select @Date_kon_2 = [Дата_кон] from [dbo].[tblЗаказыПоставщикамСп1] WHERE [Код] = @Kod_zak_post_2
	IF (@Date_kon_2 is NULL) OR (@Date_kon_2 >= getdate())
	BEGIN
	     /*net*/
         UPDATE [dbo].[tblЗаказыПоставщикамСп1] SET [Статус] = 1, [Получено] = 0, [На_поставке] = 'Нет' WHERE [Код] = @Kod_zak_post_2
	END
	ELSE
	BEGIN
	     /*istek srok zakaza*/
	     UPDATE [dbo].[tblЗаказыПоставщикамСп1] SET [Статус] = 10, [Получено] = 0, [На_поставке] = 'Нет' WHERE [Код] = @Kod_zak_post_2
	END
  END	
END

IF @@NESTLEVEL = 3
BEGIN
	DECLARE @Sklad_old as bit, @Sklad as bit, @FlagAuto as bit
	DECLARE @Sklad_prinyato_old as bit, @Sklad_prinyato as bit	
	DECLARE @Decision_old as int, @Decision as int, @Kod as int
	DECLARE @Dec_Analiz_old as int, @Dec_Analiz as int
	DECLARE @Post1 as varchar(50), @Post2 as varchar(50), @Zak1 as varchar(50)
	DECLARE @Prim as varchar(255)
    DECLARE @MassaSklad as float, @MassaSklad_old as float
    DECLARE @Massa10 as float, @Massa10_old as float
    DECLARE @DateSklad_1st as smalldatetime
    DECLARE @FragmentObr_new as bit, @FragmentObr_old as bit
    DECLARE @my_Date2 as SMALLDATETIME

	SET @my_Date2 = convert(smalldatetime,convert(varchar,getdate(),4),4)
	select	@Kod = I.[Код], @Sklad = I.[Склад], @Sklad_old = D.[Склад],
			@Sklad_prinyato = I.[Склад_принято], @Sklad_prinyato_old = D.[Склад_принято],
            @MassaSklad = I.[Масса_пост], @MassaSklad_old = D.[Масса_пост],
            @Massa10 = I.[Масса10], @Massa10_old = D.[Масса10],
            @DateSklad_1st = D.[Дата_склад_1st],
			@Decision = I.[Решение_по_поставке], @Decision_old = D.[Решение_по_поставке],
			@Dec_Analiz = I.[Решение_по_анализу], @Dec_Analiz_old = D.[Решение_по_анализу],
			@Post1 = isnull(I.[Код_поставщика],'-'), @Post2 = isnull(I.[Код_поставки],'-'),
			@Prim =  isnull(I.[Примечание],'-'),
            @FragmentObr_new = I.[ФрагментОбработано], @FragmentObr_old = D.[ФрагментОбработано]
	from INSERTED as I  left join DELETED as D on (D.Код=I.Код)
	
	SET @FlagAuto = 0
	SET @Post1 = LTrim(RTrim(@Post1))
	SET @Post2 = LTrim(RTrim(@Post2))
	SET @Prim = LTrim(RTrim(@Prim))
	SET @Zak1 = '-'
	IF (Len(@Prim)>=6) 
		SET @Zak1 = Left(@Prim,5)
	IF (
		(
		 (@Zak1_0 = '00022') or (@Zak1_0 = '00050') or (@Zak1_0 = '00105') or (@Zak1_0 = '00122') or  
		 (@Zak1_0 = '00400') or (@Zak1_0 = '00606') or (@Zak1_0 = '01000') or (@Zak1_0 = '01070') or 
		 (@Zak1_0 = '10022') or (@Zak1_0 = '10050') or (@Zak1_0 = '10122') or (@Zak1_0 = '30050') or 
		 (@Zak1_0 = '50050') or (@Zak1_0 = '50122') or (@Zak1_0 = '50406') or (@Zak1_0 = '90122')
		) 
		  /*AND (Len(@Post1)>0)*/
	   ) 
		SET @FlagAuto = 1

	IF (@Protocol_old = 0) AND (@Protocol_new = 1)
	BEGIN		
		UPDATE dbo.tblПоставки
		SET [Дата_протокола] = @my_Date2
		WHERE [Код] = @Kod
	END
    
    IF (@FragmentObr_old = 0) AND (@FragmentObr_new = 1)
	BEGIN		
		UPDATE dbo.tblПоставки
		SET [ДатаФрагментОбработано] = @my_Date2, [ДатаФрагментОбработаноFull] = getdate()
		WHERE [Код] = @Kod
	END

	IF (@Dec_Analiz <> @Dec_Analiz_old)
	 BEGIN
		UPDATE dbo.tblПоставки SET [Дата_решения_по_анализу] = getdate() WHERE [Код] = @Kod
	 END

	/**/
	IF (@Sklad_prinyato_old <> @Sklad_prinyato)
	BEGIN
		IF (@Sklad_prinyato = 1)
			UPDATE dbo.tblПоставки SET [Склад_принято_после_повторного_спектра] = 1 WHERE [Код] = @Kod
	END
	/**/

	IF (isnull(@Massa10_old,-1) <> isnull(@Massa10,-1)) AND (isnull(@MassaSklad,-1) = -1) AND (isnull(@MassaSklad_old,-1) = -1)
     BEGIN
     	UPDATE dbo.tblПоставки SET [Масса_нетто] = @Massa10 WHERE [Код] = @Kod
        INSERT INTO [tbl_Журнал_остатков]
     		select I.[Код], I.[ID], I.[Код_поставщика], I.[Код_поставки], D.[Масса_пост], I.[Масса_пост],
            		D.[Решение_по_поставке], I.[Решение_по_поставке],
            		getdate(), system_user,
            		2 /*'UPDATE'*/ ,
            		'Масса10', 'Масса нетто', I.[Причина_решения]
     		from INSERTED as I  left join DELETED as D on (D.Код=I.Код)         
     END

	IF (isnull(@MassaSklad_old,-1) <> isnull(@MassaSklad,-1))
     BEGIN
     	UPDATE dbo.tblПоставки SET [Масса_нетто] = @MassaSklad WHERE [Код] = @Kod
        INSERT INTO [tbl_Журнал_остатков]
     		select I.[Код], I.[ID], I.[Код_поставщика], I.[Код_поставки], D.[Масса_пост], I.[Масса_пост],
            		D.[Решение_по_поставке], I.[Решение_по_поставке],
            		getdate(), system_user,
            		2 /*'UPDATE'*/ ,
            		'Остаток на складе', 'Масса нетто', I.[Причина_решения]
     		from INSERTED as I  left join DELETED as D on (D.Код=I.Код)         
     END
     
	IF (@Decision = 1) AND
    	(@MassaSklad_old IS NULL) AND (@MassaSklad IS NOT NULL) AND 
        (@DateSklad_1st IS NULL)
     BEGIN
     	UPDATE dbo.tblПоставки SET [Дата_склад_1st] = getdate() WHERE [Код] = @Kod
     END
    
	IF (@Decision <> @Decision_old)
	 BEGIN
	   IF (@Decision = 1)
        BEGIN
		  IF (@FlagAuto = 1)
			UPDATE dbo.tblПоставки SET [Масса_рез] = 0, [Склад] = 1, [На взвешивании] = 1, [Дата_решения_по_поставке] = getdate(), [Дата_склад] = getdate() WHERE [Код] = @Kod
		  ELSE
			UPDATE dbo.tblПоставки SET [Масса_рез] = 0, [Склад] = 1, [Дата_решения_по_поставке] = getdate(), [Дата_склад] = getdate() WHERE [Код] = @Kod
		END
	   ELSE
		BEGIN
		  IF (@FlagAuto = 1)
			UPDATE dbo.tblПоставки SET [Масса_рез] = 0, [Склад] = 0, [На взвешивании] = 0, [Дата_решения_по_поставке] = getdate(), [Дата_склад] = getdate() WHERE [Код] = @Kod
		  ELSE
			UPDATE dbo.tblПоставки SET [Масса_рез] = 0, [Склад] = 0, [Дата_решения_по_поставке] = getdate(), [Дата_склад] = getdate() WHERE [Код] = @Kod
		END
	 END
	ELSE
	 BEGIN
		IF (@Sklad_prinyato_old <> @Sklad_prinyato)
		 BEGIN
			IF (@Sklad_prinyato = 1)
			  UPDATE dbo.tblПоставки SET [Склад_принято_после_повторного_спектра] = 1 WHERE [Код] = @Kod
		 END		  
	 END

END


END

GO

