-- -----------------------
-- OLD TABLES 
-- -----------------------

IF NOT EXISTS ( SELECT  IST.*
	FROM    INFORMATION_SCHEMA.TABLES AS IST
	WHERE   IST.TABLE_SCHEMA = 'dbo'
	AND IST.TABLE_NAME = 'obs_Contract' ) 
BEGIN
	EXEC SP_RENAME 'Contract', 'obs_Contract' 
END

IF NOT EXISTS ( SELECT  IST.*
	FROM    INFORMATION_SCHEMA.TABLES AS IST
	WHERE   IST.TABLE_SCHEMA = 'dbo'
	AND IST.TABLE_NAME = 'obs_ContractFeeSchedule' ) 
BEGIN
	EXEC SP_RENAME 'ContractFeeSchedule', 'obs_ContractFeeSchedule' 
END

IF NOT EXISTS ( SELECT  IST.*
	FROM    INFORMATION_SCHEMA.TABLES AS IST
	WHERE   IST.TABLE_SCHEMA = 'dbo'
	AND IST.TABLE_NAME = 'obs_ContractFeeSchedule_deletes' ) 
BEGIN
	EXEC SP_RENAME 'ContractFeeSchedule_deletes', 'obs_ContractFeeSchedule_deletes' 
END

IF NOT EXISTS ( SELECT  IST.*
	FROM    INFORMATION_SCHEMA.TABLES AS IST
	WHERE   IST.TABLE_SCHEMA = 'dbo'
	AND IST.TABLE_NAME = 'obs_ContractToDoctor' ) 
BEGIN
	EXEC SP_RENAME 'ContractToDoctor', 'obs_ContractToDoctor' 
END

IF NOT EXISTS ( SELECT  IST.*
	FROM    INFORMATION_SCHEMA.TABLES AS IST
	WHERE   IST.TABLE_SCHEMA = 'dbo'
	AND IST.TABLE_NAME = 'obs_ContractToServiceLocation' ) 
BEGIN
	EXEC SP_RENAME 'ContractToServiceLocation', 'obs_ContractToServiceLocation' 
END

IF NOT EXISTS ( SELECT  IST.*
	FROM    INFORMATION_SCHEMA.TABLES AS IST
	WHERE   IST.TABLE_SCHEMA = 'dbo'
	AND IST.TABLE_NAME = 'obs_ContractToInsurancePlan' ) 
BEGIN
	EXEC SP_RENAME 'ContractToInsurancePlan', 'obs_ContractToInsurancePlan' 
END

IF(EXISTS(
	SELECT 1
	FROM sys.foreign_keys fk
	WHERE fk.[name] = 'FK_EncounterProcedureToContract'
	AND parent_object_id = OBJECT_ID('EncounterProcedure')
))
BEGIN
	ALTER TABLE EncounterProcedure 
	DROP CONSTRAINT FK_EncounterProcedureToContract
END

IF(EXISTS(
	SELECT 1
	FROM sys.foreign_keys fk
	WHERE fk.[name] = 'FK_ContractToInsurancePlan_InsurancePlan'
	AND parent_object_id = OBJECT_ID('obs_ContractToInsurancePlan')
))
BEGIN
	ALTER TABLE obs_ContractToInsurancePlan
	DROP CONSTRAINT FK_ContractToInsurancePlan_InsurancePlan
END

-- -----------------------
-- VIEWS 
-- -----------------------

-- CONTRACT FEE SCHEDULE
IF EXISTS ( SELECT  IST.*
            FROM    INFORMATION_SCHEMA.VIEWS AS IST
            WHERE   IST.TABLE_SCHEMA = 'dbo'
                    AND IST.TABLE_NAME = 'Contract' ) 
    BEGIN
        DROP VIEW [dbo].[Contract]
    END

IF EXISTS ( SELECT  IST.*
            FROM    INFORMATION_SCHEMA.VIEWS AS IST
            WHERE   IST.TABLE_SCHEMA = 'dbo'
                    AND IST.TABLE_NAME = 'ContractFeeSchedule' ) 
    BEGIN
        DROP VIEW [dbo].[ContractFeeSchedule]
    END

