DELETE FROM dbo.EdiHackPayer WHERE edihackid = (SELECT EdiHackID FROM dbo.EdiHack WHERE [Name] = 'GroupTaxonomyCodeRequired')
DELETE FROM dbo.EdiHack WHERE [Name] = 'GroupTaxonomyCodeRequired'
