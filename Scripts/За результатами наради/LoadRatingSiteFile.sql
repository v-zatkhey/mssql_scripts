select ID, [Коэффициент] from tbl_Повышенная_цена;
select ID 
from tblСписокЗаказов
group by ID;
go

/**************************************/
USE [Chest35]
GO

/****** Object:  Table [dbo].[_tmp_param_for_chest]    Script Date: 02/12/2020 16:34:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO
-- drop table [_tmp_import_param_for_chest]
CREATE TABLE [dbo].[_tmp_import_param_for_chest](
	[idnumber] [varchar](10) NULL,
	[param_smiles] [nvarchar](2000) NULL,
	[param_chemical_name] [nvarchar](2000) NULL,
	[param_acceptor] [varchar](50) NULL,
	[param_donor] [varchar](50) NULL,
	[param_clogp] [varchar](50) NULL,
	[param_logbb] [varchar](50) NULL,
	[param_mw] [varchar](50) NULL,
	[param_tpsa] [varchar](50) NULL,
	[param_fsp3] [varchar](50) NULL,
	[param_logs] [varchar](50) NULL,
	[param_rotbonds] [varchar](50) NULL,
	[param_hac] [varchar](50) NULL,
	[param_rating] [varchar](50) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



BULK INSERT 
   dbo.[_tmp_import_param_for_chest]
      FROM 'C:\Users\v.zatkhey\Documents\SQL Server Management Studio\Projects\Scripts\За результатами наради\DataFile\RATING_SITE_0120.tsv' 
      WITH 
        ( 
      DATAFILETYPE =  'char'  
    ,  FORMATFILE = 'C:\Users\v.zatkhey\Documents\SQL Server Management Studio\Projects\Scripts\За результатами наради\DataFile\param_chest.fmt'  
        ) ;

SELECT [idnumber]
      ,[param_smiles]
      ,[param_chemical_name]
      ,[param_acceptor]
      ,[param_donor]
      ,[param_clogp]
      ,[param_logbb]
      ,[param_mw]
      ,[param_tpsa]
      ,[param_fsp3]
      ,[param_logs]
      ,[param_rotbonds]
      ,[param_hac]
      ,[param_rating]
  FROM [Chest35].[dbo].[_tmp_import_param_for_chest]
GO

