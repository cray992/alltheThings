USE superbill_63463_dev_v4
GO

SET XACT_ABORT ON

--BEGIN TRANSACTION

--commit 

DECLARE @TargetPracticeID INT
DECLARE @SourcePracticeID INT
DECLARE @VendorImportID INT

SET @TargetPracticeID = 11
SET @SourcePracticeID = 6
SET @VendorImportID = 3

SET NOCOUNT ON



------------------Dup Removal----------------
--UPDATE dbo._import_3_11_InsuranceCOMPANYPLANList
--SET planname='Sedgwick CMS'
--WHERE AutoTempID=20
--SELECT * FROM dbo._import_3_11_InsuranceCOMPANYPLANList
-- DELETE FROM dbo.PracticeToInsuranceCompany
--WHERE practiceid=11
/*
==========================================================================================================================================
DELETE SCRIPT
==========================================================================================================================================
*/

--/*
DELETE FROM dbo.InsurancePolicyAuthorization WHERE InsurancePolicyID IN (SELECT InsurancePolicyID FROM dbo.InsurancePolicy WHERE PracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy Auth records deleted'
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.AppointmentRecurrenceException WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @TargetPracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment Recurr Excep records deleted'
DELETE FROM dbo.AppointmentRecurrence WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @TargetPracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment Recurr records deleted'
DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @TargetPracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @TargetPracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToAppointmentReason records deleted'
DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
DELETE FROM dbo.PatientCaseDate WHERE PatientCaseID IN (SELECT PatientCaseID FROM dbo.PatientCase WHERE PracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case Date records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE VendorImportID = @VendorImportID AND PracticeID = @TargetPracticeID)
DELETE FROM dbo.Patient WHERE PracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
DELETE FROM dbo.ServiceLocation WHERE VendorImportID = @VendorImportID AND PracticeID = @TargetPracticeID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Service Location records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
DELETE FROM dbo.PracticeToInsuranceCompany WHERE PracticeID = 11 --AND InsuranceCompanyID IN (SELECT InsuranceCompanyID FROM dbo.InsuranceCompany WHERE CreatedPracticeID = 11 AND VendorImportID = 3)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Practice To Insurance Company Plan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @TargetPracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
--*/

PRINT ''
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
(
InsuranceCompanyName ,
Notes ,
AddressLine1 ,
AddressLine2 ,
City ,
State ,
Country ,
ZipCode ,
ContactPrefix ,
ContactFirstName ,
ContactMiddleName ,
ContactLastName ,
ContactSuffix ,
Phone ,
PhoneExt ,
Fax ,
FaxExt ,
BillSecondaryInsurance ,
EClaimsAccepts ,
BillingFormID ,
InsuranceProgramCode ,
HCFADiagnosisReferenceFormatCode ,
HCFASameAsInsuredFormatCode ,
LocalUseFieldTypeCode ,
ReviewCode ,
CompanyTextID ,
ClearinghousePayerID ,
CreatedPracticeID ,
CreatedDate ,
CreatedUserID ,
ModifiedDate ,
ModifiedUserID ,
SecondaryPrecedenceBillingFormID ,
VendorID ,
VendorImportID ,
--DefaultAdjustmentCode ,
ReferringProviderNumberTypeID ,
NDCFormat ,
UseFacilityID ,
AnesthesiaType ,
InstitutionalBillingFormID
)

---------INSERTING INSURANCE COMPANY INTO PRACTICE 6
--SELECT DISTINCT

--i.insurancecompanyname , -- InsuranceCompanyName - varchar(128)
--i.notes , -- Notes - text
--i.address1 , -- AddressLine1 - varchar(256)
--i.address2 , -- AddressLine2 - varchar(256)
--i.city , -- City - varchar(128)
--i.state , -- State - varchar(2)
--NULL, --i.country , -- Country - varchar(32)
--LEFT(CASE 
--WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.zip)
--WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.zip)
--ELSE '' END,9) , -- ZipCode - varchar(9)
--NULL, --i.contactprefix , -- ContactPrefix - varchar(16)
--i.contactfirstname , -- ContactFirstName - varchar(64)
--NULL, --i.contactmiddlename , -- ContactMiddleName - varchar(64)
--i.contactlastname , -- ContactLastName - varchar(64)
--NULL, --i.contactsuffix , -- ContactSuffix - varchar(16)
--CASE
--WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.phone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.phone),10)
--ELSE '' END , -- HomePhone - varchar(10)
--i.phoneext , -- PhoneExt - varchar(10)
--i.fax , -- Fax - varchar(10)
--i.faxext , -- FaxExt - varchar(10)
--'', --i.billsecondaryinsurance , -- BillSecondaryInsurance - bit
--'', --i.eclaimsaccepts , -- EClaimsAccepts - bit
--'', --i.billingformid , -- BillingFormID - int
--'', --i.insuranceprogramcode , -- InsuranceProgramCode - char(2)
--'R', --i.hcfadiagnosisreferenceformatcode , -- HCFADiagnosisReferenceFormatCode - char(1)
--'D', --i.hcfasameasinsuredformatcode , -- HCFASameAsInsuredFormatCode - char(1)
--NULL, --i.localusefieldtypecode , -- LocalUseFieldTypeCode - char(5)
--'' , -- ReviewCode - char(1)
--NULL, --i.companytextid , -- CompanyTextID - varchar(10)
--NULL, --i.clearinghousepayerid , -- ClearinghousePayerID - int
--@TargetPracticeID , -- CreatedPracticeID - int
--GETDATE() , -- CreatedDate - datetime
--0 , -- CreatedUserID - int
--GETDATE() , -- ModifiedDate - datetime
--0 , -- ModifiedUserID - int
--'', --i.secondaryprecedencebillingformid , -- SecondaryPrecedenceBillingFormID - int
--i.insuranceID , -- VendorID - varchar(50)
--@VendorImportID , -- VendorImportID - int
----a.AdjustmentCode , -- DefaultAdjustmentCode - varchar(10)
--NULL, --i.referringprovidernumbertypeid , -- ReferringProviderNumberTypeID - int
--1 , -- NDCFormat - int
--1 , -- UseFacilityID - bit
--'', --i.anesthesiatype , -- AnesthesiaType - varchar(1)
--NULL --i.institutionalbillingformid -- InstitutionalBillingFormID - int
--FROM dbo._import_3_11_Insurancecompanyplanlist i
--LEFT JOIN dbo.InsuranceCompany IC ON i.insurancecompanyname=ic.InsuranceCompanyName AND ic.CreatedPracticeID = @SourcePracticeID
--WHERE ic.insurancecompanyname IS NULL AND i.insurancecompanyname <> ''
--PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
--*/
-----NOT PRACTICEID 6***************************************** ------ENTERING INSURANCE COMPANY FROM PRACTICE 6 THAT DON"T ALREADY EXIST
SELECT Distinct

ic.insurancecompanyname , -- InsuranceCompanyName - varchar(128)
NULL,--ic.notes , -- Notes - text
ic.AddressLine1 , -- AddressLine1 - varchar(256)
NULL, --i.address2 , -- AddressLine2 - varchar(256)
ic.city , -- City - varchar(128)
ic.state , -- State - varchar(2)
NULL, --i.country , -- Country - varchar(32)
LEFT(CASE 
WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ic.zipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(ic.zipcode)
WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ic.zipcode)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(ic.zipcode)
ELSE '' END,9) , -- ZipCode - varchar(9)
NULL, --ic.contactprefix , -- ContactPrefix - varchar(16)
ic.contactfirstname , -- ContactFirstName - varchar(64)
NULL, --ic.contactmiddlename , -- ContactMiddleName - varchar(64)
ic.contactlastname , -- ContactLastName - varchar(64)
NULL, --ic.contactsuffix , -- ContactSuffix - varchar(16)
CASE
WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ic.phone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(ic.phone),10)
ELSE '' END , -- HomePhone - varchar(10)
ic.phoneext , -- PhoneExt - varchar(10)
ic.fax , -- Fax - varchar(10)
ic.faxext , -- FaxExt - varchar(10)
ic.billsecondaryinsurance , -- BillSecondaryInsurance - bit
ic.eclaimsaccepts , -- EClaimsAccepts - bit
ic.billingformid , -- BillingFormID - int
ic.insuranceprogramcode , -- InsuranceProgramCode - char(2)
ic.hcfadiagnosisreferenceformatcode , -- HCFADiagnosisReferenceFormatCode - char(1)
ic.hcfasameasinsuredformatcode , -- HCFASameAsInsuredFormatCode - char(1)
NULL, --ic.localusefieldtypecode , -- LocalUseFieldTypeCode - char(5)
'' , -- ReviewCode - char(1)''
NULL, --ic.companytextid , -- CompanyTextID - varchar(10)
NULL, --ic.clearinghousepayerid , -- ClearinghousePayerID - int
@TargetPracticeID , -- CreatedPracticeID - int
GETDATE() , -- CreatedDate - datetime
0 , -- CreatedUserID - int
GETDATE() , -- ModifiedDate - datetime
0 , -- ModifiedUserID - int
'', --ic.secondaryprecedencebillingformid , -- SecondaryPrecedenceBillingFormID - int
LEFT(i.insurancecompanyname,50) , -- VendorID - varchar(50)
@VendorImportID , -- VendorImportID - int
--ic.defaultAdjustmentCode , -- DefaultAdjustmentCode - varchar(10)
NULL, --ic.referringprovidernumbertypeid , -- ReferringProviderNumberTypeID - int
1 , -- NDCFormat - int
1 , -- UseFacilityID - bit
'', --ic.anesthesiatype , -- AnesthesiaType - varchar(1)
NULL --ic.institutionalbillingformid -- InstitutionalBillingFormID - int
FROM dbo._import_3_11_Insurancecompanyplanlist i
INNER JOIN dbo.InsuranceCompany IC ON i.insurancecompanyname=ic.InsuranceCompanyName AND ic.CreatedPracticeID = @SourcePracticeID
LEFT JOIN dbo.InsuranceCompany IC2 ON i.insurancecompanyname=ic2.InsuranceCompanyName AND ic2.CreatedPracticeID=@TargetPracticeID
WHERE ic2.insurancecompanyname IS null
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

-------------------Not Practice 6 #2

