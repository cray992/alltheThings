--===========================================================================
-- MOD: CODING TEMPLATE TABLE
--===========================================================================

IF 64 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'Name'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'CodingTemplate'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.CodingTemplate
	ALTER COLUMN [Name] VARCHAR(64)
END

--===========================================================================
-- MOD: DIAGNOSIS Code DICTIONARY TABLE
--===========================================================================

IF 100 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'DiagnosisName'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'DiagnosisCodeDictionary'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.DiagnosisCodeDictionary
	ALTER COLUMN DiagnosisName VARCHAR(100)
END

--===========================================================================
-- MOD: DOCTOR
--===========================================================================

IF 64 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'FirstName'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'Doctor'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.Doctor
	ALTER COLUMN FirstName VARCHAR(64)
END

IF 64 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'MiddleName'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'Doctor'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.Doctor
	ALTER COLUMN MiddleName VARCHAR(64)
END

IF 64 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'LastName'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'Doctor'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.Doctor
	ALTER COLUMN LastName VARCHAR(64)
END

IF 256 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'AddressLine1'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'Doctor'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.Doctor
	ALTER COLUMN AddressLine1 VARCHAR(256)
END

IF 256 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'AddressLine2'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'Doctor'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.Doctor
	ALTER COLUMN AddressLine2 VARCHAR(256)
END

IF 128 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'City'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'Doctor'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.Doctor
	ALTER COLUMN City VARCHAR(128)
END

IF 256 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'EmailAddress'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'Doctor'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.Doctor
	ALTER COLUMN EmailAddress VARCHAR(256) NULL
END

--===========================================================================
-- MOD: INSURANCE COMPANY TABLE
--===========================================================================

IF 128 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'InsuranceCompanyName'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'InsuranceCompany'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.InsuranceCompany
	ALTER COLUMN InsuranceCompanyName VARCHAR(128)
END

--===========================================================================
-- MOD: INSURANCE COMPANY PLAN TABLE
--===========================================================================

IF 128 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'PlanName'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'InsuranceCompanyPlan'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.InsuranceCompanyPlan
	ALTER COLUMN PlanName VARCHAR(128)
END

IF 256 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'AddressLine1'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'InsuranceCompanyPlan'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.InsuranceCompanyPlan
	ALTER COLUMN AddressLine1 VARCHAR(256)
END

IF 256 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'AddressLine2'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'InsuranceCompanyPlan'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.InsuranceCompanyPlan
	ALTER COLUMN AddressLine2 VARCHAR(256)
END

IF 128 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'City'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'InsuranceCompanyPlan'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.InsuranceCompanyPlan
	ALTER COLUMN City VARCHAR(128)
END

IF 64 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'ContactFirstName'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'InsuranceCompanyPlan'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.InsuranceCompanyPlan
	ALTER COLUMN ContactFirstName VARCHAR(64)
END

IF 64 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'ContactMiddleName'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'InsuranceCompanyPlan'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.InsuranceCompanyPlan
	ALTER COLUMN ContactMiddleName VARCHAR(64)
END

IF 64 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'ContactLastName'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'InsuranceCompanyPlan'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.InsuranceCompanyPlan
	ALTER COLUMN ContactLastName VARCHAR(64)
END

--===========================================================================
-- MOD: PATIENT TABLE
--===========================================================================

IF 64 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'FirstName'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'Patient'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.Patient
	ALTER COLUMN FirstName VARCHAR(64)
END

IF 64 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'MiddleName'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'Patient'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.Patient
	ALTER COLUMN MiddleName VARCHAR(64)
END

IF 64 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'LastName'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'Patient'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.Patient
	ALTER COLUMN LastName VARCHAR(64)
END

IF 256 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'AddressLine1'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'Patient'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.Patient
	ALTER COLUMN AddressLine1 VARCHAR(256)
END

IF 256 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'AddressLine2'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'Patient'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.Patient
	ALTER COLUMN AddressLine2 VARCHAR(256)
END

IF 128 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'City'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'Patient'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.Patient
	ALTER COLUMN City VARCHAR(128)
END

IF 256 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'EmailAddress'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'Patient'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.Patient
	ALTER COLUMN EmailAddress VARCHAR(256)
END

IF 64 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'ResponsibleFirstName'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'Patient'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.Patient
	ALTER COLUMN ResponsibleFirstName VARCHAR(64)
END

IF 64 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'ResponsibleMiddleName'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'Patient'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.Patient
	ALTER COLUMN ResponsibleMiddleName VARCHAR(64)
END

IF 64 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'ResponsibleLastName'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'Patient'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.Patient
	ALTER COLUMN ResponsibleLastName VARCHAR(64)
END

IF 256 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'ResponsibleAddressLine1'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'Patient'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.Patient
	ALTER COLUMN ResponsibleAddressLine1 VARCHAR(256)
END

IF 256 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'ResponsibleAddressLine2'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'Patient'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.Patient
	ALTER COLUMN ResponsibleAddressLine2 VARCHAR(256)
END

