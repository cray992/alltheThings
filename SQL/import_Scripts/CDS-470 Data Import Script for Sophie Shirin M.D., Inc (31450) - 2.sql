USE superbill_31450_dev
--USE superbill_XXX_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
DECLARE @NewVendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 1
Set @NewVendorImportID = 2  -- Vendor import record created through import tool
 

--DELETE FROM dbo.AppointmentToResource WHERE ModifiedDate LIKE
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from AppointmenttoResource'
--DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @NewVendorImportID))
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from AppointmentToAppointmentReason'
--DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @NewVendorImportID)
--PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records deleted from  Appointment '
--DELETE FROM dbo.InsurancePolicy WHERE ModifiedDate = '2014-12-22 10:12:18.967'
--PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from InsurancePolicy'
--DELETE FROM dbo.PatientCaseDate WHERE PatientCaseID IN (SELECT PatientCaseID FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @NewVendorImportID)
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from PatientCaseDate'
--DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @NewVendorImportID
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from PatientCase'
--DELETE FROM dbo.patient WHERE PracticeID = @PracticeID AND VendorImportID = @NewVendorImportID
--PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Patient'



PRINT ''
PRINT 'Deactivating Patient Cases...'
UPDATE dbo.PatientCase
SET Name = '#N/A' ,
	ModifiedDate = GETDATE() ,
	Active = 0
FROM dbo.PatientCase pc
INNER JOIN dbo.[_import_2_1_Policies] i ON
	pc.VendorID = i.ppid AND pc.VendorImportID = @VendorImportID 
WHERE pc.VendorID <> i.chartnumber
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


PRINT ''
PRINT 'Inserting into PatientCase 1 of 2...'
INSERT INTO dbo.PatientCase
        (  
		  PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
     /*   ReferringPhysicianID ,
          EmploymentRelatedFlag ,
          AutoAccidentRelatedFlag ,
          OtherAccidentRelatedFlag ,
          AbuseRelatedFlag ,
          AutoAccidentRelatedState ,   */
          Notes ,
     --   ShowExpiredInsurancePolicies ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
     /*   CaseNumber ,
          WorkersCompContactInfoID ,   */
          VendorID ,
          VendorImportID 
     /*   PregnancyRelatedFlag ,
          StatementActive ,
          EPSDT ,
          FamilyPlanning ,
          EPSDTCodeID ,
          EmergencyRelated ,
          HomeboundRelatedFlag  */
        )
SELECT DISTINCT
          pat.PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
      /*  0 , -- ReferringPhysicianID - int
          NULL , -- EmploymentRelatedFlag - bit
          NULL , -- AutoAccidentRelatedFlag - bit
          NULL , -- OtherAccidentRelatedFlag - bit
          NULL , -- AbuseRelatedFlag - bit
          '' , -- AutoAccidentRelatedState - char(2)    */
          'Created via data import, please review' , -- Notes - text
      --  NULL , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
      /*  '' , -- CaseNumber - varchar(128)
          0 , -- WorkersCompContactInfoID - int   */
          pat.VendorID , -- VendorID - varchar(50)
          @NewVendorImportID  -- VendorImportID - int
      /*  NULL , -- PregnancyRelatedFlag - bit
          NULL , -- StatementActive - bit
          NULL , -- EPSDT - bit
          NULL , -- FamilyPlanning - bit
          0 , -- EPSDTCodeID - int
          NULL , -- EmergencyRelated - bit
          NULL  -- HomeboundRelatedFlag - bit   */
FROM dbo.Patient as pat
INNER JOIN dbo.[_import_2_1_Policies] i ON
	pat.VendorID = i.ppid AND pat.VendorImportID = @VendorImportID 
WHERE pat.VendorID <> i.chartnumber
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into patientcase'


PRINT ''
PRINT 'Inserting into PatientCaseDate 1 of 2...'
INSERT INTO dbo.PatientCaseDate
        ( PracticeID ,
          PatientCaseID ,
          PatientCaseDateTypeID ,
          StartDate ,
          EndDate ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID
        )
