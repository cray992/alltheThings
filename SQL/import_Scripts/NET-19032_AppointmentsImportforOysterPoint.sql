USE superbill_62032_dev
GO

SET XACT_ABORT ON
 
BEGIN TRANSACTION
 --rollback
 --commit
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @OldVendorImportID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 4
SET @OldVendorImportID = 1

----Update to add vendorimportID to Apppointments table
--ALTER TABLE dbo.Appointment
--ADD vendorimportid VARCHAR(10)

----Update to add startdate and enddate to temp table
--ALTER TABLE dbo._import_4_1_Appointments 
--ADD startdate VARCHAR(max),enddate VARCHAR(max)

----Formatting for start and enddates
--UPDATE ie SET 
--ie.startdate = CONVERT(VARCHAR,CAST(ie.apptdate AS DATETIME)+ CAST(ie.apptstarttime AS DATETIME),121)
--FROM dbo._import_4_1_Appointments  ie

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


CREATE TABLE #ImpThesePats (PatVendorID VARCHAR(50),lastname VARCHAR(50), firstname VARCHAR(50), dob DATETIME)
--DROP TABLE #ImpThesePats
--DROP TABLE #insurancecompanyplanlist
INSERT INTO #ImpThesePats ( PatVendorID,lastname,firstname,dob )
SELECT DISTINCT i.patientid,i.patientlastname, i.patientfirstname, i.patientdob
FROM dbo._import_4_1_Patients i
LEFT JOIN patient p ON --p.VendorID = i.patientid AND 
	p.FirstName = i.patientfirstname AND 
	p.LastName = i.patientlastname AND 
	--p.AddressLine1 = i.patientaddress1 AND 
	p.DOB = DATEADD(hh,12,CAST(i.patientdob AS DATETIME) )AND
	p.PracticeID = 1--@PracticeID
WHERE p.PatientID IS NULL 

CREATE TABLE #InsuranceCompanyPlanList (ID INT , Name VARCHAR(128) , Address1 VARCHAR(128) , Address2 VARCHAR(128) , City VARCHAR(100) , [State] VARCHAR(2) , Zip VARCHAR(9) , ICPID INT)

INSERT INTO #InsuranceCompanyPlanList
        ( ID ,
		  Name ,
          Address1 ,
          Address2 ,
          City ,
          State ,
          Zip , 
		  ICPID
        )
		
SELECT DISTINCT
		  i.patientprimaryinspkgid ,
		  i.patientprimaryinspkgname , -- Name - varchar(128)
          i.patientprimaryinshldrad , -- Address1 - varchar(128)
          i.patientprimaryinshldrad1 , -- Address2 - varchar(128)
          i.patientprimaryinshldrcity , -- City - varchar(100)
          i.patientprimaryinshldrstate , -- State - varchar(2)
          REPLACE(i.patientprimaryinshldrzip,'-','') , -- Zip - varchar(9)
		  ip.InsuranceCompanyPlanID
FROM dbo._import_4_1_patients i
INNER JOIN #ImpThesePats imppat ON 
	i.patientid = imppat.PatVendorID
	INNER JOIN dbo.InsuranceCompanyPlan ip ON ip.PlanName=i.patientprimaryinspkgname
		AND ip.InsuranceCompanyPlanID = (SELECT MAX(icp2.InsuranceCompanyPlanID) FROM dbo.InsuranceCompanyPlan icp2
									  WHERE icp2.PlanName = i.patientprimaryinspkgname)
								
								
WHERE i.patientprimaryinspkgname <> '' AND 
	  i.patientprimaryinspkgname <> '*SELF PAY*' 

INSERT INTO #InsuranceCompanyPlanList
        ( ID ,
		  Name ,
          Address1 ,
          Address2 ,
          City ,
          State ,
          Zip ,
		  ICPID
        )
