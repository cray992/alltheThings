BEGIN TRAN

--==============================================================
-- CREATE VENDOR IMPORT DATA
--==============================================================

DECLARE @PracticeID INT, @VendorImportID INT
SET @PracticeID = 2

INSERT INTO dbo.VendorImport
        ( VendorName ,
          VendorFormat ,
          DateCreated ,
          Notes ,
          PracticeID 
        )
VALUES  ( '11345_2' , -- VendorName - varchar(100)
          'Other' , -- VendorFormat - varchar(50)
          GETDATE() , -- DateCreated - datetime
          'Intra-Kareo Migration from Practice 1 to 2' , -- Notes - varchar(100)
          @PracticeID  -- PracticeID - int
        )

SET @VendorImportID = (SELECT VendorImportID FROM dbo.VendorImport AS VI WHERE Notes = 'Intra-Kareo Migration from Practice 1 to 2')


--==============================================================
-- VERIFY INSURANCES ARE AVAILABLE IN BOTH PRACTICES
--==============================================================

UPDATE dbo.InsuranceCompanyPlan
SET ReviewCode = 'R'
WHERE ReviewCode = '' AND CreatedPracticeID = 1

INSERT INTO dbo.PracticeToInsuranceCompany
        ( PracticeID ,
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
SELECT @practiceid , -- PracticeID - int
         InsuranceCompanyID, -- InsuranceCompanyID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          EClaimsProviderID , -- EClaimsProviderID - varchar(32)
          EClaimsEnrollmentStatusID , -- EClaimsEnrollmentStatusID - int
          EClaimsDisable , -- EClaimsDisable - int
          AcceptAssignment , -- AcceptAssignment - bit
          UseSecondaryElectronicBilling , -- UseSecondaryElectronicBilling - bit
          UseCoordinationOfBenefits, -- UseCoordinationOfBenefits - bit
          ExcludePatientPayment, -- ExcludePatientPayment - bit
          BalanceTransfer-- BalanceTransfer - bit
FROM dbo.PracticeToInsuranceCompany AS PTIC
WHERE NOT EXISTS (SELECT 1 FROM dbo.PracticeToInsuranceCompany AS PTIC2 WHERE PTIC2.PracticeID = @practiceid AND PTIC2.InsuranceCompanyID = PTIC.InsuranceCompanyID)


--==============================================================
-- COPY PATIENTS
--==============================================================

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
          PhonecallRemindersEnabled ,
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
SELECT @PracticeID , -- PracticeID - int
          ReferringPhysicianID , -- ReferringPhysicianID - int
          Prefix , -- Prefix - varchar(16)
          FirstName , -- FirstName - varchar(64)
          MiddleName , -- MdleName - varchar(64)
          LastName , -- LastName - varchar(64)
          Suffix , -- Suffix - varchar(16)
          AddressLine1 , -- AddressLine1 - varchar(256)
          AddressLine2 , -- AddressLine2 - varchar(256)
          City , -- City - varchar(128)
          State , -- State - varchar(2)
          Country , -- Country - varchar(32)
          ZipCode , -- ZipCode - varchar(9)
          Gender , -- Gender - varchar(1)
          MaritalStatus , -- MaritalStatus - varchar(1)
          HomePhone , -- HomePhone - varchar(10)
          HomePhoneExt , -- HomePhoneExt - varchar(10)
          WorkPhone , -- WorkPhone - varchar(10)
          WorkPhoneExt , -- WorkPhoneExt - varchar(10)
          DOB , -- DOB - datetime
          SSN , -- SSN - char(9)
          EmailAddress , -- EmailAddress - varchar(256)
          ResponsibleDifferentThanPatient , -- ResponsibleDifferentThanPatient - bit
          ResponsiblePrefix , -- ResponsiblePrefix - varchar(16)
          ResponsibleFirstName , -- ResponsibleFirstName - varchar(64)
          ResponsibleMiddleName , -- ResponsibleMiddleName - varchar(64)
          ResponsibleLastName , -- ResponsibleLastName - varchar(64)
          ResponsibleSuffix , -- ResponsibleSuffix - varchar(16)
          ResponsibleRelationshipToPatient , -- ResponsibleRelationshipToPatient - varchar(1)
          ResponsibleAddressLine1 , -- ResponsibleAddressLine1 - varchar(256)
          ResponsibleAddressLine2 , -- ResponsibleAddressLine2 - varchar(256)
          ResponsibleCity , -- ResponsibleCity - varchar(128)
          ResponsibleState , -- ResponsibleState - varchar(2)
          ResponsibleCountry , -- ResponsibleCountry - varchar(32)
          ResponsibleZipCode , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          EmploymentStatus , -- EmploymentStatus - char(1)
          InsuranceProgramCode , -- InsuranceProgramCode - char(2)
          PatientReferralSourceID , -- PatientReferralSourceID - int
          PrimaryProviderID , -- PrimaryProviderID - int
          DefaultServiceLocationID , -- DefaultServiceLocationID - int
          EmployerID , -- EmployerID - int
          MedicalRecordNumber , -- MedicalRecordNumber - varchar(128)
          MobilePhone , -- MobilePhone - varchar(10)
          MobilePhoneExt , -- MobilePhoneExt - varchar(10)
          PrimaryCarePhysicianID , -- PrimaryCarePhysicianID - int
          PatientID , -- VendorID - varchar(50)
          @VendorImportID, -- VendorImportID - int
          CollectionCategoryID , -- CollectionCategoryID - int
          Active , -- Active - bit
          SendEmailCorrespondence , -- SendEmailCorrespondence - bit
          PhonecallRemindersEnabled , -- PhonecallRemindersEnabled - bit
          EmergencyName , -- EmergencyName - varchar(128)
          EmergencyPhone , -- EmergencyPhone - varchar(10)
          EmergencyPhoneExt , -- EmergencyPhoneExt - varchar(10)
          Ethnicity , -- Ethnicity - varchar(64)
          Race , -- Race - varchar(64)
          LicenseNumber , -- LicenseNumber - varchar(64)
          LicenseState , -- LicenseState - varchar(2)
          Language1 , -- Language1 - varchar(64)
          Language2  -- Language2 - varchar(64)
FROM dbo.Patient AS P
WHERE PracticeID = 1


--==============================================================
-- COPY PATIENT CASES
--==============================================================
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
SELECT P.PatientID , -- PatientID - int
          PC.Name , -- Name - varchar(128)
          PC.Active, -- Active - bit
          PayerScenarioID , -- PayerScenarioID - int
          PC.ReferringPhysicianID , -- ReferringPhysicianID - int
          pc.EmploymentRelatedFlag, -- EmploymentRelatedFlag - bit
          pc.AutoAccidentRelatedFlag, -- AutoAccidentRelatedFlag - bit
          pc.OtherAccidentRelatedFlag, -- OtherAccidentRelatedFlag - bit
          pc.AbuseRelatedFlag, -- AbuseRelatedFlag - bit
          pc.AutoAccidentRelatedState, -- AutoAccidentRelatedState - char(2)
          pc.Notes , -- Notes - text
          pc.ShowExpiredInsurancePolicies, -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          CaseNumber , -- CaseNumber - varchar(128)
          WorkersCompContactInfoID , -- WorkersCompContactInfoID - int
          PatientCaseID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          PregnancyRelatedFlag, -- PregnancyRelatedFlag - bit
          StatementActive, -- StatementActive - bit
          EPSDT, -- EPSDT - bit
          FamilyPlanning, -- FamilyPlanning - bit
          EPSDTCodeID, -- EPSDTCodeID - int
          EmergencyRelated, -- EmergencyRelated - bit
          HomeboundRelatedFlag-- HomeboundRelatedFlag - bit
FROM dbo.PatientCase AS PC
JOIN dbo.Patient AS P ON P.VendorID = PC.PatientID AND P.VendorImportID = @VendorImportID
WHERE PC.PracticeID = 1


--==============================================================
-- COPY INSURANCE POLICIES
--==============================================================

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
          ReleaseOfInformation ,
          SyncWithEHR 
        )
