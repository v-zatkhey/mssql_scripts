USE [Chest35]
GO

/****** Object:  Trigger [dbo].[TR_UPDATE_tbl��������_new212]    Script Date: 07/21/2020 14:51:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER TRIGGER [dbo].[TR_UPDATE_tbl��������_new212] ON [dbo].[tbl��������]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN



INSERT INTO [TableLogs]  ([ActionID], [TableID], [TableKodID], 
		[IDNUMBER_old], [IDNUMBER_new],
		[DOC_old], [DOC_new],
		[DateTime_], [User_], 
		[Fields_])
select 2 /*'UPDATE'*/,  1 /*'tbl��������'*/, I.���, 
		D.[ID], I.[ID], D.[���_����������] + '-' + D.[���_��������], I.[���_����������] + '-' + I.[���_��������],
		getdate(), system_user,                                       
           (case When isnull(D.[�����],-1)<>isnull(I.[�����],-1) then '�.=' + isnull(Convert(varchar,D.[�����]),'null')  + '->' + isnull(Convert(varchar,I.[�����]),'null') else '' end) +
           (case When isnull(D.[�����10],-1)<>isnull(I.[�����10],-1) then ', �10=' + isnull(Convert(varchar,D.[�����10]),'null')  + '->' + isnull(Convert(varchar,I.[�����10]),'null') else '' end) +
           (case When isnull(D.[�����_����],-1)<>isnull(I.[�����_����],-1) then ', ���.=' + isnull(Convert(varchar,D.[�����_����]),'null') + '->' + isnull(Convert(varchar,I.[�����_����]),'null') else '' end) +
           (case When isnull(Convert(varchar,D.[����_����],3), 'null')<>isnull(Convert(varchar,I.[����_����],3), 'null') then ', ����_����.=' + isnull(Convert(varchar,D.[����_����],3), 'null') + '->' +  isnull(Convert(varchar,I.[����_����],3), 'null') else '' end) +
           (case When isnull(D.[���_�������],-1)<>isnull(I.[���_�������],-1) then ', ���_��.=' + isnull(Convert(varchar,D.[���_�������]),'null') + '->' + isnull(Convert(varchar,I.[���_�������]),'null') else '' end) +
           (case When D.[�������_��_��������]<>I.[�������_��_��������] then ', �������=' + isnull(Convert(varchar,D.[�������_��_��������]),'null') + '->' + Convert(varchar,I.[�������_��_��������]) else '' end) +
           (case When isnull(Convert(varchar,D.[����_�������_��_��������],3), 'null')<>isnull(Convert(varchar,I.[����_�������_��_��������],3), 'null') then ', ����_�������=' + isnull(Convert(varchar,D.[����_�������_��_��������],3), 'null') + '->' +  isnull(Convert(varchar,I.[����_�������_��_��������],3), 'null') else '' end) +
           (case When isnull(D.[�����������],-9)<>isnull(I.[�����������],-9) then ', �.=' + isnull(Convert(varchar,D.[�����������]),'null') + '->' + isnull(Convert(varchar,I.[�����������]),'null') else '' end) +
           (case When isnull(D.[�����������_��������],-9)<>isnull(I.[�����������_��������],-9) then ', �.�.=' + isnull(Convert(varchar,D.[�����������_��������]),'null') + '->' + isnull(Convert(varchar,I.[�����������_��������]),'null') else '' end) +
           (case When isnull(D.[������],-9)<>isnull(I.[������],-9) then ', ������=' + isnull(Convert(varchar,D.[������]),'null') + '->' +  isnull(Convert(varchar,I.[������]),'null') else '' end) +
           (case When isnull(D.[��������������],-9)<>isnull(I.[��������������],-9) then ', ������-���=' + isnull(Convert(varchar,D.[��������������]),'null') + '->' +  isnull(Convert(varchar,I.[��������������]),'null') else '' end)
from INSERTED as I  left join DELETED as D on (D.���=I.���)

DECLARE @ostatoktt_old as float
DECLARE @ostatoktt_new as float
DECLARE @Netto_old as float
DECLARE @Netto_new as float
DECLARE @Status_olds as int
DECLARE @Status_news as int
-- ������ ID 492 ��������� ������� ������ �������� � ������ ��������
DECLARE @Reason_old as varchar(255)
DECLARE @Reason_new as varchar(255)

