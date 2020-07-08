exec sp_who active
--kill 148

DBCC SHOWCONTIG('TableLogs')  WITH  ALL_INDEXES ;



DBCC INPUTBUFFER ( 118 ) WITH NO_INFOMSGS; 

SELECT request_id, * 
FROM sys.dm_exec_requests 
WHERE session_id = 118


--SELECT "Блок"  FROM "dbo"."View_Блок_Спектра_список" WHERE ("Тип_спектра" = 'M' ) ORDER BY "dbo"."View_Блок_Спектра_список"."Номер_блока"  DESC 