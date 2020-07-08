/*
12.03.2019
Антон Червюк:

К сожалению, Александра сообщила про следующие таутомерные дубли,  которые ЧЕСТ не показывает:
F1274-0263
F0451-0040

*/
use Chest35;
go 

select * from tblПовторы where ID in ('F1274-0263','F0451-0040')
/*
insert into tblПовторы(ID, IDdupl, Flag_work)
	values('F1274-0263','F0451-0040',1)
	, ('F0451-0040','F1274-0263',1);
	
update tblПовторы 
set Ves = (select MIN(Код) from tblПовторы where ID in ('F1274-0263','F0451-0040')) 
where ID in ('F1274-0263','F0451-0040')
*/
select * from tblПовторы where ID in ('F1274-0263','F0451-0040')
/*
insert into tblПовторы(ID, IDdupl, Ves, Flag_work)
	values('F8888-4090','F0451-0040',276737,1)
	, ('F8888-4090','F1274-0263',276737,1)
	, ('F1274-0263','F8888-4090',276737,1)
	, ('F0451-0040','F8888-4090',276737,1);
*/


SELECT [MaterialChiralID]
      ,[MatID1]
      ,[MatID2]
      ,[Note]
  FROM [Chest35].[dbo].[MaterialChiral]
  where [MatID1] = 4444412 
	 or [MatID1]in (
					  SELECT [MatID2]
					  FROM [Chest35].[dbo].[MaterialChiral]
					  where [MatID1] = 4444412
					)
GO


select * from Materials where MatName = 'F1915-0028' --5536279

select * from Materials where MatName IN ('F3409-1320','F3409-1321','F3409-1322')
/*
6271784
6271785
6271786
*/

insert into [MaterialChiral]([MatID1], [MatID2]) values	  (5536279, 6271784)
														 ,(5536279, 6271785)
														 ,(5536279, 6271786)
														 
insert into [MaterialChiral]([MatID1], [MatID2]) values	  (6271784, 5536279)
														 ,(6271784, 6271785)
														 ,(6271784, 6271786)
insert into [MaterialChiral]([MatID1], [MatID2]) values	  (6271785, 6271784)
														 ,(6271785, 5536279)
														 ,(6271785, 6271786)
insert into [MaterialChiral]([MatID1], [MatID2]) values	  (6271786, 6271784)
														 ,(6271786, 6271785)
														 ,(6271786, 5536279)
														 
														 
/***********************************************/		
select MatID from Materials where MatName in ('F0001-0128', 'F0001-4396', 'F0001-4400')
/*
4242016
6280239
6280243
*/

insert into [MaterialChiral]([MatID1], [MatID2]) values	  (4242016, 6280239)
														 ,(4242016, 6280243)
insert into [MaterialChiral]([MatID1], [MatID2]) values	  (6280239, 4242016)
														 ,(6280239, 6280243)
insert into [MaterialChiral]([MatID1], [MatID2]) values	  (6280243, 4242016)
														 ,(6280243, 6280239)

select * from [MaterialChiral] where [MatID1]in (4242016,6280239,6280243)