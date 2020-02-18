---------------------------------------------------------------------------------------
--case 8216 - Improve Performance on PatientDataProvider_GetWorkersCompContactInfo
---------------------------------------------------------------------------------------
CREATE NONCLUSTERED INDEX IX_WorkersCompContactInfo_PatientCaseID
ON WorkersCompContactInfo (PatientCaseID)
GO

CREATE NONCLUSTERED INDEX IX_PatientCase_PatientID
ON PatientCase (PatientID)

GO

DROP INDEX Patient.IX_Patient_Practice

GO

DROP INDEX Patient.IX_Patient_RefProvider_Practice

GO

CREATE NONCLUSTERED INDEX IX_Patient_ReferringPhysicianID
ON Patient (ReferringPhysicianID)

GO

CREATE NONCLUSTERED INDEX IX_Patient_SSN
ON Patient (SSN)

GO

CREATE NONCLUSTERED INDEX IX_Patient_HomePhone
ON Patient (HomePhone)

GO

CREATE NONCLUSTERED INDEX IX_Patient_City
ON Patient (City)

GO

CREATE NONCLUSTERED INDEX IX_Patient_State
ON Patient (State)

GO

CREATE NONCLUSTERED INDEX IX_Patient_ZipCode
ON Patient (ZipCode)

GO

CREATE NONCLUSTERED INDEX IX_Patient_AddressLine1
ON Patient (AddressLine1)

GO

CREATE NONCLUSTERED INDEX IX_Patient_AddressLine2
ON Patient (AddressLine2)

GO

CREATE NONCLUSTERED INDEX IX_Patient_FirstName
ON Patient (FirstName)

GO

CREATE NONCLUSTERED INDEX IX_Patient_LastName
ON Patient (LastName)

GO

UPDATE STATISTICS Patient

GO