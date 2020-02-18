--USE superbill_6893_dev
USE superbill_6893_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @TargetPracticeID INT
DECLARE @SourcePracticeID INT
DECLARE @VendorImportID INT

SET @TargetPracticeID = 5
SET @SourcePracticeID = 4
SET @VendorImportID = 1

SET NOCOUNT ON 

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
          Hidden ,
          AccountStatus ,
          NoteTypeCode ,
          LastNote ,
		  NoteMessage
        )
SELECT 
		  GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          pat.patientid , -- PatientID - int
          'Kareo' , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          0 , -- Hidden - bit
          0 , -- AccountStatus - bit
          1 , -- NoteTypeCode - int
          0 , -- LastNote - bit
	     'Encounter DOS: ' + CONVERT(VARCHAR(30), E.DateOfService, 101) + CHAR(13) + CHAR(10) +
		 CASE WHEN EP1.EncounterProcedureID IS NOT NULL THEN 'From Date: ' + CONVERT(VARCHAR(30), EP1.ProcedureDateOfService, 101) + ' | '  ELSE '' END +
		 CASE WHEN EP1.EncounterProcedureID IS NOT NULL THEN 'To Date: ' + CONVERT(VARCHAR(30), EP1.ServiceEndDate, 101) + ' | '  ELSE '' END +
		 CASE WHEN PCD11.ProcedureCode IS NOT NULL THEN 'ProcedureCode1: ' + PCD11.ProcedureCode + ' | ' ELSE '' END	+
		 CASE WHEN DCD11.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode1-1: ' + DCD11.DiagnosisCode + ' | '  ELSE '' END +	
		 CASE WHEN DCD11.DiagnosisCode IS NULL THEN CASE WHEN ICD11.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode1-1: ' + ICD11.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD12.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode1-2: ' + DCD12.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD12.DiagnosisCode IS NULL THEN CASE WHEN ICD12.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode1-2: ' + ICD12.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +	
		 CASE WHEN DCD13.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode1-3: ' + DCD13.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD13.DiagnosisCode IS NULL THEN CASE WHEN ICD13.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode1-3: ' + ICD13.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +	
		 CASE WHEN DCD14.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode1-4: ' + DCD14.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD14.DiagnosisCode IS NULL THEN CASE WHEN ICD14.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode1-4: ' + ICD14.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +	
		 CASE WHEN EP1.ServiceChargeAmount IS NOT NULL THEN 'Units: ' + CONVERT(VARCHAR,CONVERT(INT, EP1.ServiceUnitCount),1) + ' | ' ELSE '' END +
		 CASE WHEN EP1.ServiceChargeAmount IS NOT NULL THEN 'ProcCode1Total: $' + CONVERT(VARCHAR,CONVERT(money, (EP1.ServiceChargeAmount * EP1.ServiceUnitCount)),1) ELSE '' END + CHAR(13) + CHAR(10) +

		 CASE WHEN EP2.EncounterProcedureID IS NOT NULL THEN 'From Date: ' + CONVERT(VARCHAR(30), EP2.ProcedureDateOfService, 101) + ' | '  ELSE '' END +
		 CASE WHEN EP2.EncounterProcedureID IS NOT NULL THEN 'To Date: ' + CONVERT(VARCHAR(30), EP2.ServiceEndDate, 101) + ' | '  ELSE '' END +
		 CASE WHEN PCD21.ProcedureCode IS NOT NULL THEN 'ProcedureCode2: ' + PCD21.ProcedureCode + ' | '  ELSE '' END +
		 CASE WHEN DCD21.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode2-1: ' + DCD21.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD21.DiagnosisCode IS NULL THEN CASE WHEN ICD21.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode2-1: ' + ICD21.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD22.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode2-2: ' + DCD22.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD22.DiagnosisCode IS NULL THEN CASE WHEN ICD22.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode2-2: ' + ICD22.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD23.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode2-3: ' + DCD23.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD23.DiagnosisCode IS NULL THEN CASE WHEN ICD23.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode2-3: ' + ICD23.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD24.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode2-4: ' + DCD24.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD24.DiagnosisCode IS NULL THEN CASE WHEN ICD24.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode2-4: ' + ICD24.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN EP2.ServiceChargeAmount IS NOT NULL THEN 'Units: ' + CONVERT(VARCHAR,CONVERT(INT, EP2.ServiceUnitCount),1) + ' | ' ELSE '' END +
		 CASE WHEN EP2.ServiceChargeAmount IS NOT NULL THEN 'ProcCode2Total: $' + CONVERT(VARCHAR,CONVERT(money, (EP2.ServiceChargeAmount * EP2.ServiceUnitCount)),1)  ELSE '' END + CHAR(13) + CHAR(10) +

		 CASE WHEN EP3.EncounterProcedureID IS NOT NULL THEN 'From Date: ' + CONVERT(VARCHAR(30), EP3.ProcedureDateOfService, 101) + ' | '  ELSE '' END +
		 CASE WHEN EP3.EncounterProcedureID IS NOT NULL THEN 'To Date: ' + CONVERT(VARCHAR(30), EP3.ServiceEndDate, 101) + ' | '  ELSE '' END +
		 CASE WHEN PCD31.ProcedureCode IS NOT NULL THEN 'ProcedureCode3: ' + PCD31.ProcedureCode + ' | '  ELSE '' END +
		 CASE WHEN DCD31.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode3-1: ' + DCD31.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD31.DiagnosisCode IS NULL THEN CASE WHEN ICD31.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode3-1: ' + ICD31.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD32.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode3-2: ' + DCD32.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD32.DiagnosisCode IS NULL THEN CASE WHEN ICD32.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode3-2: ' + ICD32.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD33.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode3-3: ' + DCD33.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD33.DiagnosisCode IS NULL THEN CASE WHEN ICD33.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode3-3: ' + ICD33.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD34.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode3-4: ' + DCD34.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD34.DiagnosisCode IS NULL THEN CASE WHEN ICD34.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode3-4: ' + ICD34.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN EP3.ServiceChargeAmount IS NOT NULL THEN 'Units: ' + CONVERT(VARCHAR,CONVERT(INT, EP3.ServiceUnitCount),1) + ' | ' ELSE '' END +
		 CASE WHEN EP3.ServiceChargeAmount IS NOT NULL THEN 'ProcCode3Total: $' + CONVERT(VARCHAR,CONVERT(money, (EP3.ServiceChargeAmount * EP3.ServiceUnitCount)),1)  ELSE '' END + CHAR(13) + CHAR(10) +

		 CASE WHEN EP4.EncounterProcedureID IS NOT NULL THEN 'From Date: ' + CONVERT(VARCHAR(30), EP4.ProcedureDateOfService, 101) + ' | '  ELSE '' END +
		 CASE WHEN EP4.EncounterProcedureID IS NOT NULL THEN 'To Date: ' + CONVERT(VARCHAR(30), EP4.ServiceEndDate, 101) + ' | '  ELSE '' END +
		 CASE WHEN PCD41.ProcedureCode IS NOT NULL THEN 'ProcedureCode4: ' + PCD41.ProcedureCode + ' | '  ELSE '' END +
		 CASE WHEN DCD41.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode4-1: ' + DCD41.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD41.DiagnosisCode IS NULL THEN CASE WHEN ICD41.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode4-1: ' + ICD41.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD42.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode4-2: ' + DCD42.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD42.DiagnosisCode IS NULL THEN CASE WHEN ICD42.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode4-2: ' + ICD42.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD43.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode4-3: ' + DCD43.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD43.DiagnosisCode IS NULL THEN CASE WHEN ICD43.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode4-3: ' + ICD43.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD44.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode4-4: ' + DCD44.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD44.DiagnosisCode IS NULL THEN CASE WHEN ICD44.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode4-4: ' + ICD44.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN EP4.ServiceChargeAmount IS NOT NULL THEN 'Units: ' + CONVERT(VARCHAR,CONVERT(INT, EP4.ServiceUnitCount),1) + ' | ' ELSE '' END +
		 CASE WHEN EP4.ServiceChargeAmount IS NOT NULL THEN 'ProcCode4Total: $' + CONVERT(VARCHAR,CONVERT(money, (EP4.ServiceChargeAmount * EP4.ServiceUnitCount)),1) ELSE ''  END + CHAR(13) + CHAR(10) +

		 CASE WHEN EP5.EncounterProcedureID IS NOT NULL THEN 'From Date: ' + CONVERT(VARCHAR(30), EP5.ProcedureDateOfService, 101) + ' | '  ELSE '' END +
		 CASE WHEN EP5.EncounterProcedureID IS NOT NULL THEN 'To Date: ' + CONVERT(VARCHAR(30), EP5.ServiceEndDate, 101) + ' | '  ELSE '' END +
		 CASE WHEN PCD45.ProcedureCode IS NOT NULL THEN 'ProcedureCode5: ' + PCD45.ProcedureCode + ' | '  ELSE '' END +
		 CASE WHEN DCD45.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode5-1: ' + DCD45.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD45.DiagnosisCode IS NULL THEN CASE WHEN ICD45.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode5-1: ' + ICD45.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD46.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode5-2: ' + DCD46.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD46.DiagnosisCode IS NULL THEN CASE WHEN ICD46.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode5-2: ' + ICD46.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD47.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode5-3: ' + DCD47.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD47.DiagnosisCode IS NULL THEN CASE WHEN ICD47.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode5-3: ' + ICD47.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD48.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode5-4: ' + DCD48.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD48.DiagnosisCode IS NULL THEN CASE WHEN ICD48.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode5-4: ' + ICD48.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN EP5.ServiceChargeAmount IS NOT NULL THEN 'Units: ' + CONVERT(VARCHAR,CONVERT(INT, EP5.ServiceUnitCount),1) + ' | ' ELSE '' END +
		 CASE WHEN EP5.ServiceChargeAmount IS NOT NULL THEN 'ProcCode5Total: $' + CONVERT(VARCHAR,CONVERT(money, (EP5.ServiceChargeAmount * EP5.ServiceUnitCount)),1) ELSE ''  END + CHAR(13) + CHAR(10) +

		 CASE WHEN EP6.EncounterProcedureID IS NOT NULL THEN 'From Date: ' + CONVERT(VARCHAR(30), EP6.ProcedureDateOfService, 101) + ' | '  ELSE '' END +
		 CASE WHEN EP6.EncounterProcedureID IS NOT NULL THEN 'To Date: ' + CONVERT(VARCHAR(30), EP6.ServiceEndDate, 101) + ' | '  ELSE '' END +
		 CASE WHEN PCD49.ProcedureCode IS NOT NULL THEN 'ProcedureCode6: ' + PCD49.ProcedureCode + ' | '  ELSE '' END +
		 CASE WHEN DCD49.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode6-1: ' + DCD49.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD49.DiagnosisCode IS NULL THEN CASE WHEN ICD49.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode6-1: ' + ICD49.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD50.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode6-2: ' + DCD50.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD50.DiagnosisCode IS NULL THEN CASE WHEN ICD50.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode6-2: ' + ICD50.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD51.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode6-3: ' + DCD51.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD51.DiagnosisCode IS NULL THEN CASE WHEN ICD51.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode6-3: ' + ICD51.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD52.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode6-4: ' + DCD52.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD52.DiagnosisCode IS NULL THEN CASE WHEN ICD52.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode6-4: ' + ICD52.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN EP6.ServiceChargeAmount IS NOT NULL THEN 'Units: ' + CONVERT(VARCHAR,CONVERT(INT, EP6.ServiceUnitCount),1) + ' | ' ELSE '' END +
		 CASE WHEN EP6.ServiceChargeAmount IS NOT NULL THEN 'ProcCode6Total: $' + CONVERT(VARCHAR,CONVERT(money, (EP6.ServiceChargeAmount * EP6.ServiceUnitCount)),1) ELSE ''  END + CHAR(13) + CHAR(10) +

		 CASE WHEN EP7.EncounterProcedureID IS NOT NULL THEN 'From Date: ' + CONVERT(VARCHAR(30), EP7.ProcedureDateOfService, 101) + ' | '  ELSE '' END +
		 CASE WHEN EP7.EncounterProcedureID IS NOT NULL THEN 'To Date: ' + CONVERT(VARCHAR(30), EP7.ServiceEndDate, 101) + ' | '  ELSE '' END +
		 CASE WHEN PCD53.ProcedureCode IS NOT NULL THEN 'ProcedureCode7: ' + PCD53.ProcedureCode + ' | '  ELSE '' END +
		 CASE WHEN DCD53.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode7-1: ' + DCD53.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD53.DiagnosisCode IS NULL THEN CASE WHEN ICD53.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode7-1: ' + ICD53.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD54.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode7-2: ' + DCD54.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD54.DiagnosisCode IS NULL THEN CASE WHEN ICD54.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode7-2: ' + ICD54.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD55.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode7-3: ' + DCD55.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD55.DiagnosisCode IS NULL THEN CASE WHEN ICD55.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode7-3: ' + ICD55.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD56.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode7-4: ' + DCD56.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD56.DiagnosisCode IS NULL THEN CASE WHEN ICD56.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode7-4: ' + ICD56.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN EP7.ServiceChargeAmount IS NOT NULL THEN 'Units: ' + CONVERT(VARCHAR,CONVERT(INT, EP7.ServiceUnitCount),1) + ' | ' ELSE '' END +
		 CASE WHEN EP7.ServiceChargeAmount IS NOT NULL THEN 'ProcCode7Total: $' + CONVERT(VARCHAR,CONVERT(money, (EP7.ServiceChargeAmount * EP7.ServiceUnitCount)),1) ELSE ''  END + CHAR(13) + CHAR(10) +

		 CASE WHEN EP8.EncounterProcedureID IS NOT NULL THEN 'From Date: ' + CONVERT(VARCHAR(30), EP8.ProcedureDateOfService, 101) + ' | '  ELSE '' END +
		 CASE WHEN EP8.EncounterProcedureID IS NOT NULL THEN 'To Date: ' + CONVERT(VARCHAR(30), EP8.ServiceEndDate, 101) + ' | '  ELSE '' END +
		 CASE WHEN PCD57.ProcedureCode IS NOT NULL THEN 'ProcedureCode8: ' + PCD57.ProcedureCode + ' | '  ELSE '' END +
		 CASE WHEN DCD57.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode8-1: ' + DCD57.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD57.DiagnosisCode IS NULL THEN CASE WHEN ICD57.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode8-1: ' + ICD57.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD58.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode8-2: ' + DCD58.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD58.DiagnosisCode IS NULL THEN CASE WHEN ICD58.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode8-2: ' + ICD58.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD59.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode8-3: ' + DCD59.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD59.DiagnosisCode IS NULL THEN CASE WHEN ICD59.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode8-3: ' + ICD59.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD60.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode8-4: ' + DCD60.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD60.DiagnosisCode IS NULL THEN CASE WHEN ICD60.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode8-4: ' + ICD60.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN EP8.ServiceChargeAmount IS NOT NULL THEN 'Units: ' + CONVERT(VARCHAR,CONVERT(INT, EP8.ServiceUnitCount),1) + ' | ' ELSE '' END +
		 CASE WHEN EP8.ServiceChargeAmount IS NOT NULL THEN 'ProcCode8Total: $' + CONVERT(VARCHAR,CONVERT(money, (EP8.ServiceChargeAmount * EP8.ServiceUnitCount)),1) ELSE ''  END + CHAR(13) + CHAR(10) +

		 CASE WHEN EP9.EncounterProcedureID IS NOT NULL THEN 'From Date: ' + CONVERT(VARCHAR(30), EP9.ProcedureDateOfService, 101) + ' | '  ELSE '' END +
		 CASE WHEN EP9.EncounterProcedureID IS NOT NULL THEN 'To Date: ' + CONVERT(VARCHAR(30), EP9.ServiceEndDate, 101) + ' | '  ELSE '' END +
		 CASE WHEN PCD61.ProcedureCode IS NOT NULL THEN 'ProcedureCode9: ' + PCD61.ProcedureCode + ' | '  ELSE '' END +
		 CASE WHEN DCD61.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode9-1: ' + DCD61.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD61.DiagnosisCode IS NULL THEN CASE WHEN ICD61.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode9-1: ' + ICD61.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD62.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode9-2: ' + DCD62.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD62.DiagnosisCode IS NULL THEN CASE WHEN ICD62.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode9-2: ' + ICD62.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD63.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode9-3: ' + DCD63.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD63.DiagnosisCode IS NULL THEN CASE WHEN ICD63.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode9-3: ' + ICD63.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD64.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode9-4: ' + DCD64.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD64.DiagnosisCode IS NULL THEN CASE WHEN ICD64.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode9-4: ' + ICD64.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN EP9.ServiceChargeAmount IS NOT NULL THEN 'Units: ' + CONVERT(VARCHAR,CONVERT(INT, EP9.ServiceUnitCount),1) + ' | ' ELSE '' END +
		 CASE WHEN EP9.ServiceChargeAmount IS NOT NULL THEN 'ProcCode9Total: $' + CONVERT(VARCHAR,CONVERT(money, (EP9.ServiceChargeAmount * EP9.ServiceUnitCount)),1) ELSE ''  END + CHAR(13) + CHAR(10) +

		 CASE WHEN EP10.EncounterProcedureID IS NOT NULL THEN 'From Date: ' + CONVERT(VARCHAR(30), EP10.ProcedureDateOfService, 101) + ' | '  ELSE '' END +
		 CASE WHEN EP10.EncounterProcedureID IS NOT NULL THEN 'To Date: ' + CONVERT(VARCHAR(30), EP10.ServiceEndDate, 101) + ' | '  ELSE '' END +
		 CASE WHEN PCD65.ProcedureCode IS NOT NULL THEN 'ProcedureCode10: ' + PCD65.ProcedureCode + ' | '  ELSE '' END +
		 CASE WHEN DCD65.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode10-1: ' + DCD65.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD65.DiagnosisCode IS NULL THEN CASE WHEN ICD65.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode10-1: ' + ICD65.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD66.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode10-2: ' + DCD66.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD66.DiagnosisCode IS NULL THEN CASE WHEN ICD66.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode10-2: ' + ICD66.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD67.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode10-3: ' + DCD67.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD67.DiagnosisCode IS NULL THEN CASE WHEN ICD67.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode10-3: ' + ICD67.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD68.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode10-4: ' + DCD68.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD68.DiagnosisCode IS NULL THEN CASE WHEN ICD68.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode10-4: ' + ICD68.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN EP10.ServiceChargeAmount IS NOT NULL THEN 'Units: ' + CONVERT(VARCHAR,CONVERT(INT, EP10.ServiceUnitCount),1) + ' | ' ELSE '' END +
		 CASE WHEN EP10.ServiceChargeAmount IS NOT NULL THEN 'ProcCode10Total: $' + CONVERT(VARCHAR,CONVERT(money, (EP10.ServiceChargeAmount * EP10.ServiceUnitCount)),1) ELSE ''  END + CHAR(13) + CHAR(10) +

		 CASE WHEN EP11.EncounterProcedureID IS NOT NULL THEN 'From Date: ' + CONVERT(VARCHAR(30), EP11.ProcedureDateOfService, 101) + ' | '  ELSE '' END +
		 CASE WHEN EP11.EncounterProcedureID IS NOT NULL THEN 'To Date: ' + CONVERT(VARCHAR(30), EP11.ServiceEndDate, 101) + ' | '  ELSE '' END +		 
		 CASE WHEN PCD69.ProcedureCode IS NOT NULL THEN 'ProcedureCode11: ' + PCD69.ProcedureCode + ' | '  ELSE '' END +
		 CASE WHEN DCD69.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode11-1: ' + DCD69.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD69.DiagnosisCode IS NULL THEN CASE WHEN ICD69.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode11-1: ' + ICD69.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD70.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode11-2: ' + DCD70.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD70.DiagnosisCode IS NULL THEN CASE WHEN ICD70.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode11-2: ' + ICD70.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD71.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode11-3: ' + DCD71.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD71.DiagnosisCode IS NULL THEN CASE WHEN ICD71.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode11-3: ' + ICD71.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD72.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode11-4: ' + DCD72.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD72.DiagnosisCode IS NULL THEN CASE WHEN ICD72.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode11-4: ' + ICD72.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN EP11.ServiceChargeAmount IS NOT NULL THEN 'Units: ' + CONVERT(VARCHAR,CONVERT(INT, EP11.ServiceUnitCount),1) + ' | ' ELSE '' END +
		 CASE WHEN EP11.ServiceChargeAmount IS NOT NULL THEN 'ProcCode11Total: $' + CONVERT(VARCHAR,CONVERT(money, (EP11.ServiceChargeAmount * EP11.ServiceUnitCount)),1) ELSE ''  END + CHAR(13) + CHAR(10) +
		 
		 CASE WHEN EP12.EncounterProcedureID IS NOT NULL THEN 'From Date: ' + CONVERT(VARCHAR(30), EP12.ProcedureDateOfService, 101) + ' | '  ELSE '' END +
		 CASE WHEN EP12.EncounterProcedureID IS NOT NULL THEN 'To Date: ' + CONVERT(VARCHAR(30), EP12.ServiceEndDate, 101) + ' | '  ELSE '' END +
		 CASE WHEN PCD73.ProcedureCode IS NOT NULL THEN 'ProcedureCode12: ' + PCD73.ProcedureCode + ' | '  ELSE '' END +
		 CASE WHEN DCD73.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode12-1: ' + DCD73.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD73.DiagnosisCode IS NULL THEN CASE WHEN ICD73.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode12-1: ' + ICD73.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD74.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode12-2: ' + DCD74.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD74.DiagnosisCode IS NULL THEN CASE WHEN ICD74.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode12-2: ' + ICD74.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD75.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode12-3: ' + DCD75.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD75.DiagnosisCode IS NULL THEN CASE WHEN ICD75.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode12-3: ' + ICD75.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD76.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode12-4: ' + DCD76.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD76.DiagnosisCode IS NULL THEN CASE WHEN ICD76.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode12-4: ' + ICD76.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN EP12.ServiceChargeAmount IS NOT NULL THEN 'Units: ' + CONVERT(VARCHAR,CONVERT(INT, EP12.ServiceUnitCount),1) + ' | ' ELSE '' END +
		 CASE WHEN EP12.ServiceChargeAmount IS NOT NULL THEN 'ProcCode12Total: $' + CONVERT(VARCHAR,CONVERT(money, (EP12.ServiceChargeAmount * EP12.ServiceUnitCount)),1) ELSE ''  END + CHAR(13) + CHAR(10) +
 		 
		 CASE WHEN EP13.EncounterProcedureID IS NOT NULL THEN 'From Date: ' + CONVERT(VARCHAR(30), EP13.ProcedureDateOfService, 101) + ' | '  ELSE '' END +
		 CASE WHEN EP13.EncounterProcedureID IS NOT NULL THEN 'To Date: ' + CONVERT(VARCHAR(30), EP13.ServiceEndDate, 101) + ' | '  ELSE '' END +
		 CASE WHEN PCD77.ProcedureCode IS NOT NULL THEN 'ProcedureCode13: ' + PCD77.ProcedureCode + ' | '  ELSE '' END +
		 CASE WHEN DCD77.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode13-1: ' + DCD77.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD77.DiagnosisCode IS NULL THEN CASE WHEN ICD77.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode13-1: ' + ICD77.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD78.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode13-2: ' + DCD78.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD78.DiagnosisCode IS NULL THEN CASE WHEN ICD78.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode13-2: ' + ICD78.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD79.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode13-3: ' + DCD79.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD79.DiagnosisCode IS NULL THEN CASE WHEN ICD79.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode13-3: ' + ICD79.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD80.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode13-4: ' + DCD80.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD80.DiagnosisCode IS NULL THEN CASE WHEN ICD80.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode13-4: ' + ICD80.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN EP13.ServiceChargeAmount IS NOT NULL THEN 'Units: ' + CONVERT(VARCHAR,CONVERT(INT, EP13.ServiceUnitCount),1) + ' | ' ELSE '' END +
		 CASE WHEN EP13.ServiceChargeAmount IS NOT NULL THEN 'ProcCode13Total: $' + CONVERT(VARCHAR,CONVERT(money, (EP13.ServiceChargeAmount * EP13.ServiceUnitCount)),1) ELSE ''  END + CHAR(13) + CHAR(10) +
 		 
		 CASE WHEN EP14.EncounterProcedureID IS NOT NULL THEN 'From Date: ' + CONVERT(VARCHAR(30), EP14.ProcedureDateOfService, 101) + ' | '  ELSE '' END +
		 CASE WHEN EP14.EncounterProcedureID IS NOT NULL THEN 'To Date: ' + CONVERT(VARCHAR(30), EP14.ServiceEndDate, 101) + ' | '  ELSE '' END +
		 CASE WHEN PCD81.ProcedureCode IS NOT NULL THEN 'ProcedureCode14: ' + PCD81.ProcedureCode + ' | '  ELSE '' END +
		 CASE WHEN DCD81.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode14-1: ' + DCD81.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD81.DiagnosisCode IS NULL THEN CASE WHEN ICD81.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode14-1: ' + ICD81.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD82.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode14-2: ' + DCD82.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD82.DiagnosisCode IS NULL THEN CASE WHEN ICD82.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode14-2: ' + ICD82.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD83.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode14-3: ' + DCD83.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD83.DiagnosisCode IS NULL THEN CASE WHEN ICD83.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode14-3: ' + ICD83.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD84.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode14-4: ' + DCD84.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD84.DiagnosisCode IS NULL THEN CASE WHEN ICD84.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode14-4: ' + ICD84.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN EP14.ServiceChargeAmount IS NOT NULL THEN 'Units: ' + CONVERT(VARCHAR,CONVERT(INT, EP14.ServiceUnitCount),1) + ' | ' ELSE '' END +
		 CASE WHEN EP14.ServiceChargeAmount IS NOT NULL THEN 'ProcCode14Total: $' + CONVERT(VARCHAR,CONVERT(money, (EP14.ServiceChargeAmount * EP14.ServiceUnitCount)),1) ELSE ''  END + CHAR(13) + CHAR(10) +		 
  		 
		 CASE WHEN EP15.EncounterProcedureID IS NOT NULL THEN 'From Date: ' + CONVERT(VARCHAR(30), EP15.ProcedureDateOfService, 101) + ' | '  ELSE '' END +
		 CASE WHEN EP15.EncounterProcedureID IS NOT NULL THEN 'To Date: ' + CONVERT(VARCHAR(30), EP15.ServiceEndDate, 101) + ' | '  ELSE '' END +
		 CASE WHEN PCD85.ProcedureCode IS NOT NULL THEN 'ProcedureCode15: ' + PCD85.ProcedureCode + ' | '  ELSE '' END +
		 CASE WHEN DCD85.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode15-1: ' + DCD85.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD85.DiagnosisCode IS NULL THEN CASE WHEN ICD85.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode15-1: ' + ICD85.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD86.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode15-2: ' + DCD86.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD86.DiagnosisCode IS NULL THEN CASE WHEN ICD86.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode15-2: ' + ICD86.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD87.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode15-3: ' + DCD87.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD87.DiagnosisCode IS NULL THEN CASE WHEN ICD87.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode15-3: ' + ICD87.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN DCD88.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode15-4: ' + DCD88.DiagnosisCode + ' | '  ELSE '' END +
		 CASE WHEN DCD88.DiagnosisCode IS NULL THEN CASE WHEN ICD88.DiagnosisCode IS NOT NULL THEN 'DiagnosisCode15-4: ' + ICD88.DiagnosisCode + ' | '  ELSE ''  END ELSE '' END +
		 CASE WHEN EP15.ServiceChargeAmount IS NOT NULL THEN 'Units: ' + CONVERT(VARCHAR,CONVERT(INT, EP15.ServiceUnitCount),1) + ' | ' ELSE '' END +
		 CASE WHEN EP15.ServiceChargeAmount IS NOT NULL THEN 'ProcCode15Total: $' + CONVERT(VARCHAR,CONVERT(money, (EP15.ServiceChargeAmount * EP15.ServiceUnitCount)),1) ELSE ''  END + CHAR(13) + CHAR(10)  

