USE superbill_52276_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT
DECLARE @Timezone INT

SET @PracticeID = 1
SET @VendorImportID = 1
SET @Timezone = 3 -- EST 3 , CST 2 , MST 1 , PST 0 , Hawaii -3 (Depending on DST) , Arizona - 1 (Depending on DST)

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

/*==========================================================================*/
 --FOR DB-13 ONLY -- 
--UPDATE PATIENTS WITH CORRECT DEMOGRAPHIC INFO FROM SUPPORT TOOLS EXPORT--

--CREATE TABLE #updatepat (PatientID INT , DateofBirth DATETIME , SSN VARCHAR(9))
--INSERT INTO #updatepat (PatientID, DateofBirth) 
--SELECT DISTINCT
--		     p.PatientID , -- PatientID - int
--			 DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME))  -- DateofBirth - 
--FROM dbo.Patient p 
--INNER JOIN dbo.[_import_2_1_PatientDemographics] i ON p.PatientID = i.id

--PRINT ''
--PRINT 'Updating Existing Patients Demographics...'
--UPDATE dbo.Patient 
--	SET DOB = i.DateofBirth  
--FROM #updatepat i 
--INNER JOIN dbo.Patient p ON
--	p.PatientID = i.patientid
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--DROP TABLE #updatepat

/*==========================================================================*/

/*
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'
DELETE FROM dbo.Claim WHERE EncounterProcedureID IN (SELECT EncounterProcedureID FROM dbo.EncounterProcedure WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Claim records deleted'
DELETE FROM dbo.EncounterDiagnosis WHERE EncounterID IN (SELECT EncounterID FROM dbo.Encounter WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Encounter Diagnosis records deleted'
DELETE FROM dbo.EncounterProcedure WHERE EncounterID IN (SELECT EncounterID FROM dbo.Encounter WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Encounter Procedure records deleted'
DELETE FROM dbo.Encounter WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Encounter records deleted'
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
--DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
--DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
DELETE FROM dbo.PatientCaseDate WHERE PatientCaseID IN (SELECT PatientCaseID FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case Date records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
DELETE FROM dbo.Employers WHERE CreatedUserID = 0 AND ModifiedUserID = 0
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Employer records deleted'
*/

PRINT ''
PRINT 'Updating Existing Patients with VendorID...'
UPDATE dbo.Patient 
	SET VendorID = i.patientuid
FROM dbo._import_1_1_PatientInfo i
	INNER JOIN dbo.Patient p ON 
		p.PatientID = (SELECT MAX(p2.patientid) FROM dbo.Patient p2 WHERE 
					   i.firstname = p2.FirstName AND i.lastname = p2.LastName AND p2.DOB = DATEADD(hh,12,CAST(i.dob AS DATETIME)) AND p2.PracticeID = @PracticeID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Inserting Into #tempins....'
CREATE TABLE #tempins (carriername VARCHAR(128) , address1 VARCHAR(256) , address2 VARCHAR(256) , city VARCHAR(128) , [state] VARCHAR(2) ,
					   zipcode VARCHAR(9) , contactname VARCHAR(64) , eligibilityphonenumber VARCHAR(25) , eligibilityphoneextension VARCHAR(25) , 
					   preauthphonenumber VARCHAR(25) , preauthphoneextension VARCHAR(25) , providerrelationsphonenumber VARCHAR(25) , 
					   providerrelationsphoneextension VARCHAR(25) , emailaddress VARCHAR(256) , faxnumber VARCHAR(10) , standardcopaydollaramt MONEY ,
					   carrieruid VARCHAR(50))
INSERT INTO #tempins
        ( carriername ,
          address1 ,
          address2 ,
          city ,
          state ,
          zipcode ,
          contactname ,
          eligibilityphonenumber ,
          eligibilityphoneextension ,
          preauthphonenumber ,
          preauthphoneextension ,
          providerrelationsphonenumber ,
          providerrelationsphoneextension ,
          emailaddress ,
          faxnumber ,
          standardcopaydollaramt ,
          carrieruid
        )
