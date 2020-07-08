use SKLAD30;

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		V.Zatkhey
-- Create date: 02.11.2018
-- Description:	если выдача снижает остаток ниже порогового, создать заявку (если её ещё нет) на закупку реактива
-- =============================================
--CREATE TRIGGER TR_LowerLimit_Sklad30__Выдачи 
alter TRIGGER TR_LowerLimit_Sklad30__Выдачи 
   ON  [__Выдачи] 
   AFTER INSERT,UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

--print 'TR_LowerLimit. I"m here!';

if exists(	select * 
			from inserted i
				inner join __Приемка p on p.Код_ID = i.Код_ID_приемки 
				inner join LowerLimit l on l.StoreID = p.Код_с and  l.SubstanceID = p.Код_ID_вещества
		  )
	begin
	
--	print 'TR_LowerLimit. Go!';

	if exists(	
				select l.ID
				from dbo.LowerLimit l 
					left join
					( select pr.Код_с as StoreID, p.[Код_ID_вещества] as SubstanceID
						  , sum(p.[Остаток_0]) as Qnt
					   from [Остатки_по_Приемкам] p
						inner join __Приемка pr on pr.Код_ID = p.Код_ID
					  where [Остаток_0]<>0
					  group by p.[Код_ID_вещества], pr.Код_с)x on x.SubstanceID = l.SubstanceID and l.StoreID = x.StoreID
				where l.LimitQnt > x.Qnt
			 )	
		begin
		
--		print 'TR_LowerLimit. Insert!';
		--insert into
		INSERT INTO [__Заявки] ([Код_пользователя], [Код_ID_Вещества], [CAS2], [ФИО]
							  , [Кол-во], [для SKB], [Ед_изм]
							  , [Примечание], [Session_ID], [Код_с], [для_Заказчика]
							  , [Условия_хранения]) 
		select c.Код_пользователя, p.Код_ID_вещества, null, pl.Название as [ФИО]
			, 0, l.OrderQnt, p.UM 
			, 'заявка сформирована автоматически', v.Session_ID, v.Код_с, '00000'
			, s.Условия_хранения
		from  inserted v
			inner join __Приемка p on p.Код_ID = v.Код_ID_приемки 
			inner join LowerLimit l on l.StoreID = v.Код_с and l.SubstanceID = p.Код_ID_вещества
			inner join __Вещества s on s.Код_ID = p.Код_ID_вещества
			inner join Сессии c on c.Код = v.Session_ID
			inner join Пользователи pl on pl.Код = c.Код_пользователя
			left join
				( select pr.Код_с as StoreID, p.[Код_ID_вещества] as SubstanceID, sum(p.[Остаток_0]) as Qnt
				  from [Остатки_по_Приемкам] p
					inner join __Приемка pr on pr.Код_ID = p.Код_ID
				  where [Остаток_0]<>0
				  group by p.[Код_ID_вещества], pr.Код_с)x on x.SubstanceID = l.SubstanceID and l.StoreID = x.StoreID
		where l.LimitQnt > isnull(x.Qnt,0)
			and not exists(	select * from [__Заявки] z 
							where z.Код_с = v.Код_с 
									and z.Код_ID_Вещества = p.Код_ID_вещества
									and z.Статус < 50 -- "приехало" - значит реактив уже на складе учтён и надо заказывать 
							)
		end
	end
	

END
GO
