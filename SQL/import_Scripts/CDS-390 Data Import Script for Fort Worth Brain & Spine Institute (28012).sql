USE superbill_28012_dev
-- USE superbill_28012_prod
GO

SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @VendorImportID2 INT
DECLARE @VendorImportID INT
DECLARE @PracticeID INT

SET @VendorImportID2 = 7
SET @VendorImportID = 8
SET @PracticeID = 1


--8 nextgen
--7 centricity
PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))
PRINT 'VendorImportID2 = ' + CAST(@VendorImportID2 AS VARCHAR(10))


/*
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID2
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID2
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID2
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToAppointmentReason records deleted'
DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID2
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID IN (@VendorImportID,@VendorImportID2))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Alert records deleted'
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID IN (@VendorImportID,@VendorImportID2))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID2
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
DELETE FROM dbo.Employers WHERE CreatedUserID = -50 AND ModifiedUserID = -50
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Employer records deleted'
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID2
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'
DELETE FROM dbo.ServiceLocation WHERE ModifiedUserID = -50 AND CreatedUserID = -50
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Service Location records deleted'
*/

UPDATE dbo.[_import_8_1_Appointment]
SET pernbr = 43299
WHERE patname = 'STOWERS, PATRICIA' AND startdate = '10/27/14 05:15:00'


PRINT ''
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          BillSecondaryInsurance ,
          EClaimsAccepts ,
          BillingFormID ,
		  InsuranceProgramCode ,
          HCFADiagnosisReferenceFormatCode ,
          HCFASameAsInsuredFormatCode ,
          CreatedPracticeID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          SecondaryPrecedenceBillingFormID ,
          VendorID ,
          VendorImportID ,
          NDCFormat ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID 
        )
SELECT DISTINCT
		  payername , -- InsuranceCompanyName - varchar(128)
          addr1 , -- AddressLine1 - varchar(256)
          addr2 , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          [state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
		  CASE WHEN LEN(zip) = 5 THEN zip + 
		 (CASE WHEN LEN(zipplus4) >=1 THEN RIGHT('000' + zipplus4, 4) ELSE '' END) 
		  WHEN LEN(zip) = 4 THEN '0' + zip + 
		 (CASE WHEN LEN(zipplus4) >=1 THEN RIGHT('000' + zipplus4, 4) ELSE '' END)
		  ELSE '' END  , -- ZipCode - varchar(9)
          0 , -- BillSecondaryInsurance - bit
          0 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          'CI' , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          payernamevid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18   -- InstitutionalBillingFormID - int
FROM dbo.[_import_8_1_InsuranceList]
WHERE payername <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Insurance Company Plan...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          Phone ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          CreatedPracticeID ,
          InsuranceCompanyID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
	      InsuranceCompanyName , -- PlanName - varchar(128)
          AddressLine1 , -- AddressLine1 - varchar(256)
          AddressLine2 , -- AddressLine2 - varchar(256)
          City , -- City - varchar(128)
          State , -- State - varchar(2)
          '' , -- Country - varchar(32)
          ZipCode , -- ZipCode - varchar(9)
          Phone , -- Phone - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          InsuranceCompanyID , -- InsuranceCompanyID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Employers...'
INSERT INTO dbo.Employers
        ( EmployerName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID 
        )
SELECT DISTINCT
	      companyname , -- EmployerName - varchar(128)
          addr1 , -- AddressLine1 - varchar(256)
          addr2 , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          state , -- State - varchar(2)
          '' , -- Country - varchar(32)
		  CASE WHEN LEN(zip) = 5 THEN zip + 
		 (CASE WHEN LEN(zipplus4) >=1 THEN RIGHT('000' + zipplus4, 4) ELSE '' END) 
		  WHEN LEN(zip) = 4 THEN '0' + zip + 
		 (CASE WHEN LEN(zipplus4) >=1 THEN RIGHT('000' + zipplus4, 4) ELSE '' END)
		  ELSE '' END ,  -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50  -- ModifiedUserID - int
FROM dbo.[_import_8_1_Employees] WHERE companyname <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Doctor...'
INSERT INTO dbo.Doctor
        ( PracticeID ,
          Prefix ,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          ZipCode ,
          WorkPhone ,
		  WorkPhoneExt ,
          MobilePhone ,
          EmailAddress ,
          Notes ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Degree ,
          VendorID ,
          VendorImportID ,
          FaxNumber ,
          [External] ,
          NPI 
        )
SELECT DISTINCT
		  @PracticeID ,
          '' ,
          firstname ,
          middlename ,
          lastname ,
          suffix ,
          addr1 ,
          addr2 ,
          city ,
          [state] ,
          zip ,
          CASE
		  WHEN LEN(hmphone) >= 10 THEN LEFT(hmphone,10)
		  ELSE '' END  ,
		  CASE
		  WHEN LEN(hmphone) > 10 THEN LEFT(SUBSTRING(hmphone,11,LEN(hmphone)),10)
		  ELSE NULL END ,
          mobilephone ,
          emailaddr ,
          'UPIN: ' + upin ,
          1 ,
          GETDATE() ,
          -50 ,
          GETDATE() ,
          -50 ,
          degree ,
          fullname ,
          @VendorImportID ,
          fax ,
          1 ,
          npi 
FROM dbo.[_import_8_1_ReferringProviders] WHERE hid <> 'y'
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

 

PRINT ''
PRINT 'Inserting Into Patient...'
INSERT INTO dbo.Patient
        ( PracticeID ,
          --ReferringPhysicianID ,
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
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          --PrimaryProviderID ,
          EmployerID ,
          MedicalRecordNumber ,
    --      MobilePhone ,
		  --MobilePhoneExt ,
          PrimaryCarePhysicianID ,
          VendorID ,
          VendorImportID ,
          CollectionCategoryID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled 
        )
SELECT DISTINCT
	      @PracticeID , -- PracticeID - int
        --  CASE i.referring WHEN 'Alford MD, Brent' THEN 
								--(SELECT doctorid from dbo.doctor WHERE LastName = 'ALFORD' AND FirstName = 'BRENT' and [External] = 0)
						  -- WHEN 'CHAUDHARI MD, ALOK' THEN 
								--(SELECT doctorid from dbo.doctor WHERE LastName = 'CHAUDHARI' AND FirstName = 'ALOK' and [External] = 0)
						  -- WHEN 'ELLIS MD, THOMAS' THEN 
								--(SELECT doctorid from dbo.doctor WHERE LastName = 'ELLIS' AND FirstName = 'THOMAS' and [External] = 0)
						  -- WHEN 'EVANS ACNP, AMANDA' THEN 
								--(SELECT doctorid from dbo.doctor WHERE LastName = 'EVANS' AND FirstName = 'AMANDA' and [External] = 0)
						  -- WHEN 'HAQUE MD, ATIF' THEN		
								--(SELECT doctorid from dbo.doctor WHERE LastName = 'HAQUE' AND FirstName = 'ATIF' and [External] = 0)	
						  -- WHEN 'LAPSIWALA MD, SAMIR' THEN 
								--(SELECT doctorid from dbo.doctor WHERE LastName = 'LAPSIWALA' AND FirstName = 'SAMIR' and [External] = 0)
						  -- WHEN 'LEE MD, ANTHONY' THEN 
								--(SELECT doctorid from dbo.doctor WHERE LastName = 'LEE' AND FirstName = 'ANTHONY' and [External] = 0)
						  -- WHEN 'SIADATI MD. AB' THEN 
								--(SELECT doctorid from dbo.doctor WHERE LastName = 'SIADATI' AND FirstName = 'ABDOLREZA' and [External] = 0)
						  -- ELSE rp.doctorid END , -- ReferringPhysicianID - int
          '' , -- Prefix - varchar(16)
          patfirstname , -- FirstName - varchar(64)
          patmiddlename , -- MiddleName - varchar(64)
          patlastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          addr1 , -- AddressLine1 - varchar(256)
          addr2 , -- AddressLine2 - varchar(256)
          i.city , -- City - varchar(128)
          i.state , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(zip) IN (4,8) THEN '0' + zip 
			   WHEN LEN(zip) IN (5,9) THEN zip ELSE '' END , -- ZipCode - varchar(9)
          gen , -- Gender - varchar(1)
          CASE mar WHEN 'X' THEN ''
		           WHEN 'U' THEN '' 
				   ELSE mar END , -- MaritalStatus - varchar(1)
          CASE
		  WHEN LEN(dbo.fn_RemoveNonNumericCharacters(hmphone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(hmphone),10)
		  ELSE '' END , -- HomePhone - varchar(10)
		  CASE
		  WHEN LEN(dbo.fn_RemoveNonNumericCharacters(hmphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(hmphone),11,LEN(dbo.fn_RemoveNonNumericCharacters(hmphone))),10)
		  ELSE NULL END , -- HomePhoneExt - varchar(10)
          CASE WHEN dayphone <> hmphone THEN
		  CASE
		  WHEN LEN(dbo.fn_RemoveNonNumericCharacters(dayphone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(dayphone),10)
		  ELSE '' END ELSE '' END  , -- WorkPhone - varchar(10)
          CASE WHEN dayphone <> hmphone THEN
		  CASE
		  WHEN LEN(dbo.fn_RemoveNonNumericCharacters(dayphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(dayphone),11,LEN(dbo.fn_RemoveNonNumericCharacters(dayphone))),10)
		  ELSE '' END ELSE '' END , -- WorkPhoneExt - varchar(10)
		  birthdt , -- DOB - datetime
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.ssn)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(i.ssn), 9) ELSE '' END , -- SSN - char(9)
          emailaddr , -- EmailAddress - varchar(256)
          0 , -- ResponsibleDifferentThanPatient - bit
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          CASE WHEN i.emp <> '' THEN 'E' ELSE 'U' END , -- EmploymentStatus - char(1)
       --   CASE rendering WHEN 'LAPSIWALA MD, SAMIR' THEN 6
						 --WHEN 'HAQUE MD, ATIF' THEN 5
						 --ELSE NULL END , -- PrimaryProviderID - int
          e.EmployerID , -- EmployerID - int
          'N-' + pernbr  , -- MedicalRecordNumber - varchar(128)
    --      CASE
		  --WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.mobilephone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.mobilephone),10)
		  --ELSE '' END  , -- MobilePhone - varchar(10)
		  --CASE
		  --WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.mobilephone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.mobilephone),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.mobilephone))),10)
		  --ELSE NULL END , --MobilePhoneExt - varchar(10)
          CASE i.primcarephys 
					       WHEN 'Alford MD, Brent' THEN 
								(SELECT doctorid from dbo.doctor WHERE LastName = 'ALFORD' AND FirstName = 'BRENT' and [External] = 0)
						   WHEN 'CHAUDHARI MD, ALOK' THEN 
								(SELECT doctorid from dbo.doctor WHERE LastName = 'CHAUDHARI' AND FirstName = 'ALOK' and [External] = 0)
						   WHEN 'ELLIS MD, THOMAS' THEN 
								(SELECT doctorid from dbo.doctor WHERE LastName = 'ELLIS' AND FirstName = 'THOMAS' and [External] = 0)
						   WHEN 'EVANS ACNP, AMANDA' THEN 
								(SELECT doctorid from dbo.doctor WHERE LastName = 'EVANS' AND FirstName = 'AMANDA' and [External] = 0)
						   WHEN 'HAQUE MD, ATIF' THEN	
								(SELECT doctorid from dbo.doctor WHERE LastName = 'HAQUE' AND FirstName = 'ATIF' and [External] = 0)	
						   WHEN 'LAPSIWALA MD, SAMIR' THEN 
								(SELECT doctorid from dbo.doctor WHERE LastName = 'LAPSIWALA' AND FirstName = 'SAMIR' and [External] = 0)
						   WHEN 'LEE MD, ANTHONY' THEN 
								(SELECT doctorid from dbo.doctor WHERE LastName = 'LEE' AND FirstName = 'ANTHONY' and [External] = 0)
						   WHEN 'SIADATI MD. AB' THEN 
								(SELECT doctorid from dbo.doctor WHERE LastName = 'SIADATI' AND FirstName = 'ABDOLREZA' and [External] = 0)
						   WHEN 'Corder , Kelly' THEN
								(SELECT doctorid from dbo.doctor WHERE LastName = 'CORDER' AND FirstName = 'KELLEY' and [External] = 0)
						   WHEN 'VITOVSKY PA, RODNEY' THEN
								(SELECT doctorid from dbo.doctor WHERE LastName = 'VITOVSKY' AND FirstName = 'RODNEY' and [External] = 0)
						   WHEN 'MASCIO PA, CHRISTOPHER' THEN
								(SELECT doctorid FROM dbo.doctor WHERE LastName = 'MASCIO' AND FirstName = 'CHRISTOPHER' AND [External] = 0)
							WHEN 'LUTRICK PA C, T MARK' THEN
								(SELECT doctorid FROM dbo.doctor WHERE LastName = 'LUTRICK' AND FirstName = 'T.' AND [External] = 0)
						   ELSE NULL END , -- PrimaryCarePhysicianID - int
          pernbr , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- CollectionCategoryID - int
          1 , -- Active - bit
          0 , -- SendEmailCorrespondence - bit
          0  -- PhonecallRemindersEnabled - bit
