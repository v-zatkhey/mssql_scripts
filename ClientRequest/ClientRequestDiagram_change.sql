/*
   29 июля 2020 г.17:07:54
   Пользователь: 
   Сервер: server
   База данных: Chest35
   Приложение: 
*/

/* Чтобы предотвратить возможность потери данных, необходимо внимательно просмотреть этот сценарий, прежде чем запускать его вне контекста конструктора баз данных.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Documents
	DROP CONSTRAINT FK_Documents_new21_Contacts_ContactID_ContactID
GO
ALTER TABLE dbo.Contacts SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.MaterialInfo
	DROP CONSTRAINT FK_MaterialInfo_new21_Materials__MatID_MatID
GO
ALTER TABLE dbo.Materials SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Customers
	DROP CONSTRAINT FK_Customers_new21_Items__CategoryID_ItemID
GO
ALTER TABLE dbo.Customers
	DROP CONSTRAINT FK_Customers_new21_Items__CustTypeID_ItemID
GO
ALTER TABLE dbo.Documents
	DROP CONSTRAINT FK_Documents_new21_Items__DocTypeID_ItemID
GO
ALTER TABLE dbo.Items SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Customers
	DROP CONSTRAINT [DF_dbo.Customers_new21_Enabled]
GO
ALTER TABLE dbo.Customers
	DROP CONSTRAINT [DF_dbo.Customers_new21_Order]
GO
CREATE TABLE dbo.Tmp_Customers
	(
	CustID nvarchar(5) NOT NULL,
	CustName varchar(50) NOT NULL,
	LongCustName varchar(255) NULL,
	CustTypeID int NOT NULL,
	CategoryID int NULL,
	Login_Website varchar(50) NULL,
	Parole_Website varchar(50) NULL,
	Enabled bit NOT NULL,
	Sorting int NOT NULL,
	Note varchar(255) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Customers SET (LOCK_ESCALATION = TABLE)
GO
GRANT DELETE ON dbo.Tmp_Customers TO Chest_Admins  AS dbo
GO
GRANT DELETE ON dbo.Tmp_Customers TO Chest_Postavki  AS dbo
GO
GRANT DELETE ON dbo.Tmp_Customers TO Chest_Rukovodstvo  AS dbo
GO
GRANT DELETE ON dbo.Tmp_Customers TO Chest_Zakazi  AS dbo
GO
GRANT DELETE ON dbo.Tmp_Customers TO Chest_Postavki_really  AS dbo
GO
GRANT INSERT ON dbo.Tmp_Customers TO Chest_Admins  AS dbo
GO
GRANT INSERT ON dbo.Tmp_Customers TO Chest_Postavki  AS dbo
GO
GRANT INSERT ON dbo.Tmp_Customers TO Chest_Rukovodstvo  AS dbo
GO
GRANT INSERT ON dbo.Tmp_Customers TO Chest_Zakazi  AS dbo
GO
GRANT INSERT ON dbo.Tmp_Customers TO Chest_Postavki_really  AS dbo
GO
GRANT REFERENCES ON dbo.Tmp_Customers TO Chest_Wesovschiki  AS dbo
GO
GRANT REFERENCES ON dbo.Tmp_Customers TO Chest_Admins  AS dbo
GO
GRANT REFERENCES ON dbo.Tmp_Customers TO Chest_Otpravki  AS dbo
GO
GRANT REFERENCES ON dbo.Tmp_Customers TO Chest_Postavki  AS dbo
GO
GRANT REFERENCES ON dbo.Tmp_Customers TO Chest_public  AS dbo
GO
GRANT REFERENCES ON dbo.Tmp_Customers TO Chest_Rukovodstvo  AS dbo
GO
GRANT REFERENCES ON dbo.Tmp_Customers TO Chest_Zakazi  AS dbo
GO
GRANT REFERENCES ON dbo.Tmp_Customers TO Chest_Wes_Chief  AS dbo
GO
GRANT REFERENCES ON dbo.Tmp_Customers TO Chest_Postavki_really  AS dbo
GO
GRANT SELECT ON dbo.Tmp_Customers TO Chest_Wesovschiki  AS dbo
GO
GRANT SELECT ON dbo.Tmp_Customers TO Chest_Admins  AS dbo
GO
GRANT SELECT ON dbo.Tmp_Customers TO Chest_Otpravki  AS dbo
GO
GRANT SELECT ON dbo.Tmp_Customers TO Chest_Postavki  AS dbo
GO
GRANT SELECT ON dbo.Tmp_Customers TO Chest_public  AS dbo
GO
GRANT SELECT ON dbo.Tmp_Customers TO Chest_Rukovodstvo  AS dbo
GO
GRANT SELECT ON dbo.Tmp_Customers TO Chest_Zakazi  AS dbo
GO
GRANT SELECT ON dbo.Tmp_Customers TO Chest_Wes_Chief  AS dbo
GO
GRANT SELECT ON dbo.Tmp_Customers TO Sklad30Chest  AS dbo
GO
GRANT SELECT ON dbo.Tmp_Customers TO Chest_Postavki_really  AS dbo
GO
GRANT UPDATE ON dbo.Tmp_Customers TO Chest_Admins  AS dbo
GO
GRANT UPDATE ON dbo.Tmp_Customers TO Chest_Postavki  AS dbo
GO
GRANT UPDATE ON dbo.Tmp_Customers TO Chest_Rukovodstvo  AS dbo
GO
GRANT UPDATE ON dbo.Tmp_Customers TO Chest_Zakazi  AS dbo
GO
GRANT UPDATE ON dbo.Tmp_Customers TO Chest_Postavki_really  AS dbo
GO
DECLARE @v sql_variant 
SET @v = N'Поставщик или заказчик (см. Items)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_Customers', N'COLUMN', N'CustTypeID'
GO
DECLARE @v sql_variant 
SET @v = N'Лаборатория (см. Items)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_Customers', N'COLUMN', N'CategoryID'
GO
ALTER TABLE dbo.Tmp_Customers ADD CONSTRAINT
	[DF_dbo.Customers_new21_Enabled] DEFAULT ((1)) FOR Enabled
GO
ALTER TABLE dbo.Tmp_Customers ADD CONSTRAINT
	[DF_dbo.Customers_new21_Order] DEFAULT ((555)) FOR Sorting
GO
IF EXISTS(SELECT * FROM dbo.Customers)
	 EXEC('INSERT INTO dbo.Tmp_Customers (CustID, CustName, LongCustName, CustTypeID, CategoryID, Login_Website, Parole_Website, Enabled, Sorting, Note)
		SELECT CONVERT(nvarchar(5), CustID), CustName, LongCustName, CustTypeID, CategoryID, Login_Website, Parole_Website, Enabled, Sorting, Note FROM dbo.Customers WITH (HOLDLOCK TABLOCKX)')
GO
ALTER TABLE dbo.tblClientRequests
	DROP CONSTRAINT FK_tblClientRequests_Customers
GO
ALTER TABLE dbo.MaterialInfo
	DROP CONSTRAINT FK_MaterialInfo_new21_Customers__CustID_CustID
GO
ALTER TABLE dbo.Documents
	DROP CONSTRAINT Documents_fk
GO
DROP TABLE dbo.Customers
GO
EXECUTE sp_rename N'dbo.Tmp_Customers', N'Customers', 'OBJECT' 
GO
ALTER TABLE dbo.Customers ADD CONSTRAINT
	PK_Customers_new21 PRIMARY KEY CLUSTERED 
	(
	CustID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_Customers_new21_CategoryID ON dbo.Customers
	(
	CategoryID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.Customers ADD CONSTRAINT
	IX_Customers_new21_constraint_CustName_CustTypeID UNIQUE NONCLUSTERED 
	(
	CustName,
	CustTypeID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_Customers_new21_CustID_CustName ON dbo.Customers
	(
	CustID,
	CustName
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_Customers_new21_CustName ON dbo.Customers
	(
	CustName
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_Customers_new21_CustName_CustTypeID ON dbo.Customers
	(
	CustName,
	CustTypeID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_Customers_new21_CustTypeID ON dbo.Customers
	(
	CustTypeID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_Customers_new21_Login_Website ON dbo.Customers
	(
	Login_Website
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_Customers_new21_Login_Website_Parole_Website ON dbo.Customers
	(
	Login_Website,
	Parole_Website
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_Customers_new21_Order_CustName ON dbo.Customers
	(
	Sorting,
	CustName
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.Customers ADD CONSTRAINT
	FK_Customers_new21_Items__CategoryID_ItemID FOREIGN KEY
	(
	CategoryID
	) REFERENCES dbo.Items
	(
	ItemID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Customers ADD CONSTRAINT
	FK_Customers_new21_Items__CustTypeID_ItemID FOREIGN KEY
	(
	CustTypeID
	) REFERENCES dbo.Items
	(
	ItemID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Documents
	(
	DocID int NOT NULL IDENTITY (1, 1),
	DocName varchar(50) NOT NULL,
	DocNumber int NULL,
	CustID nvarchar(5) NULL,
	ContactID int NULL,
	DocTypeID int NOT NULL,
	DocName_mod  AS (case when [DocTypeID]=(43347) OR [DocTypeID]=(44018) then CONVERT([varchar],(upper(left([DocName],(2)))+replicate('0',(5)-len(CONVERT([varchar],[DocNumber],(0)))))+CONVERT([varchar],[DocNumber],(0)),(0))  end),
	DateInsert smalldatetime NOT NULL,
	DateUpdate smalldatetime NOT NULL,
	DateCompleted smalldatetime NULL,
	Note varchar(255) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Documents SET (LOCK_ESCALATION = TABLE)
GO
GRANT DELETE ON dbo.Tmp_Documents TO Chest_Admins  AS dbo
GO
GRANT DELETE ON dbo.Tmp_Documents TO Chest_Postavki  AS dbo
GO
GRANT DELETE ON dbo.Tmp_Documents TO Chest_Zakazi  AS dbo
GO
GRANT DELETE ON dbo.Tmp_Documents TO Chest_Postavki_really  AS dbo
GO
GRANT INSERT ON dbo.Tmp_Documents TO Chest_Admins  AS dbo
GO
GRANT INSERT ON dbo.Tmp_Documents TO Chest_Postavki  AS dbo
GO
GRANT INSERT ON dbo.Tmp_Documents TO Chest_Zakazi  AS dbo
GO
GRANT INSERT ON dbo.Tmp_Documents TO Chest_Postavki_really  AS dbo
GO
GRANT REFERENCES ON dbo.Tmp_Documents TO Chest_Wesovschiki  AS dbo
GO
GRANT REFERENCES ON dbo.Tmp_Documents TO Chest_Admins  AS dbo
GO
GRANT REFERENCES ON dbo.Tmp_Documents TO Chest_Otpravki  AS dbo
GO
GRANT REFERENCES ON dbo.Tmp_Documents TO Chest_Postavki  AS dbo
GO
GRANT REFERENCES ON dbo.Tmp_Documents TO Chest_public  AS dbo
GO
GRANT REFERENCES ON dbo.Tmp_Documents TO Chest_Rukovodstvo  AS dbo
GO
GRANT REFERENCES ON dbo.Tmp_Documents TO Chest_Zakazi  AS dbo
GO
GRANT REFERENCES ON dbo.Tmp_Documents TO Chest_Wes_Chief  AS dbo
GO
GRANT REFERENCES ON dbo.Tmp_Documents TO Chest_Postavki_really  AS dbo
GO
GRANT SELECT ON dbo.Tmp_Documents TO Chest_Wesovschiki  AS dbo
GO
GRANT SELECT ON dbo.Tmp_Documents TO Chest_Admins  AS dbo
GO
GRANT SELECT ON dbo.Tmp_Documents TO Chest_Otpravki  AS dbo
GO
GRANT SELECT ON dbo.Tmp_Documents TO Chest_Postavki  AS dbo
GO
GRANT SELECT ON dbo.Tmp_Documents TO Chest_public  AS dbo
GO
GRANT SELECT ON dbo.Tmp_Documents TO Chest_Rukovodstvo  AS dbo
GO
GRANT SELECT ON dbo.Tmp_Documents TO Chest_Zakazi  AS dbo
GO
GRANT SELECT ON dbo.Tmp_Documents TO Chest_Wes_Chief  AS dbo
GO
GRANT SELECT ON dbo.Tmp_Documents TO Sklad30Chest  AS dbo
GO
GRANT SELECT ON dbo.Tmp_Documents TO Chest_Postavki_really  AS dbo
GO
GRANT UPDATE ON dbo.Tmp_Documents TO Chest_Admins  AS dbo
GO
GRANT UPDATE ON dbo.Tmp_Documents TO Chest_Postavki  AS dbo
GO
GRANT UPDATE ON dbo.Tmp_Documents TO Chest_Zakazi  AS dbo
GO
GRANT UPDATE ON dbo.Tmp_Documents TO Chest_Postavki_really  AS dbo
GO
EXECUTE sp_bindefault N'dbo.SmallDate_Now', N'dbo.Tmp_Documents.DateInsert'
GO
EXECUTE sp_bindefault N'dbo.SmallDate_Now', N'dbo.Tmp_Documents.DateUpdate'
GO
SET IDENTITY_INSERT dbo.Tmp_Documents ON
GO
IF EXISTS(SELECT * FROM dbo.Documents)
	 EXEC('INSERT INTO dbo.Tmp_Documents (DocID, DocName, DocNumber, CustID, ContactID, DocTypeID, DateInsert, DateUpdate, DateCompleted, Note)
		SELECT DocID, DocName, DocNumber, CONVERT(nvarchar(5), CustID), ContactID, DocTypeID, DateInsert, DateUpdate, DateCompleted, Note FROM dbo.Documents WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Documents OFF
GO
ALTER TABLE dbo.MaterialInfo
	DROP CONSTRAINT FK_MaterialInfo_new21_Documents__DocID_DocID
GO
DROP TABLE dbo.Documents
GO
EXECUTE sp_rename N'dbo.Tmp_Documents', N'Documents', 'OBJECT' 
GO
ALTER TABLE dbo.Documents ADD CONSTRAINT
	PK_Documents_new21 PRIMARY KEY CLUSTERED 
	(
	DocID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Documents ADD CONSTRAINT
	IX_Documents_new21_constraint_DocName_DocTypeID UNIQUE NONCLUSTERED 
	(
	DocName,
	DocTypeID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_Documents_new21_ContactID ON dbo.Documents
	(
	ContactID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_Documents_new21_CustID ON dbo.Documents
	(
	CustID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_Documents_new21_DocTypeID ON dbo.Documents
	(
	DocTypeID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.Documents ADD CONSTRAINT
	FK_Documents_new21_Items__DocTypeID_ItemID FOREIGN KEY
	(
	DocTypeID
	) REFERENCES dbo.Items
	(
	ItemID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Documents ADD CONSTRAINT
	FK_Documents_new21_Contacts_ContactID_ContactID FOREIGN KEY
	(
	ContactID
	) REFERENCES dbo.Contacts
	(
	ContactID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Documents ADD CONSTRAINT
	Documents_fk FOREIGN KEY
	(
	CustID
	) REFERENCES dbo.Customers
	(
	CustID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_MaterialInfo
	(
	MInfoID int NOT NULL IDENTITY (1, 1),
	MatID int NOT NULL,
	CustID nvarchar(5) NULL,
	CustMatName varchar(255) NULL,
	CustStockWeight int NULL,
	DocID int NULL,
	DateInsert smalldatetime NOT NULL,
	DateUpdate smalldatetime NOT NULL,
	DateFailure smalldatetime NULL,
	Note varchar(255) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_MaterialInfo SET (LOCK_ESCALATION = TABLE)
GO
GRANT DELETE ON dbo.Tmp_MaterialInfo TO Chest_Admins  AS dbo
GO
GRANT INSERT ON dbo.Tmp_MaterialInfo TO Chest_Admins  AS dbo
GO
GRANT INSERT ON dbo.Tmp_MaterialInfo TO Chest_Postavki  AS dbo
GO
GRANT INSERT ON dbo.Tmp_MaterialInfo TO Chest_Postavki_really  AS dbo
GO
GRANT REFERENCES ON dbo.Tmp_MaterialInfo TO Chest_Wesovschiki  AS dbo
GO
GRANT REFERENCES ON dbo.Tmp_MaterialInfo TO Chest_Admins  AS dbo
GO
GRANT REFERENCES ON dbo.Tmp_MaterialInfo TO Chest_Otpravki  AS dbo
GO
GRANT REFERENCES ON dbo.Tmp_MaterialInfo TO Chest_Postavki  AS dbo
GO
GRANT REFERENCES ON dbo.Tmp_MaterialInfo TO Chest_public  AS dbo
GO
GRANT REFERENCES ON dbo.Tmp_MaterialInfo TO Chest_Rukovodstvo  AS dbo
GO
GRANT REFERENCES ON dbo.Tmp_MaterialInfo TO Chest_Zakazi  AS dbo
GO
GRANT REFERENCES ON dbo.Tmp_MaterialInfo TO Chest_Wes_Chief  AS dbo
GO
GRANT REFERENCES ON dbo.Tmp_MaterialInfo TO Chest_Postavki_really  AS dbo
GO
GRANT SELECT ON dbo.Tmp_MaterialInfo TO Chest_Wesovschiki  AS dbo
GO
GRANT SELECT ON dbo.Tmp_MaterialInfo TO Chest_Admins  AS dbo
GO
GRANT SELECT ON dbo.Tmp_MaterialInfo TO Chest_Otpravki  AS dbo
GO
GRANT SELECT ON dbo.Tmp_MaterialInfo TO Chest_Postavki  AS dbo
GO
GRANT SELECT ON dbo.Tmp_MaterialInfo TO Chest_public  AS dbo
GO
GRANT SELECT ON dbo.Tmp_MaterialInfo TO Chest_Rukovodstvo  AS dbo
GO
GRANT SELECT ON dbo.Tmp_MaterialInfo TO Chest_Zakazi  AS dbo
GO
GRANT SELECT ON dbo.Tmp_MaterialInfo TO Chest_Wes_Chief  AS dbo
GO
GRANT SELECT ON dbo.Tmp_MaterialInfo TO Sklad30Chest  AS dbo
GO
GRANT SELECT ON dbo.Tmp_MaterialInfo TO Chest_Postavki_really  AS dbo
GO
GRANT UPDATE ON dbo.Tmp_MaterialInfo TO Chest_Admins  AS dbo
GO
GRANT UPDATE ON dbo.Tmp_MaterialInfo TO Chest_Postavki  AS dbo
GO
GRANT UPDATE ON dbo.Tmp_MaterialInfo TO Chest_Postavki_really  AS dbo
GO
EXECUTE sp_bindefault N'dbo.SmallDate_Now', N'dbo.Tmp_MaterialInfo.DateInsert'
GO
EXECUTE sp_bindefault N'dbo.SmallDate_Now', N'dbo.Tmp_MaterialInfo.DateUpdate'
GO
SET IDENTITY_INSERT dbo.Tmp_MaterialInfo ON
GO
IF EXISTS(SELECT * FROM dbo.MaterialInfo)
	 EXEC('INSERT INTO dbo.Tmp_MaterialInfo (MInfoID, MatID, CustID, CustMatName, CustStockWeight, DocID, DateInsert, DateUpdate, DateFailure, Note)
		SELECT MInfoID, MatID, CONVERT(nvarchar(5), CustID), CustMatName, CustStockWeight, DocID, DateInsert, DateUpdate, DateFailure, Note FROM dbo.MaterialInfo WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_MaterialInfo OFF
GO
DROP TABLE dbo.MaterialInfo
GO
EXECUTE sp_rename N'dbo.Tmp_MaterialInfo', N'MaterialInfo', 'OBJECT' 
GO
ALTER TABLE dbo.MaterialInfo ADD CONSTRAINT
	PK_MaterialInfo_new21 PRIMARY KEY CLUSTERED 
	(
	MInfoID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_MaterialInfo_new21_CustID ON dbo.MaterialInfo
	(
	CustID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_MaterialInfo_new21_CustMatName ON dbo.MaterialInfo
	(
	CustMatName
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_MaterialInfo_new21_CustStockWeight ON dbo.MaterialInfo
	(
	CustStockWeight
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_MaterialInfo_new21_DateFailure ON dbo.MaterialInfo
	(
	DateFailure
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_MaterialInfo_new21_DateInsert ON dbo.MaterialInfo
	(
	DateInsert
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_MaterialInfo_new21_DateUpdate ON dbo.MaterialInfo
	(
	DateUpdate
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_MaterialInfo_new21_DocID ON dbo.MaterialInfo
	(
	DocID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_MaterialInfo_new21_MatID ON dbo.MaterialInfo
	(
	MatID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_MaterialInfo_new21_MatID_CustID_DateFailure ON dbo.MaterialInfo
	(
	MatID,
	CustID,
	DateFailure
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_MaterialInfo_new21_MatID_CustID_DocID ON dbo.MaterialInfo
	(
	MatID,
	CustID,
	DocID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.MaterialInfo ADD CONSTRAINT
	FK_MaterialInfo_new21_Materials__MatID_MatID FOREIGN KEY
	(
	MatID
	) REFERENCES dbo.Materials
	(
	MatID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.MaterialInfo ADD CONSTRAINT
	FK_MaterialInfo_new21_Documents__DocID_DocID FOREIGN KEY
	(
	DocID
	) REFERENCES dbo.Documents
	(
	DocID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.MaterialInfo ADD CONSTRAINT
	FK_MaterialInfo_new21_Customers__CustID_CustID FOREIGN KEY
	(
	CustID
	) REFERENCES dbo.Customers
	(
	CustID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblClientRequests
	DROP CONSTRAINT FK_tblClientRequests_tblПользователи_add
GO
ALTER TABLE dbo.tblClientRequests
	DROP CONSTRAINT FK_tblClientRequests_tblПользователи_answer
GO
ALTER TABLE dbo.tblПользователи SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblЗаказчики_full SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblClientRequests
	DROP CONSTRAINT FK_tblClientRequests_tblЗапросы
GO
ALTER TABLE dbo.tblЗапросы SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblClientRequests
	DROP CONSTRAINT FK_tblClientRequests_tblЗаказы
GO
ALTER TABLE dbo.tblЗаказы SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblClientRequests
	DROP CONSTRAINT DF_tblClientRequests_HasAnswer
GO
CREATE TABLE dbo.Tmp_tblClientRequests
	(
	ID int NOT NULL IDENTITY (1, 1),
	ClientCode nvarchar(5) NULL,
	ClientName varchar(255) NULL,
	Number int NULL,
	AddDate datetime NULL,
	MsgText text NULL,
	AddEmployee int NULL,
	AnswerDate datetime NULL,
	AnswerText text NULL,
	AnswerEmployee int NULL,
	HasAnswer bit NOT NULL,
	QueryID int NULL,
	OrderID int NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tblClientRequests SET (LOCK_ESCALATION = TABLE)
GO
ALTER TABLE dbo.Tmp_tblClientRequests ADD CONSTRAINT
	DF_tblClientRequests_HasAnswer DEFAULT ((0)) FOR HasAnswer
GO
SET IDENTITY_INSERT dbo.Tmp_tblClientRequests ON
GO
IF EXISTS(SELECT * FROM dbo.tblClientRequests)
	 EXEC('INSERT INTO dbo.Tmp_tblClientRequests (ID, ClientCode, ClientName, Number, AddDate, MsgText, AddEmployee, AnswerDate, AnswerText, AnswerEmployee, HasAnswer, QueryID, OrderID)
		SELECT ID, CONVERT(nvarchar(5), ClientID), ClientName, Number, AddDate, MsgText, AddEmployee, AnswerDate, AnswerText, AnswerEmployee, HasAnswer, QueryID, OrderID FROM dbo.tblClientRequests WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tblClientRequests OFF
GO
ALTER TABLE dbo.tblClientRequestDetails
	DROP CONSTRAINT FK_tblClientRequestDetails_tblClientRequests1
GO
DROP TABLE dbo.tblClientRequests
GO
EXECUTE sp_rename N'dbo.Tmp_tblClientRequests', N'tblClientRequests', 'OBJECT' 
GO
ALTER TABLE dbo.tblClientRequests ADD CONSTRAINT
	PK_tblClientRequests PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tblClientRequests ADD CONSTRAINT
	FK_tblClientRequests_tblПользователи_add FOREIGN KEY
	(
	AddEmployee
	) REFERENCES dbo.tblПользователи
	(
	Код
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
DECLARE @v sql_variant 
SET @v = N'added by'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'tblClientRequests', N'CONSTRAINT', N'FK_tblClientRequests_tblПользователи_add'
GO
ALTER TABLE dbo.tblClientRequests ADD CONSTRAINT
	FK_tblClientRequests_tblПользователи_answer FOREIGN KEY
	(
	AnswerEmployee
	) REFERENCES dbo.tblПользователи
	(
	Код
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
DECLARE @v sql_variant 
SET @v = N'answer by'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'tblClientRequests', N'CONSTRAINT', N'FK_tblClientRequests_tblПользователи_answer'
GO
ALTER TABLE dbo.tblClientRequests ADD CONSTRAINT
	FK_tblClientRequests_tblЗапросы FOREIGN KEY
	(
	QueryID
	) REFERENCES dbo.tblЗапросы
	(
	Код
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblClientRequests ADD CONSTRAINT
	FK_tblClientRequests_tblЗаказы FOREIGN KEY
	(
	OrderID
	) REFERENCES dbo.tblЗаказы
	(
	Код
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblClientRequests ADD CONSTRAINT
	FK_tblClientRequests_Customers FOREIGN KEY
	(
	ClientCode
	) REFERENCES dbo.Customers
	(
	CustID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblClientRequests ADD CONSTRAINT
	FK_tblClientRequests_tblЗаказчики_full FOREIGN KEY
	(
	ClientCode
	) REFERENCES dbo.tblЗаказчики_full
	(
	КодЗаказчика
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
-- =============================================
-- Author:		V.Zatkhey
-- Create date: 27.07.2020
-- Description:	фр=ормування номеру запиту.
-- =============================================
CREATE TRIGGER dbo.TR_tblClientRequests_INS 
--ALTER TRIGGER dbo.TR_tblClientRequests_INS 
   ON  dbo.tblClientRequests
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	declare @LastRqNumByClient table(ClientName varchar(127), RqNum int);
	declare @NewRqNum table(ID int, RqNum int);

	insert into @LastRqNumByClient
	select ClientName, MAX(Number)
	from dbo.tblClientRequests
	where ClientName in (select ClientName from inserted group by ClientName)
	group by ClientName;
	
	insert into @NewRqNum(ID, RqNum)
	select i.ID, NewNumber = isnull(l.RqNum,0) + ROW_NUMBER() over(partition by i.ClientName order by i.ID)
	from inserted i 
		left join @LastRqNumByClient l on l.ClientName = i.ClientName;
		
	update x
	set Number = t.RqNum
	from tblClientRequests x
		inner join @NewRqNum t on t.ID = x.ID; 
			
	    
END
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblClientRequestDetails ADD CONSTRAINT
	FK_tblClientRequestDetails_tblClientRequests1 FOREIGN KEY
	(
	RequestID
	) REFERENCES dbo.tblClientRequests
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblClientRequestDetails SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
