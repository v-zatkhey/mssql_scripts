USE [Chest35]
GO



SELECT     ���, ID, ��������, ���_���������, ��������, CONVERT(varchar, Date_, 3) AS ����, CONVERT(varchar, Date_, 8) AS �����, 
                      Date_, Spectra_Block
--into _tmp_�������_�����_delete_bak_20180424                      
FROM         dbo.�������_�����
where ID = 'F3409-1155'

GO


delete from dbo.�������_����� where ID = 'F3409-1155'