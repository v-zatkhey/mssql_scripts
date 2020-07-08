/********* процедури, що пов'язані зі зміною статусу документів ********/
/*Процедури за типами роблять зміни в реєстрах*/
/*Процедури eqsDocument... викликають в транзакції процедури відповідно типу документа, а потім оновлюють статус*/
/*Статус - бітова маска кодів статуса*/

--eqsDocIncoming
if OBJECT_ID(N'eqsDocIncomingFinYes') is not null drop procedure eqsDocIncomingFinYes;
go

create procedure eqsDocIncomingFinYes @DocID int 
as
begin
	declare @errmsg varchar(max);
	begin try
		begin tran;
		
		insert into eqsRegRemainsP(StoreID,DocID, DocDate,ItemID,Quantity)
		select i.StoreID, d.ID, d.DocDate, t.ItemID, t.Quantity
		from eqsDocument d
			inner join eqsDocIncoming i on i.DocID = d.ID
			inner join eqsDetail t on t.DocID = d.ID
		where d.ID = @DocID;

		commit;	
		return;
	end try
	begin catch
		if (@@TRANCOUNT > 1) commit 
						   else rollback;
		select @errmsg = 'Помилка проведення документа ' + CAST(@DocID as varchar(32)) + ': ' + ERROR_MESSAGE();
		raiserror(@errmsg, 16,1);
	end catch;
end
go

GRANT EXEC ON eqsDocIncomingFinYes TO [SKLAD30], [IFLAB\S.Golubkov];
go


--eqsDocOutgoing
if OBJECT_ID(N'eqsDocOutgoingFinYes') is not null drop procedure eqsDocOutgoingFinYes;
go

create procedure eqsDocOutgoingFinYes @DocID int 
as
begin
	declare @errmsg varchar(max);
	begin try
		begin tran;
		
		insert into eqsRegRemainsP(StoreID,DocID, DocDate,ItemID,Quantity)
		select i.StoreID, d.ID, d.DocDate, t.ItemID, -t.Quantity
		from eqsDocument d
			inner join eqsDocOutgoing i on i.DocID = d.ID
			inner join eqsDetail t on t.DocID = d.ID
		where d.ID = @DocID;

		commit;	
		return;
	end try
	begin catch
		if (@@TRANCOUNT > 1) commit 
						   else rollback;
		select @errmsg = 'Помилка проведення документа ' + CAST(@DocID as varchar(32)) + ': ' + ERROR_MESSAGE();
		raiserror(@errmsg, 16,1);
	end catch;
end
go

GRANT EXEC ON eqsDocOutgoingFinYes TO [SKLAD30], [IFLAB\S.Golubkov];
go


--eqsDocMove
if OBJECT_ID(N'eqsDocMoveFinYes') is not null drop procedure eqsDocMoveFinYes;
go

create procedure eqsDocMoveFinYes @DocID int 
as
begin
	declare @errmsg varchar(max);
	begin try
		begin tran;
		
		insert into eqsRegRemainsP(StoreID, DocID, DocDate,ItemID,Quantity)
		select i.SourceStoreID, d.ID, d.DocDate, t.ItemID, -t.Quantity
		from eqsDocument d
			inner join eqsDocMove i on i.DocID = d.ID
			inner join eqsDetail t on t.DocID = d.ID
		where d.ID = @DocID;

		insert into eqsRegRemainsP(StoreID, DocID, DocDate,ItemID,Quantity)
		select i.TargetStoreID, d.ID, d.DocDate, t.ItemID, t.Quantity
		from eqsDocument d
			inner join eqsDocMove i on i.DocID = d.ID
			inner join eqsDetail t on t.DocID = d.ID
		where d.ID = @DocID;

		commit;	
		return;
	end try
	begin catch
		if (@@TRANCOUNT > 1) commit 
						   else rollback;
		select @errmsg = 'Помилка проведення документа ' + CAST(@DocID as varchar(32)) + ': ' + ERROR_MESSAGE();
		raiserror(@errmsg, 16,1);
	end catch;
end
go

GRANT EXEC ON eqsDocMoveFinYes TO [SKLAD30], [IFLAB\S.Golubkov];
go


--eqsDocInitial
if OBJECT_ID(N'eqsDocInitialFinYes') is not null drop procedure eqsDocInitialFinYes;
go