select @ostatoktt_old = isnull(D.[�����_����],-1), @ostatoktt_new = isnull(I.[�����_����],-1),
	   @Netto_old = isnull(D.[�����_�����],-1), @Netto_new = isnull(I.[�����_�����],-1),	
	   @Status_olds = D.[�������_��_��������], @Status_news = I.[�������_��_��������],
	   @Reason_old = D.[�������_�������] , @Reason_new = I.[�������_�������]
from INSERTED as I  left join DELETED as D on (D.���=I.���)

/*'UPDATE'*/
IF ((@ostatoktt_new <> @ostatoktt_old) or (@Status_news <> @Status_olds) or (@Reason_old <> @Reason_new ))
BEGIN	 	
     INSERT INTO [tbl_������_��������]
     select I.[���], I.[ID], I.[���_����������], I.[���_��������], D.[�����_����], I.[�����_����],
            D.[�������_��_��������], I.[�������_��_��������],
            getdate(), system_user,
            2 ,
            Null, Null, I.[�������_�������]
     from INSERTED as I  left join DELETED as D on (D.���=I.���)     
END


IF (@Netto_new <> @Netto_old)
BEGIN	 	
     INSERT INTO [tbl_������_��������]
     select I.[���], I.[ID], I.[���_����������], I.[���_��������], D.[�����_�����], I.[�����_�����],
            D.[�������_��_��������], I.[�������_��_��������],
            getdate(), system_user,
            2 /*'UPDATE'*/,
            Null, Null, I.[�������_�������]
     from INSERTED as I  left join DELETED as D on (D.���=I.���)     
END

/*
DECLARE @myIDxxx varchar(50)
select @myIDxxx = I.[ID] from INSERTED as I
EXEC [dbo].[tbl�����_GB_Update] @myIDxxx
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
select	@Decision_2 = I.[�������_��_��������], @Decision_old_2 = D.[�������_��_��������],
        @Kod_zak_post_2 = I.[���_���_����],
		@Post1_0 = isnull(I.[���_����������],'-'), @Post2_0 = isnull(I.[���_��������],'-'),
		@Prim_0 =  isnull(I.[����������],'-'),
		@myID_0 =  isnull(I.[ID],'-'),
		@Sklad_prinato_0 = I.[�����_�������],
		@Sklad_prinato_old_0 = D.[�����_�������],
		@Protocol_old = D.[��������],
		@Protocol_new = I.[��������]
	from INSERTED as I  left join DELETED as D on (D.���=I.���)

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
������������� ����������� ��� �������� � ������� �� ����� - ������ ����� ��������� ���������� ������:
z30050, z10122, z10022

� �� ����� ��� z00401, z00402, z00403�z00409 ����� �� ��������� (������ ���������������� �� ��������, �� ���� � ������� ���-�� ����� �������� ��� ������ - �� �����.LabHead ����� �� ������, � ��������� �� ��������).

����� - 10070 ��� �� ������, �.�. ��� ����� ��� ������ �������� �� z00070=F.Hoffmann-La Roche-Switzerland - � (������ ��������) ��������������� �������� �� ���� ����� ���������� (����/����� ����� �������)!

�������. � ���������,
�����
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
			select @massa_tt = isnull([�����10],0) FROM dbo.tbl��������
				   where ([ID] = @myID_0) AND 
						 ([���_����������] = @Post1_0) AND 
						 ([���_��������] = @Post2_0) AND 
						 ([����������] = @Zak1_0 + '-' + @Zak2_0)

			INSERT INTO dbo.tbl����������������� ( 
				���_���������, ���_������, ID, ���, �����, ���_��������, 
				���_����������, ���_��������,
                SaltID_0,
                Need_Massa_1, �����_���������, �����������, ��������_���������, 
                ��������_�������, ����_���������, �����������_��_������� )
				(SELECT ���_���������, ���_������, ID, ���, @massa_tt /*�����_1*/, @otpravka, 
					    ���_����������, ���_��������,
                        SaltID_0,
                        Need_Massa_1, �����_���������, �����������, ��������_���������, 
                        ��������_�������, ����_���������, �����������_��_�������
                  FROM dbo.tbl������������� WHERE ID = @myID_0 AND 
												  [���_����������] = @Post1_0 AND 
												  [���_��������] = @Post2_0 AND 
												  [���_���������] = @Zak1_0 AND
												  [���_������] = @Zak2_0 )
			DELETE FROM dbo.tbl������������� WHERE ID = @myID_0 AND 
												   [���_����������] = @Post1_0 AND 
												   [���_��������] = @Post2_0 AND 
												   [���_���������] = @Zak1_0 AND
												   [���_������] = @Zak2_0
			SET @mykolvo = 0
			SELECT @mykolvo = isnull(Count(���_ID),0) FROM dbo.tbl����������������� 
				WHERE [���_���������] = @Zak1_0 AND [���_��������] = @otpravka
			SET @mykolvo_2 = 0
			SELECT @mykolvo_2 = isnull(count([���]),0) FROM dbo.tbl���������������
				WHERE [���_���������] = @Zak1_0 AND [���_��������] = @otpravka
			IF (@mykolvo_2 > 0)
			  BEGIN
				UPDATE dbo.tbl��������������� SET [����������] = @mykolvo
					WHERE ([���_���������] = @Zak1_0) AND ([���_��������] = @otpravka) AND ([����������] <> @mykolvo)
			  END
			ELSE
			  BEGIN
				IF (@mykolvo > 0)
				  BEGIN
					INSERT INTO dbo.tbl��������������� 
							   ([���_���������], ���_��������, [����������])
						VALUES (@Zak1_0, @otpravka, @mykolvo)
				  END
			  END
		  END
	  END
  END

