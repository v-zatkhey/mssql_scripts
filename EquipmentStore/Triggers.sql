SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

use SKLAD30;
go


/****************** Item **********************/
-- CREATE
CREATE TRIGGER tr_eqsItem_ins 
   ON  dbo.eqsItem 
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Insert into eqsUnitFactor(UnitID,ItemID,UnitFactor)
	select 1, i.ID, 1
	from inserted i;

END;

GO

/********************* document *********************/
CREATE TRIGGER tr_eqsDocument_del  -- CREATE
   ON  dbo.eqsDocument
   AFTER DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--select @@TRANCOUNT; -- test
	if @@TRANCOUNT>1 commit
		else rollback;
	raiserror('Заборонено знищувати записи про документи!', 15, 1);
	return;

	
END;

GO

CREATE TRIGGER tr_eqsDocument_ins
   ON  dbo.eqsDocument
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if exists(select * 
			  from inserted i  
			  where i.DocState != 0) 
		begin
		raiserror('Заборонено створювати проведені документи!', 15, 1);
		return
		end
	
	update d	
	set DocDate  = CONVERT (date, i.DocDate)
	from eqsDocument d
		inner join inserted i on i.ID = d.ID;
	
		
	update d	
	set CreateDate = getdate()
		, CreateUser = system_user
	from eqsDocument d
		inner join inserted i on i.ID = d.ID;
		
END;

GO

-- drop trigger tr_eqsDocument_upd
CREATE TRIGGER tr_eqsDocument_upd 
   ON  dbo.eqsDocument
   AFTER  UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if exists(select * from deleted d where d.Isdeleted != 0)and not(UPDATE(IsDeleted) or UPDATE(ChangeDate) or UPDATE(ChangeUser))
		begin
		raiserror('Заборонено змінювати видалені документи!', 15, 1);
		return
		end
	
	if exists(select * from deleted d where d.DocState != 0) and not( update(DocState)or UPDATE(ChangeDate) or UPDATE(ChangeUser))
		begin
		raiserror('Заборонено змінювати проведені документи!', 15, 1);
		return
		end
	
	if exists(select * from inserted i where CONVERT (time, i.DocDate) != convert(time,'00:00:00.0'))
		update d
		set DocDate = CONVERT (date, i.DocDate)
		from eqsDocument d
			inner join inserted i on i.ID = d.ID
		where CONVERT (time, i.DocDate) != convert(time,'00:00:00.0') ; 
		
	if not update(ChangeDate) and not update(ChangeUser)	
			update d
			set ChangeDate = getdate(),
				ChangeUser = system_user
			from eqsDocument d
			where exists(select * from inserted where ID = d.ID);

END;
GO

/********************* eqsDocArticleIn *********************/
CREATE TRIGGER tr_eqsDocArticleIn_del  -- CREATE
   ON  dbo.eqsDocArticleIn
   AFTER DELETE
AS 
BEGIN

	SET NOCOUNT ON;

	if @@TRANCOUNT>1 commit
		else rollback;
	raiserror('Заборонено знищувати записи про документи!', 15, 1);
	return;

	
END;

GO

CREATE TRIGGER tr_eqsDocArticleIn_upd 
   ON  dbo.eqsDocArticleIn
   AFTER  UPDATE
AS 
BEGIN

	SET NOCOUNT ON;

	update d
	set ChangeDate = getdate(),
		ChangeUser = system_user
	from eqsDocument d
	where exists(select * from inserted where DocID = d.ID);

END;
GO
/********************* eqsDocIncoming *********************/
CREATE TRIGGER tr_eqsDocIncoming_del  -- CREATE
   ON  dbo.eqsDocIncoming
   AFTER DELETE
AS 
BEGIN

	SET NOCOUNT ON;

	if @@TRANCOUNT>1 commit
		else rollback;
	raiserror('Заборонено знищувати записи про документи!', 15, 1);
	return;

	
END;

GO

CREATE TRIGGER tr_eqsDocIncoming_upd 
   ON  dbo.eqsDocIncoming
   AFTER  UPDATE
AS 
BEGIN

	SET NOCOUNT ON;

	update d
	set ChangeDate = getdate(),
		ChangeUser = system_user
	from eqsDocument d
	where exists(select * from inserted where DocID = d.ID);