SELECT DISTINCT
		  	  i.patientprimaryinspkgid ,
		  i.patientprimaryinspkgname , -- Name - varchar(128)
          i.patientprimaryinshldrad , -- Address1 - varchar(128)
          i.patientprimaryinshldrad1 , -- Address2 - varchar(128)
          i.patientprimaryinshldrcity , -- City - varchar(100)
          i.patientprimaryinshldrstate , -- State - varchar(2)
          REPLACE(i.patientprimaryinshldrzip,'-','') , -- Zip - varchar(9)
		  icp.InsuranceCompanyPlanID
FROM dbo._import_4_1_patients i
INNER JOIN #ImpThesePats imppat ON 
	i.patientid = imppat.PatVendorID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.InsuranceCompanyPlanID = (SELECT MAX(icp2.InsuranceCompanyPlanID) FROM dbo.InsuranceCompanyPlan icp2
								  WHERE icp2.PlanName = i.patientsecondaryinspkgname AND
										icp2.AddressLine1 = i.patientsecondaryinshldr3 AND
										icp2.City = i.patientsecondaryinshldr5 AND
										icp2.ZipCode = REPLACE(i.patientsecondaryinshldrzip,'-','')
									 )
WHERE i.patientsecondaryinspkgname <> '' AND 
	  i.patientsecondaryinspkgname <> '*SELF PAY*' AND
	  NOT EXISTS (SELECT * FROM #InsuranceCompanyPlanList icp 
				  WHERE i.patientsecondaryinspkgname = icp.Name AND
						i.patientsecondaryinshldr3 = icp.Address1 AND
						REPLACE(i.patientsecondaryinshldrzip,'-','') = icp.Zip) 

PRINT ''
PRINT 'Updating Existing Patient Records with VendorID...'
UPDATE dbo.Patient 
	SET MedicalRecordNumber = i.patientid 
FROM dbo.Patient p 
	INNER JOIN dbo._import_4_1_Patients i ON 
		p.FirstName = i.patientfirstname AND 
		p.LastName = i.patientlastname AND 
		p.DOB = DATEADD(hh,12,CAST(i.patientdob AS DATETIME)) 
WHERE p.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


