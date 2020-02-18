/*

DATABASE UPDATE SCRIPT   - SHARED

v1.21.1769 to v1.22.xxxx
*/
----------------------------------

--BEGIN TRAN 
----------------------------------


---------------------------------------------------------------------------------------
-- case 2880 -- link InsuranceCompanyPlan records to ClearinghousePayersList:

-- make sure you run ProxymedDataMigrator before the following.

-- add an ICP column for foreign key linking into CPL:
ALTER TABLE
	InsuranceCompanyPlan
ADD
	ClearinghousePayerID int
		CONSTRAINT FK_InsuranceCompanyPlan_ClearinghousePayersList
			FOREIGN KEY REFERENCES ClearinghousePayersList(ClearinghousePayerID)
GO

--
-- Migrate existing records to the new schema:
--

	-- UPDATE InsuranceCompanyPlan
	-- SET ClearinghousePayerID = NULL
BEGIN TRAN 	
	-- first migrate the ones that have unique reference to CPL table (i.e. CPL table happens to have PayerNumber unique): 
	SELECT     PayerNumber, COUNT(*) AS CNT
	INTO #t_temp124
	FROM         ClearinghousePayersList
	GROUP BY PayerNumber
	
	-- leave only rows which have unique PayerNumber
	DELETE #t_temp124 WHERE CNT > 1
	
	-- make a cross-ref table:
	SELECT ICP.InsuranceCompanyPlanID, ICP.PlanName, ICP.EDIPayerNumber, CPL.Name, CPL.ClearinghousePayerID
	INTO #t_temp125
	FROM #t_temp124 t2
	INNER JOIN ClearinghousePayersList CPL ON CPL.PayerNumber = t2.PayerNumber
	INNER JOIN InsuranceCompanyPlan ICP ON ICP.EDIPayerNumber = t2.PayerNumber
	
	--SELECT * FROM #t_temp125 t3
	--INNER JOIN InsuranceCompanyPlan ICP ON ICP.InsuranceCompanyPlanID = t3.InsuranceCompanyPlanID
	
	UPDATE InsuranceCompanyPlan
	SET ClearinghousePayerID = (SELECT t3.ClearinghousePayerID FROM  #t_temp125 t3 WHERE InsuranceCompanyPlan.InsuranceCompanyPlanID = t3.InsuranceCompanyPlanID)
	
	--SELECT count(*) from InsuranceCompanyPlan ICP WHERE ICP.ClearinghousePayerID IS NOT NULL
	
	DROP TABLE #t_temp125
	
	--SELECT CPL.PayerNumber, CPL.Name AS CPL_Name, ICP.PlanName AS ICP_PlanName from InsuranceCompanyPlan ICP
	--INNER JOIN ClearinghousePayersList CPL ON ICP.ClearinghousePayerID = CPL.ClearinghousePayerID
	GO
	
	
	-- now migrate those which are state-specific and can be related to CPL through PayerNumber,StateSpecific combo:
	
	SELECT     PayerNumber,StateSpecific, COUNT(*) AS CNT
	INTO #t_temp124_1
	FROM         ClearinghousePayersList
	GROUP BY PayerNumber,StateSpecific
	ORDER BY CNT DESC
	
	-- leave only rows which have non-unique PayerNumber and a StateSpecific field:
	DELETE #t_temp124_1 WHERE (PayerNumber IN (select PayerNumber from #t_temp124)) OR (StateSpecific IS NULL)
	
	-- best effort cross-ref table for PayerNumber,State to ClearinghousePayerID:
	select t1.*, (SELECT TOP 1 CPL.ClearinghousePayerID FROM ClearinghousePayersList CPL WHERE CPL.PayerNumber = t1.PayerNumber) AS ClearinghousePayerID
	INTO #t_temp125
	FROM #t_temp124_1 t1
	ORDER BY t1.CNT, t1.PayerNumber
	
	-- select * from #t_temp125
	
	UPDATE InsuranceCompanyPlan
	SET ClearinghousePayerID = (SELECT t3.ClearinghousePayerID FROM  #t_temp125 t3
			 WHERE InsuranceCompanyPlan.EDIPayerNumber = t3.PayerNumber
				AND InsuranceCompanyPlan.State = t3.StateSpecific)
	WHERE InsuranceCompanyPlan.ClearinghousePayerID IS NULL
	
	--SELECT count(*) from InsuranceCompanyPlan ICP WHERE ICP.ClearinghousePayerID IS NOT NULL
	
	DROP TABLE #t_temp124_1
	DROP TABLE #t_temp125
	GO
	
	
	-- at last migrate the remaining ones, keeping in mind that PayerNumber will be correct, but actual link will be likely not:
	
	SELECT     PayerNumber, COUNT(*) AS CNT
	INTO #t_temp124_1
	FROM         ClearinghousePayersList
	GROUP BY PayerNumber
	
	-- leave only rows which have non-unique PayerNumber, as the unique ones were considered before
	DELETE #t_temp124_1 WHERE CNT = 1
	
	-- best effort cross-ref table for PayerNumber to ClearinghousePayerID:
	select t1.*, (SELECT TOP 1 CPL.ClearinghousePayerID FROM ClearinghousePayersList CPL WHERE CPL.PayerNumber = t1.PayerNumber) AS ClearinghousePayerID
	INTO #t_temp125
	FROM #t_temp124_1 t1
	ORDER BY t1.CNT, t1.PayerNumber
	
	-- select * from #t_temp125
	
	UPDATE InsuranceCompanyPlan
	SET ClearinghousePayerID = (SELECT t3.ClearinghousePayerID FROM  #t_temp125 t3
			 WHERE InsuranceCompanyPlan.EDIPayerNumber = t3.PayerNumber)
	WHERE InsuranceCompanyPlan.ClearinghousePayerID IS NULL
	
	--SELECT count(*) from InsuranceCompanyPlan ICP WHERE ICP.ClearinghousePayerID IS NOT NULL
	
	DROP TABLE #t_temp124_1
	DROP TABLE #t_temp125
	DROP TABLE #t_temp124
	GO

	SELECT count(*) from InsuranceCompanyPlan ICP JOIN ClearinghousePayersList CPL ON CPL.ClearinghousePayerID = ICP.ClearinghousePayerID
	WHERE ICP.EDIPayerNumber <> CPL.PayerNumber
	
-- end migrating existing records to the new schema
COMMIT

-- case 2880 -- the fields below belong to ClearinghousePayersList now, so they are to be removed from InsuranceCompanyPlan:

DROP INDEX dbo.InsuranceCompanyPlan.IX_InsuranceCompanyPlan_InsuranceCompanyPlanID_EDIPayerNumber
GO

ALTER TABLE dbo.InsuranceCompanyPlan
DROP CONSTRAINT DF_EClaimsRequiresEnrollment
GO

ALTER TABLE dbo.InsuranceCompanyPlan
DROP CONSTRAINT DF_EClaimsRequiresAuthorization
GO

ALTER TABLE dbo.InsuranceCompanyPlan
DROP CONSTRAINT DF_EClaimsRequiresProviderID
GO

ALTER TABLE dbo.InsuranceCompanyPlan
DROP CONSTRAINT DF__Insurance__EClai__75B09349
GO

ALTER TABLE dbo.InsuranceCompanyPlan
DROP CONSTRAINT DF__Insurance__EClai__76A4B782
GO

ALTER TABLE dbo.InsuranceCompanyPlan DROP COLUMN
	[EDIPayerNumber],
	[IsGovernment],
	[StateSpecific],
	[EClaimsRequiresEnrollment],
	[EClaimsRequiresAuthorization],
	[EClaimsRequiresProviderID],
	[EClaimsResponseLevel],
	[EClaimsPaperOnly],
	[EClaimsRequiresTest]
GO

---------------------------------------------------------------------------------------
--case XXXX - Description

---------------------------------------------------------------------------------------

--ROLLBACK
--COMMIT

INSERT INTO [dbo].[ClearinghousePayersList] (
	[ClearinghousePayerID],
	[ClearinghouseID],
	[PayerNumber],
	[Name],
	[Notes],
	[StateSpecific],
	[IsPaperOnly],
	[IsGovernment],
	[IsCommercial],
	[IsParticipating],
	[IsProviderIdRequired],
	[IsEnrollmentRequired],
	[IsAuthorizationRequired],
	[IsTestRequired],
	[ResponseLevel],
	[IsNewPayer],
	[DateNewPayerSince],
	[CreatedDate],
	[ModifiedDate],
	[Active],
	[IsModifiedPayer],
	[DateModifiedPayerSince],
	[KareoClearinghousePayersListID])
SELECT 
	[ClearinghousePayerID],
	[ClearinghouseID],
	[PayerNumber],
	[Name],
	[Notes],
	[StateSpecific],
	[IsPaperOnly],
	[IsGovernment],
	[IsCommercial],
	[IsParticipating],
	[IsProviderIdRequired],
	[IsEnrollmentRequired],
	[IsAuthorizationRequired],
	[IsTestRequired],
	[ResponseLevel],
	[IsNewPayer],
	[DateNewPayerSince],
	[CreatedDate],
	[ModifiedDate],
	[Active],
	[IsModifiedPayer],
	[DateModifiedPayerSince],
	CPL.ClearinghousePayerID

FROM superbill_shared.dbo.ClearinghousePayersList CPL
