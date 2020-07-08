use SKLAD30;
go

/*** Склады *******/
--select * from dbo.Склады

if not exists(select * from dbo.eqsStorePointType)
begin
	insert into eqsStorePointType(ID, Name) values (1, 'склад')
													,(2, 'матеріально відповідальна особа');											
end;
if not exists(select * from dbo.eqsStorePoint where StorePointTypeID = 1)
begin

set identity_insert eqsStorePoint on
	insert into eqsStorePoint(ID, StorePointTypeID, Name) values (1, 1, 'Cклад обладнання для лабораторій')
													,(2, 1, 'Склад лабораторного посуду та тари')	;										
set identity_insert eqsStorePoint off
end;
go

/*************** мат.ответственные **************/
/*
  SELECT [Потребитель]
      ,max([Полное название потребителя]) as [Полное название потребителя]
      ,COUNT(*)
  FROM [SKLAD30].[dbo].[__Потребители]
  where [Код_с]in (11,13) and [Полное название потребителя]is not null
  group by [Потребитель];
 */ 
--select * from eqsStorePoint where StorePointTypeID = 2
--delete from eqsStorePoint where ID = 18 and Name = 'Ивченко Раиса Григорьевна';
--delete from eqsStorePoint where ID = 54 and Name = 'Сидоржевская Любовь Анатольевна';
if not exists(select * from eqsStorePoint where StorePointTypeID = 2)
begin
declare @MaxID bigint =isnull( (select max(ID) from eqsStorePoint),0);
set identity_insert eqsStorePoint on
	insert into eqsStorePoint(ID, StorePointTypeID, Name)
	 SELECT @MaxID + ROW_NUMBER() over(order by max([Полное название потребителя]) asc)
	 , 2
     ,max([Полное название потребителя]) as [Полное название потребителя]
	  FROM [SKLAD30].[dbo].[__Потребители]
	  where [Код_с]in (11,13) and [Полное название потребителя]is not null
	  group by [Потребитель]; 											
set identity_insert eqsStorePoint off
end;
go

if not exists(select * from eqsFinRespPerson)
begin
	insert into eqsFinRespPerson(ID, InitialsName)
	select sp.ID, x.Потребитель
	from eqsStorePoint sp
	 inner join
	 (SELECT max([Полное название потребителя]) as [Полное название потребителя]
		, [Потребитель]
	  FROM [SKLAD30].[dbo].[__Потребители]
	  where [Код_с]in (11,13) and [Полное название потребителя]is not null and [Потребитель]<> 'GIR'and [Потребитель]<>'SAL'
	  group by [Потребитель]) x on x.[Полное название потребителя] = sp.Name
	where sp.StorePointTypeID = 2
	order by sp.Name; 											
end;
go

/******** единицы измерения ***************/
if not exists(select * from eqsUnitFactor)
begin
	delete from  eqsUnit;
	set identity_insert eqsUnit on;
	insert into eqsUnit(ID, Name, ShortName)
	values (1, 'штука', 'шт.'); 											
	set identity_insert eqsUnit off;
end;
go

