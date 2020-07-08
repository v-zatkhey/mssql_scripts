USE [Chest35]
GO

/****** Object:  View [dbo].[tblПоставки_Чистота_mod]    Script Date: 01/08/2019 12:27:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

USE [Chest35]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_Min_Chistota_Spectra_by_Postavka]    Script Date: 01/08/2019 16:44:19 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

alter  FUNCTION [dbo].[fn_Min_Chistota_Spectra_by_Postavka_BB] (@myKodPostavki int)  -- building block
RETURNS real AS  
BEGIN 
DECLARE @my_chistota_S real
DECLARE @my_chistota_M real
DECLARE @my_chistota real
DECLARE @my_mass real

	SET @my_chistota = 101
	SET @my_chistota_S = 101
    SET @my_chistota_M = 101
    
    SELECT	@my_chistota =  [Чистота] 
			, @my_mass = [Масса_пост] -- остаток
	FROM	dbo.[tblПоставки]
	WHERE	Код = @myKodPostavki;   

	if isnull(@my_mass,0) < 500 return null;

    IF @my_chistota is NULL 
    begin
		SET @my_chistota = 101

		SET @my_chistota_S = (SELECT TOP 1 dbo.[tblСпектр].[Процентное содержание] AS LASTCHISTOTA
	  			FROM dbo.[tblСпектр]
	  			WHERE dbo.[tblСпектр].Код_tblПоставки_rev = @myKodPostavki AND 
            			dbo.[tblСпектр].[Результат] = 'OK' AND
						dbo.[tblСпектр].[Тип_спектра] = 'S' AND   					
  						dbo.[tblСпектр].[Процентное содержание] IS NOT NULL
				ORDER BY dbo.[tblСпектр].Код DESC)
		SET @my_chistota_M = (SELECT TOP 1 dbo.[tblСпектр].[Процентное содержание] AS LASTCHISTOTA
	  			FROM dbo.[tblСпектр]
	  			WHERE dbo.[tblСпектр].Код_tblПоставки_rev = @myKodPostavki AND 
            			dbo.[tblСпектр].[Результат] = 'OK' AND
						dbo.[tblСпектр].[Тип_спектра] = 'M' AND   					
  						dbo.[tblСпектр].[Процентное содержание] IS NOT NULL
				ORDER BY dbo.[tblСпектр].Код DESC)

		IF @my_chistota_S is NULL SET @my_chistota_S = 101
		IF @my_chistota_M is NULL SET @my_chistota_M = 101
		IF @my_chistota_S <= @my_chistota SET @my_chistota = @my_chistota_S
		IF @my_chistota_M <= @my_chistota SET @my_chistota = @my_chistota_M
		IF @my_chistota = 101 SET @my_chistota = NULL
    end

RETURN (@my_chistota)
END

GO



CREATE VIEW [dbo].[tblПоставки_Чистота_mod_2]
AS
SELECT     Код, Код_поставщика, Код_поставки, Дата_пост, Дата_изменения, ID, Масса, Масса_пост, Масса_рез, Тип, Спектр, Примечание, Дата_спектра, Склад, 
                      Дата_склад, [На взвешивании], Код_весовщика, Примечание1, A, B, C, Код_спектра, Код_зак_пост, [Change_ID/Annul], New_ID, Учтено, Расчет, Дата_расчета, 
                      Причина_расчета, Консигнация, Консигнация_заказана, Склад_принято, На_повторном_спектре, [old_Растворитель для спектра], Код_весовщика_0, V_K, 
                      V_K_Date, Инвентаризация, Масса10, Решение_по_поставке, Дата_решения_по_поставке, Причина_решения, Масса_пробирки_с_веществом, 
                      М10_пробирки_с_веществом, Spectrum_Lambda, Spectrum_Epsilon, Spectrum_DopParams, N_sklada, N_holodilnika, N_polki, Дата_Учтено, Причина_Учтено, 
                      Комментарии_расчета, Склад_принято_после_повторного_спектра, Протокол, Дата_протокола, Решение_по_анализу, Дата_решения_по_анализу, 
                      Причина_решения_по_анализу, [Кол-во_пробирок], Дата_склад_1st, Масса_тары, Масса_тары_с_веществом, С_пробкой, Масса_нетто, Темное, Код_цвета, 
                      Чистота, Агрегатное_состояние, Рыночная_цена, dbo.fn_Min_Chistota_Spectra_by_Postavka_BB(Код) AS Чистота2
FROM         dbo.tblПоставки
WHERE Код_поставщика<>'EUR' AND Код_поставщика<>'USA' AND Код_поставщика<>'JPN'
GO


GRANT SELECT 
	ON [dbo].[tblПоставки_Чистота_mod_2] 
	TO [Chest_Postavki_really]
	 , [Chest_Postavki]
	 , [Chest_Wes_Chief]
	 , [Chest_public]
	 , [Chest_Wesovschiki]
	 , [Chest_Otpravki]
	 , [Chest_Zakazi]
	 , [Chest_Rukovodstvo]
GO


/****** Object:  View [dbo].[tblЧистота_max]    Script Date: 01/08/2019 12:27:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Alter VIEW [dbo].[tblЧистота_max]
AS
SELECT     ID, MIN(Чистота2) AS Purity				-- 8.01.2019 совместно с В.Семчихиным, А.Гиль и А.Емец пришли к выводу, что чистоту нужно брать минимальную по поставкам,кот. > 500 mg  
FROM         dbo.tblПоставки_Чистота_mod_2			-- при этом наименование представления не менять (чтобы не переделывать выборки из него)
GROUP BY ID

GO


GRANT SELECT 
	ON [dbo].[tblЧистота_max] 
	TO [Chest_Postavki_really]
	 , [Chest_Postavki]
	 , [Chest_Wes_Chief]
	 , [Chest_public]
	 , [Chest_Wesovschiki]
	 , [Chest_Otpravki]
	 , [Chest_Zakazi]
	 , [Chest_Rukovodstvo]
GO



/*******test******/

