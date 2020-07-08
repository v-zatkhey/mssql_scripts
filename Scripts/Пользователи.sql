SELECT [Код]
      ,[Пользователь]
  FROM [Chest35].[dbo].[tblПользователи]
  where [Enabled]=1
  order by 2
GO

SELECT [Код]
      ,[Название] as [Пользователь]
  FROM [SKLAD30].[dbo].[Пользователи]
  where [Enabled]=1
		and Код not in (93,151,94,155)
  order by 2
  
GO

-- 1234567
SELECT *
  FROM tblПользователи_П pw
	inner join [tblПользователи] p on p.Код = pw.Код_Пользователя
  where [Код_Пользователя]=62
  
update tblПользователи_П set [Пароль] = '1234567' where [Код_Пользователя]=62;

exec sp_helptext sp_who

