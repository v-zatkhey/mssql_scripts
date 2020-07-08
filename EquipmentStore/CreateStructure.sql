use SKLAD30;

USE [SKLAD30]
GO

/****** Object:  Table [dbo].[TableNames]    Script Date: 11/22/2018 10:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******************* Category - Item **************************/
if OBJECT_ID(N'eqsCategory') is null
begin
	create table eqsCategory(
			ID int not null constraint PK_eqsCategory primary key,
			Name varchar(128) not null
			);

end;
go

if OBJECT_ID(N'eqsSubCategory') is null
begin
	create table eqsSubCategory(
			ID int IDENTITY(1,1)  constraint PK_eqsSubCategory primary key,
			CategoryID int not null foreign key references eqsCategory(ID),
			Name varchar(128) not null
			);

end;
go


if OBJECT_ID(N'eqsGroup') is null
begin
	create table eqsGroup(
		ID int IDENTITY(1,1) constraint PK_eqsGroup primary key,
		SubCategoryID int not null foreign key references eqsSubCategory(ID),
		Name varchar(128) not null
	); 
end;
go


if OBJECT_ID(N'eqsUnit') is null
begin
	create table eqsUnit(
		ID int IDENTITY(1,1) constraint PK_eqsUnit primary key,
		Name varchar(128) not null,
		ShortName varchar(32) not null
	); 
end;
go

if OBJECT_ID(N'eqsItem') is null
begin
	create table eqsItem(
			ID int IDENTITY(1,1) constraint PK_eqsItem primary key,
			GroupID int not null foreign key references eqsGroup(ID),
			Name varchar(222) not null,
			NameExt varchar(32) null,
			FullName as Name + case when NameExt is null then '' else ' ' + NameExt end,
			ExternalCode varchar(128) null,
			IsDeleted tinyint not null constraint DF_eqsItem_IsDeleted default 0,
			MainUnitQuantity int not null constraint DF_eqsItem_MainUnitQuantity default 1,
			SortNumber int not null   constraint DF_eqsItem_SortNumber default 999999,
			SerialNumber varchar(128) null,										-- серийник поштучного оборудования
			Comments varchar(255) null,
			OldCodeID int null
			);

end;
go

-- alter table eqsItem add OldCodeID int null;

-- 

-- на кожний Item має бути принаймі один UnitFactor - 1
if OBJECT_ID(N'eqsUnitFactor') is null
begin
	create table eqsUnitFactor(
		ID int IDENTITY(1,1) constraint PK_eqsUnitFactor primary key,
		UnitID int not null foreign key references eqsUnit(ID),
		ItemID int not null foreign key references eqsItem(ID),
		UnitFactor int not null
	); 
end;
go



/************* Store *****************************/
if OBJECT_ID(N'eqsStorePointType') is null
begin
	create table eqsStorePointType(
			ID int not null constraint PK_eqsStorePointType primary key,
			Name varchar(128) not null
			);

end;
go

if OBJECT_ID(N'eqsStorePoint') is null
begin
	create table eqsStorePoint(
		ID int IDENTITY(1,1) constraint PK_eqsStorePoint primary key,
		StorePointTypeID int not null foreign key references eqsStorePointType(ID),
		Name varchar(128) not null,
		IsDeleted tinyint not null constraint DF_eqsStorePoint_IsDeleted default 0
	); 
end;
go

if OBJECT_ID(N'eqsFinRespPerson') is null
begin
	create table eqsFinRespPerson(
		ID int constraint PK_eqsFinRespPerson primary key foreign key references eqsStorePoint(ID),
		InitialsName varchar(50) not null
	); 
end;
go

/************ Subject ****************************/
if OBJECT_ID(N'eqsContractor') is null
begin
	create table eqsContractor(
			ID int IDENTITY(1,1) constraint PK_eqsContractor primary key,
			Name varchar(128) not null,
			FullName varchar(255) not null,
			EDRPOU varchar(12) null,
			Comments varchar(255) null,
			IsDeleted tinyint not null constraint DF_eqsContractor_IsDeleted default 0
			);