--PRINT ''
--PRINT 'Inserting Into Patient...'
--INSERT INTO dbo.Patient
--        ( PracticeID ,
--          Prefix ,
--          FirstName ,
--          MiddleName ,
--          LastName ,
--          Suffix ,
--          AddressLine1 ,
--          AddressLine2 ,
--          City ,
--          State ,
--          Country ,
--          ZipCode ,
--          Gender ,
--          MaritalStatus ,
--          HomePhone ,
--          WorkPhone ,
--		  WorkPhoneExt , 
--          DOB ,
--          SSN ,
--          EmailAddress ,
--          ResponsibleDifferentThanPatient ,
--          CreatedDate ,
--          CreatedUserID ,
--          ModifiedDate ,
--          ModifiedUserID ,
--          EmploymentStatus ,
--          MedicalRecordNumber ,
--          MobilePhone ,
--          VendorID ,
--          VendorImportID ,
--          CollectionCategoryID ,
--          Active ,
--          SendEmailCorrespondence ,
--          PhonecallRemindersEnabled , 
--		  EmergencyName , 
--		  EmergencyPhone ,
--		  ResponsibleRelationshipToPatient , 
--		  ResponsibleFirstName , 
--		  ResponsibleMiddleName ,
--		  ResponsibleLastName , 
--		  ResponsibleAddressLine1 , 
--		  ResponsibleAddressLine2 , 
--		  ResponsibleCity , 
--		  ResponsibleState , 
--		  ResponsibleZipCode
--        )
--SELECT DISTINCT
--		  @PracticeID , -- PracticeID - int
--          '' , -- Prefix - varchar(16)
--          i.patientfirstname , -- FirstName - varchar(64)
--          '' , --i.patientmiddleinitial , -- MiddleName - varchar(64)
--          i.patientlastname , -- LastName - varchar(64)
--          '' , -- Suffix - varchar(16)
--          i.patientaddress1 , -- AddressLine1 - varchar(256)
--          i.patientaddress2 , -- AddressLine2 - varchar(256)
--          i.patientcity , -- City - varchar(128)
--          i.patientstate , -- State - varchar(2)
--          '' , -- Country - varchar(32)
--          REPLACE(i.patientzip,'-','') , -- ZipCode - varchar(9)
--          i.patientsex , -- Gender - varchar(1)
--          NULL, --CASE WHEN ms.MaritalStatus IS NULL THEN '' ELSE ms.MaritalStatus END , -- MaritalStatus - varchar(1)
--          LEFT(dbo.fn_RemoveNonNumericCharacters(i.patienthomephone),10) , -- HomePhone - varchar(10)
--		  CASE
--			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientworkphone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.patientworkphone),10)
--		  ELSE '' END ,
--		  CASE
--			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.patientworkphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(i.patientworkphone),11,LEN(dbo.fn_RemoveNonNumericCharacters(i.patientworkphone))),10)
--		  ELSE NULL END ,
--          i.patientdob , -- DOB - datetime
--          i.patientssn , -- SSN - char(9)
--          i.patientemail , -- EmailAddress - varchar(256)
--          NULL, --CASE WHEN i.ptntgrntrrltnshp <> '' OR i.ptntgrntrrltnshp <> 'Self' THEN 1 ELSE 0 END , -- ResponsibleDifferentThanPatient - bit
--          GETDATE() , -- CreatedDate - datetime
--          0 , -- CreatedUserID - int
--          GETDATE() , -- ModifiedDate - datetime
--          0 , -- ModifiedUserID - int
--          'U' , -- EmploymentStatus - char(1)
--          i.patientid , -- MedicalRecordNumber - varchar(128)
--          LEFT(dbo.fn_RemoveNonNumericCharacters(i.patientmobileno),10) , -- MobilePhone - varchar(10)
--          i.patientid , -- VendorID - varchar(50)
--          @VendorImportID , -- VendorImportID - int
--          1 , -- CollectionCategoryID - int
--          1 , -- Active - bit
--          0 , -- SendEmailCorrespondence - bit
--          0 , -- PhonecallRemindersEnabled - bit
--		  NULL, --i.ptntemrgncycntctname , 
--		  NULL, --LEFT(dbo.fn_RemoveNonNumericCharacters(i.ptntemrgncycntctph),10) , 
--		  NULL, -- CASE i.ptntgrntrrltnshp
--			--WHEN 'Spouse' THEN 'U'
--			--WHEN 'Self' THEN 'S'
--			--WHEN 'Other' THEN 'O'
--			--WHEN '' THEN 'O'
--		 -- ELSE 'C' END ,
--		  NULL, --i.guardianfrstnm , 
--		  NULL, --i.guardianmddlinitial , 
--		  NULL, --i.guardianlastnm , 
--		  NULL, --i.guarantoraddr , 
--		  NULL, --i.guarantoraddr2 , 
--		  NULL, --i.guarantorcity , 
--		  NULL, --i.guarantorstate , 
--		  NULL --CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.guarantorzip)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.guarantorzip)
--			 --  WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.guarantorzip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.guarantorzip)

--FROM dbo._import_4_1_Patients i
--	INNER JOIN #ImpThesePats imppat ON 
--		i.patientid = imppat.PatVendorID			
			
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--PRINT ''
--PRINT 'Inserting Into Patient Case...'
--INSERT INTO dbo.PatientCase
--        ( PatientID ,
--          Name ,
--          Active ,
--          PayerScenarioID ,
--          Notes ,
--		  ShowExpiredInsurancePolicies ,
--          CreatedDate ,
--          CreatedUserID ,
--          ModifiedDate ,
--          ModifiedUserID ,
--          PracticeID ,
--          VendorID ,
--          VendorImportID ,
--          StatementActive ,
--          EPSDTCodeID 
--        )
--SELECT DISTINCT
--		  PatientID , -- PatientID - int
--          'Default Case' , -- Name - varchar(128)
--          1 , -- Active - bit
--          5 , -- PayerScenarioID - int
--          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
--          1 , -- ShowExpiredInsurancePolicies - bit
--          GETDATE() , -- CreatedDate - datetime
--          0 , -- CreatedUserID - int
--          GETDATE() , -- ModifiedDate - datetime
--          0 , -- ModifiedUserID - int
--          @PracticeID , -- PracticeID - int
--          VendorID , -- VendorID - varchar(50)
--          @VendorImportID , -- VendorImportID - int
--          1 , -- StatementActive - bit
--          1  -- EPSDTCodeID - int
--FROM dbo.Patient
--WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