FROM dbo.Patient  Pat 
LEFT OUTER JOIN dbo.Encounter E ON 
E.PatientID = PAT.VendorID AND
pat.PracticeID = @TargetPracticeID 
LEFT OUTER JOIN dbo.EncounterProcedure EP1 ON EP1.EncounterID = E.EncounterID AND EP1.EncounterProcedureID = (SELECT MIN(EncounterProcedureID) FROM dbo.EncounterProcedure WHERE EncounterID = E.EncounterID)
LEFT OUTER JOIN dbo.ProcedureCodeDictionary PCD11 ON  PCD11.ProcedureCodeDictionaryID = EP1.ProcedureCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED11 ON ED11.EncounterDiagnosisID = EP1.EncounterDiagnosisID1
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD11 ON DCD11.DiagnosisCodeDictionaryID = ED11.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD11 ON ICD11.ICD10DiagnosisCodeDictionaryID = ED11.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED12 ON ED12.EncounterDiagnosisID = EP1.EncounterDiagnosisID2
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD12 ON DCD12.DiagnosisCodeDictionaryID = ED12.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD12 ON ICD12.ICD10DiagnosisCodeDictionaryID = ED12.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED13 ON ED13.EncounterDiagnosisID = EP1.EncounterDiagnosisID3
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD13 ON DCD13.DiagnosisCodeDictionaryID = ED13.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD13 ON ICD13.ICD10DiagnosisCodeDictionaryID = ED13.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED14 ON ED14.EncounterDiagnosisID = EP1.EncounterDiagnosisID4
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD14 ON DCD14.DiagnosisCodeDictionaryID = ED14.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD14 ON ICD14.ICD10DiagnosisCodeDictionaryID = ED14.DiagnosisCodeDictionaryID

