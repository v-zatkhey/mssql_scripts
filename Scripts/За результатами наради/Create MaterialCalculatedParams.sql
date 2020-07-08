USE [Chest35]
GO

/****** Object:  Table [dbo].[MaterialCalculatedParams]    Script Date: 01/21/2020 09:30:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

--drop table [dbo].[MaterialCalculatedParams]
go
CREATE TABLE [dbo].[MaterialCalculatedParams](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MatID] [int] NOT NULL,
	[Smiles] [varchar](2000) NULL,
	[ChemicalName] [nvarchar](2000) NULL,
	[MW] [numeric](18, 2) NULL,
	[Acceptor] [int] NULL,
	[Donor] [int] NULL,
	[cLogP] [numeric](18, 5) NULL,
	[RotBond] [int] NULL,
	[TPSA] [numeric](18, 2) NULL,
	[Fsp3] [numeric](18, 2) NULL,
	--[VendorCnt] [int] NULL,
	[Yr] [int] NULL,
	[Ring] [int] NULL,
	[AromRing] [int] NULL,
	--[Benzene] [int] NULL,
	--[Amide] [int] NULL,
	[LogBB] [numeric](18, 5) NULL,
	[cLogS] [numeric](18, 5) NULL,
	[HAC] [int] NULL,
	[Rate] [numeric](18, 2) NULL,
 CONSTRAINT [PK_MaterialCalculatedParams] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[MaterialCalculatedParams]  WITH CHECK ADD  CONSTRAINT [FK_MaterialCalculatedParams_Materials] FOREIGN KEY([MatID])
REFERENCES [dbo].[Materials] ([MatID])
GO

ALTER TABLE [dbo].[MaterialCalculatedParams] CHECK CONSTRAINT [FK_MaterialCalculatedParams_Materials]
GO


