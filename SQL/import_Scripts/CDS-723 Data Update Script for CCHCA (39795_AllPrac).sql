--USE superbill_39795_dev
USE superbill_39795_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

-- Delcaring PracticeIDs since running this script for each individual practice is time expensive for NetOps

DECLARE @CrawfordChung INT
DECLARE @DominicTse INT
DECLARE @EdwardChan INT
DECLARE @EricLeung INT
DECLARE @ErvinWong INT
DECLARE @HoTan INT
DECLARE @JewandJew INT
DECLARE @JonYang INT
DECLARE @JoySanFran INT
DECLARE @JustinQuock INT
DECLARE @KennethChang INT
DECLARE @KevinZhaoApollo INT
DECLARE @LisaLaw INT
DECLARE @MartinLeung INT
DECLARE @PacificEnt INT
DECLARE @QingQuan INT
DECLARE @SimonLee INT
DECLARE @WilliamChung INT
DECLARE @RogerWang INT
DECLARE @RandallLow INT

SET @CrawfordChung = 20
SET @DominicTse = 15
SET @EdwardChan = 16
SET @EricLeung = 21
SET @ErvinWong = 19
SET @HoTan = 6
SET @JewandJew = 9
SET @JonYang = 5
SET @JoySanFran = 11
SET @JustinQuock = 1
SET @KennethChang = 8
SET @KevinZhaoApollo = 24
SET @LisaLaw = 13
SET @MartinLeung = 23
SET @PacificEnt = 7
SET @QingQuan = 14
SET @SimonLee = 4
SET @WilliamChung = 18
SET @RogerWang = 12
SET @RandallLow = 10


SET NOCOUNT ON 


PRINT ''
PRINT 'Updating Insurance Policy - Policy - PracticeID ' + CAST(@CrawfordChung AS VARCHAR) + '...'
UPDATE dbo.InsurancePolicy
	SET PolicyNumber = i.policynbr --, 
		--InsuranceCompanyPlanID = CASE WHEN icp.InsuranceCompanyPlanID IS NULL THEN ip.InsuranceCompanyPlanID ELSE icp.InsuranceCompanyPlanID END
FROM dbo.InsurancePolicy ip
INNER JOIN dbo.PatientCase pc ON 
	ip.PatientCaseID = pc.PatientCaseID AND 
	ip.PracticeID = @CrawfordChung AND
    pc.VendorImportID IS NOT NULL AND
	pc.VendorID IS NOT NULL AND 
	pc.CreatedUserID = 0
INNER JOIN dbo.Patient p ON 
	pc.PatientID = p.PatientID AND 
	p.PracticeID = @CrawfordChung
INNER JOIN dbo.[_import_46_1_CrawfordChung20] i ON 
	p.PatientID = i.kareopatientid AND 
	i.defcob = ip.Precedence
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	i.payername = icp.PlanName AND 
	i.addressline1 = icp.AddressLine1 AND 
	i.zip = icp.ZipCode
WHERE i.kareopatientid <> '#N/A' AND ip.PolicyNumber <> i.policynbr
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Insurance Policy - Policy - PracticeID ' + CAST(@DominicTse AS VARCHAR) + '...'
UPDATE dbo.InsurancePolicy
	SET PolicyNumber = i.policynbr --, 
		--InsuranceCompanyPlanID = CASE WHEN icp.InsuranceCompanyPlanID IS NULL THEN ip.InsuranceCompanyPlanID ELSE icp.InsuranceCompanyPlanID END
FROM dbo.InsurancePolicy ip
INNER JOIN dbo.PatientCase pc ON 
	ip.PatientCaseID = pc.PatientCaseID AND 
	ip.PracticeID = @DominicTse AND
    pc.VendorImportID IS NOT NULL AND
	pc.VendorID IS NOT NULL AND 
	pc.CreatedUserID = 0
INNER JOIN dbo.Patient p ON 
	pc.PatientID = p.PatientID AND 
	p.PracticeID = @DominicTse