SELECT
          @PracticeID , -- PracticeID - int
          patcase.PatientCaseID , -- PatientCaseID - int
          8 , -- PatientCaseDateTypeID - int
          pd.lastvisitdate , -- StartDate - datetime
          NULL , -- EndDate - datetime
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50  -- ModifiedUserID - int
FROM dbo.PatientCase AS patcase        
INNER JOIN dbo.[_import_2_1_Patient] AS pd ON
	pd.ppid = patcase.VendorID AND 
	patcase.VendorImportID = @NewVendorImportID
WHERE pd.lastvisitdate <>''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into PatientCaseDate'


PRINT ''
PRINT 'Inserting records into Patient...'
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
     --   RecordTimeStamp ,
          EmploymentStatus ,
     /*   InsuranceProgramCode ,
          PatientReferralSourceID ,  */ 
          PrimaryProviderID ,  
          DefaultServiceLocationID ,
      --  EmployerID ,   
          MedicalRecordNumber ,
          MobilePhone ,
          MobilePhoneExt ,
      --  PrimaryCarePhysicianID ,  
          VendorID ,
          VendorImportID ,
      --  CollectionCategoryID ,  
          Active ,
      /*  SendEmailCorrespondence ,
          PhonecallRemindersEnabled ,*/
          EmergencyName ,  
		  EmergencyPhone ,
		  EmergencyPhoneExt
      /*  PatientGuid ,
          Ethnicity ,
          Race ,
          LicenseNumber 
          LicenseState ,
          Language1 ,
          Language2       */
        )
