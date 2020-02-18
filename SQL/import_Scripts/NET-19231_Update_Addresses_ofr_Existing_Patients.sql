USE superbill_63524_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION
--commit
SET NOCOUNT ON

PRINT''
PRINT'Updating Addresses..'

UPDATE p
SET 
p.AddressLine1=ip.address1,
p.AddressLine2=ip.address2,
p.City=ip.city,
p.State=ip.state,
p.ZipCode=ip.zipcode
FROM dbo.Patient p 
LEFT JOIN dbo._import_1_1_PatientDemographics ip 
ON ip.chartnumber = p.PatientID
WHERE p.AddressLine1 IS NULL

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--SELECT * FROM dbo._import_1_1_PatientDemographics ORDER BY lastname,firstname
--SELECT * FROM patient ORDER BY lastname, firstname

