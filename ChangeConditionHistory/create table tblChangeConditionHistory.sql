USE [Chest35]
GO

/****** Object:  Table [dbo].[tblChangeConditionHistory]    Script Date: 09/27/2018 10:02:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE dbo.tblChangeConditionHistory(
	ID int IDENTITY(1,1) NOT NULL,
	BaseListID int NOT NULL,
	OldCondition varchar(255) NULL,
	NewCondition [varchar](255) NULL,
	ChangeDate datetime NULL,
	UserName varchar(255) NULL,
 CONSTRAINT [PK_tblChangeConditionHistory] PRIMARY KEY CLUSTERED 
(
	ID ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE dbo.tblChangeConditionHistory  
	WITH CHECK ADD  CONSTRAINT FK_ChangeConditionHistory_BaseList FOREIGN KEY(BaseListID)
	REFERENCES dbo.[tblБазовыеСписки] ([Код_ID])
GO

ALTER TABLE dbo.tblChangeConditionHistory CHECK CONSTRAINT FK_ChangeConditionHistory_BaseList
GO

-- drop table tblChangeConditionHistory

	
use [Chest35]
GO
GRANT INSERT
	, SELECT
	, ALTER
	, UPDATE
	, VIEW DEFINITION
	, VIEW CHANGE TRACKING 
	, REFERENCES
	, DELETE
	, CONTROL
		ON [dbo].[tblChangeConditionHistory] TO [Chest_Admins]
GO

GRANT SELECT
	, REFERENCES 
		ON [dbo].[tblChangeConditionHistory] TO [Chest_public]
GO

GRANT SELECT
	, REFERENCES 
		ON [dbo].[tblChangeConditionHistory] TO [Chest_Wes_Chief]
GO

GRANT SELECT
	, REFERENCES 
		ON [dbo].[tblChangeConditionHistory] TO [Chest_Wesovschiki]
GO