SELECT DISTINCT 
          @PracticeID , -- PracticeID - int
          doc.DoctorID , -- ReferringPhysicianID - int
          pd.prefix , -- Prefix - varchar(16)
          pd.firstname , -- FirstName - varchar(64)
          pd.middlename , -- MiddleName - varchar(64)
          pd.lastname , -- LastName - varchar(64)
          pd.suffix , -- Suffix - varchar(16)
          pd.Address1, -- AddressLine1 - varchar(256)
          pd.Address2 , -- AddressLine2 - varchar(256)
          pd.city , -- City - varchar(128)
          CASE WHEN pd.state = 'KIE' THEN 'KI'
		       WHEN pd.state = 'ONT' THEN 'ON' ELSE pd.state END, -- State - varchar(2) 
          '' , -- Country - varchar(32)  
		  LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pd.zip,'-','')),9) , -- ZipCode - varchar(9)
          pd.sex , -- Gender - varchar(1)
          CASE pd.maritalstat WHEN 'DIVORCED' THEN 'D'
		   					    WHEN 'MARRIED' THEN 'M'
							    WHEN 'SINGLE' THEN 'S'
							    WHEN 'WIDOWED' THEN 'W'
								WHEN 'Div/Sep' THEN 'L'
								WHEN 'OTHER' THEN ''
								WHEN 'Unknown or other' THEN ''
					 END , -- MaritalStatus - varchar(1)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pd.homephone,'-','')),10) , -- HomePhone - varchar(10)
          SUBSTRING(dbo.fn_RemoveNonNumericCharacters(pd.homephone),11,13) , -- HomePhoneExt - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pd.workphone,'-','')),10) , -- WorkPhone - varchar(10)
          SUBSTRING(dbo.fn_RemoveNonNumericCharacters(pd.workphone),11,15) , -- WorkPhoneExt - varchar(10)   
          pd.birthdate , -- DOB - datetime
          CASE WHEN LEN(pd.patientssn) >= 6 THEN RIGHT( '000'  + pd.patientssn, 9) ELSE '' END , -- SSN - char(9)
          pd.emailaddress , -- EmailAddress - varchar(256)
          CASE WHEN pd.resppartfirst <> pd.firstname OR pd.resppartlast <> pd.lastname THEN 1 ELSE 0 END , --  ResponsibleDifferentThanPatient - BIT 
          '' , -- ResponsiblePrefix - varchar(16)
          CASE WHEN pd.resppartfirst <> pd.firstname OR pd.resppartlast <> pd.lastname THEN pd.resppartfirst ELSE '' END , -- ResponsibleFirstName - varchar(64)
          CASE WHEN pd.resppartfirst <> pd.firstname OR pd.resppartlast <> pd.lastname THEN pd.resppartmiddle ELSE '' END , -- ResponsibleMiddleName - varchar(64)
          CASE WHEN pd.resppartfirst <> pd.firstname OR pd.resppartlast <> pd.lastname THEN pd.resppartlast ELSE '' END , -- ResponsibleLastName - varchar(64)
          CASE WHEN pd.resppartfirst <> pd.firstname OR pd.resppartlast <> pd.lastname THEN pd.resppartsuffix ELSE '' END , -- ResponsibleSuffix - varchar(16)
          CASE pd.guarantorrelationship WHEN 'CHILD' THEN 'C'
			   					 WHEN 'OTHER' THEN 'O'
								 WHEN '' THEN 'O'
								 WHEN 'SPOUSE' THEN 'U' 
								 WHEN 'Self' THEN 'S'
							END , -- ResponsibleRelationshipToPatient - varchar(1)
          CASE WHEN pd.resppartfirst <> pd.firstname OR pd.resppartlast <> pd.lastname THEN pd.resppartadd1 ELSE '' END , -- ResponsibleAddressLine1 - varchar(256)
          CASE WHEN pd.resppartfirst <> pd.firstname OR pd.resppartlast <> pd.lastname THEN pd.resppartadd2 ELSE '' END , -- ResponsibleAddressLine2 - varchar(256)
          CASE WHEN pd.resppartfirst <> pd.firstname OR pd.resppartlast <> pd.lastname THEN pd.resppartcity ELSE '' END , -- ResponsibleCity - varchar(128)
          CASE WHEN pd.resppartfirst <> pd.firstname OR pd.resppartlast <> pd.lastname THEN LEFT(pd.resppartstate, 2) ELSE '' END, -- ResponsibleState - varchar(2) 
          '' , -- ResponsibleCountry - varchar(32)
          CASE WHEN pd.resppartfirst <> pd.firstname OR pd.resppartlast <> pd.lastname THEN LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pd.resppartzip,'-','')),9) ELSE '' END , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
         CASE pd.Employstat WHEN 'Employed' THEN 'E'
		   					WHEN 'Retired' THEN 'R'
							      ELSE 'U' END , -- EmploymentStatus - char(1)
      /*  '' , -- InsuranceProgramCode - char(2)
          0 , -- PatientReferralSourceID - int*/
          1 , -- PrimaryProviderID - int
          1 ,  -- DefaultServiceLocationID - int
     --  '' , -- EmployerID - int     
          pd.chartnumber , -- MedicalRecordNumber - varchar(128)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pd.mobilephone,'-','')),10),  -- MobilePhone - varchar(10)
          SUBSTRING(dbo.fn_RemoveNonNumericCharacters(pd.mobilephone),11,14) , -- MobilePhoneExt - varchar(10)
      --  '' , -- PrimaryCarePhysicianID - int    
          pd.ppid, -- VendorID - varchar(50)
          @NewVendorImportID , -- VendorImportID - int
      --  0 , -- CollectionCategoryID - int
          CASE WHEN pd.patientstatus = 'Active' THEN 1 ELSE 0 END ,  -- Active - bit
      --  NULL , -- SendEmailCorrespondence - bit
      --  NULL , -- PhonecallRemindersEnabled - bit
          pd.emergencyname , -- EmergencyName - varchar(128)
		  LEFT(dbo.fn_RemoveNonNumericCharacters(pd.emergencyphone),10) ,  -- EmergencyPhone
		  SUBSTRING(dbo.fn_RemoveNonNumericCharacters(pd.emergencyphone),11,15)
      /*  NULL , -- PatientGuid - uniqueidentifier
          '' , -- Ethnicity - varchar(64)
          '' , -- Race - varchar(64)
          '',  -- LicenseNumber - varchar(64)
          '' , -- LicenseState - varchar(2)
          '' , -- Language1 - varchar(64)
          ''  -- Language2 - varchar(64)       */
FROM dbo.[_import_2_1_Patienttwo] as pd
LEFT JOIN dbo.doctor as doc ON
        doc.vendorID = pd.refphysicianid AND
        doc.VendorImportID = @VendorImportID
