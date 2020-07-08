/***** процедуры ведения жизненного цикла документов ******/

if OBJECT_ID(N'eqsDocumentCreate') is not null drop procedure eqsDocumentCreate;
go

create procedure eqsDocumentCreate @DocTypeID int, @DocID int output
as
begin
	declare @errmsg varchar(max);
	begin try
		begin tran;
			if not exists(select * from eqsDocType where ID = @DocTypeID) raiserror('Невідомий тип документа.', 16,1);
			insert into dbo.eqsDocument(DocTypeID, DocDate)
								values (@DocTypeID, GETDATE());
			select @DocID = SCOPE_IDENTITY();
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
go

GRANT EXEC ON eqsDocumentCreate TO [SKLAD30], [IFLAB\S.Golubkov];
go



/* test
declare @DocID int;
exec eqsDocumentCreate 1, @DocID output;

select @DocID; select * from eqsDocument where ID = @DocID;

select * 
from eqsDocument d 
	inner join dbo.eqsDocType t on d.DocTypeID = t.ID;

select * from eqsDocType
*/

if OBJECT_ID(N'eqsDocumentDelete') is not null drop procedure eqsDocumentDelete;
go

create procedure eqsDocumentDelete @DocID int output
as
begin
	declare @errmsg varchar(max);
	begin try
		-- якщо документ вже видалено - нічого не робимо
		if (select MIN(IsDeleted) from eqsDocument where ID = @DocID) = 1 return;
		
		begin tran
		if exists(select * from eqsDocument where ID = @DocID and DocState > 0) raiserror('Заборонено видаляти дійсний документ.', 16,1);
		
		update eqsDocument set IsDeleted = 1 where ID = @DocID;
		commit;
		return;
	end try
	begin catch
		if (@@TRANCOUNT > 1) commit 
						   else rollback;
		select @errmsg = 'Помилка видалення документа: ' + ERROR_MESSAGE();
		raiserror(@errmsg, 16,1);
	end catch;
end
go

GRANT EXEC ON eqsDocumentDelete TO [SKLAD30], [IFLAB\S.Golubkov];
go

if OBJECT_ID(N'eqsDocumentRestore') is not null drop procedure eqsDocumentRestore;
go

create procedure eqsDocumentRestore @DocID int output
as
begin
	declare @errmsg varchar(max);
	begin try
		-- якщо не є видаленим - нічого не робимо
		if (select MIN(IsDeleted) from eqsDocument where ID = @DocID) = 0 return;
		-- відновлений документ - чернетка
		update eqsDocument set IsDeleted = 0, DocState = 0 where ID = @DocID;

		return;
	end try
	begin catch
		if (@@TRANCOUNT > 1) commit 
						   else rollback;
		select @errmsg = 'Помилка відновлення документа: ' + ERROR_MESSAGE();
		raiserror(@errmsg, 16,1);
	end catch;
end
go

GRANT EXEC ON eqsDocumentRestore TO [SKLAD30], [IFLAB\S.Golubkov];
go
/*
--test
declare @DocID int = 2;

select * from eqsDocument where ID = @DocID
exec eqsDocumentDelete @DocID 
select * from eqsDocument where ID = @DocID
exec eqsDocumentRestore @DocID 
select * from eqsDocument where ID = @DocID

update eqsDocument set DocState = 1  where ID = @DocID
select * from eqsDocument where ID = @DocID
exec eqsDocumentDelete @DocID 
select * from eqsDocument where ID = @DocID
update eqsDocument set DocState = 0  where ID = @DocID
exec eqsDocumentDelete @DocID 
select * from eqsDocument where ID = @DocID
exec eqsDocumentRestore @DocID 
select * from eqsDocument where ID = @DocID

*/

/*===========================================*/
-- dbo.eqsDocArticleIn
if OBJECT_ID(N'eqsDocArticleInCreate') is not null drop procedure eqsDocArticleInCreate;
go

