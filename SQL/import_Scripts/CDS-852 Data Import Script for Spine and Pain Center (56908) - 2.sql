--USE superbill_56908_dev
USE superbill_56908_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 1

SET NOCOUNT ON 

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
          --DateOfServiceTo ,
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
          PatientCheckedIn , 
		  AmountPaid
        )
SELECT DISTINCT
          @PracticeID , -- PracticeID - int
          pc.PatientID , -- PatientID - int
          CASE WHEN PAT.PrimaryProviderID IS NULL THEN Doc.DoctorID ELSE PAT.PrimaryProviderID END , -- DoctorID - int
          CASE WHEN PAT.DefaultServiceLocationID IS NULL THEN SL.ServiceLocationID ELSE PAT.DefaultServiceLocationID END , -- LocationID - int
          i.visitdate , -- DateOfService - datetime
          GETDATE() , -- DateCreated - datetime
          Convert(Varchar(10), GETDATE(),101) + ' : Balance Forward Created, please verify before use.' , -- Notes - text
          2 , -- EncounterStatusID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'B' , -- ReleaseSignatureSourceCode - char(1)
          11 , -- PlaceOfServiceCode - char(2)
          pc.PatientCaseID , -- PatientCaseID - int       
          i.chargedate , -- PostingDate - datetime
          --i.visitdate, -- DateOfServiceTo - datetime
          'U' , -- PaymentMethod - char(1)
          0 , -- AddOns - bigint
          0 , -- DoNotSendElectronic - bit
          GETDATE() , -- SubmittedDate - datetime
          0 , -- PaymentTypeID - int
          i.ticket , -- VendorID - varchar(50)                
          @VendorImportID , -- VendorImportID - int
          0 , -- DoNotSendElectronicSecondary - bit
          0 , -- overrideClosingDate - bit
          0 , -- ClaimTypeID - int
          0 , -- SecondaryClaimTypeID - int
          2 , -- SubmitReasonIDCMS1500 - int
          2 , -- SubmitReasonIDUB04 - int
          0 , -- PatientCheckedIn - bit
		  '0.00' 	  			 
FROM dbo.PatientCase AS PC  
INNER JOIN dbo.Patient PAT ON
	PC.PatientID = PAT.PatientID AND
	PC.VendorID = PAT.VendorID  
INNER JOIN dbo._import_5_1_Balfwd i ON 
	PAT.VendorID = i.account
LEFT JOIN dbo.Doctor Doc ON
	Doc.DoctorID = (SELECT MIN(DoctorID) FROM dbo.Doctor AS D WHERE d.ActiveDoctor =1 AND d.[External] = 0 AND d.PracticeID = @PracticeID AND d.ActiveDoctor = 1)
LEFT JOIN dbo.ServiceLocation SL ON
	SL.ServicelocationID = (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation S WHERE s.PracticeID = @PracticeID)
WHERE pc.Name = 'Balance Forward' AND pc.VendorImportID = @VendorImportID AND i.amount > '0'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

CREATE TABLE #AdminNote (VisitFID INT, ChargeCode VARCHAR(50) , InsBalance VARCHAR(15))
INSERT INTO #AdminNote
        ( VisitFID ,
          ChargeCode ,
          InsBalance 
        )
SELECT DISTINCT
		  i.ticket , -- VisitFID - int
          i.cptcode , -- ChargeCode - varchar(50)
          i.ticketbalance -- InsBalance - money
FROM dbo._import_5_1_Balfwd i
WHERE i.amount > '0'

