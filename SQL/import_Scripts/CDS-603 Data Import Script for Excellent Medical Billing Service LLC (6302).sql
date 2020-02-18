USE superbill_6302_dev
--USE superbill_6302_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT
DECLARE @NewVendorImportID INT

SET @PracticeID = 8
SET @VendorImportID = 3
SET @NewVendorImportID = 4

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR) 
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR)

PRINT ''
PRINT 'Updating Patients With VendorID...'
UPDATE dbo.Patient SET VendorID = i.chartnumber
FROM dbo.Patient p
INNER JOIN dbo.[_import_4_8_Auths] i ON 
	p.FirstName = i.firstname AND 
	p.LastName = i.lastname AND 
	p.DOB = DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME))
WHERE p.VendorID IS NULL AND p.PracticeID = @PracticeID AND i.creditforward <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Inserting Into Authorizations 1...'
INSERT INTO dbo.InsurancePolicyAuthorization
        ( InsurancePolicyID ,
          AuthorizationNumber ,
          AuthorizedNumberOfVisits ,
          StartDate ,
          EndDate ,
          ContactFullname ,
          ContactPhone ,
          ContactPhoneExt ,
          AuthorizationStatusID ,
          Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          AuthorizedNumberOfVisitsUsed ,
          VendorID ,
          VendorImportID
        )
SELECT DISTINCT		
		  ip.InsurancePolicyID , -- InsurancePolicyID - int
          i.authnumber1 , -- AuthorizationNumber - varchar(65)
          i.authnumberofvisits1 , -- AuthorizedNumberOfVisits - int
          CASE WHEN ISDATE(i.authstartdate1) = 1 THEN i.authstartdate1 ELSE NULL END , -- StartDate - datetime
          CASE WHEN ISDATE(i.authenddate1) = 1 THEN i.authenddate1 ELSE NULL END , -- EndDate - datetime
          i.authcontactfullname1 , -- ContactFullname - varchar(65)
          i.authcontactphone1 , -- ContactPhone - varchar(10)
          i.authcontactphoneext1 , -- ContactPhoneExt - varchar(10)
          1 , -- AuthorizationStatusID - int
          i.authnotes1 , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.authnumberofvisitsused1 , -- AuthorizedNumberOfVisitsUsed - int
          ip.vendorid , -- VendorID - varchar(50)
          @NewVendorImportID  -- VendorImportID - int
FROM dbo.[_import_4_8_Auths] i
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		icp.VendorID = i.insurancecode1 AND 
		icp.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsurancePolicy ip ON
		ip.InsuranceCompanyPlanID = icp.InsuranceCompanyPlanID AND
        ip.PracticeID = @PracticeID AND
        ip.VendorImportID = @VendorImportID
	INNER JOIN dbo.PatientCase pc ON
		ip.PatientCaseID = pc.PatientCaseID AND 
		pc.VendorImportID = @VendorImportID 
	INNER JOIN dbo.Patient p ON 
		pc.PatientID = p.PatientID AND 
		p.VendorID = i.chartnumber 
WHERE i.authnumber1 <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Authorizations 2...'
INSERT INTO dbo.InsurancePolicyAuthorization
        ( InsurancePolicyID ,
          AuthorizationNumber ,
          AuthorizedNumberOfVisits ,
          StartDate ,
          EndDate ,
          ContactFullname ,
          ContactPhone ,
          ContactPhoneExt ,
          AuthorizationStatusID ,
          Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          AuthorizedNumberOfVisitsUsed ,
          VendorID ,
          VendorImportID
        )
SELECT DISTINCT		
		  ip.InsurancePolicyID , -- InsurancePolicyID - int
          i.authnumber2 , -- AuthorizationNumber - varchar(65)
          i.authnumberofvisits2 , -- AuthorizedNumberOfVisits - int
          CASE WHEN ISDATE(i.authstartdate2) = 2 THEN i.authstartdate2 ELSE NULL END , -- StartDate - datetime
          CASE WHEN ISDATE(i.authenddate2) = 2 THEN i.authenddate2 ELSE NULL END , -- EndDate - datetime
          i.authcontactfullname2 , -- ContactFullname - varchar(65)
          i.authcontactphone2 , -- ContactPhone - varchar(20)
          i.authcontactphoneext2 , -- ContactPhoneExt - varchar(20)
          2 , -- AuthorizationStatusID - int
          i.authnotes2 , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.authnumberofvisitsused2 , -- AuthorizedNumberOfVisitsUsed - int
          ip.vendorid , -- VendorID - varchar(50)
          @NewVendorImportID  -- VendorImportID - int
FROM dbo.[_import_4_8_Auths] i
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		icp.VendorID = i.insurancecode2 AND 
		icp.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsurancePolicy ip ON
		ip.InsuranceCompanyPlanID = icp.InsuranceCompanyPlanID AND
        ip.PracticeID = @PracticeID AND
        ip.Precedence = 2 AND
        ip.VendorImportID = @VendorImportID
	INNER JOIN dbo.PatientCase pc ON
		ip.PatientCaseID = pc.PatientCaseID AND 
		pc.PracticeID = @PracticeID
	INNER JOIN dbo.Patient p ON 
		pc.PatientID = p.PatientID AND 
		p.VendorID = i.chartnumber 
WHERE i.insurancecode2 <> '' AND i.authnumber2 <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

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
          i.creditforward , -- PaymentAmount - money
          'C' , -- PaymentMethodCode - char(1)
          'P' , -- PayerTypeCode - char(1)
          p.PatientID , -- PayerID - int
          NULL , -- PaymentNumber - varchar(30)
          'Patient Credit Forward Payment. Please verify before use.' , -- Description - varchar(250)
          GETDATE() , -- CreatedDate - datetime
          GETDATE() , -- ModifiedDate - datetime
          NULL , -- SourceEncounterID - int
          GETDATE() , -- PostingDate - datetime
          0 , -- PaymentTypeID - int
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
FROM dbo.[_import_4_8_Auths] i	
INNER JOIN dbo.Patient p ON
	i.chartnumber = p.VendorID AND 
	p.PracticeID = @PracticeID
WHERE i.creditforward <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Payment Patient...'
INSERT INTO dbo.PaymentPatient
        ( PaymentID, PatientID, PracticeID )
SELECT DISTINCT
		  pay.PaymentID, -- PaymentID - int
          p.PatientID, -- PatientID - int
          @PracticeID  -- PracticeID - int
FROM dbo.Patient p 
INNER JOIN dbo.Payment pay ON
	p.PatientID = pay.PayerID AND
	pay.PracticeID = @PracticeID
WHERE pay.CreatedDate > DATEADD(mi,-1,GETDATE()) AND pay.PayerTypeCode = 'P' AND pay.BatchID = 'CreditFwd'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Unapplied Payments...'
INSERT INTO dbo.UnappliedPayments
        ( PracticeID, PaymentID )
SELECT DISTINCT
		  @PracticeID, -- PracticeID - int
          pay.PaymentID  -- PaymentID - int
FROM dbo.Payment pay
WHERE pay.CreatedDate > DATEADD(mi,-1,GETDATE()) AND pay.PayerTypeCode = 'P' AND pay.BatchID = 'CreditFwd'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	



--COMMIT
--ROLLBACK