create procedure eqsDocArticleInCreate @StoreID int, @ArticleID int,  @DocID int output
as
begin
	declare @errmsg varchar(max);
	begin try
		begin tran;
			if not exists(select * from eqsStorePoint where ID = @StoreID) raiserror('Відсутнє місце зберігання.', 16, 1);
			if not  exists(select * from eqsArticle where ID = @ArticleID) raiserror('Відсутня стаття.', 16, 1);
			exec eqsDocumentCreate 6, @DocID output;						-- 6	Прибуток зі статті
			insert into dbo.eqsDocArticleIn(DocID, StoreID, ArticleID)
									values(@DocID, @StoreID, @ArticleID);
			
		commit;	
		select @DocID;
		return;
	end try
	begin catch
		if (@@TRANCOUNT > 1) commit 
						   else rollback;
		select @errmsg = 'Помилка створення документа: ' + ERROR_MESSAGE();
		raiserror(@errmsg, 16,1);
	end catch;
end
go

GRANT EXEC ON eqsDocArticleInCreate TO [SKLAD30], [IFLAB\S.Golubkov];
go
/*test
declare @DocID int;
exec eqsDocArticleInCreate 1, 1 , @DocID output;
select @DocID; 

select * 
from eqsDocument d 
	inner join eqsDocArticleIn i on i.DocID = d.ID
	inner join dbo.eqsDocType t on d.DocTypeID = t.ID 
where d.ID = @DocID;

select @@trancount;
*/
go

--dbo.eqsDocIncoming
if OBJECT_ID(N'eqsDocIncomingCreate') is not null drop procedure eqsDocIncomingCreate;
go

create procedure eqsDocIncomingCreate  @StoreID int, @ContractorID int, @DocID int output
as
begin
	declare @errmsg varchar(max);
	begin try
		begin tran;
			if not exists(select * from eqsStorePoint where ID = @StoreID) raiserror('Відсутнє місце зберігання.', 16, 1);
			if not  exists(select * from eqsContractor where ID = @ContractorID) raiserror('Відсутній контрагент.', 16, 1);
			exec eqsDocumentCreate 1, @DocID output;						-- 1	Прибуткова накладна
			insert into dbo.eqsDocIncoming(DocID, StoreID, ContractorID)
									values(@DocID, @StoreID, @ContractorID);
			
		commit;	
		select @DocID;
		return;
	end try
	begin catch
		if (@@TRANCOUNT > 1) commit 
						   else rollback;
		select @errmsg = 'Помилка створення документа: ' + ERROR_MESSAGE();
		raiserror(@errmsg, 16,1);
	end catch;
end

go

GRANT EXEC ON eqsDocIncomingCreate TO [SKLAD30], [IFLAB\S.Golubkov];
go

/*test  select * from eqsContractor; 
declare @DocID int;
exec eqsDocIncomingCreate 1, 1 , @DocID output;

select @DocID; 

select * 
from eqsDocument d 
	inner join dbo.eqsDocType t on d.DocTypeID = t.ID 
where d.ID = @DocID;

select @@trancount;
*/

--dbo.eqsDocInitial
if OBJECT_ID(N'eqsDocInitialCreate') is not null drop procedure eqsDocInitialCreate;
go

create procedure eqsDocInitialCreate @StoreID int, @DocID int output
as
begin
	declare @errmsg varchar(max);
	begin try
		begin tran;

			if not exists(select * from eqsStorePoint where ID = @StoreID) raiserror('Відсутнє місце зберігання.', 16, 1);
			
			exec eqsDocumentCreate 4, @DocID output;						-- 4	Початкові залишки
			insert into dbo.eqsDocInitial(DocID, StoreID)
									values(@DocID, @StoreID);
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
go

GRANT EXEC ON eqsDocInitialCreate TO [SKLAD30], [IFLAB\S.Golubkov];
go

/*test 
declare @DocID int;
exec eqsDocInitialCreate 1, @DocID output;

select @DocID; 

select * 
from eqsDocument d 
	inner join dbo.eqsDocType t on d.DocTypeID = t.ID 
	inner join eqsDocInitial i on i.DocID = d.ID
where d.ID = @DocID;

select @@trancount;
*/


