-- ================================================
-- Template generated from Template Explorer using:
-- Create Trigger (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- See additional Create Trigger templates for more
-- examples of different Trigger statements.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		V. Zatkhey
-- Create date: 10/09/2019
-- Description:	send analyse decision message
-- =============================================
--CREATE TRIGGER [dbo].[TR_UPDATE_Sklad30_�������_send_msg] 
ALTER TRIGGER [dbo].[TR_UPDATE_Sklad30_�������_send_msg] 
   ON [dbo].[__�������]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

/*
���������� 277
�������� ������� ����������� ����� � ������ �����, ���� ����������� �� ����� �������� �������.
�����, ���� ��������� ������ �� ��������, ��� ���������� ���� ����, ��� ���� �������, ���-�����, ����� � ����� ��������.
����� ������ ������ ��������.
*/
	IF UPDATE([�������_��_�������])
		BEGIN
			declare @message varchar(255) = ''
				  , @CAS varchar(25), @ProdName varchar(255)
				  , @EMailAddress varchar(255), @UserID int
				  , @PostCode varchar(255), @PostDecision varchar(255) ;

			declare curEMail cursor forward_only
			for select  t.���_������������
						, u.Email
					from inserted p 
						inner join __���������� t on t.���_ID_�������� = p.���_ID_�������� 
						inner join dbo.������������ u on u.��� = t.���_������������ 
					where p.�������_��_������� != 0
						and t.��������� = 1
						and t.����������_�������� < 2
						and t.��������� < 2
						and t.��������� < 2
						and t.������ = 0	
						and t.��_����� = 0
						and u.Email is not null
					group by  t.���_������������, u.Email
					
			OPEN curEMail;
			FETCH NEXT FROM curEMail INTO  @UserID,  @EMailAddress;
			WHILE @@FETCH_STATUS = 0
			BEGIN
				SELECT @message = ''
				declare curSolution cursor forward_only
				for select  v.CAS
							, isnull(v.ProdName,'')
							, isnull(i.��������,'')
								+ case when i.�������� is not null and post.�����_�������� is not null
									then '-'
									else ''
									end
								+ isnull(post.�����_��������,'') as PostCode  
							, isnull(r.��������_����,'')  as �������_��_�������
						from inserted p 
							inner join __�������� v on v.���_ID = p.���_ID_�������� 
							inner join __���������� t on t.���_ID_�������� = p.���_ID_�������� 
							inner join __�������� post on post.���_ID = p.���_ID_��������
							inner join __��������� i on i.���_ID = post.���_ID_��������� 
							inner join ����_�������_��_���������_��������� r on r.��� = p.�������_��_������� 
						where p.�������_��_������� != 0
							and t.���_������������ = @UserID
							and t.��������� = 1
							and t.����������_�������� < 2
							and t.��������� < 2
							and t.��������� < 2
							and t.������ = 0	
							and t.��_����� = 0
			
				OPEN curSolution;
				FETCH NEXT FROM curSolution INTO  @CAS,  @ProdName, @PostCode, @PostDecision;
				WHILE @@FETCH_STATUS = 0
				BEGIN

					SELECT @message = @CAS + ' ' + @ProdName + ' �� �������� ' + @PostCode + ' - ' + @PostDecision + '.' + CHAR(13) + CHAR(10);

					FETCH NEXT FROM curSolution INTO  @CAS,  @ProdName, @PostCode, @PostDecision;
				END
				CLOSE curSolution;
				DEALLOCATE curSolution;


				if @message != ''
					begin
					select @message =  '������ ������� �� ������� ��� ��������: '  + CHAR(13) + CHAR(10) + @message
					exec sendMessage @recipients = @EMailAddress
								, @subject = '����� ���������. ����� ������.'
								,  @message = @message;
					end	
				
				FETCH NEXT FROM curEMail INTO  @UserID,  @EMailAddress;
			END
			CLOSE curEMail;
			DEALLOCATE curEMail;
		END
END
GO
