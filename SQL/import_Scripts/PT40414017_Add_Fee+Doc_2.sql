USE superbill_12741_dev 
--USE superbill_12741_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 2
SET @VendorImportID = 2 -- Vendor import record created through import tool

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

DELETE FROM dbo.ContractFeeSchedule WHERE ContractID IN (SELECT ContractID FROM 
	dbo.[Contract] WHERE CAST([Description] AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR))
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' ContractFeeSchedule records deleted'
DELETE FROM dbo.[Contract] WHERE CAST([Description] AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR)
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Contract records deleted'
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'
	
	
-- Contract for fee schedule
PRINT ''
PRINT 'Inserting records into Contract (Standard)...'
	INSERT INTO dbo.[Contract] (
		PracticeID,
		CreatedDate,
		CreatedUserID,
		ModifiedDate,
		ModifiedUserID,
		ContractName,
		[Description],
		ContractType,
		NoResponseTriggerPaper,
		NoResponseTriggerElectronic,
		Notes,
		Capitated,
		AnesthesiaTimeIncrement,
		EffectiveStartDate,
		EffectiveEndDate,
		PolicyValidator
	)
	VALUES 
	(
		@PracticeID
		,GETDATE()
		,0
		,GETDATE()
		,0
		,'Default contract'
		,'Vendor Import ' + CAST(@VendorImportID AS VARCHAR)
		,'S'
		,45
		,45
		,CAST(@VendorImportID AS VARCHAR)
		,0
		,15
		,GETDATE()
		,DATEADD(dd, 1, DATEADD(yy, 1, GETDATE()))
		,'NULL'
	)

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Contract Fee Schedule
PRINT ''
PRINT 'Inserting records into ContractFeeSchedule (Standard)...'
	INSERT INTO dbo.ContractFeeSchedule (
		CreatedDate,
		CreatedUserID,
		ModifiedDate,
		ModifiedUserID,
		ContractID,
		Gender,
		StandardFee,
		Allowable,
		ExpectedReimbursement,
		RVU,
		ProcedureCodeDictionaryID,
		PracticeRVU,
		MalpracticeRVU,
		BaseUnits
	)
	SELECT
		GETDATE()
		,0
		,GETDATE()
		,0
		,c.ContractID
		,'B'
		,[amount]
		,0
		,0
		,0
		,pcd.ProcedureCodeDictionaryID
		,0
		,0
		,0
	FROM dbo.[_import_2_2_ProcedureCodeFeeMaint] impFS
	INNER JOIN dbo.[Contract] c ON 
		CAST(c.Notes AS VARCHAR) = CAST(@VendorImportID AS VARCHAR) AND
		c.PracticeID = @PracticeID
	INNER JOIN dbo.ProcedureCodeDictionary pcd ON LEFT(impFS.[chargecodeanddescription], 5) = pcd.ProcedureCode
	WHERE
		CAST([amount] AS MONEY) > 0

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


--Referring Doctor
PRINT ''
PRINT 'Inserting records into Doctor ...'
INSERT INTO dbo.Doctor
        ( PracticeID ,
          Prefix ,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix ,
          ActiveDoctor ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          ZipCode ,
          WorkPhone ,
          FaxNumber ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          VendorID ,
          VendorImportID ,
          [External] 
        )
SELECT    @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          ref.Doctor_Fname , -- FirstName - varchar(64)
          ref.Doctor_Mname , -- MiddleName - varchar(64)
          ref.Doctor_Lname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          1 , -- ActiveDoctor - bit
          ref.address1 ,
          ref.address2 ,
          ref.city ,
          ref.[STATE] ,
          LEFT(ref.zipcode, 9) ,
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(ref.officephone, '(', ''), ')',''), '-',''), ' ', ''), 10) ,
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(ref.faxno, '(', ''), ')',''), '-',''), ' ', ''), 10) ,
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          ref.[code] , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1  -- External - bit
FROM dbo.[_import_2_2_ReferringProviders] ref
        
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

COMMIT 