--dbo.eqsDocMove
if OBJECT_ID(N'eqsDocMoveCreate') is not null drop procedure eqsDocMoveCreate;
go

create procedure eqsDocMoveCreate @SourceStoreID int, @TargetStoreID int, @DocID int output
as
begin
	declare @errmsg varchar(max);
	begin try
		begin tran;

			if not exists(select * from eqsStorePoint where ID = @SourceStoreID) raiserror('Відсутнє вихідне місце зберігання.', 16, 1);
			if not exists(select * from eqsStorePoint where ID = @TargetStoreID) raiserror('Відсутнє кінцеве зберігання.', 16, 1);
			if @SourceStoreID = @TargetStoreID raiserror('Місця зберігання не повинні співпадати.', 16, 1);
			
			exec eqsDocumentCreate 3, @DocID output;						-- 3	Накладна на внутрішнє переміщення
			insert into dbo.eqsDocMove(DocID, SourceStoreID, TargetStoreID)
									values(@DocID, @SourceStoreID, @TargetStoreID);
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
go

GRANT EXEC ON eqsDocMoveCreate TO [SKLAD30], [IFLAB\S.Golubkov];
go

/*test 
declare @DocID int;
exec eqsDocMoveCreate 1, 2, @DocID output;

select @DocID; 

select * 
from eqsDocument d 
	inner join dbo.eqsDocType t on d.DocTypeID = t.ID 
	inner join eqsDocMove i on i.DocID = d.ID
where d.ID = @DocID;

select @@trancount;
*/

--dbo.eqsDocOutgoing
if OBJECT_ID(N'eqsDocOutgoingCreate') is not null drop procedure eqsDocOutgoingCreate;
go

create procedure eqsDocOutgoingCreate @StoreID int, @ContractorID int, @DocID int output
as
begin
	declare @errmsg varchar(max);
	begin try
		begin tran;
			if not exists(select * from eqsStorePoint where ID = @StoreID) raiserror('Відсутнє місце зберігання.', 16, 1);
			if not  exists(select * from eqsContractor where ID = @ContractorID) raiserror('Відсутній контрагент.', 16, 1);
			exec eqsDocumentCreate 2, @DocID output;						-- 2	Прибуткова накладна
			insert into dbo.eqsDocOutgoing(DocID, StoreID, ContractorID)
									values(@DocID, @StoreID, @ContractorID);
			
		commit;	
		select @DocID;
		return;
	end try
	begin catch
		if (@@TRANCOUNT > 1) commit 
						   else rollback;
		select @errmsg = 'Помилка створення документа: ' + ERROR_MESSAGE();
		raiserror(@errmsg, 16,1);
	end catch;
end
go

GRANT EXEC ON eqsDocOutgoingCreate TO [SKLAD30], [IFLAB\S.Golubkov];
go

/*test 
declare @DocID int;
exec eqsDocOutgoingCreate 1, 1, @DocID output;

select @DocID; 

select * 
from eqsDocument d 
	inner join dbo.eqsDocType t on d.DocTypeID = t.ID 
	inner join eqsDocOutgoing i on i.DocID = d.ID
where d.ID = @DocID;

select @@trancount;
*/

--dbo.eqsDocRegrading
if OBJECT_ID(N'eqsDocRegradingCreate') is not null drop procedure eqsDocRegradingCreate;
go

create procedure eqsDocRegradingCreate @StoreID int, @ArticleID int, @DocID int output
as
begin
	declare @errmsg varchar(max);
	begin try
		begin tran;
			if not exists(select * from eqsStorePoint where ID = @StoreID) raiserror('Відсутнє місце зберігання.', 16, 1);
			if not  exists(select * from eqsArticle where ID = @ArticleID) raiserror('Відсутня стаття.', 16, 1);
			exec eqsDocumentCreate 7, @DocID output;						-- 7	Пересортиця
			insert into dbo.eqsDocRegrading(DocID, StoreID, ArticleID)
									values(@DocID, @StoreID, @ArticleID);
			
		commit;	
		select @DocID;
		return;
	end try
	begin catch
		if (@@TRANCOUNT > 1) commit 
						   else rollback;
		select @errmsg = 'Помилка створення документа: ' + ERROR_MESSAGE();
		raiserror(@errmsg, 16,1);
	end catch;