INNER JOIN dbo.[_import_46_1_DominicTse15] i ON 
	p.PatientID = i.kareopatientid AND 
	i.defcob = ip.Precedence
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	i.payername = icp.PlanName AND 
	i.addressline1 = icp.AddressLine1 AND 
	i.zip = icp.ZipCode
WHERE i.kareopatientid <> '#N/A' AND ip.PolicyNumber <> i.policynbr
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Insurance Policy - Policy - PracticeID ' + CAST(@EdwardChan AS VARCHAR) + '...'
UPDATE dbo.InsurancePolicy
	SET PolicyNumber = i.policynbr --, 
		--InsuranceCompanyPlanID = CASE WHEN icp.InsuranceCompanyPlanID IS NULL THEN ip.InsuranceCompanyPlanID ELSE icp.InsuranceCompanyPlanID END
FROM dbo.InsurancePolicy ip
INNER JOIN dbo.PatientCase pc ON 
	ip.PatientCaseID = pc.PatientCaseID AND 
	ip.PracticeID = @EdwardChan AND
    pc.VendorImportID IS NOT NULL AND
	pc.VendorID IS NOT NULL AND 
	pc.CreatedUserID = 0
INNER JOIN dbo.Patient p ON 
	pc.PatientID = p.PatientID AND 
	p.PracticeID = @EdwardChan
INNER JOIN dbo.[_import_46_1_EdwardChan16] i ON 
	p.PatientID = i.kareopatientid AND 
	i.defcob = ip.Precedence
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	i.payername = icp.PlanName AND 
	i.addressline1 = icp.AddressLine1 AND 
	i.zip = icp.ZipCode
WHERE i.kareopatientid <> '#N/A' AND ip.PolicyNumber <> i.policynbr
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Insurance Policy - Policy - PracticeID ' + CAST(@EricLeung AS VARCHAR) + '...'
UPDATE dbo.InsurancePolicy
	SET PolicyNumber = i.policynbr --, 
		--InsuranceCompanyPlanID = CASE WHEN icp.InsuranceCompanyPlanID IS NULL THEN ip.InsuranceCompanyPlanID ELSE icp.InsuranceCompanyPlanID END
FROM dbo.InsurancePolicy ip
INNER JOIN dbo.PatientCase pc ON 
	ip.PatientCaseID = pc.PatientCaseID AND 
	ip.PracticeID = @EricLeung AND
    pc.VendorImportID IS NOT NULL AND
	pc.VendorID IS NOT NULL AND 
	pc.CreatedUserID = 0
INNER JOIN dbo.Patient p ON 
	pc.PatientID = p.PatientID AND 
	p.PracticeID = @EricLeung
INNER JOIN dbo.[_import_46_1_EricLeung21] i ON 
	p.PatientID = i.kareopatientid AND 
	i.defcob = ip.Precedence
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	i.payername = icp.PlanName AND 
	i.addressline1 = icp.AddressLine1 AND 
	i.zip = icp.ZipCode
WHERE i.kareopatientid <> '#N/A' AND ip.PolicyNumber <> i.policynbr
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Insurance Policy - Policy - PracticeID ' + CAST(@ErvinWong AS VARCHAR) + '...'
UPDATE dbo.InsurancePolicy
	SET PolicyNumber = i.policynbr --, 
		--InsuranceCompanyPlanID = CASE WHEN icp.InsuranceCompanyPlanID IS NULL THEN ip.InsuranceCompanyPlanID ELSE icp.InsuranceCompanyPlanID END
FROM dbo.InsurancePolicy ip
INNER JOIN dbo.PatientCase pc ON 
	ip.PatientCaseID = pc.PatientCaseID AND 
	ip.PracticeID = @ErvinWong AND
    pc.VendorImportID IS NOT NULL AND
	pc.VendorID IS NOT NULL AND 
	pc.CreatedUserID = 0
