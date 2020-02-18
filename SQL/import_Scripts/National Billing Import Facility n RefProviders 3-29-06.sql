BEGIN TRAN

DECLARE @VendorImportID INT
DECLARE @PracticeID INT
SET @VendorImportID=16

SELECT @PracticeID=PracticeID
FROM Practice
WHERE VendorImportID=@VendorImportID

CREATE TABLE #PatientFacility(PatientID INT, FacilityCode VARCHAR(50), UniqueCode VARCHAR(50))
INSERT INTO #PatientFacility(PatientID, FacilityCode)
SELECT P.PatientID, LP.Facility
FROM Patient P INNER JOIN lytec_patients LP
ON P.VendorImportID=LP.VendorImportID AND P.VendorID=LP.[Chart Number]
WHERE P.VendorImportID=@VendorImportID

CREATE TABLE #PatientReferringProvider(PatientID INT, ReferringProviderCode VARCHAR(50))
INSERT INTO #PatientReferringProvider(PatientID, ReferringProviderCode)
SELECT P.PatientID, LP.[Referring Physician]
FROM Patient P INNER JOIN lytec_patients LP
ON P.VendorImportID=LP.VendorImportID AND P.VendorID=LP.[Chart Number]
WHERE P.VendorImportID=@VendorImportID

CREATE TABLE #Facilities(FacilityCode VARCHAR(50))
CREATE TABLE #ReferringProvider(ReferringProviderCode VARCHAR(50))

IF @VendorImportID=12
BEGIN
	UPDATE #PatientFacility SET UniqueCode='COMMU0001'
	WHERE FacilityCode IN ('COMMU0000')

	UPDATE #PatientFacility SET UniqueCode='GALLA0001'
	WHERE FacilityCode IN ('GALLA0000')

	UPDATE #PatientFacility SET UniqueCode='HANCO0002'
	WHERE FacilityCode IN ('HANCO0000')

	UPDATE #PatientFacility SET UniqueCode='STVIN0000'
	WHERE FacilityCode IN ('ST.VI0000','ST.VI0001')

	UPDATE #PatientFacility SET UniqueCode=FacilityCode
	WHERE UniqueCode IS NULL

	INSERT INTO #Facilities(FacilityCode)
	SELECT DISTINCT UniqueCode
	FROM #PatientFacility

	INSERT INTO #ReferringProvider(ReferringProviderCode)
	SELECT DISTINCT ReferringProviderCode
	FROM #PatientReferringProvider
	WHERE ReferringProviderCode NOT IN ('GALLA0000','GALLA0001','LOC4')
END
ELSE
BEGIN
	UPDATE #PatientFacility SET UniqueCode=FacilityCode
	WHERE UniqueCode IS NULL

	INSERT INTO #Facilities(FacilityCode)
	SELECT DISTINCT FacilityCode
	FROM #PatientFacility

	INSERT INTO #ReferringProvider(ReferringProviderCode)
	SELECT DISTINCT ReferringProviderCode
	FROM #PatientReferringProvider

END

INSERT ServiceLocation(PracticeID, Name, AddressLine1, AddressLine2, City, State, ZipCode, Phone, PhoneExt, FaxPhone, VendorImportID, VendorID)
SELECT @PracticeID, LTRIM(RTRIM(Name)), 
CASE WHEN LTRIM(RTRIM([Address 1]))='' THEN NULL ELSE LTRIM(RTRIM([Address 1])) END, 
CASE WHEN LTRIM(RTRIM([Address 2]))='' THEN NULL ELSE LTRIM(RTRIM([Address 2])) END, 
CASE WHEN LTRIM(RTRIM(City))='' THEN NULL ELSE LTRIM(RTRIM(City)) END, 
CASE WHEN LTRIM(RTRIM(State))='' THEN NULL ELSE LTRIM(RTRIM(State)) END, 
CASE WHEN LTRIM(RTRIM(REPLACE([Zip Code],'-','')))='' THEN NULL ELSE LTRIM(RTRIM(REPLACE([Zip Code],'-',''))) END,
CASE WHEN LTRIM(RTRIM(Phone))='' THEN NULL ELSE LTRIM(RTRIM(Phone)) END, 
CASE WHEN LTRIM(RTRIM(Extension))='' THEN NULL ELSE LTRIM(RTRIM(Extension)) END, 
CASE WHEN LTRIM(RTRIM(Fax))='' THEN NULL ELSE LTRIM(RTRIM(Fax)) END, @VendorImportID, Code
FROM address_16 a INNER JOIN #Facilities F
ON a.Code=F.FacilityCode