PRINT ''
PRINT 'Inserting Into Insurance Company2...'
INSERT INTO dbo.InsuranceCompany
(
InsuranceCompanyName ,
Notes ,
AddressLine1 ,
AddressLine2 ,
City ,
State ,
Country ,
ZipCode ,
ContactPrefix ,
ContactFirstName ,
ContactMiddleName ,
ContactLastName ,
ContactSuffix ,
Phone ,
PhoneExt ,
Fax ,
FaxExt ,
BillSecondaryInsurance ,
EClaimsAccepts ,
BillingFormID ,
InsuranceProgramCode ,
HCFADiagnosisReferenceFormatCode ,
HCFASameAsInsuredFormatCode ,
LocalUseFieldTypeCode ,
ReviewCode ,
CompanyTextID ,
ClearinghousePayerID ,
CreatedPracticeID ,
CreatedDate ,
CreatedUserID ,
ModifiedDate ,
ModifiedUserID ,
SecondaryPrecedenceBillingFormID ,
VendorID ,
VendorImportID ,
--DefaultAdjustmentCode ,
ReferringProviderNumberTypeID ,
NDCFormat ,
UseFacilityID ,
AnesthesiaType ,
InstitutionalBillingFormID
)
SELECT 
i.insurancecompanyname , -- InsuranceCompanyName - varchar(128)
i.notes , -- Notes - text
i.address1 , -- AddressLine1 - varchar(256)
i.address2 , -- AddressLine2 - varchar(256)
i.city , -- City - varchar(128)
i.state , -- State - varchar(2)
NULL, --ic.country , -- Country - varchar(32)
LEFT(CASE 
WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.zip)
WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.zip)
ELSE '' END,9) , -- ZipCode - varchar(9)
NULL, --ic.contactprefix , -- ContactPrefix - varchar(16)
i.contactfirstname , -- ContactFirstName - varchar(64)
NULL, --ic.contactmiddlename , -- ContactMiddleName - varchar(64)
i.contactlastname , -- ContactLastName - varchar(64)
NULL, --ic.contactsuffix , -- ContactSuffix - varchar(16)
CASE
WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.phone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.phone),10)
ELSE '' END , -- HomePhone - varchar(10)
i.phoneext , -- PhoneExt - varchar(10)
i.fax , -- Fax - varchar(10)
i.faxext , -- FaxExt - varchar(10)
'', --ic.billsecondaryinsurance , -- BillSecondaryInsurance - bit
'', --ic.eclaimsaccepts , -- EClaimsAccepts - bit
'', --ic.billingformid , -- BillingFormID - int
'CI', --ic.insuranceprogramcode , -- InsuranceProgramCode - char(2)
'R', --ic.hcfadiagnosisreferenceformatcode , -- HCFADiagnosisReferenceFormatCode - char(1)
'D', --ic.hcfasameasinsuredformatcode , -- HCFASameAsInsuredFormatCode - char(1)
NULL, --ic.localusefieldtypecode , -- LocalUseFieldTypeCode - char(5)
'' , -- ReviewCode - char(1)
NULL, --ic.companytextid , -- CompanyTextID - varchar(10)
NULL, --ic.clearinghousepayerid , -- ClearinghousePayerID - int
@TargetPracticeID , -- CreatedPracticeID - int
GETDATE() , -- CreatedDate - datetime
0 , -- CreatedUserID - int
GETDATE() , -- ModifiedDate - datetime
0 , -- ModifiedUserID - int
'', --ic.secondaryprecedencebillingformid , -- SecondaryPrecedenceBillingFormID - int
i.insuranceID , -- VendorID - varchar(50)
@VendorImportID , -- VendorImportID - int
--ic.defaultAdjustmentCode , -- DefaultAdjustmentCode - varchar(10)
NULL, --ic.referringprovidernumbertypeid , -- ReferringProviderNumberTypeID - int
1 , -- NDCFormat - int
1 , -- UseFacilityID - bit
'', --ic.anesthesiatype , -- AnesthesiaType - varchar(1)
NULL --ic.institutionalbillingformid -- InstitutionalBillingFormID - int
FROM dbo._import_3_11_Insurancecompanyplanlist i
LEFT JOIN dbo.InsuranceCompany IC2 ON i.insurancecompanyname=ic2.InsuranceCompanyName AND ic2.CreatedPracticeID = @targetpracticeId
WHERE ic2.insurancecompanyname IS NULL and i.insurancecompanyname <>''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

PRINT ''
PRINT 'Inserting Into PracticetoInsurance Company...'
INSERT INTO dbo.PracticeToInsuranceCompany
(
PracticeID ,
InsuranceCompanyID ,
CreatedDate ,
CreatedUserID ,
ModifiedDate ,
ModifiedUserID ,
EClaimsProviderID ,
EClaimsEnrollmentStatusID ,
EClaimsDisable ,
AcceptAssignment ,
UseSecondaryElectronicBilling ,
UseCoordinationOfBenefits ,
ExcludePatientPayment ,
BalanceTransfer
)
SELECT DISTINCT
@TargetPracticeID , -- PracticeID - int
ic2.InsuranceCompanyID , -- InsuranceCompanyID - int
GETDATE() , -- CreatedDate - datetime
0 , -- CreatedUserID - int
GETDATE() , -- ModifiedDate - datetime
0 , -- ModifiedUserID - int
NULL , -- EClaimsProviderID - varchar(32)
ptic.EClaimsEnrollmentStatusID , -- EClaimsEnrollmentStatusID - int
ptic.EClaimsDisable , -- EClaimsDisable - int
ptic.acceptassignment , -- AcceptAssignment - bit
ptic.usesecondaryelectronicbilling , -- UseSecondaryElectronicBilling - bit
ptic.usecoordinationofbenefits , -- UseCoordinationOfBenefits - bit
ptic.excludepatientpayment , -- ExcludePatientPayment - bit
ptic.balancetransfer -- BalanceTransfer - bit
FROM dbo.PracticeToInsuranceCompany ptic
INNER JOIN dbo.InsuranceCompany ic ON
ptic.insurancecompanyid = ic.InsuranceCompanyID AND
--ic.VendorImportID = @VendorImportID AND 
ic.CreatedPracticeID=@SourcePracticeID
INNER JOIN dbo.InsuranceCompany IC2 ON ic.InsuranceCompanyName=ic2.InsuranceCompanyName AND ic2.CreatedPracticeID=@TargetPracticeID
WHERE ptic.practiceid = @SourcePracticeID AND NOT EXISTS (
SELECT * FROM dbo.InsuranceCompany a 
INNER JOIN dbo.PracticeToInsuranceCompany b ON a.InsuranceCompanyID = b.InsuranceCompanyID AND a.CreatedPracticeID =@TargetPracticeID)


PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

PRINT ''
PRINT 'Inserting Into Insurance Company Plan...'
INSERT INTO dbo.InsuranceCompanyPlan
(
PlanName ,
AddressLine1 ,
AddressLine2 ,
City ,
State ,
Country ,
ZipCode ,
ContactPrefix ,
ContactFirstName ,
ContactMiddleName ,
ContactLastName ,
ContactSuffix ,
Phone ,
PhoneExt ,
Notes ,
CreatedDate ,
CreatedUserID ,
ModifiedDate ,
ModifiedUserID ,
--ReviewCode ,
CreatedPracticeID ,
Fax ,
FaxExt ,
KareoInsuranceCompanyPlanID ,
KareoLastModifiedDate ,
InsuranceCompanyID ,
Copay ,
Deductible ,
VendorID ,
VendorImportID
)
SELECT
DISTINCT	
i.PlanName ,
i.Address1 ,
i.Address2 ,
i.City ,
i.State ,
NULL, --i.Country ,
CASE 
WHEN LEN(dbo.fn_RemoveNonNumericCharacters(I.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(I.zip)
WHEN LEN(dbo.fn_RemoveNonNumericCharacters(I.zip)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(I.zip)
ELSE '' END,
NULL, --i.ContactPrefix ,
i.ContactFirstName ,
NULL, --i.ContactMiddleName ,
i.ContactLastName ,
NULL, --i.ContactSuffix ,
CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.phone)) > 10 THEN
LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.phone),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.phone))),10)
ELSE NULL END  ,
i.PhoneExt ,
i.Notes ,
GETDATE() ,
0 ,
GETDATE() ,
0 ,
--i.ReviewCode ,
@TargetPracticeID,
CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.fax)) > 10 THEN
LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.fax),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.fax))),10)
ELSE NULL END ,
i.FaxExt ,
NULL, --i.KareoInsuranceCompanyPlanID ,
NULL, --CASE WHEN ISDATE(i.KareoLastModifiedDate) = 1 THEN i.kareolastmodifieddate ELSE NULL END ,
ic.InsuranceCompanyID ,
0 , --copay
0 , --deductible
i.Insuranceid ,
@VendorImportID
FROM dbo._import_3_11_Insurancecompanyplanlist i
INNER JOIN dbo.InsuranceCompany ic ON i.insurancecompanyname = ic.InsuranceCompanyName AND 
ic.VendorImportID =@VendorImportID AND -- @VendorImportID 
ic.CreatedPracticeID=@TargetPracticeID--@targetpracticeid 
LEFT JOIN dbo.InsuranceCompanyPlan a ON i.planname=a.PlanName AND a.CreatedPracticeID=@TargetPracticeID
WHERE a.planname IS NULL

PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