SELECT DISTINCT
		  icar.carriername , -- PlanName - varchar(128)
          icar.address2 , -- AddressLine1 - varchar(256)
          icar.address1 , -- AddressLine2 - varchar(256)
          icar.city , -- City - varchar(128)
          icar.[state] , -- State - varchar(2)
          LEFT(REPLACE(icar.zipcode,'-',''),9) , -- ZipCode - varchar(9)
          LEFT(icar.contactname,64) , -- ContactFirstName - varchar(64)
          icar.eligibilityphonenumber ,
		  icar.eligibilityphoneextension ,
		  icar.preauthphonenumber ,
		  icar.preauthphoneextension ,
		  icar.providerrelationsphonenumber ,
		  icar.providerrelationsphoneextension ,
		  icar.emailaddress ,
          dbo.fn_RemoveNonNumericCharacters(icar.faxnumber) , -- Fax - varchar(10)
          icar.standardcopaydollaramt , -- Copay - money
          icar.carrieruid  -- VendorID - varchar(50)
FROM dbo._import_1_1_Coverages ic 
	INNER JOIN dbo.Patient p ON 
		ic.patientfid = p.VendorID AND 
		p.PracticeID = 1
	INNER JOIN dbo._import_1_1_ChargeDetail icd ON 
		p.VendorID = icd.patientfid
	INNER JOIN dbo._import_1_1_Carriers icar ON 
		ic.carrierfid = icar.carrieruid
WHERE icd.patbalance > '0.00' OR icd.insbalance > '0.00'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

-- Updated ICP records with VendorID and avoiding duplicate records based on join as no names match 1 to 1
-- Not in records will be imported as new companies and plans due to existing duplicates on join

PRINT ''
PRINT 'Update Insurance Company Plan with VendorID...'
UPDATE dbo.InsuranceCompanyPlan
	SET VendorID = i.carrieruid , 
		VendorImportID = @VendorImportID
FROM dbo.InsuranceCompanyPlan icp
	INNER JOIN #tempins i ON
		icp.AddressLine1 = RTRIM(LTRIM(i.address2)) AND
		icp.City = i.city AND
        icp.ZipCode = dbo.fn_RemoveNonNumericCharacters(i.zipcode)
WHERE i.carrieruid NOT IN ('40096','41179','41184','43401','41630','39863','39871','39875','39982','43442','39958') 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating ICP Vendorid into IC...'
UPDATE dbo.InsuranceCompany 
	SET VendorID = icp.VendorID
FROM dbo.InsuranceCompany ic
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		ic.InsuranceCompanyID = icp.InsuranceCompanyID
WHERE icp.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Inserting Insurance Company Plan - Existing Company...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
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
          ReviewCode ,
          CreatedPracticeID ,
          Fax ,
          InsuranceCompanyID ,
          Copay ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  i.carriername , -- PlanName - varchar(128)
          i.address2 , -- AddressLine1 - varchar(256)
          i.address1 , -- AddressLine2 - varchar(256)
          i.city , -- City - varchar(128)
          i.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(i.zipcode,'-',''),9) , -- ZipCode - varchar(9)
          '' , -- ContactPrefix - varchar(16)
          LEFT(i.contactname,64) , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64)
          '' , -- ContactSuffix - varchar(16) 
          '' , -- Phone - varchar(10)
          '' , -- PhoneExt - varchar(10)
          CASE WHEN i.eligibilityphonenumber = '' THEN '' ELSE 'Eligibility Phone: ' + i.eligibilityphonenumber + ' ' + i.eligibilityphoneextension + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.preauthphonenumber = '' THEN '' ELSE 'PreAuth Phone: ' + i.preauthphonenumber + ' ' + i.preauthphoneextension + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.providerrelationsphonenumber = '' THEN '' ELSE 'Provider Relations Phone: ' + i.providerrelationsphonenumber + ' ' + i.providerrelationsphoneextension + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.emailaddress = '' THEN '' ELSE 'Email: ' + i.emailaddress END , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          '' , -- ReviewCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          dbo.fn_RemoveNonNumericCharacters(i.faxnumber) , -- Fax - varchar(10)
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          i.standardcopaydollaramt , -- Copay - money
          i.carrieruid , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM #tempins i
INNER JOIN dbo.InsuranceCompany ic ON
	ic.InsuranceCompanyID = (SELECT MIN(InsuranceCompanyID) FROM dbo.InsuranceCompany
								WHERE i.carriername = InsuranceCompanyName AND
									(ReviewCode = 'R' OR CreatedPracticeID = @PracticeID))
LEFT JOIN dbo.InsuranceCompanyPlan icp ON 
	i.carrieruid = icp.VendorID 
WHERE icp.InsuranceCompanyPlanID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurane Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          Notes ,
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
		  i.carriername , -- InsuranceCompanyName - varchar(128)
		  CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' ,
          1 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          'CI' , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          i.carrieruid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM #tempins i
