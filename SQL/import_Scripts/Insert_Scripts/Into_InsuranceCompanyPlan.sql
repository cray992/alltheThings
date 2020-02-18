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
FROM dbo._import_2_6_Insurancecompanyplanlist i
INNER JOIN dbo.InsuranceCompany ic ON i.insurancecompanyname = ic.InsuranceCompanyName AND 
--ic.VendorImportID =2-- @VendorImportID AND 
ic.CreatedPracticeID=6--@targetpracticeid 
LEFT JOIN dbo.InsuranceCompanyPlan a ON i.planname=a.PlanName AND a.CreatedPracticeID=6
WHERE a.planname IS NULL

PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '