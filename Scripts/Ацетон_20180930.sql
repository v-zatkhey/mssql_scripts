use SKLAD30;
go
declare @AcetonCodeID int, @material_id int, @store_id int
select @store_id = 8;
select @AcetonCodeID = Код_ID from __Вещества where CAS = '67-64-1' and Код_с  = @store_id;
select @material_id = @AcetonCodeID;

	select ps.*
		, ps.Дата
		, ps.Код_ID
		, p.Код_ID  as Код_ID__Приемка
		, p.Size * p.Qty as Volume
		, p.Size * p.Qty as VolIn
		, p.*
	from __Приемка p 
		left join __Поставки ps on ps.Код_ID = p.Код_ID_поставки
	where p.Код_ID_вещества = @material_id
		and ps.Дата > '20180901'

	-- расход	
	SELECT  v.Дата  
		, v.Код_ID
		, v.Код_заказчика as ClientCode
		, v.Код_заказа as OrderCode
		, v.SInfoNUMBER
		, pt.[Полное название потребителя] as CustName
		, v.*
	FROM       
	  [__Приемка] p
	  LEFT OUTER JOIN [__Выдачи] v  ON p.[Код_ID] = v.[Код_ID_приемки]
	  LEFT OUTER JOIN dbo.[__Потребители] pt ON (v.[Код_ID_потребителя] = pt.[Код_ID])
	where Код_ID_вещества = @material_id 
		and p.Код_с = @store_id
		and p.[Код_ID]= 40130
		and v.Дата >= '20181001'
		
	SELECT SUM( v.Выдано )
	FROM       
	  [__Приемка] p
	  inner JOIN [__Выдачи] v  ON p.[Код_ID] = v.[Код_ID_приемки]
	where p.Код_ID_вещества = @material_id 
		and p.Код_с = @store_id
		--and p.[Код_ID]= 40130
		--and v.Дата between '20181001' and '20181005'
		and v.Код_ID in (149593,149683,149686,149773,149778)
		
	SELECT p.Код_ID 
		, v.Дата  
		, v.Код_ID
		, v.Код_заказчика as ClientCode
		, v.Код_заказа as OrderCode
		, v.SInfoNUMBER
		, pt.[Полное название потребителя] as CustName
		, v.*
	FROM       
	  [__Приемка] p
	  LEFT OUTER JOIN [__Выдачи] v  ON p.[Код_ID] = v.[Код_ID_приемки]
	  LEFT OUTER JOIN dbo.[__Потребители] pt ON (v.[Код_ID_потребителя] = pt.[Код_ID])
	where Код_ID_вещества = @material_id 
		and p.Код_с = @store_id
		and p.[Код_ID]= 40544
		

--select @AcetonCodeID;
go

select * from dbo.Остатки_по_Приемкам p where p.Код_ID in (40130,40544)
begin tran

	alter table [__Выдачи] disable trigger TR_UPDATE_Sklad30___Выдачи;
	update 	v set [Код_ID_приемки] = 40544
		FROM  [__Выдачи] v  
		where  v.[Код_ID_приемки] = 40130
			and v.Код_ID in (149593,149683,149686,149773,149778)
	alter table [__Выдачи] enable trigger TR_UPDATE_Sklad30___Выдачи;
commit -- rollback
select * from dbo.Остатки_по_Приемкам p where p.Код_ID in (40130,40544)
go
