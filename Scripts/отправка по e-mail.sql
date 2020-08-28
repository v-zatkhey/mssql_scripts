--  Volodymyr.Zatkhey@lifechemicals.com
-- mail.iflab.local 

-- сообщения
SELECT * FROM msdb.dbo.sysmail_allitems 
   WHERE mailitem_id = 93;

-- журнал событий
SELECT * FROM msdb.dbo.sysmail_event_log 
   WHERE mailitem_id = 93 ;
 
exec msdb.dbo.sysmail_help_status_sp;
EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'sql_mail_profile',  
    @recipients = 'Volodymyr.Zatkhey@lifechemicals.com',  
    @body = 'The stored procedure finished successfully.',  
    @subject = 'Automated Success Message' ;  
    
EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'sql_mail_profile',  
    @recipients = 'Volodymyr.Zatkhey@lifechemicals.com',  
    @query = 'SELECT * FROM Chest35.dbo.Типы_решений_по_спектрам' ,  
    @subject = 'Типы_решений_по_спектрам',  
    @attach_query_result_as_file = 1,
    @query_attachment_filename = 'SpectraDecisionType.csv', -- Указывает имя файла, подлежащее использованию в результирующем наборе вложения запроса. Аргумент query_attachment_filename имеет тип nvarchar(255) и по умолчанию принимает значение NULL. Параметр не учитывается, если аргумент attach_query_result имеет значение 0. Если аргумент attach_query_result принимает значение 1, а значение данного параметра равно NULL, то компонент Database Mail создает произвольное имя файла..
	@query_result_header = 1,								-- Указывает, включают ли результаты запроса заголовки столбцов. Аргумент query_result_header имеет тип bit. Если значение равно 1, результаты запроса содержат заголовки столбцов. Если установлено значение 0, то результаты запроса не содержат заголовков столбцов. Данный аргумент имеет значение по умолчанию 1. Данный аргумент применим только в том случае, если задан аргумент @query.
	@query_result_width = 1000, -- Длинна строки для использования при форматировании результатов запроса (в символах). Аргумент query_result_width имеет тип int и значение по умолчанию 256. Его значение должно находиться в диапазоне от 10 до 32767. Данный параметр применим только в том случае, если задан аргумент @query.
	--@query_result_separator = '	',
	@exclude_query_output = 1 ;     
go
    
execute as login='IFLAB\Scheduler'  
select system_user  

exec sendMessage @recipients = 'Volodymyr.Zatkhey@lifechemicals.com' -- 'analytics_department@lifechemicals.com'
				, @subject = 'test'
				,  @message = 'Просьба проанализировать: '

revert    
go

exec sp_helptext sp_send_dbmail;
go

-- відправка результату запиту у вкладеному файлі
EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'sql_mail_profile',  
    @recipients = 'Volodymyr.Zatkhey@lifechemicals.com',  
    @query = 'SELECT * FROM Chest35.dbo.Типы_решений_по_спектрам' ,  
    @subject = 'Типы_решений_по_спектрам',  
    @attach_query_result_as_file = 1,
    @query_attachment_filename = 'SpectraDecisionType.csv', -- Указывает имя файла, подлежащее использованию в результирующем наборе вложения запроса. Аргумент query_attachment_filename имеет тип nvarchar(255) и по умолчанию принимает значение NULL. Параметр не учитывается, если аргумент attach_query_result имеет значение 0. Если аргумент attach_query_result принимает значение 1, а значение данного параметра равно NULL, то компонент Database Mail создает произвольное имя файла..
	@query_result_header = 1,								-- Указывает, включают ли результаты запроса заголовки столбцов. Аргумент query_result_header имеет тип bit. Если значение равно 1, результаты запроса содержат заголовки столбцов. Если установлено значение 0, то результаты запроса не содержат заголовков столбцов. Данный аргумент имеет значение по умолчанию 1. Данный аргумент применим только в том случае, если задан аргумент @query.
	@query_result_width = 1000, -- Длинна строки для использования при форматировании результатов запроса (в символах). Аргумент query_result_width имеет тип int и значение по умолчанию 256. Его значение должно находиться в диапазоне от 10 до 32767. Данный параметр применим только в том случае, если задан аргумент @query.
	--@query_result_separator = '	',
	@exclude_query_output = 1 ;     
go


execute as login='IFLAB\v.zatkhey' -- под sa так не работает
select system_user  
EXEC msdb.dbo.sp_send_dbmail		--- этот вызов срабатывает, если зайти в MS SQL server Management Studio под личным аккаунтом 
    @profile_name = 'sql_mail_profile',  
    @recipients = 'Volodymyr.Zatkhey@lifechemicals.com',  
    @subject = 'Файл в приложении',  
    @file_attachments = 'd:\Work\Price_1_5.txt',
	@exclude_query_output = 1 ;     
go
revert

SELECT * FROM msdb.dbo.sysmail_allitems  WHERE mailitem_id > 536;

-- настройка параметров 
exec msdb..sysmail_help_configure_sp;
exec msdb..sysmail_configure_sp   @parameter_name = 'MaxFileSize', @parameter_value = '12000000'  -- максимальный размер приложенного файла, по умолчанию - 1000000

SELECT send_request_user , [subject] , MAX(send_request_date) as LastDate 
FROM msdb.dbo.sysmail_allitems 
where send_request_date > '20200101'
group by send_request_user , [subject] 
order by [subject], MAX(send_request_date)
