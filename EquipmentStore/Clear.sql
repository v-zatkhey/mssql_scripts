use SKLAD30;

/*очистка документов*/
/*
truncate table eqsRegRemainsR;
truncate table eqsRegRemainsP;

truncate table eqsDetail;

truncate table eqsDocOutgoing;
truncate table eqsDocMove;
truncate table eqsDocIncoming;
truncate table eqsDocInitial;
truncate table eqsDocArticleIn;
truncate table eqsDocWriteOff;
truncate table eqsDocRegrading;

alter table  eqsDocument  disable trigger  tr_eqsDocument_del;
delete from eqsDocument;
alter table  eqsDocument  enable trigger  tr_eqsDocument_del;

DBCC CHECKIDENT ('eqsDocument', RESEED, 0)

*/

--select 'drop procedure ' + name + ';' from sys.objects where name like '%eqs%' and type = 'P'
--select * from sys.objects where name like '%eqs%' 
-- видалення процедур
begin 
	drop procedure eqsDocIncomingFinYes;
	drop procedure eqsDocOutgoingFinYes;
	drop procedure eqsDocMoveFinYes;
	drop procedure eqsDocInitialFinYes;
	drop procedure eqsDocWriteOffFinYes;
	drop procedure eqsDocArticleInFinYes;
	drop procedure eqsDocRegradingFinYes;
	drop procedure eqsDocumentFinYes;
	drop procedure eqsDocumentFinNo;
	drop procedure eqsDocumentCreate;
	drop procedure eqsDocumentDelete;
	drop procedure eqsDocumentRestore;
	drop procedure eqsDocArticleInCreate;
	drop procedure eqsDocIncomingCreate;
	drop procedure eqsDocInitialCreate;
	drop procedure eqsDocMoveCreate;
	drop procedure eqsDocOutgoingCreate;
	drop procedure eqsDocRegradingCreate;
	drop procedure eqsDocWriteOffCreate;
	drop procedure eqsDocListGet;
	drop procedure eqsDocumentGet;
	drop procedure eqsDocDetailGet;
	drop procedure eqsDocumentCompact;
	drop procedure eqsRestMoveRegister;
	drop procedure eqsRestMoveItemRegister;
end
--видалення таблиць
begin
	drop table eqsRegRemainsR;
	drop table eqsRegRemainsP;

	drop table eqsDocOutgoing;
	drop table eqsDocMove;
	drop table eqsDocIncoming;
	drop table eqsDocInitial;
	drop table eqsDocArticleIn;
	drop table eqsDocWriteOff;
	drop table eqsDocRegrading;

	drop table eqsDetail;
	drop table eqsDocument;
	drop table eqsDocType;

	drop table eqsArticle;
	drop table eqsContractor;

	drop table eqsFinRespPerson;
	drop table eqsStorePoint;
	drop table eqsStorePointType;

	delete from eqsUnitFactor;
	drop table eqsUnitFactor;

	drop table eqsItem;
	drop table eqsUnit;
	drop table eqsGroup;
	drop table eqsSubCategory;
	drop table eqsCategory;
	drop table eqsStatus;
	--drop table eqs_OldCategoryLink
end

--очистка лишних групп и категорий
/*
select *
from eqsGroup  g 
where not exists(select * from eqsItem where GroupID = g.ID  )

select *
-- delete from eqsSubCategory
from eqsSubCategory g 
where not exists(select * from eqsGroup where SubCategoryID  = g.ID  )
	and CategoryID >2

select *
-- delete from eqsCategory
from eqsCategory g 
where not exists(select * from eqsSubCategory where CategoryID  = g.ID  )
*/


