--Reverting FB 2332/SF 00179790 for SF 192157
UPDATE dbo.ProviderNumberType
SET Active = 1, ShowInClaimSettings = 1
WHERE ANSIReferenceIdentificationQualifier = 'ZZ'

UPDATE dbo.GroupNumberType
SET Active = 1, ShowInClaimSettings = 1
WHERE ANSIReferenceIdentificationQualifier = 'ZZ'
