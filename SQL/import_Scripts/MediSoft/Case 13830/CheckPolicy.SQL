
Use superbill_0524_dev

Select * From VendorImport Order By VendorImportID Desc

-- ===================================
-- Check Policy on MediSoft Data Files.
Drop Table #RecentCases

Select A.chartnumber
	   , Convert( Varchar(50) , Max( Convert( Int , A.casenumber ) ) ) As casenumber Into #RecentCases
	From iPatientCase A
            Inner Join iPatient B On A.ChartNumber = B.ChartNumber
    Where B.PatientType <> 'Guarantor'
	Group By A.chartnumber
	Order By A.chartnumber

Select * From #recentcases

select top 1 * from ipatient

-- insurance policy 1.
select A.chartnumber , A.description , A.policynumber1 , A.groupnumber1 , A.policy1startdate , A.policy1enddate , A.insurancecarrier1
    from ipatientcase A
            inner join #recentcases B on A.chartnumber = B.chartnumber and A.casenumber = B.casenumber
            inner join iPatient C on A.chartnumber = C.chartnumber
    where isnull( insurancecarrier1 , '' ) <> ''
            and isnull( C.patienttype , '' ) <> 'Guarantor'
    order by chartnumber

-- insurance policy 2.
select A.chartnumber , A.description , A.policynumber2 , A.groupnumber2 , A.policy2startdate , A.policy2enddate , A.insurancecarrier2
    from ipatientcase A
            inner join #recentcases B on A.chartnumber = B.chartnumber and A.casenumber = B.casenumber
            inner join iPatient C on A.chartnumber = C.chartnumber
    where isnull( insurancecarrier2 , '' ) <> ''
            and isnull( C.patienttype , '' ) <> 'Guarantor'
    order by chartnumber

-- insurance policy 3.
select A.chartnumber , A.description , A.policynumber3 , A.groupnumber3 , A.policy3startdate , A.policy3enddate
    from ipatientcase A
            inner join #recentcases B on A.chartnumber = B.chartnumber and A.casenumber = B.casenumber
            inner join iPatient C on A.chartnumber = C.chartnumber
    where isnull( insurancecarrier3 , '' ) <> ''
            and isnull( C.patienttype , '' ) <> 'Guarantor'
    order by chartnumber

-- ===================================

Select *
    From InsuranceCompanyPlan A
    Where A.InsuranceCompanyID Not In ( Select InsuranceCompanyID From InsuranceCompany )
            And A.VendorImportID = 5

Select C.VendorID
		, C.FirstName
		, C.MiddleName
		, C.LastName
      , B.Name As PatientCase
		, E.InsuranceCompanyName
		, D.PlanName As PlanName
      , A.Precedence
		, A.PolicyNumber
		, A.GroupNumber
		, Convert( Char(10) , A.PolicyStartDate , 101 ) As PolicyStartDate
		, Convert( Char(10) , A.PolicyEndDate , 101 ) As PolicyEndDate
	From InsurancePolicy A
			Inner Join PatientCase B On A.PatientCaseID = B.PatientCaseID
			Inner Join Patient C On B.PatientID = C.PatientID
			Inner Join InsuranceCompanyPlan D On A.InsuranceCompanyPlanID = D.InsuranceCompanyPlanID
			Inner Join InsuranceCompany E On D.InsuranceCompanyID = E.InsuranceCompanyID
	Where A.VendorImportID = 5
			And Precedence = 3
  Order By C.FirstName , C.LastName

