use testParser;
go

SELECT [line_n]
      ,[mireg]
      ,[mdlnumber]
      ,[supplier_code]
      ,[inner_name]
      ,[weight]
      ,[unit]
      ,[price]
      ,[currency]
      ,[quality]
  FROM [TestParser].[dbo].[price_acd201909-066]
  /*where quality is not null
	and quality<>'POA'
	and quality<>''
	and [supplier_code] = 'ENAMINE-EUR'*/
  order by line_n
GO

select distinct [weight]FROM [TestParser].[dbo].[price_acd201909-066]

SELECT [mdlnumber]
  FROM [TestParser].[dbo].[price_acd201909-066]
  where not [mdlnumber] like 'MFCD[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' 
  
select count(*)
from   dbo.[sup_acd201909-066]

select s.*, p.*
from   dbo.[sup_acd201909-066] s
	inner join [price_acd201909-066] p  on p.line_n = s.line_n
where p.mdlnumber = 'MFCD31732518'	
order by s.line_n	

select mdlnumber, supplier_code
from [price_acd201909-066]