PRINT ''
PRINT 'Inserting Into Patient...'
INSERT INTO dbo.Patient
(
PracticeID ,
ReferringPhysicianID ,
Prefix ,
FirstName ,
MiddleName ,
LastName ,
Suffix ,
AddressLine1 ,
AddressLine2 ,
City ,
State ,
Country ,
ZipCode ,
Gender ,
MaritalStatus ,
HomePhone ,
HomePhoneExt ,
WorkPhone ,
WorkPhoneExt ,
DOB ,
SSN ,
EmailAddress ,
ResponsibleDifferentThanPatient ,
ResponsiblePrefix ,
ResponsibleFirstName ,
ResponsibleMiddleName ,
ResponsibleLastName ,
ResponsibleSuffix ,
ResponsibleRelationshipToPatient ,
ResponsibleAddressLine1 ,
ResponsibleAddressLine2 ,
ResponsibleCity ,
ResponsibleState ,
ResponsibleCountry ,
ResponsibleZipCode ,
CreatedDate ,
CreatedUserID ,
ModifiedDate ,
ModifiedUserID ,
EmploymentStatus ,
InsuranceProgramCode ,
PatientReferralSourceID ,
PrimaryProviderID ,
DefaultServiceLocationID ,
EmployerID ,
MedicalRecordNumber ,
MobilePhone ,
MobilePhoneExt ,
PrimaryCarePhysicianID ,
VendorID ,
VendorImportID ,
CollectionCategoryID ,
Active ,
SendEmailCorrespondence ,
--PhonecallRemindersEnabled ,
EmergencyName ,
EmergencyPhone ,
EmergencyPhoneExt ,
Ethnicity ,
Race ,
LicenseNumber ,
LicenseState ,
Language1 ,
Language2
)
SELECT DISTINCT
@TargetPracticeID , -- PracticeID - int
NULL,--rd.doctorID , – ReferringPhysicianID - int
'' , -- Prefix - varchar(16)
p.FirstName , -- FirstName - varchar(64)
'',--p.MiddleName , – MiddleName - varchar(64)
p.LastName , -- LastName - varchar(64)
'',--p.Suffix , – Suffix - varchar(16)
p.Address1 , -- AddressLine1 - varchar(256)
p.Address2 , -- AddressLine2 - varchar(256)
p.City , -- City - varchar(128)
p.State , -- State - varchar(2)
NULL,--p.Country , – Country - varchar(32)
CASE 
WHEN LEN(dbo.fn_RemoveNonNumericCharacters(p.zipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(p.zipcode)
WHEN LEN(dbo.fn_RemoveNonNumericCharacters(p.zipcode)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(p.zipcode)
ELSE '' END , -- ZipCode - varchar(9)
p.Gender , -- Gender - varchar(1)
NULL,-- p.MaritalStatus , – MaritalStatus - varchar(1)
CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(P.homephone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(P.homephone),10)
ELSE '' END, -- HomePhone - varchar(10)
NULL,--p.HomePhoneExt , – HomePhoneExt - varchar(10)
CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(P.workphone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(P.workphone),10)
ELSE '' END, -- WorkPhone - varchar(10)
NULL,--p.WorkExtension , – WorkPhoneExt - varchar(10)
p.Dateofbirth , -- DOB - datetime
CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(P.ssn)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(P.SSN), 9)
ELSE NULL END , -- SSN - char(9)
p.Email , -- EmailAddress - varchar(256)
1 , -- ResponsibleDifferentThanPatient - bit
nuLL, --p.ResponsiblePrefix , -- ResponsiblePrefix - varchar(16)
p.ResponsiblepartyFirstName , -- ResponsibleFirstName - varchar(64)
p.ResponsiblepartyMiddleName , -- ResponsibleMiddleName - varchar(64)
p.ResponsiblepartyLastName , -- ResponsibleLastName - varchar(64)
p.ResponsiblepartySuffix , -- ResponsibleSuffix - varchar(16)
p.ResponsiblepartyRelationship , -- ResponsibleRelationshipToPatient - varchar(1)
p.ResponsiblepartyAddress1 , -- ResponsibleAddressLine1 - varchar(256)
p.ResponsiblepartyAddress2 , -- ResponsibleAddressLine2 - varchar(256)
p.ResponsiblepartyCity , -- ResponsibleCity - varchar(128)
p.ResponsiblepartyState , -- ResponsibleState - varchar(2)
NULL, --p.ResponsiblepartyCountry , -- ResponsibleCountry - varchar(32)
p.ResponsiblepartyZipCode , -- ResponsibleZipCode - varchar(9)
GETDATE() , -- CreatedDate - datetime
0 , -- CreatedUserID - int
GETDATE() , -- ModifiedDate - datetime
0 , -- ModifiedUserID - int
NULL, --p.EmploymentStatus , – EmploymentStatus - char(1)
NULL,--p.insuranceprogramcode , – InsuranceProgramCode - char(2)
NULL, --prs.PatientReferralSourceID , – PatientReferralSourceID - int
NULL,--pp.DoctorID , – PrimaryProviderID - int
NULL,--CASE WHEN sl.ServiceLocationID IS NULL THEN (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation s WHERE s.PracticeID = @TargetPracticeID) ELSE sl.ServiceLocationID END , – DefaultServiceLocationID - int
NULL, --emp.EmployerID , – EmployerID - int
chartnumber , -- MedicalRecordNumber - varchar(128)
CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(P.cellphone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(P.cellphone),10)
ELSE '' END, -- MobilePhone - varchar(10)
NULL, --p.MobilePhoneExt , -- MobilePhoneExt - varchar(10)
NULL,--pcp.DoctorID , – PrimaryCarePhysicianID - int
chartnumber , -- VendorID - varchar(50)
@VendorImportID , -- VendorImportID - int
Null , -- CollectionCategoryID - int
1 , -- Active - bit
NULL , -- SendEmailCorrespondence - bit
-- PhonecallRemindersEnabled - bit
EmergencyName, -- varchar(128)
EmergencyPhone, -- varchar(10)
EmergencyPhoneExt, -- varchar(10)
NULL, --Ethnicity - varchar(64)
NULL, --Race - varchar(64)
NULL , -- LicenseNumber - varchar(64)
NULL , -- LicenseState - varchar(2)
Null , -- Language1 - varchar(64)
NULL -- Language2 - varchar(64)
FROM dbo._import_3_11_patientDemographics P
WHERE
NOT EXISTS (SELECT * FROM dbo.Patient pp WHERE pp.FirstName = p.firstname AND pp.LastName = p.lastname AND pp.Dob = p.dateofbirth AND pp.PracticeID = @TargetPracticeID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Insert Into Patient Alert...'
INSERT INTO dbo.PatientAlert
( PatientID ,
AlertMessage ,
ShowInPatientFlag ,
ShowInAppointmentFlag ,
ShowInEncounterFlag ,
CreatedDate ,
CreatedUserID ,
ModifiedDate ,
ModifiedUserID ,
ShowInClaimFlag ,
ShowInPaymentFlag ,
ShowInPatientStatementFlag
)
SELECT
p.PatientID , -- PatientID - int
pa.patientalertmessage , -- AlertMessage - text
1 , -- ShowInPatientFlag - bit
1 , -- ShowInAppointmentFlag - bit
1 , -- ShowInEncounterFlag - bit
GETDATE() , -- CreatedDate - datetime
0 , -- CreatedUserID - int
GETDATE() , -- ModifiedDate - datetime
0 , -- ModifiedUserID - int
1, -- ShowInClaimFlag - bit
1 , -- ShowInPaymentFlag - bit
1 -- ShowInPatientStatementFlag - bit
FROM dbo._import_3_11_patientdemographics pa
INNER JOIN dbo.Patient p ON
p.VendorImportID = @VendorImportID AND
p.VendorID = pa.chartnumber
WHERE pa.patientalertmessage <>''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

INSERT INTO dbo.PayerScenario
( Name ,
Description ,
PayerScenarioTypeID ,
StatementActive
)
SELECT DISTINCT 
FinancialClass
, financialclass, 1, 1
FROM dbo._import_3_11_patientDemographics d
LEFT JOIN dbo.PayerScenario ps ON d.financialclass=ps.Name
WHERE financialclass <>'' AND ps.name IS NULL AND 
financialclass not IN(
'Medi-Cal','Medical','Cash','Cash Patient','PI Lien','P.I. Lien')

PRINT ''
PRINT 'Inserting into PatientCase ...'
INSERT INTO dbo.PatientCase
(
PatientID ,
Name ,
Active ,
PayerScenarioID ,
ReferringPhysicianID ,
EmploymentRelatedFlag ,
AutoAccidentRelatedFlag ,
OtherAccidentRelatedFlag ,
AbuseRelatedFlag ,
AutoAccidentRelatedState ,
Notes ,
ShowExpiredInsurancePolicies ,
CreatedDate ,
CreatedUserID ,
ModifiedDate ,
ModifiedUserID ,
PracticeID ,
CaseNumber ,
WorkersCompContactInfoID ,
VendorID ,
VendorImportID ,
PregnancyRelatedFlag ,
StatementActive ,
EPSDT ,
FamilyPlanning ,
EPSDTCodeID ,
EmergencyRelated ,
HomeboundRelatedFlag
)
SELECT DISTINCT	
p.PatientID ,
'Active' ,
1 ,

CASE 
pc.financialclass
WHEN 'Medi-Cal' THEN 8
WHEN 'Medical' THEN 8
WHEN 'Cash' THEN 11
WHEN 'Cash Patient' THEN 11
WHEN 'HMO' THEN 18
WHEN 'PI Lien' THEN 1
WHEN 'P.I. Lien' THEN 1
ELSE ps.PayerScenarioID
END
,

NULL,--d.DoctorID ,
0,--,pc.employmentrelatedflag ,
0,--pc.autoaccidentrelatedflag ,
0,--pc.otheraccidentrelatedflag ,
0,--pc.abuserelatedflag ,
0,--pc.AutoAccidentRelatedState ,
NULL, --pc.Notes ,
0,--pc.showexpiredinsurancepolicies ,
GETDATE() ,
0 ,
GETDATE() ,
0 ,
@TargetPracticeID ,
NULL,--pc.CaseNumber ,
NULL,--pc.WorkersCompContactInfoID ,
pc.chartnumber , -- VendorID
@VendorImportID , -- VenorID
0,--pc.pregnancyrelatedflag ,
1,--pc.statementactive ,
0,--pc.epsdt ,
0,--pc.familyplanning ,
NULL,--pc.epsdtcodeid ,
0,--pc.emergencyrelated ,
0--pc.homeboundrelatedflag
FROM dbo._import_3_11_patientDemographics pc
INNER JOIN dbo.Patient p ON
pc.chartnumber = p.VendorID AND
p.VendorImportID = @VendorImportID
left JOIN dbo.PayerScenario ps ON pc.financialclass=ps.Name
WHERE pc.chartnumber <>'MDSuite-109'

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



----------------Policy 1----------------------
PRINT ''
PRINT 'Inserting into InsurancePolicy ...'
INSERT INTO dbo.InsurancePolicy
(
PatientCaseID ,
InsuranceCompanyPlanID ,
Precedence ,
PolicyNumber ,
GroupNumber ,
PolicyStartDate ,
PolicyEndDate ,
CardOnFile ,
 PatientRelationshipToInsured,
HolderPrefix ,
HolderFirstName ,
HolderMiddleName ,
HolderLastName ,
HolderSuffix ,
HolderDOB ,
HolderSSN ,
HolderThroughEmployer ,
HolderEmployerName ,
PatientInsuranceStatusID ,
CreatedDate ,
CreatedUserID ,
ModifiedDate ,
ModifiedUserID ,
HolderGender ,
HolderAddressLine1 ,
HolderAddressLine2 ,
HolderCity ,
HolderState ,
HolderCountry ,
HolderZipCode ,
HolderPhone ,
HolderPhoneExt ,
DependentPolicyNumber ,
Notes ,
Phone ,
PhoneExt ,
Fax ,
FaxExt ,
Copay ,
Deductible ,
PatientInsuranceNumber ,
Active ,
PracticeID ,
AdjusterPrefix ,
AdjusterFirstName ,
AdjusterMiddleName ,
AdjusterLastName ,
AdjusterSuffix ,
VendorID ,
VendorImportID ,
InsuranceProgramTypeID ,
GroupName ,
ReleaseOfInformation
)
SELECT
DISTINCT

pc.PatientCaseID ,
icp.InsuranceCompanyPlanID ,
1, --ip.Precedence ,
ip.PolicyNumber1 ,
ip.GroupNumber1 ,
CASE WHEN ISDATE(ip.Policy1StartDate) = 1 THEN ip.policy1startdate ELSE NULL END ,
CASE WHEN ISDATE(ip.Policy1EndDate) = 1 THEN ip.policy1enddate ELSE NULL END ,
0, --ip.CardOnFile ,
CASE WHEN  PatientRelationship1 ='' THEN 'S' ELSE NULL END ,
NULL, --ip.HolderPrefix ,
ip.Holder1FirstName ,
ip.Holder1MiddleName ,
ip.Holder1LastName ,
NULL, --ip.Holder1Suffix ,
ip.Holder1dateofbirth ,
ip.Holder1SSN ,
0, --ip.holderthroughemployer ,
ip.Employer1 ,
0, --ip.PatientInsuranceStatusID ,
GETDATE() ,
0 ,
GETDATE() ,
0 ,
ip.holder1Gender ,
ip.holder1street1 ,
ip.holder1street2 ,
ip.Holder1City ,
ip.Holder1State ,
NULL, --ip.HolderCountry ,
ip.Holder1ZipCode ,
NULL, --ip.HolderPhone ,
NULL, --ip.HolderPhoneExt ,
ip.policynumber1 ,
ip.policy1Note ,
NULL, --ip.Phone ,
NULL, --ip.PhoneExt ,
NULL, --ip.Fax ,
NULL, --ip.FaxExt ,
ip.policy1Copay ,
ip.policy1Deductible ,
NULL, --ip.PatientInsuranceNumber , -- ASK SHEA what this number is referring to
1, --ip.active ,
@TargetPracticeID ,
NULL, --ip.AdjusterPrefix ,
NULL, --ip.AdjusterFirstName ,
NULL, --ip.AdjusterMiddleName ,
NULL, --ip.AdjusterLastName ,
NULL, --ip.AdjusterSuffix ,
ip.chartnumber, --ip.InsurancePolicyID ,
@VendorImportID ,
NULL, --ip.insuranceprogramtypeid ,
ip.primaryGroupName ,
NULL --ip.ReleaseOfInformation
FROM dbo._import_3_11_patientDemographics ip
INNER JOIN dbo._import_3_11_Insurancecompanyplanlist icpl ON ip.insurancecode1=icpl.PlanName
INNER JOIN dbo.PatientCase pc ON ip.chartnumber = pc.VendorID AND pc.VendorImportID =@VendorImportID-- @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON icpl.insurancecompanyname = icp.PlanName AND icp.VendorImportID = @VendorImportID--@VendorImportID
WHERE icp.CreatedPracticeID=@TargetPracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

------------------Policy 2----------------------
PRINT ''
PRINT 'Inserting into InsurancePolicy2 ...'
INSERT INTO dbo.InsurancePolicy
(
PatientCaseID ,
InsuranceCompanyPlanID ,
Precedence ,
PolicyNumber ,
GroupNumber ,
PolicyStartDate ,
PolicyEndDate ,
CardOnFile ,
PatientRelationshipToInsured ,
HolderPrefix ,
HolderFirstName ,
HolderMiddleName ,
HolderLastName ,
HolderSuffix ,
HolderDOB ,
HolderSSN ,
HolderThroughEmployer ,
HolderEmployerName ,
PatientInsuranceStatusID ,
CreatedDate ,
CreatedUserID ,
ModifiedDate ,
ModifiedUserID ,
HolderGender ,
HolderAddressLine1 ,
HolderAddressLine2 ,
HolderCity ,
HolderState ,
HolderCountry ,
HolderZipCode ,
HolderPhone ,
HolderPhoneExt ,
DependentPolicyNumber ,
Notes ,
Phone ,
PhoneExt ,
Fax ,
FaxExt ,
Copay ,
Deductible ,
PatientInsuranceNumber ,
Active ,
PracticeID ,
AdjusterPrefix ,
AdjusterFirstName ,
AdjusterMiddleName ,
AdjusterLastName ,
AdjusterSuffix ,
VendorID ,
VendorImportID ,
InsuranceProgramTypeID ,
GroupName ,
ReleaseOfInformation
)
SELECT
DISTINCT
pc.PatientCaseID ,
icp.InsuranceCompanyPlanID ,
2, --ip.Precedence ,
ip.PolicyNumber2 ,
ip.GroupNumber2 ,
CASE WHEN ISDATE(ip.Policy2StartDate) = 1 THEN ip.policy2startdate ELSE NULL END ,
CASE WHEN ISDATE(ip.Policy2EndDate) = 1 THEN ip.policy2enddate ELSE NULL END ,
0, --ip.CardOnFile ,
CASE WHEN  PatientRelationship2 ='' THEN 'S' ELSE NULL END , 
NULL, --ip.HolderPrefix ,
ip.Holder2FirstName ,
ip.Holder2MiddleName ,
ip.Holder2LastName ,
NULL, --ip.Holder1Suffix ,
ip.Holder2dateofbirth ,
ip.Holder2SSN ,
0, --ip.holderthroughemployer ,
ip.Employer1 ,
0, --ip.PatientInsuranceStatusID ,
GETDATE() ,
0 ,
GETDATE() ,
0 ,
ip.holder2Gender ,
ip.holder2street1 ,
ip.holder2street2 ,
ip.Holder2City ,
ip.Holder2State ,
NULL, --ip.HolderCountry ,
ip.Holder2ZipCode ,
NULL, --ip.HolderPhone ,
NULL, --ip.HolderPhoneExt ,
ip.policynumber2 ,
ip.policy2Note ,
NULL, --ip.Phone ,
NULL, --ip.PhoneExt ,
NULL, --ip.Fax ,
NULL, --ip.FaxExt ,
ip.policy2Copay ,
ip.policy2Deductible ,
NULL, --ip.PatientInsuranceNumber , -- ASK SHEA what this number is referring to
1, --ip.active ,
@TargetPracticeID ,
NULL, --ip.AdjusterPrefix ,
NULL, --ip.AdjusterFirstName ,
NULL, --ip.AdjusterMiddleName ,
NULL, --ip.AdjusterLastName ,
NULL, --ip.AdjusterSuffix ,
ip.chartnumber, --ip.InsurancePolicyID ,
@VendorImportID ,
NULL, --ip.insuranceprogramtypeid ,
ip.secondaryGroupName ,
NULL --ip.ReleaseOfInformation
FROM dbo._import_3_11_patientDemographics ip
INNER JOIN dbo.PatientCase pc ON ip.chartnumber = pc.VendorID AND pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON ip.insurancecode2 = icp.VendorID AND icp.VendorImportID = @VendorImportID
WHERE ip.insurancecode2 <> 'patient'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

----------------Policy 3----------------------
PRINT ''
PRINT 'Inserting into InsurancePolicy ...'
INSERT INTO dbo.InsurancePolicy
(
PatientCaseID ,
InsuranceCompanyPlanID ,
Precedence ,
PolicyNumber ,
GroupNumber ,
PolicyStartDate ,
PolicyEndDate ,
CardOnFile ,
PatientRelationshipToInsured ,
HolderPrefix ,
HolderFirstName ,
HolderMiddleName ,
HolderLastName ,
HolderSuffix ,
HolderDOB ,
HolderSSN ,
HolderThroughEmployer ,
HolderEmployerName ,
PatientInsuranceStatusID ,
CreatedDate ,
CreatedUserID ,
ModifiedDate ,
ModifiedUserID ,
HolderGender ,
HolderAddressLine1 ,
HolderAddressLine2 ,
HolderCity ,
HolderState ,
HolderCountry ,
HolderZipCode ,
HolderPhone ,
HolderPhoneExt ,
DependentPolicyNumber ,
Notes ,
Phone ,
PhoneExt ,
Fax ,
FaxExt ,
Copay ,
Deductible ,
PatientInsuranceNumber ,
Active ,
PracticeID ,
AdjusterPrefix ,
AdjusterFirstName ,
AdjusterMiddleName ,
AdjusterLastName ,
AdjusterSuffix ,
VendorID ,
VendorImportID ,
InsuranceProgramTypeID ,
GroupName ,
ReleaseOfInformation
)
SELECT distinct
pc.PatientCaseID ,
icp.InsuranceCompanyPlanID ,
3, --ip.Precedence ,
ip.PolicyNumber3 ,
ip.GroupNumber3 ,
CASE WHEN ISDATE(ip.Policy3StartDate) = 1 THEN ip.policy3startdate ELSE NULL END ,
CASE WHEN ISDATE(ip.Policy3EndDate) = 1 THEN ip.policy3enddate ELSE NULL END ,
0, --ip.CardOnFile ,
CASE WHEN  PatientRelationship1 ='' THEN 'S' ELSE NULL END ,
NULL, --ip.HolderPrefix ,
ip.Holder3FirstName ,
ip.Holder3MiddleName ,
ip.Holder3LastName ,
NULL, --ip.Holder3Suffix ,
ip.Holder3dateofbirth ,
ip.Holder3SSN ,
0, --ip.holderthroughemployer ,
ip.Employer3 ,
0, --ip.PatientInsuranceStatusID ,
GETDATE() ,
0 ,
GETDATE() ,
0 ,
ip.holder3Gender ,
ip.holder3street1 ,
ip.holder3street2 ,
ip.Holder3City ,
ip.Holder3State ,
NULL, --ip.HolderCountry ,
ip.Holder3ZipCode ,
NULL, --ip.HolderPhone ,
NULL, --ip.HolderPhoneExt ,
ip.policynumber3 ,
ip.policy3Note ,
NULL, --ip.Phone ,
NULL, --ip.PhoneExt ,
NULL, --ip.Fax ,
NULL, --ip.FaxExt ,
ip.policy3Copay ,
ip.policy3Deductible ,
NULL, --ip.PatientInsuranceNumber , -- ASK SHEA what this number is referring to
1, --ip.active ,
@TargetPracticeID ,
NULL, --ip.AdjusterPrefix ,
NULL, --ip.AdjusterFirstName ,
NULL, --ip.AdjusterMiddleName ,
NULL, --ip.AdjusterLastName ,
NULL, --ip.AdjusterSuffix ,
ip.chartnumber, --ip.InsurancePolicyID ,
@VendorImportID ,
NULL, --ip.insuranceprogramtypeid ,
NULL, --ip.GroupName3 ,
NULL --ip.ReleaseOfInformation
FROM dbo._import_3_11_patientDemographics ip
INNER JOIN dbo.PatientCase pc ON
ip.chartnumber = pc.VendorID AND
pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
ip.insurancecode3 = icp.VendorID AND
icp.VendorImportID = @VendorImportID
WHERE ip.insurancecode3 <> 'patient'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--DROP TABLE #tempdoc , #tempsl , #colcat

--COMMIT
--ROLLBACK
