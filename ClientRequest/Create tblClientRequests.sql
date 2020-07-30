USE [Chest35]
GO

/****** Object:  Table [dbo].[tblClientRequests]    Script Date: 07/24/2020 17:50:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblClientRequests](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[ClientID] [int] NOT NULL,
	[Number] [int] NULL,
	[AddDate] [datetime] NOT NULL,
	[MsgText] [text] NULL,
	[AddEmployee] [int] NOT NULL,
	[AnswerDate] [datetime] NULL,
	[AnswerText] [text] NULL,
	[AnswerEmployee] [int] NULL,
	[HasAnswer] [bit] NOT NULL,
	[QueryID] [int] NULL,
	[OrderID] [int] NULL,
 CONSTRAINT [PK_tblClientRequests] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[tblClientRequests]  WITH CHECK ADD  CONSTRAINT [FK_tblClientRequests_Customers] FOREIGN KEY([ClientID])
REFERENCES [dbo].[Customers] ([CustID])
GO

ALTER TABLE [dbo].[tblClientRequests] CHECK CONSTRAINT [FK_tblClientRequests_Customers]
GO

ALTER TABLE [dbo].[tblClientRequests]  WITH CHECK ADD  CONSTRAINT [FK_tblClientRequests_tbl���������_full] FOREIGN KEY([ClientID])
REFERENCES [dbo].[tbl���������_full] ([���])
GO

ALTER TABLE [dbo].[tblClientRequests] CHECK CONSTRAINT [FK_tblClientRequests_tbl���������_full]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'link to the client' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblClientRequests', @level2type=N'CONSTRAINT',@level2name=N'FK_tblClientRequests_tbl���������_full'
GO

ALTER TABLE [dbo].[tblClientRequests]  WITH CHECK ADD  CONSTRAINT [FK_tblClientRequests_tbl������] FOREIGN KEY([OrderID])
REFERENCES [dbo].[tbl������] ([���])
GO

ALTER TABLE [dbo].[tblClientRequests] CHECK CONSTRAINT [FK_tblClientRequests_tbl������]
GO

ALTER TABLE [dbo].[tblClientRequests]  WITH CHECK ADD  CONSTRAINT [FK_tblClientRequests_tbl�������] FOREIGN KEY([QueryID])
REFERENCES [dbo].[tbl�������] ([���])
GO

ALTER TABLE [dbo].[tblClientRequests] CHECK CONSTRAINT [FK_tblClientRequests_tbl�������]
GO

ALTER TABLE [dbo].[tblClientRequests]  WITH CHECK ADD  CONSTRAINT [FK_tblClientRequests_tbl������������_add] FOREIGN KEY([AddEmployee])
REFERENCES [dbo].[tbl������������] ([���])
GO

ALTER TABLE [dbo].[tblClientRequests] CHECK CONSTRAINT [FK_tblClientRequests_tbl������������_add]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'added by' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblClientRequests', @level2type=N'CONSTRAINT',@level2name=N'FK_tblClientRequests_tbl������������_add'
GO

ALTER TABLE [dbo].[tblClientRequests]  WITH CHECK ADD  CONSTRAINT [FK_tblClientRequests_tbl������������_answer] FOREIGN KEY([AnswerEmployee])
REFERENCES [dbo].[tbl������������] ([���])
GO

ALTER TABLE [dbo].[tblClientRequests] CHECK CONSTRAINT [FK_tblClientRequests_tbl������������_answer]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'answer by' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblClientRequests', @level2type=N'CONSTRAINT',@level2name=N'FK_tblClientRequests_tbl������������_answer'
GO