GO

IF EXISTS ( SELECT  IST.*
            FROM    INFORMATION_SCHEMA.VIEWS AS IST
            WHERE   IST.TABLE_SCHEMA = 'dbo'
                    AND IST.TABLE_NAME = 'ContractFeeSchedule_deletes' ) 
    BEGIN
        DROP VIEW [dbo].[ContractFeeSchedule_deletes]
    END

GO


IF EXISTS ( SELECT  IST.*
            FROM    INFORMATION_SCHEMA.VIEWS AS IST
            WHERE   IST.TABLE_SCHEMA = 'dbo'
                    AND IST.TABLE_NAME = 'ContractToDoctor' ) 
    BEGIN
        DROP VIEW [dbo].[ContractToDoctor]
    END

GO

IF EXISTS ( SELECT  IST.*
            FROM    INFORMATION_SCHEMA.VIEWS AS IST
            WHERE   IST.TABLE_SCHEMA = 'dbo'
                    AND IST.TABLE_NAME = 'ContractToServiceLocation' ) 
    BEGIN
        DROP VIEW [dbo].[ContractToServiceLocation]
    END

GO

IF EXISTS ( SELECT  IST.*
            FROM    INFORMATION_SCHEMA.VIEWS AS IST
            WHERE   IST.TABLE_SCHEMA = 'dbo'
                    AND IST.TABLE_NAME = 'ContractToInsurancePlan' ) 
    BEGIN
        DROP VIEW [dbo].[ContractToInsurancePlan]
    END

GO

CREATE VIEW [dbo].[Contract]
(
	[ContractID],
	[PracticeID],
	[RecordTimeStamp],
	[CreatedDate],
	[CreatedUserID],
	[ModifiedDate],
	[ModifiedUserID],
	[ContractName],
	[Description],
	[ContractType],
	[EffectiveStartDate],
	[EffectiveEndDate],
	[PolicyValidator],
	[NoResponseTriggerPaper],
	[NoResponseTriggerElectronic],
	[Notes],
	[Capitated],
	[AnesthesiaTimeIncrement]
)
AS
	(
				SELECT
			  crs.ContractRateScheduleID AS ContractID
			, crs.PracticeID AS PracticeID
			, CAST(NULL AS TIMESTAMP) AS RecordTimeStamp
			, GETDATE() AS CreatedDate
			, 0 AS CreatedUserID
			, GETDATE() AS ModifiedDate
			, 0 AS ModifiedUserID
			, ic.InsuranceCompanyName AS ContractName
			, CAST(NULL AS TEXT) AS [Description]
			, CAST('P' AS CHAR(1)) AS ContractType
			, crs.EffectiveStartDate AS EffectiveStartDate
			, crs.EffectiveEndDate AS EffectiveEndDate
			, CAST(NULL AS VARCHAR(64)) AS PolicyValidator
			, crs.PaperClaimsNoResponseTrigger AS NoResponseTriggerPaper 
			, crs.EClaimsNoResponseTrigger AS NoResponseTriggerElectronic 
			, CAST(NULL AS TEXT) AS Notes
			, crs.Capitated AS Capitated
			, crs.AnesthesiaTimeIncrement AS AnesthesiaTimeIncrement
		FROM ContractsAndFees_ContractRateSchedule crs
		LEFT JOIN InsuranceCompany ic ON ic.InsuranceCompanyID = crs.InsuranceCompanyID

	)
	UNION ALL
	(
		SELECT  
			  sfs.StandardFeeScheduleID AS ContractID
			, sfs.PracticeID AS PracticeID
			, CAST(NULL AS TIMESTAMP) AS RecordTimeStamp
   			, GETDATE() AS CreatedDate
			, 0 AS CreatedUserID
			, GETDATE() AS ModifiedDate
			, 0 AS ModifiedUserID
			, sfs.[Name] AS ContractName
			, CAST(NULL AS TEXT) AS [Description]
			, CAST('S' AS CHAR(1)) AS ContractType
			, sfs.EffectiveStartDate AS EffectiveStartDate 
			, CAST('5000-01-01' AS DATETIME) AS EffectiveEndDate--pretend it's really far in the future, since Standard Fee Schedules no longer end.
			, CAST(NULL AS VARCHAR(64)) AS PolicyValidator
			, sfs.PaperClaimsNoResponseTrigger AS NoResponseTriggerPaper 
			, sfs.EClaimsNoResponseTrigger AS NoResponseTriggerElectronic 
			, CAST(sfs.Notes AS TEXT) AS Notes 
			, CAST(0 AS BIT) AS Capitated
			, sfs.AnesthesiaTimeIncrement AS AnesthesiaTimeIncrement
		FROM ContractsAndFees_StandardFeeSchedule sfs
	)