-- --Insert Insurance Policies where they do not already exist
--PRINT ''
--PRINT 'Inserting Into Insurance Policy - Primary...'
--INSERT INTO dbo.InsurancePolicy
--        ( PatientCaseID ,
--          InsuranceCompanyPlanID ,
--          Precedence ,
--          PolicyNumber ,
--          GroupNumber ,
--          CardOnFile ,
--          PatientRelationshipToInsured ,
--          HolderPrefix ,
--          HolderFirstName ,
--          HolderMiddleName ,
--          HolderLastName ,
--          HolderSuffix ,
--          HolderDOB ,
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
--		  HolderSSN ,
--          Active ,
--          PracticeID ,
--          VendorID ,
--          VendorImportID ,
--          ReleaseOfInformation 
--        )
		

--SELECT DISTINCT
--		  pc.PatientCaseID , -- PatientCaseID - int
--          icp.ICPID , -- InsuranceCompanyPlanID - int
--          1 , -- Precedence - int
--          i.patientprimarypolicyidnumber , -- PolicyNumber - varchar(32)
--          i.patientprimarypolicygrpnu , -- GroupNumber - varchar(32)
--          0 , -- CardOnFile - bit
--          CASE WHEN i.patientprimaryptnttoins <> 'Self' THEN 'C' ELSE 'S' END  , -- PatientRelationshipToInsured - varchar(1)
--          NULL, --CASE WHEN i.patientprimaryptnttoins <> 'Self' THEN '' END , -- HolderPrefix - varchar(16)
--          CASE WHEN i.patientfirstname <> 'Self' THEN i.patientfirstname END , -- HolderFirstName - varchar(64)
--          '', --CASE WHEN i.patientprimaryptnttoins <> 'Self' THEN '' END , -- HolderMiddleName - varchar(64)
--          CASE WHEN i.patientlastname <> 'Self' THEN i.patientlastname END , -- HolderLastName - varchar(64)
--          NULL, --CASE WHEN i.patientprimaryptnttoins <> 'Self' THEN '' END , -- HolderSuffix - varchar(16)
--          CASE WHEN i.patientdob <> 'Self' THEN i.patientdob END , -- HolderDOB - datetime
--          GETDATE() , -- CreatedDate - datetime
--          0 , -- CreatedUserID - int
--          GETDATE() , -- ModifiedDate - datetime
--          0 , -- ModifiedUserID - int
--          CASE WHEN i.patientsex <> 'Self' THEN i.patientsex END , -- HolderGender - char(1)
--          CASE WHEN i.patientaddress1 <> 'Self' THEN i.patientaddress1 END , -- HolderAddressLine1 - varchar(256)
--          CASE WHEN i.patientaddress2 <> 'Self' THEN i.patientaddress2 END , -- HolderAddressLine2 - varchar(256)
--          CASE WHEN i.patientcity <> 'Self' THEN i.patientcity END , -- HolderCity - varchar(128)
--          CASE WHEN i.patientstate <> 'Self' THEN i.patientstate END , -- HolderState - varchar(2)
--          NULL, --CASE WHEN i.patientprimaryptnttoins <> 'Self' THEN '' END , -- HolderCountry - varchar(32)
--          CASE WHEN i.patientzip <> 'Self' THEN REPLACE(i.patientzip,'-','') END , -- HolderZipCode - varchar(9)
--          CASE WHEN i.patientprimarypolicyidnumber <> 'Self' THEN i.patientprimarypolicyidnumber END , -- DependentPolicyNumber - varchar(32)
--		  CASE WHEN i.patientssn <> 'Self' THEN REPLACE(i.patientssn,'-','') END ,
--          1 , -- Active - bit
--          @PracticeID , -- PracticeID - int
--          pc.VendorID , -- VendorID - varchar(50)
--          @VendorImportID , -- VendorImportID - int
--          'Y'  -- ReleaseOfInformation - varchar(1)