INNER JOIN dbo.Patient p ON 
	pc.PatientID = p.PatientID AND 
	p.PracticeID = @ErvinWong
INNER JOIN dbo.[_import_46_1_ErvinWong19] i ON 
	p.PatientID = i.kareopatientid AND 
	i.defcob = ip.Precedence
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	i.payername = icp.PlanName AND 
	i.addressline1 = icp.AddressLine1 AND 
	i.zip = icp.ZipCode
WHERE i.kareopatientid <> '#N/A' AND ip.PolicyNumber <> i.policynbr
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Insurance Policy - Policy - PracticeID ' + CAST(@HoTan AS VARCHAR) + '...'
UPDATE dbo.InsurancePolicy
	SET PolicyNumber = i.policynbr --, 
		--InsuranceCompanyPlanID = CASE WHEN icp.InsuranceCompanyPlanID IS NULL THEN ip.InsuranceCompanyPlanID ELSE icp.InsuranceCompanyPlanID END
FROM dbo.InsurancePolicy ip
INNER JOIN dbo.PatientCase pc ON 
	ip.PatientCaseID = pc.PatientCaseID AND 
	ip.PracticeID = @HoTan AND
    pc.VendorImportID IS NOT NULL AND
	pc.VendorID IS NOT NULL AND 
	pc.CreatedUserID = 0
INNER JOIN dbo.Patient p ON 
	pc.PatientID = p.PatientID AND 
	p.PracticeID = @HoTan
INNER JOIN dbo.[_import_46_1_HoTan6] i ON 
	p.PatientID = i.kareopatientid AND 
	i.defcob = ip.Precedence
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	i.payername = icp.PlanName AND 
	i.addressline1 = icp.AddressLine1 AND 
	i.zip = icp.ZipCode
WHERE i.kareopatientid <> '#N/A' AND ip.PolicyNumber <> i.policynbr
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Insurance Policy - Policy - PracticeID ' + CAST(@JewandJew AS VARCHAR) + '...'
UPDATE dbo.InsurancePolicy
	SET PolicyNumber = i.policynbr --, 
		--InsuranceCompanyPlanID = CASE WHEN icp.InsuranceCompanyPlanID IS NULL THEN ip.InsuranceCompanyPlanID ELSE icp.InsuranceCompanyPlanID END
FROM dbo.InsurancePolicy ip
INNER JOIN dbo.PatientCase pc ON 
	ip.PatientCaseID = pc.PatientCaseID AND 
	ip.PracticeID = @JewandJew AND
    pc.VendorImportID IS NOT NULL AND
	pc.VendorID IS NOT NULL AND 
	pc.CreatedUserID = 0
INNER JOIN dbo.Patient p ON 
	pc.PatientID = p.PatientID AND 
	p.PracticeID = @JewandJew
INNER JOIN dbo.[_import_46_1_JewandJew9] i ON 
	p.PatientID = i.kareopatientid AND 
	i.defcob = ip.Precedence
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	i.payername = icp.PlanName AND 
	i.addressline1 = icp.AddressLine1 AND 
	i.zip = icp.ZipCode
WHERE i.kareopatientid <> '#N/A' AND ip.PolicyNumber <> i.policynbr
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Insurance Policy - Policy - PracticeID ' + CAST(@JonYang AS VARCHAR) + '...'
UPDATE dbo.InsurancePolicy
	SET PolicyNumber = i.policynbr --, 
		--InsuranceCompanyPlanID = CASE WHEN icp.InsuranceCompanyPlanID IS NULL THEN ip.InsuranceCompanyPlanID ELSE icp.InsuranceCompanyPlanID END
FROM dbo.InsurancePolicy ip
INNER JOIN dbo.PatientCase pc ON 
	ip.PatientCaseID = pc.PatientCaseID AND 
	ip.PracticeID = @JonYang AND
    pc.VendorImportID IS NOT NULL AND
	pc.VendorID IS NOT NULL AND 
	pc.CreatedUserID = 0