end
go

GRANT EXEC ON eqsDocRegradingCreate TO [SKLAD30], [IFLAB\S.Golubkov];
go

/*test 
declare @DocID int;
exec eqsDocRegradingCreate 1, 1, @DocID output;

select @DocID; 

select * 
from eqsDocument d 
	inner join dbo.eqsDocType t on d.DocTypeID = t.ID 
	inner join eqsDocRegrading i on i.DocID = d.ID
where d.ID = @DocID;

select @@trancount;
*/


--dbo.eqsDocWriteOff
if OBJECT_ID(N'eqsDocWriteOffCreate') is not null drop procedure eqsDocWriteOffCreate;
go

create procedure eqsDocWriteOffCreate @StoreID int, @ArticleID int, @DocID int output
as
begin
	declare @errmsg varchar(max);
	begin try
		begin tran;
			if not exists(select * from eqsStorePoint where ID = @StoreID) raiserror('Відсутнє місце зберігання.', 16, 1);
			if not  exists(select * from eqsArticle where ID = @ArticleID) raiserror('Відсутня стаття.', 16, 1);
			exec eqsDocumentCreate 5, @DocID output;						-- 5	Списання
			insert into eqsDocWriteOff(DocID, StoreID, ArticleID)
									values(@DocID, @StoreID, @ArticleID);
			
		commit;	
		select @DocID;
		return;
	end try
	begin catch
		if (@@TRANCOUNT > 1) commit 
						   else rollback;
		select @errmsg = 'Помилка створення документа: ' + ERROR_MESSAGE();
		raiserror(@errmsg, 16,1);
	end catch;
end
go

GRANT EXEC ON eqsDocWriteOffCreate TO [SKLAD30], [IFLAB\S.Golubkov];
go

/*test 
declare @DocID int;
exec eqsDocWriteOffCreate 1, 1, @DocID output;

select @DocID; 

select * 
from eqsDocument d 
	inner join dbo.eqsDocType t on d.DocTypeID = t.ID 
	inner join eqsDocWriteOff i on i.DocID = d.ID
where d.ID = @DocID;

select @@trancount;
*/
go


if OBJECT_ID(N'eqsDocListGet') is not null drop procedure eqsDocListGet;
go

create procedure eqsDocListGet	@BegDate date = null
							   ,@EndDate date = null
							   ,@StoreID int = null
							   ,@StatusMsk int = null 
							   ,@WithDeleted int = 0 
as
begin
	declare @errmsg varchar(max); 
	begin try
		begin tran
			select	cast(ROW_NUMBER()over(order by d.DocDate, d.ID) as int) as ROW_ID
					, d.ID as DocID	
					, d.DocTypeID
					, dt.Name as DocTypeName
					, d.DocDate
					, d.DocCode
					, d.Comments
					, d.IsDeleted
					, d.DocState&1 as FIN
			from eqsDocument d
				inner join eqsDocType dt on dt.ID = d.DocTypeID
				left join eqsDocIncoming di on di.DocID = d.ID
				left join eqsDocOutgoing do on do.DocID = d.ID
				left join eqsDocArticleIn da on da.DocID = d.ID
				left join eqsDocWriteOff dw on dw.DocID = d.ID
				left join eqsDocRegrading dr on dr.DocID = d.ID
				left join eqsDocInitial dn on dn.DocID = d.ID
				left join eqsDocMove dm on dm.DocID = d.ID
			where   (@BegDate IS null or d.DocDate >= @BegDate) 
				and (@EndDate is null or d.DocDate <= @EndDate )
				and (@StatusMsk is null or @StatusMsk = d.DocState or @StatusMsk&d.DocState != 0)
				and (d.IsDeleted = 0 or @WithDeleted = 1)
				and (@StoreID is null 
					or @StoreID  = coalesce(di.StoreID,do.StoreID,da.StoreID,dw.StoreID,dr.StoreID,dn.StoreID) 
					or @StoreID = dm.SourceStoreID
					or @StoreID = dm.TargetStoreID)
			order by d.DocDate, d.ID;
		commit;		
		return;
	end try
	begin catch
		if (@@TRANCOUNT > 1) commit 
						   else if (@@TRANCOUNT != 0)  rollback;
		select @errmsg = 'Помилка переліку документів: ' + ERROR_MESSAGE();
		raiserror(@errmsg, 16,1);
	end catch;
