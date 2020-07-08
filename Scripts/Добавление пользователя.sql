use SKLAD30;

go

/*
Добрий день.

Прохання організувати доступ до програм чест для нового хіміка - Мельник Ярослав Володимирович (Yaroslav Melnyk)
Керівник – Манджуло Олександр.
Права доступу як у Тимошенко Тараса.

Дкую.

Regards,
Maksim Shchegelskiy

select * from Chest35.dbo.tblПоставщики_full
*/
/*
14/03/2019
From: Sergey Babiy 
Здравствуйте, прошу присвоить три буквы новому пользователю.
Лаборатория 705
Зав. Лаб BSB

Мельничук Святослава Олегівна
Тел 093-745-21-14
Смт. Калинівска, Київська обл., В4асильківський р-н вул.Лисенка 13

А также пароль на склад...

Извините, MSO!!!!

С ув. Любовь С.


*/

declare @SampleUserID int = 170 --Давыдов Александр Олегович
	  , @UserName varchar(255) = 'Мельничук Святослава Олегівна'
	  , @ParentID int = 75 --Бабий Сергей Богданович
	  , @Password varchar(32) = 'MS143752'
	  , @SupllierCode varchar(10) = 'MSO'
	  , @Login varchar(32) = 'S.Melnychuk'
	  , @NewUserID int;
	  
-- sample
select * 
from dbo.Пользователи u --where u.Parent_Id = 75
where u.Код = @SampleUserID ;

select d.* , l.Название
from dbo.Пользователи u
	inner join dbo.Пользователи_и_доступ d on d.Код_пользователя = u.Код
	inner join dbo.Уровни_доступа l on l.Код = d.Код_уровня_доступа
where u.Код = @SampleUserID and d.Код_склада != 11; ---- ос. случай ;

--- new
INSERT INTO [SKLAD30].[dbo].[Пользователи]
           ([Название]
           ,[Пароль]
           ,[Order]
           ,[Enabled]
           ,[Date]
           ,[Parent_Id]  
           ,[Код_поставщика]
           ,[Winlogin] 
           ,[Prefer_Sklad_Id])
     select
           @UserName as Название 
           ,@Password as Пароль
           ,[Order] 
           ,[Enabled]
           ,getdate() as [Date] 
           ,@ParentID -- Parent_Id 
           ,@SupllierCode as Код_поставщика 
           ,@Login
           ,Prefer_Sklad_Id 
     from SKLAD30.dbo.Пользователи u
	 where u.Код = @SampleUserID 
		and not exists(select * from  SKLAD30.[dbo].Пользователи where [Название] = @UserName);

select @NewUserID = u.Код 
from dbo.Пользователи u
where [Название] = @UserName ;


INSERT INTO [SKLAD30].[dbo].[Пользователи_и_доступ]
           ([Код_пользователя]
           ,[Код_склада]
           ,[Код_уровня_доступа])
     select
           @NewUserID as Код_пользователя 
           , Код_склада
           , Код_уровня_доступа
		from [SKLAD30].dbo.Пользователи_и_доступ d 
		where d.Код_пользователя = @SampleUserID
			and d.Код_склада != 11 ---- ос. случай
			and not exists(	select * from [SKLAD30].[dbo].[Пользователи_и_доступ] 
							where Код_пользователя = @NewUserID
								and Код_склада = d.Код_склада
								and Код_уровня_доступа = d.Код_уровня_доступа
								)
			;

-- result
select * 
from dbo.Пользователи u
where u.Код = @NewUserID ;

select d.* , l.Название
from dbo.Пользователи u
	inner join dbo.Пользователи_и_доступ d on d.Код_пользователя = u.Код
	inner join dbo.Уровни_доступа l on l.Код = d.Код_уровня_доступа
where u.Код = @NewUserID;
go

--update dbo.Пользователи set Пароль = 'lah9173' where Код = 172;

