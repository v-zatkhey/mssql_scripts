SELECT [MaterialChiralID]
      ,[MatID1]
      ,[MatID2]
      ,[Note]
  FROM [Chest35].[dbo].[MaterialChiral]
  where [MatID1] in (select MatID from Materials where MatName in ('F2167-9961','F2167-9998','F2167-9999'))
GO

-------------------------------------
insert into [MaterialChiral]([MatID1],[MatID2],[Note])
select x.MatID, y.MatID, 'script'
from      
  (select MatID from Materials where MatName in ('F2167-9961','F2167-9998','F2167-9999')) x cross join
  (select MatID from Materials where MatName in ('F2167-9961','F2167-9998','F2167-9999')) y
where not exists(select * from [MaterialChiral] where [MatID1] = x.MatID and MatID2 = y.MatID)
	and x.MatID != y.MatID ;
GO

