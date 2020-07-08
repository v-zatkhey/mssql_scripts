select * from tblТипы_спектров where Тип in ('S', 'M' ,'G');
select * from [tblВиды_Растворителей] v where  v.Тип in (1,2,25) and Category = 2 order by v.Тип, v.Sorting;


SELECT t.Тип, v.Код, v.Name, v.Sorting  
FROM [Chest35].[dbo].[tblВиды_Растворителей] v
	inner join tblТипы_спектров t on t.Код = v.Тип
where v.Тип in (1,2,25)
	and Category = 2
order by v.Тип, Sorting;

select len('Заказчик принимает с любой чистотой!')

/*
insert into [tblВиды_Растворителей](Name,Comments,Category,Sorting,Тип)
values ('Принимаем!','Заказчик принимает с любой чистотой!',2,500,1)
	,  ('Принимаем!','Заказчик принимает с любой чистотой!',2,500,2)
	,  ('Принимаем!','Заказчик принимает с любой чистотой!',2,500,25)
*/
--UPDATE [tblВиды_Растворителей] SET Sorting = 500 WHERE Код in (224,236,232,220,231,219)

select i.* 
from dbo.MaterialInfo i inner join Materials m on m.MatID = i.MatID
where m.MatName = 'F6782-0635';
--update MaterialInfo set DateFailure = getdate() where MInfoID = 7063397;