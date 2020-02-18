USE superbill_5075_dev
-- USE superbill_5075_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @SourceContractID INT
DECLARE @SourceBaseUnits TABLE
(
	CPTCodeID INT NOT NULL,
	Units INT NOT NULL
)

SET @PracticeID = 3 -- ANESTHESIA CONSULTANTS PA
SET @SourceContractID = 4 -- Sample contract to copy all fees from (AETNA)

INSERT INTO @SourceBaseUnits SELECT ProcedureCodeDictionaryID, BaseUnits FROM dbo.ContractFeeSchedule WHERE ContractID = @SourceContractID

-- FOR EACH CONTRACT DO LOTS OF STUFF
DECLARE @ContractID INT
DECLARE cr CURSOR FORWARD_ONLY FAST_FORWARD READ_ONLY
FOR SELECT ContractID FROM dbo.Contract WHERE ContractID IN (65,66,67)
	 
OPEN cr
FETCH NEXT FROM cr INTO @ContractID
WHILE @@fetch_status = 0
BEGIN
	-- Contract information
	UPDATE
		ContractFeeSchedule
	SET 
		ContractFeeSchedule.BaseUnits = [@SourceBaseUnits].Units
	FROM 
		@SourceBaseUnits
	WHERE
		ContractFeeSchedule.ContractID = @ContractID AND
		ContractFeeSchedule.ProcedureCodeDictionaryID = [@SourceBaseUnits].CPTCodeID
		
	
	PRINT 'Updated ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' fee schedules for contract ' + CAST(@ContractID AS VARCHAR(10))
	
		
	PRINT ''

	FETCH NEXT FROM cr INTO @ContractID
END
CLOSE cr
DEALLOCATE cr


COMMIT TRAN