PRINT ''
PRINT 'Updating Encounter Notes...'
UPDATE dbo.Encounter 
	SET AdminNotes =  'Remaining Balances From File:' + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) +
							  'Procedure Code: ' + Bal1.ChargeCode + ' | Ticket Balance = ' + Bal1.InsBalance + CHAR(13) + CHAR(10) +
					   ISNULL('Procedure Code: ' + Bal2.ChargeCode + ' | Ticket Balance = ' + Bal2.InsBalance,'') + CHAR(13) + CHAR(10) +
					   ISNULL('Procedure Code: ' + Bal3.ChargeCode + ' | Ticket Balance = ' + Bal3.InsBalance,'') + CHAR(13) + CHAR(10) +
					   ISNULL('Procedure Code: ' + Bal4.ChargeCode + ' | Ticket Balance = ' + Bal4.InsBalance,'') + CHAR(13) + CHAR(10) +
					   ISNULL('Procedure Code: ' + Bal5.ChargeCode + ' | Ticket Balance = ' + Bal5.InsBalance,'') + CHAR(13) + CHAR(10) +
					   ISNULL('Procedure Code: ' + Bal6.ChargeCode + ' | Ticket Balance = ' + Bal6.InsBalance,'') + CHAR(13) + CHAR(10) +
					   ISNULL('Procedure Code: ' + Bal7.ChargeCode + ' | Ticket Balance = ' + Bal7.InsBalance,'') + CHAR(13) + CHAR(10) +
					   ISNULL('Procedure Code: ' + Bal8.ChargeCode + ' | Ticket Balance = ' + Bal8.InsBalance,'') + CHAR(13) + CHAR(10) +
					   ISNULL('Procedure Code: ' + Bal9.ChargeCode + ' | Ticket Balance = ' + Bal9.InsBalance,'') + CHAR(13) + CHAR(10) +
					   ISNULL('Procedure Code: ' + Bal10.ChargeCode + ' | Ticket Balance = ' + Bal10.InsBalance,'') + CHAR(13) + CHAR(10) +
					   ISNULL('Procedure Code: ' + Bal11.ChargeCode + ' | Ticket Balance = ' + Bal11.InsBalance,'') + CHAR(13) + CHAR(10) +
					   ISNULL('Procedure Code: ' + Bal12.ChargeCode + ' | Ticket Balance = ' + Bal12.InsBalance,'') + CHAR(13) + CHAR(10) +
					   ISNULL('Procedure Code: ' + Bal13.ChargeCode + ' | Ticket Balance = ' + Bal13.InsBalance,'') + CHAR(13) + CHAR(10) +
					   ISNULL('Procedure Code: ' + Bal14.ChargeCode + ' | Ticket Balance = ' + Bal14.InsBalance,'') + CHAR(13) + CHAR(10) +
					   ISNULL('Procedure Code: ' + Bal15.ChargeCode + ' | Ticket Balance = ' + Bal15.InsBalance,'')
FROM dbo.Encounter e
LEFT JOIN (
SELECT VisitFID, ChargeCode, InsBalance,  ROW_NUMBER() OVER(PARTITION BY VisitFID ORDER BY VisitFID) AS BalNum FROM #AdminNote
		  ) AS Bal1 ON e.VendorID = Bal1.VisitFID AND Bal1.BalNum = 1
LEFT JOIN (
SELECT VisitFID, ChargeCode, InsBalance,  ROW_NUMBER() OVER(PARTITION BY VisitFID ORDER BY VisitFID) AS BalNum FROM #AdminNote
		  ) AS Bal2 ON e.VendorID = Bal2.VisitFID AND Bal2.BalNum = 2
LEFT JOIN (
SELECT VisitFID, ChargeCode, InsBalance,  ROW_NUMBER() OVER(PARTITION BY VisitFID ORDER BY VisitFID) AS BalNum FROM #AdminNote
		  ) AS Bal3 ON e.VendorID = Bal3.VisitFID AND bal3.BalNum = 3
LEFT JOIN (
SELECT VisitFID, ChargeCode, InsBalance,  ROW_NUMBER() OVER(PARTITION BY VisitFID ORDER BY VisitFID) AS BalNum FROM #AdminNote
		  ) AS Bal4 ON e.VendorID = Bal4.VisitFID AND bal4.BalNum = 4
