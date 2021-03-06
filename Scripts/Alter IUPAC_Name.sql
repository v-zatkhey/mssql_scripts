use Chest35;
go

-- alter table dbo.Materials alter column IUPAC_Name nvarchar(4000);
go 

--update Materials set IUPAC_Name = N'9-butyl-10-[(1E)-2-[(3E)-3-{2-[(10E)-9-butyl-4-methyl-3-oxa-9-azatetracyclo[6.6.1.0²,⁶.0¹¹,¹⁵]pentadeca-1,6,8(15),11,13-pentaen-10-ylidene]ethylidene}-2-(phenylsulfanyl)cyclohex-1-en-1-yl]ethenyl]-4-methyl-3-oxa-9-azatetracyclo[6.6.1.0²,⁶.0¹¹,¹⁵]pentadeca-1(15),2(6),7,9,11,13-hexaen-9-ium tetrafluoroborate' 
--where MatName = 'F9995-4271';

select IUPAC_Name --, * 
from Materials where MatName = 'F9995-4271';

select IUPAC_Name --, * 
from Materials where MatName in( 'F9995-4271', 'F9995-0021');

select IUPAC_Name , * --  187431 rows
from Materials 
where IUPAC_Name like '%?%';