WHERE NOT EXISTS (SELECT FirstName, LastName, DOB FROM dbo.Patient p 
					WHERE pd.firstname = p.FirstName AND 
						  pd.lastname = p.LastName AND
						  DATEADD(hh,12,CAST(pd.birthdate AS DATETIME)) = p.DOB AND
						  p.PracticeID = @PracticeID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into patient Successfully'


PRINT ''
PRINT 'Inserting into PatientCase 2 of 2...'
INSERT INTO dbo.PatientCase
        (  
		  PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
     /*   ReferringPhysicianID ,
          EmploymentRelatedFlag ,
          AutoAccidentRelatedFlag ,
          OtherAccidentRelatedFlag ,
          AbuseRelatedFlag ,
          AutoAccidentRelatedState ,   */
          Notes ,
     --   ShowExpiredInsurancePolicies ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
     /*   CaseNumber ,
          WorkersCompContactInfoID ,   */
          VendorID ,
          VendorImportID 
     /*   PregnancyRelatedFlag ,
          StatementActive ,
          EPSDT ,
          FamilyPlanning ,
          EPSDTCodeID ,
          EmergencyRelated ,
          HomeboundRelatedFlag  */
        )
SELECT DISTINCT
          pat.PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
      /*  0 , -- ReferringPhysicianID - int
          NULL , -- EmploymentRelatedFlag - bit
          NULL , -- AutoAccidentRelatedFlag - bit
          NULL , -- OtherAccidentRelatedFlag - bit
          NULL , -- AbuseRelatedFlag - bit
          '' , -- AutoAccidentRelatedState - char(2)    */
          'Created via data import, please review' , -- Notes - text
      --  NULL , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
      /*  '' , -- CaseNumber - varchar(128)
          0 , -- WorkersCompContactInfoID - int   */
          pat.VendorID , -- VendorID - varchar(50)
          @NewVendorImportID  -- VendorImportID - int
      /*  NULL , -- PregnancyRelatedFlag - bit
          NULL , -- StatementActive - bit
          NULL , -- EPSDT - bit
          NULL , -- FamilyPlanning - bit
          0 , -- EPSDTCodeID - int
          NULL , -- EmergencyRelated - bit
          NULL  -- HomeboundRelatedFlag - bit   */
FROM dbo.Patient as pat
WHERE pat.VendorImportID = @NewVendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into patientcase'


PRINT ''
PRINT 'Inserting into PatientCaseDate 2 of 2...'
INSERT INTO dbo.PatientCaseDate
        ( PracticeID ,
          PatientCaseID ,
          PatientCaseDateTypeID ,
          StartDate ,
          EndDate ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID
        )
SELECT
          @PracticeID , -- PracticeID - int
          patcase.PatientCaseID , -- PatientCaseID - int
          8 , -- PatientCaseDateTypeID - int
          pd.lastvisitdate , -- StartDate - datetime
          NULL , -- EndDate - datetime
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50  -- ModifiedUserID - int
FROM dbo.PatientCase AS patcase        
INNER JOIN dbo.[_import_2_1_Patienttwo] as pd ON
      pd.ppid = patcase.VendorID AND
	  patcase.VendorImportID = @NewVendorImportID
WHERE pd.lastvisitdate <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into PatientCaseDate'


PRINT ''
PRINT 'Inserting Into Insurance Policy...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
      --  PolicyStartDate ,
      --  PolicyEndDate ,
      --  CardOnFile ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
          HolderSSN ,
      --  HolderThroughEmployer ,
      --  HolderEmployerName ,
      --  PatientInsuranceStatusID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
      --  RecordTimeStamp ,
      --  HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,  
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
      /*  HolderPhone ,
          HolderPhoneExt , */
          DependentPolicyNumber ,
   /*     Notes ,
          Phone ,
          PhoneExt ,
          Fax ,
          FaxExt ,     
          Copay , 
          Deductible , */
     --   PatientInsuranceNumber , 
          Active ,
          PracticeID ,
      /*  AdjusterPrefix ,
          AdjusterFirstName ,
          AdjusterMiddleName ,
          AdjusterLastName ,
          AdjusterSuffix ,     */
          VendorID ,
          VendorImportID 
      --  InsuranceProgramTypeID ,
      --  GroupName ,
      --  ReleaseOfInformation ,
      --  SyncWithEHR ,
      --  InsurancePolicyGuid
        )
