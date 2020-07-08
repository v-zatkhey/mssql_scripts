USE [Chest35]
--drop table [param_for_chest_buff]
GO

/****** Object:  Table [dbo].[param_for_chest]    Script Date: 03/30/2020 12:17:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[param_for_chest_buff](
	[idnumber] [varchar](10) not NULL,
	[param_smiles] [varchar](2000) NULL,
	[param_chemical_name] [varchar](2000) NULL,
	[param_acceptor] [int] NULL,
	[param_donor] [int] NULL,
	[param_clogp] [decimal](18, 5) NULL,
	[param_logbb] [decimal](18, 5) NULL,
	[param_mw] [decimal](18, 2) NULL,
	[param_tpsa] [decimal](18, 2) NULL,
	[param_fsp3] [decimal](18, 2) NULL,
	[param_logs] [decimal](18, 5) NULL,
	[param_rotbonds] [int] NULL,
	[param_rings] [int] NULL,
	[param_aromrings] [int] NULL,
	[param_hac] [int] NULL,
	[param_rating] [decimal](18, 2) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