SELECT PC.PatientCaseID , -- PatientCaseID - int
          ip.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          ip.Precedence , -- Precedence - int
          PolicyNumber , -- PolicyNumber - varchar(32)
          GroupNumber , -- GroupNumber - varchar(32)
          PolicyStartDate , -- PolicyStartDate - datetime
          PolicyEndDate , -- PolicyEndDate - datetime
          CardOnFile, -- CardOnFile - bit
          PatientRelationshipToInsured , -- PatientRelationshipToInsured - varchar(1)
          HolderPrefix , -- HolderPrefix - varchar(16)
          HolderFirstName , -- HolderFirstName - varchar(64)
          HolderMiddleName , -- HolderMiddleName - varchar(64)
          HolderLastName , -- HolderLastName - varchar(64)
          HolderSuffix , -- HolderSuffix - varchar(16)
          HolderDOB , -- HolderDOB - datetime
          HolderSSN , -- HolderSSN - char(11)
          HolderThroughEmployer , -- HolderThroughEmployer - bit
          HolderEmployerName , -- HolderEmployerName - varchar(128)
          PatientInsuranceStatusID , -- PatientInsuranceStatusID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          HolderGender , -- HolderGender - char(1)
          HolderAddressLine1 , -- HolderAddressLine1 - varchar(256)
          HolderAddressLine2 , -- HolderAddressLine2 - varchar(256)
          HolderCity , -- HolderCity - varchar(128)
          HolderState , -- HolderState - varchar(2)
          HolderCountry , -- HolderCountry - varchar(32)
          HolderZipCode , -- HolderZipCode - varchar(9)
          HolderPhone , -- HolderPhone - varchar(10)
          HolderPhoneExt , -- HolderPhoneExt - varchar(10)
          DependentPolicyNumber , -- DependentPolicyNumber - varchar(32)
          IP.Notes , -- Notes - text
          Phone , -- Phone - varchar(10)
          PhoneExt , -- PhoneExt - varchar(10)
          Fax , -- Fax - varchar(10)
          FaxExt , -- FaxExt - varchar(10)
          Copay , -- Copay - money
          Deductible , -- Deductible - money
          PatientInsuranceNumber , -- PatientInsuranceNumber - varchar(32)
          IP.Active , -- Active - bit
          @PracticeID , -- PracticeID - int
          AdjusterPrefix , -- AdjusterPrefix - varchar(16)
          AdjusterFirstName , -- AdjusterFirstName - varchar(64)
          AdjusterMiddleName , -- AdjusterMiddleName - varchar(64)
          AdjusterLastName , -- AdjusterLastName - varchar(64)
          AdjusterSuffix , -- AdjusterSuffix - varchar(16)
          ip.InsurancePolicyID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          InsuranceProgramTypeID , -- InsuranceProgramTypeID - int
          GroupName , -- GroupName - varchar(14)
          ReleaseOfInformation , -- ReleaseOfInformation - varchar(1)
          SyncWithEHR  -- SyncWithEHR - bit
FROM dbo.InsurancePolicy AS IP
JOIN dbo.PatientCase AS PC ON PC.VendorID = IP.PatientCaseID AND PC.VendorImportID = @VendorImportID
WHERE IP.PracticeID = 1


ROLLBACK TRAN