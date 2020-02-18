USE superbill_27599_dev 
--USE superbill_27599_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN

 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
DECLARE @OldVendorImportID INT
 
SET @PracticeID = 1
SET @OldVendorImportID = 4
SET @VendorImportID = 5 -- Vendor import record created through import tool
 
PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

--DELETE FROM dbo.PatientAlert WHERE ModifiedDate > '2014-09-05 08:07:32.760'
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Alert records deleted'
--DELETE FROM dbo.EncounterDiagnosis WHERE EncounterID IN (SELECT EncounterID FROM dbo.Encounter WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Encounter Diagnosis records deleted'
--DELETE FROM dbo.EncounterProcedure WHERE EncounterID IN (SELECT EncounterID FROM dbo.Encounter WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Encounter Procedure records deleted'
--DELETE FROM dbo.Encounter WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Encounter records deleted'
--DELETE FROM dbo.PatientCase WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'



PRINT ''
PRINT 'Inserting Into Patient Case...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
	      p.PatientID ,
          'Balance Forward' ,
          1 ,
          11 ,
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created for Balance Forward.' ,
          GETDATE() ,
          -50 ,
          GETDATE() ,
          -50 ,
          @PracticeID ,
          p.PatientID ,
          @VendorImportID 
FROM dbo.[_import_5_1_BalanceForwardReport] i
	INNER JOIN dbo.Patient p ON
		p.PatientID = i.patientid AND 
		p.VendorImportID = @OldVendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


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
          'Patient has Balance Forward Encounter' , -- AlertMessage - text
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
FROM dbo.[_import_5_1_BalanceForwardReport] i
	INNER JOIN dbo.Patient p ON 
		p.VendorID = i.patientid AND 
		p.VendorImportID = @OldVendorImportID
WHERE NOT EXISTS (SELECT * FROM dbo.PatientAlert pa WHERE pa.PatientID = p.PatientID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Diagnosis Code for Balance Forward...'
IF NOT EXISTS (SELECT * FROM dbo.DiagnosisCodeDictionary WHERE OfficialName = 'Miscellaneous')
INSERT INTO dbo.DiagnosisCodeDictionary
        ( DiagnosisCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Active ,
          OfficialName ,
          LocalName 
        )
VALUES  ( '000.00' , -- DiagnosisCode - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          1 , -- Active - bit
          'Miscellaneous' , -- OfficialName - varchar(300)
          'Miscellaneous'  -- LocalName - varchar(100)
        )
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Encounter...'
INSERT INTO dbo.Encounter
        ( PracticeID ,
          PatientID ,
          DoctorID ,
          LocationID ,
          DateOfService ,
          DateCreated ,
          Notes ,
          EncounterStatusID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ReleaseSignatureSourceCode ,
          PlaceOfServiceCode ,
          PatientCaseID ,
          PostingDate ,
          DateOfServiceTo ,
          PaymentMethod ,
          AddOns ,
          DoNotSendElectronic ,
          SubmittedDate ,
          PaymentTypeID ,
          VendorID ,
          VendorImportID ,
          DoNotSendElectronicSecondary ,
          overrideClosingDate ,
          ClaimTypeID ,
          SecondaryClaimTypeID ,
          SubmitReasonIDCMS1500 ,
          SubmitReasonIDUB04 ,
          PatientCheckedIn 
        )
SELECT DISTINCT
	      @PracticeID ,
          i.patientid ,
          1 ,
          1 ,
          GETDATE() ,
          GETDATE() ,
          Convert(Varchar(10), GETDATE(),101) + ': Creating Balance Forward' ,
          2 ,
          GETDATE() ,
          -50 ,
          GETDATE() ,
          -50 ,
          'B' ,
          11 ,
          pc.PatientCaseID ,
          GETDATE() ,
          GETDATE() ,
          'U' ,
          0 ,
          0 ,
          GETDATE() ,
          0 ,
          i.patientid ,
          @VendorImportID ,
          0 ,
          0 ,
          0 ,
          0 ,
          2 ,
          2 ,
          0 
FROM dbo.[_import_5_1_BalanceForwardReport] i
INNER JOIN dbo.PatientCase pc ON pc.PatientID = i.patientid AND pc.VendorImportID = @VendorImportID
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
		  EncounterID , -- EncounterID - int
          dcd.DiagnosisCodeDictionaryID , -- DiagnosisCodeDictionaryID - int
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          1 , -- ListSequence - int
          @PracticeID , -- PracticeID - int
          e.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Encounter e
INNER JOIN dbo.[_import_5_1_BalanceForwardReport] i ON
	e.VendorID = i.patientid AND
	e.VendorImportID = @VendorImportID
INNER JOIN  dbo.DiagnosisCodeDictionary dcd ON
	dcd.DiagnosisCode = '000.00'
WHERE VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Insert Into Encounter Procedure...'
INSERT INTO dbo.EncounterProcedure
        ( EncounterID ,
          ProcedureCodeDictionaryID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ServiceChargeAmount ,
          ServiceUnitCount ,
          ProcedureDateOfService ,
          PracticeID ,
          EncounterDiagnosisID1 ,
          ServiceEndDate ,
          VendorID ,
          VendorImportID ,
          TypeOfServiceCode ,
          AnesthesiaTime ,
          ConcurrentProcedures 
        )
SELECT DISTINCT
	      e.EncounterID ,
          pcd.ProcedureCodeDictionaryID ,
          GETDATE() ,
          -50 ,
          GETDATE() ,
          -50 ,
          i.total ,
          '1.0000' ,
          GETDATE() ,
          @PractIceID ,
          ed.EncounterDiagnosisID ,
          GETDATE() ,
          i.patientid ,
          @VendorImportID ,
          '1' ,
          0 ,
          1 
FROM dbo.[_import_5_1_BalanceForwardReport] i
INNER JOIN dbo.Encounter e ON
	i.patientid = e.VendorID AND 
	e.VendorImportID = @VendorImportID
INNER JOIN dbo.ProcedureCodeDictionary pcd ON
	pcd.OfficialName = 'BALANCE FORWARD'
INNER JOIN dbo.EncounterDiagnosis ed ON 
	i.patientid = ed.VendorID AND
	ed.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'




--COMMIT
ROLLBACk