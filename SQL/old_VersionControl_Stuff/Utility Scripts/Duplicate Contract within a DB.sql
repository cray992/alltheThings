-- 
-- This script is used to duplicate a contract. Upon duplication, we can specify
-- a new practice, effective date range and contract name. 
--
-- In addition, some basic business rules are enforce such as a single contract
-- for a practice given date range.
-- 
-- To use this script, we must specify a given set of parameters:
--	Madatory Parameters
--		@SourcePractice  is the practice ID to be duplicated
--		@SourceContractID is the Contract ID to be duplicated
--
--	Optional Parameters (1 or more must be proivded). If left blank, the value of the orginal contract will be used
--		@TargetPractice is the practice that the new contract will be assgin to
--		@TargetContractName is the name that the contract is used
--		@TargetEffectiveStartDate is the Start date the new contract will use
--		@TargetEffectiveEndDate is the new End Date the new contract will use



----------------------------------
-- Addes the VendorID column if it doesn't already exist ----
IF not exists( select Object_Name(id), * from sys.syscolumns where id = Object_ID('contract') and name = 'VendorID' )
	ALTER TABLE [CONTRACT] ADD VendorID varchar(50)

IF not exists( select Object_Name(id), * from sys.syscolumns where id = Object_ID('contract') and name = 'VendorImportID' )
	ALTER TABLE [CONTRACT] ADD VendorImportID INT
GO
----------------------------------


DECLARE 
	@SourcePractice INT,
	@SourceContractID INT,
	@TargetPractice INT,
	@TargetContractName VARCHAR(128),
	@TargetEffectiveStartDate Datetime,
	@TargetEffectiveEndDate Datetime,
	@ImportSessionNotes VARCHAR(128)

-- MUST FILL IN THE PARAMETERS USE "NULL" WHEN YOU WANT TO USE THE DEFAULT VALUES -----


SET	@SourcePractice = 1					-- Practice ID of Source	(Mandatory)
SET	@SourceContractID =	3					-- Contract ID of Source	(Mandatory)

SET	@TargetPractice = 2					-- Practice ID of Destination	(Optional)
SET	@TargetContractName = NULL				-- New Name of Contract			(Optional)

SET	@TargetEffectiveStartDate =	NULL		-- New Begin Range				(Optional)
SET	@TargetEffectiveEndDate =	NULL		-- New End Date					(Optionsl)

-- Notes tobe written to the VendorImport table to describe this session.
SET @ImportSessionNotes = 'Case 12682' + 'date: ' + convert( varchar, getdate() ) 

------------------ Example ---------------------
--	SET @SourcePractice = 2					
--	SET @SourceContractID = 24					
--	SET @TargetPractice = 1
--	SET @TargetContractName = 'phongs contract'
--	SET @TargetEffectiveStartDate = '1/1/08'
--	SET @TargetEffectiveEndDate = '12/31/08'
------------------------------------------------

DECLARE 
	@VendorImportID INT,
	@ErrorMsg1 Varchar(200),
	@ErrorMsg2 Varchar(200),
	@ErrorMsg3 Varchar(200)


SELECT 
	@ErrorMsg1 = 'Can not copy. Source and target are identical. Business rule: Effective start & end date are unique for each location and practice',
	@ErrorMsg2 = 'Can not copy. BOTH the Start Date or Effective date needs to be provided. Otherwise, leave as NULL and system will assign based on existing contract',
	@ErrorMsg3 = 'Con not copy. Source Contract does not exist'
--------------------------------------------
--- Begin Parameter Checking ---------------------
IF	@SourcePractice = @TargetPractice AND
	@TargetEffectiveStartDate IS NULL AND 
	@TargetEffectiveEndDate IS NULL 
	BEGIN
		PRINT @ErrorMsg1
		RETURN
	END

IF ( @TargetEffectiveStartDate IS NULL OR @TargetEffectiveEndDate IS NULL) 
		AND not ( @TargetEffectiveStartDate IS NULL and @TargetEffectiveEndDate IS NULL)
	BEGIN
		PRINT @ErrorMsg2
		RETURN
	END

--- End Parameter Checking ---------------------
----------------------------------------------


SELECT 
	ContractID,
	insC.PracticeID,
	getdate() as CreatedDate,
	insC.CreatedUserID,
	getdate() as ModifiedDate,
	insC.ModifiedUserID,
	insC.ContractName,
	insC.Description,
	insC.ContractType,
	insC.EffectiveStartDate,
	insC.EffectiveEndDate,
	insC.PolicyValidator,
	insC.NoResponseTriggerPaper,
	insC.NoResponseTriggerElectronic,
	insC.Notes,
	insC.Capitated
INTO #InsContract 
FROM [CONTRACT] insC
WHERE PracticeID = @SourcePractice
	and ContractID = @SourceContractID


IF @@rowcount = 0
	BEGIN
		PRINT @ErrorMsg3
		RETURN
	END





-----------------------------------------------
-- Business rule validation -------------------


SELECT 
	@TargetPractice = isnull(@TargetPractice, PracticeID),
	@TargetContractName = isnull(@TargetContractName, ContractName ),
	@TargetEffectiveStartDate = isnull( @TargetEffectiveStartDate, EffectiveStartDate ),
	@TargetEffectiveEndDate = isnull( @TargetEffectiveEndDate, EffectiveEndDate)
from  #InsContract


-- if the effective date overlaps, the system will try to provide a valid effective Date
IF	exists( select * from [Contract] WHERE PracticeID = @TargetPractice AND (@TargetEffectiveStartDate <= EffectiveEndDate AND @TargetEffectiveEndDate >=  EffectiveStartDate))
BEGIN
			SELECT	@TargetEffectiveStartDate = DATEADD( d, 1, dbo.fn_DateOnly( max(EffectiveEndDate)) ),
					@TargetEffectiveEndDate = DATEADD( d, 1, dbo.fn_DateOnly( max(EffectiveEndDate)) )
			from  [Contract]
			WHERE PracticeID = @TargetPractice
