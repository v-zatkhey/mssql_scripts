
use [Chest35]
GO

GRANT SELECT,INSERT,UPDATE,DELETE,REFERENCES 
ON [dbo].[tblID_CAS] 
TO [Chest_Admins],[Chest_Postavki],[Sklad30Chest],[Chest_Wes_Chief]
	,[Chest_Rukovodstvo],[Chest_Postavki_really],[Chest_Wesovschiki],[Chest_Otpravki],[Chest_Zakazi]
GO

GRANT SELECT,REFERENCES ON [dbo].[tblID_CAS] TO [Chest_public]
GO
