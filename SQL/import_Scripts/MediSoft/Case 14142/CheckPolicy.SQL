
Use superbill_0720_dev

Select * From VendorImport Order By VendorImportID Desc

-- ===================================
-- Check Policy on MediSoft Data Files.
Drop Table #RecentCases

Select A.chartnumber
	   , Convert( Varchar(50) , Max( Convert( Int , A.casenumber ) ) ) As casenumber Into #RecentCases
	From impMWCAS14142 A
            Inner Join impMWPAT14142 B On A.ChartNumber = B.ChartNumber
            Inner Join Patient C on A.chartnumber = C.vendorid
    Where B.PatientType <> 'Guarantor'
	Group By A.chartnumber
	Order By A.chartnumber

Select * From #recentcases Where chartnumber = 'WILPO000'

-- insurance policy 1.
select A.chartnumber , A.description , A.policynumber1 , A.groupnumber1 , A.policy1startdate , A.policy1enddate , A.insurancecarrier1
    from ipatientcase A
            inner join #recentcases B on A.chartnumber = B.chartnumber and A.casenumber = B.casenumber
            inner join iPatient C on A.chartnumber = C.chartnumber
            inner join patient D on C.chartnumber = D.vendorid
    where isnull( A.insurancecarrier1 , '' ) <> ''
            and isnull( C.patienttype , '' ) <> 'Guarantor'
    order by A.chartnumber

-- insurance policy 2.
drop table #tmp2

select A.chartnumber , A.casenumber , A.policynumber2 , A.groupnumber2 , A.insurancecarrier2 into #tmp2
    from ipatientcase A
            inner join #recentcases B on A.chartnumber = B.chartnumber and A.casenumber = B.casenumber
            inner join iPatient C on A.chartnumber = C.chartnumber
            inner join patient D on C.chartnumber = D.vendorid
    where isnull( insurancecarrier2 , '' ) <> ''
            and isnull( C.patienttype , '' ) <> 'Guarantor'
            and isnull( A.insurancecarrier2 , '' ) <> ''
            and D.vendorimportid = 4
    -- group by A.chartnumber , A.policynumber2 , A.groupnumber2 , A.insurancecarrier2 having count(*) > 1
    order by A.chartnumber

select A.*
    from #tmp2 A
    where not exists ( select B.* from insurancepolicy B where B.vendorid = A.insurancecarrier2 and B.policynumber = A.policynumber2 and B.groupnumber = A.groupnumber2 )

select * from iinscompany where code in ( 'CONLI' , 'KAISR' , 'PRUD' , 'SE&SM' )
select * from iPatient Where chartnumber = 'WILPO000'
select * from iPatientCase where chartnumber = 'WILPO000'
select * from PatientCase where vendorid = '831'
select * from insurancepolicy where patientcaseid = 13210
select * from insurancecompanyplan where vendorid = 'KAISR'
select * from insurancecompany where vendorid = 'KAISR'

-- insurance policy 3.
select A.chartnumber , A.description , A.policynumber3 , A.groupnumber3 , A.policy3startdate , A.policy3enddate
    from ipatientcase A
            inner join #recentcases B on A.chartnumber = B.chartnumber and A.casenumber = B.casenumber
            inner join iPatient C on A.chartnumber = C.chartnumber
            inner join patient D on C.chartnumber = D.vendorid
    where isnull( insurancecarrier3 , '' ) <> ''
            and isnull( C.patienttype , '' ) <> 'Guarantor'
    order by chartnumber

Select * From VendorImport Order By VendorImportID Desc
-- ===================================
Select *
    From InsuranceCompanyPlan A
    Where A.InsuranceCompanyID Not In ( Select InsuranceCompanyID From InsuranceCompany )
            And A.VendorImportID = 4

Select C.VendorID
      , A.Precedence
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
	Where A.VendorImportID = 4
			And Precedence = 2
   Order By C.FirstName , C.LastName

-- ===========================================
