USE [SKLAD30]
GO

/****** Object:  Table [dbo].[LowerLimit]    Script Date: 11/02/2018 10:25:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[LowerLimit](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[StoreID] [int] NOT NULL,
	[SubstanceID] [int] NOT NULL,
	[LimitQnt] [int] NOT NULL,
	[OrderQnt] [int] NOT NULL,
 CONSTRAINT [PK_LowerLimit] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[LowerLimit]  WITH CHECK ADD  CONSTRAINT [FK_LowerLimit_Вещества] FOREIGN KEY([SubstanceID])
REFERENCES [dbo].[__Вещества] ([Код_ID])
GO

ALTER TABLE [dbo].[LowerLimit] CHECK CONSTRAINT [FK_LowerLimit_Вещества]
GO

ALTER TABLE [dbo].[LowerLimit]  WITH CHECK ADD  CONSTRAINT [FK_LowerLimitСклады] FOREIGN KEY([StoreID])
REFERENCES [dbo].[Склады] ([Код])
GO

ALTER TABLE [dbo].[LowerLimit] CHECK CONSTRAINT [FK_LowerLimitСклады]
GO


ALTER TABLE [dbo].[LowerLimit] ADD  CONSTRAINT [DF_LowerLimit_LimitQnt]  DEFAULT ((0)) FOR [LimitQnt]
GO

ALTER TABLE [dbo].[LowerLimit] ADD  CONSTRAINT [DF_LowerLimit_OrderQnt]  DEFAULT ((0)) FOR [OrderQnt]
GO