/*
use Chest35;

select * from dbo.tblПользователи where Код = 30; -- Попов Сергей Владимирович
INSERT INTO [Chest35].[dbo].[tblПользователи]
           ([Аббревиатура]
           ,[Пользователь]
           ,[Сортировка]
           ,[Ввод_заказов]
           ,[Ввод_запросов]
           ,[Торги_по_запросам]
           ,[Решение_по_запросам]
           ,[Enabled]
           ,[Вход_в_программу_Запросов]
           ,[Расширенная_информация_по_запросам]
           ,[Ответ_заказчику_по_запросу])
SELECT 'SAI' as [Аббревиатура]
      ,'Шиф Александр Игоревич' as [Пользователь]
      ,[Сортировка]
      ,[Ввод_заказов]
      ,[Ввод_запросов]
      ,[Торги_по_запросам]
      ,[Решение_по_запросам]
      ,[Enabled]
      ,[Вход_в_программу_Запросов]
      ,[Расширенная_информация_по_запросам]
      ,[Ответ_заказчику_по_запросу]
  FROM [Chest35].[dbo].[tblПользователи] 
  WHERE Код = 30 
	and not exists(select * from  [Chest35].[dbo].[tblПользователи] where [Пользователь] = 'Шиф Александр Игоревич')
GO





select * from Chest35.dbo.tblПользователи where Код = 75
select * from Chest35.dbo.tblПользователи where Код = 37

select * from Chest35.dbo.tblПользователи_П where Код_Пользователя = 81

*/


-- добавление прав на склад
declare @SampleUserID int = 57 --Манджуло Александр Юрьевич
	  , @UserID int = 170 -- Давыдов Александр Олегович
	  , @StoreID int = 1;
	  
-- sample
select * 
from dbo.Пользователи u 
where u.Код = @SampleUserID ;

select d.* , l.Название
from dbo.Пользователи u
	inner join dbo.Пользователи_и_доступ d on d.Код_пользователя = u.Код
	inner join dbo.Уровни_доступа l on l.Код = d.Код_уровня_доступа
where u.Код = @SampleUserID and d.Код_склада = @StoreID; ---- ос. случай ;

INSERT INTO [SKLAD30].[dbo].[Пользователи_и_доступ]
           ([Код_пользователя]
           ,[Код_склада]
           ,[Код_уровня_доступа])
     select
           @UserID as Код_пользователя 
           , Код_склада
           , Код_уровня_доступа
		from [SKLAD30].dbo.Пользователи_и_доступ d 
		where d.Код_пользователя = @SampleUserID
			and d.Код_склада = @StoreID
			and not exists(	select * from [SKLAD30].[dbo].[Пользователи_и_доступ] 
							where Код_пользователя = @UserID
								and Код_склада = d.Код_склада
								and Код_уровня_доступа = d.Код_уровня_доступа
								)
			;
go
			
/***************************/
/* 2019-06-10 від Zoreslav Stepanenko:
Можно оформить доступ к складской программе новому сотруднику лабораториии № 4 (заведующий Степаненко З.В.)
Архипову Вячеславу Владимировичу (аналогично как сделано для Шадмановой или Жебеля)?
*/

declare @SampleUserID int = 143 --Шадманова Виктория Игоревна
	  , @UserName varchar(255) = 'Архипов Вячеслав Владимирович'
	  , @ParentID int = 36 -- Степаненко Зореслав Викторович
	  , @Password varchar(32) = 'pparmg1967'
	  , @SupllierCode varchar(10) = 'AVV'
	  , @Login varchar(32) = 'V.Arkhipov'
	  , @NewUserID int;
	  
-- sample
select * 
from dbo.Пользователи u --where u.Parent_Id = 75
where u.Код = @SampleUserID ;

select d.* , l.Название
from dbo.Пользователи u
	inner join dbo.Пользователи_и_доступ d on d.Код_пользователя = u.Код
	inner join dbo.Уровни_доступа l on l.Код = d.Код_уровня_доступа
where u.Код = @SampleUserID and d.Код_склада != 11; ---- ос. случай ;

--- new
INSERT INTO [SKLAD30].[dbo].[Пользователи]
           ([Название]
           ,[Пароль]
           ,[Order]
           ,[Enabled]
           ,[Date]
           ,[Parent_Id]  
           ,[Код_поставщика]
           ,[Winlogin] 
           ,[Prefer_Sklad_Id])
     select
           @UserName as Название 
           ,@Password as Пароль
           ,[Order] 
           ,[Enabled]
           ,getdate() as [Date] 
           ,@ParentID -- Parent_Id 
           ,@SupllierCode as Код_поставщика 
           ,@Login
           ,Prefer_Sklad_Id 
     from SKLAD30.dbo.Пользователи u
	 where u.Код = @SampleUserID 
		and not exists(select * from  SKLAD30.[dbo].Пользователи where [Название] = @UserName);

