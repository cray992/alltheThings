-- Execute agaist TARGET database

DECLARE
	@SourceCustomerID INT,
	@TargetCustomerID INT,
	@TargetDatabaseName VARCHAR(MAX),
	@PracticeID INT,
	
	@SQL VARCHAR(MAX),
	@EXSQL VARCHAR(MAX)


SET @SourceCustomerID=xxx
SET @TargetCustomerID=xxx
SET @TargetDatabaseName='SUPERBILL_xxx_PROD'
SET @PracticeID=x

SET @SQL = 
	'INSERT INTO [SharedServer].[superbill_Shared].dbo.CustomerMapEncounter( FromCustomerID, EncounterID, ClaimID, ToCustomerID )
	SELECT {1} AS FromCustomerID, e.EncounterID, c.ClaimID, {2} ToCustomerID 
	FROM {0}.dbo.encounter e
	INNER JOIN {0}.dbo.encounterProcedure ep 
		ON e.practiceID = ep.PracticeID 
		AND e.EncounterID = ep.EncounterID
	INNER JOIN {0}.dbo.claim c 
		ON c.[PracticeID] = ep.[PracticeID]
		AND c.[EncounterProcedureID] = ep.[EncounterProcedureID]
	LEFT JOIN [SharedServer].[superbill_Shared].dbo.CustomerMapEncounter b
		on b.FromCustomerID = {1}
		AND b.EncounterID = e.EncounterID
		AND c.ClaimID = b.ClaimID
	WHERE e.pRacticeID = {3}
		AND b.FromCustomerID is null'

	SET @EXSQL = @SQL
	SET @EXSQL = REPLACE(@EXSQL,'{0}',@TargetDatabaseName)
	SET @EXSQL = REPLACE(@EXSQL,'{1}',@SourceCustomerID)
	SET @EXSQL = REPLACE(@EXSQL,'{2}',@TargetCustomerID)
	SET @EXSQL = REPLACE(@EXSQL,'{3}',@PracticeID)

	PRINT @EXSQL
	EXEC( @EXSQL )


	SET @SQL = 
	'INSERT INTO [SharedServer].[superbill_Shared].dbo.CustomerMapBillEDI( FromCustomerID,  [BillBatchID], [BillID], ToCustomerID )
	SELECT {1} AS FromCustomerID, bb.BillBatchID, bedi.BillID, {2} AS ToCustomerID
	FROM {0}.dbo.Bill_EDI bedi
		INNER JOIN {0}.dbo.BillBatch bb 
			ON bb.[BillBatchID] = bedi.[BillBatchID]
		LEFT JOIN [SharedServer].[superbill_Shared].dbo.CustomerMapBillEDI b 
			on b.FromCustomerID = {1} 
			and bb.BillBatchID =b.BillBatchID
			AND bedi.BillID = b.BillID		
	WHERE bb.[PracticeID] = {3}
		AND b.FromCustomerID IS NULL'


	SET @EXSQL = @SQL
	SET @EXSQL = REPLACE(@EXSQL,'{0}',@TargetDatabaseName)
	SET @EXSQL = REPLACE(@EXSQL,'{1}',@SourceCustomerID)
	SET @EXSQL = REPLACE(@EXSQL,'{2}',@TargetCustomerID)
	SET @EXSQL = REPLACE(@EXSQL,'{3}',@PracticeID)

	PRINT @EXSQL
	EXEC( @EXSQL )


-- Migrate the Practice Mapping.
	SET @SQL = 
	'INSERT INTO [SharedServer].[superbill_Shared].dbo.CustomerMapPractice( FromCustomerID,  practiceID, ToCustomerID )
	SELECT {1} AS FromCustomerID, p.PracticeID, {2} AS ToCustomerID
	FROM {0}.dbo.Practice p
		LEFT JOIN [SharedServer].[superbill_Shared].dbo.CustomerMapPractice b on b.PracticeID = p.practiceID AND b.FromCustomerID = {1}
	WHERE 
		p.PracticeID = {3}
		AND b.FromCustomerID IS NULL
	'


	SET @EXSQL = @SQL
	SET @EXSQL = REPLACE(@EXSQL,'{0}',@TargetDatabaseName)
	SET @EXSQL = REPLACE(@EXSQL,'{1}',@SourceCustomerID)
	SET @EXSQL = REPLACE(@EXSQL,'{2}',@TargetCustomerID)
	SET @EXSQL = REPLACE(@EXSQL,'{3}',@PracticeID)

	PRINT @EXSQL
	EXEC( @EXSQL )


-- update CustomerID
	UPDATE CustomerProperties SET [value]=@TargetCustomerID WHERE [Key]='CustomerID'



-- KFax transfer
IF EXISTS (SELECT * FROM sharedserver.superbill_shared.dbo.FaxDNISCustomerPractice 
	WHERE customerID=@SourceCustomerID and practiceID=@practiceID)
BEGIN
	-- Insert the DNIS we are about to reassign to the history table
	INSERT INTO sharedserver.superbill_shared.dbo.FaxDNISHistory (DateDeleted, DNIS, CustomerID, PracticeID)
	SELECT getdate(), DNIS, CustomerID, PracticeID
	FROM sharedserver.superbill_shared.dbo.FaxDNISCustomerPractice
	WHERE customerID=@SourceCustomerID
		and practiceID=@practiceID

	-- Reassign the DNIS to the new customer
	IF NOT EXISTS (SELECT * FROM sharedserver.superbill_shared.dbo.FaxDNISCustomerPractice WHERE CustomerID=@TargetCustomerID 
		AND PracticeID=@PracticeID)
	BEGIN
		UPDATE sharedserver.superbill_shared.dbo.FaxDNISCustomerPractice
		SET CustomerID = @TargetCustomerID, CreatedDate=getdate()
		WHERE customerID=@SourceCustomerID
			and practiceID=@practiceID
	END

	-- Associate the k-fax account with the new customer
	INSERT INTO sharedserver.superbill_shared.dbo.CustomerUsers (CustomerID, UserID)
	SELECT CustomerID, 1526 as UserID
	FROM sharedserver.superbill_shared.dbo.Customer c
	WHERE CustomerID = @TargetCustomerID
		AND NOT exists(select * from sharedserver.superbill_shared.dbo.CustomerUsers cu 
				where c.customerID=cu.customerID and userID=1526)
END

-- update practice id so users will be able to change IC/IP visibility level
UPDATE dbo.InsuranceCompany SET CreatedPracticeID=@practiceID, ReviewCode = 'R'
UPDATE dbo.InsuranceCompanyPlan SET CreatedPracticeID=@practiceID, ReviewCode = 'R'

-- handle Merchant Information
if not exists (select * from sharedserver.superbill_shared.dbo.MerchantAccountConfig where CustomerID=@TargetCustomerID and PracticeID=@PracticeID)
	update sharedserver.superbill_shared.dbo.MerchantAccountConfig set CustomerID=@TargetCustomerID where CustomerID=@SourceCustomerID and PracticeID=@PracticeID
