select COUNT(*) 
from sys.objects 
where [type] = 'U';

select 'drop table [' + name + '];', * 
from sys.objects 
where [type] = 'U'
	and name like 'tmp%';
	
/*
drop table [tmp_ESA_Распр_5_old];
drop table [tmp_ESA_Распр_5_old2];
drop table [tmp_ESA_Распр_5];
drop table [tmp_2007_03_1];
drop table [tmp_2007_03_2_(with_Block)];
drop table [tmp_2007_03_3_(after_2003)];
drop table [tmp_2007_03_3_(before_2003)];
drop table [tmp_2007_01_12_2];
drop table [tmp_2007_01_12_2_(with_Block)];
drop table [tmp_ttt_tblВзвешивание];
*/	

select 'drop table [' + name + '];', * 
from sys.objects 
where [type] = 'U'
	and name like '%old21';

/*
drop table [Materials_old21];
drop table [MaterialSalts_old21];
drop table [Documents_old21];
drop table [tblЗаказыПоставщикамСп1_old21];
drop table [ISISHOST_IFLAB_old21];
drop table [tblЗаказчики_full_old21];
drop table [tblСпектр_old21];
drop table [tblПользователи_old21];
drop table [tbl_emolecules_info_old21];
drop table [tbl_Reactive_compounds_old21];
drop table [tblИстория_эксклюзивности_old21];
drop table [tblБазовыеСписки_old21];
drop table [tblОтправкаЗаказов_old21];
drop table [tbl_Особые_Заказы_old21];
drop table [tblЗаказы_old21];
drop table [tblВесовщики_old21];
drop table [История_ввода_old21];
drop table [tblПоставки_old21];
drop table [Тара_Приход_old21];
drop table [tblЗаказыПоставщикам_old21];
drop table [tblПоставщики_full_old21];
drop table [tblВзвешивание_old21];
drop table [Тара_Расход_old21];
drop table [Salts_old21];
drop table [tbl_sigma_info_old21];
drop table [Customers_old21];
drop table [tblВыполненныеЗаказы_old21];
drop table [MaterialInfo_old21];
drop table [MaterialChiral_old21];

drop table [Materials_old21];
drop table [Documents_old21];
drop table [Тара_Приход_old21];
drop table [Salts_old21];
drop table [Customers_old21];
*/	
	
select COUNT(*) 
from Materials
where IUPAC_Name like '%?%'
	