IF 128 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'ResponsibleCity'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'Patient'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.Patient
	ALTER COLUMN ResponsibleCity VARCHAR(128)
END

--===========================================================================
-- MOD: PATIENT EMPLOYER TABLE
--===========================================================================

IF 128 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'EmployerName'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'PatientEmployer'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.PatientEmployer
	ALTER COLUMN EmployerName VARCHAR(128)
END

IF 256 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'AddressLine1'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'PatientEmployer'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.PatientEmployer
	ALTER COLUMN AddressLine1 VARCHAR(256)
END

IF 256 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'AddressLine2'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'PatientEmployer'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.PatientEmployer
	ALTER COLUMN AddressLine2 VARCHAR(256)
END

IF 128 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'City'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'PatientEmployer'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.PatientEmployer
	ALTER COLUMN City VARCHAR(128)
END

--===========================================================================
-- MOD: PATIENT INSURANCE TABLE
--===========================================================================

IF 64 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'HolderFirstName'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'PatientInsurance'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.PatientInsurance
	ALTER COLUMN HolderFirstName VARCHAR(64)
END

IF 64 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'HolderMiddleName'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'PatientInsurance'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.PatientInsurance
	ALTER COLUMN HolderMiddleName VARCHAR(64)
END

IF 64 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'HolderLastName'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'PatientInsurance'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.PatientInsurance
	ALTER COLUMN HolderLastName VARCHAR(64)
END

IF 256 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'HolderAddressLine1'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'PatientInsurance'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.PatientInsurance
	ALTER COLUMN HolderAddressLine1 VARCHAR(256)
END

IF 256 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'HolderAddressLine2'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'PatientInsurance'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.PatientInsurance
	ALTER COLUMN HolderAddressLine2 VARCHAR(256)
END

IF 128 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'HolderCity'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'PatientInsurance'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.PatientInsurance
	ALTER COLUMN HolderCity VARCHAR(128)
END

--===========================================================================
-- MOD: PRACTICE TABLE
--===========================================================================

IF 64 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'AdministrativeContactFirstName'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'Practice'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.Practice
	ALTER COLUMN AdministrativeContactFirstName VARCHAR(64)
END

IF 64 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'AdministrativeContactMiddleName'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'Practice'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.Practice
	ALTER COLUMN AdministrativeContactMiddleName VARCHAR(64)
END

IF 64 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'AdministrativeContactLastName'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'Practice'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.Practice
	ALTER COLUMN AdministrativeContactLastName VARCHAR(64)
END

IF 256 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'AdministrativeContactEmailAddress'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'Practice'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.Practice
	ALTER COLUMN AdministrativeContactEmailAddress VARCHAR(256)
END

IF 256 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'AddressLine1'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'Practice'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.Practice
	ALTER COLUMN AddressLine1 VARCHAR(256)
END

IF 256 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'AddressLine2'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'Practice'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.Practice
	ALTER COLUMN AddressLine2 VARCHAR(256)
END

IF 128 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'City'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'Practice'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.Practice
	ALTER COLUMN City VARCHAR(128)
END

--===========================================================================
-- MOD: PROCEDURE Code DICTIONARY TABLE
--===========================================================================

IF 100 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'ProcedureName'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'ProcedureCodeDictionary'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.ProcedureCodeDictionary
	ALTER COLUMN ProcedureName VARCHAR(100)
END

--===========================================================================
-- MOD: REFERRING PHYSICIAN TABLE
--===========================================================================

IF 64 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'FirstName'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'ReferringPhysician'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.ReferringPhysician
	ALTER COLUMN FirstName VARCHAR(64)
END

IF 64 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'MiddleName'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'ReferringPhysician'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.ReferringPhysician
	ALTER COLUMN MiddleName VARCHAR(64)
END

IF 64 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'LastName'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'ReferringPhysician'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.ReferringPhysician
	ALTER COLUMN LastName VARCHAR(64)
END

--===========================================================================
-- MOD: SERVICE LOCATION TABLE
--===========================================================================

IF 128 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'Name'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'ServiceLocation'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.ServiceLocation
	ALTER COLUMN [Name] VARCHAR(128)
END

IF 256 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'AddressLine1'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'ServiceLocation'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.ServiceLocation
	ALTER COLUMN AddressLine1 VARCHAR(256)
END

IF 256 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'AddressLine2'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'ServiceLocation'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.ServiceLocation
	ALTER COLUMN AddressLine2 VARCHAR(256) 
END

IF 128 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'City'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'ServiceLocation'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.ServiceLocation
	ALTER COLUMN City VARCHAR(128)
END

IF 128 > (
	SELECT	length
	FROM	SYSCOLUMNS
	WHERE	Name = 'BillingName'
	AND	id = (
		SELECT	id
		FROM	SYSOBJECTS
		WHERE	Name = 'ServiceLocation'
		AND	type = 'U'))
BEGIN
	ALTER TABLE dbo.ServiceLocation
	ALTER COLUMN BillingName VARCHAR(128)
END