LEFT JOIN dbo.InsuranceCompany ic ON 
	i.carrieruid = ic.VendorID
LEFT JOIN dbo.InsuranceCompanyPlan icp ON 
	i.carrieruid = icp.VendorID
WHERE ic.InsuranceCompanyID IS NULL AND icp.InsuranceCompanyPlanID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurane Company Plan...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
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
          CreatedPracticeID ,
          Fax ,
          InsuranceCompanyID ,
          Copay ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  i.carriername , -- PlanName - varchar(128)
          i.address1 , -- AddressLine1 - varchar(256)
          i.address2 , -- AddressLine2 - varchar(256)
          i.city , -- City - varchar(128)
          i.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(i.zipcode,'-',''),9)  , -- ZipCode - varchar(9)
          '' , -- ContactPrefix - varchar(16)
          LEFT(i.contactname,64) , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64)
          '' , -- ContactSuffix - varchar(16) 
          '' , -- Phone - varchar(10)
          '' , -- PhoneExt - varchar(10)
          CASE WHEN i.eligibilityphonenumber = '' THEN '' ELSE 'Eligibility Phone: ' + i.eligibilityphonenumber + i.eligibilityphoneextension + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.preauthphonenumber = '' THEN '' ELSE 'PreAuth Phone: ' + i.preauthphonenumber + i.preauthphoneextension + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.providerrelationsphonenumber = '' THEN '' ELSE 'Provider Relations Phone: ' + i.providerrelationsphonenumber + i.providerrelationsphoneextension + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.emailaddress = '' THEN '' ELSE 'Email: ' + i.emailaddress END , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          dbo.fn_RemoveNonNumericCharacters(i.faxnumber) , -- Fax - varchar(10)
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          i.standardcopaydollaramt , -- Copay - money , -- Copay - money
          i.carrieruid , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM #tempins i
INNER JOIN dbo.InsuranceCompany ic ON
	ic.VendorID = i.carrieruid AND
	ic.VendorImportID = @VendorImportID
LEFT JOIN dbo.InsuranceCompanyPlan icp ON 
	i.carrieruid = icp.VendorID 
WHERE icp.InsuranceCompanyPlanID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

UPDATE dbo._import_1_1_Facilities 
SET address2 = 
CASE address2 
	 WHEN '2525 NW LOVEJOY ST' THEN '2525 NW Lovejoy St'
	 WHEN '1005 COUGAR STREET' THEN '1005 Cougar St'
	 WHEN '5311 N VANCOUVER AVENUE' THEN '5311 N Vancouver Ave'
END

PRINT ''
PRINT 'Updating Existing Service Locations with VendorID...'
UPDATE dbo.ServiceLocation 
	SET VendorID = i.facilityuid
FROM dbo.ServiceLocation sl 
INNER JOIN dbo.[_import_1_1_Facilities] i ON 
	sl.AddressLine1 = i.address2 AND 
	sl.[State] = i.[state]
WHERE sl.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Inserting Into Patient Case - Balance Forward...'
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
          'Balance Forward' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          0 , -- EmploymentRelatedFlag - bit
          0 , -- AutoAccidentRelatedFlag - bit
          0 , -- OtherAccidentRelatedFlag - bit
          0 , -- AbuseRelatedFlag - bit
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import for the purpose of Balance Forward Encounters. Please verify before use.' , -- Notes - text
          1 , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
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
FROM dbo.Patient p 
	INNER JOIN _import_1_1_ChargeDetail i ON
		p.VendorID = i.patientfid AND
		p.PracticeID = @PracticeID