END;
GO
/********************* eqsDocInitial *********************/
CREATE TRIGGER tr_eqsDocInitial_del  -- CREATE
   ON  dbo.eqsDocInitial
   AFTER DELETE
AS 
BEGIN

	SET NOCOUNT ON;

	if @@TRANCOUNT>1 commit
		else rollback;
	raiserror('Заборонено знищувати записи про документи!', 15, 1);
	return;

	
END;

GO

CREATE TRIGGER tr_eqsDocInitial_upd 
   ON  dbo.eqsDocInitial
   AFTER  UPDATE
AS 
BEGIN

	SET NOCOUNT ON;

	update d
	set ChangeDate = getdate(),
		ChangeUser = system_user
	from eqsDocument d
	where exists(select * from inserted where DocID = d.ID);

END;
GO
/********************* eqsDocMove *********************/
CREATE TRIGGER tr_eqsDocMove_del  -- CREATE
   ON  dbo.eqsDocMove
   AFTER DELETE
AS 
BEGIN

	SET NOCOUNT ON;

	if @@TRANCOUNT>1 commit
		else rollback;
	raiserror('Заборонено знищувати записи про документи!', 15, 1);
	return;

	
END;

GO

CREATE TRIGGER tr_eqsDocMove_upd 
   ON  dbo.eqsDocMove
   AFTER  UPDATE
AS 
BEGIN

	SET NOCOUNT ON;

	update d
	set ChangeDate = getdate(),
		ChangeUser = system_user
	from eqsDocument d
	where exists(select * from inserted where DocID = d.ID);

END;
GO
/********************* eqsDocOutgoing *********************/
CREATE TRIGGER tr_eqsDocOutgoing_del  -- CREATE
   ON  dbo.eqsDocOutgoing
   AFTER DELETE
AS 
BEGIN

	SET NOCOUNT ON;

	if @@TRANCOUNT>1 commit
		else rollback;
	raiserror('Заборонено знищувати записи про документи!', 15, 1);
	return;

	
END;

GO

CREATE TRIGGER tr_eqsDocOutgoing_upd 
   ON  dbo.eqsDocOutgoing
   AFTER  UPDATE
AS 
BEGIN

	SET NOCOUNT ON;

	update d
	set ChangeDate = getdate(),
		ChangeUser = system_user
	from eqsDocument d
	where exists(select * from inserted where DocID = d.ID);

END;
GO
/********************* eqsDocRegrading *********************/
CREATE TRIGGER tr_eqsDocRegrading_del  -- CREATE
   ON  dbo.eqsDocRegrading
   AFTER DELETE
AS 
BEGIN

	SET NOCOUNT ON;

	if @@TRANCOUNT>1 commit
		else rollback;
	raiserror('Заборонено знищувати записи про документи!', 15, 1);
	return;

	
END;

GO

CREATE TRIGGER tr_eqsDocRegrading_upd 
   ON  dbo.eqsDocRegrading
   AFTER  UPDATE
AS 
BEGIN

	SET NOCOUNT ON;

	update d
	set ChangeDate = getdate(),
		ChangeUser = system_user
	from eqsDocument d
	where exists(select * from inserted where DocID = d.ID);

END;
GO
/********************* eqsDocWriteOff *********************/
CREATE TRIGGER tr_eqsDocWriteOff_del  -- CREATE
   ON  dbo.eqsDocWriteOff
   AFTER DELETE
AS 
BEGIN

	SET NOCOUNT ON;

	if @@TRANCOUNT>1 commit
		else rollback;
	raiserror('Заборонено знищувати записи про документи!', 15, 1);
	return;

	
END;

GO

CREATE TRIGGER tr_eqsDocWriteOff_upd 
   ON  dbo.eqsDocWriteOff
   AFTER  UPDATE
AS 
BEGIN

	SET NOCOUNT ON;

	update d
	set ChangeDate = getdate(),
		ChangeUser = system_user
	from eqsDocument d
	where exists(select * from inserted where DocID = d.ID);

END;
GO

