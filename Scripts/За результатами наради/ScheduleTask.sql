--use Chest35;
--go

declare @address varchar(255)
	, @subject varchar(128)
	, @body varchar(max)
	, @bound int = 20; -- ������� �������, ��� ��������� ��� ������������� �����������
	
declare	  @ScaffoldID int
		, @ScaffoldCode varchar(16)
		, @ChemistID int
		, @ChemistCode char(3)
		, @Email varchar(128)
		, @count int;
		 
declare curEmail cursor forward_only
for
select sc.ScaffoldID, s.Code as ScaffoldCode, sc.ChemistID, p.���_����������, p.Email, count(*) as AllCount
from tblScaffold s
	inner join tblScaffoldChemist sc on sc.ScaffoldID = s.ID 
	inner join tbl����������_full p on p.��� = sc.ChemistID
	inner join tblScaffoldMaterials sm on sm.ScaffoldID  = s.ID
	inner join Materials m on m.MatID = sm.MatID
	inner join tbl�������� f on f.ID = m.MatName
where sc.NeedMsgSend <> 0 and f.�������_��_�������� = 1
group by sc.ScaffoldID, s.Code, sc.ChemistID, p.���_����������, p.Email
having count(*) >= @bound
;

open curEmail;

fetch next from curEmail into @ScaffoldID, @ScaffoldCode, @ChemistID, @ChemistCode, @Email, @count;
while @@FETCH_STATUS=0
	begin
		select @address = 'Viktoria.Kosheenko@lifechemicals.com;' + @Email + '; Volodymyr.Zatkhey@lifechemicals.com';
		select @subject = '��� ���������� ��������� �������';
		select @body = '� �������� ��������� ' + @ScaffoldCode 
						+ ' �� ����� ��������� ' + CAST(@count as varchar(10)) 
						+ ' �������.' + CHAR(10)
						+ '������� ���������� ��������� ������� ����� ������� � ��������.';
		
		select '�i��������� �� ' + @address;
		
		exec dbo.sendMessage @address, @subject, @body;
		update tblScaffoldChemist set NeedMsgSend = 0 where ScaffoldID = @ScaffoldID and ChemistID = @ChemistID;

		fetch next from curEmail into @ScaffoldID, @ScaffoldCode, @ChemistID, @ChemistCode, @Email, @count;	
	end;

close curEmail;
deallocate curEmail;