LEFT OUTER JOIN dbo.EncounterProcedure EP2 ON EP2.EncounterID = E.EncounterID AND EP2.EncounterProcedureID = (SELECT MIN(EncounterProcedureID) FROM dbo.EncounterProcedure WHERE EncounterID = E.EncounterID AND EncounterProcedureID <> EP1.EncounterProcedureID)
LEFT OUTER JOIN dbo.ProcedureCodeDictionary PCD21 ON  PCD21.ProcedureCodeDictionaryID = EP2.ProcedureCodeDictionaryID 
LEFT OUTER JOIN dbo.EncounterDiagnosis ED21 ON ED21.EncounterDiagnosisID = EP2.EncounterDiagnosisID1
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD21 ON DCD21.DiagnosisCodeDictionaryID = ED21.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD21 ON ICD21.ICD10DiagnosisCodeDictionaryID = ED21.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED22 ON ED22.EncounterDiagnosisID = EP2.EncounterDiagnosisID2
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD22 ON DCD22.DiagnosisCodeDictionaryID = ED22.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD22 ON ICD22.ICD10DiagnosisCodeDictionaryID = ED22.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED23 ON ED23.EncounterDiagnosisID = EP2.EncounterDiagnosisID3
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD23 ON DCD23.DiagnosisCodeDictionaryID = ED23.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD23 ON ICD23.ICD10DiagnosisCodeDictionaryID = ED23.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED24 ON ED24.EncounterDiagnosisID = EP2.EncounterDiagnosisID4
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD24 ON DCD24.DiagnosisCodeDictionaryID = ED24.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD24 ON ICD24.ICD10DiagnosisCodeDictionaryID = ED24.DiagnosisCodeDictionaryID