FROM dbo.[_import_8_1_PatientDemo] i
	--LEFT JOIN dbo.Doctor rp ON
	--	i.referring = rp.VendorID AND
	--	rp.VendorImportID = @VendorImportID
	--LEFT JOIN dbo.Doctor pcp ON 
	--	i.primcarephys = pcp.VendorID AND
	--	pcp.VendorImportID = @VendorImportID
	LEFT JOIN dbo.Employers e ON
		i.emp = e.EmployerName 
WHERE i.pernbr <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Updating Patient Primary and Referring Prov...'
UPDATE dbo.Patient
SET PrimaryProviderID = CASE i.rendering 
					       WHEN 'Alford MD, Brent' THEN 
								(SELECT doctorid from dbo.doctor WHERE LastName = 'ALFORD' AND FirstName = 'BRENT' and [External] = 0)
						   WHEN 'CHAUDHARI MD, ALOK' THEN 
								(SELECT doctorid from dbo.doctor WHERE LastName = 'CHAUDHARI' AND FirstName = 'ALOK' and [External] = 0)
						   WHEN 'ELLIS MD, THOMAS' THEN 
								(SELECT doctorid from dbo.doctor WHERE LastName = 'ELLIS' AND FirstName = 'THOMAS' and [External] = 0)
						   WHEN 'EVANS ACNP, AMANDA' THEN 
								(SELECT doctorid from dbo.doctor WHERE LastName = 'EVANS' AND FirstName = 'AMANDA' and [External] = 0)
						   WHEN 'HAQUE MD, ATIF' THEN	
								(SELECT doctorid from dbo.doctor WHERE LastName = 'HAQUE' AND FirstName = 'ATIF' and [External] = 0)	
						   WHEN 'LAPSIWALA MD, SAMIR' THEN 
								(SELECT doctorid from dbo.doctor WHERE LastName = 'LAPSIWALA' AND FirstName = 'SAMIR' and [External] = 0)
						   WHEN 'LEE MD, ANTHONY' THEN 
								(SELECT doctorid from dbo.doctor WHERE LastName = 'LEE' AND FirstName = 'ANTHONY' and [External] = 0)
						   WHEN 'SIADATI MD. AB' THEN 
								(SELECT doctorid from dbo.doctor WHERE LastName = 'SIADATI' AND FirstName = 'ABDOLREZA' and [External] = 0)
						   WHEN 'Corder , Kelly' THEN
								(SELECT doctorid from dbo.doctor WHERE LastName = 'CORDER' AND FirstName = 'KELLEY' and [External] = 0)
						   WHEN 'VITOVSKY PA, RODNEY' THEN
								(SELECT doctorid from dbo.doctor WHERE LastName = 'VITOVSKY' AND FirstName = 'RODNEY' and [External] = 0)
						   WHEN 'MASCIO PA, CHRISTOPHER' THEN
								(SELECT doctorid FROM dbo.doctor WHERE LastName = 'MASCIO' AND FirstName = 'CHRISTOPHER' AND [External] = 0)
							WHEN 'LUTRICK PA C, T MARK' THEN
								(SELECT doctorid FROM dbo.doctor WHERE LastName = 'LUTRICK' AND FirstName = 'T.' AND [External] = 0)
						   ELSE rp.DoctorID END  ,
	ReferringPhysicianID = CASE i.referring 
					       WHEN 'Alford MD, Brent' THEN 
								(SELECT doctorid from dbo.doctor WHERE LastName = 'ALFORD' AND FirstName = 'BRENT' and [External] = 0)
						   WHEN 'CHAUDHARI MD, ALOK' THEN 
								(SELECT doctorid from dbo.doctor WHERE LastName = 'CHAUDHARI' AND FirstName = 'ALOK' and [External] = 0)
						   WHEN 'ELLIS MD, THOMAS' THEN 
								(SELECT doctorid from dbo.doctor WHERE LastName = 'ELLIS' AND FirstName = 'THOMAS' and [External] = 0)
						   WHEN 'EVANS ACNP, AMANDA' THEN 
								(SELECT doctorid from dbo.doctor WHERE LastName = 'EVANS' AND FirstName = 'AMANDA' and [External] = 0)
						   WHEN 'HAQUE MD, ATIF' THEN	
								(SELECT doctorid from dbo.doctor WHERE LastName = 'HAQUE' AND FirstName = 'ATIF' and [External] = 0)	
						   WHEN 'LAPSIWALA MD, SAMIR' THEN 
								(SELECT doctorid from dbo.doctor WHERE LastName = 'LAPSIWALA' AND FirstName = 'SAMIR' and [External] = 0)
						   WHEN 'LEE MD, ANTHONY' THEN 
								(SELECT doctorid from dbo.doctor WHERE LastName = 'LEE' AND FirstName = 'ANTHONY' and [External] = 0)
						   WHEN 'SIADATI MD. AB' THEN 
								(SELECT doctorid from dbo.doctor WHERE LastName = 'SIADATI' AND FirstName = 'ABDOLREZA' and [External] = 0)
						   WHEN 'Corder , Kelly' THEN
								(SELECT doctorid from dbo.doctor WHERE LastName = 'CORDER' AND FirstName = 'KELLEY' and [External] = 0)
						   WHEN 'VITOVSKY PA, RODNEY' THEN
								(SELECT doctorid from dbo.doctor WHERE LastName = 'VITOVSKY' AND FirstName = 'RODNEY' and [External] = 0)
						   WHEN 'MASCIO PA, CHRISTOPHER' THEN
								(SELECT doctorid FROM dbo.doctor WHERE LastName = 'MASCIO' AND FirstName = 'CHRISTOPHER' AND [External] = 0)
					       WHEN 'LUTRICK PA C, T MARK' THEN
								(SELECT doctorid FROM dbo.doctor WHERE LastName = 'LUTRICK' AND FirstName = 'T.' AND [External] = 0)
						   ELSE rp.DoctorID END 