LEFT JOIN (
SELECT VisitFID, ChargeCode, InsBalance,  ROW_NUMBER() OVER(PARTITION BY VisitFID ORDER BY VisitFID) AS BalNum FROM #AdminNote
		  ) AS Bal5 ON e.VendorID = Bal5.VisitFID AND bal5.BalNum = 5
LEFT JOIN (
SELECT VisitFID, ChargeCode, InsBalance,  ROW_NUMBER() OVER(PARTITION BY VisitFID ORDER BY VisitFID) AS BalNum FROM #AdminNote
		  ) AS Bal6 ON e.VendorID = Bal6.VisitFID AND bal6.BalNum = 6
LEFT JOIN (
SELECT VisitFID, ChargeCode, InsBalance,  ROW_NUMBER() OVER(PARTITION BY VisitFID ORDER BY VisitFID) AS BalNum FROM #AdminNote
		  ) AS Bal7 ON e.VendorID = Bal7.VisitFID AND bal7.BalNum = 7
LEFT JOIN (
SELECT VisitFID, ChargeCode, InsBalance,  ROW_NUMBER() OVER(PARTITION BY VisitFID ORDER BY VisitFID) AS BalNum FROM #AdminNote
		  ) AS Bal8 ON e.VendorID = Bal8.VisitFID AND bal8.BalNum = 8
LEFT JOIN (
SELECT VisitFID, ChargeCode, InsBalance,  ROW_NUMBER() OVER(PARTITION BY VisitFID ORDER BY VisitFID) AS BalNum FROM #AdminNote
		  ) AS Bal9 ON e.VendorID = Bal9.VisitFID AND bal9.BalNum = 9
LEFT JOIN (
SELECT VisitFID, ChargeCode, InsBalance,  ROW_NUMBER() OVER(PARTITION BY VisitFID ORDER BY VisitFID) AS BalNum FROM #AdminNote
		  ) AS Bal10 ON e.VendorID = Bal10.VisitFID AND bal10.BalNum = 10
LEFT JOIN (
SELECT VisitFID, ChargeCode, InsBalance,  ROW_NUMBER() OVER(PARTITION BY VisitFID ORDER BY VisitFID) AS BalNum FROM #AdminNote
		  ) AS Bal11 ON e.VendorID = Bal11.VisitFID AND bal11.BalNum = 11
LEFT JOIN (
SELECT VisitFID, ChargeCode, InsBalance,  ROW_NUMBER() OVER(PARTITION BY VisitFID ORDER BY VisitFID) AS BalNum FROM #AdminNote
		  ) AS Bal12 ON e.VendorID = Bal12.VisitFID AND Bal12.BalNum = 12
LEFT JOIN (
SELECT VisitFID, ChargeCode, InsBalance,  ROW_NUMBER() OVER(PARTITION BY VisitFID ORDER BY VisitFID) AS BalNum FROM #AdminNote
		  ) AS Bal13 ON e.VendorID = Bal13.VisitFID AND bal13.BalNum = 13
LEFT JOIN (
SELECT VisitFID, ChargeCode, InsBalance,  ROW_NUMBER() OVER(PARTITION BY VisitFID ORDER BY VisitFID) AS BalNum FROM #AdminNote
		  ) AS Bal14 ON e.VendorID = Bal14.VisitFID AND bal14.BalNum = 14
LEFT JOIN (
SELECT VisitFID, ChargeCode, InsBalance,  ROW_NUMBER() OVER(PARTITION BY VisitFID ORDER BY VisitFID) AS BalNum FROM #AdminNote
		  ) AS Bal15 ON e.VendorID = Bal15.VisitFID AND bal15.BalNum = 15
WHERE e.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Inserting Into Encounter Diagnosis...'
INSERT INTO dbo.EncounterDiagnosis
        ( 
		  EncounterID ,
          DiagnosisCodeDictionaryID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          RecordTimeStamp ,
          ListSequence ,
          PracticeID ,
          VendorID ,
          VendorImportID
        )
