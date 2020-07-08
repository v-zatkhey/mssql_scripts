select * from Materials
where MatName in ('F6575-6178' , 'F6579-7599')


select * from dbo.MaterialInfo 
where MatID in 
	(
	select MatID 
	from Materials
	where MatName in ('F6575-6178' , 'F6579-7599')
	)

begin tran	
	update dbo.MaterialInfo 
	set DateFailure =  CAST( GETDATE() as DATe)
	where MatID in 
		(
		select MatID 
		from Materials
		where MatName in ('F6575-6178' , 'F6579-7599')
			--and DateFailure is null
		)
commit

/********** за переліком ***********/
SELECT	m.MatName
FROM OPENROWSET(
		BULK       N'M:\Private_sh\Zatkhey Volodymyr\SIM-NOT.txt',
		FORMATFILE=N'M:\Private_sh\Zatkhey Volodymyr\DataParametersForRating\ID_list.xml', 
		FIRSTROW = 1 
			   ) AS c
	inner join Materials m on m.MatName = c.idnumber collate SQL_Ukrainian_CP1251_CI_AS
	
select * 
from dbo.MaterialInfo 
where MatID in 
	(
	SELECT	m.MatID
	FROM OPENROWSET(
			BULK       N'M:\Private_sh\Zatkhey Volodymyr\SIM-NOT.txt',
			FORMATFILE=N'M:\Private_sh\Zatkhey Volodymyr\DataParametersForRating\ID_list.xml', 
			FIRSTROW = 1 
				   ) AS c
		inner join Materials m on m.MatName = c.idnumber collate SQL_Ukrainian_CP1251_CI_AS
	)
	and DateFailure is null;

begin tran	
	update dbo.MaterialInfo 
	set DateFailure =  CAST( GETDATE() as DATe)
	where MatID in 
	(
	SELECT	m.MatID
	FROM OPENROWSET(
			BULK       N'M:\Private_sh\Zatkhey Volodymyr\SIM-NOT.txt',
			FORMATFILE=N'M:\Private_sh\Zatkhey Volodymyr\DataParametersForRating\ID_list.xml', 
			FIRSTROW = 1 
				   ) AS c
		inner join Materials m on m.MatName = c.idnumber collate SQL_Ukrainian_CP1251_CI_AS
	)
	and DateFailure is null;
commit