FROM dbo.Patient p 
	INNER JOIN dbo.[_import_8_1_DefaultProviders] i ON
		p.VendorID = i.pernbr AND
		p.VendorImportID = @VendorImportID
	LEFT JOIN dbo.Doctor rp ON
		i.referring = rp.VendorID AND
		rp.VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '


PRINT ''
PRINT 'Inserting Into Patient Case...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          EmploymentRelatedFlag ,
          AutoAccidentRelatedFlag ,
          OtherAccidentRelatedFlag ,
          AbuseRelatedFlag ,
          Notes ,
          ShowExpiredInsurancePolicies ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
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
		  PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          0 , -- EmploymentRelatedFlag - bit
          0 , -- AutoAccidentRelatedFlag - bit
          0 , -- OtherAccidentRelatedFlag - bit
          0 , -- AbuseRelatedFlag - bit
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          0 , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          0 , -- PregnancyRelatedFlag - bit
          1 , -- StatementActive - bit
          0 , -- EPSDT - bit
          0 , -- FamilyPlanning - bit
          1 , -- EPSDTCodeID - int
          0 , -- EmergencyRelated - bit
          0  -- HomeboundRelatedFlag - bit
FROM dbo.Patient 
WHERE VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Patient Alert...'
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
SELECT DISTINCT
		  p.PatientID , -- PatientID - int
          i.alert , -- AlertMessage - text
          1 , -- ShowInPatientFlag - bit
          0 , -- ShowInAppointmentFlag - bit
          0 , -- ShowInEncounterFlag - bit
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          0 , -- ShowInClaimFlag - bit
          0 , -- ShowInPaymentFlag - bit
          0  -- ShowInPatientStatementFlag - bit
FROM dbo.Patient p
	INNER JOIN dbo.[_import_8_1_PatientAlerts] i ON
		p.VendorID = i.pernbr AND 
		p.VendorImportID = @VendorImportID
WHERE i.alert <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Updating Patient Alert with Balances for Existing Alerts...'
UPDATE dbo.PatientAlert
	SET AlertMessage = CAST(pa.AlertMessage AS VARCHAR(MAX)) + ' | ' + i.alert
FROM dbo.PatientAlert pa
	INNER JOIN dbo.Patient p ON 
		pa.PatientID = pa.PatientID AND
		p.VendorImportID = @VendorImportID
	INNER JOIN dbo.[_import_8_1_BalanceAlert] i ON
		i.pid = p.VendorID 
WHERE pa.PatientID = p.PatientID 
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '


PRINT ''
PRINT 'Inserting Into Patient Alert - Balances...'
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
SELECT DISTINCT
		  p.PatientID , -- PatientID - int
          i.alert , -- AlertMessage - text
          1 , -- ShowInPatientFlag - bit
          0 , -- ShowInAppointmentFlag - bit
          0 , -- ShowInEncounterFlag - bit
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          0 , -- ShowInClaimFlag - bit
          0 , -- ShowInPaymentFlag - bit
          0  -- ShowInPatientStatementFlag - bit
FROM dbo.Patient p
	INNER JOIN dbo.[_import_8_1_BalanceAlert] i ON
		p.VendorID = i.pid AND 
		p.VendorImportID = @VendorImportID
	LEFT JOIN dbo.PatientAlert pa ON
		p.PatientID = pa.PatientID 
WHERE i.alert <> '' AND pa.PatientID IS NULL
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



PRINT ''
PRINT 'Updating Patient Alert with Policy Info...'
UPDATE dbo.PatientAlert
	SET AlertMessage = CAST(pa.AlertMessage AS VARCHAR(MAX)) + ' | Duplicate Insurance policy found for this Patient - Please Verify before use!' 
FROM dbo.PatientAlert pa
	INNER JOIN dbo.Patient p ON 
		pa.PatientID = pa.PatientID AND
		p.VendorImportID = @VendorImportID
	INNER JOIN dbo.[_import_8_1_Policy2] i ON
		p.VendorID = i.pernbr
WHERE pa.PatientID = p.PatientID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '


PRINT ''
PRINT 'Inserting Into Patient Alert with Policy Info...'
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
SELECT DISTINCT
		  p.PatientID , -- PatientID - int
          'Duplicate Insurance policy found for this Patient - Please Verify before use!' , -- AlertMessage - text
          1 , -- ShowInPatientFlag - bit
          0 , -- ShowInAppointmentFlag - bit
          0 , -- ShowInEncounterFlag - bit
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          0 , -- ShowInClaimFlag - bit
          0 , -- ShowInPaymentFlag - bit
          0  -- ShowInPatientStatementFlag - bit
FROM dbo.Patient p
	INNER JOIN dbo.[_import_8_1_Policy2] i ON
		p.VendorID = i.pernbr AND 
		p.VendorImportID = @VendorImportID
	LEFT JOIN dbo.PatientAlert pa ON
		p.PatientID = pa.PatientID 
WHERE pa.PatientID IS NULL
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

PRINT ''
PRINT 'Inserting Into Patient Journal Note...'
INSERT INTO dbo.PatientJournalNote
        ( CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PatientID ,
          UserName ,
          SoftwareApplicationID ,
          NoteMessage ,
          NoteTypeCode 
        )
SELECT DISTINCT
		  GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          p.PatientID , -- PatientID - int
          '' , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          'Nextgen MRN: ' + i.mdrc , -- NoteMessage - varchar(max)
          1  -- NoteTypeCode - int
