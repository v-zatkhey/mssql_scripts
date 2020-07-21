use Chest35;
go

select round(cLogP, 1) as rnd_cLogP, COUNT(*) as cnt 
from MaterialCalculatedParams
group by round(cLogP, 1)
order by round(cLogP, 1) ;

select round(cLogP, 0) as rnd_cLogP, COUNT(*) as cnt 
from MaterialCalculatedParams
where round(cLogP, 0) between -2 and 6
group by round(cLogP, 0)
order by round(cLogP, 0) ;

select  m.MatName as ID, mcp.cLogP
from MaterialCalculatedParams mcp
	inner join Materials m on m.MatID = mcp.MatID
where mcp.cLogP >= 20 --or mcp.cLogP = 0
order by mcp.cLogP
;