/******** категории и подкатегории ********/
/*
select * from dbo.__Категории c
where c.Код_с = 11
select * from dbo.__Категории c
where c.Код_с = 13

select c.Категория,  v.*
from dbo.__Вещества v
	inner join dbo.__Категории c on c.Код_ID = v.Category_ID
where v.Код_с = 11 or v.Код_с = 13
order by v.Category_ID


select  v.*
from dbo.__Вещества v
where v.Код_с = 11 and v.RusName <> v.ProdName
*/
-- delete from eqsSubCategory
-- delete from eqsCategory
set identity_insert eqsSubCategory on;
if not exists(select * from eqsCategory) and not exists(select * from eqsSubCategory)
begin
insert into 	 eqsCategory (ID,Name) 	values	 ( 1, 'ЛАБОРАТОРНАЯ ПОСУДА И ПРИНАДЛЕЖНОСТИ'); 
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (1, 1, 'Стеклянная лабораторная посуда');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (2, 1, 'Мерная посуда стеклянная и пластиковая');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (3, 1, 'Пластиковая химическая посуда');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (4, 1, 'Лабораторная посуда из высокотемпературного фарфора');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (5, 1, 'Принадлежности лабораторные из стали');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (6, 1, 'Изделия из резины для лабораторий');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (7, 1, 'Трубка стеклянная и дрот');
insert into 	 eqsCategory (ID,Name) 	values	 ( 2, 'ИЗМЕРИТЕЛЬНОЕ ОБОРУДОВАНИЕ И ПРИБОРЫ'); 
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (8, 2, 'Весы лабораторные и промышленные');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (9, 2, 'Микропипетки, бутылочные дозаторы');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (10, 2, 'Спектрофотометры и фотометры');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (11, 2, 'Электронные термометры');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (12, 2, 'Измерение влажности');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (13, 2, 'рН-метры, рН-электроды, индикаторная бумага');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (14, 2, 'Кондуктометры');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (15, 2, 'Оксиметры растворенного кислорода');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (16, 2, 'Мультиметры');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (17, 2, 'Отбор проб для аналитического контроля');
insert into 	 eqsCategory (ID,Name) 	values	 ( 3, 'СПЕЦИАЛЬНОЕ АНАЛИТИЧЕСКОЕ ОБОРУДОВАНИЕ'); 
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (18, 3, 'Аналитические сита и просеивающие машины');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (19, 3, 'Испарители ротационные');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (20, 3, 'Системы анализа белка методом Кьельдаля');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (21, 3, 'Экспресс-метод определения содержания азота/белка методом Дюма');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (22, 3, 'Аппараты для экстракции жиров и клетчатки');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (23, 3, 'Флоккуляторы для определения коагулянтов');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (24, 3, 'Оборудование для промышленного применения');
insert into 	 eqsCategory (ID,Name) 	values	 ( 4, 'ЛАБОРАТОРНЫЕ МЕШАЛКИ, ДОЗАТОРЫ, НАСОСЫ'); 
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (25, 4, 'Магнитные мешалки с подогревом и без подогрева');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (26, 4, 'Мешалки лабораторные с верхним приводом');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (27, 4, 'Мельницы лабораторные');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (28, 4, 'Насосы');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (29, 4, 'Ультразвуковые бани и диспергаторы');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (30, 4, 'Центрифуги лабораторные');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (31, 4, 'Шейкеры (встряхиватели), 3D шейкеры, миксеры');
insert into 	 eqsCategory (ID,Name) 	values	 ( 5, 'ОБОРУДОВАНИЕ ДЛЯ НАГРЕВА И ОХЛАЖДЕНИЯ'); 
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (32, 5, 'Бани водяные лабораторные');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (33, 5, 'Горелки газовые лабораторные');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (34, 5, 'Инкубаторы биологические, СО2-инкубаторы');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (35, 5, 'Климатические и испытательные камеры');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (36, 5, 'Печи муфельные');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (37, 5, 'Плитки и колбонагреватели лабораторные');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (38, 5, 'Сушильные шкафы MEMMERT');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (39, 5, 'Термореакторы');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (40, 5, 'Термостаты жидкостные');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (41, 5, 'Холодильники и морозильники лабораторные');
insert into 	 eqsCategory (ID,Name) 	values	 ( 6, 'ФИЛЬТРОВАЛЬНЫЕ И ХРОМАТОГРАФИЧЕСКИЕ МАТЕРИАЛЫ'); 
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (42, 6, 'Бумага фильтровальная лабораторная');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (43, 6, 'Экстракционные патроны');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (44, 6, 'Мембранные фильтры для лабораторных целей');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (45, 6, 'Шприцевые мембранные фильтры');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (46, 6, 'Бумага специальная лабораторная');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (47, 6, 'Хроматографические виалы, флаконы и крышки.');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (48, 6, 'Хроматографические шприцы (микрошприцы)');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (49, 6, 'Колонки хроматографические');
insert into 	 eqsCategory (ID,Name) 	values	 ( 7, 'МИКРОБИОЛОГИЧЕСКИЕ ИССЛЕДОВАНИЯ'); 
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (50, 7, 'Оборудование для инкубации');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (51, 7, 'Стеклянная посуда для микробиологии');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (52, 7, 'Стекла предметные и покровные');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (53, 7, 'Лабораторный пластик одноразовый');
insert into 	 eqsCategory (ID,Name) 	values	 ( 8, 'БЕЗОПАСНОСТЬ ЛАБОРАТОРНЫХ РАБОТ'); 
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (54, 8, 'Коврики лабораторные');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (55, 8, 'Перчатки для лабораторных работ');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (56, 8, 'Принадлежности для защиты глаз и лица');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (57, 8, 'Утилизация лабораторных отходов');
insert into 	 eqsCategory (ID,Name) 	values	 ( 9, 'ІНШЕ'); 
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (58, 9, 'Витратні матеріали');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (59, 9, 'Запасні частини');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (60, 9, 'Інструменти');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (61, 9, 'Тара');
insert into 	 eqsSubCategory (ID, CategoryID, Name)	values	 (62, 9, 'Інше');

