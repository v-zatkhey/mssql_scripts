/*****процедури отримання даних для звітів ***/
use SKLAD30 ;
go

/***** оборотна відомість ****/

--eqsRestMoveRegister

--select * from dbo.eqsRegRemainsR
--select * from dbo.eqsRegRemainsP

if OBJECT_ID(N'eqsRestMoveRegister') is not null drop procedure eqsRestMoveRegister;
go

create procedure eqsRestMoveRegister @StorePointID int, @BegDate date, @EndDate date 
as
begin
	declare @errmsg varchar(max);
	begin try
		begin tran;
		
		declare @BegRest table(ItemID int, Quantity int);
		declare @EndRest table(ItemID int, Quantity int);

		-- початкові залишки
		insert into @BegRest(ItemID,Quantity)
		select x.ItemID , SUM(x.Quantity)
		from
		(select r.ItemID, r.Quantity
		from eqsRegRemainsR r 
		where r.StoreID = @StorePointID
		union all
		select p.ItemID, -p.Quantity
		from eqsRegRemainsP  p 
		where p.StoreID = @StorePointID
			and p.DocDate >= @BegDate
		) x
		group by x.ItemID ;

		-- кінцеві залишки
		insert into @EndRest(ItemID,Quantity)
		select x.ItemID , SUM(x.Quantity)
		from
		(select r.ItemID, r.Quantity
		from eqsRegRemainsR r 
		where r.StoreID = @StorePointID
		union all
		select p.ItemID, -p.Quantity
		from eqsRegRemainsP  p 
		where p.StoreID = @StorePointID
			and p.DocDate > @EndDate
		) x
		group by x.ItemID ;

	select x.ItemID
		, i.FullName
		, SUM(x.BegRest ) as BegRest
		, SUM(x.DebMove  ) as DebMove
		, SUM(x.CreMove  ) as CreMove
		, SUM(x.EndRest ) as EndRest
		
	from (
		select ItemID
			   , Quantity as BegRest
			   , 0 as DebMove
			   , 0 as CreMove
			   , 0 as EndRest 
		from @BegRest
		union all
		select ItemID
			, 0 as BegRest
			, sum(case when p.Quantity>0 then p.Quantity else 0 end) as DebMove
			, sum(case when p.Quantity<0 then -p.Quantity else 0 end) as CreMove
			, 0 as EndRest 
		from eqsRegRemainsP p 
		where p.StoreID = @StorePointID
			and p.DocDate between @BegDate and @EndDate
		group by p.ItemID 	
		union all
		select ItemID
			   , 0 as EndRest
			   , 0 as DebMove
			   , 0 as CreMove
			   , Quantity as EndRest 
		from @EndRest
		) x
		inner join eqsItem i on i.ID = x.ItemID 
		group by x.ItemID, i.FullName, i.SortNumber
		order by i.SortNumber , i.FullName  ;
		 
		
		commit;	
		return;
	end try
	begin catch
		if (@@TRANCOUNT > 1) commit 
						   else if (@@TRANCOUNT > 0)  rollback;
		select @errmsg = 'Помилка формування оборотної відомості:  StorePointID = ' 
						+ CAST(@StorePointID as varchar(32)) 
						+ '; період з  ' + CAST(@BegDate as varchar(32)) 
						+ ' по ' + CAST(@EndDate as varchar(32)) 
		raiserror(@errmsg, 16,1);
	end catch;
end
go

GRANT EXEC ON eqsRestMoveRegister TO [SKLAD30], [IFLAB\S.Golubkov];
go

--exec eqsRestMoveRegister 1, '20190115', '20190115'

if OBJECT_ID(N'eqsRestMoveItemRegister') is not null drop procedure eqsRestMoveItemRegister;
go

create procedure eqsRestMoveItemRegister @StorePointID int, @ItemID int, @BegDate date, @EndDate date 
as
begin
	declare @errmsg varchar(max);
	begin try
		begin tran;
		
		declare @BegRest int;
		declare @EndRest int;

		-- початковий залишок
		select  @BegRest = isnull(SUM(x.Quantity),0)
		from
		(select r.StoreID, r.Quantity
		from eqsRegRemainsR r 
		where r.StoreID = @StorePointID
			and r.ItemID = @ItemID
		union all
		select p.StoreID, -p.Quantity
		from eqsRegRemainsP  p 
		where p.StoreID = @StorePointID
			and p.ItemID = @ItemID
			and p.DocDate >= @BegDate
		) x;

		-- кінцевий залишок
		select @EndRest = isnull(SUM(x.Quantity),0)
		from
		(select r.StoreID, r.Quantity
		from eqsRegRemainsR r 
		where r.StoreID = @StorePointID
			and r.ItemID = @ItemID
		union all
		select p.StoreID, -p.Quantity
		from eqsRegRemainsP  p 
		where p.StoreID = @StorePointID
			and p.ItemID = @ItemID
			and p.DocDate > @EndDate
		) x;

	declare @Move table(DocID int,DocType varchar(255),DocDate datetime, DocComments varchar(255), DebMove int,CreMove int);
	insert into @Move
	select p.DocID , t.Name as DocType, p.DocDate, d.Comments
			, case when p.Quantity >0 then p.Quantity else 0 end as DebMove
			, case when p.Quantity <0 then -p.Quantity else 0 end as CreMove 
	from eqsRegRemainsP p
		inner join eqsDocument d on d.ID = p.DocID 
		inner join eqsDocType t on t.ID = d.DocTypeID 
	where p.ItemID = @ItemID
			and p.StoreID = @StorePointID
			and p.DocDate between @BegDate and @EndDate;
	
	select 0 as DocID, 'Початковий залишок' as DocType, @BegDate as [Date], null as Comments, @BegRest as BeforeRest, 0 as DebMove, 0 as CreMove, 0 as AfterRest
	union all
	select m.DocID 
			, m.DocType 
			, m.DocDate 
			, m.DocComments 
			, @BegRest + isnull(SUM(m2.DebMove - m2.CreMove),0) as BeforeRest
			, m.DebMove 
			, m.CreMove 
			, @BegRest + isnull(SUM(m2.DebMove - m2.CreMove),0) + m.DebMove - m.CreMove  as AfterRest
	from @Move m
		left join @Move m2 on m.DocDate > m2.DocDate 
				  or m.DocDate = m2.DocDate and m.DocID > m2.DocID 
	group by m.DocID, m.DocType, m.DocDate, m.DocComments, m.DebMove, m.CreMove 			  
	union all
	select 0, 'Кінцевий залишок', @BegDate, null, 0 as BeforeRest, 0 as DebMove, 0 as CreMove, @EndRest as AfterRest;
	
	
		 
		
		commit;	
		return;
	end try
	begin catch
		if (@@TRANCOUNT > 1) commit 
						   else if (@@TRANCOUNT > 0)  rollback;
		select @errmsg = 'Помилка формування відомості njdfhe:  ItemID = ' 
						+ CAST(@ItemID  as varchar(32)) 
						+ '; період з  ' + CAST(@BegDate as varchar(32)) 
						+ ' по ' + CAST(@EndDate as varchar(32)) 
		raiserror(@errmsg, 16,1);
	end catch;
end
go

GRANT EXEC ON eqsRestMoveItemRegister TO [SKLAD30], [IFLAB\S.Golubkov];
go

exec eqsRestMoveItemRegister 1, 330, '20190115', '20190115'
