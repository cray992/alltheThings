DECLARE @PracticeID int
DECLARE @VendorImportID int
DECLARE @DefaultEncounterStatus int
DECLARE @PracticeTableSet varchar(max)
DECLARE @sql varchar(max)

SET @PracticeTableSet = 'winniestowell'
SET @PracticeID = 111
SET @VendorImportID = 4
SET @DefaultEncounterStatus = 2

CREATE TABLE #procedures
(
	[Code1] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Code2] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Code3] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Type] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Description] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TypeOfService] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DefaultPlaceService1] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DefaultPlaceService2] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DefaultPlaceService3] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TimeToDoProcedure] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InsuranceCategory] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PatientOnlyResponsible] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DonotPrintOnInsurance] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OnlyPrintOnInsurance] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CostOfServiceProduct] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MedicareAllowedAmount] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AmountA] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AmountB] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AmountC] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AmountD] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AmountE] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AmountF] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AmountG] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AmountH] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AmountI] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AmountJ] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AmountK] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AmountL] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AmountM] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AmountN] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AmountO] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AmountP] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AmountQ] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AmountR] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AmountS] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AmountT] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AmountU] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AmountV] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AmountW] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AmountX] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AmountY] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AmountZ] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccountCode] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Taxable] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Inactive] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AdjustmentAmountNegativ] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DefaultModifiers] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PrePayment] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DefaultModifier1] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DefaultModifier2] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DefaultModifier3] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DefaultModifier4] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UserCode] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DateCreated] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Approved] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RecallCode] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ValidSurfaces] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RevenueCode] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TaxRate] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DateModified] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PurchasedService] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DefaultUnits] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

CREATE TABLE #transactions 
(
	[ChartNumber] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CaseNumber] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EntryNumber] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClaimNumber] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DateFrom] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DateTo] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DocumentNumber] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Description] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AttendingProvider] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ProcedureCode] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TransactionType] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InsuranceCategory] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Modifier1] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Modifier2] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Modifier3] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Modifier4] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PlaceOfService] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TypeOfService] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[VisitNumber] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[VisitTotalInSeries] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[VisitSeriesID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Units] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Minutes] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Amount] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PriceIndicator] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Diagnosis1] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Diagnosis2] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Diagnosis3] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Diagnosis4] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClaimItemRejected] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AcceptAssignment1] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AcceptAssignment2] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AcceptAssignment3] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DateCreated] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DateOfFirstStatement] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DateOfSecondStatement] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DateOfLastStatement] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BilledToInsured1] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BilledToInsured2] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BilledToInsured3] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GuarantorPaid] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Insurance1Paid] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Insurance2Paid] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Insurance3Paid] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GuarantorAmountPaid] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Insurance1AmountPaid] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Insurance2AmountPaid] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Insurance3AmountPaid] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GuarantorResponsible] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Insurance1Responsible] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Insurance2Responsible] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Insurance3Responsible] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WhoPaid] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DocumentationType] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Documentation] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AttorneyPaid] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AttorneyAmountPaid] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AttorneyResponsible] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AdjustmentAmount] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UserCode] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AllowedAmount] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DiagnosisCode1] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DiagnosisCode2] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DiagnosisCode3] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DiagnosisCode4] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CCEntryNumber] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ToothNumber] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ToothSurface] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MouthQuadrant] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DepositID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CheckNumber] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UnappliedAmount] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DateModified] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Facility] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ProcedureDescription] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Diagnosis1Description] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Diagnosis2Description] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Diagnosis3Description] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Diagnosis4Description] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StatementNumber] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)

SET @sql = REPLACE('INSERT INTO #transactions SELECT * FROM {0}_mwtrn','{0}',@PracticeTableSet)
EXEC (@sql)

SET @sql = REPLACE('INSERT INTO #procedures SELECT * FROM {0}_mwpro','{0}',@PracticeTableSet)
EXEC (@sql)

BEGIN TRAN

--ensure all modifiers are in the ProcedureModifiers table -- first create temp table
DECLARE @mods TABLE (Mod char(2), PM varchar(16))

