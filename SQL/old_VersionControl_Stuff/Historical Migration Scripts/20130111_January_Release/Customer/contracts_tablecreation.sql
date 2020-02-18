-- -----------------------
-- TABLES 
-- -----------------------

-- ---
-- STANDARD FEE SCHEDULE  

-- Name
-- PracticeID
-- Notes
-- EffectiveStartDate
-- SourceType
-- SourceFileName
-- EClaimsNoResponseTrigger
-- PaperClaimsNoResponseTrigger
-- MedicareFeeScheduleGPCICarrier
-- MedicareFeeScheduleGPCILocality
-- MedicareFeeScheduleGPCIBatchID
-- MedicareFeeScheduleRVUBatchID
-- AddPercent
-- AnesthesiaTimeIncrement
  
IF NOT EXISTS ( SELECT  IST.*
                FROM    INFORMATION_SCHEMA.TABLES AS IST
                WHERE   IST.TABLE_SCHEMA = 'dbo'
                        AND IST.TABLE_NAME = 'ContractsAndFees_StandardFeeSchedule' ) 
    BEGIN                    
        CREATE TABLE [dbo].[ContractsAndFees_StandardFeeSchedule]
            (
              StandardFeeScheduleID INT IDENTITY(1, 1)
                                        NOT NULL ,
              PracticeID INT NOT NULL ,
              [Name] VARCHAR(128) NOT NULL ,
              Notes VARCHAR(1024) NULL ,
              EffectiveStartDate DATETIME NOT NULL ,
              SourceType CHAR(1) NOT NULL
                                 DEFAULT 'U' , -- Unknown
              SourceFileName VARCHAR(256) NULL,
              EClaimsNoResponseTrigger INT NOT NULL
                                           DEFAULT 30 , -- 30 Days (Default should actually be applied from Provider)
              PaperClaimsNoResponseTrigger INT NOT NULL
                                               DEFAULT 30 , -- 30 Days
              MedicareFeeScheduleGPCICarrier INT NULL ,
              MedicareFeeScheduleGPCILocality INT NULL ,
              MedicareFeeScheduleGPCIBatchID INT NULL ,
              MedicareFeeScheduleRVUBatchID INT NULL ,
              AddPercent DECIMAL NOT NULL ,
              AnesthesiaTimeIncrement INT NOT NULL
                                          DEFAULT 0 ,
              CONSTRAINT [PK_ContractsAndFees_StandardFeeSchedule] PRIMARY KEY CLUSTERED
                ( [StandardFeeScheduleID] ASC )
            )
    END
    
-- ---
-- STANDARD FEE

-- StandardFeeID
-- StandardFeeScheduleID
-- ProcedureCodeID
-- ModifierID
-- SetFee
-- AnesthesiaBaseUnits

IF NOT EXISTS ( SELECT  IST.*
                FROM    INFORMATION_SCHEMA.TABLES AS IST
                WHERE   IST.TABLE_SCHEMA = 'dbo'
                        AND IST.TABLE_NAME = 'ContractsAndFees_StandardFee' ) 
    BEGIN    
        CREATE TABLE [dbo].[ContractsAndFees_StandardFee]
            (
              StandardFeeID INT IDENTITY(1, 1) NOT NULL ,
              StandardFeeScheduleID INT REFERENCES ContractsAndFees_StandardFeeSchedule ( StandardFeeScheduleID ) NOT NULL ,
              ProcedureCodeID INT NULL ,
              ModifierID INT NULL ,
              SetFee MONEY NOT NULL DEFAULT 0.0 ,
              AnesthesiaBaseUnits INT NOT NULL DEFAULT 0 ,
              
              CONSTRAINT [PK_ContractsAndFees_StandardFee] PRIMARY KEY CLUSTERED
                ( [StandardFeeID] ASC )
            )
    END

-- ---
-- STANDARD FEE SCHEDULE LINK     

-- StandardFeeScheduleLinkID
-- ProviderID
-- LocationID
-- StandardFeeScheduleID
   
IF NOT EXISTS ( SELECT  IST.*
                FROM    INFORMATION_SCHEMA.TABLES AS IST
                WHERE   IST.TABLE_SCHEMA = 'dbo'
                        AND IST.TABLE_NAME = 'ContractsAndFees_StandardFeeScheduleLink' ) 
    BEGIN              
        CREATE TABLE [dbo].[ContractsAndFees_StandardFeeScheduleLink]
            (
              StandardFeeScheduleLinkID INT IDENTITY(1, 1)
                                            NOT NULL ,
              ProviderID INT NOT NULL ,
              LocationID INT NOT NULL ,
              StandardFeeScheduleID INT NOT NULL REFERENCES ContractsAndFees_StandardFeeSchedule ( StandardFeeScheduleID ) ,
              
              CONSTRAINT [PK_ContractsAndFees_StandardFeeScheduleLink] PRIMARY KEY CLUSTERED
                ( [StandardFeeScheduleLinkID] ASC )
            )
    END