--- 23.01.2020 ������� �� 6-���������� ��� ��������
IF (@Decision_2 <> @Decision_old_2)
  BEGIN
	   IF (@Decision_2 = 1)
        BEGIN
		  IF (@FlagAuto_0 = 1)
			BEGIN
			  SET @massa_tt = 0
			  IF (Len(@Prim_0)=12)
			    BEGIN
				  select @massa_tt = isnull([�����],0) FROM dbo.tbl������_2 
				   where [���_���������] = @Zak1_0 and [���_������] = @Zak2_0
			    END			
			  UPDATE dbo.tbl������������� 
				SET [���_��������] = 's99999', [�����_1] = @massa_tt,
                    [���_����������] = @Post1_0, [���_��������] = @Post2_0
              WHERE ([ID] = @myID_0) and ([���_���������] = @Zak1_0) and ([���_������] = @Zak2_0)			  
			END		  
		END
	   ELSE
		BEGIN
		  IF (@FlagAuto_0 = 1)
			BEGIN			  
			  UPDATE dbo.tbl������������� 
				SET [���_��������] = 's00000', [�����_1] = 0,
                    [���_����������] = Null, [���_��������] = Null
              WHERE ([ID] = @myID_0) and ([���_���������] = @Zak1_0) and ([���_������] = @Zak2_0) and
					([���_����������] = @Post1_0) and ([���_��������] = @Post2_0)
			END		  
		END
  END    