WHERE i.patbalance > '0.00' OR i.insbalance > '0.00'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Policy - Balance Forward...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
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
          DependentPolicyNumber ,
          Notes ,
          Copay ,
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
          i.sequencenumber , -- Precedence - int
          i.subscriberidnumber , -- PolicyNumber - varchar(32)
          i.groupnumber , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(i.effectivestartdate) = 1 THEN i.effectivestartdate ELSE NULL END , -- PolicyStartDate - datetime
          CASE WHEN ISDATE(i.effectiveenddate) = 1 THEN i.effectiveenddate ELSE NULL END , -- PolicyEndDate - datetime
          1 , -- CardOnFile - bit
          CASE WHEN p.FirstName <> rp.firstname AND p.LastName <> rp.lastname THEN CASE i.relationshippatienttosubscriber 
																						WHEN 1 THEN 'S' 
																						WHEN 2 THEN 'U' 
																						WHEN 3 THEN 'C'
																						WHEN 4 THEN 'O'
																				    ELSE 'S' END ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN p.FirstName <> rp.firstname AND p.LastName <> rp.lastname THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN p.FirstName <> rp.firstname AND p.LastName <> rp.lastname THEN rp.firstname END , -- HolderFirstName - varchar(64)
          CASE WHEN p.FirstName <> rp.firstname AND p.LastName <> rp.lastname THEN rp.middlename END , -- HolderMiddleName - varchar(64)
          CASE WHEN p.FirstName <> rp.firstname AND p.LastName <> rp.lastname THEN rp.lastname END , -- HolderLastName - varchar(64)
          CASE WHEN p.FirstName <> rp.firstname AND p.LastName <> rp.lastname THEN '' END , -- HolderSuffix - varchar(16)
          CASE WHEN p.FirstName <> rp.firstname AND p.LastName <> rp.lastname THEN CASE WHEN ISDATE(rp.dob) = 1 THEN rp.dob ELSE NULL END END , -- HolderDOB - datetime
          CASE WHEN p.FirstName <> rp.firstname AND p.LastName <> rp.lastname THEN CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(rp.ssn)) >= 6 THEN RIGHT('000' + rp.ssn,9) ELSE '' END END , -- HolderSSN - char(11)
          0 , -- HolderThroughEmployer - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN p.FirstName <> rp.firstname AND p.LastName <> rp.lastname THEN rp.gender END , -- HolderGender - char(1)
          CASE WHEN p.FirstName <> rp.firstname AND p.LastName <> rp.lastname THEN rp.address2 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN p.FirstName <> rp.firstname AND p.LastName <> rp.lastname THEN rp.address1 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN p.FirstName <> rp.firstname AND p.LastName <> rp.lastname THEN rp.city END , -- HolderCity - varchar(128)
          CASE WHEN p.FirstName <> rp.firstname AND p.LastName <> rp.lastname THEN rp.[state] END , -- HolderState - varchar(2)
          CASE WHEN p.FirstName <> rp.firstname AND p.LastName <> rp.lastname THEN '' END , -- HolderCountry - varchar(32)
          CASE WHEN p.FirstName <> rp.firstname AND p.LastName <> rp.lastname THEN LEFT(REPLACE(rp.zipcode,'-',''),9) END , -- HolderZipCode - varchar(9)
          CASE WHEN p.FirstName <> rp.firstname AND p.LastName <> rp.lastname THEN LEFT(rp.homephone,10) END , -- HolderPhone - varchar(10)
          CASE WHEN p.FirstName <> rp.firstname AND p.LastName <> rp.lastname THEN i.subscriberidnumber END , -- DependentPolicyNumber - varchar(32)
          '' , -- Notes - text
          i.copaydollaramount , -- Copay - money
          i.active , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID + i.sequencenumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          LEFT(i.groupname,14) , -- GroupName - varchar(14)
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_1_1_Coverages] i
INNER JOIN dbo.PatientCase pc ON 
	i.patientfid = pc.VendorID AND 
	pc.VendorImportID = @VendorImportID AND 
	pc.Name = 'Balance Forward'
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	i.carrierfid = icp.VendorID AND
	icp.VendorImportID = @VendorImportID
LEFT JOIN dbo.[_import_1_1_ResponsibleParties] rp ON
	i.responsiblepartysubscriberfid = rp.responsiblepartyuid
INNER JOIN dbo._import_1_1_ChargeDetail impcd ON
	i.patientfid = impcd.patientfid
INNER JOIN dbo.Patient p ON 
	pc.PatientID = p.PatientID AND 
    p.PracticeID = @PracticeID
INNER JOIN dbo._import_1_1_ChargeDetail icd ON 
	p.VendorID = icd.patientfid
WHERE icd.patbalance > '0.00' OR icd.insbalance > '0.00'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Procedure Code Dictionary...'
INSERT INTO dbo.ProcedureCodeDictionary
        ( ProcedureCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          TypeOfServiceCode ,
          Active ,
          OfficialName ,
          CustomCode
        )
SELECT DISTINCT
		  i.chargecode , -- ProcedureCode - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          '1' , -- TypeOfServiceCode - char(1)
          1 , -- Active - bit
          i.insurancedescription , -- OfficialName - varchar(300)
          1  -- CustomCode - bit
FROM dbo._import_1_1_ChargeCodes i
	LEFT JOIN dbo.ProcedureCodeDictionary pcd ON 
		i.chargecode = pcd.ProcedureCode