--insert each distinct set of modifiers into temp table
INSERT INTO @mods
SELECT DISTINCT 
	trn.modifier1,
	proceduremodifiercode
FROM
	#transactions trn
	left outer join proceduremodifier pm ON CAST(trn.modifier1 AS varchar(16))=pm.proceduremodifiercode

INSERT INTO @mods
SELECT DISTINCT 
	trn.modifier2,
	proceduremodifiercode
FROM
	#transactions trn
	left outer join proceduremodifier pm ON CAST(trn.modifier2 AS varchar(16))=pm.proceduremodifiercode
	left outer join @mods m on m.Mod = trn.modifier2
WHERE
	m.Mod IS NULL

INSERT INTO @mods
SELECT DISTINCT 
	trn.modifier3,
	proceduremodifiercode
FROM
	#transactions trn
	left outer join proceduremodifier pm ON CAST(trn.modifier3 AS varchar(16))=pm.proceduremodifiercode
	left outer join @mods m on m.Mod = trn.modifier3
WHERE
	m.Mod IS NULL

INSERT INTO @mods
SELECT DISTINCT 
	trn.modifier4,
	proceduremodifiercode
FROM
	#transactions trn
	left outer join proceduremodifier pm ON CAST(trn.modifier4 AS varchar(16))=pm.proceduremodifiercode
	left outer join @mods m on m.Mod = trn.modifier4
WHERE
	m.Mod IS NULL

--filter out invalid codes or codes matching existing codes
DELETE FROM @mods WHERE LEN(Mod) < 2 OR PM IS NOT NULL

--add non-existent codes
INSERT INTO ProcedureModifier (ProcedureModifierCode, ModifierName,CreatedDate,ModifiedDate,CreatedUserID,ModifiedUserID)
SELECT Mod, 'Inserted by import', GETDATE(),GETDATE(),0,0 FROM @mods

--ensure all procedures are in the code dictionary
INSERT INTO
	ProcedureCodeDictionary
	(ProcedureCode, CreatedDate,ModifiedDate,CreatedUserID,ModifiedUserID, TypeOfServiceCode,Active,OfficialName)
SELECT
	Code2, GETDATE(),GETDATE(),0,0, TypeOfService,1,Description
FROM
	#procedures
WHERE 
	Code2 NOT IN (SELECT procedurecode FROM procedurecodedictionary) 
	AND LEN(typeofservice) > 0

--identify diagnoses that are in the transaction table
DECLARE @alldiagparts TABLE (Code varchar(max), ParseCode varchar(max), DCD int)
INSERT INTO @alldiagparts (Code)
SELECT DISTINCT 
	trn.DiagnosisCode1
FROM
	#transactions trn
	LEFT OUTER JOIN @alldiagparts adp ON adp.Code = trn.DiagnosisCode1
WHERE 
	adp.Code IS NULL

INSERT INTO @alldiagparts (Code)
SELECT DISTINCT 
	trn.DiagnosisCode2
FROM
	#transactions trn
	LEFT OUTER JOIN @alldiagparts adp ON adp.Code = trn.DiagnosisCode2
WHERE 
	adp.Code IS NULL
INSERT INTO @alldiagparts (Code)
SELECT DISTINCT 
	trn.DiagnosisCode3
FROM
	#transactions trn
	LEFT OUTER JOIN @alldiagparts adp ON adp.Code = trn.DiagnosisCode3
WHERE 
	adp.Code IS NULL
INSERT INTO @alldiagparts (Code)
SELECT DISTINCT 
	trn.DiagnosisCode4
FROM
	#transactions trn
	LEFT OUTER JOIN @alldiagparts adp ON adp.Code = trn.DiagnosisCode4
WHERE 
	adp.Code IS NULL


--try to associate with code ditionary
UPDATE @alldiagparts
SET
	DCD = d.DiagnosisCodeDictionaryID
FROM
	@alldiagparts adp
	INNER JOIN DiagnosisCodeDictionary d ON d.DiagnosisCode = adp.Code

--remove any that are associated correctly (no action necessary)
DELETE FROM @alldiagparts WHERE DCD IS NOT NULL

