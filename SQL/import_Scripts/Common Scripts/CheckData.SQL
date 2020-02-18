-- Common Script.
-- Checks the validation of the import.

Use superbill_0720_prod
Go

-- Check Insurance Policy After Import.
Select * From VendorImport

Select C.VendorID
        , B.Name
		, C.LastName
		, C.FirstName
		, C.MiddleName
		, E.InsuranceCompanyName
		, D.PlanName As PlanName
		, A.PolicyNumber
		, A.GroupNumber
		, Convert( Char(10) , A.PolicyStartDate , 101 ) As PolicyStartDate
		, Convert( Char(10) , A.PolicyEndDate , 101 ) As PolicyEndDate
	From InsurancePolicy A
			Inner Join PatientCase B On A.PatientCaseID = B.PatientCaseID
			Inner Join Patient C On B.PatientID = C.PatientID
			Inner Join InsuranceCompanyPlan D On A.InsuranceCompanyPlanID = D.InsuranceCompanyPlanID
			Inner Join InsuranceCompany E On D.InsuranceCompanyID = E.InsuranceCompanyID
	Where A.VendorImportID = 1
			And Precedence = 3

Declare @vendorimportid int
Select @vendorimportid = 1
Select Count(*) As PatientCount From patient Where vendorimportid = @vendorimportid
Select Count(*) As PatientCaseCount From patientcase Where vendorimportid = @vendorimportid
Select Count(*) As DoctorCount From doctor Where vendorimportid = @vendorimportid
Select Count(*) As InsuranceCompanyCount From insurancecompany Where vendorimportid = @vendorimportid
Select Count(*) As InsuranceCompanyPlanCount From insurancecompanyplan Where vendorimportid = @vendorimportid
Select Count(*) As InsurancePolicyCount From insurancepolicy Where vendorimportid = @vendorimportid


-- Check Responsible and Holder Information.
Select B.VendorID
		, B.FirstName
		, B.LastName
		, Convert( Char(10) , B.DOB , 101 ) As DOB
		, B.ResponsibleFirstName
		, B.ResponsibleLastName
		, B.ResponsibleRelationshipToPatient
		, A.PatientRelationshipToInsured
		, A.HolderFirstName
		, A.HolderLastName
		, B.ResponsibleDifferentThanPatient
	From insurancepolicy A
			inner join PatientCase C On A.PatientCaseID = C.PatientCaseID
			inner join Patient B On C.PatientID = B.PatientID
	Where IsNull( A.PatientRelationshiptoInsured , '' ) <> 'S'
			And A.vendorimportid = 15
