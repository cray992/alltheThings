USE superbill_29285_dev
--USE superbill_29285_prod
GO


SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @VendorImportID INT
DECLARE @PracticeID INT
  
SET @VendorImportID = 6
SET @PracticeID = 1


--DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
--DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
--DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
--DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
--DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
--DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
--DELETE FROM dbo.PatientJournalNote WHERE CreatedUserID = -50 AND ModifiedUserID = -50 
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
--DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
--DELETE FROM dbo.Employers where CreatedUserID = -50 AND ModifiedUserID = -50
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Employer records deleted'



PRINT ''
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
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
          Fax ,
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
		  insname , -- InsuranceCompanyName - varchar(128)
          CASE WHEN phone2 = '' THEN '' ELSE phone2 END , -- Notes - text
          [address] , -- AddressLine1 - varchar(256)
          address2 , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          state , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(zip) IN (4,8) THEN '0' + zip WHEN LEN(zip) IN (5,9) THEN zip ELSE '' END , -- ZipCode - varchar(9)
          '' , -- ContactPrefix - varchar(16)
          contactfirst , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          contactlast , -- ContactLastName - varchar(64)
          '' , -- ContactSuffix - varchar(16)
          phone1 , -- Phone - varchar(10)
          fax , -- Fax - varchar(10)
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
          insureno , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_6_1_Insurances]
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Insurance Company Plan'
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
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          CreatedPracticeID ,
          Fax ,
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
          '' , -- ContactPrefix - varchar(16)
          ContactFirstName , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          ContactLastName , -- ContactLastName - varchar(64)
          '' , -- ContactSuffix - varchar(16)
          Phone , -- Phone - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          Fax , -- Fax - varchar(10)
          InsuranceCompanyID , -- InsuranceCompanyID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Employer...'
INSERT INTO dbo.Employers
        ( EmployerName ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID 
        )
SELECT DISTINCT
		  empname , -- EmployerName - varchar(128)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50  -- ModifiedUserID - int
FROM dbo.[_import_6_1_Patient] WHERE empname <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Patient...'
INSERT INTO dbo.Patient
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
          PrimaryProviderID ,
          DefaultServiceLocationID ,
          EmployerID ,
          MobilePhone ,
          MobilePhoneExt ,
          VendorID ,
          VendorImportID ,
          CollectionCategoryID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled ,
		  MedicalRecordNumber
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          i.[first] , -- FirstName - varchar(64)
          i.middle , -- MiddleName - varchar(64)
          i.[last] , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          i.[address] , -- AddressLine1 - varchar(256)
          i.address2 , -- AddressLine2 - varchar(256)
          i.city , -- City - varchar(128)
          LEFT(i.[state], 2) , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(i.ZIP) IN (4,8) THEN '0' + i.zip WHEN LEN(i.ZIP) IN (5,9) THEN i.zip ELSE '' END , -- ZipCode - varchar(9)
          i.sex , -- Gender - varchar(1)
          CASE i.married  WHEN 'U' THEN '' ELSE i.married END , -- MaritalStatus - varchar(1)
          i.homphone , -- HomePhone - varchar(10)
          '' , -- HomePhoneExt - varchar(10)
          i.wrkphone , -- WorkPhone - varchar(10)
          '' , -- WorkPhoneExt - varchar(10)
          i.dob , -- DOB - datetime
          CASE WHEN LEN(i.ssn)>= 6 THEN RIGHT('000' + i.ssn , 9 ) ELSE '' END , -- SSN - char(9)
          i.email , -- EmailAddress - varchar(256)
          CASE WHEN i.familyno = g.familyno THEN 1 ELSE 0 END , -- ResponsibleDifferentThanPatient - bit
          CASE WHEN i.familyno = g.familyno THEN '' ELSE NULL END , -- ResponsiblePrefix - varchar(16)
          CASE WHEN i.familyno = g.familyno THEN g.[first] ELSE NULL END , -- ResponsibleFirstName - varchar(64)
          CASE WHEN i.familyno = g.familyno THEN g.middle ELSE NULL END , -- ResponsibleMiddleName - varchar(64)
          CASE WHEN i.familyno = g.familyno THEN g.[last] ELSE NULL END , -- ResponsibleLastName - varchar(64)
          CASE WHEN i.familyno = g.familyno THEN '' ELSE NULL END , -- ResponsibleSuffix - varchar(16)
          CASE WHEN i.familyno = g.familyno THEN 'O' ELSE NULL END , -- ResponsibleRelationshipToPatient - varchar(1)
          CASE WHEN i.familyno = g.familyno THEN g.[address] ELSE NULL END , -- ResponsibleAddressLine1 - varchar(256)
          CASE WHEN i.familyno = g.familyno THEN g.address2 ELSE NULL END , -- ResponsibleAddressLine2 - varchar(256)
          CASE WHEN i.familyno = g.familyno THEN g.city ELSE NULL END , -- ResponsibleCity - varchar(128)
          CASE WHEN i.familyno = g.familyno THEN g.[state] ELSE NULL END , -- ResponsibleState - varchar(2)
          CASE WHEN i.familyno = g.familyno THEN '' ELSE NULL END  , -- ResponsibleCountry - varchar(32)
          CASE WHEN i.familyno = g.familyno THEN g.zip ELSE NULL END  , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          CASE WHEN empname <> '' THEN 'E' ELSE 'U' END , -- EmploymentStatus - char(1)
          1 , -- PrimaryProviderID - int
          1 , -- DefaultServiceLocationID - int
          e.EmployerID , -- EmployerID - int
          cellphone , -- MobilePhone - varchar(10)
          '' , -- MobilePhoneExt - varchar(10)
          i.familyno + i.personno , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- CollectionCategoryID - int
          1 , -- Active - bit
          0 , -- SendEmailCorrespondence - bit
          0 , -- PhonecallRemindersEnabled - bit
		  i.familyno + '-' + i.personno -- MedicalRecordNumber
FROM dbo.[_import_6_1_Patient] i
	LEFT JOIN dbo.[_import_6_1_PatGuarantor] g ON 
		i.familyno = g.familyno
	LEFT JOIN dbo.Employers e ON 
		i.empname = e.EmployerName
WHERE i.[first] <> '' AND i.[last] <> '' AND 
NOT EXISTS (SELECT FirstName, LastName, DOB FROM dbo.Patient p 
				WHERE i.[first] = p.FirstName AND	
					  i.[last] = p.LastName AND
					  DATEADD(hh,12,CAST(i.dob AS DATETIME)) = p.DOB AND
					  p.PracticeID = @PracticeID)
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
          NoteMessage 
        )
SELECT DISTINCT
		  GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          p.PatientID , -- PatientID - int
          '' , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          'Previous Chart Number: ' + i.chartno  -- NoteMessage - varchar(max)
FROM dbo.[_import_6_1_Patient] i
	INNER JOIN dbo.Patient p ON 
		i.familyno + i.personno = p.VendorID AND
		p.VendorImportID = @VendorImportID
WHERE i.chartno <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



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
PRINT 'Inserting Into Policy...'
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
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          DependentPolicyNumber ,
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
          policyrank, -- Precedence - int
          policyno , -- PolicyNumber - varchar(32)
          insgroupid , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(effdate) = 1 THEN CONVERT(VARCHAR, effdate, 101) ELSE NULL END , -- PolicyStartDate - datetime
          CASE WHEN ISDATE(enddatedonotimporttermed) = 1 THEN enddatedonotimporttermed ELSE NULL END , -- PolicyEndDate - datetime
          CASE relation WHEN '' THEN 'S' ELSE relation END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN relation <> 'S' AND relation <> '' THEN '' ELSE NULL END  , -- HolderPrefix - varchar(16)
          CASE WHEN relation <> 'S' AND relation <> '' THEN insuredfirst ELSE NULL END , -- HolderFirstName - varchar(64)
          CASE WHEN relation <> 'S' AND relation <> '' THEN insuredmiddle ELSE NULL END , -- HolderMiddleName - varchar(64)
          CASE WHEN relation <> 'S' AND relation <> '' THEN insuredlast ELSE NULL END , -- HolderLastName - varchar(64)
          CASE WHEN relation <> 'S' AND relation <> '' THEN '' ELSE NULL END , -- HolderSuffix - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          CASE WHEN relation <> 'S' AND relation <> '' THEN policyno ELSE NULL END , -- DependentPolicyNumber - varchar(32)
          genericcopay , -- Copay - money
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          LEFT(i.insgroupnm, 14) , -- GroupName - varchar(14)
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_6_1_Policy] i
	INNER JOIN dbo.PatientCase pc ON 
		i.familyno + i.personno = pc.VendorID AND
		pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON
		i.insureno = icp.VendorID AND
		icp.VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


