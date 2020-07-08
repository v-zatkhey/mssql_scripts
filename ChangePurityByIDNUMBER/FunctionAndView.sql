USE [Chest35]
GO

/****** Object:  View [dbo].[tbl��������_�������_mod]    Script Date: 01/08/2019 12:27:41 ******/
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
    
    SELECT	@my_chistota =  [�������] 
			, @my_mass = [�����_����] -- �������
	FROM	dbo.[tbl��������]
	WHERE	��� = @myKodPostavki;   

	if isnull(@my_mass,0) < 500 return null;

    IF @my_chistota is NULL 
    begin
		SET @my_chistota = 101

		SET @my_chistota_S = (SELECT TOP 1 dbo.[tbl������].[���������� ����������] AS LASTCHISTOTA
	  			FROM dbo.[tbl������]
	  			WHERE dbo.[tbl������].���_tbl��������_rev = @myKodPostavki AND 
            			dbo.[tbl������].[���������] = 'OK' AND
						dbo.[tbl������].[���_�������] = 'S' AND   					
  						dbo.[tbl������].[���������� ����������] IS NOT NULL
				ORDER BY dbo.[tbl������].��� DESC)
		SET @my_chistota_M = (SELECT TOP 1 dbo.[tbl������].[���������� ����������] AS LASTCHISTOTA
	  			FROM dbo.[tbl������]
	  			WHERE dbo.[tbl������].���_tbl��������_rev = @myKodPostavki AND 
            			dbo.[tbl������].[���������] = 'OK' AND
						dbo.[tbl������].[���_�������] = 'M' AND   					
  						dbo.[tbl������].[���������� ����������] IS NOT NULL
				ORDER BY dbo.[tbl������].��� DESC)

		IF @my_chistota_S is NULL SET @my_chistota_S = 101
		IF @my_chistota_M is NULL SET @my_chistota_M = 101
		IF @my_chistota_S <= @my_chistota SET @my_chistota = @my_chistota_S
		IF @my_chistota_M <= @my_chistota SET @my_chistota = @my_chistota_M
		IF @my_chistota = 101 SET @my_chistota = NULL
    end

RETURN (@my_chistota)
END

GO



CREATE VIEW [dbo].[tbl��������_�������_mod_2]
AS
SELECT     ���, ���_����������, ���_��������, ����_����, ����_���������, ID, �����, �����_����, �����_���, ���, ������, ����������, ����_�������, �����, 
                      ����_�����, [�� �����������], ���_���������, ����������1, A, B, C, ���_�������, ���_���_����, [Change_ID/Annul], New_ID, ������, ������, ����_�������, 
                      �������_�������, �����������, �����������_��������, �����_�������, ��_���������_�������, [old_������������ ��� �������], ���_���������_0, V_K, 
                      V_K_Date, ��������������, �����10, �������_��_��������, ����_�������_��_��������, �������_�������, �����_��������_�_���������, 
                      �10_��������_�_���������, Spectrum_Lambda, Spectrum_Epsilon, Spectrum_DopParams, N_sklada, N_holodilnika, N_polki, ����_������, �������_������, 
                      �����������_�������, �����_�������_�����_����������_�������, ��������, ����_���������, �������_��_�������, ����_�������_��_�������, 
                      �������_�������_��_�������, [���-��_��������], ����_�����_1st, �����_����, �����_����_�_���������, �_�������, �����_�����, ������, ���_�����, 
                      �������, ����������_���������, ��������_����, dbo.fn_Min_Chistota_Spectra_by_Postavka_BB(���) AS �������2
FROM         dbo.tbl��������
WHERE ���_����������<>'EUR' AND ���_����������<>'USA' AND ���_����������<>'JPN'
GO


GRANT SELECT 
	ON [dbo].[tbl��������_�������_mod_2] 
	TO [Chest_Postavki_really]
	 , [Chest_Postavki]
	 , [Chest_Wes_Chief]
	 , [Chest_public]
	 , [Chest_Wesovschiki]
	 , [Chest_Otpravki]
	 , [Chest_Zakazi]
	 , [Chest_Rukovodstvo]
GO


/****** Object:  View [dbo].[tbl�������_max]    Script Date: 01/08/2019 12:27:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Alter VIEW [dbo].[tbl�������_max]
AS
SELECT     ID, MIN(�������2) AS Purity				-- 8.01.2019 ��������� � �.����������, �.���� � �.���� ������ � ������, ��� ������� ����� ����� ����������� �� ���������,���. > 500 mg  
FROM         dbo.tbl��������_�������_mod_2			-- ��� ���� ������������ ������������� �� ������ (����� �� ������������ ������� �� ����)
GROUP BY ID

GO


GRANT SELECT 
	ON [dbo].[tbl�������_max] 
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

select * from [tbl�������_max] where Purity < 90
select * from [tbl�������_max] where ID = 'F1298-0431'
select * from dbo.tbl�������� where ID = 'F0918-1472' and ���_���������� not in ('USA','EUR','JPN')
select * from [tbl�������_max] where ID = 'F0918-1472' 
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
    
    SELECT	@my_chistota =  [�������] 
			, @my_mass = [�����_����] -- �������
	FROM	dbo.[tbl��������]
	WHERE	��� = @myKodPostavki ;
			--AND [�������] IS NOT NULL;   
	select @my_mass as rest, @my_chistota as Purity;
	if isnull(@my_mass,0) < 500 select 'Return1';

    IF @my_chistota is NULL 
    begin
		SET @my_chistota = 101

		SET @my_chistota_S = (SELECT TOP 1 dbo.[tbl������].[���������� ����������] AS LASTCHISTOTA
	  			FROM dbo.[tbl������]
	  			WHERE dbo.[tbl������].���_tbl��������_rev = @myKodPostavki AND 
            			dbo.[tbl������].[���������] = 'OK' AND
						dbo.[tbl������].[���_�������] = 'S' AND   					
  						dbo.[tbl������].[���������� ����������] IS NOT NULL
				ORDER BY dbo.[tbl������].��� DESC)
		SET @my_chistota_M = (SELECT TOP 1 dbo.[tbl������].[���������� ����������] AS LASTCHISTOTA
	  			FROM dbo.[tbl������]
	  			WHERE dbo.[tbl������].���_tbl��������_rev = @myKodPostavki AND 
            			dbo.[tbl������].[���������] = 'OK' AND
						dbo.[tbl������].[���_�������] = 'M' AND   					
  						dbo.[tbl������].[���������� ����������] IS NOT NULL
				ORDER BY dbo.[tbl������].��� DESC)

		select @my_chistota_S,@my_chistota_M,'___';
		
		IF @my_chistota_S is NULL SET @my_chistota_S = 101
		IF @my_chistota_M is NULL SET @my_chistota_M = 101
		IF @my_chistota_S <= @my_chistota SET @my_chistota = @my_chistota_S
		IF @my_chistota_M <= @my_chistota SET @my_chistota = @my_chistota_M
		IF @my_chistota = 101 SET @my_chistota = NULL
    end
select @my_chistota, 'Return2' 