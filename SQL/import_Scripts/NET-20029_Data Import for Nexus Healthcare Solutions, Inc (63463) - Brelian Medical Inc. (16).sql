USE superbill_63463_prod
GO
--SELECT * FROM dbo.ServiceLocation WHERE PracticeID=15
SET XACT_ABORT ON

SET NOCOUNT ON 

BEGIN TRANSACTION
--rollback
--commit 

DECLARE @TargetPracticeID INT
DECLARE @SourcePracticeID INT
DECLARE @VendorImportID INT

SET @TargetPracticeID = 16
SET @SourcePracticeID = 6
SET @VendorImportID = 14

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



--*/
-----NOT PRACTICEID 6***************************************** ------ENTERING INSURANCE COMPANY FROM PRACTICE 6 THAT DON"T ALREADY EXIST
SELECT Distinct

ic.insurancecompanyname , -- InsuranceCompanyName - varchar(128)
NULL,--ic.notes , -- Notes - text
NULL, --i.address1 , -- AddressLine1 - varchar(256)
NULL, --NULL, --i.address2 , -- AddressLine2 - varchar(256)
NULL, --i.city , -- City - varchar(128)
NULL, --i.state , -- State - varchar(2)
NULL, --i.country , -- Country - varchar(32)
NULL, --LEFT(CASE 
--WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.zip)
--WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.zip)
--ELSE '' END,9) , -- ZipCode - varchar(9)
NULL, --ic.contactprefix , -- ContactPrefix - varchar(16)
NULL, --ic.contactfirstname , -- ContactFirstName - varchar(64)
NULL, --ic.contactmiddlename , -- ContactMiddleName - varchar(64)
NULL, --ic.contactlastname , -- ContactLastName - varchar(64)
NULL, --ic.contactsuffix , -- ContactSuffix - varchar(16)
NULL, --CASE
--WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.phone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.phone),10)
--ELSE '' END , -- HomePhone - varchar(10)
NULL, --i.phoneext , -- PhoneExt - varchar(10)
NULL, --i.fax , -- Fax - varchar(10)
NULL, --i.faxext , -- FaxExt - varchar(10)
ic.billsecondaryinsurance , -- BillSecondaryInsurance - bit
ic.eclaimsaccepts , -- EClaimsAccepts - bit
ic.billingformid , -- BillingFormID - int
ic.insuranceprogramcode , -- InsuranceProgramCode - char(2)
ic.hcfadiagnosisreferenceformatcode , -- HCFADiagnosisReferenceFormatCode - char(1)
ic.hcfasameasinsuredformatcode , -- HCFASameAsInsuredFormatCode - char(1)
NULL, --ic.localusefieldtypecode , -- LocalUseFieldTypeCode - char(5)
'' , -- ReviewCode - char(1)''
NULL, --ic.companytextid , -- CompanyTextID - varchar(10)
ic.clearinghousepayerid , -- ClearinghousePayerID - int
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
FROM dbo._import_14_16_Insurancecompanyplanlist i
INNER JOIN dbo.InsuranceCompany IC ON i.insurancecompanyname=ic.InsuranceCompanyName AND ic.CreatedPracticeID = @SourcePracticeID
LEFT JOIN dbo.InsuranceCompany IC2 ON i.insurancecompanyname=ic2.InsuranceCompanyName AND ic2.CreatedPracticeID=@TargetPracticeID
WHERE ic2.insurancecompanyname IS null
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


-----------------Not Practice 6 #2

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
SELECT DISTINCT
i.insurancecompanyname , -- InsuranceCompanyName - varchar(128)
NULL,--.notes , -- Notes - text
NULL, -- AddressLine1 - varchar(256)
NULL, -- AddressLine2 - varchar(256)
NULL, -- City - varchar(128)
NULL, -- State - varchar(2)
NULL, --ic.country , -- Country - varchar(32)
NULL, -- ZipCode - varchar(9)
NULL, --ic.contactprefix , -- ContactPrefix - varchar(16)
i.contactfirstname , -- ContactFirstName - varchar(64)
NULL, --ic.contactmiddlename , -- ContactMiddleName - varchar(64)
i.contactlastname , -- ContactLastName - varchar(64)
NULL, --ic.contactsuffix , -- ContactSuffix - varchar(16)
NULL, -- HomePhone - varchar(10)
i.phoneext , -- PhoneExt - varchar(10)
NULL, -- Fax - varchar(10)
NULL, -- FaxExt - varchar(10)
'', --ic.billsecondaryinsurance , -- BillSecondaryInsurance - bit
'', --ic.eclaimsaccepts , -- EClaimsAccepts - bit
'', --ic.billingformid , -- BillingFormID - int
'CI', --ic.insuranceprogramcode , -- InsuranceProgramCode - char(2)
'R', --ic.hcfadiagnosisreferenceformatcode , -- HCFADiagnosisReferenceFormatCode - char(1)
'D', --ic.hcfasameasinsuredformatcode , -- HCFASameAsInsuredFormatCode - char(1)
NULL, --ic.localusefieldtypecode , -- LocalUseFieldTypeCode - char(5)
'' , -- ReviewCode - char(1)
NULL, --ic.companytextid , -- CompanyTextID - varchar(10)
ic2.clearinghousepayerid , -- ClearinghousePayerID - int
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

FROM dbo._import_14_16_Insurancecompanyplanlist i
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
ic.InsuranceCompanyID , -- InsuranceCompanyID - int
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
ptic.insurancecompanyid = ic.VendorID AND
ic.VendorImportID = @VendorImportID AND ic.CreatedPracticeID=@SourcePracticeID
WHERE ptic.practiceid = @SourcePracticeID
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


FROM dbo._import_14_16_Insurancecompanyplanlist i
INNER JOIN dbo.InsuranceCompany ic ON i.insurancecompanyname = ic.InsuranceCompanyName AND 
--ic.VendorImportID =@VendorImportID AND -- @VendorImportID 
ic.CreatedPracticeID=@TargetPracticeID--@targetpracticeid 
LEFT JOIN dbo.InsuranceCompanyPlan a ON i.planname=a.PlanName AND a.CreatedPracticeID=@TargetPracticeID
WHERE a.planname IS NULL

PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
--rollback