/*
Просьба вытянуть инфу по таким параметрам:
Первый список:
1)	Поставки МЕМ
2)	Вид: OIL
3)	Период: 1,06,2019-30,06,2019
4)	Решение: Склад
5)	Есть блок S

Второй список:
6)	Поставки KIS
7)	Вид: OIL
8)	Период: 1,06,2019-30,06,2019
9)	Решение: Склад
10)	Есть блок S

Третий список:
11)	Поставки LSA
12)	Вид: OIL
13)	Период: 1,06,2019-30,06,2019
14)	Решение: Склад
15)	Есть блок S
*/

use Chest35;
go

select distinct ID
from tblПоставки p 
where [Склад] = 1
		and Дата_склад between '20190601' and '20190630'	
		and exists(select * from tblСпектр s where s.Код_tblПоставки_rev = p.Код and s.Тип_спектра = 'S' and s.Результат = 'OK')
		and Агрегатное_состояние = 'o'	
		and p.Код_поставщика = 'MEM';
select distinct ID
from tblПоставки p 
where [Склад] = 1
		and Дата_склад between '20190601' and '20190630'	
		and exists(select * from tblСпектр s where s.Код_tblПоставки_rev = p.Код and s.Тип_спектра = 'S' and s.Результат = 'OK')
		and Агрегатное_состояние = 'o'	
		and p.Код_поставщика = 'KIS';
select distinct ID
from tblПоставки p 
where [Склад] = 1
		and Дата_склад between '20190601' and '20190630'	
		and exists(select * from tblСпектр s where s.Код_tblПоставки_rev = p.Код and s.Тип_спектра = 'S' and s.Результат = 'OK')
		and Агрегатное_состояние = 'o'	
		and p.Код_поставщика = 'LSA';
				
				