FROM dbo.Patient p
	INNER JOIN dbo.[_import_8_1_PatientDemo] i ON
		p.VendorID = i.pernbr AND 
		p.VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Insurance Policy...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PolicyEndDate ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
		  HolderAddressLine1 ,
		  HolderAddressLine2 ,
		  HolderCity ,
		  HolderState ,
		  HolderZipCode ,
		  HolderCountry ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          DependentPolicyNumber ,
          Notes ,
          Copay ,
          Deductible ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          GroupName ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          i.defcob , -- Precedence - int
          i.polnbr , -- PolicyNumber - varchar(32)
          i.[group] , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(i.poleff) = 1 THEN i.poleff ELSE NULL END , -- PolicyStartDate - datetime
          CASE WHEN ISDATE(i.polexp) = 1 THEN i.polexp ELSE NULL END , -- PolicyEndDate - datetime
          CASE i.relation WHEN 'SELF' THEN 'S'
						  WHEN 'Step Child' THEN 'C'
						  WHEN 'Child, Father is the Patient' THEN 'C' 
						  WHEN 'Child-Insured NOT Respon' THEN 'C'
						  WHEN 'Parent, Child is the Patient' THEN 'C'
						  WHEN 'Grandparent' THEN 'C' 
						  WHEN 'Life Partner' THEN 'U'
						  WHEN 'Spouse' THEN 'U'
						  ELSE 'O' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN i.relation <> 'SELF' THEN '' ELSE NULL END , -- HolderPrefix - varchar(16)
          CASE WHEN i.relation <> 'SELF' THEN i.insfirstname ELSE NULL END , -- HolderFirstName - varchar(64)
          CASE WHEN i.relation <> 'SELF' THEN i.insmiddlename ELSE NULL END , -- HolderMiddleName - varchar(64)  
          CASE WHEN i.relation <> 'SELF' THEN i.inslastname ELSE NULL END , -- HolderLastName - varchar(64)
          CASE WHEN i.relation <> 'SELF' THEN i.inssuffix ELSE NULL END , -- HolderSuffix - varchar(16)
		  CASE WHEN i.relation <> 'SELF' THEN i.addr1 ELSE NULL END ,
		  CASE WHEN i.relation <> 'SELF' THEN i.addr2 ELSE NULL END ,
		  CASE WHEN i.relation <> 'SELF' THEN i.city ELSE NULL END ,
		  CASE WHEN i.relation <> 'SELF' THEN i.[STATE] ELSE NULL END ,
		  CASE WHEN i.relation <> 'SELF' THEN 
			CASE WHEN LEN(i.zip) IN (4,8) THEN '0' + i.zip WHEN LEN(i.zip) IN (5,9) THEN i.zip ELSE '' END ELSE NULL END ,
		  CASE WHEN i.relation <> 'SELF' THEN '' ELSE NULL END ,
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          CASE WHEN i.relation <> 'SELF' THEN i.polnbr ELSE NULL END , -- DependentPolicyNumber - varchar(32)
          note , -- Notes - text
          i.coamt , -- Copay - money
          i.dedamt , -- Deductible - money
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          LEFT(groupname , 14) , -- GroupName - varchar(14)
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_8_1_Policy] i
	INNER JOIN dbo.InsuranceCompanyPlan icp ON
		i.payernamevid = icp.VendorID AND
		icp.VendorImportID = @VendorImportID
	INNER JOIN dbo.PatientCase pc ON
		i.pernbr  = pc.VendorID AND
		pc.VendorImportID = @VendorImportID
WHERE i.defcob <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Insurance Policy 2...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PolicyEndDate ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
		  HolderAddressLine1 ,
		  HolderAddressLine2 ,
		  HolderCity ,
		  HolderState ,
		  HolderZipCode ,
		  HolderCountry ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          DependentPolicyNumber ,
          Notes ,
          Copay ,
          Deductible ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          GroupName ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          i.defcob1 , -- Precedence - int
          i.polnbr , -- PolicyNumber - varchar(32)
          [group] , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(poleff) = 1 THEN poleff ELSE NULL END , -- PolicyStartDate - datetime
          CASE WHEN ISDATE(polexp) = 1 THEN polexp ELSE NULL END , -- PolicyEndDate - datetime
          CASE i.relation WHEN 'SELF' THEN 'S'
						  WHEN 'Step Child' THEN 'C'
						  WHEN 'Child, Father is the Patient' THEN 'C' 
						  WHEN 'Child-Insured NOT Respon' THEN 'C'
						  WHEN 'Parent, Child is the Patient' THEN 'C'
						  WHEN 'Grandparent' THEN 'C' 
						  WHEN 'Life Partner' THEN 'U'
						  WHEN 'Spouse' THEN 'U'
						  ELSE 'O' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN i.relation <> 'SELF' THEN '' ELSE NULL END , -- HolderPrefix - varchar(16)
          CASE WHEN i.relation <> 'SELF' THEN i.insfirstname ELSE NULL END , -- HolderFirstName - varchar(64)
          CASE WHEN i.relation <> 'SELF' THEN i.insmiddlename ELSE NULL END , -- HolderMiddleName - varchar(64)  
          CASE WHEN i.relation <> 'SELF' THEN i.inslastname ELSE NULL END , -- HolderLastName - varchar(64)
          CASE WHEN i.relation <> 'SELF' THEN i.inssuffix ELSE NULL END , -- HolderSuffix - varchar(16)
		  CASE WHEN i.relation <> 'SELF' THEN i.addr1 ELSE NULL END ,
		  CASE WHEN i.relation <> 'SELF' THEN i.addr2 ELSE NULL END ,
		  CASE WHEN i.relation <> 'SELF' THEN i.city ELSE NULL END ,
		  CASE WHEN i.relation <> 'SELF' THEN i.[STATE] ELSE NULL END ,
		  CASE WHEN i.relation <> 'SELF' THEN 
			CASE WHEN LEN(i.zip) IN (4,8) THEN '0' + i.zip WHEN LEN(i.zip) IN (5,9) THEN i.zip ELSE '' END ELSE NULL END ,
		  CASE WHEN i.relation <> 'SELF' THEN '' ELSE NULL END ,
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          CASE WHEN i.relation <> 'SELF' THEN i.polnbr ELSE NULL END , -- DependentPolicyNumber - varchar(32)
          note , -- Notes - text
          coamt , -- Copay - money
          dedamt , -- Deductible - money
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          LEFT(groupname , 14) , -- GroupName - varchar(14)
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_8_1_Policy2] i
	INNER JOIN dbo.InsuranceCompanyPlan icp ON
		i.payername = icp.VendorID AND
		icp.VendorImportID = @VendorImportID
	INNER JOIN dbo.PatientCase pc ON
		i.pernbr  = pc.VendorID AND
		pc.VendorImportID = @VendorImportID
WHERE i.defcob1 <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



PRINT ''
PRINT 'Inserting Into Appointment...'
INSERT INTO dbo.Appointment
        ( PatientID ,
          PracticeID ,
          ServiceLocationID ,
          StartDate ,
          EndDate ,
          AppointmentType ,
          Subject ,
          Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
		  AppointmentResourceTypeID ,
          AppointmentConfirmationStatusCode ,
          PatientCaseID ,
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm 
        )
SELECT DISTINCT
		  p.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          CASE i.locname		WHEN 'Harris Hospital Out Patient' THEN 
									(SELECT servicelocationid FROM dbo.ServiceLocation WHERE BillingName = 'Harris Methodist Hospital Fort W')
								 WHEN 'Harris Hospital In Patient' THEN 
									(SELECT servicelocationid FROM dbo.ServiceLocation WHERE BillingName = 'Harris Methodist Hospital Fort W')
								 WHEN 'Baylor All Saints Hospital OutPatient' THEN 
									(SELECT servicelocationid FROM dbo.ServiceLocation WHERE BillingName = 'Baylor All Saints Hospital')
								 WHEN 'Baylor All Saints Hospital In Patient' THEN 
									(SELECT servicelocationid FROM dbo.ServiceLocation WHERE BillingName = 'Baylor All Saints Hospital')
								 WHEN 'BSHFt Worth Out Patient' THEN 
									(SELECT servicelocationid FROM dbo.ServiceLocation WHERE BillingName = 'Baylor Surgical Hospital of Fort')
								 WHEN 'BSHFt Worth In Patient' THEN 
									(SELECT servicelocationid FROM dbo.ServiceLocation WHERE BillingName = 'Baylor Surgical Hospital of Fort')
								 WHEN 'FP Southlake Out Patient' THEN 
									(SELECT servicelocationid FROM dbo.ServiceLocation WHERE BillingName = 'Forest Park Southlake')
								 WHEN 'FP Southlake In Patient' THEN
									(SELECT servicelocationid FROM dbo.ServiceLocation WHERE BillingName = 'Forest Park Southlake')
								 WHEN 'Fort Worth Brain And Spine Institute' THEN
									(SELECT servicelocationid FROM dbo.ServiceLocation WHERE BillingName = 'Fort Worth Brain & Spine Institute')
								 WHEN 'Granbury Clinic' THEN
									(SELECT servicelocationid FROM dbo.ServiceLocation WHERE BillingName = 'Granbury Clinic')
								 WHEN 'Keller North Fort Worth Clinic' THEN
									(SELECT servicelocationid FROM dbo.ServiceLocation WHERE BillingName = 'Keller North Fort Worth Clinic')
								 ELSE 1 END , -- ServiceLocationID - int
          startdate , -- StartDate - datetime
          enddate , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          pernbr , -- Subject - varchar(64)
          details , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
		  1 , --AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          starttm , -- StartTm - smallint
          endtm  -- EndTm - smallint
FROM dbo.[_import_8_1_Appointment] i
	INNER JOIN dbo.Patient p ON 
		i.pernbr = p.VendorID AND 
		p.VendorImportID = @VendorImportID
	LEFT JOIN dbo.PatientCase pc ON 
		p.PatientID = pc.PatientID AND
		pc.PracticeID = @PracticeID
	INNER JOIN dbo.DateKeyToPractice dk ON	
		dk.PracticeID = @PracticeID AND
		dk.dt = CAST(CAST(i.startdate AS DATE) AS DATETIME)
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