end
set identity_insert eqsSubCategory off;

-- select c.*, s.* from eqsCategory c inner join eqsSubCategory s on s.CategoryID = c.ID
go
/********* группы **********************/
if not exists(select * from eqsGroup)	
begin
	set identity_insert eqsGroup on;

	insert into   eqsGroup (ID, SubCategoryID, Name) values  (1,1, 'Колби лабораторні скляні ');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (2,1, 'Прилади скляні');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (3,1, 'Крани скляні');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (4,2, 'Бюретки мірні');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (5,2, 'Склянки скляні та тефлонові');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (6,2, 'Єксікатори скляні та пластикові');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (7,2, 'Циліндри мірні');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (8,2, 'Лійки скляні та пластикові');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (9,4, 'Склянки та кухлі порцелянові');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (10,6, 'Трубки з''єднувальні та вакуумні');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (11,7, 'Трубка скляна');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (12,9, 'Дозувачі цифрові');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (13,11, 'Термометри');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (14,28, 'Обладнання та прилади');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (15,41, 'Судини Дьюара');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (16,41, 'Холодильники скляні');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (17,58, 'Витратні матеріали');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (18,59, 'Запасні частини');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (19,60, 'Інструменти');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (20,61, 'Тара');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (21,62, 'Миючі засоби');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (22,62, 'Товари особистої гігієни');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (23,62, 'Засоби захисту');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (24,62, 'Товари широкого вжитку');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (25,62, 'Інвентар');
	insert into   eqsGroup (ID, SubCategoryID, Name) values  (26,62, 'ПММ');
		
	set identity_insert eqsGroup off;
end

--select * from eqsGroup
go

-- link to old categories
if not OBJECT_ID(N'eqs_OldCategoryLink') is null drop table eqs_OldCategoryLink;
create table eqs_OldCategoryLink(OldCategoryKodID int, GroupID bigint);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (42,1);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (46,4);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (51,8);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (59,14);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (57,17);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (35,1);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (37,1);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (39,1);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (52,16);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (25,8);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (45,12);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (30,15);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (58,18);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (61,19);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (55,1);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (38,1);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (32,1);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (53,11);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (24,3);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (50,8);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (54,2);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (21,1);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (34,1);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (23,8);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (63,8);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (43,1);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (9,14);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (62,1);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (60,2);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (33,1);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (36,1);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (27,5);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (64,14);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (31,20);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (28,13);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (40,1);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (49,10);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (48,11);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (56,1);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (47,9);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (19,16);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (44,7);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (41,1);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (29,6);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (12,21);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (13,22);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (14,23);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (15,24);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (16,25);
insert into   eqs_OldCategoryLink (OldCategoryKodID, GroupID) values  (17,26);
go
/**************** Item ***********************************/
/*
select * from eqsGroup
select  l.GroupID, v.ProdName
		, case when v.SynonName is null and v.Notice is null 
			then null	
			else ISNULL(v.SynonName,'') + case when v.Notice is null then '' else ' ' + v.Notice end
			end as Comments
		, v.Код_ID
		, * 
from dbo.__Вещества v 
	left join eqs_OldCategoryLink l on l.OldCategoryKodID = v.Category_ID --283
where v.Код_с in (11,13) --294 
	and l.OldCategoryKodID is null
*/


