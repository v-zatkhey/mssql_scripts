use [Chest35]
GO

GRANT INSERT, SELECT, UPDATE, REFERENCES, DELETE  
ON [dbo].[tblClientRequests] 
TO [Chest_Admins], [Chest_Rukovodstvo], [Chest_Zakazi]
GO

GRANT SELECT, REFERENCES ON [dbo].[tblClientRequests] TO [Chest_public]
GO

GRANT INSERT, SELECT, UPDATE, REFERENCES, DELETE  
ON [dbo].tblClientRequestDetails 
TO [Chest_Admins], [Chest_Rukovodstvo], [Chest_Zakazi]
GO

GRANT SELECT, REFERENCES ON [dbo].tblClientRequestDetails TO [Chest_public]
GO

GRANT SELECT, REFERENCES ON [dbo].vwClientRequests TO [Chest_public], [Chest_Admins], [Chest_Rukovodstvo], [Chest_Zakazi]
GO