--PRINT ''
--PRINT 'Inserting Into Appointment Reason...'
--INSERT INTO dbo.AppointmentReason
--        ( PracticeID ,
--          Name ,
--          DefaultDurationMinutes ,
--          ModifiedDate 
--        )
--SELECT DISTINCT
--		  @PracticeID , -- PracticeID - int
--          [event] , -- Name - varchar(128)
--          15 , -- DefaultDurationMinutes - int
--          GETDATE()  -- ModifiedDate - datetime
--FROM dbo.[_import_8_1_Appointment] i WHERE NOT EXISTS (SELECT * FROM dbo.AppointmentReason ar WHERE i.[event] = ar.Name) AND
--									 [event] <> ''
--PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


IF NOT EXISTS (SELECT * FROM dbo.PracticeResource WHERE ResourceName = 'HUBBARD MD, RICHARD')   
BEGIN

PRINT ''
PRINT 'Inserting Into Practice Resource...'
INSERT INTO dbo.PracticeResource
        ( PracticeResourceTypeID ,
          PracticeID ,
          ResourceName ,
          ModifiedDate ,
          CreatedDate
        )
VALUES  ( 3 , -- PracticeResourceTypeID - int
          @PracticeID , -- PracticeID - int
          'HUBBARD MD, RICHARD' , -- ResourceName - varchar(50)
          GETDATE() , -- ModifiedDate - datetime
          GETDATE()  -- CreatedDate - datetime
        )
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

END

PRINT ''	
PRINT 'Inserting Into Appointment to Appointment Reason...'
INSERT INTO dbo.AppointmentToAppointmentReason
        ( AppointmentID ,
          AppointmentReasonID ,
          PrimaryAppointment ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT	
		  a.AppointmentID , -- AppointmentID - int
          ar.AppointmentReasonID , -- AppointmentReasonID - int
          1 , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_8_1_Appointment] i
	INNER JOIN dbo.Appointment a ON
		a.StartDate = CAST(i.startdate AS DATETIME) AND
		a.EndDate = CAST(i.enddate AS DATETIME) AND 
		a.[Subject] = i.pernbr
	INNER JOIN dbo.AppointmentReason ar ON
		ar.Name = i.[event] AND
		ar.PracticeID = @PracticeID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Appointment to Resource Type 1...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  a.AppointmentID , -- AppointmentID - int
          1 , -- AppointmentResourceTypeID - int
          CASE i.rendering
						   WHEN 'Alford MD, Brent' THEN 
								(SELECT doctorid from dbo.doctor WHERE LastName = 'ALFORD' AND FirstName = 'BRENT' and [External] = 0)
						   WHEN 'CHAUDHARI MD, ALOK' THEN 
								(SELECT doctorid from dbo.doctor WHERE LastName = 'CHAUDHARI' AND FirstName = 'ALOK' and [External] = 0)
						   WHEN 'ELLIS MD, THOMAS' THEN 
								(SELECT doctorid from dbo.doctor WHERE LastName = 'ELLIS' AND FirstName = 'THOMAS' and [External] = 0)
						   WHEN 'EVANS ACNP, AMANDA' THEN 
								(SELECT doctorid from dbo.doctor WHERE LastName = 'EVANS' AND FirstName = 'AMANDA' and [External] = 0)
						   WHEN 'HAQUE MD, ATIF' THEN	
								(SELECT doctorid from dbo.doctor WHERE LastName = 'HAQUE' AND FirstName = 'ATIF' and [External] = 0)	
						   WHEN 'LAPSIWALA MD, SAMIR' THEN 
								(SELECT doctorid from dbo.doctor WHERE LastName = 'LAPSIWALA' AND FirstName = 'SAMIR' and [External] = 0)
						   WHEN 'LEE MD, ANTHONY' THEN 
								(SELECT doctorid from dbo.doctor WHERE LastName = 'LEE' AND FirstName = 'ANTHONY' and [External] = 0)
						   WHEN 'SIADATI MD. AB' THEN 
								(SELECT doctorid from dbo.doctor WHERE LastName = 'SIADATI' AND FirstName = 'ABDOLREZA' and [External] = 0)
						   WHEN 'Corder , Kelly' THEN
								(SELECT doctorid from dbo.doctor WHERE LastName = 'CORDER' AND FirstName = 'KELLEY' and [External] = 0)
						   WHEN 'VITOVSKY PA, RODNEY' THEN
								(SELECT doctorid from dbo.doctor WHERE LastName = 'VITOVSKY' AND FirstName = 'RODNEY' and [External] = 0)
						   WHEN 'MASCIO PA, CHRISTOPHER' THEN
								(SELECT doctorid FROM dbo.doctor WHERE LastName = 'MASCIO' AND FirstName = 'CHRISTOPHER' AND [External] = 0)
							WHEN 'LUTRICK PA C, T MARK' THEN
								(SELECT doctorid FROM dbo.doctor WHERE LastName = 'LUTRICK' AND FirstName = 'T.' AND [External] = 0)
						   ELSE 2 END , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.Appointment a
	INNER JOIN dbo.[_import_8_1_Appointment] i ON
		a.StartDate = CAST(i.startdate AS DATETIME) AND
		a.EndDate = CAST(i.enddate AS DATETIME) AND
		a.[Subject] = i.pernbr
WHERE i.rendering <> 'HUBBARD MD, RICHARD' AND i.rendering <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



PRINT ''
PRINT 'Inserting Into Appointment to Resource Type 2...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT  
		  a.AppointmentID , -- AppointmentID - int
          2 , -- AppointmentResourceTypeID - int
          pr.PracticeResourceID , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.Appointment a
	INNER JOIN dbo.[_import_8_1_Appointment] i ON
		a.StartDate = CAST(i.startdate AS DATETIME) AND
		a.EndDate = CAST(i.enddate AS DATETIME) AND
		a.[Subject] = i.pernbr
    INNER JOIN dbo.PracticeResource pr ON 
		pr.ResourceName = 'HUBBARD MD, RICHARD' AND
		pr.PracticeID = @PracticeID
WHERE i.rendering = 'HUBBARD MD, RICHARD'
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


--PRINT ''
--PRINT 'Inserting Into Service Location...'
--INSERT INTO dbo.ServiceLocation
--        ( PracticeID ,
--          Name ,
--          AddressLine1 ,
--          AddressLine2 ,
--          City ,
--          State ,
--          Country ,
--          ZipCode ,
--          CreatedDate ,
--          CreatedUserID ,
--          ModifiedDate ,
--          ModifiedUserID ,
--          PlaceOfServiceCode ,
--          BillingName ,
--          Phone ,
--          VendorImportID ,
--          VendorID , 
--		  NPI
--        )
--SELECT DISTINCT		
--		  @PracticeID , -- PracticeID - int
--          servicelocationinternalname , -- Name - varchar(128)
--          servicelocationstreet1 , -- AddressLine1 - varchar(256)
--          servicelocationstreet2 , -- AddressLine2 - varchar(256)
--          servicelocationscity , -- City - varchar(128)
--          LEFT(sercvicelocationsstate, 2) , -- State - varchar(2)
--          '' , -- Country - varchar(32)
--          LEFT(REPLACE(servicelocationzip,'-',''), 9) , -- ZipCode - varchar(9)
--          GETDATE() , -- CreatedDate - datetime
--          -50 , -- CreatedUserID - int
--          GETDATE() , -- ModifiedDate - datetime
--          -50 , -- ModifiedUserID - int
--          CASE placeofservice WHEN 'Office' THEN 11
--							  WHEN 'Outpatient Hospital' THEN 22
--							  WHEN 'Inpatient Hopital' THEN 21
--							  WHEN 'Hospital Emergency Room' THEN 23
--							  ELSE 11 END  , -- PlaceOfServiceCode - char(2)
--          servicelocationbillingname , -- BillingName - varchar(128)
--          LEFT(servicelocationphone , 10) , -- Phone - varchar(10)
--          @VendorImportID2 , -- VendorImportID - int
--          AutoTempID ,  -- VendorID - int
--		  LEFT(servicelocationnpi, 10)
--FROM dbo.[_import_7_1_ServiceLocations]
--WHERE servicelocationbillingname <> ''
--PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


