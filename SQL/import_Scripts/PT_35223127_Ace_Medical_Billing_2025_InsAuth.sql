USE superbill_2025_dev
go

UPDATE dbo.Patient
	SET Gender = (SELECT sex FROM dbo.[_import_5_1_PatientDemosCopy] WHERE 
					Patient.vendorID = dbo.[_import_5_1_PatientDemosCopy].chart_number)
	WHERE dbo.patient.VendorImportID = 5
	
	
SELECT * FROM dbo.InsurancePolicyAuthorization	
	ORDER BY AuthorizationNumber
	
INSERT INTO dbo.InsurancePolicyAuthorization
        ( InsurancePolicyID ,
          AuthorizationNumber ,
          AuthorizedNumberOfVisits ,
          AuthorizationStatusID ,
          Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          RecordTimeStamp ,
          AuthorizedNumberOfVisitsUsed
        )
SELECT  
		ip.InsurancePolicyID , -- InsurancePolicyID - int
        insurance_authorization_1 , -- AuthorizationNumber - varchar(65)
          0 , -- AuthorizedNumberOfVisits - int
          0 , -- AuthorizationStatusID - int
          'Created via data import' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          NULL , -- RecordTimeStamp - timestamp
          0  -- AuthorizedNumberOfVisitsUsed - int
FROM dbo.[_import_5_1_PatientDemosCopy] impIPA
INNER JOIN dbo.PatientCase pc ON
	impIPA.chart_number = pc.VendorID AND
	pc.VendorImportID = 5
INNER JOIN DBO.InsurancePolicy ip ON
	pc.PatientCaseID = ip.PatientCaseID AND
	ip.VendorImportID = 5
WHERE insurance_authorization_1 <> ''