WHERE pcd.ProcedureCodeDictionaryID IS NULL	
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Encounter...'
INSERT INTO dbo.Encounter
        ( PracticeID ,
          PatientID ,
          DoctorID ,
          AppointmentID ,
          LocationID ,
          PatientEmployerID ,
          DateOfService ,
          DateCreated ,
          Notes ,
          EncounterStatusID ,
          AdminNotes ,
          AmountPaid ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          MedicareAssignmentCode ,
          ReleaseOfInformationCode ,
          ReleaseSignatureSourceCode ,
          PlaceOfServiceCode ,
          ConditionNotes ,
          PatientCaseID ,
          InsurancePolicyAuthorizationID ,
          PostingDate ,
          DateOfServiceTo ,
          SupervisingProviderID ,
          ReferringPhysicianID ,
          PaymentMethod ,
          Reference ,
          AddOns ,
          HospitalizationStartDT ,
          HospitalizationEndDT ,
          Box19 ,
          DoNotSendElectronic ,
          SubmittedDate ,
          PaymentTypeID ,
          PaymentDescription ,
          EDIClaimNoteReferenceCode ,
          EDIClaimNote ,
          VendorID ,
          VendorImportID ,
          AppointmentStartDate ,
          BatchID ,
          SchedulingProviderID ,
          DoNotSendElectronicSecondary ,
          PaymentCategoryID ,
          overrideClosingDate ,
          Box10d ,
          ClaimTypeID ,
          OperatingProviderID ,
          OtherProviderID ,
          PrincipalDiagnosisCodeDictionaryID ,
          AdmittingDiagnosisCodeDictionaryID ,
          PrincipalProcedureCodeDictionaryID ,
          DRGCodeID ,
          ProcedureDate ,
          AdmissionTypeID ,
          AdmissionDate ,
          PointOfOriginCodeID ,
          AdmissionHour ,
          DischargeHour ,
          DischargeStatusCodeID ,
          Remarks ,
          SubmitReasonID ,
          DocumentControlNumber ,
          PTAProviderID ,
          SecondaryClaimTypeID ,
          SubmitReasonIDCMS1500 ,
          SubmitReasonIDUB04 ,
          DocumentControlNumberCMS1500 ,
          DocumentControlNumberUB04 ,
          EDIClaimNoteReferenceCodeCMS1500 ,
          EDIClaimNoteReferenceCodeUB04 ,
          EDIClaimNoteCMS1500 ,
          EDIClaimNoteUB04 ,
          PatientCheckedIn ,
          RoomNumber ,
          DiagnosisMapSource ,
          CollectionCategoryID
        )
