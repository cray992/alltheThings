USE superbill_5075_dev
-- USE superbill_5075_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @SourceContractID INT

SET @PracticeID = 4 -- Anesthesia Associates of Clay County
SET @SourceContractID = 15 -- Sample contract to copy all fees from

-- Clean up first
PRINT 'Removing existing data for import contracts'
DELETE FROM dbo.ContractToDoctor WHERE ContractID IN (SELECT ContractID FROM _ImportFeeSchedules)
DELETE FROM dbo.ContractFeeSchedule WHERE ContractID IN (SELECT ContractID FROM _ImportFeeSchedules)
DELETE FROM dbo.ContractToServiceLocation WHERE ContractID IN (SELECT ContractID FROM _ImportFeeSchedules)
PRINT ''

-- FOR EACH CONTRACT DO LOTS OF STUFF
DECLARE @ContractID INT
DECLARE cr CURSOR FORWARD_ONLY FAST_FORWARD READ_ONLY
FOR SELECT ContractID FROM dbo.[_ImportFeeSchedules]
	 
OPEN cr
FETCH NEXT FROM cr INTO @ContractID
WHILE @@fetch_status = 0
BEGIN
	-- Contract information
	INSERT INTO dbo.ContractFeeSchedule ( 
		CreatedDate ,
		CreatedUserID ,
		ModifiedDate ,
		ModifiedUserID ,
		ContractID ,
		Modifier ,
		Gender ,
		StandardFee ,
		Allowable ,
		ExpectedReimbursement ,
		RVU ,
		ProcedureCodeDictionaryID ,
		DiagnosisCodeDictionaryID ,
		PracticeRVU ,
		MalpracticeRVU ,
		BaseUnits
	)
	SELECT  
		GETDATE(), -- CreatedDate - datetime
		0, -- CreatedUserID - int
		GETDATE(), -- ModifiedDate - datetime
		0 , -- ModifiedUserID - int
		@ContractID, -- ContractID - int
		cfs.Modifier , -- Modifier - varchar(16)
		cfs.Gender , -- Gender - char(1)
		impIFS.[STANDARD FEE] , -- StandardFee - money
		impIFS.[ALLOWED AMT] , -- Allowable - money
		cfs.ExpectedReimbursement, -- ExpectedReimbursement - money
		cfs.RVU, -- RVU - decimal
		cfs.ProcedureCodeDictionaryID, -- ProcedureCodeDictionaryID - int
		cfs.DiagnosisCodeDictionaryID, -- DiagnosisCodeDictionaryID - int
		cfs.PracticeRVU, -- PracticeRVU - decimal
		cfs.MalpracticeRVU, -- MalpracticeRVU - decimal
		cfs.BaseUnits  -- BaseUnits - int
	FROM 
		dbo.ContractFeeSchedule cfs
	INNER JOIN dbo.[_ImportFeeSchedules] impIFS ON impIFS.ContractID = @ContractID -- Import Contract of current iteration
	WHERE
		cfs.ContractID = @SourceContractID -- A sample contract to copy from
	
	PRINT 'Created ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' fee schedules for contract ' + CAST(@ContractID AS VARCHAR(10))
	
	
	-- Doctors
	INSERT INTO dbo.ContractToDoctor ( 
		CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID ,
		ContractID ,
		DoctorID
    )
	SELECT 
		GETDATE(), 0, GETDATE(), 0,
		@ContractID,
		DoctorID
	FROM dbo.Doctor
	WHERE PracticeID = @PracticeID AND [External] = 0
	
	PRINT 'Created ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' doctors for contract ' + CAST(@ContractID AS VARCHAR(10))
	
	
	-- Service locations
	INSERT INTO dbo.ContractToServiceLocation (
		CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID ,
		ContractID ,
		ServiceLocationID
    )
	SELECT 
		GETDATE(), 0, GETDATE(), 0,
		@ContractID,
		ServiceLocationID
	FROM dbo.ServiceLocation
	WHERE PracticeID = @PracticeID
	
	PRINT 'Created ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' service locations ' + CAST(@ContractID AS VARCHAR(10))
	
	PRINT ''

	FETCH NEXT FROM cr INTO @ContractID
END
CLOSE cr
DEALLOCATE cr






	
	
	
	
COMMIT TRAN