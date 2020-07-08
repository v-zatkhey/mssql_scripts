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
-- Author:		V.Zatkhey
-- Create date: 20/05/2020
-- Description:	Set Updated
-- =============================================
CREATE TRIGGER dbo.tr_MaterialCalculatedParams_UPD_INS 
   ON  dbo.MaterialCalculatedParams
   AFTER  INSERT,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    if not update(Updated)
		begin
			update m
			set Updated = GETDATE()
			from MaterialCalculatedParams m
				inner join inserted i on i.ID = m.ID
		end 

END
GO