--FROM dbo._import_4_1_Patients i 
--	INNER JOIN dbo.Patient p ON 
--		p.VendorID = i.patientid AND
--		p.VendorImportID = @VendorImportID
--	INNER JOIN dbo.PatientCase pc ON 
--		p.PatientID = pc.PatientID AND 
--		pc.VendorImportID = @VendorImportID AND
--		pc.Name <> 'Balance Forward'
--	INNER JOIN #InsuranceCompanyPlanList ICP ON 
--		i.patientprimaryinspkgid = icp.ID
	
	
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--PRINT ''
--PRINT 'Inserting Into Insurance Policy - Secondary...'
--INSERT INTO dbo.InsurancePolicy
--        ( PatientCaseID ,
--          InsuranceCompanyPlanID ,
--          Precedence ,
--          PolicyNumber ,
--          GroupNumber ,
--          CardOnFile ,
--          PatientRelationshipToInsured ,
--          HolderPrefix ,
--          HolderFirstName ,
--          HolderMiddleName ,
--          HolderLastName ,
--          HolderSuffix ,
--          HolderDOB ,
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
--		  HolderSSN , 
--          Active ,
--          PracticeID ,
--          VendorID ,
--          VendorImportID ,
--          ReleaseOfInformation 
--        )

--SELECT DISTINCT
--		  pc.PatientCaseID , -- PatientCaseID - int
--          icp.ICPID , -- InsuranceCompanyPlanID - int
--          2 , -- Precedence - int
--          i.patientsecondarypolicyidn , -- PolicyNumber - varchar(32)
--          i.patientsecondarypolicygrp , -- GroupNumber - varchar(32)
--          0 , -- CardOnFile - bit
--          CASE WHEN i.patientsecondaryptnttoi <> 'Self' THEN 'C' ELSE 'S' END  , -- PatientRelationshipToInsured - varchar(1)
--          NULL, --CASE WHEN i.patientsecondaryptnttoins <> 'Self' THEN '' END , -- HolderPrefix - varchar(16)
--          CASE WHEN i.patientsecondaryinshldr <> 'Self' THEN i.patientsecondaryinshldr END , -- HolderFirstName - varchar(64)
--          NULL, --CASE WHEN i.patientsecondaryptnttoins <> 'Self' THEN 'C' ELSE 'S' END , -- HolderMiddleName - varchar(64)
--          CASE WHEN i.patientsecondaryinshldr2 <> 'Self' THEN i.patientsecondaryinshldr2 END , -- HolderLastName - varchar(64)
--          NULL, --CASE WHEN i.patientprimaryptnttoins <> 'Self' THEN '' END , -- HolderSuffix - varchar(16)
--          CASE WHEN i.patientsecondaryinshldrdob <> 'Self' THEN i.patientsecondaryinshldrdob END , -- HolderDOB - datetime
--          GETDATE() , -- CreatedDate - datetime
--          0 , -- CreatedUserID - int
--          GETDATE() , -- ModifiedDate - datetime
--          0 , -- ModifiedUserID - int
--          CASE WHEN i.patientsecondaryinshldrsex <> 'Self' THEN i.patientsecondaryinshldrsex END , -- HolderGender - char(1)
--          CASE WHEN i.patientsecondaryinshldr3 <> 'Self' THEN i.patientsecondaryinshldr3 END , -- HolderAddressLine1 - varchar(256)
--          CASE WHEN i.patientsecondaryinshldr4 <> 'Self' THEN i.patientsecondaryinshldr4 END , -- HolderAddressLine2 - varchar(256)
--          CASE WHEN i.patientsecondaryinshldr5 <> 'Self' THEN i.patientsecondaryinshldr5 END , -- HolderCity - varchar(128)
--          CASE WHEN i.patientsecondaryinshldr6 <> 'Self' THEN i.patientsecondaryinshldr6 END , -- HolderState - varchar(2)
--          NULL, --CASE WHEN i.patientprimaryptnttoins <> 'Self' THEN '' END , -- HolderCountry - varchar(32)
--          CASE WHEN i.patientsecondaryinshldrzip <> 'Self' THEN REPLACE(i.patientsecondaryinshldrzip,'-','') END , -- HolderZipCode - varchar(9)
--          CASE WHEN i.patientsecondarypolicyidn <> 'Self' THEN i.patientsecondarypolicyidn END , -- DependentPolicyNumber - varchar(32)
--		  NULL, --CASE WHEN i.patientssn <> 'Self' THEN REPLACE(i.patientssn,'-','') END ,
--          1 , -- Active - bit
--          @PracticeID , -- PracticeID - int
--          pc.VendorID , -- VendorID - varchar(50)
--          @VendorImportID , -- VendorImportID - int
--          'Y'  -- ReleaseOfInformation - varchar(1)
--FROM dbo._import_4_1_Patients i 
--	INNER JOIN dbo.Patient p ON 
--		p.VendorID = i.patientid AND
--		p.VendorImportID = @VendorImportID
--	INNER JOIN dbo.PatientCase pc ON 
--		p.PatientID = pc.PatientID AND 
--		pc.VendorImportID = @VendorImportID AND
--		pc.Name <> 'Balance Forward'
--	INNER JOIN #InsuranceCompanyPlanList ICP ON 
--		i.patientsecondaryinspkgid = icp.ID
		
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--PRINT ''
--PRINT 'Updating Patient Case...'
--UPDATE dbo.PatientCase 
--	SET Name = 'Self Pay' , PayerScenarioID = 11
--FROM dbo.PatientCase pc 
--	LEFT JOIN dbo.InsurancePolicy ip ON 
--		pc.PatientCaseID = ip.PatientCaseID AND 
--		ip.PracticeID = @PracticeID AND 
--		ip.VendorImportID = @VendorImportID
--WHERE pc.PracticeID = @PracticeID AND pc.VendorImportID = @VendorImportID AND pc.Name <> 'Balance Forward' AND ip.InsurancePolicyID IS NULL
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'
--commit
--rollback
DECLARE @ApptTypeTimes TABLE (
   ApptType VARCHAR(128) null,
   TimeFrame INT null,
   AppointmentType VARCHAR(256) null
)
--DECLARE @PracticeID INT
--SET @PracticeID =1

