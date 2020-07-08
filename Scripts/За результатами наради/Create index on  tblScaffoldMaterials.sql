USE [Chest35]
GO

/****** Object:  Index [IX_tblScaffoldMaterials]    Script Date: 01/27/2020 12:43:06 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[tblScaffoldMaterials]') AND name = N'IX_tblScaffoldMaterials')
DROP INDEX [IX_tblScaffoldMaterials] ON [dbo].[tblScaffoldMaterials] WITH ( ONLINE = OFF )
GO

USE [Chest35]
GO

/****** Object:  Index [IX_tblScaffoldMaterials]    Script Date: 01/27/2020 12:43:07 ******/
CREATE unique NONCLUSTERED  INDEX [IX_tblScaffoldMaterials] ON [dbo].[tblScaffoldMaterials] 
(
	ScaffoldID, MatID ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