LEFT OUTER JOIN dbo.EncounterProcedure EP3 ON EP3.EncounterID = E.EncounterID AND EP3.EncounterProcedureID = (SELECT MIN(EncounterProcedureID) FROM dbo.EncounterProcedure WHERE EncounterID = E.EncounterID AND EncounterPRocedureID NOT IN (EP1.EncounterProcedureID, EP2.EncounterProcedureID))
LEFT OUTER JOIN dbo.ProcedureCodeDictionary PCD31 ON  PCD31.ProcedureCodeDictionaryID = EP3.ProcedureCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED31 ON ED31.EncounterDiagnosisID = EP3.EncounterDiagnosisID1
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD31 ON DCD31.DiagnosisCodeDictionaryID = ED31.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD31 ON ICD31.ICD10DiagnosisCodeDictionaryID = ED31.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED32 ON ED32.EncounterDiagnosisID = EP3.EncounterDiagnosisID2
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD32 ON DCD32.DiagnosisCodeDictionaryID = ED32.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD32 ON ICD32.ICD10DiagnosisCodeDictionaryID = ED32.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED33 ON ED33.EncounterDiagnosisID = EP3.EncounterDiagnosisID3
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD33 ON DCD33.DiagnosisCodeDictionaryID = ED33.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD33 ON ICD33.ICD10DiagnosisCodeDictionaryID = ED33.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED34 ON ED34.EncounterDiagnosisID = EP3.EncounterDiagnosisID4
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD34 ON DCD34.DiagnosisCodeDictionaryID = ED34.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD34 ON ICD34.ICD10DiagnosisCodeDictionaryID = ED34.DiagnosisCodeDictionaryID

