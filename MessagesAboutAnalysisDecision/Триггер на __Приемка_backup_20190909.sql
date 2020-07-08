USE [SKLAD30]
GO

/****** Object:  Trigger [dbo].[TR_UPDATE_Sklad30_�������]    Script Date: 09/09/2019 11:45:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER TRIGGER [dbo].[TR_UPDATE_Sklad30_�������] ON [dbo].[__�������]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN

  IF UPDATE([���_�])
    BEGIN      
      RAISERROR (' !!! [���_�] is not changeable  !!!', 16, 1)
      ROLLBACK TRANSACTION 
      RETURN
    END

  DECLARE @myKod_ID_postavki int, @myKod_s int
  DECLARE @myDate smalldatetime
  DECLARE @myPeriod smalldatetime
  DECLARE @str varchar(255)
  DECLARE @myKod_ID_Istochnika int
  DECLARE @myKod_ID_veschestva int
  DECLARE @myNomer_postavki varchar(255)
  DECLARE @Kod_Spectra_changed bit
  DECLARE @Decision_changed bit
  DECLARE @Position_changed bit
  DECLARE @Labels_changed bit, @Label_old bit, @Label_new bit
  DECLARE @myKod_ID_priemki int
  DECLARE @myQty int
  DECLARE @myVersion int
  
  SET @Kod_Spectra_changed = 0
  IF UPDATE([���_�������])
  	BEGIN
    	SET @Kod_Spectra_changed = 1
    END
  SET @Decision_changed = 0
  IF UPDATE(�������_��_�������) or 
     UPDATE(����_�������_��_�������) or 
     UPDATE(�������_�������_��_�������) or
     UPDATE(Qual)
  	BEGIN
    	SET @Decision_changed = 1
    END
  SET @Position_changed = 0
  IF UPDATE(�����_������) or 
     UPDATE(�����_��������) or 
     UPDATE(�����_�����) or
     UPDATE(�����_������) or
     UPDATE(�����_�����)
  	BEGIN
    	SET @Position_changed = 1
    END
    
  SET @myKod_ID_priemki = -1
  SET @myQty = 0
  SET @myVersion = 0
  SET @Label_old = 0
  SET @Label_new = 0
  SET @Labels_changed = 0
  IF UPDATE(��������)
  	BEGIN
    	SET @Labels_changed = 1        
    END 

  

  select @myKod_ID_postavki = [���_ID_��������], @myKod_s = [���_�], 
  		 @myKod_ID_veschestva = [���_ID_��������], @Label_old = [��������] from DELETED
  SET @myKod_s = isnull(@myKod_s,0)
  SET @myKod_ID_postavki = isnull(@myKod_ID_postavki,0)
  SET @myKod_ID_veschestva = isnull(@myKod_ID_veschestva,0)
  select @myDate = [����], @myKod_ID_Istochnika = [���_ID_���������], @myNomer_postavki = [�����_��������] from [__��������] where [���_ID] = @myKod_ID_postavki
  SET @myKod_ID_Istochnika = isnull(@myKod_ID_Istochnika,0)
  SET @myNomer_postavki = isnull(@myNomer_postavki,'')
  SET @myDate = isnull(@myDate,convert(smalldatetime,'01.01.70',4))
  select @myPeriod = [Period] from [������] where [���] = @myKod_s
  SET @myPeriod = isnull(@myPeriod,getdate())


DECLARE @myIstochnik varchar(255)
DECLARE @myCAS varchar(255)
SELECT @myIstochnik = [��������] FROM [__���������] WHERE [���_ID] = @myKod_ID_Istochnika
SELECT @myCAS = [CAS] FROM [__��������] WHERE [���_ID] = @myKod_ID_veschestva
SET @myIstochnik = isnull(@myIstochnik,'')
SET @myCAS = isnull(@myCAS,'')

IF (@Kod_Spectra_changed = 0) AND (@Decision_changed = 0) AND (@Position_changed = 0) AND (@Labels_changed = 0)
BEGIN
 IF not (@myIstochnik = '<non>')
 BEGIN
  IF @myDate < @myPeriod
    BEGIN
      set @str = ' !!! Period was closed  !!!' + ' (' + convert(varchar,@myDate,4) + ' < ' + convert(varchar,@myPeriod,4) + ')'
      RAISERROR (@str, 16, 1)
      ROLLBACK TRANSACTION 
      RETURN
    END
 END
END

  select @myKod_ID_postavki = [���_ID_��������], @myKod_s = [���_�], 
  		 @Label_new = [��������], @myKod_ID_priemki = [���_ID], @myQty = [Qty] from INSERTED
  SET @myKod_s = isnull(@myKod_s,0)
  SET @myKod_ID_postavki = isnull(@myKod_ID_postavki,0)
  select @myDate = [����] from [__��������] where [���_ID] = @myKod_ID_postavki
  SET @myDate = isnull(@myDate,convert(smalldatetime,'01.01.70',4))
  select @myPeriod = [Period] from [������] where [���] = @myKod_s
  SET @myPeriod = isnull(@myPeriod,getdate())

IF (@Kod_Spectra_changed = 0) AND (@Decision_changed = 0) AND (@Position_changed = 0) AND (@Labels_changed = 0)
BEGIN
 IF not ( (not (UPDATE([���_ID_��������])))   AND  (@myIstochnik = '<non>') )
 BEGIN
  IF @myDate < @myPeriod
    BEGIN
      set @str = ' !!! Period was closed  !!!' + ' (' + convert(varchar,@myDate,4) + ' < ' + convert(varchar,@myPeriod,4) + ')'
      RAISERROR (@str, 16, 1)
      ROLLBACK TRANSACTION 
      RETURN
    END
 END
END

IF UPDATE([Qty]) AND (@Label_old = 1) AND (@Label_new = 1)
BEGIN
	/*
    RAISERROR (' !!! You can not change [Qty] when [Labels] is True !!!', 16, 1)
    ROLLBACK TRANSACTION 
    RETURN
    */
    UPDATE [__�������] SET [��������]=0 WHERE [���_ID] = @myKod_ID_priemki
