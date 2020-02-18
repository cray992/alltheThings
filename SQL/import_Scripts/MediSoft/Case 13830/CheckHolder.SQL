Use superbill_0524_dev

Drop Table #RecentCases

Select A.ChartNumber , Convert( Varchar(10) , Max( Convert( Int , CaseNumber ) ) ) As CaseNumber
        Into #RecentCases
    From impMWCAS A
    Group By A.ChartNumber
    Order By A.ChartNumber

Select * From VendorImport Order By VendorImportID Desc

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
			And Precedence = 2
         And IsNull( HolderLastName , '' ) <> ''
  Order By C.FirstName , C.LastName

          
Select A.ChartNumber
        , C.LastName
        , C.FirstName
        , C.Sex
        , C.DateOfBirth
        , DateDiff( yy , Convert( DateTime , C.DateOfBirth ) , GetDate() ) As Age
        , A.Insured1
        , D.LastName
        , D.FirstName
        , D.Sex
        , D.DateOfBirth
        , DateDiff( yy , Convert( DateTime , D.DateOfBirth ) , GetDate() ) As Age
    From impMWCAS A
            Inner Join #RecentCases B On A.ChartNumber = B.ChartNumber And A.CaseNumber = B.CaseNumber
            Inner Join impMWPAT C On A.ChartNumber = C.ChartNumber
            Inner Join impMWPAT D On A.Insured2 = D.ChartNumber
    Where IsNull( A.Insured1 , '' ) <> IsNull( A.ChartNumber , '' ) And IsNull( A.Insured1 , '' ) <> ''
            And IsNull( A.InsuranceCarrier1 , '' ) <> ''
            And C.PatientType <> 'Guarantor'
    Order By C.LastName , C.FirstName