LEFT OUTER JOIN dbo.EncounterProcedure EP4 ON EP4.EncounterID = E.EncounterID AND EP4.EncounterProcedureID = (SELECT MIN(EncounterProcedureID) FROM dbo.EncounterProcedure WHERE EncounterID = E.EncounterID AND EncounterPRocedureID NOT IN (EP1.EncounterProcedureID, EP2.EncounterProcedureID, EP3.EncounterProcedureID))
LEFT OUTER JOIN dbo.ProcedureCodeDictionary PCD41 ON  PCD41.ProcedureCodeDictionaryID = EP4.ProcedureCodeDictionaryID 
LEFT OUTER JOIN dbo.EncounterDiagnosis ED41 ON ED41.EncounterDiagnosisID = EP4.EncounterDiagnosisID1
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD41 ON DCD41.DiagnosisCodeDictionaryID = ED41.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD41 ON ICD41.ICD10DiagnosisCodeDictionaryID = ED41.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED42 ON ED42.EncounterDiagnosisID = EP4.EncounterDiagnosisID2
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD42 ON DCD42.DiagnosisCodeDictionaryID = ED42.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD42 ON ICD42.ICD10DiagnosisCodeDictionaryID = ED42.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED43 ON ED43.EncounterDiagnosisID = EP4.EncounterDiagnosisID3
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD43 ON DCD43.DiagnosisCodeDictionaryID = ED43.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD43 ON ICD43.ICD10DiagnosisCodeDictionaryID = ED43.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED44 ON ED44.EncounterDiagnosisID = EP4.EncounterDiagnosisID4
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD44 ON DCD44.DiagnosisCodeDictionaryID = ED44.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD44 ON ICD44.ICD10DiagnosisCodeDictionaryID = ED44.DiagnosisCodeDictionaryID

