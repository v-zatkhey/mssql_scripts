use SKLAD30 ;
go

/* Улучшение #65 */
alter table dbo.__Выдачи 
	add	  BruttoMassBegin float null
		, BruttoMassEnd float null;
go