insert into @ApptTypeTimes 
(ApptType,TimeFrame,AppointmentType) values 
('Sick',10,'Sick Appt'),
('Well Child OK',20,'Well Exam-20'),
('Labs Only',10,'Labs Only'),
('Shots Only',5, 'Shots Only'),
('New Patient',20,'New Patient Visit'),
('Recheck',10,'Sick Appt'),
('WCC30',30,'Well Exam-30'),
('Flu Shot/Mist',10,'Shots Only'),
('20-Med Check',20,'Med Check'),
('Conference General',20,'General Conference-20'),
('Sports Physical',20,'Well Exam-20'),
('Prenatal',30,'Prenatal'),
('ADHD/ADD Conference',30,'ADHD Conference'),
('ANY 10,',10,'No appointment reason required'),
('Well Child CK',20,'Well Exam-20');


PRINT ''
PRINT 'Inserting Into Apppointment...'
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
          EndTm, 
		  vendorimportid
        )
		
SELECT DISTINCT 
		  p.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          1 , -- ServiceLocationID - int
          CONVERT(VARCHAR,CAST(i.apptdate AS DATETIME),120)+CAST(i.apptstarttime AS datetime)as startdatetime, -- StartDate - datetime  
          DATEADD(MINUTE,at.TimeFrame,CONVERT(VARCHAR,CAST(i.apptdate AS DATETIME),120)+CAST(i.apptstarttime AS datetime))AS enddatetime,
          'P' , -- AppointmentType - varchar(1)
          i.AutoTempID , -- Subject - varchar(64)
          i.apptnote , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          a.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          REPLACE(i.apptstarttime,':',''), -- StartTm - smallint
          REPLACE(CONVERT(CHAR(5),DATEADD(MINUTE,at.TimeFrame,i.apptstarttime),108),':',''), -- EndTm - smallint
		  @VendorImportID
