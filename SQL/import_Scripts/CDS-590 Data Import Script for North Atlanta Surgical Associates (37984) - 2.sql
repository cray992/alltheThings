USE superbill_37984_dev
--USE superbill_39969_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 1

SET NOCOUNT ON 

/*
DELETE FROM dbo.UnappliedPayments WHERE PaymentID IN (SELECT PaymentID FROM dbo.Payment WHERE BatchID = 'CreditFwd')
DELETE FROM dbo.PaymentPatient WHERE PaymentID IN (SELECT PaymentID FROM dbo.Payment WHERE BatchID = 'CreditFwd')
DELETE FROM dbo.Payment WHERE BatchID = 'CreditFwd'
*/

PRINT ''
PRINT 'Inserting Into Temp Table...'
CREATE TABLE #temppatient
(GuarantorID VARCHAR(25) , VendorID VARCHAR(25))

INSERT INTO #temppatient
        ( GuarantorID, VendorID )
SELECT DISTINCT
		  i.guarantorlegacyaccountnumber, -- GuarantorID - int
          i.patientlegacyaccountnumber  -- VendorID - int
FROM dbo.[_import_4_1_patient] i
INNER JOIN dbo.Patient p ON 
	i.patientlegacyaccountnumber = p.VendorID AND
    p.PracticeID = @PracticeID
INNER JOIN dbo.[_import_1_1_Sheet1] u ON
	u.guarantor = i.guarantorlegacyaccountnumber
WHERE CONVERT(DATETIME,i.ptlastdateofservice) > '2011-01-01 00:00:000' 
PRINT CAST (@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Temp Table...'
INSERT INTO #temppatient
        ( GuarantorID, VendorID )
SELECT DISTINCT
		  i.guarantorlegacyaccountnumber, -- GuarantorID - int
          i.patientlegacyaccountnumber  -- VendorID - int
FROM dbo.[_import_5_1_Patient2] i
INNER JOIN dbo.Patient p ON 
	i.patientlegacyaccountnumber = p.VendorID AND
    p.PracticeID = @PracticeID
INNER JOIN dbo.[_import_1_1_Sheet1] u ON
	u.guarantor = i.guarantorlegacyaccountnumber
WHERE CONVERT(DATETIME,i.ptlastdateofservice) > '2011-01-01 00:00:000' 
PRINT CAST (@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Payment...'
INSERT INTO dbo.Payment
        ( PracticeID ,
          PaymentAmount ,
          PaymentMethodCode ,
          PayerTypeCode ,
          PayerID ,
          PaymentNumber ,
          Description ,
          CreatedDate ,
          ModifiedDate ,
          SourceEncounterID ,
          PostingDate ,
          PaymentTypeID ,
          DefaultAdjustmentCode ,
          BatchID ,
          CreatedUserID ,
          ModifiedUserID ,
          SourceAppointmentID ,
          EOBEditable ,
          AdjudicationDate ,
          ClearinghouseResponseID ,
          ERAErrors ,
          AppointmentID ,
          AppointmentStartDate ,
          PaymentCategoryID ,
          overrideClosingDate ,
          IsOnline
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          u.totaluc , -- PaymentAmount - money
          'U' , -- PaymentMethodCode - char(1)
          'P'  , -- PayerTypeCode - char(1)
          pat.PatientID , -- PayerID - int
          NULL , -- PaymentNumber - varchar(30)
          CASE WHEN icp.InsuranceCompanyPlanID IS NOT NULL THEN 'Insurance Plan Name: ' + icp.PlanName + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) 
			   WHEN icp.InsuranceCompanyID IS NULL AND u.insvendorid <> '' THEN 'Warning. Unable to locate the following Insurance Plan: ' + u.insname
		  ELSE 'Patient Credit Forward Payment' END , -- Description - varchar(250)
          GETDATE() , -- CreatedDate - datetime
          GETDATE() , -- ModifiedDate - datetime
          NULL , -- SourceEncounterID - int
          GETDATE(), -- PostingDate - datetime
		  0  , -- PaymentTypeID - int
          NULL , -- DefaultAdjustmentCode - varchar(10)
          'CreditFwd' , -- BatchID - varchar(50)
          0 , -- CreatedUserID - int
          0 , -- ModifiedUserID - int
          NULL , -- SourceAppointmentID - int
          1 , -- EOBEditable - bit
          NULL , -- AdjudicationDate - datetime
          NULL , -- ClearinghouseResponseID - int
          NULL , -- ERAErrors - xml
          NULL , -- AppointmentID - int
          NULL , -- AppointmentStartDate - datetime
          NULL , -- PaymentCategoryID - int
          0 , -- overrideClosingDate - bit
          0  -- IsOnline - bit
FROM dbo.[_import_1_1_Sheet1] u
INNER JOIN #temppatient temp ON
	temp.GuarantorID = u.guarantor
INNER JOIN dbo.Patient pat ON 
	temp.VendorID = pat.VendorID
LEFT JOIN dbo.InsuranceCompanyPlan icp ON
	u.insvendorid = icp.VendorID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Payment Patient...'
INSERT INTO dbo.PaymentPatient
        ( PaymentID, PatientID, PracticeID )
SELECT 
		  pay.PaymentID, -- PaymentID - int
          p.PatientID, -- PatientID - int
          @PracticeID  -- PracticeID - int
FROM dbo.Patient p 
INNER JOIN dbo.Payment pay ON
	p.PatientID = pay.PayerID AND
	pay.PracticeID = @PracticeID
WHERE pay.CreatedDate > DATEADD(mi,-1,GETDATE()) AND pay.BatchID = 'CreditFwd' AND pay.PayerTypeCode = 'P' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Unapplied Payments...'
INSERT INTO dbo.UnappliedPayments
        ( PracticeID, PaymentID )
SELECT 
		  @PracticeID, -- PracticeID - int
          pay.PaymentID  -- PaymentID - int
FROM dbo.Payment pay
WHERE pay.CreatedDate > DATEADD(mi,-1,GETDATE())  AND pay.BatchID = 'CreditFwd'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

DROP TABLE #temppatient


--ROLLBACK
--COMMIT