end
go

GRANT EXEC ON eqsDocListGet TO [SKLAD30], [IFLAB\S.Golubkov];
go


-- test
/*
exec eqsDocListGet;
exec eqsDocListGet '20181206', '20181206', 1, 0, 0;

exec eqsDocumentFinYes 2;
exec eqsDocListGet '20181206', '20181206', 1, 1, 0;
exec eqsDocumentFinNo 2;


exec eqsDocumentDelete 7;
exec eqsDocListGet '20181206', '20181206', 1, 0, 0;
exec eqsDocumentRestore 7;

*/

if OBJECT_ID(N'eqsDocumentGet') is not null drop procedure eqsDocumentGet;
go

create procedure eqsDocumentGet @DocID int 
as
begin
	declare @errmsg varchar(max), @DocType int; 
	if not exists(select * from eqsDocument where ID = @DocID)
		begin
		select @errmsg = 'Не існує документа з ID ' + cast(@DocID as varchar(32))
		raiserror(@errmsg, 16,1);
		return;
		end;
	begin try
		begin tran
		select @DocType = DocTypeID from eqsDocument where ID = @DocID;
		if @DocType in (1,2)
			select	d.ID	
					, d.DocTypeID
					, d.DocDate
					, d.DocCode
					, d.Comments
					, d.IsDeleted
					, d.DocState&1 as FIN
					, coalesce(di.StoreID,do.StoreID) as StoreID
					, coalesce(di.ContractorID, do.ContractorID) as ContractorID
			from eqsDocument d
				left join eqsDocIncoming di on di.DocID = d.ID
				left join eqsDocOutgoing do on do.DocID = d.ID
			where d.ID = @DocID;
			else if @DocType in (5,6,7)
					select	d.ID	
							, d.DocTypeID
							, d.DocDate
							, d.DocCode
							, d.Comments
							, d.IsDeleted
							, d.DocState&1 as FIN
							, coalesce(di.StoreID,do.StoreID,dr.StoreID) as StoreID
							, coalesce(di.ArticleID, do.ArticleID, dr.ArticleID) as ArticleID
					from eqsDocument d
						left join eqsDocArticleIn di on di.DocID = d.ID
						left join eqsDocWriteOff do on do.DocID = d.ID
						left join eqsDocRegrading dr on dr.DocID = d.ID
					where d.ID = @DocID;
					else if @DocType in (3)
						select	d.ID	
								, d.DocTypeID
								, d.DocDate
								, d.DocCode
								, d.Comments
								, d.IsDeleted
								, d.DocState&1 as FIN
								, dm.SourceStoreID
								, dm.TargetStoreID
						from eqsDocument d
							inner join eqsDocMove dm on dm.DocID = d.ID
						where d.ID = @DocID;
						else if @DocType in (4)
							select	d.ID	
									, d.DocTypeID
									, d.DocDate
									, d.DocCode
									, d.Comments
									, d.IsDeleted
									, d.DocState&1 as FIN
									, di.StoreID
							from eqsDocument d
								inner join eqsDocInitial di on di.DocID = d.ID
							where d.ID = @DocID;
							else 
							begin
								select @errmsg = 'Неврахований тип документа: ' + CAST(@DocType as varchar(16));
								raiserror(@errmsg, 16,1);							
							end;
					
		commit;		
		return;
	end try
	begin catch
		if (@@TRANCOUNT > 1) commit 
						   else if (@@TRANCOUNT != 0)  rollback;
		select @errmsg = 'Помилка пошуку документа: ' + ERROR_MESSAGE();
		raiserror(@errmsg, 16,1);
	end catch;
