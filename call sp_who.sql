exec sp_who active
--kill 148

DBCC SHOWCONTIG('TableLogs')  WITH  ALL_INDEXES ;



DBCC INPUTBUFFER ( 118 ) WITH NO_INFOMSGS; 

SELECT request_id, * 
FROM sys.dm_exec_requests 
WHERE session_id = 118


--SELECT "����"  FROM "dbo"."View_����_�������_������" WHERE ("���_�������" = 'M' ) ORDER BY "dbo"."View_����_�������_������"."�����_�����"  DESC 