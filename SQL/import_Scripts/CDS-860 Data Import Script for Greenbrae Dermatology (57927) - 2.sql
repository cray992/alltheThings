USE superbill_57927_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 3

SET NOCOUNT ON 

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
          WorkPhone ,
          DOB ,
          SSN ,
		  ResponsibleDifferentThanPatient ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          EmployerID ,
          MedicalRecordNumber ,
          VendorID ,
          VendorImportID ,
          CollectionCategoryID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled , 
		  PrimaryProviderID
        )
SELECT DISTINCT
	      @PracticeID , -- PracticeID - int
          rd.DoctorID , -- ReferringPhysicianID - int
          '' , -- Prefix - varchar(16)
          i.dependentname , -- FirstName - varchar(64)
          i.depmiddleinitial , -- MiddleName - varchar(64)
          i.lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          i.depaddress1 , -- AddressLine1 - varchar(256)
          i.depaddress2 , -- AddressLine2 - varchar(256)
          i.depcity, -- City - varchar(128)
          LEFT(i.depstate ,2) , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(i.depzip,'-',''),' ',''),'=',''),'r',''),'.','')) IN (4,8) 
					THEN '0' + (REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(i.depzip,'-',''),' ',''),'=',''),'r',''),'.',''))
			   WHEN LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(i.depzip,'-',''),' ',''),'=',''),'r',''),'.','')) IN (5,9) 
					THEN REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(i.depzip,'-',''),' ',''),'=',''),'r',''),'.','')
		  ELSE '00000' END , -- ZipCode - varchar(9)
          i.sex , -- Gender - varchar(1)
          CASE i.maritalstatus WHEN 'D' THEN 'D'
							WHEN 'S' THEN 'S'
							WHEN 'W' THEN 'W' 
							WHEN 'M' THEN 'M' ELSE '' END , -- MaritalStatus - varchar(1)
          CASE WHEN LEN(i.depphone) < 9 THEN '' ELSE i.depphone END , -- HomePhone - varchar(10)
          CASE WHEN LEN(i.depphone2) < 9 THEN '' ELSE i.depphone2 END , -- WorkPhone - varchar(10)
          CASE WHEN LEN(i.dateofbirth) = 8 THEN CONVERT(VARCHAR(10),CAST(i.dateofbirth AS DATE),101) ELSE '1901-01-01 12:00:00.000' END , -- DOB - datetime
          CASE WHEN LEN(i.socialsec) >= 6 THEN RIGHT('000' + i.socialsec, 9) ELSE '' END , -- SSN - char(9)
          0 , -- ResponsibleDifferentThanPatient - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE i.employmentstatus WHEN 'E' THEN 'E'
					   WHEN 'R' THEN 'R'
					   WHEN 'RE' THEN 'R'
					   WHEN 'RET' THEN 'R'
					   WHEN 'S' THEN 'S'
					   WHEN 'Y' THEN 'E'
					   WHEN 'YES' THEN 'E' ELSE 'U' END , -- EmploymentStatus - char(1)
          e.EmployerID , -- EmployerID - int
          i.account + '.' + i.dependentnumber , -- MedicalRecordNumber - varchar(128)
          i.account + '.' + i.dependentnumber, -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- CollectionCategoryID - int
          1 , -- Active - bit
          0 , -- SendEmailCorrespondence - bit
          0 , -- PhonecallRemindersEnabled - bit
		  dr.DoctorID
FROM dbo._import_3_1_DepFile i
LEFT JOIN dbo.Doctor rd ON
	rd.VendorID = i.defaultreferringdr AND
	rd.VendorImportID = @VendorImportID
LEFT JOIN dbo.Employers e ON 
	i.depemployer = e.EmployerName 
LEFT JOIN dbo._import_3_1_DrFile pdr ON 
	i.defaultdoctor = pdr.drno
LEFT JOIN dbo.Doctor dr ON
	pdr.drfname = dr.FirstName AND 
	pdr.drnatlprovid = dr.NPI AND
	dr.PracticeID = @PracticeID AND
    dr.[External] = 0