GO

CREATE VIEW [dbo].[ContractFeeSchedule](
	[ContractFeeScheduleID],
	[RecordTimeStamp],
	[CreatedDate],
	[CreatedUserID],
	[ModifiedDate],
	[ModifiedUserID],
	[ContractID],
	[Modifier],
	[Gender],
	[StandardFee],
	[Allowable],
	[ExpectedReimbursement],
	[RVU],
	[ProcedureCodeDictionaryID],
	[DiagnosisCodeDictionaryID],
	[PracticeRVU],
	[MalpracticeRVU],
	[BaseUnits]
)
AS
	(
		SELECT
		  cr.ContractRateID AS ContractFeeScheduleID
		, CAST(NULL AS TIMESTAMP) AS RecordTimeStamp
		, GETDATE() AS CreatedDate
		, 0 AS CreatedUserID
		, GETDATE() AS ModifiedDate
		, 0 AS ModifiedUserID
		, cr.ContractRateScheduleID AS ContractID
		, pm.ProcedureModifierCode AS Modifier
		, CAST('B' AS CHAR(1)) AS Gender
		, cr.SetFee AS StandardFee
		, CAST(NULL AS MONEY) AS Allowable
		, CAST(NULL AS MONEY) AS ExpectedReimbursement
		, CAST(0 AS DECIMAL(18,3)) AS RVU
		, cr.ProcedureCodeID AS ProcedureCodeDictionaryID
		, NULL AS DiagnosisCodeDictionaryID
		, CAST(0 AS DECIMAL(18,3)) AS PracticeRVU
		, CAST(0 AS DECIMAL(18,3)) AS MalpracticeRVU
		, cr.AnesthesiaBaseUnits AS BaseUnits
		FROM ContractsAndFees_ContractRate cr
		LEFT JOIN ProcedureModifier pm ON pm.ProcedureModifierID = cr.ModifierID
	)
	UNION
	(
		SELECT
			  sf.StandardFeeID AS ContractFeeScheduleID
			, CAST(NULL AS TIMESTAMP) AS RecordTimeStamp
			, GETDATE() AS CreatedDate
			, 0 AS CreatedUserID
			, GETDATE() AS ModifiedDate
			, 0 AS ModifiedUserID
			, sf.StandardFeeScheduleID AS ContractID
			, pm.ProcedureModifierCode AS Modifier
			, CAST('B' AS CHAR(1)) AS Gender
			, sf.SetFee AS StandardFee
			, CAST(NULL AS MONEY) AS Allowable
			, CAST(NULL AS MONEY) AS ExpectedReimbursement
			, CAST(0 AS DECIMAL(18,3)) AS RVU
			, sf.ProcedureCodeID AS ProcedureCodeDictionaryID
			, NULL AS DiagnosisCodeDictionaryID
			, CAST(0 AS DECIMAL(18,3)) AS PracticeRVU
			, CAST(0 AS DECIMAL(18,3)) AS MalpracticeRVU
			, sf.AnesthesiaBaseUnits AS BaseUnits
		FROM ContractsAndFees_StandardFee sf
		LEFT JOIN ProcedureModifier pm ON pm.ProcedureModifierID = sf.ModifierID
	)
