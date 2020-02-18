USE superbill_31776_dev
--USE superbill_31776_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON


PRINT ''
PRINT 'Updating Insurance Company...'
UPDATE dbo.InsuranceCompany 
SET AddressLine1 = i.clmaddr ,
	AddressLine2 = i.clmattn
FROM dbo.InsuranceCompany ic
INNER JOIN dbo.[_import_1_1_InsPlanClmfiledat] i ON
i.clmcono = ic.VendorID AND
ic.VendorImportID = 1
WHERE ic.ModifiedUserID = 0 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


PRINT ''
PRINT 'Updating Insurance Company Plan...'
UPDATE dbo.InsuranceCompanyPlan 
SET AddressLine1 = i.clmaddr ,
	AddressLine2 = i.clmattn
FROM dbo.InsuranceCompanyPlan icp
INNER JOIN dbo.[_import_1_1_InsPlanClmfiledat] i ON
i.clmcono = icp.VendorID AND
icp.VendorImportID = 1
WHERE icp.ModifiedUserID = 0 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


--ROLLBACK
--COMMIT