SELECT DISTINCT	
		  @PracticeID , -- PracticeID - int
          p.PatientID , -- PatientID - int
          1 ,--rendprov.DoctorID , -- DoctorID - int ******** NEEDS UPDATING - mapping to provider based on date and patid is duplicated
          NULL , -- AppointmentID - int
          1 , -- LocationID - int
          NULL , -- PatientEmployerID - int
          impcd.begindateofservice , -- DateOfService - datetime
          GETDATE() , -- DateCreated - datetime
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          1 , -- EncounterStatusID - int *********		DRAFT = 1 , APPROVED = 3
          'From AdvancedMD - ' + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) +
		  CASE WHEN impcd.patbalance > '0.00' THEN + CHAR(13) + CHAR(10) + 'Remaining Patient Balance: ' + impcd.patbalance  
		       WHEN impcd.insbalance > '0.00' THEN + CHAR(13) + CHAR(10) + 'Remaining Insurance Balance: ' + impcd.insbalance
		  ELSE '' END + CHAR(13) + CHAR(10) +
		  'PatientFID: ' + impcd.patientfid + CHAR(13) + CHAR(10) +
		  'ChargeDetail_UID: ' + impcd.chargedetailuid + CHAR(13) + CHAR(10) +
		  'Created Date: ' + CONVERT(VARCHAR(10),impcd.createdat,101) + CHAR(13) + CHAR(10) , -- AdminNotes - text
          NULL , -- AmountPaid - money
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          NULL , -- MedicareAssignmentCode - char(1)
          NULL , -- ReleaseOfInformationCode - char(1)
          'B' , -- ReleaseSignatureSourceCode - char(1)
          11 , -- PlaceOfServiceCode - char(2)
          NULL , -- ConditionNotes - text
          pc.PatientCaseID , -- PatientCaseID - int
          NULL , -- InsurancePolicyAuthorizationID - int
          impcd.postingdate , -- PostingDate - datetime
          impcd.enddateofservice , -- DateOfServiceTo - datetime
          NULL , -- SupervisingProviderID - int
          NULL , -- ReferringPhysicianID - int
          'U' , -- PaymentMethod - char(1)
          NULL , -- Reference - varchar(40)
          0 , -- AddOns - bigint
          NULL , -- HospitalizationStartDT - datetime
          NULL , -- HospitalizationEndDT - datetime
          NULL , -- Box19 - varchar(51)
          1 , -- DoNotSendElectronic - bit
          NULL , -- SubmittedDate - datetime
          NULL , -- PaymentTypeID - int
          NULL , -- PaymentDescription - varchar(250)
          NULL , -- EDIClaimNoteReferenceCode - char(3)
          NULL , -- EDIClaimNote - varchar(1600)
          impcd.chargedetailuid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          NULL , -- AppointmentStartDate - datetime
          '' , -- BatchID - varchar(50)
          NULL , -- SchedulingProviderID - int
          1 , -- DoNotSendElectronicSecondary - bit
          NULL , -- PaymentCategoryID - int
          0 , -- overrideClosingDate - bit
          '' , -- Box10d - varchar(40)
          0 , -- ClaimTypeID - int
          NULL , -- OperatingProviderID - int
          NULL , -- OtherProviderID - int
          NULL , -- PrincipalDiagnosisCodeDictionaryID - int
          NULL , -- AdmittingDiagnosisCodeDictionaryID - int
          NULL , -- PrincipalProcedureCodeDictionaryID - int
          NULL , -- DRGCodeID - int
          GETDATE() , -- ProcedureDate - datetime
          NULL , -- AdmissionTypeID - int
          GETDATE() , -- AdmissionDate - datetime
          NULL , -- PointOfOriginCodeID - int
          NULL , -- AdmissionHour - varchar(2)
          NULL , -- DischargeHour - varchar(2)
          NULL , -- DischargeStatusCodeID - int
          NULL , -- Remarks - varchar(255)
          NULL , -- SubmitReasonID - int
          NULL , -- DocumentControlNumber - varchar(26)
          NULL , -- PTAProviderID - int
          0 , -- SecondaryClaimTypeID - int
          2 , -- SubmitReasonIDCMS1500 - int
          2 , -- SubmitReasonIDUB04 - int
          NULL , -- DocumentControlNumberCMS1500 - varchar(26)
          NULL , -- DocumentControlNumberUB04 - varchar(26)
          NULL , -- EDIClaimNoteReferenceCodeCMS1500 - char(3)
          NULL , -- EDIClaimNoteReferenceCodeUB04 - char(3)
          NULL , -- EDIClaimNoteCMS1500 - varchar(1600)
          NULL , -- EDIClaimNoteUB04 - varchar(1600)
          0 , -- PatientCheckedIn - bit
          NULL , -- RoomNumber - varchar(32)
          1 , -- DiagnosisMapSource - bit
          p.CollectionCategoryID  -- CollectionCategoryID - int
FROM dbo._import_1_1_ChargeDetail impcd 
	INNER JOIN dbo._import_1_1_PatientInfo imppat ON 
		imppat.patientuid = impcd.patientfid
	INNER JOIN dbo.Patient p ON 
		imppat.patientuid = p.VendorID AND 
		p.PracticeID = @PracticeID
	INNER JOIN dbo.PatientCase pc ON 
		p.PatientID = pc.PatientID AND 
		pc.Name = 'Balance Forward' AND
		pc.VendorImportID = @VendorImportID
WHERE impcd.patbalance > '0.00' OR impcd.insbalance > '0.00'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Encounter Diagnosis...'
INSERT INTO dbo.EncounterDiagnosis
        ( EncounterID ,
          DiagnosisCodeDictionaryID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ListSequence ,
          PracticeID ,
          VendorID ,
          VendorImportID
        )