INNER JOIN dbo.Patient p ON 
	pc.PatientID = p.PatientID AND 
	p.PracticeID = @JonYang
INNER JOIN dbo.[_import_46_1_JonYang5] i ON 
	p.PatientID = i.kareopatientid AND 
	i.defcob = ip.Precedence
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	i.payername = icp.PlanName AND 
	i.addressline1 = icp.AddressLine1 AND 
	i.zip = icp.ZipCode
WHERE i.kareopatientid <> '#N/A' AND ip.PolicyNumber <> i.policynbr
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Insurance Policy - Policy - PracticeID ' + CAST(@JoySanFran AS VARCHAR) + '...'
UPDATE dbo.InsurancePolicy
	SET PolicyNumber = i.policynbr --, 
		--InsuranceCompanyPlanID = CASE WHEN icp.InsuranceCompanyPlanID IS NULL THEN ip.InsuranceCompanyPlanID ELSE icp.InsuranceCompanyPlanID END
FROM dbo.InsurancePolicy ip
INNER JOIN dbo.PatientCase pc ON 
	ip.PatientCaseID = pc.PatientCaseID AND 
	ip.PracticeID = @JoySanFran AND
    pc.VendorImportID IS NOT NULL AND
	pc.VendorID IS NOT NULL AND 
	pc.CreatedUserID = 0
INNER JOIN dbo.Patient p ON 
	pc.PatientID = p.PatientID AND 
	p.PracticeID = @JoySanFran
INNER JOIN dbo.[_import_46_1_JoySanFran11] i ON 
	p.PatientID = i.kareopatientid AND 
	i.defcob = ip.Precedence
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	i.payername = icp.PlanName AND 
	i.addressline1 = icp.AddressLine1 AND 
	i.zip = icp.ZipCode
WHERE i.kareopatientid <> '#N/A' AND ip.PolicyNumber <> i.policynbr
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Insurance Policy - Policy - PracticeID ' + CAST(@JustinQuock AS VARCHAR) + '...'
UPDATE dbo.InsurancePolicy
	SET PolicyNumber = i.policynbr --, 
		--InsuranceCompanyPlanID = CASE WHEN icp.InsuranceCompanyPlanID IS NULL THEN ip.InsuranceCompanyPlanID ELSE icp.InsuranceCompanyPlanID END
FROM dbo.InsurancePolicy ip
INNER JOIN dbo.PatientCase pc ON 
	ip.PatientCaseID = pc.PatientCaseID AND 
	ip.PracticeID = @JustinQuock AND
    pc.VendorImportID IS NOT NULL AND
	pc.VendorID IS NOT NULL AND 
	pc.CreatedUserID = 0
INNER JOIN dbo.Patient p ON 
	pc.PatientID = p.PatientID AND 
	p.PracticeID = @JustinQuock
INNER JOIN dbo.[_import_46_1_JustinQuock1] i ON 
	p.PatientID = i.kareopatientid AND 
	i.defcob = ip.Precedence
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	i.payername = icp.PlanName AND 
	i.addressline1 = icp.AddressLine1 AND 
	i.zip = icp.ZipCode
WHERE i.kareopatientid <> '#N/A' AND ip.PolicyNumber <> i.policynbr
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Insurance Policy - Policy - PracticeID ' + CAST(@KennethChang AS VARCHAR) + '...'
UPDATE dbo.InsurancePolicy
	SET PolicyNumber = i.policynbr --, 
		--InsuranceCompanyPlanID = CASE WHEN icp.InsuranceCompanyPlanID IS NULL THEN ip.InsuranceCompanyPlanID ELSE icp.InsuranceCompanyPlanID END
FROM dbo.InsurancePolicy ip
INNER JOIN dbo.PatientCase pc ON 
	ip.PatientCaseID = pc.PatientCaseID AND 
	ip.PracticeID = @KennethChang AND
    pc.VendorImportID IS NOT NULL AND
	pc.VendorID IS NOT NULL AND 
	pc.CreatedUserID = 0
