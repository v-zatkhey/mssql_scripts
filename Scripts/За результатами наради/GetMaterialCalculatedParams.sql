SELECT --[ID]
      --,[MatID]
      m.MatName as IDNUMBER
      ,cp.[Smiles]
      ,cp.[ChemicalName]
      ,cp.[MW]
      ,cp.[Acceptor]
      ,cp.[Donor]
      ,cp.[cLogP]
      ,cp.[RotBond]
      ,cp.[TPSA]
      ,cp.[Fsp3]
      ,cp.[VendorCnt]
      ,cp.[Yr]
      ,cp.[Ring]
      ,cp.[AromRing]
      ,cp.[Benzene]
      ,cp.[Amide]
      ,cp.[LogBB]
      ,cp.[cLogS]
      ,cp.[HAC]
      ,cp.[Rate]
  FROM [Chest35].[dbo].[MaterialCalculatedParams] cp
	inner join [Chest35].dbo.Materials m on m.MatID = cp.MatID
GO