IF (@Decision_2 <> @Decision_old_2) AND (@Kod_zak_post_2 > 0) AND (@Sklad_prinato_0 = 0)
BEGIN
  IF (@Decision_2 = 1)
  BEGIN
	/*prinjato*/
	UPDATE [dbo].[tbl�������������������1] SET [������] = 2, [��������] = [��������], [��_��������] = '��' WHERE [���] = @Kod_zak_post_2
  END
  ELSE
  BEGIN
	/*ne prinjato*/
	SET @Date_kon_2 = NULL
	select @Date_kon_2 = [����_���] from [dbo].[tbl�������������������1] WHERE [���] = @Kod_zak_post_2
	IF (@Date_kon_2 is NULL) OR (@Date_kon_2 >= getdate())
	BEGIN
	     /*net*/
         UPDATE [dbo].[tbl�������������������1] SET [������] = 1, [��������] = 0, [��_��������] = '���' WHERE [���] = @Kod_zak_post_2
	END
	ELSE
	BEGIN
	     /*istek srok zakaza*/
	     UPDATE [dbo].[tbl�������������������1] SET [������] = 10, [��������] = 0, [��_��������] = '���' WHERE [���] = @Kod_zak_post_2
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
	select	@Kod = I.[���], @Sklad = I.[�����], @Sklad_old = D.[�����],
			@Sklad_prinyato = I.[�����_�������], @Sklad_prinyato_old = D.[�����_�������],
            @MassaSklad = I.[�����_����], @MassaSklad_old = D.[�����_����],
            @Massa10 = I.[�����10], @Massa10_old = D.[�����10],
            @DateSklad_1st = D.[����_�����_1st],
			@Decision = I.[�������_��_��������], @Decision_old = D.[�������_��_��������],
			@Dec_Analiz = I.[�������_��_�������], @Dec_Analiz_old = D.[�������_��_�������],
			@Post1 = isnull(I.[���_����������],'-'), @Post2 = isnull(I.[���_��������],'-'),
			@Prim =  isnull(I.[����������],'-'),
            @FragmentObr_new = I.[������������������], @FragmentObr_old = D.[������������������]
	from INSERTED as I  left join DELETED as D on (D.���=I.���)
	
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
		UPDATE dbo.tbl��������
		SET [����_���������] = @my_Date2
		WHERE [���] = @Kod
	END
    
    IF (@FragmentObr_old = 0) AND (@FragmentObr_new = 1)
	BEGIN		
		UPDATE dbo.tbl��������
		SET [����������������������] = @my_Date2, [����������������������Full] = getdate()
		WHERE [���] = @Kod
	END

	IF (@Dec_Analiz <> @Dec_Analiz_old)
	 BEGIN
		UPDATE dbo.tbl�������� SET [����_�������_��_�������] = getdate() WHERE [���] = @Kod
	 END

	/**/
	IF (@Sklad_prinyato_old <> @Sklad_prinyato)
	BEGIN
		IF (@Sklad_prinyato = 1)
			UPDATE dbo.tbl�������� SET [�����_�������_�����_����������_�������] = 1 WHERE [���] = @Kod
	END
	/**/

	IF (isnull(@Massa10_old,-1) <> isnull(@Massa10,-1)) AND (isnull(@MassaSklad,-1) = -1) AND (isnull(@MassaSklad_old,-1) = -1)
     BEGIN
     	UPDATE dbo.tbl�������� SET [�����_�����] = @Massa10 WHERE [���] = @Kod
        INSERT INTO [tbl_������_��������]
     		select I.[���], I.[ID], I.[���_����������], I.[���_��������], D.[�����_����], I.[�����_����],
            		D.[�������_��_��������], I.[�������_��_��������],
            		getdate(), system_user,
            		2 /*'UPDATE'*/ ,
            		'�����10', '����� �����', I.[�������_�������]
     		from INSERTED as I  left join DELETED as D on (D.���=I.���)         
     END

	IF (isnull(@MassaSklad_old,-1) <> isnull(@MassaSklad,-1))
     BEGIN
     	UPDATE dbo.tbl�������� SET [�����_�����] = @MassaSklad WHERE [���] = @Kod
        INSERT INTO [tbl_������_��������]
     		select I.[���], I.[ID], I.[���_����������], I.[���_��������], D.[�����_����], I.[�����_����],
            		D.[�������_��_��������], I.[�������_��_��������],
            		getdate(), system_user,
            		2 /*'UPDATE'*/ ,
            		'������� �� ������', '����� �����', I.[�������_�������]
     		from INSERTED as I  left join DELETED as D on (D.���=I.���)         
     END
     
	IF (@Decision = 1) AND
    	(@MassaSklad_old IS NULL) AND (@MassaSklad IS NOT NULL) AND 
        (@DateSklad_1st IS NULL)
     BEGIN
     	UPDATE dbo.tbl�������� SET [����_�����_1st] = getdate() WHERE [���] = @Kod
     END
    
	IF (@Decision <> @Decision_old)
	 BEGIN
	   IF (@Decision = 1)
        BEGIN
		  IF (@FlagAuto = 1)
			UPDATE dbo.tbl�������� SET [�����_���] = 0, [�����] = 1, [�� �����������] = 1, [����_�������_��_��������] = getdate(), [����_�����] = getdate() WHERE [���] = @Kod
		  ELSE
			UPDATE dbo.tbl�������� SET [�����_���] = 0, [�����] = 1, [����_�������_��_��������] = getdate(), [����_�����] = getdate() WHERE [���] = @Kod
		END
	   ELSE
		BEGIN
		  IF (@FlagAuto = 1)
			UPDATE dbo.tbl�������� SET [�����_���] = 0, [�����] = 0, [�� �����������] = 0, [����_�������_��_��������] = getdate(), [����_�����] = getdate() WHERE [���] = @Kod
		  ELSE
			UPDATE dbo.tbl�������� SET [�����_���] = 0, [�����] = 0, [����_�������_��_��������] = getdate(), [����_�����] = getdate() WHERE [���] = @Kod
		END
	 END
	ELSE
	 BEGIN
		IF (@Sklad_prinyato_old <> @Sklad_prinyato)
		 BEGIN
			IF (@Sklad_prinyato = 1)
			  UPDATE dbo.tbl�������� SET [�����_�������_�����_����������_�������] = 1 WHERE [���] = @Kod
		 END		  
	 END

END


END

GO