create procedure eqsDocInitialFinYes @DocID int 
as
begin
	declare @errmsg varchar(max);
	begin try
		begin tran;
		
		insert into eqsRegRemainsP(StoreID,DocID, DocDate,ItemID,Quantity)
		select i.StoreID, d.ID, d.DocDate, t.ItemID, t.Quantity
		from eqsDocument d
			inner join eqsDocInitial i on i.DocID = d.ID
			inner join eqsDetail t on t.DocID = d.ID
		where d.ID = @DocID;

		commit;	
		return;
	end try
	begin catch
		if (@@TRANCOUNT > 1) commit 
						   else rollback;
		select @errmsg = 'Помилка проведення документа ' + CAST(@DocID as varchar(32)) + ': ' + ERROR_MESSAGE();
		raiserror(@errmsg, 16,1);
	end catch;
end
go

GRANT EXEC ON eqsDocInitialFinYes TO [SKLAD30], [IFLAB\S.Golubkov];
go

--eqsDocWriteOff
if OBJECT_ID(N'eqsDocWriteOffFinYes') is not null drop procedure eqsDocWriteOffFinYes;
go

create procedure eqsDocWriteOffFinYes @DocID int 
as
begin
	declare @errmsg varchar(max);
	begin try
		begin tran;
		
		insert into eqsRegRemainsP(StoreID,DocID, DocDate,ItemID,Quantity)
		select i.StoreID, d.ID, d.DocDate, t.ItemID, -t.Quantity
		from eqsDocument d
			inner join eqsDocWriteOff i on i.DocID = d.ID
			inner join eqsDetail t on t.DocID = d.ID
		where d.ID = @DocID;

		commit;	
		return;
	end try
	begin catch
		if (@@TRANCOUNT > 1) commit 
						   else rollback;
		select @errmsg = 'Помилка проведення документа ' + CAST(@DocID as varchar(32)) + ': ' + ERROR_MESSAGE();
		raiserror(@errmsg, 16,1);
	end catch;
end
go

GRANT EXEC ON eqsDocWriteOffFinYes TO [SKLAD30], [IFLAB\S.Golubkov];
go


--eqsDocArticleIn
if OBJECT_ID(N'eqsDocArticleInFinYes') is not null drop procedure eqsDocArticleInFinYes;
go

create procedure eqsDocArticleInFinYes @DocID int 
as
begin
	declare @errmsg varchar(max);
	begin try
		begin tran;
		
		insert into eqsRegRemainsP(StoreID,DocID, DocDate,ItemID,Quantity)
		select i.StoreID, d.ID, d.DocDate, t.ItemID, t.Quantity
		from eqsDocument d
			inner join eqsDocArticleIn i on i.DocID = d.ID
			inner join eqsDetail t on t.DocID = d.ID
		where d.ID = @DocID;

		commit;	
		return;
	end try
	begin catch
		if (@@TRANCOUNT > 1) commit 
						   else rollback;
		select @errmsg = 'Помилка проведення документа ' + CAST(@DocID as varchar(32)) + ': ' + ERROR_MESSAGE();
		raiserror(@errmsg, 16,1);
	end catch;
end
go

GRANT EXEC ON eqsDocArticleInFinYes TO [SKLAD30], [IFLAB\S.Golubkov];
go

--eqsDocRegrading
if OBJECT_ID(N'eqsDocRegradingFinYes') is not null drop procedure eqsDocRegradingFinYes;
go

create procedure eqsDocRegradingFinYes @DocID int 
as
begin
	declare @errmsg varchar(max);
	begin try
		begin tran;
		
		insert into eqsRegRemainsP(StoreID,DocID, DocDate,ItemID,Quantity)
		select i.StoreID, d.ID, d.DocDate, t.ItemID, t.Quantity
		from eqsDocument d
			inner join eqsDocRegrading i on i.DocID = d.ID
			inner join eqsDetail t on t.DocID = d.ID
		where d.ID = @DocID;

		commit;	
		return;
	end try
	begin catch
		if (@@TRANCOUNT > 1) commit 
						   else rollback;
		select @errmsg = 'Помилка проведення документа ' + CAST(@DocID as varchar(32)) + ': ' + ERROR_MESSAGE();
		raiserror(@errmsg, 16,1);
	end catch;
end
go

GRANT EXEC ON eqsDocRegradingFinYes TO [SKLAD30], [IFLAB\S.Golubkov];
go



/************************ eqsDocument *******************************************/
if OBJECT_ID(N'eqsDocumentFinYes') is not null drop procedure eqsDocumentFinYes;
go

