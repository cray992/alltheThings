DECLARE @ReferringProviderID INT
DECLARE @DoctorID INT

SET @ReferringProviderID=
SET @DoctorID=

INSERT INTO ProviderNumber(DoctorID, ProviderNumberTypeID, InsuranceCompanyPlanID, LocationID, ProviderNumber, AttachConditionsTypeID)
SELECT @DoctorID, ProviderNumberTypeID, InsuranceCompanyPlanID, LocationID, ProviderNumber, AttachConditionsTypeID
FROM ProviderNumber
WHERE DoctorID=@ReferringProviderID

UPDATE Patient SET ReferringPhysicianID=@DoctorID
WHERE ReferringPhysicianID=@ReferringProviderID

UPDATE PatientCase SET ReferringPhysicianID=@DoctorID
WHERE ReferringPhysicianID=@ReferringProviderID

UPDATE Encounter SET ReferringPhysicianID=@DoctorID
WHERE ReferringPhysicianID=@ReferringProviderID

UPDATE C SET ReferringProviderIDNumber=UPIN.ProviderNumber
FROM Claim C INNER JOIN EncounterProcedure EP
ON C.EncounterProcedureID=EP.EncounterProcedureID
INNER JOIN Encounter E
ON EP.EncounterID=E.EncounterID
INNER JOIN PatientCase PC
ON E.PatientCaseID=PC.PatientCaseID
INNER JOIN ProviderNumber UPIN
ON PC.ReferringPhysicianID=UPIN.DoctorID AND UPIN.ProviderNumberTypeID = 25
WHERE PC.ReferringPhysicianID=@DoctorID AND ReferringProviderIDNumber IS NULL

UPDATE Patient SET PrimaryCarePhysicianID=@DoctorID
WHERE PrimaryCarePhysicianID=@ReferringProviderID

DELETE ProviderNumber
WHERE DoctorID=@ReferringProviderID

DELETE Doctor
WHERE DoctorID=@ReferringProviderID

