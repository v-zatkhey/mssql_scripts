/*
Володя, добрый день, сделай мне, пожалуйста, выборку по всем продуктам Спектрум, которых имеется больше 50г. 
Критерий – поставки должны быть от BSB, SUA, PSV, ADA, JTG, OAM, GER, VAP, MSO, DAO.

Спасибо,
Сергей Попов
*/
use Chest35;
go

declare @ChemList as table(Abbr char(3));
insert into @ChemList values
('BSB')
,('SUA')
,('PSV')
,('ADA')
,('JTG')
,('OAM')
,('GER')
,('VAP')
,('MSO')
,('DAO')
--,('SKP')
--,('MNB')
--,('DEU')
--,('MEM')
--, ('MLG')
--, ('DNF')
--, ('BEV')
--, ('KEV')

--select Abbr from @ChemList;

select --
--distinct
	 p.ID 
	, m.[SINFO-ID]
--	, p.Код_поставщика
--	, p.Код_поставки
	, ROUND( sum(p.Масса_пост),1) as Масса
	--, * 
from tblПоставки p
	inner join @ChemList cl on p.Код_поставщика = cl.Abbr
	inner join Materials m on m.MatName = p.ID
--where [Масса_пост]>=50000
--where ISNULL(Масса_пост,0)>0
group by p.ID 
	, m.[SINFO-ID] 
having sum(p.Масса_пост)>=50000
order by --p.Код_поставщика,
	 p.ID;