END

DECLARE @i int = 1
IF (@Labels_changed = 1) AND (@Label_new <> @Label_old)
BEGIN
  	SELECT @myVersion = ISNULL(MAX([Version]),0)+1 FROM [__�������_Items_History] WHERE [���_ID_�������] = @myKod_ID_priemki
    IF @myVersion > 0
     BEGIN
		DELETE FROM [__�������_Items]
    	  WHERE [���_ID_�������] = @myKod_ID_priemki AND [Version] < @myVersion
     END
    IF @Label_new = 1
    BEGIN
        IF @myVersion > 0
        BEGIN
    		WHILE @i <= @myQty
        	BEGIN            	
        		INSERT INTO [__�������_Items] ([���_ID_�������], [Item_Number], [Item_Kolvo], [Version])
            		VALUES (@myKod_ID_priemki, @i, @myQty, @myVersion)
                SET @i = @i + 1
        	END
        END
    END
END

INSERT INTO [TableLogs]  
select getdate(), I.[Session_ID], I.[���_�], 
2 /*��������*/,
7 /*__�������*/,
I.[���_ID], @myIstochnik + '-' + @myNomer_postavki, @myCAS,
'���=' + convert(varchar,isnull(D.[���],0)) +
case when ( convert(varchar,isnull(D.[���],0)) <> convert(varchar,isnull(I.[���],0)) )
then
'->' + convert(varchar,isnull(I.[���],0))
else
''
end +
', ���-��=' + convert(varchar,isnull(D.[Size],0)*isnull(D.[Qty],1)) + ' ' + isnull(D.[UM],'') + 
case when ( (convert(varchar,isnull(D.[Size],0)*isnull(D.[Qty],1)) + ' ' + isnull(D.[UM],'')) <> (convert(varchar,isnull(I.[Size],0)*isnull(I.[Qty],1)) + ' ' + isnull(I.[UM],'')) )
then
'->' + isnull(convert(varchar,isnull(I.[Size],0)*isnull(I.[Qty],1)),'0') + ' ' + isnull(I.[UM],'')
else
''
end +
', UAH_CostPrice=' + convert(varchar,isnull(D.[UAH_CostPrice],0)) +
case when ( (convert(varchar,isnull(D.[UAH_CostPrice],0))) <> (convert(varchar,isnull(I.[UAH_CostPrice],0))) )
then
'->' + convert(varchar,isnull(I.[UAH_CostPrice],0))
else
''
end
from INSERTED as I  left join DELETED as D on (D.���_ID=I.���_ID)





  DECLARE @KodP int  
  DECLARE @KodV int
  DECLARE @CatNumbr varchar(255)  
  DECLARE @IDNUMBER0 varchar(255)

  SELECT @KodP=[���_ID], @CatNumbr=[CatNumbr] FROM INSERTED  
  IF @KodP > 0
    BEGIN
   	  IF len(@CatNumbr) >= 10 AND (UPPER(LEFT(@CatNumbr,1)) = 'F') AND (SUBSTRING(@CatNumbr,6,1) = '-')
   		 AND (ISNUMERIC(SUBSTRING(@CatNumbr,2,4)) = 1) AND (ISNUMERIC(SUBSTRING(@CatNumbr,7,4)) = 1)
   	 	BEGIN
           	SELECT @IDNUMBER0=dbo.[__��������].IDNUMBER0, @KodV=dbo.[__��������].[���_ID] FROM dbo.[__�������] 
	           	INNER JOIN dbo.[__��������] ON (dbo.[__�������].[���_ID_��������] = dbo.[__��������].[���_ID])
				WHERE dbo.[__�������].[���_ID] = @KodP
			IF isnull(@IDNUMBER0,'') = ''
			 BEGIN
   	    		UPDATE dbo.[__��������] SET [IDNUMBER0] = UPPER(LEFT(@CatNumbr,10)) WHERE [���_ID] = @KodV
             END
        END    
  END

  





IF @@NESTLEVEL = 3
BEGIN
  DECLARE @Kod int
  
  DECLARE @UMx varchar(50)
  SELECT @Kod=[���_ID], @UMx=[UM] FROM INSERTED
  
  IF isnull(@UMx,'') = ''
  	BEGIN
    	UPDATE dbo.[__�������] SET [UM] = 'g' WHERE [���_ID] = @Kod
    END
  
  IF UPDATE([�������_��_�������])
  	BEGIN
    	/*SELECT @Kod=[���_ID] FROM INSERTED*/
    	UPDATE dbo.[__�������] SET [����_�������_��_�������] = getdate() WHERE [���_ID] = @Kod
    END	
  
  
  
END





END

GO


