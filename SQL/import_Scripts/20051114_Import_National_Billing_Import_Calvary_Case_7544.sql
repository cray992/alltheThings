ALTER TABLE ReferringPhysician
ADD VendorID int
GO

ALTER TABLE InsurancePolicy
ADD VendorID int
GO

BEGIN TRAN

INSERT INTO ReferringPhysician
	(VendorID, PracticeID, Prefix,FirstName,Middlename,LastName,Suffix,UPIN,WorkPhone,AddressLine1,AddressLine2,City,State,ZipCode,FaxPhone, CreatedDate,CreatedUserID,ModifiedDate,ModifiedUserID)
SELECT
	ReferringPhysicianID, 4, '','', '', Name, '', MedicaidProviderNumber, Phone1, Address1, Address2, City, State, ZipCode, Phone2, GETDATE(), 0, GETDATE(), 0
FROM
	ImportReferringPhysician$

INSERT INTO InsuranceCompany
	(VendorID, InsuranceCompanyName, AddressLine1, AddressLine2, City, State, ZipCode, Phone, 
	BillSecondaryInsurance, InsuranceProgramCode, ReviewCode, HCFADiagnosisReferenceFormatCode, HCFASameAsInsuredFormatCode, 
	EClaimsAccepts, CreatedDate,CreatedUserID,ModifiedDate,ModifiedUserID)
SELECT
	CAST (InsuranceCompanyID as varchar), InsuranceCompanyName, Address1,Address2,City,State,ZipCode,Phone,
	0, 'ZZ', 'R', 'C','D',0,GETDATE(), 0, GETDATE(), 0
FROM 
	ImportInsuranceCompany$

INSERT INTO InsuranceCompanyPlan
	(VendorID, PlanName, AddressLine1, AddressLine2, City,State,ZipCode,Phone, ReviewCode, InsuranceCompanyID, Copay, Deductible,CreatedDate,CreatedUserID,ModifiedDate,ModifiedUserID)
SELECT
	CAST (IIC.InsuranceCompanyID as varchar), IIC.InsuranceCompanyName, IIC.Address1,IIC.Address2,IIC.City,IIC.State,IIC.ZipCode,IIC.Phone,'R', IC.InsuranceCompanyID, 0,0,GETDATE(), 0, GETDATE(), 0
FROM
	ImportInsuranceCompany$ IIC
	INNER JOIN InsuranceCompany IC ON IC.VendorID = CAST(IIC.InsuranceCompanyID as varchar)

-- CreatedDate,CreatedUserID,ModifiedDate,ModifiedUserID)
-- GETDATE(), 0, GETDATE(), 0

INSERT INTO Patient
	(VendorID,PracticeID, Prefix,FirstName,MiddleName,LastName,Suffix,AddressLine1,AddressLine2,City,State,ZipCode,
	Gender,MaritalStatus,HomePhone,WorkPhone,DOB,SSN,Notes,
	ResponsibleDifferentThanPatient, ResponsibleRelationshipToPatient,ResponsiblePrefix,ResponsibleFirstName,ResponsibleMiddleName,ResponsibleLastName,ResponsibleSuffix,
	PrimaryProviderID,ReferringPhysicianID, CreatedDate,CreatedUserID,ModifiedDate,ModifiedUserID)
SELECT
	CAST(IP.PatientID AS varchar), 4, '', IP.FirstName, COALESCE(IP.MiddleName,''), IP.LastName, COALESCE(IP.Title,''), IP.Address1, IP.Address2, IP.City, IP.State, IP.ZipCode,
	IP.Sex, CASE WHEN IP.MaritalStatus IS NULL THEN 'U' WHEN IP.MaritalStatus='MI' THEN 'M' ELSE 'S' END, IP.Phone1, IP.Phone2, IP.DOB, IP.SSN, COALESCE(IP.Notes1 + ', ', IP.Notes2),
	CASE WHEN IP.RelToPatient = 'Self' THEN 0 ELSE 1 END, CASE WHEN IP.RelToPatient <> 'Self' THEN 'C' ELSE NULL END, '', CASE WHEN IP.RelToPatient <> 'Self' THEN IP.GuarantorFirstName ELSE NULL END, CASE WHEN IP.RelToPatient <> 'Self' THEN IP.GuarantorMiddleName ELSE NULL END, CASE WHEN IP.RelToPatient <> 'Self' THEN IP.GuarantorLastName ELSE NULL END, CASE WHEN IP.RelToPatient <> 'Self' THEN IP.GuarantorTitle ELSE NULL END,
	9, RP.ReferringPhysicianID, GETDATE(), 0, GETDATE(), 0