FROM dbo._import_4_1_Appointments i  
	INNER JOIN dbo._import_4_1_Patients ip ON 
		ip.patientid = i.patientid
INNER JOIN patient p ON --p.VendorID = i.patientid
		p.LastName = ip.patientlastname AND 
		p.FirstName = ip.patientfirstname AND 
		dbo.fn_DateOnly(p.DOB) = dbo.fn_DateOnly(ip.patientdob) AND 
		p.PracticeID = @PracticeID 
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = @PracticeID AND
		DK.dt = CAST(CAST(i.apptdate AS DATE) AS DATETIME)
	LEFT JOIN dbo.Appointment a ON a.AppointmentID = i.AutoTempID AND 
		--p.PatientID = a.PatientID AND 
		CAST(i.startdate AS DATETIME) = a.StartDate 
       -- CAST(i.EndDate AS DATETIME) = a.EndDate  
		and a.PracticeID = @PracticeID
	INNER JOIN @ApptTypeTimes at ON at.ApptType=i.appttype
WHERE (i.patientid <> '' OR i.patientid IS NOT NULL) AND a.AppointmentID IS NULL

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
--commit
--rollback
BEGIN TRANSACTION 
PRINT ''
PRINT 'Inserting Into AppointmentToResource...'
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
          1,--d.ProviderTypeID , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          1  -- PracticeID - int



FROM dbo._import_4_1_Appointments i
	INNER JOIN dbo.Appointment a ON 
		--a.AppointmentID = i.AutoTempID  
		a.StartDate = i.startdate
		WHERE a.CreatedDate > DATEADD(mi,-11,GETDATE())


		
     --rollback


	
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into AppointmentReason...'
INSERT INTO dbo.AppointmentReason
        ( PracticeID ,
          Name ,
          DefaultDurationMinutes ,
          DefaultColorCode ,
          Description ,
          ModifiedDate 
          --AppointmentReasonGuid
        )
SELECT DISTINCT
	@PracticeID , -- PracticeID - int
    at.AppointmentType , -- Name - varchar(128)

    0 , -- DefaultDurationMinutes - int
    0 , -- DefaultColorCode - int
    '' , -- Description - varchar(256)
    GETDATE()  -- ModifiedDate - datetime
    --''  -- AppointmentReasonGuid - uniqueidentifier
FROM dbo._import_4_1_Appointments i
INNER JOIN @ApptTypeTimes at ON at.ApptType=i.appttype
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into AppointmenttoAppointmentReason...'
INSERT INTO dbo.AppointmentToAppointmentReason

(
	AppointmentID, 
	AppointmentReasonID, 
	--PrimaryAppointment, 
	--ModifiedDate, 
	--[TIMESTAMP], 
	PracticeID
)

SELECT a.AppointmentID, 
MIN(ar.AppointmentReasonID) AS AppointmentReasonID, 
1--@PracticeID AS PracticeID

FROM Appointment a
INNER JOIN AppointmentReason ar
ON ar.PracticeID = a.PracticeID 
INNER JOIN Patient p
ON a.PatientID = p.PatientID 
INNER JOIN _import_4_1_Appointments iapt
--ON iapt.patientid = Appointment.PatientID
ON p.FirstName = iapt.patientfirstname 
AND p.LastName = iapt.patientlastname
AND a.StartDate = CONVERT(VARCHAR,CAST(iapt.apptdate AS DATETIME),120)+ CAST(iapt.apptstarttime AS DATETIME)
GROUP BY a.AppointmentID

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--ROLLBACK
--COMMIT




