-- -----------------------
-- TABLES 
-- -----------------------

-- ---
-- Medicare RVU  

-- ID
-- EffectiveStart

IF NOT EXISTS ( SELECT  IST.*
                FROM    INFORMATION_SCHEMA.TABLES AS IST
                WHERE   IST.TABLE_SCHEMA = 'dbo'
                        AND IST.TABLE_NAME = 'MedicareFeeScheduleRVUBatch' ) 
    BEGIN                    
        CREATE TABLE [dbo].[MedicareFeeScheduleRVUBatch]
            (
              [MedicareFeeScheduleRVUBatchID] INT IDENTITY(1, 1) NOT NULL ,
              [ConversionFactor] FLOAT NOT NULL,
              [BudgetNeutralityAdjustor] FLOAT NOT NULL,
			  [EffectiveStart] DATETIME NOT NULL,

              CONSTRAINT [PK_MedicareFeeScheduleRVUBatch] PRIMARY KEY CLUSTERED
                ( [MedicareFeeScheduleRVUBatchID] ASC )
            )
    END  

-- MedicareFeeScheduleRVUID
-- MedicareFeeScheduleID
-- ProcedureCode
-- Modifier
-- Work RVU
-- Facility Practice Expense RVU
-- Non Facility Practice Expense RVU
-- Malpractice Expense RVU


IF NOT EXISTS ( SELECT  IST.*
                FROM    INFORMATION_SCHEMA.TABLES AS IST
                WHERE   IST.TABLE_SCHEMA = 'dbo'
                        AND IST.TABLE_NAME = 'MedicareFeeScheduleRVU' ) 
    BEGIN                    
        CREATE TABLE [dbo].[MedicareFeeScheduleRVU]
            (
              [MedicareFeeScheduleRVUID] INT IDENTITY(1, 1) NOT NULL ,
			  [MedicareFeeScheduleRVUBatchID] INT NOT NULL,
			  [ProcedureCode] VARCHAR(16) NOT NULL,
			  [Modifier] VARCHAR(16) NULL,
			  [WorkRVU] FLOAT NOT NULL,
			  [FacilityPracticeExpenseRVU] FLOAT NOT NULL,
			  [NonFacilityPracticeExpenseRVU] FLOAT NOT NULL,
			  [MalpracticeExpenseRVU] FLOAT NOT NULL,

              CONSTRAINT [PK_MedicareFeeScheduleRVU] PRIMARY KEY CLUSTERED
                ( [MedicareFeeScheduleRVUID] ASC )
            )
    END    
    
    IF NOT EXISTS(Select * FROM SYS.INDEXES WHERE NAME='IX_MedicareFeeScheduleRVU_MedicareFeeScheduleRVUBatchID_ProcedureCode_Modifier')
    Create NonClustered Index IX_MedicareFeeScheduleRVU_MedicareFeeScheduleRVUBatchID_ProcedureCode_Modifier ON MedicareFeeScheduleRVU(MedicareFeeScheduleRVUBatchID,ProcedureCode,Modifier)
   GO
    
-- ---
-- Medicare GPCI

-- ID
-- EffectiveStart

IF NOT EXISTS ( SELECT  IST.*
                FROM    INFORMATION_SCHEMA.TABLES AS IST
                WHERE   IST.TABLE_SCHEMA = 'dbo'
                        AND IST.TABLE_NAME = 'MedicareFeeScheduleGPCIBatch' ) 
    BEGIN                    
        CREATE TABLE [dbo].[MedicareFeeScheduleGPCIBatch]
            (
              [MedicareFeeScheduleGPCIBatchID] INT IDENTITY(1, 1) NOT NULL ,
			  [EffectiveStart] DATETIME NOT NULL,

              CONSTRAINT [PK_MedicareFeeScheduleGPCIBatch] PRIMARY KEY CLUSTERED
                ( [MedicareFeeScheduleGPCIBatchID] ASC )
            )
    END  
    
-- MedicareFeeScheduleGPCIID
-- MedicareFeeScheduleID
-- Carrier
-- Locality
-- Work GPCI
-- PE GPCI
-- MP GPCI