LEFT OUTER JOIN dbo.EncounterProcedure EP5 ON EP5.EncounterID = E.EncounterID AND EP5.EncounterProcedureID = (SELECT MIN(EncounterProcedureID) FROM dbo.EncounterProcedure WHERE EncounterID = E.EncounterID AND EncounterPRocedureID NOT IN (EP1.EncounterProcedureID, EP2.EncounterProcedureID, EP3.EncounterProcedureID , EP4.EncounterProcedureID))
LEFT OUTER JOIN dbo.ProcedureCodeDictionary PCD45 ON  PCD45.ProcedureCodeDictionaryID = EP5.ProcedureCodeDictionaryID 
LEFT OUTER JOIN dbo.EncounterDiagnosis ED45 ON ED45.EncounterDiagnosisID = EP5.EncounterDiagnosisID1
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD45 ON DCD45.DiagnosisCodeDictionaryID = ED45.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD45 ON ICD45.ICD10DiagnosisCodeDictionaryID = ED45.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED46 ON ED46.EncounterDiagnosisID = EP5.EncounterDiagnosisID2
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD46 ON DCD46.DiagnosisCodeDictionaryID = ED46.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD46 ON ICD46.ICD10DiagnosisCodeDictionaryID = ED46.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED47 ON ED47.EncounterDiagnosisID = EP5.EncounterDiagnosisID3
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD47 ON DCD47.DiagnosisCodeDictionaryID = ED47.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD47 ON ICD47.ICD10DiagnosisCodeDictionaryID = ED47.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED48 ON ED48.EncounterDiagnosisID = EP5.EncounterDiagnosisID4
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD48 ON DCD48.DiagnosisCodeDictionaryID = ED48.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD48 ON ICD48.ICD10DiagnosisCodeDictionaryID = ED48.DiagnosisCodeDictionaryID

LEFT OUTER JOIN dbo.EncounterProcedure EP6 ON EP6.EncounterID = E.EncounterID AND EP6.EncounterProcedureID = (SELECT MIN(EncounterProcedureID) FROM dbo.EncounterProcedure WHERE EncounterID = E.EncounterID AND EncounterPRocedureID NOT IN (EP1.EncounterProcedureID, EP2.EncounterProcedureID, EP3.EncounterProcedureID , EP4.EncounterProcedureID , EP5.EncounterProcedureID))
LEFT OUTER JOIN dbo.ProcedureCodeDictionary PCD49 ON  PCD49.ProcedureCodeDictionaryID = EP6.ProcedureCodeDictionaryID 
LEFT OUTER JOIN dbo.EncounterDiagnosis ED49 ON ED49.EncounterDiagnosisID = EP6.EncounterDiagnosisID1
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD49 ON DCD49.DiagnosisCodeDictionaryID = ED49.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD49 ON ICD49.ICD10DiagnosisCodeDictionaryID = ED49.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED50 ON ED50.EncounterDiagnosisID = EP6.EncounterDiagnosisID2
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD50 ON DCD50.DiagnosisCodeDictionaryID = ED50.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD50 ON ICD50.ICD10DiagnosisCodeDictionaryID = ED50.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED51 ON ED51.EncounterDiagnosisID = EP6.EncounterDiagnosisID3
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD51 ON DCD51.DiagnosisCodeDictionaryID = ED51.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD51 ON ICD51.ICD10DiagnosisCodeDictionaryID = ED51.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED52 ON ED52.EncounterDiagnosisID = EP6.EncounterDiagnosisID4
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD52 ON DCD52.DiagnosisCodeDictionaryID = ED52.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD52 ON ICD52.ICD10DiagnosisCodeDictionaryID = ED52.DiagnosisCodeDictionaryID

LEFT OUTER JOIN dbo.EncounterProcedure EP7 ON EP7.EncounterID = E.EncounterID AND EP7.EncounterProcedureID = (SELECT MIN(EncounterProcedureID) FROM dbo.EncounterProcedure WHERE EncounterID = E.EncounterID AND EncounterPRocedureID NOT IN (EP1.EncounterProcedureID, EP2.EncounterProcedureID, EP3.EncounterProcedureID , EP4.EncounterProcedureID , EP5.EncounterProcedureID , EP6.EncounterProcedureID))
LEFT OUTER JOIN dbo.ProcedureCodeDictionary PCD53 ON  PCD53.ProcedureCodeDictionaryID = EP7.ProcedureCodeDictionaryID 
LEFT OUTER JOIN dbo.EncounterDiagnosis ED53 ON ED53.EncounterDiagnosisID = EP7.EncounterDiagnosisID1
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD53 ON DCD53.DiagnosisCodeDictionaryID = ED53.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD53 ON ICD53.ICD10DiagnosisCodeDictionaryID = ED53.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED54 ON ED54.EncounterDiagnosisID = EP7.EncounterDiagnosisID2
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD54 ON DCD54.DiagnosisCodeDictionaryID = ED54.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD54 ON ICD54.ICD10DiagnosisCodeDictionaryID = ED54.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED55 ON ED55.EncounterDiagnosisID = EP7.EncounterDiagnosisID3
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD55 ON DCD55.DiagnosisCodeDictionaryID = ED55.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD55 ON ICD55.ICD10DiagnosisCodeDictionaryID = ED55.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED56 ON ED56.EncounterDiagnosisID = EP7.EncounterDiagnosisID4
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD56 ON DCD56.DiagnosisCodeDictionaryID = ED56.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD56 ON ICD56.ICD10DiagnosisCodeDictionaryID = ED56.DiagnosisCodeDictionaryID

LEFT OUTER JOIN dbo.EncounterProcedure EP8 ON EP8.EncounterID = E.EncounterID AND EP8.EncounterProcedureID = (SELECT MIN(EncounterProcedureID) FROM dbo.EncounterProcedure WHERE EncounterID = E.EncounterID AND EncounterPRocedureID NOT IN (EP1.EncounterProcedureID, EP2.EncounterProcedureID, EP3.EncounterProcedureID , EP4.EncounterProcedureID , EP5.EncounterProcedureID , EP6.EncounterProcedureID , EP7.EncounterProcedureID))
LEFT OUTER JOIN dbo.ProcedureCodeDictionary PCD57 ON  PCD57.ProcedureCodeDictionaryID = EP8.ProcedureCodeDictionaryID 
LEFT OUTER JOIN dbo.EncounterDiagnosis ED57 ON ED57.EncounterDiagnosisID = EP8.EncounterDiagnosisID1
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD57 ON DCD57.DiagnosisCodeDictionaryID = ED57.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD57 ON ICD57.ICD10DiagnosisCodeDictionaryID = ED57.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED58 ON ED58.EncounterDiagnosisID = EP8.EncounterDiagnosisID2
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD58 ON DCD58.DiagnosisCodeDictionaryID = ED58.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD58 ON ICD58.ICD10DiagnosisCodeDictionaryID = ED58.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED59 ON ED59.EncounterDiagnosisID = EP8.EncounterDiagnosisID3
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD59 ON DCD59.DiagnosisCodeDictionaryID = ED59.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD59 ON ICD59.ICD10DiagnosisCodeDictionaryID = ED59.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED60 ON ED60.EncounterDiagnosisID = EP8.EncounterDiagnosisID4
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD60 ON DCD60.DiagnosisCodeDictionaryID = ED60.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD60 ON ICD60.ICD10DiagnosisCodeDictionaryID = ED60.DiagnosisCodeDictionaryID