SELECT DISTINCT
	      e.EncounterID , -- EncounterID - int
          CASE WHEN dcd.DiagnosisCodeDictionaryID IS NULL THEN dcd10.ICD10DiagnosisCodeDictionaryId ELSE dcd.DiagnosisCodeDictionaryID END , -- DiagnosisCodeDictionaryID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          impcdd.codesequence , -- ListSequence - int
          @PracticeID , -- PracticeID - int
          impcdd.chargedetaildiagnosiscodeuid , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo._import_1_1_ChargeDetail impcd 
	INNER JOIN dbo.Encounter e ON 
		impcd.chargedetailuid = e.VendorID AND 
		e.VendorImportID = @VendorImportID
	INNER JOIN dbo._import_1_1_LnkChargeDetailDiagnosisCode impcdd ON 
		impcd.chargedetailuid = impcdd.chargedetailfid
	INNER JOIN dbo._import_1_1_DiagnosisCodes impdc ON 
		impcdd.diagnosiscodefid = impdc.diagnosiscodeuid
	LEFT JOIN dbo.DiagnosisCodeDictionary dcd ON 
		impdc.diagnosiscode = dcd.DiagnosisCode
	LEFT JOIN dbo.ICD10DiagnosisCodeDictionary dcd10 ON 
		impdc.diagnosiscode = dcd10.DiagnosisCode
WHERE impdc.display = 1 AND (impcd.patbalance > '0.00' OR impcd.insbalance > '0.00') AND (impcdd.codesequence >= 1 AND impcdd.codesequence <=8)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

CREATE TABLE #TempImpProcedureMod (ChargeDetailModifierCodeUID INT , ChargeDetailFID INT , ModifierCodeFID INT , codesequence INT , KProcedureModifer VARCHAR(10))
INSERT INTO #TempImpProcedureMod
        ( ChargeDetailModifierCodeUID ,
          ChargeDetailFID ,
          ModifierCodeFID ,
          codesequence , 
		  KProcedureModifer
        )
SELECT DISTINCT
		  i.chargedetailmodifiercodeuid , -- ChargeDetailModifierCodeUID - int
          i.chargedetailfid , -- ChargeDetailFID - int
          i.modifiercodefid , -- ModifierCodeFID - int
          i.codesequence ,  -- codesequence - int
		  pm.ProcedureModifierCode
FROM dbo._import_1_1_lnkChargeDetailModifierCodes i
	INNER JOIN dbo._import_1_1_ModifierCodes mc ON
		i.modifiercodefid = mc.modifiercodeuid
	LEFT JOIN dbo.ProcedureModifier pm ON
		mc.modifiercode = pm.ProcedureModifierCode

PRINT ''
PRINT 'Inserting Into Encounter Procedure...'
INSERT INTO dbo.EncounterProcedure
        ( EncounterID ,
          ProcedureCodeDictionaryID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ServiceChargeAmount ,
          ServiceUnitCount ,
          ProcedureModifier1 ,
          ProcedureModifier2 ,
          ProcedureModifier3 ,
          ProcedureModifier4 ,
          ProcedureDateOfService ,
          PracticeID ,
          EncounterDiagnosisID1 ,
          EncounterDiagnosisID2 ,
          EncounterDiagnosisID3 ,
          EncounterDiagnosisID4 ,
          ServiceEndDate ,
          VendorID ,
          VendorImportID ,
          ContractID ,
          [Description] ,
          EDIServiceNoteReferenceCode ,
          EDIServiceNote ,
          TypeOfServiceCode ,
          AnesthesiaTime ,
          ApplyPayment ,
          PatientResp ,
          AssessmentDate ,
          RevenueCodeID ,
          NonCoveredCharges ,
          DoctorID ,
          StartTime ,
          EndTime ,
          ConcurrentProcedures ,
          StartTimeText ,
          EndTimeText ,
          EncounterDiagnosisID5 ,
          EncounterDiagnosisID6 ,
          EncounterDiagnosisID7 ,
          EncounterDiagnosisID8
        )
