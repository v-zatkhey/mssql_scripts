-- select * from _NumbValue -- J - 3
-- exec getSpectrumBlockNumber 	@NumeratorID = 1, @Seria = 'R'  
-- update n set Value = 3 	from _NumbValue n where  n.Seria = 'J'

select *, n.Value - x.BlockNumber as [нумератор опережает на] 
	--update n set Value = x.BlockNumber
	from _NumbValue n
	full join (
				select Тип_спектра as SpectrumSeria, MAX(Номер_блока) BlockNumber
				from tblСпектр
				group by Тип_спектра
				) x on x.SpectrumSeria = n.Seria and n.NumeratorID = 1
	where ISNULL(n.Value,0) <> ISNULL(x.blockNumber,0)
	

select * 
from 	tblСпектр	 
where Тип_спектра in ( 'R')
	and Номер_блока >= 1575
order by Код desc
	

select * 
from 	tblСпектр	 
where Тип_спектра in ( 'G')
	and Номер_блока > 530
order by Код desc

select * 
from 	tblСпектр	 
where Тип_спектра in ( 'L')
	and Номер_блока > 530
order by Код



select * 
from 	tblСпектр	 
where Тип_спектра in ( 'S')
	and Номер_блока > 28580
order by Код


select * 
from 	tblСпектр	 
where Тип_спектра in ( 'F')
	and Номер_блока > 1015
order by Код


select * 
from 	tblСпектр	 
where Тип_спектра in ( 'U')
	and Номер_блока > 60
order by Код

select * 
from 	tblСпектр	 
where Тип_спектра in ( 'R')
	and Номер_блока > 1504
order by Код desc

select * 
from 	tblСпектр	 
where Тип_спектра in ( 'L')
	and Номер_блока > 500
order by Код

select * 
from 	tblСпектр	 
where Тип_спектра in ( 'G')
	and Номер_блока > 560
order by Код

--exec getSpectrumBlockNumber 1, 'Y'
/*
select top 1000 Тип_спектра as SpectrumSeria, Номер_блока BlockNumber, *
from tblСпектр
where Номер_блока = ''
*/
select top 1000 Тип_спектра as SpectrumSeria, Номер_блока BlockNumber, *
from tblСпектр
where Номер_блока = '28988'  -- 1321352
							-- 1321354
select top 1000 Тип_спектра as SpectrumSeria, Номер_блока BlockNumber, *
from tblСпектр	where Код in (1321352,1321354)	;					
							
select * 
from dbo.tblПоставки 
where  Код_поставщика='KEV' and Код_поставки = '0985' and ID = 'F6543-0674' 
	or Код_поставщика= 'VIG' and Код_поставки = '4178'and ID = 'F3409-1086';

/*
exec getSpectrumBlockNumber 1, 'Y';

select * from _NumbValue

update n set Value = x.BlockNumber
from _NumbValue n
full join (
			select Тип_спектра as SpectrumSeria, MAX(Номер_блока) BlockNumber
			from tblСпектр
			group by Тип_спектра
			) x on x.SpectrumSeria = n.Seria and n.NumeratorID = 1
where n.Seria = 'K' and ISNULL(n.Value,0) <> ISNULL(x.blockNumber,0);

*/
			select Тип_спектра as SpectrumSeria, MAX(Номер_блока) BlockNumber
			from tblСпектр
			group by Тип_спектра
			
select * 
from 	tblСпектр	 
where Тип_спектра = 'M'
	and Номер_блока > 28993
order by Код 	
	--Дата > '22/10/2018'	
select * 
from 	tblСпектр	 
where Тип_спектра = 'H'
	and Номер_блока > 4600
order by Код 

select * from 	tblСпектр where Примечание = 'BEM-1229'

select * 
from 	tblСпектр	 
where Тип_спектра = 'V'
	and Номер_блока > 1115
order by Код 


SELECT top 100 * FROM tblСпектр WHERE (ID = 'F0850-6795') ORDER BY Код DESC