LEFT JOIN dbo.Patient p ON 
	p.FirstName = i.dependentname AND
	p.LastName = i.lastname AND
	p.DOB = CASE WHEN LEN(i.dateofbirth) = 8 THEN DATEADD(hh,12,CAST(CONVERT(VARCHAR(10),CAST(i.dateofbirth AS DATE),101) AS DATETIME)) ELSE '1901-01-01 12:00:00.000' END 
WHERE i.dependentname <> '' AND i.lastname <> '' AND p.PatientID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
--7114

PRINT ''
PRINT 'Inserting into PatientCase'
INSERT INTO dbo.PatientCase
        ( PatientID ,
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
	      PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          NULL , -- ReferringPhysicianID - int
          0 , -- EmploymentRelatedFlag - bit
          0 , -- AutoAccidentRelatedFlag - bit
          0 , -- OtherAccidentRelatedFlag - bit
          0 , -- AbuseRelatedFlag - bit
          NULL , -- AutoAccidentRelatedState - char(2)
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          1 , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          NULL , -- CaseNumber - varchar(128)
          NULL , -- WorkersCompContactInfoID - int
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
WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

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
          1 , -- ServiceLocationID - int
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          LEFT(i.aptuniq, 64) , -- Subject - varchar(64)
          '' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
		  CAST(REPLACE(RIGHT(i.startdate,5), ':','') AS SMALLINT) , -- StartTm - smallint
          CAST(REPLACE(RIGHT(i.enddate,5), ':','') AS SMALLINT)   -- EndTm - smallint
FROM dbo._import_2_1_Appointments i
INNER JOIN dbo.patient AS p ON
  p.VendorID = i.aptaccount +  '.' + i.aptdepno and
  p.VendorImportID = @VendorImportID
LEFT JOIN dbo.patientcase AS pc ON
  pc.patientID = p.patientID AND
  pc.VendorImportID = @VendorImportID
INNER JOIN dbo.DateKeyToPractice AS dk ON 
  dk.PracticeID = @PracticeID AND 
  dk.Dt = CAST(CAST(i.startdate AS date) AS DATETIME) 
LEFT JOIN dbo.Appointment a ON 
	CAST(i.startdate AS DATETIME) = a.StartDate AND
	CAST(i.enddate AS DATETIME) = a.EndDate AND
	p.PatientID = a.PatientID AND
	a.PracticeID = @PracticeID 
WHERE a.AppointmentID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into AppointmenttoAppointmentReason...'
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
FROM dbo._import_2_1_Appointments i
INNER JOIN dbo._import_3_1_RsnFile irsn ON 
	i.aptreason = irsn.reason
INNER JOIN dbo.AppointmentReason ar ON
	ar.Name = irsn.[description] AND
	ar.PracticeID = @PracticeID
INNER JOIN dbo.Patient p ON 
	i.aptaccount + '.' + i.aptdepno = p.VendorID AND 
	p.VendorImportID = @VendorImportID
INNER JOIN dbo.Appointment a ON
	a.PatientID = p.PatientID AND
	a.StartDate = CAST(i.startdate AS DATETIME) AND
	a.EndDate = CAST(i.enddate AS DATETIME) AND
	a.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into AppointmenttoResource...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  a.AppointmentID , -- AppointmentID - int
		  1, -- AppointmentResourceTypeID - int
          CASE WHEN dr.DoctorID IS NULL THEN 1 ELSE dr.DoctorID END , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo._import_2_1_Appointments i
INNER JOIN dbo.Patient p ON 
	i.aptaccount + '.' + i.aptdepno = p.VendorID AND 
	p.VendorImportID = @VendorImportID
INNER JOIN dbo.Appointment a ON
	a.PatientID = p.PatientID AND
	a.StartDate = CAST(i.startdate AS DATETIME) AND
	a.EndDate = CAST(i.enddate AS DATETIME) AND
	a.PracticeID = @PracticeID
INNER JOIN dbo._import_3_1_DrFile idr ON 
	i.aptdr = idr.drno
LEFT JOIN dbo.Doctor dr ON 
	idr.drfname = dr.FirstName AND
	idr.drnatlprovid = dr.NPI AND
	dr.PracticeID = @PracticeID AND 
	dr.[External] = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

INSERT INTO dbo.Employers
        ( EmployerName ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID
        )
SELECT DISTINCT
		  i.depemployer , -- EmployerName - varchar(128)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo._import_3_1_DepFile i 
	LEFT JOIN dbo.Employers e ON 
		i.depemployer = e.EmployerName 
WHERE e.EmployerID IS NULL AND i.depemployer <> ''

INSERT INTO dbo.Employers
        ( EmployerName ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID
        )
SELECT DISTINCT
		  i.ipremplname , -- EmployerName - varchar(128)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo._import_3_1_IprFile i 
	LEFT JOIN dbo.Employers e ON 
		i.ipremplname = e.EmployerName 
WHERE e.EmployerID IS NULL AND i.ipremplname <> ''

UPDATE dbo._import_3_1_IprFile SET iprno = iprno + '1'
WHERE iprno = '6092' AND iprfname = 'stephanie' AND iprlname = 'guerro'

CREATE TABLE #tempins ( PCID INT , ICPID INT , Precedence INT , PolicyNumber VARCHAR(32) , GroupNumber VARCHAR(32) , 
						PolicyStartDate DATE , PolicyEndDate DATE , 
						PatRelationtoInsured VARCHAR(1) , HolderFirstName VARCHAR(64) , HolderMiddleName VARCHAR(64) , 
						HolderLastName VARCHAR(64) , HolderDOB DATE , HolderGender CHAR(1) , HolderThroughEmployer BIT ,
						HolderEmployerName VARCHAR(128) , HolderAddressLine1 VARCHAR(256) , HolderAddressLine2 VARCHAR(256) ,
						HolderCity VARCHAR(128) , HolderState VARCHAR(2) , HolderCountry VARCHAR(32) , HolderZipCode VARCHAR(9) ,
						HolderPhone VARCHAR(10) , DependentPolicyNumber VARCHAR(32) , Notes VARCHAR(MAX) , VendorID VARCHAR(50))