IF NOT EXISTS 
( 
	SELECT  IST.*
	FROM    INFORMATION_SCHEMA.TABLES AS IST
	WHERE   IST.TABLE_SCHEMA = 'dbo'
	AND IST.TABLE_NAME = 'MedicareFeeScheduleGPCI' 
) 
BEGIN                    
    CREATE TABLE [dbo].[MedicareFeeScheduleGPCI]
    (
		[MedicareFeeScheduleGPCIID] INT IDENTITY(1, 1) NOT NULL ,
		[MedicareFeeScheduleGPCIBatchID] INT NOT NULL,
		[Carrier] INT NOT NULL,
		[Locality] INT NULL,
		[LocalityName] VARCHAR(128) NULL,
		[WorkGPCI] FLOAT NOT NULL,
		[PracticeExpenseGPCI] FLOAT NOT NULL,
		[MalpracticeExpenseGPCI] FLOAT NOT NULL,

		CONSTRAINT [PK_MedicareFeeScheduleGPCI] PRIMARY KEY CLUSTERED
			( [MedicareFeeScheduleGPCIID] ASC )
    )
END  

IF NOT EXISTS (Select * from sys.indexes where name='IX_MedicareFeeScheduleGPCI_Carrier_Locality_MedicareFeeScheduleGPCIBatchID')
Create NonClustered Index IX_MedicareFeeScheduleGPCI_Carrier_Locality_MedicareFeeScheduleGPCIBatchID On MedicareFeeScheduleGPCI(Carrier, Locality, MedicareFeeScheduleGPCIBatchID)
-- ---
-- Medicare ZIP to Carrier Locality

-- ID
-- EffectiveStart

IF NOT EXISTS ( SELECT  IST.*
                FROM    INFORMATION_SCHEMA.TABLES AS IST
                WHERE   IST.TABLE_SCHEMA = 'dbo'
                        AND IST.TABLE_NAME = 'MedicareFeeScheduleZipGPCILinkBatch' ) 
    BEGIN                    
        CREATE TABLE [dbo].[MedicareFeeScheduleZipGPCILinkBatch]
            (
              [MedicareFeeScheduleZipGPCILinkBatchID] INT IDENTITY(1, 1) NOT NULL ,
			  [EffectiveStart] DATETIME NOT NULL,

              CONSTRAINT [PK_MedicareFeeScheduleZipGPCILinkBatch] PRIMARY KEY CLUSTERED
                ( [MedicareFeeScheduleZipGPCILinkBatchID] ASC )
            )
    END  
 
-- ID
-- MedicareFeeScheduleID
-- Zip Code
-- Carrier
-- Locality

IF NOT EXISTS 
( 
	SELECT  IST.*
	FROM    INFORMATION_SCHEMA.TABLES AS IST
	WHERE   IST.TABLE_SCHEMA = 'dbo'
	AND IST.TABLE_NAME = 'MedicareFeeScheduleZipGPCILink'
) 
BEGIN                    
	CREATE TABLE [dbo].[MedicareFeeScheduleZipGPCILink]
	(
		[MedicareFeeScheduleZipGPCILinkID] INT IDENTITY(1, 1) NOT NULL ,
		[MedicareFeeScheduleZipGPCILinkBatchID] INT NOT NULL,
		[ZipCode] CHAR(5) NOT NULL,
		[Carrier] INT NOT NULL,
		[Locality] INT NOT NULL,

		CONSTRAINT [PK_MedicareFeeScheduleZipGPCILink] PRIMARY KEY CLUSTERED
			( [MedicareFeeScheduleZipGPCILinkID] ASC )
	)
END

IF NOT EXISTS( Select * from sys.indexes where name='IX_MedicareFeeScheduleZipGPCILink_MedicareFeeScheduleZipGPCILinkBatchID_ZipCode')
Create Nonclustered Index IX_MedicareFeeScheduleZipGPCILink_MedicareFeeScheduleZipGPCILinkBatchID_ZipCode ON MedicareFeeScheduleZipGPCILink(MedicareFeeScheduleZipGPCILinkBatchID, ZipCode)

Go