FROM
	ImportPatient$ IP
	LEFT OUTER JOIN ReferringPhysician RP
		ON RP.VendorID = CAST(IP.ReferringPhysiciianID as varchar)



INSERT INTO PatientCase
	(PracticeID, PatientID, Name, Active, PayerScenarioID /* 5 */, ReferringPhysicianID, 
	EmploymentRelatedFlag, AutoAccidentRelatedFlag,AbuseRelatedFlag, ShowExpiredInsurancePolicies, CreatedDate,CreatedUserID,ModifiedDate,ModifiedUserID)
SELECT
	4, P.PatientID, 'Case 1', 1, 5, P.ReferringPhysicianID, 0, 0, 0, 0, GETDATE(), 0, GETDATE(), 0
FROM
	Patient P 
	INNER JOIN ImportPatient$ IP ON P.VendorID = CAST(IP.PatientID as varchar)


INSERT INTO InsurancePolicy
	(PracticeID, PatientCaseID, 
	InsuranceCompanyPlanID, Precedence, PolicyNumber, GroupNumber, PolicyStartDate,PolicyEndDate, CardOnFile, 
	HolderDifferentThanPatient, PatientRelationshipToInsured, 
	HolderFirstName, HolderMiddleName, HolderLastName, HolderSuffix, 
	HolderAddressLine1, HolderAddressLine2, HolderCity, HolderState, HolderZipCode, HolderPhone, HolderDOB, HolderGender, 
	Notes, CreatedDate,CreatedUserID,ModifiedDate,ModifiedUserID)
SELECT
	4, (SELECT TOP 1 PatientCaseID FROM PatientCase WHERE PatientCase.PatientID = P.PatientID),
	ICP.InsuranceCompanyPlanID, IPI.PrimarySecondary, IPI.PolicyNumber, IPI.GroupNumber, IPI.EffectiveDate, IPI.ExpirationDate, 1,
	CASE WHEN IPI.Relationship = 'Self' THEN 0 ELSE 1 END, CASE WHEN IPI.Relationship <> 'Self' THEN 'C' ELSE 'S' END, 
	CASE WHEN IPI.Relationship <> 'Self' THEN IPI.HolderFirstName ELSE NULL END, CASE WHEN IPI.Relationship <> 'Self' THEN IPI.HolderMiddleName ELSE NULL END, CASE WHEN IPI.Relationship <> 'Self' THEN IPI.HolderLastName ELSE NULL END, CASE WHEN IPI.Relationship <> 'Self' THEN IPI.HolderTitle ELSE NULL END,
	CASE WHEN IPI.Relationship <> 'Self' THEN IPI.Address1 ELSE NULL END, CASE WHEN IPI.Relationship <> 'Self' THEN IPI.Address2 ELSE NULL END, CASE WHEN IPI.Relationship <> 'Self' THEN IPI.City ELSE NULL END, CASE WHEN IPI.Relationship <> 'Self' THEN IPI.State ELSE NULL END, CASE WHEN IPI.Relationship <> 'Self' THEN IPI.ZipCode ELSE NULL END, CASE WHEN IPI.Relationship <> 'Self' THEN IPI.Phone ELSE NULL END, CASE WHEN IPI.Relationship <> 'Self' THEN IPI.InsuredDOB ELSE NULL END, CASE WHEN IPI.Relationship <> 'Self' THEN IPI.InsuredSex ELSE NULL END,
	COALESCE(COALESCE(Notes1 + ', ', Notes2) + ', ', Notes3),GETDATE(), 0, GETDATE(), 0
FROM
	ImportPatientInsurance$ IPI
	INNER JOIN Patient P ON P.VendorID = CAST(IPI.PatientID as varchar)
	INNER JOIN InsuranceCompanyPlan ICP ON ICP.VendorID = CAST(IPI.InsuranceCompanyID as varchar)

-- ROLLBACK
-- COMMIT