if not exists(select * from eqsItem) 
begin
	insert into eqsItem(GroupID,Name, Comments, OldCodeID)
	select  isnull(l.GroupID,24) -- Товари широкого вжитку
			, v.ProdName
			, case when v.SynonName is null and v.Notice is null 
				then null	
				else ISNULL(v.SynonName,'') + case when v.Notice is null then '' else ' ' + v.Notice end
				end as Comments
			, v.Код_ID
	from dbo.__Вещества v 
		left join eqs_OldCategoryLink l on l.OldCategoryKodID = v.Category_ID --283
		left join eqsItem i on i.OldCodeID = v.Код_ID
	where v.Код_с in (11,13) and i.ID is null

end; -- 283 -- +11
go

insert into eqsUnitFactor(UnitID,ItemID,UnitQuantity)
select 1, i.ID, 1
from eqsItem i
where not exists(select * from eqsUnitFactor where ItemID = i.ID and UnitQuantity = 1);
go


/********************типы документов**********************/
if not exists(select * from eqsDocType)
begin
insert into eqsDocType(ID, Name, IsOuterDoc, TableName)
	values(1, 'Прибуткова накладна', 1, 'eqsDocIncoming')
	,(2, 'Видаткова накладна', 1, 'eqsDocOutgoing')	
	,(3, 'Накладна на внутрішнє переміщення', 0, 'eqsDocMove')
	,(4, 'Початкові залишки', 0, 'eqsDocMove')	
	,(5, 'Списання', 1, 'eqsDocWriteOff')	
	,(6, 'Прибуток зі статті', 1, 'eqsDocArticleIn')	
	,(7, 'Пересортиця', 0, 'eqsDocRegrading');
end;

-- delete from eqsStatus
if not exists(select * from eqsStatus)
begin
insert into eqsStatus(ID, Name, Short, Code)
	values(0, 'Чернетка', 'ЧН', 'DFT')
		 ,(1, 'Проведений', 'ПР', 'FIN')	
end;
go

/********** контрагенты *******/

--select * from eqsContractor
/*
insert into eqsContractor(Name, FullName, Comments, OldCodeID)
select Источник, [Полное название источника] , Инв_номер , Код_ID  
from dbo.__Источники 
where (Код_с  = 11 or Код_с  = 13) 
*/

--update c 
--set EDRPOU = LEFT(Comments,10)
--	, Comments = LTRIM( SUBSTRING(Comments, 11, LEN(Comments)-10))
select LEFT(Comments,10), LTRIM ( SUBSTRING(Comments, 11, LEN(Comments)-10)), * 
from eqsContractor c
where LEFT(Comments,10) like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	and ID not in (11,73,106,118) 
	and EDRPOU is null;
	
--update c 
--set EDRPOU = LEFT(Comments,8)
--	, Comments = LTRIM ( SUBSTRING(Comments, 9, LEN(Comments)-8))
select LEFT(Comments,8), LTRIM ( SUBSTRING(Comments, 9, LEN(Comments)-8)), * 
from eqsContractor c
where LEFT(Comments,8) like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	and ID not in (11,73,106,118) 
	and EDRPOU is null;
go	
	