SELECT DISTINCT
          enc.EncounterID , -- EncounterID - int
          dcd.DiagnosisCodeDictionaryID , -- DiagnosisCodeDictionaryID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          NULL , -- RecordTimeStamp - timestamp
          1 , -- ListSequence - int
          @PracticeID  , -- PracticeID - int
          enc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Encounter as enc 
INNER JOIN dbo.DiagnosisCodeDictionary AS dcd ON
    dcd.DiagnosisCode = '000.00'      
WHERE enc.VendorImportID = @VendorImportID AND enc.PracticeID = @PracticeID   
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

CREATE TABLE #procode (ProcCode VARCHAR(10) , NAME VARCHAR(300))
INSERT INTO #procode
        ( ProcCode, NAME )
SELECT DISTINCT
		  i.cptcode , -- ProcCode - varchar(10)
          CASE i.cptcode
			WHEN '14' THEN 'CORRESPONDENCE-ATTNY RESPONSE' 
			WHEN '99938' THEN 'REACTIVE ACCOUNT BALANCE'
			WHEN 'A9301' THEN 'PULLEY SET-OVERDOOR'
			WHEN 'A9302' THEN 'THERABAND'
			WHEN 'A9303' THEN 'THERA PUTTY'
			WHEN 'CPR' THEN 'INSTRUCTING OF ELECTROMEDICAL'
			WHEN 'L1503' THEN 'NADA CHAIR'
			WHEN 'O1450' THEN 'ONE MODALITY'
		 END
FROM dbo._import_5_1_Balfwd i 
LEFT JOIN dbo.ProcedureCodeDictionary pcd ON 
	i.cptcode = pcd.ProcedureCode 
WHERE pcd.procedurecodedictionaryid IS NULL AND i.amount > '0'
		
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
          NOC ,
          CustomCode
        )
SELECT DISTINCT
		  ProcCode , -- ProcedureCode - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          '1' , -- TypeOfServiceCode - char(1)
          1 , -- Active - bit
          NAME , -- OfficialName - varchar(300)
          0 , -- NOC - int
          1  -- CustomCode - bit
FROM #procode 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Encounter Procedure...'
INSERT INTO dbo.EncounterProcedure
        ( 
		  EncounterID ,
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
          AssessmentDate ,
          DoctorID ,
          ConcurrentProcedures 
        )
SELECT DISTINCT
          enc.EncounterID  , -- EncounterID - int
          pcd.ProcedureCodeDictionaryID , -- ProcedureCodeDictionaryID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.amount , -- ServiceChargeAmount - money   
          '1.000' , -- ServiceUnitCount - decimal
          GETDATE() , -- ProcedureDateOfService - datetime
          @PracticeID , -- PracticeID - int
          ed.EncounterDiagnosisID , -- EncounterDiagnosisID1 - int
          GETDATE() , -- ServiceEndDate - datetime
          enc.VendorID , -- VendorID - varchar(50)              
          @VendorImportID , -- VendorImportID - int
          '1' , -- TypeOfServiceCode - char(1)
          0 , -- AnesthesiaTime - int
          GETDATE() , -- AssessmentDate - datetime
          enc.DoctorID , -- DoctorID - int
          1  -- ConcurrentProcedures - int
FROM dbo.Encounter AS enc
INNER JOIN dbo._import_5_1_Balfwd i ON 
	enc.VendorID = i.ticket
INNER JOIN dbo.ProcedureCodeDictionary AS pcd ON
	i.billcode = pcd.ProcedureCode
INNER JOIN dbo.EncounterDiagnosis AS ed ON
   ed.vendorID = enc.VendorID AND 
   ed.VendorImportID = @VendorImportID   
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
  

DROP TABLE #procode, #AdminNote

--ROLLBACK
--COMMIT