--PRINT ''
--PRINT 'Inserting Into Insurance Company...'
--INSERT INTO dbo.InsuranceCompany
--        ( InsuranceCompanyName ,
--          Notes ,
--          AddressLine1 ,
--          AddressLine2 ,
--          City ,
--          State ,
--          Country ,
--          ZipCode ,
--          Phone ,
--          PhoneExt ,
--          Fax ,
--          FaxExt ,
--          BillSecondaryInsurance ,
--          EClaimsAccepts ,
--          BillingFormID ,
--		  InsuranceProgramCode ,
--          HCFADiagnosisReferenceFormatCode ,
--          HCFASameAsInsuredFormatCode ,
--          CreatedPracticeID ,
--          CreatedDate ,
--          CreatedUserID ,
--          ModifiedDate ,
--          ModifiedUserID ,
--          SecondaryPrecedenceBillingFormID ,
--          VendorID ,
--          VendorImportID ,
--          NDCFormat ,
--          UseFacilityID ,
--          AnesthesiaType ,
--          InstitutionalBillingFormID
--        )
--SELECT DISTINCT
--		  insurancecompanyname , -- InsuranceCompanyName - varchar(128)
--          notes , -- Notes - text
--          insurancestreet1 , -- AddressLine1 - varchar(256)
--          insurancestreet2 , -- AddressLine2 - varchar(256)
--          insurancecity , -- City - varchar(128)
--          LEFT(insurancestate, 2) , -- State - varchar(2)
--          '' , -- Country - varchar(32)
--          CASE WHEN LEN(REPLACE(insurancezip,'-','')) IN (4,8) THEN '0' + REPLACE(insurancezip,'-','')
--			   WHEN LEN(REPLACE(insurancezip,'-','')) IN (5,9) THEN REPLACE(insurancezip,'-','')
--			   ELSE '' END , -- ZipCode - varchar(9)
--          insurancephone , -- Phone - varchar(10)
--          insurancephoneext , -- PhoneExt - varchar(10)
--          insurancefax , -- Fax - varchar(10)
--          insurancefaxext , -- FaxExt - varchar(10)
--          0 , -- BillSecondaryInsurance - bit
--          0 , -- EClaimsAccepts - bit
--          13 , -- BillingFormID - int
--          'CI' , -- InsuranceProgramCode - char(2)
--          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
--          'D' , -- HCFASameAsInsuredFormatCode - char(1)
--          @PracticeID , -- CreatedPracticeID - int
--          GETDATE() , -- CreatedDate - datetime
--          -50 , -- CreatedUserID - int
--          GETDATE() , -- ModifiedDate - datetime
--          -50 , -- ModifiedUserID - int
--          13 , -- SecondaryPrecedenceBillingFormID - int
--          insuranceid , -- VendorID - varchar(50)
--          @VendorImportID2 , -- VendorImportID - int
--          1 , -- NDCFormat - int
--          1 , -- UseFacilityID - bit
--          'U' , -- AnesthesiaType - varchar(1)
--          18  -- InstitutionalBillingFormID - int
--FROM dbo.[_import_7_1_InsuranceList] WHERE insurancecompanyname <> ''
--PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


--PRINT ''
--PRINT 'Inserting Into Insurance Company Plan...'
--INSERT INTO dbo.InsuranceCompanyPlan
--        ( PlanName ,
--          AddressLine1 ,
--          AddressLine2 ,
--          City ,
--          State ,
--          Country ,
--          ZipCode ,
--          Phone ,
--          PhoneExt ,
--          CreatedDate ,
--          CreatedUserID ,
--          ModifiedDate ,
--          ModifiedUserID ,
--          CreatedPracticeID ,
--          Fax ,
--          FaxExt ,
--          InsuranceCompanyID ,
--          VendorID ,
--          VendorImportID 
--        )
--SELECT DISTINCT
--		  InsuranceCompanyName , -- PlanName - varchar(128)
--          AddressLine1 , -- AddressLine1 - varchar(256)
--          AddressLine2 , -- AddressLine2 - varchar(256)
--          City , -- City - varchar(128)
--          State , -- State - varchar(2)
--          Country , -- Country - varchar(32)
--          ZipCode , -- ZipCode - varchar(9)
--          Phone , -- Phone - varchar(10)
--          PhoneExt , -- PhoneExt - varchar(10)
--          GETDATE() , -- CreatedDate - datetime
--          -50 , -- CreatedUserID - int
--          GETDATE() , -- ModifiedDate - datetime
--          -50 , -- ModifiedUserID - int
--          @PracticeID , -- CreatedPracticeID - int
--          Fax , -- Fax - varchar(10)
--          FaxExt , -- FaxExt - varchar(10)
--          InsuranceCompanyID , -- InsuranceCompanyID - int
--          VendorID , -- VendorID - varchar(50)
--          @VendorImportID2  -- VendorImportID - int
--FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID2
--PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Patient...'
INSERT INTO dbo.Patient
        ( PracticeID ,
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
          DefaultServiceLocationID ,
          MedicalRecordNumber ,
          MobilePhone ,
          MobilePhoneExt ,
          PrimaryCarePhysicianID ,
          VendorID ,
          VendorImportID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          rp.DoctorID , -- ReferringPhysicianID - int
          '' , -- Prefix - varchar(16)
          i.firstname  , -- FirstName - varchar(64)
          i.middleinitial  , -- MiddleName - varchar(64)
          i.lastname  , -- LastName - varchar(64)
          i.suffix , -- Suffix - varchar(16)
          i.street1 , -- AddressLine1 - varchar(256)
          i.street2 , -- AddressLine2 - varchar(256)
          i.city , -- City - varchar(128)
          LEFT(i.[state] , 2) , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(REPLACE(i.zipcode,'-',''),' ','') , 9) ,  -- ZipCode - varchar(9)
          CASE WHEN i.gender = '' THEN 'U' ELSE i.gender END , -- Gender - varchar(1)
          i.maritalstatus , -- MaritalStatus - varchar(1)
		  CASE
		  WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.homephone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.homephone),10)
		  ELSE '' END , -- HomePhone - varchar(10)
		  CASE
		  WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.homephone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.homephone),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.homephone))),10)
		  ELSE NULL END  , -- HomePhoneExt - varchar(10)
		  CASE
		  WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.workphone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.workphone),10)
		  ELSE '' END  , -- WorkPhone - varchar(10)
		  CASE
		  WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.workphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.workphone),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.workphone))),10)
		  ELSE NULL END , -- WorkPhoneExt - varchar(10)
          CASE WHEN ISDATE(i.dateofbirth) = 1 THEN i.dateofbirth ELSE NULL END , -- DOB - datetime
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.socialsecuritynumber)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(i.socialsecuritynumber) , 9 ) ELSE '' END , -- SSN - char(9)
          i.email , -- EmailAddress - varchar(256)
          CASE WHEN i.responsiblepartyrelationship <> '' THEN 1 ELSE 0 END , -- ResponsibleDifferentThanPatient - bit
          CASE WHEN i.responsiblepartyrelationship <> '' THEN '' END , -- ResponsiblePrefix - varchar(16)
          CASE WHEN i.responsiblepartyrelationship <> '' THEN i.responsiblepartyfirstname ELSE NULL END , -- ResponsibleFirstName - varchar(64)
          CASE WHEN i.responsiblepartyrelationship <> '' THEN i.responsiblepartymiddlename ELSE NULL END , -- ResponsibleMiddleName - varchar(64)
          CASE WHEN i.responsiblepartyrelationship <> '' THEN i.responsiblepartylastname ELSE NULL END , -- ResponsibleLastName - varchar(64)
          CASE WHEN i.responsiblepartyrelationship <> '' THEN '' ELSE NULL END , -- ResponsibleSuffix - varchar(16)
          CASE WHEN i.responsiblepartyrelationship = '' THEN NULL ELSE i.responsiblepartyrelationship END , -- ResponsibleRelationshipToPatient - varchar(1)
          CASE WHEN i.responsiblepartyrelationship <> '' THEN i.responsiblepartyaddress1 ELSE NULL END, -- ResponsibleAddressLine1 - varchar(256)
          CASE WHEN i.responsiblepartyrelationship <> '' THEN i.responsiblepartyaddress2 ELSE NULL END , -- ResponsibleAddressLine2 - varchar(256)
          CASE WHEN i.responsiblepartyrelationship <> '' THEN i.responsiblepartycity ELSE NULL END , -- ResponsibleCity - varchar(128)
          CASE WHEN i.responsiblepartyrelationship <> '' THEN LEFT(i.responsiblepartystate, 2) ELSE NULL END , -- ResponsibleState - varchar(2)
          CASE WHEN i.responsiblepartyrelationship <> '' THEN '' ELSE NULL END , -- ResponsibleCountry - varchar(32)
          CASE WHEN i.responsiblepartyrelationship <> '' THEN LEFT(REPLACE(i.responsiblepartyzipcode,'-',''), 9) ELSE NULL END  , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          i.employmentstatus , -- EmploymentStatus - char(1)
          CASE i.defaultservicelocation 
				WHEN 'Fort Worth Brain and Spine Institute,LLP' THEN 1
				WHEN '2-FORT WORTH BRAIN AND SPINE INST., LLP' THEN 1
				WHEN 'Harris Methodist' THEN 5
				ELSE NULL END , -- DefaultServiceLocationID - int
          'C-' + i.chartnumber , -- MedicalRecordNumber - varchar(128)
		  CASE
		  WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.cellphone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.cellphone),10)
		  ELSE '' END  , -- MobilePhone - varchar(10)
		  CASE
		  WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.cellphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.cellphone),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.cellphone))),10)
		  ELSE NULL END , -- MobilePhoneExt - varchar(10)
          pcp.DoctorID , -- PrimaryCarePhysicianID - int
          i.chartnumber , -- VendorID - varchar(50)
          @VendorImportID2 , -- VendorImportID - int
          1 , -- Active - bit
          0 , -- SendEmailCorrespondence - bit
            0  -- PhonecallRemindersEnabled - bit
