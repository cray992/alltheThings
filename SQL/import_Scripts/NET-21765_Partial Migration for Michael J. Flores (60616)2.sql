USE superbill_65024_dev;
GO
--rollback
--commit
SET XACT_ABORT ON;



BEGIN TRANSACTION;

DECLARE @TargetPracticeID INT;
DECLARE @SourcePracticeID INT;
DECLARE @VendorImportID INT;

SET @TargetPracticeID = 1;
SET @SourcePracticeID = 1;
SET @VendorImportID =14;

SET NOCOUNT ON;

PRINT 'Source PracticeID = ' + CAST(@SourcePracticeID AS VARCHAR);
PRINT 'Target PracticeID = ' + CAST(@TargetPracticeID AS VARCHAR);
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR);

SET IDENTITY_INSERT dbo.InsurancePolicy ON ;

PRINT''
PRINT 'Inserting into InsurancePolicy ...'
INSERT INTO dbo.InsurancePolicy
        ( InsurancePolicyID,
		  PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          --PolicyStartDate ,
          --PolicyEndDate ,
          ----CardOnFile ,
          PatientRelationshipToInsured ,
          --HolderPrefix ,
          HolderFirstName ,
          --HolderMiddleName ,
          HolderLastName ,
          --HolderSuffix ,
          --HolderDOB ,
          --HolderSSN ,
          --HolderThroughEmployer ,
          --HolderEmployerName ,
          --PatientInsuranceStatusID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          --HolderGender ,
          --HolderAddressLine1 ,
          --HolderAddressLine2 ,
          --HolderCity ,
          --HolderState ,
          --HolderCountry ,
          --HolderZipCode ,
          --HolderPhone ,
          --HolderPhoneExt ,
          --DependentPolicyNumber ,
          --Notes ,
          --Phone ,
          --PhoneExt ,
          --Fax ,
          --FaxExt ,
          Copay ,
          Deductible ,
          --PatientInsuranceNumber ,
          Active ,
          PracticeID ,
          --AdjusterPrefix ,
          --AdjusterFirstName ,
          --AdjusterMiddleName ,
          --AdjusterLastName ,
          --AdjusterSuffix ,
          VendorID ,
          VendorImportID 
          --InsuranceProgramTypeID ,
          --GroupName ,
          --ReleaseOfInformation 
		  )

		  --SELECT * FROM dbo.Relationship

SELECT  DISTINCT 
		  ip.InsurancePolicyID,
          pc.PatientCaseID ,
          icp.insurancecompanyplanid ,
          1 ,
          ip.PolicyNumber ,
          ip.GroupNumber ,
    --      CASE WHEN ISDATE(ip.PolicyStartDate) = 1 THEN ip.policystartdate ELSE NULL END ,
    --      CASE WHEN ISDATE(ip.PolicyEndDate) = 1 THEN ip.policyenddate ELSE NULL END ,
    --      --ip.CardOnFile ,
	--ip.patientrelationshiptoinsured,
		   CASE WHEN ip.patientrelationshiptoinsured='S'
				THEN 'S'
				ELSE 'U'
		   END ,                      -- PatientRelationshipToInsured - varchar(1)
          --ip.HolderPrefix ,
          ip.HolderFirstName ,
          --ip.HolderMiddleName ,
          ip.HolderLastName ,
          --ip.HolderSuffix ,
          --CAST(ip.HolderDOB AS DATETIME),
          --ip.HolderSSN ,
          --ip.holderthroughemployer  ,
          --ip.HolderEmployerName ,
          --ip.PatientInsuranceStatusID ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          --ip.HolderGender ,
          --ip.HolderAddressLine1 ,
          --ip.HolderAddressLine2 ,
          --ip.HolderCity ,
          --ip.HolderState ,
          --ip.HolderCountry ,
          --ip.HolderZipCode ,
          --ip.HolderPhone ,
          --ip.HolderPhoneExt ,
          --ip.DependentPolicyNumber ,
          --ip.Notes ,
          --ip.Phone ,
          --ip.PhoneExt ,
          --ip.Fax ,
          --ip.FaxExt ,
          ip.Copay ,
          ip.Deductible ,
          --ip.PatientInsuranceNumber ,
          ip.active  ,
          @TargetPracticeID ,
          --ip.AdjusterPrefix ,
          --ip.AdjusterFirstName ,
          --ip.AdjusterMiddleName ,
          --ip.AdjusterLastName ,
          --ip.AdjusterSuffix ,
          ip.InsurancePolicyID ,
          @VendorImportID 
          --ip.insuranceprogramtypeid ,
          --ip.GroupName ,
          --ip.ReleaseOfInformation 

	--SELECT * 
FROM dbo._import_1_1_inspolicytable ip
	INNER JOIN dbo._import_1_1_patientcase ipc ON 
		ipc.patientcaseid = ip.patientcaseid
	INNER JOIN dbo._import_1_1_patients ipt ON 
		ipt.patientid = ipc.patientid
	INNER JOIN patient p ON 
		p.LastName = ipt.lastname AND 
		p.FirstName = ipt.firstname
	INNER JOIN dbo.PatientCase pc ON 
		pc.PatientID = p.PatientID AND 
		pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan icp
        ON icp.InsuranceCompanyPlanID = ip.insurancecompanyplanid
WHERE PatientRelationshipToInsured<>'1'


PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
SET IDENTITY_INSERT dbo.InsurancePolicy OFF ;




--rollback
--commit


--SELECT * FROM dbo._import_1_1_inspolicytable WHERE patientcaseid = 806
--SELECT * FROM dbo.InsurancePolicy WHERE PatientCaseID = 806