--try to resolve codes like 1234, 12345, or E1234 to 123.4, 123.45 and E123.4 respectively
UPDATE @alldiagparts SET ParseCode = SUBSTRING(Code,1,3) + '.' + SUBSTRING(Code,4,100) WHERE SUBSTRING(Code,1,1) IN ('1','2','3','4','5','6','7','8','9','0') AND LEN(Code) > 3
UPDATE @alldiagparts SET ParseCode = SUBSTRING(Code,1,4) + '.' + SUBSTRING(Code,5,100) WHERE SUBSTRING(Code,1,1) NOT IN ('1','2','3','4','5','6','7','8','9','0') AND LEN(Code) > 4

--try to associate with code dictionary again
UPDATE @alldiagparts
SET
	DCD = d.DiagnosisCodeDictionaryID
FROM
	@alldiagparts adp
	INNER JOIN DiagnosisCodeDictionary d ON d.DiagnosisCode = adp.ParseCode

--if association was made, propagate re-parsed diagnosis code to source table
UPDATE #transactions SET DiagnosisCode1 = adp.ParseCode FROM #transactions trn INNER JOIN @alldiagparts adp ON adp.Code = trn.DiagnosisCode1 WHERE adp.DCD IS NOT NULL
UPDATE #transactions SET DiagnosisCode2 = adp.ParseCode FROM #transactions trn INNER JOIN @alldiagparts adp ON adp.Code = trn.DiagnosisCode2 WHERE adp.DCD IS NOT NULL
UPDATE #transactions SET DiagnosisCode3 = adp.ParseCode FROM #transactions trn INNER JOIN @alldiagparts adp ON adp.Code = trn.DiagnosisCode3 WHERE adp.DCD IS NOT NULL
UPDATE #transactions SET DiagnosisCode4 = adp.ParseCode FROM #transactions trn INNER JOIN @alldiagparts adp ON adp.Code = trn.DiagnosisCode4 WHERE adp.DCD IS NOT NULL

--remove codes that are correctly associated
DELETE FROM @alldiagparts WHERE DCD IS NOT NULL

--insert the rest of re-parsed codes into code dictionary
INSERT INTO DiagnosisCodeDictionary (DiagnosisCode,CreatedDate,ModifiedDate,CreatedUserID,ModifiedUserID,Active,OfficialName)
SELECT ParseCode, GETDATE(),GETDATE(),0,0,1,'' FROM @alldiagparts WHERE ParseCode IS NOT NULL

--propagate parsed diagnosis codes that were inserted 
UPDATE #transactions SET DiagnosisCode1 = adp.ParseCode FROM #transactions trn INNER JOIN @alldiagparts adp ON adp.Code = trn.DiagnosisCode1 WHERE adp.ParseCode IS NOT NULL
UPDATE #transactions SET DiagnosisCode2 = adp.ParseCode FROM #transactions trn INNER JOIN @alldiagparts adp ON adp.Code = trn.DiagnosisCode2 WHERE adp.ParseCode IS NOT NULL
UPDATE #transactions SET DiagnosisCode3 = adp.ParseCode FROM #transactions trn INNER JOIN @alldiagparts adp ON adp.Code = trn.DiagnosisCode3 WHERE adp.ParseCode IS NOT NULL
UPDATE #transactions SET DiagnosisCode4 = adp.ParseCode FROM #transactions trn INNER JOIN @alldiagparts adp ON adp.Code = trn.DiagnosisCode4 WHERE adp.ParseCode IS NOT NULL

--remove all inserted parsed codes
DELETE FROM @alldiagparts WHERE ParseCode IS NOT NULL

--insert rest into code dictionary
INSERT INTO DiagnosisCodeDictionary (DiagnosisCode,CreatedDate,ModifiedDate,CreatedUserID,ModifiedUserID,Active,OfficialName)
SELECT Code, GETDATE(),GETDATE(),0,0,1,'' FROM @alldiagparts


--create encounter record
DECLARE @t TABLE (UniqueID varchar(100), CaseNumber int, AttendingProvider int, PlaceOfService int, DateCreated datetime, DateFrom datetime, DateTo datetime)

