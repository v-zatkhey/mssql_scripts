/*
   11 сентября 2019 г.15:36:10
   Пользователь: sa
   Сервер: SERVER
   База данных: SKLAD30
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
ALTER TABLE dbo.__Требования ADD
	AnalysisMask bigint NOT NULL CONSTRAINT DF___Требования_AnalysisMask DEFAULT 0
GO
ALTER TABLE dbo.__Требования SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
