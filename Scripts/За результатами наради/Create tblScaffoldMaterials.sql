USE [Chest35]
GO

/****** Object:  Table [dbo].[tblScaffoldMaterials]    Script Date: 01/27/2020 12:47:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblScaffoldMaterials](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ScaffoldID] [int] NULL,
	[MatID] [int] NULL,
 CONSTRAINT [PK_tblScaffoldMaterials] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[tblScaffoldMaterials]  WITH CHECK ADD  CONSTRAINT [FK_tblScaffoldMaterials_Materials] FOREIGN KEY([MatID])
REFERENCES [dbo].[Materials] ([MatID])
GO

ALTER TABLE [dbo].[tblScaffoldMaterials] CHECK CONSTRAINT [FK_tblScaffoldMaterials_Materials]
GO

ALTER TABLE [dbo].[tblScaffoldMaterials]  WITH CHECK ADD  CONSTRAINT [FK_tblScaffoldMaterials_tblScaffold] FOREIGN KEY([ScaffoldID])
REFERENCES [dbo].[tblScaffold] ([ID])
GO

ALTER TABLE [dbo].[tblScaffoldMaterials] CHECK CONSTRAINT [FK_tblScaffoldMaterials_tblScaffold]
GO