LEFT OUTER JOIN dbo.EncounterProcedure EP9 ON EP9.EncounterID = E.EncounterID AND EP9.EncounterProcedureID = (SELECT MIN(EncounterProcedureID) FROM dbo.EncounterProcedure WHERE EncounterID = E.EncounterID AND EncounterPRocedureID NOT IN (EP1.EncounterProcedureID, EP2.EncounterProcedureID, EP3.EncounterProcedureID , EP4.EncounterProcedureID , EP5.EncounterProcedureID , EP6.EncounterProcedureID , EP7.EncounterProcedureID , EP8.EncounterProcedureID))
LEFT OUTER JOIN dbo.ProcedureCodeDictionary PCD61 ON  PCD61.ProcedureCodeDictionaryID = EP9.ProcedureCodeDictionaryID 
LEFT OUTER JOIN dbo.EncounterDiagnosis ED61 ON ED61.EncounterDiagnosisID = EP9.EncounterDiagnosisID1
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD61 ON DCD61.DiagnosisCodeDictionaryID = ED61.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD61 ON ICD61.ICD10DiagnosisCodeDictionaryID = ED61.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED62 ON ED62.EncounterDiagnosisID = EP9.EncounterDiagnosisID2
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD62 ON DCD62.DiagnosisCodeDictionaryID = ED62.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD62 ON ICD62.ICD10DiagnosisCodeDictionaryID = ED62.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED63 ON ED63.EncounterDiagnosisID = EP9.EncounterDiagnosisID3
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD63 ON DCD63.DiagnosisCodeDictionaryID = ED63.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD63 ON ICD63.ICD10DiagnosisCodeDictionaryID = ED63.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED64 ON ED64.EncounterDiagnosisID = EP9.EncounterDiagnosisID4
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD64 ON DCD64.DiagnosisCodeDictionaryID = ED64.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD64 ON ICD64.ICD10DiagnosisCodeDictionaryID = ED64.DiagnosisCodeDictionaryID

LEFT OUTER JOIN dbo.EncounterProcedure EP10 ON EP10.EncounterID = E.EncounterID AND EP10.EncounterProcedureID = (SELECT MIN(EncounterProcedureID) FROM dbo.EncounterProcedure WHERE EncounterID = E.EncounterID AND EncounterPRocedureID NOT IN (EP1.EncounterProcedureID, EP2.EncounterProcedureID, EP3.EncounterProcedureID , EP4.EncounterProcedureID , EP5.EncounterProcedureID , EP6.EncounterProcedureID , EP7.EncounterProcedureID , EP8.EncounterProcedureID , EP9.EncounterProcedureID))
LEFT OUTER JOIN dbo.ProcedureCodeDictionary PCD65 ON  PCD65.ProcedureCodeDictionaryID = EP10.ProcedureCodeDictionaryID 
LEFT OUTER JOIN dbo.EncounterDiagnosis ED65 ON ED65.EncounterDiagnosisID = EP10.EncounterDiagnosisID1
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD65 ON DCD65.DiagnosisCodeDictionaryID = ED65.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD65 ON ICD65.ICD10DiagnosisCodeDictionaryID = ED65.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED66 ON ED66.EncounterDiagnosisID = EP10.EncounterDiagnosisID2
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD66 ON DCD66.DiagnosisCodeDictionaryID = ED66.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD66 ON ICD66.ICD10DiagnosisCodeDictionaryID = ED66.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED67 ON ED67.EncounterDiagnosisID = EP10.EncounterDiagnosisID3
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD67 ON DCD67.DiagnosisCodeDictionaryID = ED67.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD67 ON ICD67.ICD10DiagnosisCodeDictionaryID = ED67.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED68 ON ED68.EncounterDiagnosisID = EP10.EncounterDiagnosisID4
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD68 ON DCD68.DiagnosisCodeDictionaryID = ED68.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD68 ON ICD68.ICD10DiagnosisCodeDictionaryID = ED68.DiagnosisCodeDictionaryID

LEFT OUTER JOIN dbo.EncounterProcedure EP11 ON EP11.EncounterID = E.EncounterID AND EP11.EncounterProcedureID = (SELECT MIN(EncounterProcedureID) FROM dbo.EncounterProcedure WHERE EncounterID = E.EncounterID AND EncounterPRocedureID NOT IN (EP1.EncounterProcedureID, EP2.EncounterProcedureID, EP3.EncounterProcedureID , EP4.EncounterProcedureID , EP5.EncounterProcedureID , EP6.EncounterProcedureID , EP7.EncounterProcedureID , EP8.EncounterProcedureID , EP9.EncounterProcedureID , EP10.EncounterProcedureID))
LEFT OUTER JOIN dbo.ProcedureCodeDictionary PCD69 ON  PCD69.ProcedureCodeDictionaryID = EP11.ProcedureCodeDictionaryID 
LEFT OUTER JOIN dbo.EncounterDiagnosis ED69 ON ED69.EncounterDiagnosisID = EP11.EncounterDiagnosisID1
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD69 ON DCD69.DiagnosisCodeDictionaryID = ED69.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD69 ON ICD69.ICD10DiagnosisCodeDictionaryID = ED69.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED70 ON ED70.EncounterDiagnosisID = EP11.EncounterDiagnosisID2
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD70 ON DCD70.DiagnosisCodeDictionaryID = ED70.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD70 ON ICD70.ICD10DiagnosisCodeDictionaryID = ED70.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED71 ON ED71.EncounterDiagnosisID = EP11.EncounterDiagnosisID3
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD71 ON DCD71.DiagnosisCodeDictionaryID = ED71.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD71 ON ICD71.ICD10DiagnosisCodeDictionaryID = ED71.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED72 ON ED72.EncounterDiagnosisID = EP11.EncounterDiagnosisID4
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD72 ON DCD72.DiagnosisCodeDictionaryID = ED72.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD72 ON ICD72.ICD10DiagnosisCodeDictionaryID = ED72.DiagnosisCodeDictionaryID

LEFT OUTER JOIN dbo.EncounterProcedure EP12 ON EP12.EncounterID = E.EncounterID AND EP12.EncounterProcedureID = (SELECT MIN(EncounterProcedureID) FROM dbo.EncounterProcedure WHERE EncounterID = E.EncounterID AND EncounterPRocedureID NOT IN (EP1.EncounterProcedureID, EP2.EncounterProcedureID, EP3.EncounterProcedureID , EP4.EncounterProcedureID , EP5.EncounterProcedureID , EP6.EncounterProcedureID , EP7.EncounterProcedureID , EP8.EncounterProcedureID , EP9.EncounterProcedureID , EP10.EncounterProcedureID , EP11.EncounterProcedureID))
LEFT OUTER JOIN dbo.ProcedureCodeDictionary PCD73 ON  PCD73.ProcedureCodeDictionaryID = EP12.ProcedureCodeDictionaryID 
LEFT OUTER JOIN dbo.EncounterDiagnosis ED73 ON ED73.EncounterDiagnosisID = EP12.EncounterDiagnosisID1
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD73 ON DCD73.DiagnosisCodeDictionaryID = ED73.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD73 ON ICD73.ICD10DiagnosisCodeDictionaryID = ED73.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED74 ON ED74.EncounterDiagnosisID = EP12.EncounterDiagnosisID2
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD74 ON DCD74.DiagnosisCodeDictionaryID = ED74.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD74 ON ICD74.ICD10DiagnosisCodeDictionaryID = ED74.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED75 ON ED75.EncounterDiagnosisID = EP12.EncounterDiagnosisID3
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD75 ON DCD75.DiagnosisCodeDictionaryID = ED75.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD75 ON ICD75.ICD10DiagnosisCodeDictionaryID = ED75.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED76 ON ED76.EncounterDiagnosisID = EP12.EncounterDiagnosisID4
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD76 ON DCD76.DiagnosisCodeDictionaryID = ED76.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD76 ON ICD76.ICD10DiagnosisCodeDictionaryID = ED76.DiagnosisCodeDictionaryID

