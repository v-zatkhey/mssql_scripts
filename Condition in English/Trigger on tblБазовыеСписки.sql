USE [Chest35]
GO
/****** Object:  Trigger [dbo].[tblБазовыеСписки_triu]    Script Date: 10/22/2018 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[tblБазовыеСписки_triu] ON [dbo].[tblБазовыеСписки]
WITH EXECUTE AS CALLER
FOR INSERT, UPDATE
AS
BEGIN
  UPDATE t
     set ID = UPPER(i.ID)
  FROM [dbo].[tblБазовыеСписки] t
  JOIN inserted i
    ON i.Код_ID = t.Код_ID
  WHERE CAST(t.ID as varbinary(2000)) <> CAST(upper(i.ID) as varbinary(2000))
    AND i.ID IS NOT NULL

if update([Условия_взвешивания])    
	begin
	/*
	UPDATE t
     set [Код_условия_взвешивания] = u.Код
	FROM [dbo].[tblБазовыеСписки] t
	  inner join inserted i on i.Код_ID = t.Код_ID
	  left join deleted d on d.Код_ID = t.Код_ID
	  left JOIN dbo.[tblТипы_условий_взвешивания] u on u.[Условие взвешивания]= t.[Условия_взвешивания]
	where isnull(d.Условия_взвешивания,'') <> isnull(i.Условия_взвешивания,'') ;
	*/
	declare @new_cond table(bl_id int, cond_id int);
	
	-- из каких условий из справочника слеплена строка условий в базовом списке
	insert into @new_cond(bl_id, cond_id)
	select distinct  bl.Код_ID , cnd.Код 
	from inserted	 bl
		inner join tblТипы_условий_взвешивания cnd on bl.Условия_взвешивания like '%'+ cnd.[Условие взвешивания] + '%' 
				and cnd.Код not in (31,32,33);										-- с этими кодами - двойные условия. потом удалить 
	
	--ненужные следует удалить
	delete from tblBaseListCondition
	from tblBaseListCondition blc
		inner join inserted i on i.Код_ID = blc.BaseListID
		left join @new_cond t on blc.BaseListID = t.bl_id and blc.ConditionID = t.cond_id 
	where t.bl_id is null;				
	
	--недостающие - добавить
	insert into tblBaseListCondition(BaseListID,ConditionID)
	select t.bl_id,t.cond_id 
	from @new_cond t 
	where not exists(select * from tblBaseListCondition where BaseListID = t.bl_id and ConditionID = t.cond_id);				

	end  
END
go

--exec sp_who active