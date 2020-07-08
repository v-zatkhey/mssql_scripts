SELECT Код,Тип, Name, Comments, Category FROM tblВиды_Растворителей WHERE Category=2
SELECT * FROM tblВиды_Растворителей WHERE Category=2 AND Тип in (1,2,7,15,23,25) ORDER BY Sorting, Код
select * from tblТипы_спектров where Код in (1,2,7,15,23,25)
SELECT Тип FROM tblВиды_Растворителей WHERE Category=2 group by  Тип

-- insert into  tblВиды_Растворителей (Name,Comments,Category,Sorting,[Тип])
select 'СРОЧНО!' 
	, 'СРОЧНО!'
	, 2 as Category
	, 555 as Sorting
	, Код as [Тип]
from tblТипы_спектров 
where Код in (1,2,7,15,23,25)


/*
Хорошо, давайте попросим Володю добавить «не отбирать».

...

С ув. Любовь С[идоржевская]
*/
-- insert into  tblВиды_Растворителей (Name,Comments,Category,Sorting,[Тип])
select 'НЕ ОТБИРАТЬ!' 
	, 'НЕ ОТБИРАТЬ!'
	, 2 as Category
	, 555 as Sorting
	, Код as [Тип]
from tblТипы_спектров 
where Код in (1,2,7,15,23,25);

--------------------------------------
SELECT * FROM tblВиды_Растворителей WHERE Category=1 AND Тип in (1,7) ORDER BY Тип, Sorting, Код
select * from tblТипы_спектров where Код in (1,2,7,15,23,25)

--insert into tblВиды_Растворителей (Name,Comments,Category,Sorting,[Тип])values ('D2O+TFA','D2O+TFA',1,140,1),('D2O+TFA','D2O+TFA',1,140,7);


/*****/
select * from tblТипы_спектров where Код in (2,15)
SELECT * FROM tblВиды_Растворителей 
WHERE Category=2 AND Тип in (2,15) 
ORDER BY [Тип], Sorting, Код