SELECT DISTINCT
          patcase.PatientCaseID , -- PatientCaseID - int
          inscoplan.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          ip.orderforclaims , -- Precedence - int
          ip.policynumber , -- PolicyNumber - varchar(32)
          ip.GroupNumber , -- GroupNumber - varchar(32)
      --  '' , -- PolicyStartDate - datetime
      --  '' , -- PolicyEndDate - datetime
      --  NULL , -- CardOnFile - bit
          CASE WHEN ip.guarantorrelationship = 'CHILD' THEN 'C'
		       WHEN ip.guarantorrelationship = 'SELF' THEN 'S'
			   WHEN	ip.guarantorrelationship = 'SPOUSE' THEN 'U'
			   WHEN	ip.guarantorrelationship = 'OTHER' THEN 'O'
					                           ELSE 'S'  END , -- PatientRelationshipToInsured - varchar(1) 
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN ip.patientsameasguarantor = '0' THEN ip.resppartfirst END, -- HolderFirstName - varchar(64)
          CASE WHEN ip.patientsameasguarantor = '0' THEN ip.resppartmiddle END , -- HolderMiddleName - varchar(64)
          CASE WHEN ip.patientsameasguarantor = '0' THEN ip.resppartlast END , -- HolderLastName - varchar(64)
          CASE WHEN ip.patientsameasguarantor = '0' THEN ip.resppartsuffix END  , -- HolderSuffix - varchar(16)
          CASE WHEN ip.patientsameasguarantor = '0' THEN CASE WHEN ip.resppartbday = '1/1/1900' THEN NULL ELSE ip.resppartbday END END, -- HolderDOB - datetime  
          CASE WHEN ip.patientsameasguarantor = '0'  THEN 
		  CASE WHEN LEN(ip.resppartssn) >= 6 THEN RIGHT ('000' + ip.resppartssn, 9) ELSE '' END END , -- HolderSSN - char(11)
      --  NULL , -- HolderThroughEmployer - bit
      --  '' , -- HolderEmployerName - varchar(128)
      --  0 , -- PatientInsuranceStatusID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
      --  '' , -- HolderGender - char(1)
          CASE WHEN ip.patientsameasguarantor = '0' THEN ip.resppartadd1 END  , -- HolderAddressLine1 - varchar(256)
          CASE WHEN ip.patientsameasguarantor = '0' THEN ip.resppartadd2 END  , -- HolderAddressLine2 - varchar(256) 
          CASE WHEN ip.patientsameasguarantor = '0' THEN ip.resppartcity END   , -- HolderCity - varchar(128)  
          CASE WHEN ip.patientsameasguarantor = '0' THEN ip.resppartstate END , -- HolderState - varchar(2)
          '' , -- HolderCountry - varchar(32)
          CASE WHEN ip.patientsameasguarantor = '0' THEN LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(ip.resppartzip,'-','')),9) END  , -- HolderZipCode - varchar(9)
      --  '' , -- HolderPhone - varchar(10)  
      --  '' , -- HolderPhoneExt - varchar(10)
          CASE WHEN ip.patientsameasguarantor = '0' THEN ip.policynumber END , -- DependentPolicyNumber - varchar(32)
      /*  '' , -- Notes - text
          '' , -- Phone - varchar(10)
          '' , -- PhoneExt - varchar(10)
          '' , -- Fax - varchar(10)
          '' , -- FaxExt - varchar(10)   
          '' , -- Copay - money  
          '' , -- Deductible - money
      --  '' , -- PatientInsuranceNumber - varchar(32) */
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
      /*  '' , -- AdjusterPrefix - varchar(16)
          '' , -- AdjusterFirstName - varchar(64)
          '' , -- AdjusterMiddleName - varchar(64)
          '' , -- AdjusterLastName - varchar(64)
          '' , -- AdjusterSuffix - varchar(16)     */
          ip.policynumber , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
      --  0 , -- InsuranceProgramTypeID - int
      --  '' , -- GroupName - varchar(14)
      --  '' , -- ReleaseOfInformation - varchar(1)
      --  NULL , -- SyncWithEHR - bit
      --  NULL  -- InsurancePolicyGuid - uniqueidentifier