select * from [tblЧистота_max] where Purity < 90
select * from [tblЧистота_max] where ID = 'F1298-0431'
select * from dbo.tblПоставки where ID = 'F0918-1472' and Код_поставщика not in ('USA','EUR','JPN')
select * from [tblЧистота_max] where ID = 'F0918-1472' 
select [dbo].[fn_Min_Chistota_Spectra_by_Postavka_BB](603674)


declare @myKodPostavki int
DECLARE @my_chistota_S real
DECLARE @my_chistota_M real
DECLARE @my_chistota real
DECLARE @my_mass real

	set @myKodPostavki = 603674;
	SET @my_chistota = 101
	SET @my_chistota_S = 101
    SET @my_chistota_M = 101
    
    SELECT	@my_chistota =  [Чистота] 
			, @my_mass = [Масса_пост] -- остаток
	FROM	dbo.[tblПоставки]
	WHERE	Код = @myKodPostavki ;
			--AND [Чистота] IS NOT NULL;   
	select @my_mass as rest, @my_chistota as Purity;
	if isnull(@my_mass,0) < 500 select 'Return1';

    IF @my_chistota is NULL 
    begin
		SET @my_chistota = 101

		SET @my_chistota_S = (SELECT TOP 1 dbo.[tblСпектр].[Процентное содержание] AS LASTCHISTOTA
	  			FROM dbo.[tblСпектр]
	  			WHERE dbo.[tblСпектр].Код_tblПоставки_rev = @myKodPostavki AND 
            			dbo.[tblСпектр].[Результат] = 'OK' AND
						dbo.[tblСпектр].[Тип_спектра] = 'S' AND   					
  						dbo.[tblСпектр].[Процентное содержание] IS NOT NULL
				ORDER BY dbo.[tblСпектр].Код DESC)
		SET @my_chistota_M = (SELECT TOP 1 dbo.[tblСпектр].[Процентное содержание] AS LASTCHISTOTA
	  			FROM dbo.[tblСпектр]
	  			WHERE dbo.[tblСпектр].Код_tblПоставки_rev = @myKodPostavki AND 
            			dbo.[tblСпектр].[Результат] = 'OK' AND
						dbo.[tblСпектр].[Тип_спектра] = 'M' AND   					
  						dbo.[tblСпектр].[Процентное содержание] IS NOT NULL
				ORDER BY dbo.[tblСпектр].Код DESC)

		select @my_chistota_S,@my_chistota_M,'___';
		
		IF @my_chistota_S is NULL SET @my_chistota_S = 101
		IF @my_chistota_M is NULL SET @my_chistota_M = 101
		IF @my_chistota_S <= @my_chistota SET @my_chistota = @my_chistota_S
		IF @my_chistota_M <= @my_chistota SET @my_chistota = @my_chistota_M
		IF @my_chistota = 101 SET @my_chistota = NULL
    end
select @my_chistota, 'Return2' 