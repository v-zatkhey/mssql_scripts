/*
   15 января 2020 г.11:09:15
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
ALTER TABLE dbo.tblПоставщики_full SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblScaffold SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblScaffoldChemist ADD CONSTRAINT
	FK_tblScaffoldChemist_tblScaffold FOREIGN KEY
	(
	ScaffoldID
	) REFERENCES dbo.tblScaffold
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblScaffoldChemist ADD CONSTRAINT
	FK_tblScaffoldChemist_tblПоставщики_full FOREIGN KEY
	(
	ChemistID
	) REFERENCES dbo.tblПоставщики_full
	(
	Код
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblScaffoldChemist SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
