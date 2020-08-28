--  Volodymyr.Zatkhey@lifechemicals.com
-- mail.iflab.local 

-- ���������
SELECT * FROM msdb.dbo.sysmail_allitems 
   WHERE mailitem_id = 93;

-- ������ �������
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
    @query = 'SELECT * FROM Chest35.dbo.����_�������_��_��������' ,  
    @subject = '����_�������_��_��������',  
    @attach_query_result_as_file = 1,
    @query_attachment_filename = 'SpectraDecisionType.csv', -- ��������� ��� �����, ���������� ������������� � �������������� ������ �������� �������. �������� query_attachment_filename ����� ��� nvarchar(255) � �� ��������� ��������� �������� NULL. �������� �� �����������, ���� �������� attach_query_result ����� �������� 0. ���� �������� attach_query_result ��������� �������� 1, � �������� ������� ��������� ����� NULL, �� ��������� Database Mail ������� ������������ ��� �����..
	@query_result_header = 1,								-- ���������, �������� �� ���������� ������� ��������� ��������. �������� query_result_header ����� ��� bit. ���� �������� ����� 1, ���������� ������� �������� ��������� ��������. ���� ����������� �������� 0, �� ���������� ������� �� �������� ���������� ��������. ������ �������� ����� �������� �� ��������� 1. ������ �������� �������� ������ � ��� ������, ���� ����� �������� @query.
	@query_result_width = 1000, -- ������ ������ ��� ������������� ��� �������������� ����������� ������� (� ��������). �������� query_result_width ����� ��� int � �������� �� ��������� 256. ��� �������� ������ ���������� � ��������� �� 10 �� 32767. ������ �������� �������� ������ � ��� ������, ���� ����� �������� @query.
	--@query_result_separator = '	',
	@exclude_query_output = 1 ;     
go
    
execute as login='IFLAB\Scheduler'  
select system_user  

exec sendMessage @recipients = 'Volodymyr.Zatkhey@lifechemicals.com' -- 'analytics_department@lifechemicals.com'
				, @subject = 'test'
				,  @message = '������� ����������������: '

revert    
go

exec sp_helptext sp_send_dbmail;
go

-- �������� ���������� ������ � ���������� ����
EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'sql_mail_profile',  
    @recipients = 'Volodymyr.Zatkhey@lifechemicals.com',  
    @query = 'SELECT * FROM Chest35.dbo.����_�������_��_��������' ,  
    @subject = '����_�������_��_��������',  
    @attach_query_result_as_file = 1,
    @query_attachment_filename = 'SpectraDecisionType.csv', -- ��������� ��� �����, ���������� ������������� � �������������� ������ �������� �������. �������� query_attachment_filename ����� ��� nvarchar(255) � �� ��������� ��������� �������� NULL. �������� �� �����������, ���� �������� attach_query_result ����� �������� 0. ���� �������� attach_query_result ��������� �������� 1, � �������� ������� ��������� ����� NULL, �� ��������� Database Mail ������� ������������ ��� �����..
	@query_result_header = 1,								-- ���������, �������� �� ���������� ������� ��������� ��������. �������� query_result_header ����� ��� bit. ���� �������� ����� 1, ���������� ������� �������� ��������� ��������. ���� ����������� �������� 0, �� ���������� ������� �� �������� ���������� ��������. ������ �������� ����� �������� �� ��������� 1. ������ �������� �������� ������ � ��� ������, ���� ����� �������� @query.
	@query_result_width = 1000, -- ������ ������ ��� ������������� ��� �������������� ����������� ������� (� ��������). �������� query_result_width ����� ��� int � �������� �� ��������� 256. ��� �������� ������ ���������� � ��������� �� 10 �� 32767. ������ �������� �������� ������ � ��� ������, ���� ����� �������� @query.
	--@query_result_separator = '	',
	@exclude_query_output = 1 ;     
go


execute as login='IFLAB\v.zatkhey' -- ��� sa ��� �� ��������
select system_user  
EXEC msdb.dbo.sp_send_dbmail		--- ���� ����� �����������, ���� ����� � MS SQL server Management Studio ��� ������ ��������� 
    @profile_name = 'sql_mail_profile',  
    @recipients = 'Volodymyr.Zatkhey@lifechemicals.com',  
    @subject = '���� � ����������',  
    @file_attachments = 'd:\Work\Price_1_5.txt',
	@exclude_query_output = 1 ;     
go
revert

SELECT * FROM msdb.dbo.sysmail_allitems  WHERE mailitem_id > 536;

-- ��������� ���������� 
exec msdb..sysmail_help_configure_sp;
exec msdb..sysmail_configure_sp   @parameter_name = 'MaxFileSize', @parameter_value = '12000000'  -- ������������ ������ ������������ �����, �� ��������� - 1000000

SELECT send_request_user , [subject] , MAX(send_request_date) as LastDate 
FROM msdb.dbo.sysmail_allitems 
where send_request_date > '20200101'
group by send_request_user , [subject] 
order by [subject], MAX(send_request_date)