end
go

GRANT EXEC ON eqsDocumentGet TO [SKLAD30], [IFLAB\S.Golubkov];
go

/*
-- test
exec eqsDocumentGet 1;
exec eqsDocumentGet 2;
exec eqsDocumentGet 3;
exec eqsDocumentGet 4;
exec eqsDocumentGet 5;
exec eqsDocumentGet 6;
exec eqsDocumentGet 7;
exec eqsDocumentGet 8;
exec eqsDocumentGet 9;
exec eqsDocumentGet 26;

execute as login = 'SKLAD30'
select system_user
exec eqsDocumentGet 2;
revert

update eqsDetail set UnitFactor = 1 where DocID = 7

select * from eqsUnitFactor

*/

if OBJECT_ID(N'eqsDocDetailGet') is not null drop procedure eqsDocDetailGet;
go

create procedure eqsDocDetailGet @DocID int 
as
begin
	declare @errmsg varchar(max); 
	begin try
		begin tran
			select	  d.DocID
					, d.ItemID
					, d.Quantity
					, d.UnitFactor
			from eqsDetail d
			where d.DocID = @DocID;
		commit;		
		return;
	end try
	begin catch
		if (@@TRANCOUNT > 1) commit 
						   else if (@@TRANCOUNT != 0)  rollback;
		select @errmsg = 'Помилка пошуку рядків документа ' + CAST(@DocID as varchar(32)) + ': ' + ERROR_MESSAGE();
		raiserror(@errmsg, 16,1);
	end catch;
end
go

GRANT EXEC ON eqsDocDetailGet TO [SKLAD30], [IFLAB\S.Golubkov];
go


/*
-- test
exec eqsDocDetailGet 1;
exec eqsDocDetailGet 2;
exec eqsDocDetailGet 3;
exec eqsDocDetailGet 4;
exec eqsDocDetailGet 5;
exec eqsDocDetailGet 6;
exec eqsDocDetailGet 7;
exec eqsDocDetailGet 8;
exec eqsDocDetailGet 9;

*/

if OBJECT_ID(N'eqsDocumentCompact') is not null drop procedure eqsDocumentCompact;
go

create procedure eqsDocumentCompact @DocID int 
as
begin
	declare @errmsg varchar(max); 
	begin try
		begin tran
			delete
			from eqsDetail
			where DocID = @DocID and Quantity = 0;
		commit;		
		return;
	end try
	begin catch
		if (@@TRANCOUNT > 1) commit 
						   else if (@@TRANCOUNT != 0)  rollback;
		select @errmsg = 'Помилка стиснення документа ' + CAST(@DocID as varchar(32)) + ': ' + ERROR_MESSAGE();
		raiserror(@errmsg, 16,1);
	end catch;
end
go

GRANT EXEC ON eqsDocumentCompact TO [SKLAD30], [IFLAB\S.Golubkov];
go


/*
-- test
exec eqsDocDetailGet 1;

*/



/******** загальна схема процедур ********/
/*

if OBJECT_ID(N'<...>') is not null drop procedure <...>;
go

create procedure <...> @DocTypeID int, @DocID int output
as
begin
	declare @errmsg varchar(max);
	begin try
		begin tran;
			insert into dbo.eqsDocument(DocTypeID, DocDate)
								values (@DocTypeID, GETDATE());
			select @DocID = SCOPE_IDENTITY();
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


--DBCC CHECKIDENT ('имя_таблицы', RESEED, новое_стартовое_значение)
*/