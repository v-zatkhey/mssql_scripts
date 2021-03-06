/*
   5 марта 2019 г.9:38:25
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
ALTER TABLE dbo.tblПробирки_для_масел WITH NOCHECK ADD CONSTRAINT
	CK_tblПробирки_для_масел_ID_format CHECK (ID like 'F[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
GO
DECLARE @v sql_variant 
SET @v = N'формат F-номера'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'tblПробирки_для_масел', N'CONSTRAINT', N'CK_tblПробирки_для_масел_ID_format'
GO
ALTER TABLE dbo.tblПробирки_для_масел SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
