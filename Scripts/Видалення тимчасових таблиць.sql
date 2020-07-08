
select name, crdate, 'drop table '+ name + ';' 
from sysobjects 
where type = 'U' and name like '_tmp%' and crdate < '20200101'
order by crdate;

drop table [_tmp_Соответствие номеров];
drop table _tmp_Price_coeff;
drop table _tmp_ID_MaterialsCost;
drop table _tmp_Aldehydes;
drop table _tmp_Solubility_Km;
drop table _tmp_Undissolved_10mM_DMSO;
drop table [_tmp_НАРК];
drop table [_tmp_ДСЕК];