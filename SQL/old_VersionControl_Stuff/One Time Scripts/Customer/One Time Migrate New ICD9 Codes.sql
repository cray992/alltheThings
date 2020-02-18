DECLARE @CurrentDB VARCHAR(50)
DECLARE @SyncDiagnosis BIT
SET @CurrentDB=DB_NAME()

SELECT @SyncDiagnosis=SyncDiagnosis
FROM superbill_shared..Customer
WHERE DatabaseName=@CurrentDB

IF @SyncDiagnosis=1 OR @CurrentDB='CustomerModel' OR @CurrentDB='CustomerModelPrepopulated'
BEGIN
	IF @CurrentDB<>'superbill_0001_prod'
	BEGIN
		UPDATE DiagnosisCodeDictionary SET DiagnosisName=ICD.DiagnosisName
		FROM DiagnosisCodeDictionary DCD INNER JOIN superbill_shared..ICD9Cleaned ICD
		ON DCD.DiagnosisCode=ICD.DiagnosisCode
	END
	
	--Add new ICD9 codes
	INSERT INTO DiagnosisCodeDictionary(DiagnosisCode, DiagnosisName)
	SELECT ICD.DiagnosisCode, ICD.DiagnosisName
	FROM superbill_shared..ICD9Cleaned ICD LEFT JOIN DiagnosisCodeDictionary DCD
	ON ICD.DiagnosisCode=DCD.DiagnosisCode
	WHERE DCD.DiagnosisCode IS NULL
END

IF @CurrentDB='superbill_0001_prod'
BEGIN
	UPDATE superbill_shared..Customer SET SyncDiagnosis=0
	WHERE CustomerID=1
END