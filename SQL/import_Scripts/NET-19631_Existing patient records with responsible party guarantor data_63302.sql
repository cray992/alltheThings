USE superbill_63302_dev
GO
SET NOCOUNT ON 
BEGIN TRANSACTION
--rollback
--commit
PRINT'Updating contact and guarantor info...'
UPDATE p SET
p.EmergencyName=ip.EmergencyName,
p.ResponsibleFirstName=ip.ResponsiblePartyFirstName,
p.ResponsibleLastName=ip.ResponsiblePartyLastName,
p.emergencyphone= 
	CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ip.EmergencyPhone)) >= 10 
	THEN LEFT(dbo.fn_RemoveNonNumericCharacters(ip.EmergencyPhone),10)ELSE '' END,
p.ResponsibleRelationshipToPatient=
	CASE 
	WHEN ip.ResponsiblePartyRelationship='child'THEN 'C'
	WHEN ip.ResponsiblePartyRelationship='spouse'THEN 'U'
	ELSE 'O' END,
p.ResponsibleAddressLine1=ip.ResponsiblePartyAddress1,
p.ResponsibleAddressLine2=ip.ResponsiblePartyAddress2,
p.ResponsibleCity=ip.ResponsiblePartyCity,
p.ResponsibleState=ip.ResponsiblePartyState,
p.ResponsibleZipCode=REPLACE(ip.ResponsiblePartyZipCode,'-','')
FROM dbo.[Carelink_63302#csv$] ip INNER JOIN dbo.Patient p 
ON p.VendorID=ip.ChartNumber
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