INNER JOIN dbo.Patient p ON 
	pc.PatientID = p.PatientID AND 
	p.PracticeID = @KennethChang
INNER JOIN dbo.[_import_46_1_KennethChang8] i ON 
	p.PatientID = i.kareopatientid AND 
	i.defcob = ip.Precedence
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	i.payername = icp.PlanName AND 
	i.addressline1 = icp.AddressLine1 AND 
	i.zip = icp.ZipCode
WHERE i.kareopatientid <> '#N/A' AND ip.PolicyNumber <> i.policynbr
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Insurance Policy - Policy - PracticeID ' + CAST(@KevinZhaoApollo AS VARCHAR) + '...'
UPDATE dbo.InsurancePolicy
	SET PolicyNumber = i.policynbr --, 
		--InsuranceCompanyPlanID = CASE WHEN icp.InsuranceCompanyPlanID IS NULL THEN ip.InsuranceCompanyPlanID ELSE icp.InsuranceCompanyPlanID END
FROM dbo.InsurancePolicy ip
INNER JOIN dbo.PatientCase pc ON 
	ip.PatientCaseID = pc.PatientCaseID AND 
	ip.PracticeID = @KevinZhaoApollo AND
    pc.VendorImportID IS NOT NULL AND
	pc.VendorID IS NOT NULL AND 
	pc.CreatedUserID = 0
INNER JOIN dbo.Patient p ON 
	pc.PatientID = p.PatientID AND 
	p.PracticeID = @KevinZhaoApollo
INNER JOIN dbo.[_import_46_1_KevinZhaoApollo24] i ON 
	p.PatientID = i.kareopatientid AND 
	i.defcob = ip.Precedence
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	i.payername = icp.PlanName AND 
	i.addressline1 = icp.AddressLine1 AND 
	i.zip = icp.ZipCode
WHERE i.kareopatientid <> '#N/A' AND ip.PolicyNumber <> i.policynbr
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Insurance Policy - Policy - PracticeID ' + CAST(@LisaLaw AS VARCHAR) + '...'
UPDATE dbo.InsurancePolicy
	SET PolicyNumber = i.policynbr --, 
		--InsuranceCompanyPlanID = CASE WHEN icp.InsuranceCompanyPlanID IS NULL THEN ip.InsuranceCompanyPlanID ELSE icp.InsuranceCompanyPlanID END
FROM dbo.InsurancePolicy ip
INNER JOIN dbo.PatientCase pc ON 
	ip.PatientCaseID = pc.PatientCaseID AND 
	ip.PracticeID = @LisaLaw AND
    pc.VendorImportID IS NOT NULL AND
	pc.VendorID IS NOT NULL AND 
	pc.CreatedUserID = 0
INNER JOIN dbo.Patient p ON 
	pc.PatientID = p.PatientID AND 
	p.PracticeID = @LisaLaw
INNER JOIN dbo.[_import_46_1_LisaLaw13] i ON 
	p.PatientID = i.kareopatientid AND 
	i.defcob = ip.Precedence
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	i.payername = icp.PlanName AND 
	i.addressline1 = icp.AddressLine1 AND 
	i.zip = icp.ZipCode
WHERE i.kareopatientid <> '#N/A' AND ip.PolicyNumber <> i.policynbr
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Insurance Policy - Policy - PracticeID ' + CAST(@MartinLeung AS VARCHAR) + '...'
UPDATE dbo.InsurancePolicy
	SET PolicyNumber = i.policynbr --, 
		--InsuranceCompanyPlanID = CASE WHEN icp.InsuranceCompanyPlanID IS NULL THEN ip.InsuranceCompanyPlanID ELSE icp.InsuranceCompanyPlanID END