FROM [dbo].[_import_2_1_Policies] as ip
INNER JOIN dbo.PatientCase AS patcase ON 
    patcase.vendorID = ip.ppid AND 
    patcase.vendorimportID = @newvendorimportID     
INNER JOIN dbo.InsuranceCompanyPlan AS inscoplan ON
    inscoplan.VendorID = ip.insurancecarriersid AND
    inscoplan.VendorImportID = @VendorImportID
WHERE ip.policynumber <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Inserted into Insurance Policy Successfully'


PRINT ''
PRINT 'Updating Other Appointment to Primary...'
UPDATE dbo.Appointment 
SET AppointmentType = 'P' , 
	PatientID = pat.patientid ,
	PatientCaseID = pc.patientcaseid ,
	ModifiedDate = GETDATE() ,
	[Subject] = ia.PatientVisitId + ia.ppppid
FROM dbo.[_import_2_1_Appointment] as ia 
INNER JOIN dbo.patient AS pat ON
  pat.VendorID = ia.ppppid and
  pat.VendorImportID IN (@VendorImportID, @NewVendorImportID)
INNER JOIN dbo.Appointment a ON 
  a.[Subject] = ia.firstname + ' ' + ia.lastname AND
 -- a.[Subject] = ia.PatientVisitId + ia.ppppid AND
  a.startdate = CAST(ia.startdate AS DATETIME) AND 
  a.enddate = CAST(ia.enddate AS DATETIME) 
LEFT JOIN dbo.PatientCase pc ON
  pc.VendorID = ia.ppppid AND
  pc.VendorImportID IN (@NewVendorImportID, @VendorImportID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records Inserted into Appointment Successfully'


PRINT ''
PRINT 'Updating Appointment Patient Case...'
UPDATE dbo.Appointment 
SET PatientCaseID = pc.PatientCaseID
FROM dbo.[_import_2_1_Appointment] ia
INNER JOIN dbo.patient AS pat ON
  pat.VendorID = ia.ppppid and
  pat.VendorImportID = @VendorImportID
INNER JOIN dbo.Appointment a ON 
  a.[Subject] = ia.PatientVisitId + ia.ppppid AND
  a.startdate = CAST(ia.startdate AS DATETIME) AND 
  a.enddate = CAST(ia.enddate AS DATETIME) 
INNER JOIN dbo.PatientCase pc ON
  pc.PatientID = pat.PatientID AND
  pc.VendorImportID = @NewVendorImportID
WHERE pc.ModifiedDate > DATEADD(s, -100, GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


PRINT ''
PRINT 'Inserting into Appointment To Appointment Reason'
INSERT INTO dbo.AppointmentToAppointmentReason
        ( AppointmentID ,
          AppointmentReasonID ,
          PrimaryAppointment ,
          ModifiedDate ,
	  --  TIMESTAMP ,
          PracticeID
        )
SELECT  DISTINCT
          dboa.AppointmentID , -- AppointmentID - int
          ar.AppointmentReasonID , -- AppointmentReasonID - int
          1 , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
	  --  NULL , -- TIMESTAMP - timestamp
          @PracticeID  -- PracticeID - int
FROM dbo._import_2_1_Appointment as ia
INNER JOIN dbo.Appointment as dboa ON
     dboa.practiceID = @practiceID AND
     dboa.[subject] = ia.PatientVisitId + ia.ppppid AND
     dboa.startdate = CAST(ia.startdate AS DATETIME) AND 
     dboa.enddate = CAST(ia.enddate AS DATETIME)  
INNER JOIN dbo.AppointmentReason AS ar ON 
     ar.name = ia.appttype AND 
	 ar.PracticeID = @PracticeID
WHERE dboa.ModifiedDate > DATEADD(s, -100, GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted Appointment To Appointment Reason'


PRINT '' 
PRINT 'updating patient case with PayerScenarioID'
Update dbo.patientcase set PayerScenarioID=11, name='Self Pay' from dbo.patientcase as patcase 
LEFT JOIN dbo.insurancepolicy as ip ON
ip.patientcaseID = patcase.patientcaseID 
where patcase.VendorImportID = @NewVendorImportID AND
ip.patientcaseID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated into patient case '

--ROLLBACK
--COMMIT