-- ---
-- CONTRACT RATE SCHEDULE

-- ContractRateScheduleID
-- PracticeID
-- InsuranceCompanyID
-- EffectiveStartDate
-- EffectiveEndDate
-- SourceType
-- SourceFileName
-- EClaimsNoResponseTrigger
-- PaperClaimsNoResponseTrigger
-- AnesthesiaTimeIncrement

IF NOT EXISTS ( SELECT  IST.*
                FROM    INFORMATION_SCHEMA.TABLES AS IST
                WHERE   IST.TABLE_SCHEMA = 'dbo'
                        AND IST.TABLE_NAME = 'ContractsAndFees_ContractRateSchedule' ) 
    BEGIN  
        CREATE TABLE [dbo].[ContractsAndFees_ContractRateSchedule]
            (
              ContractRateScheduleID INT IDENTITY(1, 1) NOT NULL ,
              PracticeID INT NOT NULL ,
              InsuranceCompanyID INT NOT NULL ,
              EffectiveStartDate DATETIME NOT NULL ,
              EffectiveEndDate DATETIME NOT NULL ,
              SourceType CHAR(1) NOT NULL ,
              SourceFileName VARCHAR(256) NULL ,
              EClaimsNoResponseTrigger INT NOT NULL ,
              PaperClaimsNoResponseTrigger INT NOT NULL ,
              MedicareFeeScheduleGPCICarrier INT NULL ,
              MedicareFeeScheduleGPCILocality INT NULL ,
              MedicareFeeScheduleGPCIBatchID INT NULL ,
              MedicareFeeScheduleRVUBatchID INT NULL ,
              AddPercent DECIMAL NOT NULL ,
              AnesthesiaTimeIncrement INT NOT NULL ,
              Capitated BIT NOT NULL ,
              
              CONSTRAINT [PK_ContractsAndFees_ContractRateSchedule] PRIMARY KEY CLUSTERED
                ( [ContractRateScheduleID] ASC )
            )
    END
     
-- ---
-- CONTRACT RATE

-- ContractRateID
-- ContractRateScheduleID
-- ProcedureCodeID
-- ModifierID
-- SetFee
-- AnesthesiaBaseUnits

IF NOT EXISTS ( SELECT  IST.*
                FROM    INFORMATION_SCHEMA.TABLES AS IST
                WHERE   IST.TABLE_SCHEMA = 'dbo'
                        AND IST.TABLE_NAME = 'ContractsAndFees_ContractRate' ) 
    BEGIN  
        CREATE TABLE [dbo].[ContractsAndFees_ContractRate]
            (
              ContractRateID INT IDENTITY(1, 1) NOT NULL ,
              ContractRateScheduleID INT REFERENCES ContractsAndFees_ContractRateSchedule ( ContractRateScheduleID ) NOT NULL ,
              ProcedureCodeID INT NOT NULL ,
              ModifierID INT NULL ,
              SetFee MONEY NOT NULL ,
              AnesthesiaBaseUnits INT NOT NULL ,
              
              CONSTRAINT [PK_ContractsAndFees_ContractRate] PRIMARY KEY CLUSTERED
                ( [ContractRateID] ASC )
            )
    END

-- ---
-- CONTRACT RATE SCHEDULE LINK    

-- ContractRateScheduleLinkID
-- ProviderID
-- LocationID
-- ContractRateScheduleID

IF NOT EXISTS ( SELECT  IST.*
                FROM    INFORMATION_SCHEMA.TABLES AS IST
                WHERE   IST.TABLE_SCHEMA = 'dbo'
                        AND IST.TABLE_NAME = 'ContractsAndFees_ContractRateScheduleLink' ) 
    BEGIN              
        CREATE TABLE [dbo].[ContractsAndFees_ContractRateScheduleLink]
            (
              ContractRateScheduleLinkID INT IDENTITY(1, 1) NOT NULL ,
              ProviderID INT NOT NULL ,
              LocationID INT NOT NULL ,
              ContractRateScheduleID INT
                NOT NULL
                REFERENCES ContractsAndFees_ContractRateSchedule ( ContractRateScheduleID ) ,
              CONSTRAINT [PK_ContractsAndFees_ContractRateScheduleLink] PRIMARY KEY CLUSTERED
                ( [ContractRateScheduleLinkID] ASC )
            )
    END
      