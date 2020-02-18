USE superbill_59642_prod
GO


BEGIN TRAN
SET XACT_ABORT ON
SET NOCOUNT ON 


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
'Primary Policy- ' + CHAR(10) + CHAR(10) +
'     Plan Name: ' + icp1.planname + CHAR(10) + 
'          Policy #: ' + pd.policynumber1 + CHAR(10) + 
														CASE WHEN pd.groupnumber1 <> '' THEN 
 '          Group #: ' + pd.groupnumber1 + CHAR(10)		ELSE '' END +
														CASE WHEN pd.patientrelationship1 = 'O' THEN CHAR(10) + 
															CASE WHEN pd.holder1firstname <> '' THEN 
'    Holder Name: ' + pd.holder1firstname + ' ' + CASE WHEN pd.holder1middlename = '' THEN pd.holder1lastname + CHAR(10) ELSE pd.holder1middlename + ' ' + pd.holder1lastname + CHAR(10) END 
																ELSE '' END +
															CASE WHEN pd.holder1street1 <> '' THEN   
'Holder Address: ' + pd.holder1street1 + ' ' + pd.holder1city + ', ' + pd.holder1state + ' ' + pd.holder1zipcode 
																ELSE '' END
														ELSE '' END +
CASE WHEN pd.policynumber2 <> '' AND icp2.AutoTempID IS NOT NULL THEN
CHAR(10) + CHAR(10) + 'Secondary Policy- ' + CHAR(10) + CHAR(10) +
'     Plan Name: ' + icp2.planname + CHAR(10) + 
'          Policy #: ' + pd.policynumber2 + CHAR(10) + 
														CASE WHEN pd.groupnumber2 <> '' THEN 
 '          Group #: ' + pd.groupnumber2 + CHAR(10)		ELSE '' END +
														CASE WHEN pd.patientrelationship2 = 'O' THEN CHAR(10) + 
															CASE WHEN pd.holder2firstname <> '' THEN 
'    Holder Name: ' + pd.holder2firstname + ' ' + CASE WHEN pd.holder2middlename = '' THEN pd.holder2lastname + CHAR(10) ELSE pd.holder2middlename + ' ' + pd.holder2lastname + CHAR(10) END 
																ELSE '' END +
															CASE WHEN pd.holder2street1 <> '' THEN   
'Holder Address: ' + pd.holder1street1 + ' ' + pd.holder2city + ', ' + pd.holder2state + ' ' + pd.holder2zipcode 
																ELSE '' END
														ELSE '' END 
ELSE '' END + 
CASE WHEN pd.policynumber3 <> '' AND icp3.AutoTempID IS NOT NULL THEN
CHAR(10) + CHAR(10) + 'Tertiary Policy- ' + CHAR(10) + CHAR(10) +
'     Plan Name: ' + icp3.planname + CHAR(10) + 
'          Policy #: ' + pd.policynumber3 + CHAR(10) + 
														CASE WHEN pd.groupnumber3 <> '' THEN 
 '          Group #: ' + pd.groupnumber3 + CHAR(10)		ELSE '' END +
														CASE WHEN pd.patientrelationship3 = 'O' THEN CHAR(10) + 
															CASE WHEN pd.holder3firstname <> '' THEN 
'    Holder Name: ' + pd.holder3firstname + ' ' + CASE WHEN pd.holder3middlename = '' THEN pd.holder3lastname + CHAR(10) ELSE pd.holder3middlename + ' ' + pd.holder3lastname + CHAR(10) END 
																ELSE '' END +
															CASE WHEN pd.holder3street1 <> '' THEN   
'Holder Address: ' + pd.holder1street1 + ' ' + pd.holder3city + ', ' + pd.holder3state + ' ' + pd.holder3zipcode 
																ELSE '' END
														ELSE '' END 
ELSE '' END , -- AlertMessage - text
          1 , -- ShowInPatientFlag - bit
          0 , -- ShowInAppointmentFlag - bit
          0 , -- ShowInEncounterFlag - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          0 , -- ShowInClaimFlag - bit
          0 , -- ShowInPaymentFlag - bit
          0  -- ShowInPatientStatementFlag - bit
FROM dbo._import_1_1_PatientDemographics pd
INNER JOIN dbo._import_1_1_InsuranceCOMPANYPLANList icp1 ON pd.insurancecode1 = icp1.insuranceid
LEFT JOIN dbo._import_1_1_InsuranceCOMPANYPLANList icp2 ON pd.insurancecode2 = icp2.insuranceid 
LEFT JOIN dbo._import_1_1_InsuranceCOMPANYPLANList icp3 ON pd.insurancecode3 = icp3.insuranceid
INNER JOIN dbo.Patient p ON pd.chartnumber = p.VendorID AND p.PracticeID = 1
LEFT JOIN dbo.PatientAlert pa ON p.PatientID = pa.PatientID
WHERE pd.policynumber1 <> '' AND pa.PatientAlertID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Patient Alert Records Inserted'

UPDATE dbo.Patient 
	SET	CreatedDate = GETDATE() , 
		ModifiedDate = GETDATE()
WHERE PatientID IN (SELECT PatientID FROM dbo.PatientAlert WHERE CreatedDate > DATEADD(ss,-2,GETDATE()))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Patient Records Updated'


--COMMIT
--ROLLBACK