FROM dbo.InsurancePolicy ip
INNER JOIN dbo.PatientCase pc ON 
	ip.PatientCaseID = pc.PatientCaseID AND 
	ip.PracticeID = @MartinLeung AND
    pc.VendorImportID IS NOT NULL AND
	pc.VendorID IS NOT NULL AND 
	pc.CreatedUserID = 0
INNER JOIN dbo.Patient p ON 
	pc.PatientID = p.PatientID AND 
	p.PracticeID = @MartinLeung
INNER JOIN dbo.[_import_46_1_MartinLeung23] i ON 
	p.PatientID = i.kareopatientid AND 
	i.defcob = ip.Precedence
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	i.payername = icp.PlanName AND 
	i.addressline1 = icp.AddressLine1 AND 
	i.zip = icp.ZipCode
WHERE i.kareopatientid <> '#N/A' AND ip.PolicyNumber <> i.policynbr
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Insurance Policy - Policy - PracticeID ' + CAST(@PacificEnt AS VARCHAR) + '...'
UPDATE dbo.InsurancePolicy
	SET PolicyNumber = i.policynbr --, 
		--InsuranceCompanyPlanID = CASE WHEN icp.InsuranceCompanyPlanID IS NULL THEN ip.InsuranceCompanyPlanID ELSE icp.InsuranceCompanyPlanID END
FROM dbo.InsurancePolicy ip
INNER JOIN dbo.PatientCase pc ON 
	ip.PatientCaseID = pc.PatientCaseID AND 
	ip.PracticeID = @PacificEnt AND
    pc.VendorImportID IS NOT NULL AND
	pc.VendorID IS NOT NULL AND 
	pc.CreatedUserID = 0
INNER JOIN dbo.Patient p ON 
	pc.PatientID = p.PatientID AND 
	p.PracticeID = @PacificEnt
INNER JOIN dbo.[_import_46_1_PacificEnt7] i ON 
	p.PatientID = i.kareopatientid AND 
	i.defcob = ip.Precedence
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	i.payername = icp.PlanName AND 
	i.addressline1 = icp.AddressLine1 AND 
	i.zip = icp.ZipCode
WHERE i.kareopatientid <> '#N/A' AND ip.PolicyNumber <> i.policynbr
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Insurance Policy - Policy - PracticeID ' + CAST(@QingQuan AS VARCHAR) + '...'
UPDATE dbo.InsurancePolicy
	SET PolicyNumber = i.policynbr --, 
		--InsuranceCompanyPlanID = CASE WHEN icp.InsuranceCompanyPlanID IS NULL THEN ip.InsuranceCompanyPlanID ELSE icp.InsuranceCompanyPlanID END
FROM dbo.InsurancePolicy ip
INNER JOIN dbo.PatientCase pc ON 
	ip.PatientCaseID = pc.PatientCaseID AND 
	ip.PracticeID = @QingQuan AND
    pc.VendorImportID IS NOT NULL AND
	pc.VendorID IS NOT NULL AND 
	pc.CreatedUserID = 0
INNER JOIN dbo.Patient p ON 
	pc.PatientID = p.PatientID AND 
	p.PracticeID = @QingQuan
INNER JOIN dbo.[_import_46_1_QingQuan14] i ON 
	p.PatientID = i.kareopatientid AND 
	i.defcob = ip.Precedence
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	i.payername = icp.PlanName AND 
	i.addressline1 = icp.AddressLine1 AND 
	i.zip = icp.ZipCode
WHERE i.kareopatientid <> '#N/A' AND ip.PolicyNumber <> i.policynbr
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Insurance Policy - Policy - PracticeID ' + CAST(@SimonLee AS VARCHAR) + '...'
UPDATE dbo.InsurancePolicy
	SET PolicyNumber = i.policynbr --, 
		--InsuranceCompanyPlanID = CASE WHEN icp.InsuranceCompanyPlanID IS NULL THEN ip.InsuranceCompanyPlanID ELSE icp.InsuranceCompanyPlanID END
