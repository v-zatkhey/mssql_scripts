/*
   15 января 2020 г.10:51:04
   Пользователь: sa
   Сервер: SERVER
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
CREATE TABLE dbo.tblScaffoldChemist
	(
	ID int NOT NULL IDENTITY (1, 1),
	ScaffoldID int NOT NULL,
	ChemistID int NOT NULL,
	MsgWasSended bit NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.tblScaffoldChemist ADD CONSTRAINT
	DF_tblScaffoldChemist_MsgWasSended DEFAULT 0 FOR MsgWasSended
GO
ALTER TABLE dbo.tblScaffoldChemist SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblScaffoldChemist', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblScaffoldChemist', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblScaffoldChemist', 'Object', 'CONTROL') as Contr_Per 