GO

CREATE VIEW [dbo].[ContractToInsurancePlan]
(
	[ContractToInsurancePlanID],
	[RecordTimeStamp],
	[CreatedDate], 
	[CreatedUserID],
	[ModifiedDate], 
	[ModifiedUserID],
	[ContractID], 
	[PlanID]
)
AS
	SELECT 
	(crs.ContractRateScheduleID * 100000 + icp.InsuranceCompanyPlanID) AS ContractToInsurancePlanID,
	CAST(NULL AS TIMESTAMP) AS RecordTimeStamp,
	GETDATE() AS CreatedDate,
	0 AS CreatedUserID,
	GETDATE() AS ModifiedDate,
	0 AS ModifiedUserID,
	crs.ContractRateScheduleID AS ContractID, 
	icp.InsuranceCompanyPlanID AS PlanID
	FROM ContractsAndFees_ContractRateSchedule crs
	JOIN InsuranceCompanyPlan icp ON icp.InsuranceCompanyID = crs.InsuranceCompanyID
GO
    
CREATE VIEW [dbo].[ContractToDoctor]
(
	[ContractToDoctorID],
	[RecordTimeStamp],
	[CreatedDate],
	[CreatedUserID],
	[ModifiedDate],
	[ModifiedUserID],
	[ContractID],
	[DoctorID]
)
AS
SELECT 
	(crsl.ContractRateScheduleID * 100000 + crsl.ProviderID) AS ContractToDoctorID,
	CAST(NULL AS TIMESTAMP) AS RecordTimeStamp,
	GETDATE() AS CreatedDate,
	0 AS CreatedUserID,
	GETDATE() AS ModifiedDate,
	0 AS ModifiedUserID,
	crsl.ContractRateScheduleID AS ContractID,
	crsl.ProviderID AS DoctorID
FROM ContractsAndFees_ContractRateScheduleLink crsl
UNION ALL
(
	SELECT 
		(sfsl.StandardFeeScheduleID * 100000 + sfsl.ProviderID) AS ContractToDoctorID,
		CAST(NULL AS TIMESTAMP) AS RecordTimeStamp,
		GETDATE() AS CreatedDate,
		0 AS CreatedUserID,
		GETDATE() AS ModifiedDate,
		0 AS ModifiedUserID,
		sfsl.StandardFeeScheduleID AS ContractID,
		sfsl.ProviderID AS DoctorID
	FROM ContractsAndFees_StandardFeeScheduleLink sfsl
)
    
GO
    
CREATE VIEW [dbo].[ContractToServiceLocation]
(
	[ContractToServiceLocationID],
	[RecordTimeStamp],
	[CreatedDate],
	[CreatedUserID],
	[ModifiedDate],
	[ModifiedUserID],
	[ContractID],
	[ServiceLocationID]
)
AS
SELECT 
	(crsl.ContractRateScheduleID * 100000 + crsl.LocationID) AS ContractToServiceLocationID,
	CAST(NULL AS TIMESTAMP) AS RecordTimeStamp,
	GETDATE() AS CreatedDate,
	0 AS CreatedUserID,
	GETDATE() AS ModifiedDate,
	0 AS ModifiedUserID,
	crsl.ContractRateScheduleID AS ContractID,
	crsl.LocationID AS ServiceLocationID
FROM ContractsAndFees_ContractRateScheduleLink crsl
UNION ALL
(
	SELECT 
		(sfsl.StandardFeeScheduleID * 100000 + sfsl.LocationID) AS ContractToServiceLocationID,
		CAST(NULL AS TIMESTAMP) AS RecordTimeStamp,
		GETDATE() AS CreatedDate,
		0 AS CreatedUserID,
		GETDATE() AS ModifiedDate,
		0 AS ModifiedUserID,
		sfsl.StandardFeeScheduleID AS ContractID,
		sfsl.LocationID AS ServiceLocationID
	FROM ContractsAndFees_StandardFeeScheduleLink sfsl
)
GO