SELECT DISTINCT
		  e.EncounterID , -- EncounterID - int
          pcd.ProcedureCodeDictionaryID , -- ProcedureCodeDictionaryID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          impcd.fee , -- ServiceChargeAmount - money
          impcd.units , -- ServiceUnitCount - decimal
          impprocmod1.KProcedureModifer , -- ProcedureModifier1 - varchar(16)
          impprocmod2.KProcedureModifer , -- ProcedureModifier2 - varchar(16)
          impprocmod3.KProcedureModifer , -- ProcedureModifier3 - varchar(16)
          NULL , -- ProcedureModifier4 - varchar(16)
          e.DateOfService , -- ProcedureDateOfService - datetime
          @PracticeID , -- PracticeID - int
          ed_5.EncounterDiagnosisID , -- EncounterDiagnosisID1 - int
          ed_6.EncounterDiagnosisID , -- EncounterDiagnosisID2 - int
          ed_7.EncounterDiagnosisID , -- EncounterDiagnosisID3 - int
          ed_8.EncounterDiagnosisID , -- EncounterDiagnosisID4 - int
          e.DateOfServiceTo , -- ServiceEndDate - datetime
          e.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          NULL , -- ContractID - int
          NULL , -- Description - varchar(80)
          NULL , -- EDIServiceNoteReferenceCode - char(3)
          NULL , -- EDIServiceNote - varchar(80)
          NULL , -- TypeOfServiceCode - char(1)
          0 , -- AnesthesiaTime - int
          0.00 , -- ApplyPayment - money
          0.00 , -- PatientResp - money
          NULL , -- AssessmentDate - datetime
          NULL , -- RevenueCodeID - int
          0.00 , -- NonCoveredCharges - money
          NULL , -- DoctorID - int
          NULL , -- StartTime - datetime
          NULL , -- EndTime - datetime
          NULL , -- ConcurrentProcedures - int
          NULL , -- StartTimeText - varchar(4)
          NULL , -- EndTimeText - varchar(4)
          ed_1.EncounterDiagnosisID , -- EncounterDiagnosisID5 - int
          ed_2.EncounterDiagnosisID , -- EncounterDiagnosisID6 - int
          ed_3.EncounterDiagnosisID , -- EncounterDiagnosisID7 - int
          ed_4.EncounterDiagnosisID  -- EncounterDiagnosisID8 - int
FROM dbo.Encounter e 
	LEFT JOIN dbo.EncounterDiagnosis ed_1 ON 
		e.EncounterID = ed_1.EncounterID AND
		ed_1.ListSequence = 1 AND 
		ed_1.VendorImportID = @VendorImportID
	LEFT JOIN dbo.EncounterDiagnosis ed_2 ON 
		e.EncounterID = ed_2.EncounterID AND
		ed_2.ListSequence = 2 AND
		ed_2.VendorImportID = @VendorImportID
	LEFT JOIN dbo.EncounterDiagnosis ed_3 ON 
		e.EncounterID = ed_3.EncounterID AND
		ed_3.ListSequence = 3 AND
		ed_3.VendorImportID = @VendorImportID
	LEFT JOIN dbo.EncounterDiagnosis ed_4 ON 
		e.EncounterID = ed_4.EncounterID AND
		ed_4.ListSequence = 4 AND
		ed_4.VendorImportID = @VendorImportID
	LEFT JOIN dbo.EncounterDiagnosis ed_5 ON 
		e.EncounterID = ed_5.EncounterID AND
		ed_5.ListSequence = 5 AND
		ed_5.VendorImportID = @VendorImportID
	LEFT JOIN dbo.EncounterDiagnosis ed_6 ON 
		e.EncounterID = ed_6.EncounterID AND
		ed_6.ListSequence = 6 AND
		ed_6.VendorImportID = @VendorImportID
	LEFT JOIN dbo.EncounterDiagnosis ed_7 ON 
		e.EncounterID = ed_7.EncounterID AND
		ed_7.ListSequence = 7 AND
		ed_7.VendorImportID = @VendorImportID
	LEFT JOIN dbo.EncounterDiagnosis ed_8 ON 
		e.EncounterID = ed_8.EncounterID AND
		ed_8.ListSequence = 8 AND
		ed_8.VendorImportID = @VendorImportID
	INNER JOIN dbo._import_1_1_ChargeDetail impcd ON
		e.VendorID = impcd.chargedetailuid 
	INNER JOIN dbo._import_1_1_ChargeCodes impcc ON 
		impcd.chargecodefid = impcc.chargecodeuid 
	INNER JOIN dbo.ProcedureCodeDictionary pcd ON 
		impcc.chargecode = pcd.ProcedureCode
	LEFT JOIN #TempImpProcedureMod impprocmod1 ON
		impcd.chargedetailuid = impprocmod1.ChargeDetailFID AND
		impprocmod1.codesequence = 1
	LEFT JOIN #TempImpProcedureMod impprocmod2 ON
		impcd.chargedetailuid = impprocmod2.ChargeDetailFID AND
		impprocmod2.codesequence = 2
	LEFT JOIN #TempImpProcedureMod impprocmod3 ON
		impcd.chargedetailuid = impprocmod3.ChargeDetailFID AND
		impprocmod3.codesequence = 3
WHERE impcd.patbalance > '0.00' OR impcd.insbalance > '0.00'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


DROP TABLE #tempins
DROP TABLE #TempImpProcedureMod

 
--ROLLBACK
--COMMIT