LEFT OUTER JOIN dbo.EncounterProcedure EP13 ON EP13.EncounterID = E.EncounterID AND EP13.EncounterProcedureID = (SELECT MIN(EncounterProcedureID) FROM dbo.EncounterProcedure WHERE EncounterID = E.EncounterID AND EncounterPRocedureID NOT IN (EP1.EncounterProcedureID, EP2.EncounterProcedureID, EP3.EncounterProcedureID , EP4.EncounterProcedureID , EP5.EncounterProcedureID , EP6.EncounterProcedureID , EP7.EncounterProcedureID , EP8.EncounterProcedureID , EP9.EncounterProcedureID , EP10.EncounterProcedureID , EP11.EncounterProcedureID , EP12.EncounterProcedureID))
LEFT OUTER JOIN dbo.ProcedureCodeDictionary PCD77 ON  PCD77.ProcedureCodeDictionaryID = EP13.ProcedureCodeDictionaryID 
LEFT OUTER JOIN dbo.EncounterDiagnosis ED77 ON ED77.EncounterDiagnosisID = EP13.EncounterDiagnosisID1
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD77 ON DCD77.DiagnosisCodeDictionaryID = ED77.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD77 ON ICD77.ICD10DiagnosisCodeDictionaryID = ED77.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED78 ON ED78.EncounterDiagnosisID = EP13.EncounterDiagnosisID2
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD78 ON DCD78.DiagnosisCodeDictionaryID = ED78.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD78 ON ICD78.ICD10DiagnosisCodeDictionaryID = ED78.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED79 ON ED79.EncounterDiagnosisID = EP13.EncounterDiagnosisID3
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD79 ON DCD79.DiagnosisCodeDictionaryID = ED79.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD79 ON ICD79.ICD10DiagnosisCodeDictionaryID = ED79.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED80 ON ED80.EncounterDiagnosisID = EP13.EncounterDiagnosisID4
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD80 ON DCD80.DiagnosisCodeDictionaryID = ED80.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD80 ON ICD80.ICD10DiagnosisCodeDictionaryID = ED80.DiagnosisCodeDictionaryID

LEFT OUTER JOIN dbo.EncounterProcedure EP14 ON EP14.EncounterID = E.EncounterID AND EP14.EncounterProcedureID = (SELECT MIN(EncounterProcedureID) FROM dbo.EncounterProcedure WHERE EncounterID = E.EncounterID AND EncounterPRocedureID NOT IN (EP1.EncounterProcedureID, EP2.EncounterProcedureID, EP3.EncounterProcedureID , EP4.EncounterProcedureID , EP5.EncounterProcedureID , EP6.EncounterProcedureID , EP7.EncounterProcedureID , EP8.EncounterProcedureID , EP9.EncounterProcedureID , EP10.EncounterProcedureID , EP11.EncounterProcedureID , EP12.EncounterProcedureID, EP13.EncounterProcedureID))
LEFT OUTER JOIN dbo.ProcedureCodeDictionary PCD81 ON  PCD81.ProcedureCodeDictionaryID = EP13.ProcedureCodeDictionaryID 
LEFT OUTER JOIN dbo.EncounterDiagnosis ED81 ON ED81.EncounterDiagnosisID = EP14.EncounterDiagnosisID1
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD81 ON DCD81.DiagnosisCodeDictionaryID = ED81.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD81 ON ICD81.ICD10DiagnosisCodeDictionaryID = ED81.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED82 ON ED82.EncounterDiagnosisID = EP14.EncounterDiagnosisID2
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD82 ON DCD82.DiagnosisCodeDictionaryID = ED82.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD82 ON ICD82.ICD10DiagnosisCodeDictionaryID = ED82.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED83 ON ED83.EncounterDiagnosisID = EP14.EncounterDiagnosisID3
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD83 ON DCD83.DiagnosisCodeDictionaryID = ED83.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD83 ON ICD83.ICD10DiagnosisCodeDictionaryID = ED83.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED84 ON ED84.EncounterDiagnosisID = EP14.EncounterDiagnosisID4
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD84 ON DCD84.DiagnosisCodeDictionaryID = ED84.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD84 ON ICD84.ICD10DiagnosisCodeDictionaryID = ED84.DiagnosisCodeDictionaryID

LEFT OUTER JOIN dbo.EncounterProcedure EP15 ON EP15.EncounterID = E.EncounterID AND EP15.EncounterProcedureID = (SELECT MIN(EncounterProcedureID) FROM dbo.EncounterProcedure WHERE EncounterID = E.EncounterID AND EncounterPRocedureID NOT IN (EP1.EncounterProcedureID, EP2.EncounterProcedureID, EP3.EncounterProcedureID , EP4.EncounterProcedureID , EP5.EncounterProcedureID , EP6.EncounterProcedureID , EP7.EncounterProcedureID , EP8.EncounterProcedureID , EP9.EncounterProcedureID , EP10.EncounterProcedureID , EP11.EncounterProcedureID , EP12.EncounterProcedureID, EP13.EncounterProcedureID, EP14.EncounterProcedureID))
LEFT OUTER JOIN dbo.ProcedureCodeDictionary PCD85 ON  PCD85.ProcedureCodeDictionaryID = EP15.ProcedureCodeDictionaryID 
LEFT OUTER JOIN dbo.EncounterDiagnosis ED85 ON ED85.EncounterDiagnosisID = EP15.EncounterDiagnosisID1
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD85 ON DCD85.DiagnosisCodeDictionaryID = ED85.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD85 ON ICD85.ICD10DiagnosisCodeDictionaryID = ED85.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED86 ON ED86.EncounterDiagnosisID = EP15.EncounterDiagnosisID2
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD86 ON DCD86.DiagnosisCodeDictionaryID = ED86.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD86 ON ICD86.ICD10DiagnosisCodeDictionaryID = ED86.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED87 ON ED87.EncounterDiagnosisID = EP15.EncounterDiagnosisID3
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD87 ON DCD87.DiagnosisCodeDictionaryID = ED87.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD87 ON ICD87.ICD10DiagnosisCodeDictionaryID = ED87.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.EncounterDiagnosis ED88 ON ED88.EncounterDiagnosisID = EP15.EncounterDiagnosisID4
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD88 ON DCD88.DiagnosisCodeDictionaryID = ED88.DiagnosisCodeDictionaryID
LEFT OUTER JOIN dbo.ICD10DiagnosisCodeDictionary ICD88 ON ICD88.ICD10DiagnosisCodeDictionaryID = ED88.DiagnosisCodeDictionaryID

LEFT OUTER JOIN dbo.Doctor rp ON rp.DoctorID = E.DoctorID
WHERE E.Encounterid IS NOT NULL 
ORDER BY e.DateOfService ASC
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--ROLLBACK
--COMMIT