--PRINT ''
--PRINT 'Inserting Into Appointment...'
--INSERT INTO dbo.Appointment
--        ( PatientID ,
--          PracticeID ,
--          ServiceLocationID ,
--          StartDate ,
--          EndDate ,
--          AppointmentType ,
--          Subject ,
--          Notes ,
--          CreatedDate ,
--          CreatedUserID ,
--          ModifiedDate ,
--          ModifiedUserID ,
--          AppointmentResourceTypeID ,
--          AppointmentConfirmationStatusCode ,
--          PatientCaseID ,
--          StartDKPracticeID ,
--          EndDKPracticeID ,
--          StartTm ,
--          EndTm 
--        )
--SELECT DISTINCT
--		  p.PatientID , -- PatientID - int
--          @PracticeID , -- PracticeID - int
--          1 , -- ServiceLocationID - int
--          i.startdatecst , -- StartDate - datetime
--          i.enddatecst , -- EndDate - datetime
--          'P' , -- AppointmentType - varchar(1)
--          '' , -- Subject - varchar(64)
--          'Reason: ' + i.reason , -- Notes - text
--          GETDATE() , -- CreatedDate - datetime
--          -50 , -- CreatedUserID - int
--          GETDATE() , -- ModifiedDate - datetime
--          -50 , -- ModifiedUserID - int
--          1 , -- AppointmentResourceTypeID - int
--          'S' , -- AppointmentConfirmationStatusCode - char(1)
--          pc.PatientCaseID , -- PatientCaseID - int
--          dk.DKPracticeID , -- StartDKPracticeID - int
--          dk.DKPracticeID , -- EndDKPracticeID - int
--          i.starttmcst , -- StartTm - smallint
--          i.endtmcst  -- EndTm - smallint
--FROM dbo.[_import_6_1_Appointment] i
--	INNER JOIN dbo.PatientCase pc ON 
--		i.familyno + i.personno = pc.VendorID AND
--		pc.VendorImportID = @VendorImportID
--	INNER JOIN dbo.Patient p ON 
--		i.familyno + i.personno = p.VendorID AND
--		p.VendorImportID = p.VendorImportID
--	INNER JOIN dbo.DateKeyToPractice dk ON
--		dk.PracticeID = @PracticeID AND
--		dk.Dt = CAST(CAST(i.startdatecst AS DATE) AS DATETIME)
--PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


--PRINT ''
--PRINT 'Inserting Into Appointment to Resource...'
--INSERT INTO dbo.AppointmentToResource
--        ( AppointmentID ,
--          AppointmentResourceTypeID ,
--          ResourceID ,
--          ModifiedDate ,
--          PracticeID
--        )
--SELECT DISTINCT
--		  a.AppointmentID , -- AppointmentID - int
--          1 , -- AppointmentResourceTypeID - int
--          1 , -- ResourceID - int
--          GETDATE() , -- ModifiedDate - datetime
--          @PracticeID  -- PracticeID - int
--FROM dbo.Appointment a
--	INNER JOIN dbo.Patient p ON
--		a.PatientID = p.PatientID AND
--		p.VendorImportID = @VendorImportID  
--	INNER JOIN dbo.[_import_6_1_Appointment] i ON	
--		a.StartDate = i.startdatecst AND
--		p.VendorID  = i.familyno + i.personno
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
                    'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) , -- Notes - varchar(1024)
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
                    i.fee , -- SetFee - money
                    0  -- AnesthesiaBaseUnits - int
      FROM dbo.[_import_6_1_FeeSchedule] AS i
      INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule AS sfs ON
            CAST(sfs.[Notes] AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND
            sfs.PracticeID = @PracticeID  
      INNER JOIN dbo.ProcedureCodeDictionary AS pcd ON
            pcd.[ProcedureCode] = i.procno
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
            sfs.[Notes] = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND
            sfs.PracticeID = @PracticeID    
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Updating Patient Cases that do not have policies...'
UPDATE dbo.PatientCase 
      SET PayerScenarioID = 11 
      FROM dbo.PatientCase pc
      LEFT JOIN dbo.InsurancePolicy ip ON
            pc.PatientCaseID = ip.PatientCaseID  
      WHERE pc.VendorImportID = @VendorImportID AND
              PayerScenarioID = 5 AND 
              ip.PatientCaseID IS NULL 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



--COMMIT
--ROLLBACK