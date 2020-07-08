
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		V.Zatkhey
-- Create date: 18.10.2018
-- Description:	получение уникальных номеров блоков для спектров
-- =============================================
--CREATE 
Alter PROCEDURE getSpectrumBlockNumber 
	@NumeratorID int  
	, @Seria varchar(10) 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	-- set isolation
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

	SET NOCOUNT ON;
	
	declare @NewValue bigint = null;
	declare @MaxValue bigint = null;

	begin tran
	
	-- автосинхронизация. на случай, если блок добавили "вручную"
	select @MaxValue = MAX(Номер_блока) from tblСпектр where Тип_спектра = @Seria;
	select @NewValue = Value from _NumbValue where NumeratorID = @NumeratorID and Seria = @Seria;
	select @NewValue = case when @NewValue < @MaxValue then @MaxValue else @NewValue end;

	
	if @NewValue is null 
		begin
		select @NewValue = 1;
		insert into _NumbValue(NumeratorID, Seria, Value) values(@NumeratorID,@Seria,@NewValue)
		end
		else
		begin 
		select @NewValue = @NewValue + 1;
		update _NumbValue set  Value = @NewValue where NumeratorID = @NumeratorID and Seria = @Seria;
		end
	
	commit	
	
	select @NewValue as Value

END
GO



GRANT execute
		ON [dbo].getSpectrumBlockNumber TO [Chest_Admins], [Chest_Postavki]
GO