INSERT INTO @t
SELECT CaseNumber + '-' + VisitNumber, cast(CaseNumber as int), max(AttendingProvider), max(PlaceOfService),min(DateCreated),min(DateFrom),max(DateTo)
FROM #transactions 
WHERE TransactionType IN ('A','B')
GROUP BY CaseNumber, VisitNumber
ORDER BY CAST(CaseNumber AS INT), CAST(VisitNumber as INT)

INSERT INTO encounter
	(practiceid,
	patientid,
	patientcaseid,
	doctorid,
	locationid,
	dateofservice,
	dateofserviceto,
	datecreated,
	postingdate,
	encounterstatusid,
	createddate,
	createduserid,
	modifieddate,
	modifieduserid,
	placeofservicecode,
	referringphysicianid,
	vendorid,
	vendorimportid)
SELECT
	@PracticeID,
	pat.patientid,
	cas.patientcaseid,
	d.doctorid,
	1,
	trn.datefrom,
	trn.dateto,
	trn.datecreated,
	trn.datecreated,
	@DefaultEncounterStatus,
	trn.datecreated,
	0,
	GETDATE(),
	0,
	CASE WHEN trn.placeofservice > 10 THEN trn.placeofservice ELSE 41 END,
	cas.ReferringPhysicianID,
	trn.uniqueid,
	@VendorImportID
FROM
	@t trn
	INNER JOIN patientcase cas ON (cas.vendorimportid=@VendorImportID AND cas.VendorID = trn.CaseNumber)
	INNER JOIN patient pat ON cas.patientid=pat.patientid
	inner join doctor d ON (d.vendorimportid=@VendorImportID AND d.vendorid = CAST(trn.attendingprovider as varchar(max)))


--create temp table to hold list of diagnoses for each procedure
DECLARE @diags TABLE (EncounterID varchar(100), DCD int, ListSequence int)

--for diag1..4, insert records into diagnosis temp table
INSERT INTO @diags
SELECT DISTINCT
	trn.CaseNumber + '-' + trn.VisitNumber,
	DCD.DiagnosisCodeDictionaryID,
	1
FROM
	#transactions trn
	inner join DiagnosisCodeDictionary dcd ON dcd.DiagnosisCode = trn.DiagnosisCode1
WHERE
	TransactionType IN ('A','B')
	AND Diagnosis1 = 'True'
	AND Len(DiagnosisCode1) > 0

INSERT INTO @diags
SELECT DISTINCT
	trn.CaseNumber + '-' + trn.VisitNumber,
	DCD.DiagnosisCodeDictionaryID,
	2
FROM
	#transactions trn
	inner join DiagnosisCodeDictionary dcd ON dcd.DiagnosisCode = trn.DiagnosisCode2
WHERE
	TransactionType IN ('A','B')
	AND Diagnosis2 = 'True'
	AND Len(DiagnosisCode2) > 0

INSERT INTO @diags
SELECT DISTINCT
	trn.CaseNumber + '-' + trn.VisitNumber,
	DCD.DiagnosisCodeDictionaryID,
	3
FROM
	#transactions trn
	inner join DiagnosisCodeDictionary dcd ON dcd.DiagnosisCode = trn.DiagnosisCode3
WHERE
	TransactionType IN ('A','B')
	AND Diagnosis3 = 'True'
	AND Len(DiagnosisCode3) > 0

INSERT INTO @diags
SELECT DISTINCT
	trn.CaseNumber + '-' + trn.VisitNumber,
	DCD.DiagnosisCodeDictionaryID,
	4
FROM
	#transactions trn
	inner join DiagnosisCodeDictionary dcd ON dcd.DiagnosisCode = trn.DiagnosisCode4
WHERE
	TransactionType IN ('A','B')
	AND Diagnosis4 = 'True'
	AND Len(DiagnosisCode4) > 0