select @NewUserID = u.Код 
from dbo.Пользователи u
where [Название] = @UserName ;


INSERT INTO [SKLAD30].[dbo].[Пользователи_и_доступ]
           ([Код_пользователя]
           ,[Код_склада]
           ,[Код_уровня_доступа])
     select
           @NewUserID as Код_пользователя 
           , Код_склада
           , Код_уровня_доступа
		from [SKLAD30].dbo.Пользователи_и_доступ d 
		where d.Код_пользователя = @SampleUserID
			and d.Код_склада != 11 ---- ос. случай
			and not exists(	select * from [SKLAD30].[dbo].[Пользователи_и_доступ] 
							where Код_пользователя = @NewUserID
								and Код_склада = d.Код_склада
								and Код_уровня_доступа = d.Код_уровня_доступа
								)
			;

-- result
select * 
from dbo.Пользователи u
where u.Код = @NewUserID ;

select d.* , l.Название
from dbo.Пользователи u
	inner join dbo.Пользователи_и_доступ d on d.Код_пользователя = u.Код
	inner join dbo.Уровни_доступа l on l.Код = d.Код_уровня_доступа
where u.Код = @NewUserID;
go
/*****************************************************************************/
/**
Володимир, прохання створити користувача для корстування програмами Чест.
Доступи по аналогії з користувачем Матюшенко Светлана Александровна - Svetlana Matyushenko
Штаюра Юлія Мар’янівна - Yuliia Shtaiura
*/


use Chest35;
go

/*
select * from dbo.tblПользователи where Код = 76; -- Матюшенко Светлана
INSERT INTO [Chest35].[dbo].[tblПользователи]
           ([Аббревиатура]
           ,[Пользователь]
           ,[Сортировка]
           ,[Ввод_заказов]
           ,[Ввод_запросов]
           ,[Торги_по_запросам]
           ,[Решение_по_запросам]
           ,[Enabled]
           ,[Вход_в_программу_Запросов]
           ,[Расширенная_информация_по_запросам]
           ,[Ответ_заказчику_по_запросу]
           , WinLogin )
SELECT null as [Аббревиатура]
      ,'Штаюра Юлія Мар`янівна' as [Пользователь]
      ,[Сортировка]
      ,[Ввод_заказов]
      ,[Ввод_запросов]
      ,[Торги_по_запросам]
      ,[Решение_по_запросам]
      ,[Enabled]
      ,[Вход_в_программу_Запросов]
      ,[Расширенная_информация_по_запросам]
      ,[Ответ_заказчику_по_запросу]
      , 'Y.Shtaiura'
  FROM [Chest35].[dbo].[tblПользователи] 
  WHERE Код = 76 
	and not exists(select * from  [Chest35].[dbo].[tblПользователи] where [Пользователь] = 'Штаюра Юлія Мар`янівна')
GO


select * from Chest35.dbo.tblПользователи where Код = 84
select * from Chest35.dbo.tblПользователи_П where Код_Пользователя = 84
*/

use SKLAD30;
go


declare @SampleUserID int = 162 -- Матюшенко Светлана Александровна
	  , @UserName varchar(255) = 'Штаюра Юлія Мар’янівна'
	  , @ParentID int = 37 -- Серебряков Игорь Маркович
	  , @Password varchar(32) = '607408'
	  , @SupllierCode varchar(10) = null
	  , @Login varchar(32) = 'Y.Shtaiura'
	  , @email varchar(255) = 'Yuliia.Staiura@lifechemicals.com'
	  , @NewUserID int;

	  
-- sample
select * 
from dbo.Пользователи u --where u.Parent_Id = 75
where u.Код = @SampleUserID ;

select d.* , l.Название
from dbo.Пользователи u
	inner join dbo.Пользователи_и_доступ d on d.Код_пользователя = u.Код
	inner join dbo.Уровни_доступа l on l.Код = d.Код_уровня_доступа
where u.Код = @SampleUserID and d.Код_склада != 11; ---- ос. случай ;

--- new
INSERT INTO [SKLAD30].[dbo].[Пользователи]
           ([Название]
           ,[Пароль]
           ,[Order]
           ,[Enabled]
           ,[Date]
           ,[Parent_Id]  
           ,[Код_поставщика]
           ,[Winlogin] 
           ,[Prefer_Sklad_Id]
           , Email )
     select
           @UserName as Название 
           ,@Password as Пароль
           ,[Order] 
           ,[Enabled]
           ,getdate() as [Date] 
           ,@ParentID -- Parent_Id 
           ,@SupllierCode as Код_поставщика 
           ,@Login
           ,Prefer_Sklad_Id
           ,@email 
     from SKLAD30.dbo.Пользователи u
	 where u.Код = @SampleUserID 
		and not exists(select * from  SKLAD30.[dbo].Пользователи where [Название] = @UserName);

select @NewUserID = u.Код 
from dbo.Пользователи u
where [Название] = @UserName ;


INSERT INTO [SKLAD30].[dbo].[Пользователи_и_доступ]
           ([Код_пользователя]
           ,[Код_склада]
           ,[Код_уровня_доступа])
     select
           @NewUserID as Код_пользователя 
           , Код_склада
           , Код_уровня_доступа
		from [SKLAD30].dbo.Пользователи_и_доступ d 
		where d.Код_пользователя = @SampleUserID
			and d.Код_склада != 11 ---- ос. случай
			and not exists(	select * from [SKLAD30].[dbo].[Пользователи_и_доступ] 
							where Код_пользователя = @NewUserID
								and Код_склада = d.Код_склада
								and Код_уровня_доступа = d.Код_уровня_доступа
								)
			;

-- result
select * 
from dbo.Пользователи u
where u.Код = @NewUserID ;

select d.* , l.Название
from dbo.Пользователи u
	inner join dbo.Пользователи_и_доступ d on d.Код_пользователя = u.Код
	inner join dbo.Уровни_доступа l on l.Код = d.Код_уровня_доступа
where u.Код = @NewUserID;
go
/*********************************************************/
/*
В связи с увольнением А.Гиль и передачей её работы новому сотруднику, Мичкову К.В., 
- просьба: создать/перенастроить рабочее место (... выдать пароль QManager). 
Прилагаю заполненную "Форму для учета сотрудника фирмы".
*/

use Chest35;
go

select * from dbo.tblПользователи where Код = 37; -- Гиль Анастасия Артемовна
INSERT INTO [Chest35].[dbo].[tblПользователи]
           ([Аббревиатура]
           ,[Пользователь]
           ,[Сортировка]
           ,[Ввод_заказов]
           ,[Ввод_запросов]
           ,[Торги_по_запросам]
           ,[Решение_по_запросам]
           ,[Enabled]
           ,[Вход_в_программу_Запросов]
           ,[Расширенная_информация_по_запросам]
           ,[Ответ_заказчику_по_запросу]
           , WinLogin )
SELECT null as [Аббревиатура]
      ,'Мічков Костянтин Валерійович' as [Пользователь]
      ,[Сортировка]
      ,[Ввод_заказов]
      ,[Ввод_запросов]
      ,[Торги_по_запросам]
      ,[Решение_по_запросам]
      ,[Enabled]
      ,[Вход_в_программу_Запросов]
      ,[Расширенная_информация_по_запросам]
      ,[Ответ_заказчику_по_запросу]
      , 'K.Michkov'
  FROM [Chest35].[dbo].[tblПользователи] 
  WHERE Код = 37
	and not exists(select * from  [Chest35].[dbo].[tblПользователи] where [Пользователь] = 'Мічков Костянтин Валерійович')
GO


select * from Chest35.dbo.tblПользователи where Код = 85
select * from Chest35.dbo.tblПользователи_П where Код_Пользователя = 85


--update [tblПользователи] set [Аббревиатура] = 'SUM'  where Код =  84
------------------------------------------------------------------------------------------------------------
-- Нікулін Олександр Анатолійович Заявка - ID 214 (Холдинг)
use Chest35;
go


