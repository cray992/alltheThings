PRINT ''
PRINT 'Inserting Into PracticetoInsurance Company...'
INSERT INTO dbo.PracticeToInsuranceCompany
(
PracticeID ,
InsuranceCompanyID ,
CreatedDate ,
CreatedUserID ,
ModifiedDate ,
ModifiedUserID ,
EClaimsProviderID ,
EClaimsEnrollmentStatusID ,
EClaimsDisable ,
AcceptAssignment ,
UseSecondaryElectronicBilling ,
UseCoordinationOfBenefits ,
ExcludePatientPayment ,
BalanceTransfer
)
SELECT DISTINCT
@TargetPracticeID , -- PracticeID - int
ic.InsuranceCompanyID , -- InsuranceCompanyID - int
GETDATE() , -- CreatedDate - datetime
0 , -- CreatedUserID - int
GETDATE() , -- ModifiedDate - datetime
0 , -- ModifiedUserID - int
NULL , -- EClaimsProviderID - varchar(32)
ptic.EClaimsEnrollmentStatusID , -- EClaimsEnrollmentStatusID - int
ptic.EClaimsDisable , -- EClaimsDisable - int
ptic.acceptassignment , -- AcceptAssignment - bit
ptic.usesecondaryelectronicbilling , -- UseSecondaryElectronicBilling - bit
ptic.usecoordinationofbenefits , -- UseCoordinationOfBenefits - bit
ptic.excludepatientpayment , -- ExcludePatientPayment - bit
ptic.balancetransfer -- BalanceTransfer - bit
FROM dbo.PracticeToInsuranceCompany ptic
INNER JOIN dbo.InsuranceCompany ic ON
ptic.insurancecompanyid = ic.VendorID AND
ic.VendorImportID = @VendorImportID AND ic.CreatedPracticeID=@targetpracticeId
WHERE ptic.practiceid = @SourcePracticeID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
