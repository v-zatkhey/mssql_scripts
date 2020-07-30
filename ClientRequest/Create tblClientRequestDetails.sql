USE [Chest35]
GO

/****** Object:  Table [dbo].[tblClientRequestDetails]    Script Date: 07/24/2020 17:51:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tblClientRequestDetails](
	[ID] [bigint] NOT NULL,
	[RequestID] [bigint] NULL,
	[IDNumber] [varchar](10) NULL,
	[CAS] [varchar](15) NULL,
	[CustMass] [decimal](18, 3) NULL,
	[CustPrice] [decimal](18, 2) NULL,
	[PurityDemand] [varchar](10) NULL,
 CONSTRAINT [PK_tblClientRequestDetails] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[tblClientRequestDetails]  WITH CHECK ADD  CONSTRAINT [FK_tblClientRequestDetails_tblClientRequests] FOREIGN KEY([RequestID])
REFERENCES [dbo].[tblClientRequests] ([ID])
GO

ALTER TABLE [dbo].[tblClientRequestDetails] CHECK CONSTRAINT [FK_tblClientRequestDetails_tblClientRequests]
GO