end;
go
/*
alter table eqsContractor add FullName varchar(255) null, Comments varchar(255) null;
alter table eqsContractor add OldCodeID int null;
*/

if OBJECT_ID(N'eqsArticle') is null
begin
	create table eqsArticle(
		ID int IDENTITY(1,1) constraint PK_eqsArticle primary key,
		Name varchar(128) not null,
		IsDeleted tinyint not null constraint DF_eqsArticle_IsDeleted default 0
	); 
end;
go

/******************** Document *******************/
if OBJECT_ID(N'eqsDocType') is null
begin

	CREATE TABLE eqsDocType(
		ID int				NOT NULL constraint PK_eqsDocType primary key,
		Name varchar(255)		NOT NULL,
		IsOuterDoc tinyint		not null,
		TableName varchar(64)	null
				
	 CONSTRAINT [IX_eqsDocType_Name] UNIQUE NONCLUSTERED 
				(
					Name ASC
				) 
	) ON [PRIMARY]
	
end;
GO

if OBJECT_ID(N'eqsDocument') is null
begin

	CREATE TABLE eqsDocument(
		ID int IDENTITY(1,1)	NOT NULL constraint PK_eqsDocument primary key,
		DocTypeID int NOT NULL  FOREIGN KEY REFERENCES eqsDocType(ID),
		DocCode varchar(32)		null,
		DocDate datetime,
		CreateDate datetime,
		CreateUser varchar(64),
		ChangeDate datetime,
		ChangeUser varchar(64),
		Comments varchar(255) null,
		IsDeleted tinyint not null constraint DF_eqsDocument_IsDeleted default 0,
		DocState	int  CONSTRAINT	DF_eqsDocument_DocState   DEFAULT 0
		
	 				
	 CONSTRAINT IX_eqsDocument_Date_ID UNIQUE NONCLUSTERED 
				(
					DocDate ASC, ID asc
				) 
				
	) ON [PRIMARY];

end;	

if OBJECT_ID(N'eqsDetail') is null
begin

	CREATE TABLE eqsDetail(
		ID int IDENTITY(1,1) NOT NULL constraint PK_eqsDetail primary key, 
		DocID int  NOT NULL FOREIGN KEY REFERENCES eqsDocument(ID),
		ItemID int NOT NULL  FOREIGN KEY REFERENCES eqsItem(ID),
		Quantity int not null constraint DF_eqsDetail_Quantity default 0,		-- неподільних одиниць
		UnitFactor int not null constraint DF_eqsDetail_UnitFactor default 1,	-- кількість наподільних одиниць у одиниці
		UnitQuantity  as cast(Quantity as float)/UnitFactor							-- звичних одиниць
	) ON [PRIMARY];

end;	

if OBJECT_ID(N'eqsDocInitial') is null
begin

	CREATE TABLE eqsDocInitial(
		DocID int NOT NULL constraint PK_eqseqsDocInitial primary key  FOREIGN KEY REFERENCES eqsDocument(ID),
		StoreID int NOT NULL  FOREIGN KEY REFERENCES eqsStorePoint(ID)
	) ON [PRIMARY];

end;

if OBJECT_ID(N'eqsDocIncoming') is null
begin

	CREATE TABLE eqsDocIncoming(
		DocID int NOT NULL constraint PK_eqsDocIncoming primary key  FOREIGN KEY REFERENCES eqsDocument(ID),
		StoreID int NOT NULL  FOREIGN KEY REFERENCES eqsStorePoint(ID),
		ContractorID int null FOREIGN KEY REFERENCES eqsContractor(ID)
	) ON [PRIMARY];

end;	