FROM dbo.InsurancePolicy ip
INNER JOIN dbo.PatientCase pc ON 
	ip.PatientCaseID = pc.PatientCaseID AND 
	ip.PracticeID = @SimonLee AND
    pc.VendorImportID IS NOT NULL AND
	pc.VendorID IS NOT NULL AND 
	pc.CreatedUserID = 0
INNER JOIN dbo.Patient p ON 
	pc.PatientID = p.PatientID AND 
	p.PracticeID = @SimonLee
INNER JOIN dbo.[_import_46_1_SimonLee4] i ON 
	p.PatientID = i.kareopatientid AND 
	i.defcob = ip.Precedence
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	i.payername = icp.PlanName AND 
	i.addressline1 = icp.AddressLine1 AND 
	i.zip = icp.ZipCode
WHERE i.kareopatientid <> '#N/A' AND ip.PolicyNumber <> i.policynbr
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Insurance Policy - Policy - PracticeID ' + CAST(@WilliamChung AS VARCHAR) + '...'
UPDATE dbo.InsurancePolicy
	SET PolicyNumber = i.policynbr --, 
		--InsuranceCompanyPlanID = CASE WHEN icp.InsuranceCompanyPlanID IS NULL THEN ip.InsuranceCompanyPlanID ELSE icp.InsuranceCompanyPlanID END
FROM dbo.InsurancePolicy ip
INNER JOIN dbo.PatientCase pc ON 
	ip.PatientCaseID = pc.PatientCaseID AND 
	ip.PracticeID = @WilliamChung AND
    pc.VendorImportID IS NOT NULL AND
	pc.VendorID IS NOT NULL AND 
	pc.CreatedUserID = 0
INNER JOIN dbo.Patient p ON 
	pc.PatientID = p.PatientID AND 
	p.PracticeID = @WilliamChung
INNER JOIN dbo.[_import_46_1_WilliamChung18] i ON 
	p.PatientID = i.kareopatientid AND 
	i.defcob = ip.Precedence
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	i.payername = icp.PlanName AND 
	i.addressline1 = icp.AddressLine1 AND 
	i.zip = icp.ZipCode
WHERE i.kareopatientid <> '#N/A' AND ip.PolicyNumber <> i.policynbr
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


PRINT ''
PRINT 'Updating Insurance Policy - Policy - PracticeID ' + CAST(@RogerWang AS VARCHAR) + '...'
UPDATE dbo.InsurancePolicy
	SET PolicyNumber = i.policynbr --, 
		--InsuranceCompanyPlanID = CASE WHEN icp.InsuranceCompanyPlanID IS NULL THEN ip.InsuranceCompanyPlanID ELSE icp.InsuranceCompanyPlanID END
FROM dbo.InsurancePolicy ip
INNER JOIN dbo.PatientCase pc ON 
	ip.PatientCaseID = pc.PatientCaseID AND 
	ip.PracticeID = @RogerWang AND
    pc.VendorImportID IS NOT NULL AND
	pc.VendorID IS NOT NULL AND 
	pc.CreatedUserID = 0
INNER JOIN dbo.Patient p ON 
	pc.PatientID = p.PatientID AND 
	p.PracticeID = @RogerWang
INNER JOIN dbo.[_import_46_1_RogerWangAAA12] i ON 
	p.PatientID = i.kareopatientid AND 
	i.defcob = ip.Precedence
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	i.payername = icp.PlanName AND 
	i.addressline1 = icp.AddressLine1 AND 
	i.zip = icp.ZipCode
WHERE i.kareopatientid <> '#N/A' AND ip.PolicyNumber <> i.policynbr
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


PRINT ''
PRINT 'Updating Insurance Policy - Policy - PracticeID ' + CAST(@RandallLow AS VARCHAR) + '...'
UPDATE dbo.InsurancePolicy
	SET PolicyNumber = i.policynbr --, 
		--InsuranceCompanyPlanID = CASE WHEN icp.InsuranceCompanyPlanID IS NULL THEN ip.InsuranceCompanyPlanID ELSE icp.InsuranceCompanyPlanID END