END



IF	exists( select * from [Contract] WHERE PracticeID = @TargetPractice AND (@TargetEffectiveStartDate <= EffectiveEndDate AND @TargetEffectiveEndDate >=  EffectiveStartDate))
	BEGIN
		PRINT @ErrorMsg1

			SELECT	PracticeID, ContractName, ContractID,
				@TargetEffectiveStartDate as TargetStartDate, EffectiveStartDate,
				@TargetEffectiveEndDate as TargetEndDate,  EffectiveEndDate
			from [Contract] 
			WHERE PracticeID = @TargetPractice AND @TargetEffectiveStartDate <= EffectiveEndDate 
				AND @TargetEffectiveEndDate >=  EffectiveStartDate
		RETURN

	END

select *
from #InsContract




Begin tran MyTran

Begin Try


	DECLARE @ptrval binary(16),
			@ContractDescription Varchar(128)
	SELECT @ptrval = TEXTPTR(description) ,
			@ContractDescription = 'Duplicate contract: ' + ContractName + ' on ' + convert( varchar, getdate(), 1) + '; ' 
	   FROM #InsContract c
		WHERE description IS NOT NULL

	IF @ptrval IS NOT NULL
		BEGIN
		UPDATETEXT #InsContract.description @ptrval 0 0 @ContractDescription
		END
	ELSE 
		BEGIN
		-- Update the description
		UPDATE #InsContract
		SET description = 'Duplicate contract: ' + ContractName + ' on ' + convert( varchar, getdate(), 1) + '; ' 
		END
		
	





	INSERT INTO VendorImport(VendorName, DateCreated, Notes, VendorFormat)
	VALUES('Duplicate Contract',GETDATE(),@ImportSessionNotes,'KAREO')
	SET @VendorImportID=@@IDENTITY	

	-- importID
	select @VendorImportID


	INSERT CONTRACT (
		VendorID,
		VendorImportID,
		PracticeID,
		CreatedDate,
		CreatedUserID,
		ModifiedDate,
		ModifiedUserID,
		ContractName,
		Description,
		ContractType,
		EffectiveStartDate,
		EffectiveEndDate,
		PolicyValidator,
		NoResponseTriggerPaper,
		NoResponseTriggerElectronic,
		Notes,
		Capitated
		)
	SELECT 
		ContractID,
		@VendorImportID,
		ISNULL(@TargetPractice,insC.PracticeID),
		getdate(),
		insC.CreatedUserID,
		getdate(),
		insC.ModifiedUserID,
		@TargetContractName,
		insC.Description,
		insC.ContractType,
		@TargetEffectiveStartDate,
		@TargetEffectiveEndDate,
		insC.PolicyValidator,
		insC.NoResponseTriggerPaper,
		insC.NoResponseTriggerElectronic,
		insC.Notes,
		insC.Capitated
	FROM #InsContract insC

	INSERT ContractFeeSchedule (
		CreatedDate,
		CreatedUserID,
		ModifiedDate,
		ModifiedUserID,
		ContractID,
		Modifier,
		Gender,
		StandardFee,
		Allowable,
		ExpectedReimbursement,
		RVU,
		ProcedureCodeDictionaryID,
		DiagnosisCodeDictionaryID
		)
	SELECT 
		getdate(),
		cfs.CreatedUserID,
		getdate(),
		cfs.ModifiedUserID,
		c.ContractID,
		cfs.Modifier,
		cfs.Gender,
		cfs.StandardFee,
		cfs.Allowable,
		cfs.ExpectedReimbursement,
		cfs.RVU,
		cfs.ProcedureCodeDictionaryID,
		cfs.DiagnosisCodeDictionaryID
	FROM ContractFeeSchedule as cfs inner join
		[Contract] as c on c.VendorID = cfs.ContractID
	WHERE c.VendorImportID = @VendorImportID

	IF @TargetPractice IS NOT NULL AND @SourcePractice<>@TargetPractice
	BEGIN
		INSERT ContracttoServiceLocation (
			CreatedDate,
			CreatedUserID,
			ModifiedDate,
			ModifiedUserID,
			ContractID,
			ServiceLocationID
			)
		SELECT
			getdate(),
			loc.CreatedUserID,
			getdate(),
			loc.ModifiedUserID,
			c.ContractID,
			loc.ServiceLocationID
		FROM ContracttoServiceLocation loc INNER JOIN
			[Contract] c on c.VendorID = loc.ContractID
		WHERE c.VendorImportID = @VendorImportID
	END

	INSERT  ContractToInsurancePlan(CreatedDate, CreatedUserID, ModifiedDate, ModifiedUserID,
									ContractID, PlanID)
	SELECT GETDATE(), CIP.CreatedUserID, GETDATE(), CIP.ModifiedUserID, C.ContractID, CIP.PlanID
	FROM ContractToInsurancePlan CIP INNER JOIN [Contract] C ON CIP.ContractID=C.VendorID
	WHERE C.VendorImportID=@VendorImportID


	commit Tran MyTran
END TRY

BEGIN CATCH
	PRINT 'rolling back. Error log....'
    SELECT
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_SEVERITY() AS ErrorSeverity,
        ERROR_STATE() AS ErrorState,
        ERROR_PROCEDURE() AS ErrorProcedure,
        ERROR_LINE() AS ErrorLine,
        ERROR_MESSAGE() AS ErrorMessage;

	Rollback Tran MyTran
END CATCH


	Drop table #InsContract


go

