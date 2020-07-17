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

select --p.Код_поставщика,
distinct
	 p.ID 
	, m.[SINFO-ID]
	--, p.Код_поставки
	--, p.Масса_пост
	--, * 
from tblПоставки p
	inner join @ChemList cl on p.Код_поставщика = cl.Abbr
	inner join Materials m on m.MatName = p.ID
where [Масса_пост]>=50000
order by --p.Код_поставщика,
	 p.ID;