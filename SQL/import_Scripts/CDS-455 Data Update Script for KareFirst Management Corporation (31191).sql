USE superbill_31191_dev
--USE superbill_XXX_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 4 -- Vendor import record created through import tool
 
PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))
 
-- Clear out any existing records for this import, (makes the script safe to run multiple times)
--PRINT ''
--PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

UPDATE dbo.InsuranceCompany SET AddressLine1=PayerAddress1,AddressLine2=PayerAddress2,City=Payercity,State=Payerstate,ZipCode=payerzip FROM dbo._import_4_1_PayerListing AS ipl
INNER JOIN dbo.InsuranceCompany AS ic ON
   ic.InsuranceCompanyName=ipl.payername AND
   ic.VendorImportID=2
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records updated into Insurance Company Successfully'

PRINT''
UPDATE dbo.InsuranceCompanyPlan SET AddressLine1=PayerAddress1,AddressLine2=PayerAddress2,city=Payercity,State=Payerstate,ZipCode=payerzip FROM dbo._import_4_1_PayerListing AS ipl
INNER JOIN dbo.InsuranceCompanyPlan AS inscoplan ON
   inscoplan.PlanName=ipl.payername AND
   inscoplan.VendorImportID=2
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records updated into Insurance Company Plan Successfully'

--ROLLBACK
--COMMIT

