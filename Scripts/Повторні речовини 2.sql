SELECT [���]
      ,[ID]
      ,[IDdupl]
      ,[Ves]
      ,[Flag_work]
  FROM [Chest35].[dbo].[tbl�������]
GO


SELECT min([���]) over(partition by [Ves])
	, *
      ,[Ves]
  FROM [Chest35].[dbo].[tbl�������]
GO


declare @double as table(ID nvarchar(10));
insert into @double values('F2197-4556'),('F2167-4214')

begin tran

	--insert into dbo.tbl�������(ID, IDdupl, Flag_work)
	select d1.ID, d2.ID, 1
	from @double d1 cross join @double d2
	where d1.ID != d2.ID;

	/*
	update t
	set t.Ves = (	select min([���]) 
					from  dbo.tbl������� t
						inner join @double d on d.ID = t.ID)
	*/	
	select t.*				
	from  dbo.tbl������� t
		inner join @double d on d.ID = t.ID;


	select t.*
	from  dbo.tbl������� t
		inner join @double d on d.ID = t.ID

commit	