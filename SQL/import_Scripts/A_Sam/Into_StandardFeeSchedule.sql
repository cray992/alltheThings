USE superbill_11269_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @TargetPracticeID INT
DECLARE @SourcePracticeID INT
DECLARE @VendorImportID INT

SET @TargetPracticeID = 23
SET @SourcePracticeID = 11
SET @VendorImportID = 5

SET NOCOUNT ON 

--ALTER TABLE dbo.ContractsAndFees_StandardFee ADD vendorimportid VARCHAR(10)
--ALTER TABLE dbo.ContractsAndFees_StandardFeeSchedule ADD vendorimportid VARCHAR(10)
--ALTER TABLE dbo.ContractsAndFees_StandardFeeScheduleLink ADD vendorimportid VARCHAR(10)
--ALTER TABLE dbo.ContractsAndFees_ContractRate ADD vendorimportid VARCHAR(10)
--ALTER TABLE dbo.ContractsAndFees_ContractRateSchedule ADD vendorimportid VARCHAR(10)
--ALTER TABLE dbo.ContractsAndFees_ContractRateScheduleLink ADD vendorimportid VARCHAR(10)
--ALTER TABLE dbo.ContractsAndFees_ContractRate ADD practiceid INT 

PRINT 'Source PracticeID = ' + CAST(@SourcePracticeID AS VARCHAR) 
PRINT 'Target PracticeID = ' + CAST(@TargetPracticeID AS VARCHAR) 
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR) 
--rollback
--commit

PRINT''
PRINT'Insert Into ContractsAndFees_StandardFeeSchedule...'
INSERT INTO dbo.ContractsAndFees_StandardFeeSchedule
(
    PracticeID,
    Name,
    Notes,
    EffectiveStartDate,
    SourceType,
    SourceFileName,
    EClaimsNoResponseTrigger,
    PaperClaimsNoResponseTrigger,
    MedicareFeeScheduleGPCICarrier,
    MedicareFeeScheduleGPCILocality,
    MedicareFeeScheduleGPCIBatchID,
    MedicareFeeScheduleRVUBatchID,
    AddPercent,
    AnesthesiaTimeIncrement,
	  vendorimportid
)
SELECT DISTINCT 
    @TargetPracticeID,         -- PracticeID - int
    fs.Name,        -- Name - varchar(128)
    fs.Notes,        -- Notes - varchar(1024)
    GETDATE(), -- EffectiveStartDate - datetime
    fs.SourceType,        -- SourceType - char(1)
    fs.SourceFileName,        -- SourceFileName - varchar(256)
    fs.EClaimsNoResponseTrigger,         -- EClaimsNoResponseTrigger - int
    fs.PaperClaimsNoResponseTrigger,         -- PaperClaimsNoResponseTrigger - int
    fs.MedicareFeeScheduleGPCICarrier,         -- MedicareFeeScheduleGPCICarrier - int
    fs.MedicareFeeScheduleGPCILocality,         -- MedicareFeeScheduleGPCILocality - int
    fs.MedicareFeeScheduleGPCIBatchID,         -- MedicareFeeScheduleGPCIBatchID - int
    fs.MedicareFeeScheduleRVUBatchID,         -- MedicareFeeScheduleRVUBatchID - int
    fs.AddPercent,      -- AddPercent - decimal(18, 0)
    fs.AnesthesiaTimeIncrement,          -- AnesthesiaTimeIncrement - int
    @vendorimportid
   --select *  
FROM dbo.ContractsAndFees_StandardFeeSchedule fs
WHERE fs.PracticeID=@SourcePracticeID AND fs.Name = 'Standard Fees'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

SELECT * FROM dbo.ContractsAndFees_StandardFeeSchedule a WHERE a.EffectiveStartDate > DATEADD(mi, -3, GETDATE());

--rollback
--commit

PRINT''
PRINT'Insert Into ContractsAndFees_StandardFee...'
INSERT INTO dbo.ContractsAndFees_StandardFee
(
    StandardFeeScheduleID,
    ProcedureCodeID,
    ModifierID,
    SetFee,
    AnesthesiaBaseUnits,
	vendorimportid
)
SELECT 
    (SELECT a.StandardFeeScheduleID FROM dbo.ContractsAndFees_StandardFeeSchedule a WHERE a.PracticeID=23 AND a.Name='Standard Fees'),    -- StandardFeeScheduleID - int
    sf.ProcedureCodeID,    -- ProcedureCodeID - int
    sf.ModifierID,    -- ModifierID - int
    sf.SetFee, -- SetFee - money
    sf.AnesthesiaBaseUnits,     -- AnesthesiaBaseUnits - int
    5

--select * 
FROM dbo.ContractsAndFees_StandardFee sf 
	INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule sfs ON sfs.StandardFeeScheduleID=sf.StandardFeeScheduleID
WHERE sf.StandardFeeScheduleID=sfs.StandardFeeScheduleID AND sfs.PracticeID=@SourcePracticeID

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT''
PRINT'Inserting into Contract Rate Schedule...'
INSERT INTO dbo.ContractsAndFees_ContractRateSchedule