FROM dbo.[_import_7_1_PatientDemographics] i
	LEFT JOIN dbo.Doctor rp ON 
		rp.DoctorID = (SELECT TOP 1 rp1.doctorid FROM dbo.Doctor rp1 
						WHERE rp1.FirstName = referringphysicianfirstname AND rp1.LastName = i.referringphysicianlastname) AND
		rp.PracticeID = @PracticeID
	LEFT JOIN dbo.Doctor pcp ON 
		pcp.DoctorID = (SELECT TOP 1 pcp1.doctorid FROM dbo.Doctor pcp1
						 WHERE pcp1.FirstName = i.primarycarephysicianfirstname AND pcp1.LastName = i.primarycarephysicianlastname) AND
	    pcp.PracticeID = @PracticeID
WHERE i.firstname <> '' AND i.lastname <> '' AND 
NOT EXISTS (SELECT FirstName, LastName, DOB FROM dbo.Patient p 
				WHERE i.firstname = p.FirstName AND
					  i.lastname = p.LastName AND
					  DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME)) = p.DOB)																
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

PRINT ''
PRINT 'Inserting Into Patient Alert...'
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
SELECT DISTINCT
		  p.PatientID , -- PatientID - int
          i.patientalertmessage , -- AlertMessage - text
          1 , -- ShowInPatientFlag - bit
          0 , -- ShowInAppointmentFlag - bit
          0 , -- ShowInEncounterFlag - bit
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          0 , -- ShowInClaimFlag - bit
          0 , -- ShowInPaymentFlag - bit
          0  -- ShowInPatientStatementFlag - bit
FROM dbo.Patient p
	INNER JOIN dbo.[_import_7_1_PatientDemographics] i ON
		p.VendorID = i.chartnumber AND 
		p.VendorImportID = @VendorImportID
WHERE i.patientalertmessage <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

--PRINT ''
--PRINT 'Updating Patient Alert with Balances for Existing Alerts...'
--UPDATE dbo.PatientAlert
--	SET AlertMessage = CAST(pa.AlertMessage AS VARCHAR(MAX)) + ' | ' + i.alert
--FROM dbo.PatientAlert pa
--	INNER JOIN dbo.Patient p ON	
--		pa.PatientID = p.PatientID AND
--		p.VendorImportID = @VendorImportID2
--	INNER JOIN dbo.[_import_7_1_Balances] i ON
--		i.guarantorname = p.LastName + ', ' + p.FirstName + ' ' + p.MiddleName 
--WHERE pa.PatientID = p.PatientID
--PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '



PRINT ''
PRINT 'Inserting into Patient Balance Alert...'
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
SELECT DISTINCT
		  p.PatientID , -- PatientID - int
          i.alert , -- AlertMessage - text
          1 , -- ShowInPatientFlag - bit
          1 , -- ShowInAppointmentFlag - bit
          1 , -- ShowInEncounterFlag - bit
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          1 , -- ShowInClaimFlag - bit
          1 , -- ShowInPaymentFlag - bit
          1  -- ShowInPatientStatementFlag - bit
FROM dbo.[_import_7_1_Balances] i
INNER JOIN dbo.Patient p ON	
	i.guarantorname = p.LastName + ', ' + p.FirstName + ' ' + p.MiddleName AND
	p.VendorImportID = @VendorImportID2
LEFT JOIN dbo.PatientAlert pa ON
	p.PatientID = pa.PatientID
WHERE pa.PatientID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Patient Case...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          EmploymentRelatedFlag ,
          AutoAccidentRelatedFlag ,
          OtherAccidentRelatedFlag ,
          AbuseRelatedFlag ,
          Notes ,
          ShowExpiredInsurancePolicies ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
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
		  PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          0 , -- EmploymentRelatedFlag - bit
          0 , -- AutoAccidentRelatedFlag - bit
          0 , -- OtherAccidentRelatedFlag - bit
          0 , -- AbuseRelatedFlag - bit
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          0 , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID2 , -- VendorImportID - int
          0 , -- PregnancyRelatedFlag - bit
          1 , -- StatementActive - bit
          0 , -- EPSDT - bit
          0 , -- FamilyPlanning - bit
          1 , -- EPSDTCodeID - int
          0 , -- EmergencyRelated - bit
          0  -- HomeboundRelatedFlag - bit
FROM dbo.Patient 
WHERE VendorImportID = @VendorImportID2
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


--PRINT ''
--PRINT 'Inserting Into Insurance Policy...'
--INSERT INTO dbo.InsurancePolicy
--        ( PatientCaseID ,
--          InsuranceCompanyPlanID ,
--          Precedence ,
--          PolicyNumber ,
--          GroupNumber ,
--          PolicyStartDate ,
--          PolicyEndDate ,
--          PatientRelationshipToInsured ,
--          HolderPrefix ,
--          HolderFirstName ,
--          HolderMiddleName ,
--          HolderLastName ,
--          HolderSuffix ,
--          HolderDOB ,
--          HolderSSN ,
--          CreatedDate ,
--          CreatedUserID ,
--          ModifiedDate ,
--          ModifiedUserID ,
--          HolderGender ,
--          HolderAddressLine1 ,
--          HolderAddressLine2 ,
--          HolderCity ,
--          HolderState ,
--          HolderCountry ,
--          HolderZipCode ,
--          DependentPolicyNumber ,
--          Active ,
--          PracticeID ,
--          VendorID ,
--          VendorImportID ,
--          ReleaseOfInformation 
--        )
--SELECT DISTINCT
--		  pc.PatientCaseID , -- PatientCaseID - int
--          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
--          i.[order] , -- Precedence - int
--          i.policynumber1 , -- PolicyNumber - varchar(32)
--          i.groupnumber1 , -- GroupNumber - varchar(32)
--          CASE WHEN ISDATE(i.policy1startdate) = 1 THEN i.policy1startdate ELSE NULL END , -- PolicyStartDate - datetime
--          CASE WHEN ISDATE(i.policy1enddate) = 1 THEN i.policy1enddate ELSE NULL END , -- PolicyEndDate - datetime
--          i.patientrelationship1 , -- PatientRelationshipToInsured - varchar(1)
--          CASE WHEN i.patientrelationship1 <> 'S' THEN '' ELSE NULL END , -- HolderPrefix - varchar(16)
--          CASE WHEN i.patientrelationship1 <> 'S' THEN i.holder1firstname ELSE NULL END , -- HolderFirstName - varchar(64)
--          CASE WHEN i.patientrelationship1 <> 'S' THEN i.holder1middlename ELSE NULL END , -- HolderMiddleName - varchar(64)
--          CASE WHEN i.patientrelationship1 <> 'S' THEN i.holder1lastname ELSE NULL END , -- HolderLastName - varchar(64)
--          CASE WHEN i.patientrelationship1 <> 'S' THEN '' ELSE NULL END , -- HolderSuffix - varchar(16)
--          CASE WHEN i.patientrelationship1 <> 'S' THEN 
--				CASE WHEN ISDATE(i.holder1dateofbirth) = 1 THEN i.holder1dateofbirth ELSE NULL END ELSE NULL END , -- HolderDOB - datetime
--          CASE WHEN i.patientrelationship1 <> 'S' THEN i.holder1ssn ELSE NULL END , -- HolderSSN - char(11)
--          GETDATE() , -- CreatedDate - datetime
--          -50 , -- CreatedUserID - int
--          GETDATE() , -- ModifiedDate - datetime
--          -50 , -- ModifiedUserID - int
--          CASE WHEN i.patientrelationship1 <> 'S' THEN i.holder1gender ELSE NULL END , -- HolderGender - char(1)
--          CASE WHEN i.patientrelationship1 <> 'S' THEN i.holder1street1 ELSE NULL END , -- HolderAddressLine1 - varchar(256)
--          CASE WHEN i.patientrelationship1 <> 'S' THEN i.holder1street2 ELSE NULL END , -- HolderAddressLine2 - varchar(256)
--          CASE WHEN i.patientrelationship1 <> 'S' THEN i.holder1city ELSE NULL END , -- HolderCity - varchar(128)
--          CASE WHEN i.patientrelationship1 <> 'S' THEN i.holder1state ELSE NULL END , -- HolderState - varchar(2)
--          CASE WHEN i.patientrelationship1 <> 'S' THEN '' ELSE NULL END , -- HolderCountry - varchar(32)
--          CASE WHEN i.patientrelationship1 <> 'S' THEN 
--				CASE WHEN LEN(i.holder1zipcode) IN (4,8) THEN '0' + i.holder1zipcode 
--					 WHEN LEN(i.holder1zipcode) IN (5,9) THEN i.holder1zipcode ELSE '' END ELSE NULL END , -- HolderZipCode - varchar(9)
--          CASE WHEN i.patientrelationship1 <> 'S' THEN i.policynumber1 ELSE NULL END , -- DependentPolicyNumber - varchar(32)
--          1 , -- Active - bit
--          @PracticeID , -- PracticeID - int
--          pc.VendorID , -- VendorID - varchar(50)
--          @VendorImportID2 , -- VendorImportID - int
--          'Y'  -- ReleaseOfInformation - varchar(1)
--FROM dbo.[_import_7_1_PatientInsurance] i
--	INNER JOIN dbo.PatientCase pc ON 
--		i.chartnumber = pc.VendorID AND
--		pc.VendorImportID = @VendorImportID2
--	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
--		i.insurancecode1 = icp.VendorID AND
--		icp.VendorImportID = @VendorImportID2
--WHERE i.[order] <> ''
--PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


