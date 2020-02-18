USE superbill_39795_prod
GO

SELECT * FROM dbo.InsuranceCompany WHERE InsuranceCompanyID IN (72,56494)
SELECT * FROM dbo.PracticeToInsuranceCompany WHERE InsuranceCompanyID IN (72,56494) AND PracticeID IN (1,47)

select * 
FROM dbo.ClearinghouseResponse C WITH (NOLOCK)


SET XACT_ABORT ON

BEGIN TRANSACTION
--rollback
--commit

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 47
SET @VendorImportID = 93

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

UPDATE i SET 
i.BillingFormID = q.billingformid,
i.SecondaryPrecedenceBillingFormID = q.secondaryprecedencebillingformid
--select i.CreatedPracticeID,* 
FROM dbo.InsuranceCompany i 
	INNER JOIN dbo._import_98_47_InsuranceCompany q ON 
		q.InsuranceCompanyName = i.InsuranceCompanyName
WHERE i.createdpracticeid = 47 

UPDATE i SET 
i.VendorID = q.insurancecompanyid
--select i.CreatedPracticeID,i.* 
FROM dbo.InsuranceCompany i 
	INNER JOIN dbo._import_98_47_InsuranceCompany q ON 
		q.InsuranceCompanyName = i.InsuranceCompanyName
WHERE i.createdpracticeid = @PracticeID 
DELETE FROM dbo.PracticeToInsuranceCompany WHERE practiceid =47 

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
          @PracticeID , -- PracticeID - int
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          NULL, -- EClaimsProviderID - varchar(32)
          ptic.eclaimsenrollmentstatusid , -- EClaimsEnrollmentStatusID - int
          ptic.eclaimsdisable , -- EClaimsDisable - int
          ptic.acceptassignment  , -- AcceptAssignment - bit
          i.usesecondaryelectronicbilling , -- UseSecondaryElectronicBilling - bit
          ptic.usecoordinationofbenefits  , -- UseCoordinationOfBenefits - bit
          ptic.excludepatientpayment  , -- ExcludePatientPayment - bit
          ptic.balancetransfer  -- BalanceTransfer - bit
		  --SELECT * 
FROM dbo.[PracticeToInsuranceCompany] ptic
	INNER JOIN dbo.InsuranceCompany ic ON
		CAST(ptic.insurancecompanyid AS VARCHAR) = ic.VendorID AND
		ic.VendorImportID = 93 AND 
		ic.CreatedPracticeID = 47
	INNER JOIN dbo._import_98_47_ptic i ON 
		i.insurancecompanyid = ic.VendorID
WHERE ptic.practiceid = 1
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

UPDATE pr SET 
pr.UseSecondaryElectronicBilling = i.usesecondaryelectronicbilling,
pr.EClaimsEnrollmentStatusID = i.eclaimsenrollmentstatusid,
pr.EClaimsDisable = i.eclaimsdisable,
pr.AcceptAssignment = i.acceptassignment,
pr.UseCoordinationOfBenefits = i.usecoordinationofbenefits,
pr.ExcludePatientPayment = i.excludepatientpayment,
pr.BalanceTransfer = i.balancetransfer,
pr.IsEnrollable = i.isenrollable,
pr.EClaimsProviderID = i.eclaimsproviderid
--SELECT ic.insurancecompanyname,pr.* 
FROM dbo.PracticeToInsuranceCompany pr
	INNER JOIN dbo.InsuranceCompany ic ON 
		ic.InsuranceCompanyID = pr.InsuranceCompanyID
	INNER JOIN dbo._import_101_47_practicetoinscompany i ON 
		i.insurancecompanyname = ic.InsuranceCompanyName
WHERE pr.PracticeID = 47

commit
--SELECT * FROM dbo._import_98_47_ptic

--DELETE  
SELECT * FROM dbo.PracticeToInsuranceCompany WHERE PracticeID = 1
SELECT * FROM dbo._import_0_47_ptic
SELECT * FROM dbo.PracticeToInsuranceCompany WHERE practiceid = 47

SELECT ic.InsuranceCompanyName,ptic.* FROM insurancecompany ic
INNER JOIN dbo.PracticeToInsuranceCompany ptic ON 
ptic.InsuranceCompanyID = ic.InsuranceCompanyID
WHERE ptic.PracticeID = 1 AND ic.CreatedPracticeID = 1 ORDER BY InsuranceCompanyName

SELECT * FROM insurancecompany WHERE CreatedPracticeID = 47 ORDER BY InsuranceCompanyName