(
    PracticeID,
	InsuranceCompanyID,
    EffectiveStartDate,
	EffectiveEndDate,
    SourceType,
    SourceFileName,
    EClaimsNoResponseTrigger,
    PaperClaimsNoResponseTrigger,
    MedicareFeeScheduleGPCICarrier,
    MedicareFeeScheduleGPCILocality,
    MedicareFeeScheduleGPCIBatchID,
    MedicareFeeScheduleRVUBatchID,
    AddPercent,
    AnesthesiaTimeIncrement,
	Capitated,
	vendorimportid
)
SELECT 
    @TargetPracticeID,         -- PracticeID - int
	a.InsuranceCompanyID,
    GETDATE(), -- EffectiveStartDate - datetime
	a.EffectiveEndDate, --EffectiveEndDate
    a.SourceType,        -- SourceType - char(1)
    a.SourceFileName,        -- SourceFileName - varchar(256)
    a.EClaimsNoResponseTrigger,         -- EClaimsNoResponseTrigger - int
    a.PaperClaimsNoResponseTrigger,         -- PaperClaimsNoResponseTrigger - int
    a.MedicareFeeScheduleGPCICarrier,         -- MedicareFeeScheduleGPCICarrier - int
    a.MedicareFeeScheduleGPCILocality,         -- MedicareFeeScheduleGPCILocality - int
    a.MedicareFeeScheduleGPCIBatchID,         -- MedicareFeeScheduleGPCIBatchID - int
    a.MedicareFeeScheduleRVUBatchID,         -- MedicareFeeScheduleRVUBatchID - int
    a.AddPercent,      -- AddPercent - decimal(18, 0)
    a.AnesthesiaTimeIncrement,          -- AnesthesiaTimeIncrement - int
	0, -- capitated
	@VendorImportID
     --SELECT *
FROM dbo.ContractsAndFees_ContractRateSchedule a 
WHERE a.PracticeID=@SourcePracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



--SELECT * FROM dbo.ContractsAndFees_ContractRateSchedule a WHERE a.EffectiveStartDate > DATEADD(mi, -30, GETDATE());
--SELECT * FROM dbo.ContractsAndFees_ContractRate WHERE 
--SELECT * FROM dbo.ContractsAndFees_ContractRateSchedule a  ORDER BY a.InsuranceCompanyID





PRINT''
PRINT'Inserting into Contract Rate...'

INSERT INTO dbo.ContractsAndFees_ContractRate
(
    ContractRateScheduleID,
    ProcedureCodeID,
    ModifierID,
    SetFee,
    AnesthesiaBaseUnits,
	VendorImportid
)
SELECT 
    cr.ContractRateScheduleID,    -- ContractRateScheduleID - int
    cr.ProcedureCodeID,    -- ProcedureCodeID - int
    NULL ,    -- ModifierID - int
    cr.SetFee, -- SetFee - money
    0,     -- AnesthesiaBaseUnits - int
	5
    
--SELECT cr.*
FROM dbo.ContractsAndFees_ContractRate cr
INNER JOIN dbo.ContractsAndFees_ContractRateSchedule crs
ON crs.ContractRateScheduleID = cr.ContractRateScheduleID
WHERE crs.PracticeID=11 AND 
cr.ContractRateScheduleID=100247

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT''
PRINT'Insert Into ContractsAndFees_StandardFeeScheduleLink...'

INSERT INTO dbo.ContractsAndFees_StandardFeeScheduleLink
(
    ProviderID,
    LocationID,
    StandardFeeScheduleID,
	vendorimportid
)
SELECT DISTINCT 
    doc.doctorid, -- ProviderID - int
    sl.ServiceLocationID, -- LocationID - int
    sfs.StandardFeeScheduleID,  -- StandardFeeScheduleID - int
    5


FROM dbo.Doctor doc 
	INNER JOIN dbo.ServiceLocation sl ON sl.practiceid=doc.PracticeID
	INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule sfs ON sfs.PracticeID = 23
WHERE doc.[External]<>1

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT''
PRINT'Inserting into Contract Rate Schedule Link'
INSERT INTO dbo.ContractsAndFees_ContractRateScheduleLink
(
    ProviderID,
    LocationID,
    ContractRateScheduleID,
	vendorimportid
)
SELECT 
		  doc.doctorID , -- ProviderID - int
          sl.ServiceLocationID,  -- LocationID - int
          sfs.ContractRateScheduleID,  -- ContractRateScheduleID - int
		  5
   
FROM dbo.Doctor doc 
INNER JOIN dbo.ServiceLocation sl ON sl.practiceid=doc.PracticeID
INNER JOIN dbo.ContractsAndFees_ContractRateSchedule sfs ON sfs.PracticeID = 23
WHERE doc.[External]<>1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--rollback
--commit


--SELECT * FROM dbo.ContractsAndFees_StandardFeeSchedule 
--SELECT * FROM dbo.ContractsAndFees_StandardFee WHERE StandardFeeScheduleID =23
--SELECT * FROM dbo.ContractsAndFees_ContractRateSchedule WHERE PracticeID=23--ContractRateScheduleID=100125
--SELECT * FROM dbo.ContractsAndFees_ContractRate WHERE ContractRateScheduleID=100125


--DELETE FROM dbo.ContractsAndFees_StandardFee WHERE vendorimportid=5
--DELETE FROM dbo.ContractsAndFees_StandardFeeScheduleLink WHERE vendorimportid=5
--DELETE FROM dbo.ContractsAndFees_StandardFeeSchedule WHERE vendorimportid=5
DELETE FROM dbo.ContractsAndFees_ContractRate WHERE vendorimportid=5
DELETE FROM dbo.ContractsAndFees_ContractRateSchedule WHERE vendorimportid=5
DELETE FROM dbo.ContractsAndFees_ContractRateScheduleLink WHERE vendorimportid=5
