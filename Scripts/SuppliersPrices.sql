/****** Сценарий для команды SelectTopNRows среды SSMS  ******/
SELECT TOP 1000 [id]
      ,[mdlnumber]
      ,[sub_code]
      ,[supplier_name]
      ,[weight_val]
      ,[weight_type]
      ,[price]
      ,[currency]
      ,[purity]
  FROM [Chest35].[dbo].[Biovia_Prices]
  
  select distinct weight_val  
  FROM [Chest35].[dbo].[Biovia_Prices] where weight_type= 'G'
  go
  
  
  -- 1,5,10,25,50,100
  declare @mdl_number varchar(127) = 'MFCD00017295'
  select coalesce(z_1.[supplier_name], z_5.supplier_name, z_10.supplier_name, z_25.supplier_name, z_50.supplier_name, z_100.supplier_name) as  supplier_name
	, coalesce(z_1.sub_code , z_5.sub_code, z_10.sub_code, z_25.sub_code, z_50.sub_code, z_100.sub_code) as  sub_code
	, coalesce(z_1.mdlnumber , z_5.mdlnumber, z_10.mdlnumber, z_25.mdlnumber, z_50.mdlnumber, z_100.mdlnumber) as  mdlnumber
	, z_1.Price_1
	, z_1.Cur_1
	, z_1.Pur_1
	, z_5.Price_5
	, z_5.Cur_5
	, z_5.Pur_5
	, z_10.Cur_10
	, z_10.Price_10
	, z_10.Pur_10
	, z_25.Cur_25
	, z_25.Price_25
	, z_25.Pur_25
	, z_50.Price_50
	, z_50.Cur_50
	, z_50.Pur_50
	, z_100.Cur_100
	, z_100.Price_100
	, z_100.Pur_100
  from(
  SELECT [id]									--1
      ,[mdlnumber]
      ,[sub_code]
      ,[supplier_name]
      ,[price] as Price_1
      ,[currency] as Cur_1
      ,[purity] as Pur_1
  FROM [Chest35].[dbo].[Biovia_Prices]
  where weight_type= 'G' 
		and [weight_val] = 1
		and mdlnumber =  @mdl_number
  ) z_1 
  full join(											--5
  SELECT [id]
      ,[mdlnumber]
      ,[sub_code]
      ,[supplier_name]
      ,[price] as Price_5 
      ,[currency] as Cur_5
      ,[purity] as Pur_5
  FROM [Chest35].[dbo].[Biovia_Prices]
  where weight_type= 'G' 
		and [weight_val] = 5
		and mdlnumber =  @mdl_number
  )z_5 on z_5.supplier_name = z_1.supplier_name and z_5.mdlnumber = z_1.mdlnumber and z_5.sub_code =z_1.sub_code
  full join(											--10
  SELECT [id]
      ,[mdlnumber]
      ,[sub_code]
      ,[supplier_name]
      ,[price] as Price_10 
      ,[currency] as Cur_10
      ,[purity] as Pur_10
  FROM [Chest35].[dbo].[Biovia_Prices]
  where weight_type= 'G' 
		and [weight_val] = 10 
		and mdlnumber =  @mdl_number
  )z_10 on		z_10.supplier_name = coalesce(z_1.supplier_name,z_5.supplier_name) 
			and z_10.mdlnumber = coalesce(z_1.mdlnumber, z_5.mdlnumber)
			and z_10.sub_code = coalesce(z_1.sub_code, z_5.sub_code)
  full join(											--25
  SELECT [id]
      ,[mdlnumber]
      ,[sub_code]
      ,[supplier_name]
      ,[price] as Price_25 
      ,[currency] as Cur_25
      ,[purity] as Pur_25
  FROM [Chest35].[dbo].[Biovia_Prices]
  where weight_type= 'G' 
		and [weight_val] = 25 
		and mdlnumber =  @mdl_number
  )z_25 on		z_25.supplier_name = coalesce(z_1.supplier_name, z_5.supplier_name, z_10.supplier_name) 
			and z_25.mdlnumber = coalesce(z_1.mdlnumber, z_5.mdlnumber, z_10.mdlnumber)
			and z_25.sub_code = coalesce(z_1.sub_code, z_5.sub_code, z_10.sub_code)
  full join(											--50
  SELECT [id]
      ,[mdlnumber]
      ,[sub_code]
      ,[supplier_name]
      ,[price] as Price_50 
      ,[currency] as Cur_50
      ,[purity] as Pur_50
  FROM [Chest35].[dbo].[Biovia_Prices]
  where weight_type= 'G' 
		and [weight_val] = 50 
		and mdlnumber =  @mdl_number
  )z_50 on		z_50.supplier_name = coalesce(z_1.supplier_name, z_5.supplier_name, z_10.supplier_name, z_25.supplier_name) 
			and z_50.mdlnumber = coalesce(z_1.mdlnumber, z_5.mdlnumber, z_10.mdlnumber, z_25.mdlnumber)
			and z_50.sub_code = coalesce(z_1.sub_code, z_5.sub_code, z_10.sub_code, z_25.sub_code)
  full join(											--100
  SELECT [id]
      ,[mdlnumber]
      ,[sub_code]
      ,[supplier_name]
      ,[price] as Price_100 
      ,[currency] as Cur_100
      ,[purity] as Pur_100
  FROM [Chest35].[dbo].[Biovia_Prices]
  where weight_type= 'G' 
		and [weight_val] = 100 
		and mdlnumber =  @mdl_number
  )z_100 on	z_100.supplier_name = coalesce(z_1.supplier_name, z_5.supplier_name, z_10.supplier_name, z_25.supplier_name, z_50.supplier_name)
			and z_100.mdlnumber = coalesce(z_1.mdlnumber, z_5.mdlnumber, z_10.mdlnumber, z_25.mdlnumber, z_50.mdlnumber)
			and z_100.sub_code = coalesce(z_1.sub_code, z_5.sub_code, z_10.sub_code, z_25.sub_code, z_50.sub_code)									
 go
 
 --trusted
  declare @mdl_number varchar(127) =  'MFCD00172112'
  select coalesce(z_1.[supplier_name], z_5.supplier_name, z_10.supplier_name, z_25.supplier_name, z_50.supplier_name, z_100.supplier_name) as  supplier_name
	, coalesce(z_1.sub_code , z_5.sub_code, z_10.sub_code, z_25.sub_code, z_50.sub_code, z_100.sub_code) as  sub_code
	, coalesce(z_1.mdlnumber , z_5.mdlnumber, z_10.mdlnumber, z_25.mdlnumber, z_50.mdlnumber, z_100.mdlnumber) as  mdlnumber
	, z_1.Price_1
	, z_1.Cur_1
	, z_1.Pur_1
	, z_5.Price_5
	, z_5.Cur_5
	, z_5.Pur_5
	, z_10.Cur_10
	, z_10.Price_10
	, z_10.Pur_10
	, z_25.Cur_25
	, z_25.Price_25
	, z_25.Pur_25
	, z_50.Price_50
	, z_50.Cur_50
	, z_50.Pur_50
	, z_100.Cur_100
	, z_100.Price_100
	, z_100.Pur_100
  from(
  SELECT [id]									--1
      ,[mdlnumber]
      ,[sub_code]
      ,[supplier_name]
      ,[price] as Price_1
      ,[currency] as Cur_1
      ,[purity] as Pur_1
  FROM [Chest35].[dbo].[Biovia_Prices_Trusted_Suppliers]
  where weight_type= 'G' 
		and [weight_val] = 1
		and mdlnumber =  @mdl_number
  ) z_1 
  full join(											--5
  SELECT [id]
      ,[mdlnumber]
      ,[sub_code]
      ,[supplier_name]
      ,[price] as Price_5 
      ,[currency] as Cur_5
      ,[purity] as Pur_5
  FROM [Chest35].[dbo].[Biovia_Prices_Trusted_Suppliers]
  where weight_type= 'G' 
		and [weight_val] = 5
		and mdlnumber =  @mdl_number
  )z_5 on z_5.supplier_name = z_1.supplier_name and z_5.mdlnumber = z_1.mdlnumber and z_5.sub_code =z_1.sub_code
  full join(											--10
  SELECT [id]
      ,[mdlnumber]
      ,[sub_code]
      ,[supplier_name]
      ,[price] as Price_10 
      ,[currency] as Cur_10
      ,[purity] as Pur_10
  FROM [Chest35].[dbo].[Biovia_Prices_Trusted_Suppliers]
  where weight_type= 'G' 
		and [weight_val] = 10 
		and mdlnumber =  @mdl_number
  )z_10 on		z_10.supplier_name = coalesce(z_1.supplier_name,z_5.supplier_name) 
			and z_10.mdlnumber = coalesce(z_1.mdlnumber, z_5.mdlnumber)
			and z_10.sub_code = coalesce(z_1.sub_code, z_5.sub_code)
  full join(											--25
  SELECT [id]
      ,[mdlnumber]
      ,[sub_code]
      ,[supplier_name]
      ,[price] as Price_25 
      ,[currency] as Cur_25
      ,[purity] as Pur_25
  FROM [Chest35].[dbo].[Biovia_Prices_Trusted_Suppliers]
  where weight_type= 'G' 
		and [weight_val] = 25 
		and mdlnumber =  @mdl_number
  )z_25 on		z_25.supplier_name = coalesce(z_1.supplier_name, z_5.supplier_name, z_10.supplier_name) 
			and z_25.mdlnumber = coalesce(z_1.mdlnumber, z_5.mdlnumber, z_10.mdlnumber)
			and z_25.sub_code = coalesce(z_1.sub_code, z_5.sub_code, z_10.sub_code)
  full join(											--50
  SELECT [id]
      ,[mdlnumber]
      ,[sub_code]
      ,[supplier_name]
      ,[price] as Price_50 
      ,[currency] as Cur_50
      ,[purity] as Pur_50
  FROM [Chest35].[dbo].[Biovia_Prices_Trusted_Suppliers]
  where weight_type= 'G' 
		and [weight_val] = 50 
		and mdlnumber =  @mdl_number
  )z_50 on		z_50.supplier_name = coalesce(z_1.supplier_name, z_5.supplier_name, z_10.supplier_name, z_25.supplier_name) 
			and z_50.mdlnumber = coalesce(z_1.mdlnumber, z_5.mdlnumber, z_10.mdlnumber, z_25.mdlnumber)
			and z_50.sub_code = coalesce(z_1.sub_code, z_5.sub_code, z_10.sub_code, z_25.sub_code)
  full join(											--100
  SELECT [id]
      ,[mdlnumber]
      ,[sub_code]
      ,[supplier_name]
      ,[price] as Price_100 
      ,[currency] as Cur_100
      ,[purity] as Pur_100
  FROM [Chest35].[dbo].[Biovia_Prices_Trusted_Suppliers]
  where weight_type= 'G' 
		and [weight_val] = 100 
		and mdlnumber =  @mdl_number
  )z_100 on	z_100.supplier_name = coalesce(z_1.supplier_name, z_5.supplier_name, z_10.supplier_name, z_25.supplier_name, z_50.supplier_name)
			and z_100.mdlnumber = coalesce(z_1.mdlnumber, z_5.mdlnumber, z_10.mdlnumber, z_25.mdlnumber, z_50.mdlnumber)
			and z_100.sub_code = coalesce(z_1.sub_code, z_5.sub_code, z_10.sub_code, z_25.sub_code, z_50.sub_code)									
 go
 
 
 use Chest35;
 go
 
 --  declare @mdl_number varchar(127) = 'MFCD00017295'

 create procedure GetBioviaPrices(@mdl_number varchar(127))
 as
 begin
	  select coalesce(z_1.[supplier_name], z_5.supplier_name, z_10.supplier_name, z_25.supplier_name, z_50.supplier_name, z_100.supplier_name) as  supplier_name
		, coalesce(z_1.sub_code , z_5.sub_code, z_10.sub_code, z_25.sub_code, z_50.sub_code, z_100.sub_code) as  sub_code
		, coalesce(z_1.mdlnumber , z_5.mdlnumber, z_10.mdlnumber, z_25.mdlnumber, z_50.mdlnumber, z_100.mdlnumber) as  mdlnumber
		, z_1.Price_1
		, z_1.Cur_1
		, z_1.Pur_1
		, z_5.Price_5
		, z_5.Cur_5
		, z_5.Pur_5
		, z_10.Cur_10
		, z_10.Price_10
		, z_10.Pur_10
		, z_25.Cur_25
		, z_25.Price_25
		, z_25.Pur_25
		, z_50.Price_50
		, z_50.Cur_50
		, z_50.Pur_50
		, z_100.Cur_100
		, z_100.Price_100
		, z_100.Pur_100
	  from(
	  SELECT [id]									--1
		  ,[mdlnumber]
		  ,[sub_code]
		  ,[supplier_name]
		  ,[price] as Price_1
		  ,[currency] as Cur_1
		  ,[purity] as Pur_1
	  FROM [Chest35].[dbo].[Biovia_Prices]
	  where weight_type= 'G' 
			and [weight_val] = 1
			and mdlnumber =  @mdl_number
	  ) z_1 
	  full join(											--5
	  SELECT [id]
		  ,[mdlnumber]
		  ,[sub_code]
		  ,[supplier_name]
		  ,[price] as Price_5 
		  ,[currency] as Cur_5
		  ,[purity] as Pur_5
	  FROM [Chest35].[dbo].[Biovia_Prices]
	  where weight_type= 'G' 
			and [weight_val] = 5
			and mdlnumber =  @mdl_number
	  )z_5 on z_5.supplier_name = z_1.supplier_name and z_5.mdlnumber = z_1.mdlnumber and z_5.sub_code =z_1.sub_code
	  full join(											--10
	  SELECT [id]
		  ,[mdlnumber]
		  ,[sub_code]
		  ,[supplier_name]
		  ,[price] as Price_10 
		  ,[currency] as Cur_10
		  ,[purity] as Pur_10
	  FROM [Chest35].[dbo].[Biovia_Prices]
	  where weight_type= 'G' 
			and [weight_val] = 10 
			and mdlnumber =  @mdl_number
	  )z_10 on		z_10.supplier_name = coalesce(z_1.supplier_name,z_5.supplier_name) 
				and z_10.mdlnumber = coalesce(z_1.mdlnumber, z_5.mdlnumber)
				and z_10.sub_code = coalesce(z_1.sub_code, z_5.sub_code)
	  full join(											--25
	  SELECT [id]
		  ,[mdlnumber]
		  ,[sub_code]
		  ,[supplier_name]
		  ,[price] as Price_25 
		  ,[currency] as Cur_25
		  ,[purity] as Pur_25
	  FROM [Chest35].[dbo].[Biovia_Prices]
	  where weight_type= 'G' 
			and [weight_val] = 25 
			and mdlnumber =  @mdl_number
	  )z_25 on		z_25.supplier_name = coalesce(z_1.supplier_name, z_5.supplier_name, z_10.supplier_name) 
				and z_25.mdlnumber = coalesce(z_1.mdlnumber, z_5.mdlnumber, z_10.mdlnumber)
				and z_25.sub_code = coalesce(z_1.sub_code, z_5.sub_code, z_10.sub_code)
	  full join(											--50
	  SELECT [id]
		  ,[mdlnumber]
		  ,[sub_code]
		  ,[supplier_name]
		  ,[price] as Price_50 
		  ,[currency] as Cur_50
		  ,[purity] as Pur_50
	  FROM [Chest35].[dbo].[Biovia_Prices]
	  where weight_type= 'G' 
			and [weight_val] = 50 
			and mdlnumber =  @mdl_number
	  )z_50 on		z_50.supplier_name = coalesce(z_1.supplier_name, z_5.supplier_name, z_10.supplier_name, z_25.supplier_name) 
				and z_50.mdlnumber = coalesce(z_1.mdlnumber, z_5.mdlnumber, z_10.mdlnumber, z_25.mdlnumber)
				and z_50.sub_code = coalesce(z_1.sub_code, z_5.sub_code, z_10.sub_code, z_25.sub_code)
	  full join(											--100
	  SELECT [id]
		  ,[mdlnumber]
		  ,[sub_code]
		  ,[supplier_name]
		  ,[price] as Price_100 
		  ,[currency] as Cur_100
		  ,[purity] as Pur_100
	  FROM [Chest35].[dbo].[Biovia_Prices]
	  where weight_type= 'G' 
			and [weight_val] = 100 
			and mdlnumber =  @mdl_number
	  )z_100 on	z_100.supplier_name = coalesce(z_1.supplier_name, z_5.supplier_name, z_10.supplier_name, z_25.supplier_name, z_50.supplier_name)
				and z_100.mdlnumber = coalesce(z_1.mdlnumber, z_5.mdlnumber, z_10.mdlnumber, z_25.mdlnumber, z_50.mdlnumber)
				and z_100.sub_code = coalesce(z_1.sub_code, z_5.sub_code, z_10.sub_code, z_25.sub_code, z_50.sub_code)	;								
 end
 go
 
 grant execute on GetBioviaPrices to  Chest_Admins, Chest_Rukovodstvo, Chest_public
 go
 
 exec GetBioviaPrices 'MFCD00017295';
 go
 
 SELECT parameter_val as [version] FROM Biovia_Chemical_Parameters where parameter_name = 'BIOVIA_VER'
 
GO

execute as login = 'IFLAB\a.yemets'
select system_user
exec GetBioviaPrices 'MFCD00017295';
revert