create procedure eqsDocumentFinYes @DocID int 
as
begin
	declare @errmsg varchar(max);
	declare @DocTypeID int;
	
	if exists(select * from eqsDocument where ID = @DocID and DocState&1=1) return; -- документ вже проведений
	
	select @DocTypeID = DocTypeID from eqsDocument where ID = @DocID;
	begin try
		begin tran;
		
		if @DocTypeID = 1	--Прибуткова накладна		
			exec eqsDocIncomingFinYes @DocID;
			else if @DocTypeID = 2	--Видаткова накладна		
				exec eqsDocOutgoingFinYes @DocID;
				else if @DocTypeID = 3	--Накладна на внутрішнє переміщення		
					exec eqsDocMoveFinYes @DocID;
					else if @DocTypeID = 4	--Початкові залишки		
						exec eqsDocInitialFinYes @DocID;
						else if @DocTypeID = 5	-- Списання		
							exec eqsDocWriteOffFinYes @DocID;
							else if @DocTypeID = 6	--Прибуток зі статті		
								exec eqsDocArticleInFinYes @DocID;
								else if  @DocTypeID = 7	--Пересортиця		
									exec eqsDocRegradingFinYes @DocID;
									else raiserror('Проведення документа невідомого типу.',16,1);
						
		update eqsDocument set DocState = DocState|1 where ID = @DocID;			
		
		commit;	
		return;
	end try
	begin catch
		if (@@TRANCOUNT > 1) commit 
						   else rollback;
		select @errmsg = ERROR_MESSAGE();
		raiserror(@errmsg, 16,1);
	end catch;
end
go

GRANT EXEC ON eqsDocumentFinYes TO [SKLAD30], [IFLAB\S.Golubkov];
go


	
/* розпроведення - загальне*/
if OBJECT_ID(N'eqsDocumentFinNo') is not null drop procedure eqsDocumentFinNo;
go

create procedure eqsDocumentFinNo @DocID int 
as
begin
	declare @errmsg varchar(max);
	if exists(select * from eqsDocument where ID = @DocID and DocState&1=0) return; -- документ не проведений

	begin try
		begin tran;
		
		delete from eqsRegRemainsP where DocID = @DocID;
		update eqsDocument set DocState = DocState^1 where ID = @DocID;			
		commit;	
		return;
	end try
	begin catch
		if (@@TRANCOUNT > 1) commit 
						   else rollback;
		select @errmsg = 'Помилка розпроведення документа ' + CAST(@DocID as varchar(32)) + ': ' + ERROR_MESSAGE();
		raiserror(@errmsg, 16,1);
	end catch;
end
go

GRANT EXEC ON eqsDocumentFinNo TO [SKLAD30], [IFLAB\S.Golubkov];
go

/*
exec eqsDocumentFinYes 27;
select * from eqsDocument where ID = 27;
select * from eqsDetail where DocID = 27;
exec eqsDocMoveFinYes_ 27;

--test
select * from eqsDocument
select * from eqsDocType
select * from eqsItem where ID = 9 -- 9 Лапка для лабораторного штатива

--insert into eqsDetail (DocID,ItemID,Quantity,UnitFactor) values (2,9,15,1),(7,9,5,1);
select * from eqsDocument d inner join eqsDetail t on t.DocID = d.ID;

exec eqsDocumentFinYes 2;

select * from eqsRegRemainsP
select * from eqsRegRemainsR

exec eqsDocumentFinYes 7;

select * from eqsDocument d where id in (2,7);
select * from eqsRegRemainsP
select * from eqsRegRemainsR

-- exec eqsDocumentFinNo 2; --  в таком порядке не будет работать
exec eqsDocumentFinNo 7;
exec eqsDocumentFinNo 2;

select * from eqsDocument d where id in (2,7);

select * from eqsRegRemainsP
select * from eqsRegRemainsR


*/


/******** загальна схема процедур ********/
/*

if OBJECT_ID(N'<...>') is not null drop procedure <...>;
go

create procedure <...> @DocTypeID int, @DocID int 
as
begin
	declare @errmsg varchar(max);
	begin try
		begin tran;


		commit;	
		return;
	end try
	begin catch
		if (@@TRANCOUNT > 1) commit 
						   else rollback;
		select @errmsg = 'Помилка створення документа: ' + ERROR_MESSAGE();
		raiserror(@errmsg, 16,1);
	end catch;
end

GRANT EXEC ON <...> TO [SKLAD30], [IFLAB\S.Golubkov];
go

*/