/***************** Detail ********************/
CREATE TRIGGER tr_eqsDetail_ins_upd 
   ON  dbo.eqsDetail
   AFTER insert, update
AS 
BEGIN

	SET NOCOUNT ON;
/*перевірка кількості. від'ємна може бути тільки у пересортах*/
	if exists(	select * 
				from eqsDocument d 
					inner join inserted i on i.DocID = d.ID 
				where d.DocTypeID !=7 and i.Quantity <0
			 )
		begin
			raiserror('Кількість не може бути менше 0!', 15, 1);
			return;
		end;
/*перевірка стану документа.проведені не змінювати*/
	if exists(	select * 
				from eqsDocument d 
					inner join inserted i on i.DocID = d.ID 
				where d.DocState != 0
			 )
		begin
			raiserror('Заборонено редагувати документи!', 15, 1);
			return;
		end;		
/*оновлення деталей = оновлення документа*/		
	update d
	set ChangeDate = getdate(),
		ChangeUser = system_user
	from eqsDocument d
	where exists(select * from inserted where DocID = d.ID);
		
END;
go

CREATE TRIGGER tr_eqsDetail_del 
   ON  dbo.eqsDetail
   AFTER delete
AS 
BEGIN

	SET NOCOUNT ON;
/*перевірка кількості. заборона видалення якщо кількість не 0*/
	if exists(	select * 
				from deleted d  
				where d.Quantity != 0
			 )
		begin
			raiserror('Заборонено видаляти позиції якщо кількість не 0!', 15, 1);
			return;
		end;
		
END;
go

/********************* eqsRegRemainsP *********************/
CREATE TRIGGER tr_eqsRegRemainsP_del  
   ON  eqsRegRemainsP
   AFTER DELETE
AS 
BEGIN

	SET NOCOUNT ON;
	
	update r
	set Quantity = r.Quantity - x.Quantity
	from eqsRegRemainsR r
		inner join 
		(	
		select d.StoreID, d.ItemID, SUM(d.Quantity) as Quantity
		from deleted d
		group by d.StoreID, d.ItemID
		) x on x.StoreID = r.StoreID and x.ItemID = r.ItemID
		
	return;

	
END;

GO

-- drop trigger tr_eqsRegRemainsP_ins
CREATE TRIGGER tr_eqsRegRemainsP_ins
   ON  eqsRegRemainsP
   AFTER INSERT
AS 
BEGIN

	SET NOCOUNT ON;

	update r
	set Quantity = r.Quantity + x.Quantity
	from eqsRegRemainsR r
		inner join 
		(	
		select d.StoreID, d.ItemID, SUM(d.Quantity) as Quantity
		from inserted d
		group by d.StoreID, d.ItemID
		) x on x.StoreID = r.StoreID and x.ItemID = r.ItemID;
		
	insert into eqsRegRemainsR(StoreID,ItemID,Quantity)
	select x.StoreID, x.ItemID, x.Quantity
	from 
		(	
		select d.StoreID, d.ItemID, SUM(d.Quantity) as Quantity
		from inserted d
		group by d.StoreID, d.ItemID
		) x left join eqsRegRemainsR r on r.StoreID = x.StoreID and r.ItemID = x.ItemID	
	where r.StoreID is null;
		
END;

GO

-- drop trigger tr_eqsRegRemainsP_upd
CREATE TRIGGER tr_eqsRegRemainsP_upd 
   ON  dbo.eqsRegRemainsP
   AFTER  UPDATE
AS 
BEGIN

	SET NOCOUNT ON;

	if @@TRANCOUNT>1 commit
		else rollback;
	raiserror('Заборонено оновлювати регістр! Використовуйте delete/insert!', 15, 1);
	return;


END;
GO

/********************* eqsRegRemainsR *********************/
CREATE TRIGGER tr_eqsRegRemainsR_ins_upd 
   ON  dbo.eqsRegRemainsR
   AFTER  UPDATE, INSERT
AS 
BEGIN

	SET NOCOUNT ON;
	if exists(select * from inserted where Quantity < 0)
		begin
		if @@TRANCOUNT>1 commit
			else rollback;
		raiserror('Решта не може бути від"ємною!', 15, 1);
		end;
	return;


END;
GO