INSERT INTO EncounterDiagnosis (EncounterID,DiagnosisCodeDictionaryID, CreatedDate, ModifiedDate, CreatedUserID, ModifiedUserID, ListSequence, PracticeID, VendorID, VendorImportID)
SELECT 
	e.encounterid,
	d.DCD,
	GETDATE(), GETDATE(), 0, 0,
	d.ListSequence,
	@PracticeID,
	d.EncounterID,
	@VendorImportID
FROM
	@diags d
	INNER JOIN Encounter e on (e.vendorimportid=@VendorImportID and e.vendorid = d.encounterid)


--create temp table to hold procedures
DECLARE @procs TABLE (EncounterID varchar(100), PCD int, Amount money, Units int, M1 char(2), M2 char(2), M3 char(3), M4 char(4),  
ED1 int, ED2 int, ED3 int, ED4 int, dFrom datetime, dTo datetime, VendorID varchar(max))

INSERT INTO @procs
SELECT 
	trn.CaseNumber + '-' + trn.VisitNumber,
	PCD.ProcedureCodeDictionaryID,
	trn.Amount,
	cast(cast(trn.Units as decimal) * 10 as int) / 10,
	trn.Modifier1,
	trn.Modifier2,
	trn.Modifier3,
	trn.Modifier4,
	d1.EncounterDiagnosisID,
	d2.EncounterDiagnosisID,
	d3.EncounterDiagnosisID,
	d4.EncounterDiagnosisID,
	trn.DateFrom,
	trn.DateTo,
	trn.CaseNumber + '-' + trn.VisitNumber + '-' + trn.EntryNumber
FROM
	#transactions trn
	left outer join EncounterDiagnosis d1 ON d1.vendorimportid = @VendorImportID and d1.vendorid=(trn.CaseNumber + '-' + trn.VisitNumber) and d1.listsequence=1
	left outer join EncounterDiagnosis d2 ON d2.vendorimportid = @VendorImportID and d2.vendorid=(trn.CaseNumber + '-' + trn.VisitNumber) and d2.listsequence=2
	left outer join EncounterDiagnosis d3 ON d3.vendorimportid = @VendorImportID and d3.vendorid=(trn.CaseNumber + '-' + trn.VisitNumber) and d3.listsequence=3
	left outer  join EncounterDiagnosis d4 ON d4.vendorimportid = @VendorImportID and d4.vendorid=(trn.CaseNumber + '-' + trn.VisitNumber) and d4.listsequence=4
	inner join #procedures pro ON pro.Code1 = trn.ProcedureCode
	inner join ProcedureCodeDictionary PCD ON pcd.ProcedureCode = pro.Code2
WHERE
	trn.TransactionType IN ('A','B')

--if any diagnoses didn't resolve, it was because the encounters weren't inserted, most likely, because the patient was gone
DELETE FROM @procs where ED1 IS NULL

--insert procedures
INSERT INTO EncounterProcedure (EncounterID,procedurecodedictionaryid, createddate,modifieddate,createduserid,modifieduserid,servicechargeamount,serviceunitcount,
proceduremodifier1,proceduremodifier2,proceduremodifier3,proceduremodifier4, proceduredateofservice,serviceenddate,practiceid,
encounterdiagnosisid1,encounterdiagnosisid2,encounterdiagnosisid3,encounterdiagnosisid4,VendorID,VendorImportID)
SELECT
	e.encounterid,
	p.pcd,
	e.createddate,
	getdate(), 0,0,
	p.amount,
	p.units,
	p.M1, p.M2, p.M3, p.M4,
	p.dFrom, p.dTo, 
	@PracticeID,
	p.ED1, p.ED2, ED3, p.ED4,
	p.VendorID,
	@VendorImportID
FROM
	@procs p
	INNER JOIN Encounter e ON e.VendorImportID = @VendorImportID AND e.VendorID = p.EncounterID

--COMMIT
--ROLLBACK


DROP TABLE #procedures
DROP TABLE #transactions

/*
--cleanup
delete from encounterprocedure
from encounterprocedure ep inner join encounter e on ep.encounterid=e.encounterid where e.practiceid=111
delete from encounterdiagnosis
from encounterdiagnosis ed inner join encounter e on ed.encounterid=e.encounterid where e.practiceid=111
delete from encounter where practiceid=111
*/
