USE [Chest35]
GO

/****** Object:  Index [IX_Materials_new21_MatID_MatName]    Script Date: 12/13/2019 09:53:53 ******/
CREATE NONCLUSTERED INDEX [IX_Materials_new21_MatID_MatName] ON [dbo].[Materials] 
(
	[MatID] ASC,
	[MatName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