INSERT INTO #tempins
        ( PCID ,
          ICPID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
		  PolicyStartDate ,
		  PolicyEndDate ,
          PatRelationtoInsured ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderDOB ,
          HolderGender ,
          HolderThroughEmployer ,
          HolderEmployerName ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          HolderPhone ,
          DependentPolicyNumber ,
          Notes ,
          VendorID
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PCID - int
          icp.InsuranceCompanyPlanID , -- ICPID - int
          1 , -- Precedence - int
          ins.insid , -- PolicyNumber - varchar(32)
          ins.insgroup , -- GroupNumber - varchar(32)
		  CASE WHEN ins.insstartdt = '0' THEN NULL ELSE CONVERT(VARCHAR(10),CAST(ins.insstartdt AS DATE),101) END , -- PolicyStartDate datetime
		  CASE WHEN ins.insenddt = '0' THEN NULL ELSE CONVERT(VARCHAR(10),CAST(ins.insenddt AS DATE),101) END , -- PolicyEndDate datetime
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.firstname THEN 'O' ELSE 'S' END , -- PatRelationtoInsured - varchar(1)
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName THEN ip.iprfname END , -- HolderFirstName - varchar(64)
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName THEN ip.iprmi END , -- HolderMiddleName - varchar(64)
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName THEN ip.iprlname END , -- HolderLastName - varchar(64)
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName THEN 
			CASE WHEN ip.iprdob = '0' THEN NULL ELSE CONVERT(VARCHAR(10),CAST(ip.iprdob AS DATE),101) END END , -- HolderDOB - datetime
		  CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName THEN 
			CASE ip.iprsex WHEN 'M' THEN 'M' WHEN 'F' THEN 'F' ELSE 'U' END END , -- HolderGender - char(1)
          CASE WHEN ins.insempl = 'Y' THEN 1 ELSE 0 END , -- HolderThroughEmployer - bit
          CASE WHEN ins.insempl = 'Y' THEN e.EmployerName END , -- HolderEmployerName - varchar(128)
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName THEN ip.ipraddr END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName THEN '' END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName THEN ip.iprcity END , -- HolderCity - varchar(128)
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName THEN LEFT(ip.iprstate, 2) END , -- HolderState - varchar(2)
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName THEN '' END , -- HolderCountry - varchar(32)
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName THEN 
			CASE WHEN LEN(REPLACE(REPLACE(ip.iprzip,' ',''),'-','')) IN (4,8) THEN '0' + REPLACE(REPLACE(ip.iprzip,' ',''),'-','')
			ELSE LEFT(REPLACE(REPLACE(ip.iprzip,' ',''),'-',''), 9) END END , -- HolderZipCode - varchar(9)
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName THEN ip.iprphone END , -- HolderPhone - varchar(10)
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName AND ip.iprlname <> p.LastName THEN ins.insid END , -- DependentPolicyNumber - varchar(32)
          CASE WHEN ins.insstatus = '' THEN '' ELSE 'Insurance Status: ' + ins.insstatus END , -- Notes - text
          pc.VendorID  -- VendorID - varchar(50)
FROM dbo.PatientCase pc
INNER JOIN dbo.Patient p ON	
	pc.PatientID = p.PatientID AND
	p.VendorImportID = @VendorImportID
LEFT JOIN dbo._import_3_1_InsFile ins ON
	pc.VendorID = ins.insaccount + '.' + ins.insdep
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.VendorID = ins.insconum AND
	icp.VendorImportID = 1
INNER JOIN dbo._import_3_1_DepFile i ON
	p.VendorID = i.account + '.' + i.dependentnumber
LEFT JOIN dbo.[_import_3_1_Iprfile] ip ON
	ins.insipr = ip.iprno 
LEFT JOIN dbo.Employers e ON
	ip.ipremplname = e.EmployerName
WHERE pc.VendorImportID = @VendorImportID AND i.preferredplan1 = icp.VendorID

UNION 

SELECT DISTINCT
		  pc.PatientCaseID , -- PCID - int
          icp.InsuranceCompanyPlanID , -- ICPID - int
          2 , -- Precedence - int
          ins.insid , -- PolicyNumber - varchar(32)
          ins.insgroup , -- GroupNumber - varchar(32)
		  CASE WHEN ins.insstartdt = '0' THEN NULL ELSE CONVERT(VARCHAR(10),CAST(ins.insstartdt AS DATE),101) END , -- PolicyStartDate datetime
		  CASE WHEN ins.insenddt = '0' THEN NULL ELSE CONVERT(VARCHAR(10),CAST(ins.insenddt AS DATE),101) END , -- PolicyEndDate datetime
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.firstname THEN 'O' ELSE 'S' END , -- PatRelationtoInsured - varchar(1)
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName THEN ip.iprfname END , -- HolderFirstName - varchar(64)
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName THEN ip.iprmi END , -- HolderMiddleName - varchar(64)
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName THEN ip.iprlname END , -- HolderLastName - varchar(64)
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName THEN 
			CASE WHEN ip.iprdob = '0' THEN NULL ELSE CONVERT(VARCHAR(10),CAST(ip.iprdob AS DATE),101) END END , -- HolderDOB - datetime
		  CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName THEN 
			CASE ip.iprsex WHEN 'M' THEN 'M' WHEN 'F' THEN 'F' ELSE 'U' END END , -- HolderGender - char(1)
          CASE WHEN ins.insempl = 'Y' THEN 1 ELSE 0 END , -- HolderThroughEmployer - bit
          CASE WHEN ins.insempl = 'Y' THEN e.EmployerName END , -- HolderEmployerName - varchar(128)
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName THEN ip.ipraddr END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName THEN '' END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName THEN ip.iprcity END , -- HolderCity - varchar(128)
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName THEN LEFT(ip.iprstate, 2) END , -- HolderState - varchar(2)
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName THEN '' END , -- HolderCountry - varchar(32)
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName THEN 
			CASE WHEN LEN(REPLACE(REPLACE(ip.iprzip,' ',''),'-','')) IN (4,8) THEN '0' + REPLACE(REPLACE(ip.iprzip,' ',''),'-','')
			ELSE LEFT(REPLACE(REPLACE(ip.iprzip,' ',''),'-',''), 9) END END , -- HolderZipCode - varchar(9)
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName THEN ip.iprphone END , -- HolderPhone - varchar(10)
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName AND ip.iprlname <> p.LastName THEN ins.insid END , -- DependentPolicyNumber - varchar(32)
          CASE WHEN ins.insstatus = '' THEN '' ELSE 'Insurance Status: ' + ins.insstatus END , -- Notes - text
          pc.VendorID  -- VendorID - varchar(50)
FROM dbo.PatientCase pc
INNER JOIN dbo.Patient p ON	
	pc.PatientID = p.PatientID AND
	p.VendorImportID = @VendorImportID
LEFT JOIN dbo._import_3_1_InsFile ins ON
	pc.VendorID = ins.insaccount + '.' + ins.insdep
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.VendorID = ins.insconum AND
	icp.VendorImportID = 1
INNER JOIN dbo._import_3_1_DepFile i ON
	p.VendorID = i.account + '.' + i.dependentnumber
LEFT JOIN dbo.[_import_3_1_Iprfile] ip ON
	ins.insipr = ip.iprno 
LEFT JOIN dbo.Employers e ON
	ip.ipremplname = e.EmployerName
WHERE pc.VendorImportID = @VendorImportID AND i.preferredplan2 = icp.VendorID

UNION 

SELECT DISTINCT
		  pc.PatientCaseID , -- PCID - int
          icp.InsuranceCompanyPlanID , -- ICPID - int
          3 , -- Precedence - int
          ins.insid , -- PolicyNumber - varchar(32)
          ins.insgroup , -- GroupNumber - varchar(32)
		  CASE WHEN ins.insstartdt = '0' THEN NULL ELSE CONVERT(VARCHAR(10),CAST(ins.insstartdt AS DATE),101) END , -- PolicyStartDate datetime
		  CASE WHEN ins.insenddt = '0' THEN NULL ELSE CONVERT(VARCHAR(10),CAST(ins.insenddt AS DATE),101) END , -- PolicyEndDate datetime
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.firstname THEN 'O' ELSE 'S' END , -- PatRelationtoInsured - varchar(1)
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName THEN ip.iprfname END , -- HolderFirstName - varchar(64)
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName THEN ip.iprmi END , -- HolderMiddleName - varchar(64)
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName THEN ip.iprlname END , -- HolderLastName - varchar(64)
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName THEN 
			CASE WHEN ip.iprdob = '0' THEN NULL ELSE CONVERT(VARCHAR(10),CAST(ip.iprdob AS DATE),101) END END , -- HolderDOB - datetime
		  CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName THEN 
			CASE ip.iprsex WHEN 'M' THEN 'M' WHEN 'F' THEN 'F' ELSE 'U' END END , -- HolderGender - char(1)
          CASE WHEN ins.insempl = 'Y' THEN 1 ELSE 0 END , -- HolderThroughEmployer - bit
          CASE WHEN ins.insempl = 'Y' THEN e.EmployerName END , -- HolderEmployerName - varchar(128)
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName THEN ip.ipraddr END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName THEN '' END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName THEN ip.iprcity END , -- HolderCity - varchar(128)
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName THEN LEFT(ip.iprstate, 2) END , -- HolderState - varchar(2)
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName THEN '' END , -- HolderCountry - varchar(32)
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName THEN 
			CASE WHEN LEN(REPLACE(REPLACE(ip.iprzip,' ',''),'-','')) IN (4,8) THEN '0' + REPLACE(REPLACE(ip.iprzip,' ',''),'-','')
			ELSE LEFT(REPLACE(REPLACE(ip.iprzip,' ',''),'-',''), 9) END END , -- HolderZipCode - varchar(9)
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName THEN ip.iprphone END , -- HolderPhone - varchar(10)
          CASE WHEN ins.insipr <> '0' AND ip.iprfname <> p.FirstName AND ip.iprlname <> p.LastName THEN ins.insid END , -- DependentPolicyNumber - varchar(32)
          CASE WHEN ins.insstatus = '' THEN '' ELSE 'Insurance Status: ' + ins.insstatus END , -- Notes - text
          pc.VendorID  -- VendorID - varchar(50)
FROM dbo.PatientCase pc
INNER JOIN dbo.Patient p ON	
	pc.PatientID = p.PatientID AND
	p.VendorImportID = @VendorImportID
LEFT JOIN dbo._import_3_1_InsFile ins ON
	pc.VendorID = ins.insaccount + '.' + ins.insdep
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.VendorID = ins.insconum AND
	icp.VendorImportID = 1
INNER JOIN dbo._import_3_1_DepFile i ON
	p.VendorID = i.account + '.' + i.dependentnumber
LEFT JOIN dbo.[_import_3_1_Iprfile] ip ON
	ins.insipr = ip.iprno 
LEFT JOIN dbo.Employers e ON
	ip.ipremplname = e.EmployerName
WHERE pc.VendorImportID = @VendorImportID AND i.preferredplan3 = icp.VendorID

PRINT ''
PRINT 'Inserting Into Policies...'
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
          HolderThroughEmployer ,
          HolderEmployerName ,
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
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  PCID , -- PatientCaseID - int
          ICPID , -- InsuranceCompanyPlanID - int
          Precedence , -- Precedence - int
          PolicyNumber , -- PolicyNumber - varchar(32)
          GroupNumber , -- GroupNumber - varchar(32)
          PolicyStartDate , -- PolicyStartDate - datetime
          PolicyEndDate , -- PolicyEndDate - datetime
          0 , -- CardOnFile - bit
          PatRelationtoInsured , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          HolderFirstName , -- HolderFirstName - varchar(64)
          HolderMiddleName , -- HolderMiddleName - varchar(64)
          HolderLastName , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          HolderDOB , -- HolderDOB - datetime
          HolderThroughEmployer , -- HolderThroughEmployer - bit
          HolderEmployerName , -- HolderEmployerName - varchar(128)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          HolderGender , -- HolderGender - char(1)
          HolderAddressLine1 , -- HolderAddressLine1 - varchar(256)
          HolderAddressLine2 , -- HolderAddressLine2 - varchar(256)
          HolderCity , -- HolderCity - varchar(128)
          HolderState , -- HolderState - varchar(2)
          '' , -- HolderCountry - varchar(32)
          HolderZipCode , -- HolderZipCode - varchar(9)
          HolderPhone , -- HolderPhone - varchar(10)
          DependentPolicyNumber , -- DependentPolicyNumber - varchar(32)
          Notes , -- Notes - text
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM #tempins
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Patient Cases that do not have policies...'
UPDATE dbo.PatientCase 
      SET PayerScenarioID = 11 , 
		  Name = 'Self Pay'
      FROM dbo.PatientCase pc
      LEFT JOIN dbo.InsurancePolicy ip ON
            pc.PatientCaseID = ip.PatientCaseID  
      WHERE pc.VendorImportID = @VendorImportID AND
              PayerScenarioID = 5 AND 
              ip.PatientCaseID IS NULL AND
              pc.Name <> 'Balance Forward'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

DROP TABLE #tempins


SELECT * FROM patient WHERE VendorImportID = 3

--ROLLBACK
--COMMIT