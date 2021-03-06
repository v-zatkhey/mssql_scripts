  
  /*************************/
select x.IDNUMBER, x.Заказ, x.Заказано, x.zp_chem , y.zp_synth, y.zp_chief
from (  
  select t.IDNUMBER , zp.Заказано, zp.Заказ,  sum( zp.ЗарпХимику)   as zp_chem
  from  dbo._tmp_ID_MaterialsCost t
	left join dbo.tblЗаказыПоставщикамСп1 zp on zp.ID = t.IDNUMBER
 --where 	t.IDNUMBER = 'F9995-2700'
  group by t.IDNUMBER, zp.Заказано, zp.Заказ
) x 
inner join (		
 select t.IDNUMBER, sum (z.Зарплата_синтетику) as zp_synth ,max( z.Зарплата_завлабу ) zp_chief
  from  dbo._tmp_ID_MaterialsCost t
	left join dbo.tblВыполненныеЗаказы z on z.ID  = t.IDNUMBER
 --where 	z.ID = 'F9995-2700'
  group by t.IDNUMBER 	
)y on y.IDNUMBER = x.IDNUMBER
  order by 1;
  
select t.IDNUMBER, min(z.Стоимость_реактива), AVG(z.Стоимость_реактива),  max(z.Стоимость_реактива), COUNT(*) as Cnt
from dbo._tmp_ID_MaterialsCost t left join (
	dbo.tblЗапросы_Ответы_Химиков_по_Веществам z	 
	inner join tblСписокЗапросов s on s.Код = z.Код_вещества  
	inner join 	dbo.tblЗапросы q on q.Код = s.Запрос_Код and q.[Ответ на запрос] = 1
	) on t.IDNUMBER = s.IDNUMBER
group by t.IDNUMBER	
having max(z.Стоимость_реактива) is not null;	
		

		
		
	