FROM dbo.InsurancePolicy ip
INNER JOIN dbo.PatientCase pc ON 
	ip.PatientCaseID = pc.PatientCaseID AND 
	ip.PracticeID = @RandallLow AND
    pc.VendorImportID IS NOT NULL AND
	pc.VendorID IS NOT NULL AND 
	pc.CreatedUserID = 0
INNER JOIN dbo.Patient p ON 
	pc.PatientID = p.PatientID AND 
	p.PracticeID = @RandallLow
INNER JOIN dbo.[_import_46_1_Randalllow10] i ON 
	p.PatientID = i.kareopatientid AND 
	i.defcob = ip.Precedence
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	i.payername = icp.PlanName AND 
	i.addressline1 = icp.AddressLine1 AND 
	i.zip = icp.ZipCode
WHERE i.kareopatientid <> '#N/A' AND ip.PolicyNumber <> i.policynbr
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'




/*
=================================================================================================================================
QA
=================================================================================================================================

DECLARE @CrawfordChung INT
DECLARE @DominicTse INT
DECLARE @EdwardChan INT
DECLARE @EricLeung INT
DECLARE @ErvinWong INT
DECLARE @HoTan INT
DECLARE @JewandJew INT
DECLARE @JonYang INT
DECLARE @JoySanFran INT
DECLARE @JustinQuock INT
DECLARE @KennethChang INT
DECLARE @KevinZhaoApollo INT
DECLARE @LisaLaw INT
DECLARE @MartinLeung INT
DECLARE @PacificEnt INT
DECLARE @QingQuan INT
DECLARE @SimonLee INT
DECLARE @WilliamChung INT
DECLARE @RogerWang INT
DECLARE @RandallLow INT

SET @CrawfordChung = 20
SET @DominicTse = 15
SET @EdwardChan = 16
SET @EricLeung = 21
SET @ErvinWong = 19
SET @HoTan = 6
SET @JewandJew = 9
SET @JonYang = 5
SET @JoySanFran = 11
SET @JustinQuock = 1
SET @KennethChang = 8
SET @KevinZhaoApollo = 24
SET @LisaLaw = 13
SET @MartinLeung = 23
SET @PacificEnt = 7
SET @QingQuan = 14
SET @SimonLee = 4
SET @WilliamChung = 18
SET @RogerWang = 12
SET @RandallLow = 10

SELECT DISTINCT
CAST(i.kareopatientid AS INT) AS [KareoPatientID] , i.personid, p.FirstName , p.LastName , CONVERT(VARCHAR(30), p.dob,101) AS [DateofBirth] , 
ip.Precedence AS [Precedence/def_cob], ip.PolicyNumber AS [KareoPolicy] ,i.policynbr , i.payername
FROM dbo.InsurancePolicy ip
INNER JOIN dbo.PatientCase pc ON 
	ip.PatientCaseID = pc.PatientCaseID AND 
	ip.PracticeID = @LisaLaw AND
    pc.VendorImportID IS NOT NULL AND
	pc.VendorID IS NOT NULL AND 
	pc.CreatedUserID = 0
INNER JOIN dbo.Patient p ON 
	pc.PatientID = p.PatientID AND 
	p.PracticeID = @LisaLaw
INNER JOIN dbo.[_import_46_1_LisaLaw13] i ON 
	p.PatientID = i.kareopatientid AND 
	i.defcob = ip.Precedence
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	i.payername = icp.PlanName AND 
	i.addressline1 = icp.AddressLine1 AND 
	i.zip = icp.ZipCode
WHERE i.kareopatientid <> '#N/A' -- AND ip.PolicyNumber <> i.policynbr
ORDER BY CAST(i.kareopatientid AS INT)
==============================================================================================================================
*/


--ROLLBACK
--COMMIT