--PRINT ''
--PRINT 'Inserting Into Contract and Fees Contract Rate Schedule...'
--INSERT INTO dbo.ContractsAndFees_ContractRateSchedule
--        ( PracticeID ,
--          InsuranceCompanyID ,
--          EffectiveStartDate ,
--          EffectiveEndDate ,
--          SourceType ,
--          SourceFileName ,
--          EClaimsNoResponseTrigger ,
--          PaperClaimsNoResponseTrigger ,
--          AddPercent ,
--          AnesthesiaTimeIncrement ,
--          Capitated
--        )
--SELECT DISTINCT
--	      1 , -- PracticeID - int
--          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
--          GETDATE() , -- EffectiveStartDate - datetime
--          DATEADD(dd, -1, DATEADD(yy, 1, GETDATE())) , -- EffectiveEndDate - datetime
--          'F' , -- SourceType - char(1)
--          'Import File' , -- SourceFileName - varchar(256)
--          45 , -- EClaimsNoResponseTrigger - int
--          45 , -- PaperClaimsNoResponseTrigger - int
--          0 , -- AddPercent - decimal
--          15 , -- AnesthesiaTimeIncrement - int
--          0  -- Capitated - bit
--FROM dbo.[_import_7_1_InsuranceSpecificFeeSchedule] i
--INNER JOIN dbo.InsuranceCompany ic ON
--	ic.InsuranceCompanyID IN (SELECT ic.InsuranceCompanyID FROM dbo.InsuranceCompany ic2
--									INNER JOIN dbo.[_import_7_1_InsuranceList] i ON
--										ic2.VendorID = i.insuranceid AND
--										ic2.VendorImportID = @VendorImportID2) AND 
--	ic.VendorImportID = @VendorImportID2 --VendorImportID
--PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



--PRINT ''
--PRINT 'Inserting Into Contracts and Fees Contract Rate...'
--INSERT INTO dbo.ContractsAndFees_ContractRate
--        ( ContractRateScheduleID ,
--          ProcedureCodeID ,
--          SetFee ,
--          AnesthesiaBaseUnits
--        )
--SELECT DISTINCT
--		  crs.ContractRateScheduleID , -- ContractRateScheduleID - int
--          pcd.ProcedureCodeDictionaryID , -- ProcedureCodeID - int
--          ifm.standardfee , -- SetFee - money
--          0  -- AnesthesiaBaseUnits - int
--FROM dbo.ContractsAndFees_ContractRateSchedule crs
--	INNER JOIN dbo.[_import_7_1_InsuranceSpecificFeeSchedule] ifm ON
--		crs.InsuranceCompanyID IN (SELECT ic.InsuranceCompanyID FROM dbo.InsuranceCompany ic
--									INNER JOIN dbo.[_import_7_1_InsuranceList] i ON
--										ic.VendorID = i.insuranceid AND
--										ic.VendorImportID = @VendorImportID2
--									WHERE i.insuranceid = ifm.insurancecode)
--	INNER JOIN dbo.ProcedureCodeDictionary pcd ON
--		pcd.ProcedureCode = ifm.cpt
--PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



--PRINT ''
--PRINT 'Inserting Into Contracts and Fees Contract Rate Schedule Link...'
--INSERT INTO dbo.ContractsAndFees_ContractRateScheduleLink
--        ( ProviderID ,
--          LocationID ,
--          ContractRateScheduleID
--        )
--SELECT  
--		  d.DoctorID , -- ProviderID - int
--          sl.ServiceLocationID , -- LocationID - int
--          crs.ContractRateScheduleID  -- ContractRateScheduleID - int
--FROM dbo.Doctor d , dbo.ServiceLocation sl , dbo.ContractsAndFees_ContractRateSchedule crs
--WHERE d.PracticeID = @PracticeID AND
--	d.[External] = 0 AND
--	sl.PracticeID = @PracticeID AND
--	crs.InsuranceCompanyID IN (SELECT InsuranceCompanyID  FROM dbo.InsuranceCompany ic WHERE ic.CreatedPracticeID = @PracticeID) AND
--	crs.PracticeID = @PracticeID
--PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



PRINT ''
PRINT 'Inserting into Standard Fee Schedule...'
      INSERT INTO dbo.ContractsAndFees_StandardFeeSchedule
                  ( PracticeID ,
                    Name ,
                    Notes ,
                    EffectiveStartDate ,
                    SourceType ,
                    SourceFileName ,
                    EClaimsNoResponseTrigger ,
                    PaperClaimsNoResponseTrigger ,
                    AddPercent ,
                    AnesthesiaTimeIncrement
                  )
      VALUES  
                  ( 
                    @PracticeID , -- PracticeID - int
                    'Default Contract' , -- Name - varchar(128)
                    'Vendor Import ' + CAST(@VendorImportID2 AS VARCHAR) , -- Notes - varchar(1024)
                    GETDATE() , -- EffectiveStartDate - datetime
                    'F' , -- SourceType - char(1)
                    'Import File' , -- SourceFileName - varchar(256)
                    30 , -- EClaimsNoResponseTrigger - int
                    30 , -- PaperClaimsNoResponseTrigger - int
                    0 , -- AddPercent - decimal
                    15  -- AnesthesiaTimeIncrement - int
                  )
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Standard Fee...'
      INSERT INTO dbo.ContractsAndFees_StandardFee
                  ( StandardFeeScheduleID ,
                    ProcedureCodeID ,
                    SetFee ,
                    AnesthesiaBaseUnits
                  )
      SELECT DISTINCT
                    sfs.[StandardFeeScheduleID], -- StandardFeeScheduleID - int
                    pcd.[ProcedureCodeDictionaryID] , -- ProcedureCodeID - int
                    i.standardfee , -- SetFee - money
                    0  -- AnesthesiaBaseUnits - int
      FROM dbo.[_import_7_1_StandardFeeSchedule] AS i
      INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule AS sfs ON
            CAST(sfs.[Notes] AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID2 AS VARCHAR) AND
            sfs.PracticeID = @PracticeID  
      INNER JOIN dbo.ProcedureCodeDictionary AS pcd ON
            pcd.[ProcedureCode] = i.cpt
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Standard Fee Schedule Link...'
      INSERT INTO dbo.ContractsAndFees_StandardFeeScheduleLink
                  ( ProviderID ,
                    LocationID ,
                    StandardFeeScheduleID
                  )
      SELECT DISTINCT
                    doc.[DoctorID] , -- ProviderID - int
                    sl.[ServiceLocationID] , -- LocationID - int
                    sfs.[StandardFeeScheduleID]  -- StandardFeeScheduleID - int
      FROM dbo.Doctor AS doc, dbo.ServiceLocation AS sl, dbo.ContractsAndFees_StandardFeeSchedule AS sfs
      WHERE doc.[External] = 0 AND
            doc.[PracticeID] = @PracticeID AND
            sl.PracticeID = @PracticeID AND
            sfs.[Notes] = 'Vendor Import ' + CAST(@VendorImportID2 AS VARCHAR) AND
            sfs.PracticeID = @PracticeID    
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Patient Cases that do not have policies...'
UPDATE dbo.PatientCase 
      SET PayerScenarioID = 11 , 
		  Name = 'Self Pay'
      FROM dbo.PatientCase pc
      LEFT JOIN dbo.InsurancePolicy ip ON
            pc.PatientCaseID = ip.PatientCaseID  AND
			pc.VendorImportID IN (@VendorImportID , @VendorImportID2)
      WHERE 
              PayerScenarioID = 5 AND 
              ip.PatientCaseID IS NULL 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



--ROLLBACK
--COMMIT