select * from dbo.tblПользователи where Код = 76; -- Матюшенко Светлана
select * from tblПоставщики_full
INSERT INTO [Chest35].[dbo].[tblПользователи]
           ([Аббревиатура]
           ,[Пользователь]
           ,[Сортировка]
           ,[Ввод_заказов]
           ,[Ввод_запросов]
           ,[Торги_по_запросам]
           ,[Решение_по_запросам]
           ,[Enabled]
           ,[Вход_в_программу_Запросов]
           ,[Расширенная_информация_по_запросам]
           ,[Ответ_заказчику_по_запросу]
           , WinLogin )
SELECT 'NOA' as [Аббревиатура]
      ,'Нікулін Олександр Анатолійович' as [Пользователь]
      ,[Сортировка]
      ,[Ввод_заказов]
      ,[Ввод_запросов]
      ,[Торги_по_запросам]
      ,[Решение_по_запросам]
      ,[Enabled]
      ,[Вход_в_программу_Запросов]
      ,[Расширенная_информация_по_запросам]
      ,[Ответ_заказчику_по_запросу]
      , 'O.Nikulin'
  FROM [Chest35].[dbo].[tblПользователи] 
  WHERE Код = 76 
	and not exists(select * from  [Chest35].[dbo].[tblПользователи] where [Пользователь] = 'Нікулін Олександр Анатолійович')
GO


select * from Chest35.dbo.tblПользователи where Код = 86
select * from Chest35.dbo.tblПользователи_П where Код_Пользователя = 86
go

--update tblПоставщики_full set Email = 'Oleksandr.Nikulin@spec-info.com' where Код  = 680;
--update tblПоставщики_full set Email = 'Yuliia.Staiura@lifechemicals.com' where Код  = 681;


use SKLAD30;
go


declare @SampleUserID int = 170 -- Давыдов Александр Олегович
	  , @UserName varchar(255) = 'Нікулін Олександр Анатолійович'
	  , @ParentID int = 75 -- Бабий Сергей Богданович
	  , @Password varchar(32) = '41031107'
	  , @SupllierCode varchar(10) = 'NOA'
	  , @Login varchar(32) = 'O.Nikulin'
	  , @email varchar(255) = 'Oleksandr.Nikulin@spec-info.com'
	  , @NewUserID int;

	  
-- sample
select * 
from dbo.Пользователи u --where u.Parent_Id = 75
where u.Код = @SampleUserID ;

/*
select d.* , l.Название
from dbo.Пользователи u
	inner join dbo.Пользователи_и_доступ d on d.Код_пользователя = u.Код
	inner join dbo.Уровни_доступа l on l.Код = d.Код_уровня_доступа
where u.Код = @SampleUserID and d.Код_склада != 11; ---- ос. случай ;
*/
--- new
INSERT INTO [SKLAD30].[dbo].[Пользователи]
           ([Название]
           ,[Пароль]
           ,[Order]
           ,[Enabled]
           ,[Date]
           ,[Parent_Id]  
           ,[Код_поставщика]
           ,[Winlogin] 
           ,[Prefer_Sklad_Id]
           , Email )
     select
           @UserName as Название 
           ,@Password as Пароль
           ,[Order] 
           ,[Enabled]
           ,getdate() as [Date] 
           ,@ParentID -- Parent_Id 
           ,@SupllierCode as Код_поставщика 
           ,@Login
           ,Prefer_Sklad_Id
           ,@email 
     from SKLAD30.dbo.Пользователи u
	 where u.Код = @SampleUserID 
		and not exists(select * from  SKLAD30.[dbo].Пользователи where [Название] = @UserName);

select @NewUserID = u.Код from dbo.Пользователи u where [Название] = @UserName ;


INSERT INTO [SKLAD30].[dbo].[Пользователи_и_доступ]
           ([Код_пользователя]
           ,[Код_склада]
           ,[Код_уровня_доступа])
     select
           @NewUserID as Код_пользователя 
           , Код_склада
           , Код_уровня_доступа
		from [SKLAD30].dbo.Пользователи_и_доступ d 
		where d.Код_пользователя = @SampleUserID
			and d.Код_склада != 11 ---- ос. случай
			and not exists(	select * from [SKLAD30].[dbo].[Пользователи_и_доступ] 
							where Код_пользователя = @NewUserID
								and Код_склада = d.Код_склада
								and Код_уровня_доступа = d.Код_уровня_доступа
								)
			;

-- result
select * 
from dbo.Пользователи u
where u.Код = @NewUserID ;

select d.* , l.Название
from dbo.Пользователи u
	inner join dbo.Пользователи_и_доступ d on d.Код_пользователя = u.Код
	inner join dbo.Уровни_доступа l on l.Код = d.Код_уровня_доступа
where u.Код = @NewUserID;
go

-- вже нема
/*
begin tran
delete from  SKLAD30.dbo.Пользователи_и_доступ where Код_пользователя = 178
delete from  SKLAD30.dbo.Пользователи where Код = 178
delete from Chest35.dbo.tblПользователи where Код = 86
delete from Chest35.dbo.tblПользователи_П where Код_Пользователя = 86
commit
*/
/***********************************************************************/
/* Заявка - ID 424 (Холдинг) По проханню Манджуло Олександра потрібно створити доступи до складу та честу по анології як у Тимошенко Тараса. */
use SKLAD30 ;
go

declare @SampleUserID int = 65  --Тимошенко Тарас Петрович
	  , @UserName varchar(255) = 'Манзюк Олександр Володимирович'
	  --, @ParentID int = 36 -- Степаненко Зореслав Викторович
	  , @Password varchar(32) = 'hgf6785'
	  , @SupllierCode varchar(10) = null
	  , @Login varchar(32) = 'O.Manziuk'
	  , @email varchar(255) = 'Oleksandr.Manziuk@lifechemicals.com'
	  , @NewUserID int	  
;
-- SKLAD30	  
-- sample
select * 
from dbo.Пользователи u --where u.Parent_Id = 75
where u.Код = @SampleUserID ;

select d.* , l.Название
from dbo.Пользователи u
	inner join dbo.Пользователи_и_доступ d on d.Код_пользователя = u.Код
	inner join dbo.Уровни_доступа l on l.Код = d.Код_уровня_доступа
where u.Код = @SampleUserID and d.Код_склада != 11; ---- ос. случай ;

--- new
INSERT INTO [SKLAD30].[dbo].[Пользователи]
           ([Название]
           ,[Пароль]
           ,[Order]
           ,[Enabled]
           ,[Date]
           ,[Parent_Id]  
           ,[Код_поставщика]
           ,[Winlogin] 
           ,[Prefer_Sklad_Id])
     select
           @UserName as Название 
           ,@Password as Пароль
           ,[Order] 
           ,[Enabled]
           ,getdate() as [Date] 
           ,Parent_Id 
           ,@SupllierCode as Код_поставщика 
           ,@Login
           ,Prefer_Sklad_Id 
     from SKLAD30.dbo.Пользователи u
	 where u.Код = @SampleUserID 
		and not exists(select * from  SKLAD30.[dbo].Пользователи where [Название] = @UserName);

select @NewUserID = u.Код 
from dbo.Пользователи u
where [Название] = @UserName ;


INSERT INTO [SKLAD30].[dbo].[Пользователи_и_доступ]
           ([Код_пользователя]
           ,[Код_склада]
           ,[Код_уровня_доступа])
     select
           @NewUserID as Код_пользователя 
           , Код_склада
           , Код_уровня_доступа
		from [SKLAD30].dbo.Пользователи_и_доступ d 
		where d.Код_пользователя = @SampleUserID
			and d.Код_склада != 11 ---- ос. случай
			and not exists(	select * from [SKLAD30].[dbo].[Пользователи_и_доступ] 
							where Код_пользователя = @NewUserID
								and Код_склада = d.Код_склада
								and Код_уровня_доступа = d.Код_уровня_доступа
								)
			;

-- result
select * 
from dbo.Пользователи u
where u.Код = @NewUserID ;

select d.* , l.Название
from dbo.Пользователи u
	inner join dbo.Пользователи_и_доступ d on d.Код_пользователя = u.Код
	inner join dbo.Уровни_доступа l on l.Код = d.Код_уровня_доступа
where u.Код = @NewUserID;

go