UPDATE P SET DefaultServiceLocationID=ServiceLocationID
FROM Patient P INNER JOIN #PatientFacility PF
ON P.PatientID=PF.PatientID
INNER JOIN ServiceLocation SL
ON SL.VendorImportID=@VendorImportID AND PF.UniqueCode=SL.VendorID

INSERT Doctor(PracticeID, FirstName, MiddleName, LastName, Prefix, Suffix, AddressLine1, AddressLine2, City, State, ZipCode, HomePhone, HomePhoneExt, FaxNumber, VendorImportID, VendorID, [External])
SELECT @PracticeID, 
CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(Name)))<>0 THEN LEFT(LTRIM(RTRIM(Name)),CHARINDEX(' ',LTRIM(RTRIM(Name)))-1) ELSE LTRIM(RTRIM(Name)) END,
CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(Name)))<>0 AND CHARINDEX(' ',LTRIM(RTRIM(Name)),CHARINDEX(' ',LTRIM(RTRIM(Name)))+1)<>0 THEN
SUBSTRING(LTRIM(RTRIM(Name)),CHARINDEX(' ',LTRIM(RTRIM(Name)))+1,CHARINDEX(' ',LTRIM(RTRIM(Name)),CHARINDEX(' ',LTRIM(RTRIM(Name)))+1)-CHARINDEX(' ',LTRIM(RTRIM(Name)))) ELSE '' END,
CASE WHEN CHARINDEX(' ',LTRIM(RTRIM(Name)))<>0 AND CHARINDEX(' ',LTRIM(RTRIM(Name)),CHARINDEX(' ',LTRIM(RTRIM(Name)))+1)<>0 THEN
RIGHT(LTRIM(RTRIM(Name)),LEN(LTRIM(RTRIM(Name)))-CHARINDEX(' ',LTRIM(RTRIM(Name)),CHARINDEX(' ',LTRIM(RTRIM(Name)))+1)) ELSE 
RIGHT(LTRIM(RTRIM(Name)),LEN(LTRIM(RTRIM(Name)))-CHARINDEX(' ',LTRIM(RTRIM(Name)))+1) END, '', '',
CASE WHEN LTRIM(RTRIM([Address 1]))='' THEN NULL ELSE LTRIM(RTRIM([Address 1])) END, 
CASE WHEN LTRIM(RTRIM([Address 2]))='' THEN NULL ELSE LTRIM(RTRIM([Address 2])) END, 
CASE WHEN LTRIM(RTRIM(City))='' THEN NULL ELSE LTRIM(RTRIM(City)) END, 
CASE WHEN LTRIM(RTRIM(State))='' THEN NULL ELSE LTRIM(RTRIM(State)) END, 
CASE WHEN LTRIM(RTRIM(REPLACE([Zip Code],'-','')))='' THEN NULL ELSE LTRIM(RTRIM(REPLACE([Zip Code],'-',''))) END,
CASE WHEN LTRIM(RTRIM(Phone))='' THEN NULL ELSE LTRIM(RTRIM(Phone)) END, 
CASE WHEN LTRIM(RTRIM(Extension))='' THEN NULL ELSE LTRIM(RTRIM(Extension)) END, 
CASE WHEN LTRIM(RTRIM(Fax))='' THEN NULL ELSE LTRIM(RTRIM(Fax)) END, @VendorImportID, Code, 1
FROM address_16 a INNER JOIN #ReferringProvider R
ON a.Code=R.ReferringProviderCode

INSERT INTO ProviderNumber(DoctorID, ProviderNumberTypeID, ProviderNumber, AttachConditionsTypeID)
SELECT DoctorID, 25, LTRIM(RTRIM([Insurance Codes 1])), 1
FROM Doctor D INNER JOIN address_16 a
ON D.VendorImportID=@VendorImportID AND D.VendorID=a.Code
WHERE LTRIM(RTRIM([Insurance Codes 1]))<>''

UPDATE P SET ReferringPhysicianID=DoctorID
FROM Patient P INNER JOIN #PatientReferringProvider PRP
ON P.PatientID=PRP.PatientID
INNER JOIN Doctor D
ON D.VendorImportID=@VendorImportID AND D.VendorID=PRP.ReferringProviderCode

DROP TABLE #PatientFacility
DROP TABLE #PatientReferringProvider
DROP TABLE #Facilities
DROP TABLE #ReferringProvider

--COMMIT
--ROLLBACK