if OBJECT_ID(N'eqsDocMove') is null
begin

	CREATE TABLE eqsDocMove(
		DocID int NOT NULL constraint PK_eqsDocMove primary key  FOREIGN KEY REFERENCES eqsDocument(ID),
		SourceStoreID int NOT NULL  FOREIGN KEY REFERENCES eqsStorePoint(ID),
		TargetStoreID int NOT NULL  FOREIGN KEY REFERENCES eqsStorePoint(ID)
	) ON [PRIMARY];

end;	

if OBJECT_ID(N'eqsDocOutgoing') is null
begin

	CREATE TABLE eqsDocOutgoing(
		DocID int NOT NULL constraint PK_eqsDocOutgoing primary key  FOREIGN KEY REFERENCES eqsDocument(ID),
		StoreID int NOT NULL  FOREIGN KEY REFERENCES eqsStorePoint(ID),
		ContractorID int null FOREIGN KEY REFERENCES eqsContractor(ID)
	) ON [PRIMARY];

end;	

if OBJECT_ID(N'eqsDocArticleIn') is null
begin

	CREATE TABLE eqsDocArticleIn(
		DocID int NOT NULL constraint PK_eqsDocArticleIn primary key  FOREIGN KEY REFERENCES eqsDocument(ID),
		StoreID int NOT NULL  FOREIGN KEY REFERENCES eqsStorePoint(ID),
		ArticleID int null FOREIGN KEY REFERENCES eqsArticle(ID)
	) ON [PRIMARY];

end;

if OBJECT_ID(N'eqsDocWriteOff') is null
begin

	CREATE TABLE eqsDocWriteOff(
		DocID int NOT NULL constraint PK_eqsDocWriteOff primary key  FOREIGN KEY REFERENCES eqsDocument(ID),
		StoreID int NOT NULL  FOREIGN KEY REFERENCES eqsStorePoint(ID),
		ArticleID int null FOREIGN KEY REFERENCES eqsArticle(ID)
	) ON [PRIMARY];

end;

if OBJECT_ID(N'eqsDocRegrading') is null
begin

	CREATE TABLE eqsDocRegrading(
		DocID int NOT NULL constraint PK_eqsDocRegrading primary key  FOREIGN KEY REFERENCES eqsDocument(ID),
		StoreID int NOT NULL  FOREIGN KEY REFERENCES eqsStorePoint(ID),
		ArticleID int null FOREIGN KEY REFERENCES eqsArticle(ID)
	) ON [PRIMARY];

end;	

/*************** регистр остатков *************/

if OBJECT_ID(N'eqsRegRemainsP') is null
begin

	CREATE TABLE eqsRegRemainsP(
		ID int IDENTITY(1,1) NOT NULL constraint PK_eqsRegRemainsP primary key,
		StoreID int NOT NULL  FOREIGN KEY REFERENCES eqsStorePoint(ID),
		DocID int NOT NULL FOREIGN KEY REFERENCES eqsDocument(ID),
		DocDate datetime,
		ItemID int NOT NULL  FOREIGN KEY REFERENCES eqsItem(ID),
		Quantity int null 
	) ON [PRIMARY];

end;	

if OBJECT_ID(N'eqsRegRemainsR') is null
begin

	CREATE TABLE eqsRegRemainsR(
		ID int IDENTITY(1,1) NOT NULL constraint PK_eqsRegRemainsR primary key,
		StoreID int NOT NULL  FOREIGN KEY REFERENCES eqsStorePoint(ID),
		ItemID int NOT NULL  FOREIGN KEY REFERENCES eqsItem(ID),
		Quantity int null 
	) ON [PRIMARY];

end;		

/*************** статус *********************/
if OBJECT_ID(N'eqsStatus') is null
begin

	CREATE TABLE eqsStatus(
		ID int NOT NULL constraint PK_eqseqsStatus primary key,
		Name varchar(32) NOT NULL,		
		Short  varchar(8) NOT NULL,  
		Code  varchar(8) NOT NULL  
	) ON [PRIMARY];

end;	