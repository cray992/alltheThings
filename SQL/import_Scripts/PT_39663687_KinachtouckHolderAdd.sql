USE superbill_10799_dev
--USE superbill_10799_prod
GO


UPDATE dbo.InsurancePolicy
	SET
		HolderFirstName = (SELECT subfirstn FROM dbo.[_import_6_1_PatientDemos] p
							WHERE ip.VendorID = p.[chart] + '_' + p.[coveragelev]),
		 HolderLastName =(SELECT sublastn FROM dbo.[_import_6_1_PatientDemos] p
							WHERE ip.VendorID = p.[chart] + '_' + p.[coveragelev]),
		HolderDOB = (SELECT subdob FROM dbo.[_import_6_1_PatientDemos] p
							WHERE ip.VendorID = p.[chart] + '_' + p.[coveragelev]),
		HolderGender = (SELECT subsex FROM dbo.[_import_6_1_PatientDemos] p
							WHERE ip.VendorID = p.[chart] + '_' + p.[coveragelev]),
		PatientRelationshipToInsured = 'O'
						
	FROM dbo.InsurancePolicy ip
	JOIN dbo.[_import_6_1_PatientDemos] pd ON
	 ip.vendorID = pd.chart + '_' + pd.coveragelev
	WHERE ip.VendorImportId = 6
	AND pd.firstname <> pd.subfirstn
	

UPDATE dbo.InsurancePolicy
	SET
		HolderFirstName = (SELECT sub_firstn FROM dbo.[_import_5_1_PatientDemos] p
							WHERE ip.VendorID = p.[chart_#] + '_' + p.[coverage_lev]),
		 HolderLastName =(SELECT sub_lastn FROM dbo.[_import_5_1_PatientDemos] p
							WHERE ip.VendorID = p.[chart_#] + '_' + p.[coverage_lev]),
		HolderDOB = (SELECT sub_dob FROM dbo.[_import_5_1_PatientDemos] p
							WHERE ip.VendorID = p.[chart_#] + '_' + p.[coverage_lev]),
		HolderGender = (SELECT sub_sex FROM dbo.[_import_5_1_PatientDemos] p
							WHERE ip.VendorID = p.[chart_#] + '_' + p.[coverage_lev]),
		PatientRelationshipToInsured = 'O'
						
	FROM dbo.InsurancePolicy ip
	JOIN dbo.[_import_5_1_PatientDemos] pd ON
	 ip.vendorID = pd.chart_# + '_' + pd.coverage_lev
	WHERE ip.VendorImportId = 5
	AND pd.first_name <> pd.sub_firstn
	
	
	
	
	
/*	
SELECT InsurancePolicyID, ip.PatientCaseID, HolderFirstName, HolderLastName, p.FirstName, p.LastName FROM dbo.InsurancePolicy ip
JOIN dbo.[_import_6_1_PatientDemos] pd ON
	ip.VendorID = pd.chart + '_' + pd.coveragelev
JOIN dbo.PatientCase pc ON ip.PatientCaseID = pc.PatientCaseID
JOIN dbo.patient p ON pc.PatientID = p.PatientID
where PD.firstname <> Pd.subfirstn

	

SELECT TOP 10 * FROM dbo.[_import_5_1_PatientDemos]

*/

UPDATE dbo.InsurancePolicy
	SET DependentPolicyNumber = PolicyNumber
	FROM dbo.InsurancePolicy ip
	JOIN dbo.[_import_6_1_PatientDemos] pd ON
	 ip.vendorID = pd.chart + '_' + pd.coveragelev
	WHERE ip.VendorImportId = 6
	AND pd.firstname <> pd.subfirstn
	

UPDATE dbo.InsurancePolicy
	SET DependentPolicyNumber = PolicyNumber
	FROM dbo.InsurancePolicy ip
	JOIN dbo.[_import_5_1_PatientDemos] pd ON
	 ip.vendorID = pd.chart_# + '_' + pd.coverage_lev
	WHERE ip.VendorImportId = 5
	AND pd.first_name <> pd.sub_firstn