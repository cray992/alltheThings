/*

DATABASE UPDATE SCRIPT

v1.26.1914 to v1.28.xxxx		// .27 was a quick fix post-release and has no migration script
*/
----------------------------------

--BEGIN TRAN 
----------------------------------


---------------------------------------------------------------------------------------
--case 3840 - Add flag to InsuranceCompanyPlan table to determine if the secondary insurance is automatically billed

ALTER TABLE
	InsuranceCompanyPlan
ADD
	BillSecondaryInsurance BIT NOT NULL DEFAULT 0
GO

--Update any insurance plans with Medicare in the name to have this new bit set to 1
UPDATE	InsuranceCompanyPlan
SET	BillSecondaryInsurance = 1
WHERE	PlanName LIKE '%medicare%'

---------------------------------------------------------------------------------------
--case 3865 - Add DMS Record Type for Provider

INSERT INTO DMSRecordType
	(TableName)
VALUES	('Provider')

---------------------------------------------------------------------------------------
--case 3272 - Multiple ST envelopes for ANSI-837

INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(39, 'EDI --Submitter Number', 'SN', 200)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(40, 'EDI --Submitter Name', 'SM', 210)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(41, 'EDI --Receiver Number', 'RN', 220)
INSERT INTO GroupNumberType (GroupNumberTypeID, TypeName, ANSIReferenceIdentificationQualifier, SortOrder) VALUES(42, 'EDI --Receiver Name', 'RM', 230)


---------------------------------------------------------------------------------------
--case 3890 - Medi-Cal rejections due to SBR09 code hardcoded to '09'

ALTER TABLE [dbo].[InsuranceProgram] DROP CONSTRAINT [PK_InsuranceProgram]
GO

ALTER TABLE
	[dbo].[InsuranceProgram]
ALTER COLUMN
	[InsuranceProgramCode] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
GO

ALTER TABLE [dbo].[InsuranceProgram] WITH NOCHECK ADD
	CONSTRAINT [PK_InsuranceProgram] PRIMARY KEY CLUSTERED
	(
		[InsuranceProgramCode]
	) ON [PRIMARY]
GO

ALTER TABLE
	[dbo].[InsuranceCompanyPlan]
ALTER COLUMN
	[InsuranceProgramCode] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
GO


ALTER TABLE
	[dbo].[InsuranceProgram]
ADD
	[Comment] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SortOrder] [int] NULL
GO

INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('09', 'Self-pay', NULL, 10)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('10', 'Central Certification', 'NSF Reference: CA0-23.0 (K), DA0-05.0 (K)', 20)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('11', 'Other Non-Federal Programs', NULL, 30)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('12', 'Preferred Provider Organization (PPO)', NULL, 40)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('13', 'Point of Service (POS)', NULL, 50)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('14', 'Exclusive Provider Organization (EPO)', NULL, 60)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('15', 'Indemnity Insurance', NULL, 70)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('16', 'Health Maintenance Organization (HMO) Medicare Risk', NULL, 80)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('AM', 'Automobile Medical', NULL, 90)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('BL', 'Blue Cross/Blue Shield', 'NSF Reference: CA0-23.0 (G), DA0-05.0 (G), CA0-23.0 (P), DA0-05.0 (P)', 100)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('CH', 'Champus', 'NSF Reference: CA0-23.0 (H), DA0-05.0 (H)', 110)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('CI', 'Commercial Insurance Co.', 'NSF Reference: CA0-23.0 (F), DA0-05.0 (F)', 120)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('DS', 'Disability', NULL, 130)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('HM', 'Health Maintenance Organization', 'NSF Reference: CA0-23.0 (I), DA0-05.0 (I)', 140)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('LI', 'Liability', NULL, 150)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('LM', 'Liability Medical', NULL, 160)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('MB', 'Medicare Part B', 'NSF Reference: CA0-23.0 (C), DA0-05.0 (C)', 170)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('MC', 'Medicaid', 'NSF Reference: CA0-23.0 (D), DA0-05.0 (D)', 180)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('OF', 'Other Federal Program', 'NSF Reference: CA0-23.0 (E), DA0-05.0 (E)', 190)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('TV', 'Title V', 'NSF Reference: DA0-05.0 (T)', 200)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('VA', 'Veteran Administration Plan', 'Refers to Veteran’s Affairs Plan. NSF Reference: DA0-05.0 (V)', 210)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('WC', 'Workers Compensation Health Claim', 'NSF Reference: CA0-23.0 (B), DA0-05.0 (B)', 220)
INSERT INTO [dbo].[InsuranceProgram] ([InsuranceProgramCode], [ProgramName], [Comment], [SortOrder]) VALUES ('ZZ', 'Mutually Defined / Unknown', 'NSF Reference: CA0-23.0 (Z), DA0-05.0 (Z)', 230)
GO

UPDATE [dbo].[InsuranceCompanyPlan] SET [InsuranceProgramCode] = '09'
GO

DELETE [dbo].[InsuranceProgram] WHERE SortOrder IS NULL 
GO

UPDATE [dbo].[InsuranceCompanyPlan] SET [InsuranceProgramCode] = 'MC' WHERE (PlanName LIKE '%Medicaid%')
UPDATE [dbo].[InsuranceCompanyPlan] SET [InsuranceProgramCode] = 'MB' WHERE (PlanName LIKE '%Medicare%')
UPDATE [dbo].[InsuranceCompanyPlan] SET [InsuranceProgramCode] = '12' WHERE (PlanName LIKE '%PPO%')
UPDATE [dbo].[InsuranceCompanyPlan] SET [InsuranceProgramCode] = '15' WHERE (PlanName LIKE '%Indemnity%')
UPDATE [dbo].[InsuranceCompanyPlan] SET [InsuranceProgramCode] = 'BL' WHERE (PlanName LIKE '%BC/BS%' OR PlanName LIKE '%Blue Shield%' OR PlanName LIKE '%Blue Cross%')
UPDATE [dbo].[InsuranceCompanyPlan] SET [InsuranceProgramCode] = 'CH' WHERE (PlanName LIKE '%Champus%' OR PlanName LIKE '%Champva%')
UPDATE [dbo].[InsuranceCompanyPlan] SET [InsuranceProgramCode] = 'VA' WHERE (PlanName LIKE '%Veteran%')
UPDATE [dbo].[InsuranceCompanyPlan] SET [InsuranceProgramCode] = 'MC' WHERE (PlanName LIKE '%Medi-Cal%')
GO

ALTER TABLE [dbo].[InsuranceCompanyPlan] DROP CONSTRAINT [DF__Insurance__Insur__1B34BBAE]
ALTER TABLE [dbo].[InsuranceCompanyPlan] ADD CONSTRAINT [DF_InsuranceCompanyPlan_InsuranceProgramCode] DEFAULT ('09') FOR [InsuranceProgramCode]
GO

ALTER TABLE [dbo].[InsuranceCompanyPlan] ADD CONSTRAINT [FK_InsuranceCompanyPlan_InsuranceProgram] FOREIGN KEY 
	(
		[InsuranceProgramCode]
	) REFERENCES [InsuranceProgram] (
		[InsuranceProgramCode]
	)
GO

---------------------------------------------------------------------------------------
--case 2991 / 3890 - the SBR09 is actually patient-related, so we take it from Patient or, if null, - a default from InsuranceCompanyPlan

ALTER TABLE
	[dbo].[Patient]
ADD
	[InsuranceProgramCode] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO

ALTER TABLE [dbo].[Patient] ADD CONSTRAINT [FK_Patient_InsuranceProgram] FOREIGN KEY 
	(
		[InsuranceProgramCode]
	) REFERENCES [InsuranceProgram] (
		[InsuranceProgramCode]
	)
GO

---------------------------------------------------------------------------------------
--case 3795:  Add column to PatientInsurance table to allow insurance records to be marked deleted

ALTER TABLE 	PatientInsurance
ADD 		Deleted bit NOT NULL DEFAULT 0
GO

---------------------------------------------------------------------------------------
--case 3503 - Pimp my "Select Practice" stored procedure 

--Create UnappliedPayments Table for use in precalculating unapplied payments
CREATE TABLE UnappliedPayments(PracticeID INT NOT NULL, PaymentID INT NOT NULL)
GO

ALTER TABLE UnappliedPayments ADD CONSTRAINT PK_UnappliedPayments 
PRIMARY KEY CLUSTERED (PracticeID, PaymentID)
GO

--Populate UnappliedPayments Table with all unapplied payments in Customer
INSERT INTO UnappliedPayments
SELECT PMT.PracticeID, PMT.PaymentID
FROM [dbo].[Payment] PMT 
LEFT OUTER JOIN dbo.PaymentClaimTransaction PCT
ON PMT.PaymentID = PCT.PaymentID
LEFT OUTER JOIN dbo.ClaimTransaction CT
ON PCT.ClaimTransactionID = CT.ClaimTransactionID						
LEFT OUTER JOIN dbo.RefundToPayments RTP
ON PMT.PaymentID=RTP.PaymentID
WHERE ClaimTransactionTypeCode='PAY'
GROUP BY PMT.PracticeID, PMT.PaymentID
HAVING  MAX(ISNULL(PMT.PaymentAmount,0)) - (SUM(ISNULL(CT.Amount,0))+SUM(ISNULL(RTP.Amount,0))) > 0

---------------------------------------------------------------------------------------
--case 3904 - Implement new Clustered Indexing Scheme

--===========================================================================
--CLAIM
--===========================================================================
--Remove FK to allow Drop of Claim PK
ALTER TABLE BillClaim DROP CONSTRAINT FK_BillClaim_Claim
GO

--Remove FK to allow Drop of Claim PK
ALTER TABLE ClaimPayer DROP CONSTRAINT FK_ClaimPayer_Claim
GO

--Remove FK to allow Drop of Claim PK
ALTER TABLE ClaimTransaction DROP CONSTRAINT FK_ClaimTransaction_Claim
GO

--DROP unnecessary Indexes
DROP INDEX Claim.IX_Claim_PracticeID_ClaimID
GO

--DROP unnecessary Indexes
DROP INDEX Claim.IX_Claim_CID_PID_StatusCode_AssignIndic_Patient_Rendering_ServiceBeginDate
GO

--DROP unnecessary Indexes
DROP INDEX Claim.IX_Claim_CID_StatusCode_AssignIndic_Patient_Practice_Rendering_ServiceBeginDate
GO

--DROP unnecessary Indexes
DROP INDEX Claim.IX_Claim_ClaimStatusCode_PracticeID
GO

--DROP unnecessary Indexes
DROP INDEX Claim.IX_Claim_ReferringProviderID_PracticeID
GO

--Remove existing PK
ALTER TABLE Claim DROP CONSTRAINT PK_Claim
GO

--Add new nonclustered PK
ALTER TABLE Claim ADD CONSTRAINT PK_Claim PRIMARY KEY NONCLUSTERED (ClaimID)
GO

--Replace FK relationship
ALTER TABLE ClaimTransaction ADD CONSTRAINT FK_ClaimTransaction_Claim
FOREIGN KEY (ClaimID) REFERENCES Claim (ClaimID)
ON DELETE NO ACTION ON UPDATE NO ACTION
GO

--Replace FK relationship
ALTER TABLE ClaimPayer ADD CONSTRAINT FK_ClaimPayer_Claim
FOREIGN KEY (ClaimID) REFERENCES Claim (ClaimID)
ON DELETE NO ACTION ON UPDATE NO ACTION
GO

--Replace FK relationship
ALTER TABLE BillClaim ADD CONSTRAINT FK_BillClaim_Claim
FOREIGN KEY (ClaimID) REFERENCES Claim (ClaimID)
ON DELETE NO ACTION ON UPDATE NO ACTION
GO

--Create New Clustered INDEX
CREATE UNIQUE CLUSTERED INDEX CI_Claim_PracticeID_ClaimID
ON Claim (PracticeID, ClaimID)
GO

--Create Additional New Indexes
CREATE INDEX IX_Claim_ClaimStatusCode
ON Claim (ClaimStatusCode)
GO

CREATE INDEX IX_Claim_ReferringProviderID
ON Claim (ReferringProviderID)
GO

--===========================================================================
--CLAIMPAYER
--===========================================================================

--Add new column required for new clustered index
ALTER TABLE ClaimPayer ADD PracticeID INT
GO

--Populate new column
UPDATE ClaimPayer Set PracticeID=C.PracticeID
FROM ClaimPayer CP Inner join Claim C ON CP.Claimid=C.Claimid
GO

--Set the new column to not null
ALTER TABLE ClaimPayer ALTER COLUMN PracticeID INT NOT NULL
GO

--Drop existing PK
ALTER TABLE ClaimPayer DROP CONSTRAINT PK_ClaimPayer
GO

--Replace with new nonclustered PK
ALTER TABLE ClaimPayer ADD CONSTRAINT PK_ClaimPayer PRIMARY KEY NONCLUSTERED (ClaimPayerID)
GO

--Create new new clustered index
CREATE UNIQUE CLUSTERED INDEX CI_ClaimPayer_PracticeID_ClaimID 
ON ClaimPayer (PracticeID, ClaimPayerID, ClaimID)
GO

--===========================================================================
-- CLAIMTRANSACTION
--===========================================================================

--Drop FK to enable dropping and adding of PK with NONCLUSTERED INDEX
ALTER TABLE PaymentClaimTransaction DROP CONSTRAINT FK_PaymentClaimTransaction_ClaimTransaction
GO

--Drop Existing clustered PK 
ALTER TABLE ClaimTransaction DROP CONSTRAINT PK_ClaimTransaction
GO

--Add new non clustered PK 
ALTER TABLE ClaimTransaction ADD CONSTRAINT PK_ClaimTransaction PRIMARY KEY NONCLUSTERED (ClaimTransactionID)
GO

--Replace FK relationship
ALTER TABLE PaymentClaimTransaction ADD CONSTRAINT FK_PaymentClaimTransaction_ClaimTransaction
FOREIGN KEY (ClaimTransactionID) REFERENCES ClaimTransaction (ClaimTransactionID)
ON DELETE NO ACTION ON UPDATE NO ACTION
GO

--Create New Clustered Index
CREATE UNIQUE CLUSTERED INDEX CI_ClaimTransaction_PracticeID_ClaimTransactionID_ClaimID
ON ClaimTransaction (PracticeID, ClaimTransactionID, ClaimID)
GO

--===========================================================================
-- ENCOUNTER
--===========================================================================
--Remove FK to allow Drop of Encounter PK
ALTER TABLE Payment DROP CONSTRAINT FK_Payment_Encounter
GO

--Remove FK to allow Drop of Encounter PK
ALTER TABLE Bill DROP CONSTRAINT FK_Bill_Encounter
GO

--Remove FK to allow Drop of Encounter PK
ALTER TABLE EncounterDiagnosis DROP CONSTRAINT FK_EncounterDiagnosis_Encounter
GO

--Remove FK to allow Drop of Encounter PK
ALTER TABLE EncounterProcedure DROP CONSTRAINT FK_EncounterProcedure_Encounter
GO

--Remove FK to allow Drop of Encounter PK
ALTER TABLE EncounterToPatientInsurance DROP CONSTRAINT FK_EncounterToPatientInsurance_Encounter
GO

--Remove existing PK
ALTER TABLE Encounter DROP CONSTRAINT PK_Encounter
GO

--Replace with new nonclustered PK
ALTER TABLE Encounter ADD CONSTRAINT PK_Encounter PRIMARY KEY NONCLUSTERED (EncounterID)
GO

--Replace FK relationship
ALTER TABLE EncounterToPatientInsurance ADD CONSTRAINT FK_EncounterToPatientInsurance_Encounter
FOREIGN KEY (EncounterID) REFERENCES Encounter (EncounterID)
ON DELETE NO ACTION ON UPDATE NO ACTION
GO

--Replace FK relationship
ALTER TABLE EncounterProcedure ADD CONSTRAINT FK_EncounterProcedure_Encounter
FOREIGN KEY (EncounterID) REFERENCES Encounter (EncounterID)
ON DELETE NO ACTION ON UPDATE NO ACTION
GO

--Replace FK relationship
ALTER TABLE EncounterDiagnosis ADD CONSTRAINT FK_EncounterDiagnosis_Encounter
FOREIGN KEY (EncounterID) REFERENCES Encounter (EncounterID)
ON DELETE NO ACTION ON UPDATE NO ACTION
GO

--Replace FK relationship
ALTER TABLE Bill ADD CONSTRAINT FK_Bill_Encounter
FOREIGN KEY (EncounterID) REFERENCES Encounter (EncounterID)
ON DELETE NO ACTION ON UPDATE NO ACTION
GO

--Replace FK relationship
ALTER TABLE Payment ADD CONSTRAINT FK_Payment_Encounter
FOREIGN KEY (SourceEncounterID) REFERENCES Encounter (EncounterID)
ON DELETE NO ACTION ON UPDATE NO ACTION
GO

--Add new Clustered Index
CREATE UNIQUE CLUSTERED INDEX CI_Encounter_PracticeID_EncounterID
ON Encounter (PracticeID, EncounterID)
GO

--===========================================================================
-- ENCOUNTERDIAGNOSIS
--===========================================================================
--Add PracticeID column for new clustered index
ALTER TABLE EncounterDiagnosis ADD PracticeID INT
GO

--Populate the new column
UPDATE EncounterDiagnosis SET PracticeID=E.PracticeID
FROM EncounterDiagnosis ED INNER JOIN Encounter E ON ED.EncounterID=E.EncounterID
GO

--Set the new column to NOT NULL
ALTER TABLE EncounterDiagnosis ALTER COLUMN PracticeID INT NOT NULL
GO

--Drop existing Clustered PK
ALTER TABLE EncounterDiagnosis DROP CONSTRAINT PK_EncounterDiagnosis
GO

--Add new nonclustered PK
ALTER TABLE EncounterDiagnosis ADD CONSTRAINT PK_EncounterDiagnosis
PRIMARY KEY NONCLUSTERED (EncounterDiagnosisID)
GO

--Add new Clustered Index
CREATE UNIQUE CLUSTERED INDEX CI_EncounterDiagnosis_PracticeID_EncounterDiagnosisID_EncounterID
ON EncounterDiagnosis (PracticeID, EncounterDiagnosisID, EncounterID)
GO

--===========================================================================
-- ENCOUNTERPROCEDURE
--===========================================================================
--Add PracticeID column for new clustered index
ALTER TABLE EncounterProcedure ADD PracticeID INT
GO

--Populate the new column
UPDATE EncounterProcedure SET PracticeID=E.PracticeID
FROM EncounterProcedure EP INNER JOIN Encounter E ON EP.EncounterID=E.EncounterID
GO

--Set the new column to NOT NULL
ALTER TABLE EncounterProcedure ALTER COLUMN PracticeID INT NOT NULL
GO

--Drop existing Clustered PK
ALTER TABLE EncounterProcedure DROP CONSTRAINT PK_EncounterProcedure
GO

--Add new nonclustered PK
ALTER TABLE EncounterProcedure ADD CONSTRAINT PK_EncounterProcedure
PRIMARY KEY NONCLUSTERED (EncounterProcedureID)
GO

--Add new Clustered Index
CREATE UNIQUE CLUSTERED INDEX CI_EncounterProcedure_PracticeID_EncounterProcedureID_EncounterID
ON EncounterProcedure (PracticeID, EncounterProcedureID, EncounterID)
GO

--===========================================================================
-- ENCOUNTERTOPATIENTINSURANCE
--===========================================================================
--Add PracticeID column for new clustered index
ALTER TABLE EncounterToPatientInsurance ADD PracticeID INT
GO

--Populate the new column
UPDATE EncounterToPatientInsurance SET PracticeID=E.PracticeID
FROM EncounterToPatientInsurance ETPI INNER JOIN Encounter E ON ETPI.EncounterID=E.EncounterID
GO

--Set the new column to NOT NULL
ALTER TABLE EncounterToPatientInsurance ALTER COLUMN PracticeID INT NOT NULL
GO

--Drop existing Clustered PK
ALTER TABLE EncounterToPatientInsurance DROP CONSTRAINT PK_EncounterToPatientInsurance
GO

--Add new nonclustered PK
ALTER TABLE EncounterToPatientInsurance ADD CONSTRAINT PK_EncounterToPatientInsurance
PRIMARY KEY NONCLUSTERED (EncounterID, PatientInsuranceID)
GO

--Add new Clustered Index
CREATE UNIQUE CLUSTERED INDEX CI_EncounterToPatientInsurance_PracticeID_EncounterToPatientInsuranceID_EncounterID
ON EncounterToPatientInsurance (PracticeID, EncounterID, PatientInsuranceID)
GO

--===========================================================================
-- PATIENT
--===========================================================================
--Drop FK to enable dropping and adding of PK with NONCLUSTERED INDEX
ALTER TABLE Encounter DROP CONSTRAINT FK_Encounter_Patient
GO

--Drop FK to enable dropping and adding of PK with NONCLUSTERED INDEX
ALTER TABLE PatientAuthorization DROP CONSTRAINT FK_PatientAuthorization_Patient
GO

--Drop FK to enable dropping and adding of PK with NONCLUSTERED INDEX
ALTER TABLE PatientInsurance DROP CONSTRAINT FK_PatientInsurance_Patient
GO

--Drop FK to enable dropping and adding of PK with NONCLUSTERED INDEX
ALTER TABLE PaymentPatient DROP CONSTRAINT FK_PaymentPatient_Patient
GO

--Drop existing PK
ALTER TABLE Patient DROP CONSTRAINT PK_Patient
GO

--Replace with new nonclustered PK
ALTER TABLE Patient ADD CONSTRAINT PK_Patient PRIMARY KEY NONCLUSTERED (PatientID)
GO

--Replace FK relationship
ALTER TABLE PaymentPatient ADD CONSTRAINT FK_PaymentPatient_Patient
FOREIGN KEY (PatientID) REFERENCES Patient (PatientID)
ON DELETE NO ACTION ON UPDATE NO ACTION
GO

--Replace FK relationship
ALTER TABLE PatientInsurance ADD CONSTRAINT FK_PatientInsurance_Patient
FOREIGN KEY (PatientID) REFERENCES Patient (PatientID)
ON DELETE NO ACTION ON UPDATE NO ACTION
GO

--Replace FK relationship
ALTER TABLE PatientAuthorization ADD CONSTRAINT FK_PatientAuthorization_Patient
FOREIGN KEY (PatientID) REFERENCES Patient (PatientID)
ON DELETE NO ACTION ON UPDATE NO ACTION
GO

--Replace FK relationship
ALTER TABLE Encounter ADD CONSTRAINT FK_Encounter_Patient
FOREIGN KEY (PatientID) REFERENCES Patient (PatientID)
ON DELETE NO ACTION ON UPDATE NO ACTION
GO

--Create new Clustered Index
CREATE UNIQUE CLUSTERED INDEX CI_Patient_PracticeID_PatientID
ON Patient (PracticeID, PatientID)
GO

--===========================================================================
-- PATIENTINSURANCE
--===========================================================================
--Add PracticeID column for new clustered index
ALTER TABLE PatientInsurance ADD PracticeID INT
GO

--Populate PracticeID
UPDATE PatientInsurance SET PracticeID=P.PracticeID
FROM PatientInsurance PatI INNER JOIN Patient P ON PatI.PatientID=P.PatientID
GO

--Set the new column to NOT NULL
ALTER TABLE PatientInsurance ALTER COLUMN PracticeID INT NOT NULL
GO

--Drop FK to enable dropping and adding of PK with NONCLUSTERED INDEX
ALTER TABLE EncounterToPatientInsurance DROP CONSTRAINT FK_EncounterToPatientInsurance_PatientInsurance
GO

--Drop FK to enable dropping and adding of PK with NONCLUSTERED INDEX
ALTER TABLE PatientAuthorization DROP CONSTRAINT FK_PatientAuthorization_PatientInsurance
GO

--Drop current Clustered PK
ALTER TABLE PatientInsurance DROP CONSTRAINT PK_PatientInsurance
GO

--Add new nonclustered PK
ALTER TABLE PatientInsurance ADD CONSTRAINT PK_PatientInsurance
PRIMARY KEY NONCLUSTERED (PatientInsuranceID)
GO

--Replace FK relationship
ALTER TABLE PatientAuthorization ADD CONSTRAINT FK_PatientAuthorization_PatientInsurance
FOREIGN KEY (PatientInsuranceID) REFERENCES PatientInsurance (PatientInsuranceID)
ON DELETE NO ACTION ON UPDATE NO ACTION
GO

--Replace FK relationship
ALTER TABLE EncounterToPatientInsurance ADD CONSTRAINT FK_EncounterToPatientInsurance_PatientInsurance
FOREIGN KEY (PatientInsuranceID) REFERENCES PatientInsurance (PatientInsuranceID)
ON DELETE NO ACTION ON UPDATE NO ACTION
GO

--Create new Clustered Index
CREATE UNIQUE CLUSTERED INDEX CI_PatientInsurance_PracticeID_PatientInsuranceID_PatientID
ON PatientInsurance (PracticeID, PatientInsuranceID, PatientID)
GO

--===========================================================================
-- PAYMENT
--===========================================================================
--Drop FK to enable dropping and adding of PK with NONCLUSTERED INDEX
ALTER TABLE ClearinghouseResponse DROP CONSTRAINT FK_ClearinghouseResponse_Payment
GO

--Drop FK to enable dropping and adding of PK with NONCLUSTERED INDEX
ALTER TABLE PaymentClaimTransaction DROP CONSTRAINT FK_PaymentClaimTransaction_Payment
GO

--Drop FK to enable dropping and adding of PK with NONCLUSTERED INDEX
ALTER TABLE PaymentPatient DROP CONSTRAINT FK_PaymentPatient_Payment
GO

--Drop FK to enable dropping and adding of PK with NONCLUSTERED INDEX
ALTER TABLE RefundToPayments DROP CONSTRAINT FK_RefundToPayments_PaymentID
GO

--Drop existing PK
ALTER TABLE Payment DROP CONSTRAINT PK_Payment
GO

--Add new nonclustered PK
ALTER TABLE Payment ADD CONSTRAINT PK_Payment PRIMARY KEY NONCLUSTERED (PaymentID)
GO

--Replace FK relationship
ALTER TABLE RefundToPayments ADD CONSTRAINT FK_RefundToPayments_PaymentID
FOREIGN KEY (PaymentID) REFERENCES Payment (PaymentID)
ON DELETE NO ACTION ON UPDATE NO ACTION
GO

--Replace FK relationship
ALTER TABLE PaymentPatient ADD CONSTRAINT FK_PaymentPatient_Payment
FOREIGN KEY (PaymentID) REFERENCES Payment (PaymentID)
ON DELETE NO ACTION ON UPDATE NO ACTION
GO

--Replace FK relationship
ALTER TABLE PaymentClaimTransaction ADD CONSTRAINT FK_PaymentClaimTransaction_Payment
FOREIGN KEY (PaymentID) REFERENCES Payment (PaymentID)
ON DELETE NO ACTION ON UPDATE NO ACTION
GO

--Replace FK relationship
ALTER TABLE ClearinghouseResponse ADD CONSTRAINT FK_ClearinghouseResponse_Payment
FOREIGN KEY (PaymentID) REFERENCES Payment (PaymentID)
ON DELETE NO ACTION ON UPDATE NO ACTION
GO

--Create new Clustered Index
CREATE UNIQUE CLUSTERED INDEX CI_Payment_PracticeID_PaymentID
ON Payment (PracticeID, PaymentID)
GO

--===========================================================================
-- PAYMENTCLAIMTRANSACTION
--===========================================================================
--Add PracticeID column for new clustered index
ALTER TABLE PaymentClaimTransaction ADD PracticeID INT
GO

--Populate PracticeID
UPDATE PaymentClaimTransaction SET PracticeID=P.PracticeID
FROM PaymentClaimTransaction PCT INNER JOIN Payment P ON PCT.PaymentID=P.PaymentID
GO

--Make PracticeID column NOT NULL
ALTER TABLE PaymentClaimTransaction ALTER COLUMN PracticeID INT NOT NULL
GO

--Drop Existing clustered PK
ALTER TABLE PaymentClaimTransaction DROP CONSTRAINT PK_PaymentClaimTransaction
GO

--Add new nonclustered PK
ALTER TABLE PaymentClaimTransaction ADD CONSTRAINT PK_PaymentClaimTransaction
PRIMARY KEY NONCLUSTERED (PaymentClaimTransactionID)
GO

--Add new clusterd index
CREATE UNIQUE CLUSTERED INDEX CI_PaymentClaimTransaction_PracticeID_PaymentClaimTransactionID_ClaimID
ON PaymentClaimTransaction (PracticeID, PaymentClaimTransactionID, ClaimID, ClaimTransactionID)
GO

--===========================================================================
-- PAYMENTPATIENT
--===========================================================================
--Add PracticeID column for new clustered index
ALTER TABLE PaymentPatient ADD PracticeID INT
GO

--Populate PracticeID
UPDATE PaymentPatient SET PracticeID=P.PracticeID
FROM PaymentPatient PP INNER JOIN Payment P ON PP.PaymentID=P.PaymentID
GO

--Make PracticeID column NOT NULL
ALTER TABLE PaymentPatient ALTER COLUMN PracticeID INT NOT NULL
GO

--Drop Existing clustered PK
ALTER TABLE PaymentPatient DROP CONSTRAINT PK_PaymentPatient
GO

--Add new nonclustered PK
ALTER TABLE PaymentPatient ADD CONSTRAINT PK_PaymentPatient
PRIMARY KEY NONCLUSTERED (PaymentPatientID)
GO

--Add new clusterd index
CREATE UNIQUE CLUSTERED INDEX CI_PaymentPatient_PracticeID_PaymentPatientID_PaymentID_PatientID
ON PaymentPatient (PracticeID, PaymentPatientID, PaymentID, PatientID)
GO

--===========================================================================
-- PRACTICEFEE
--===========================================================================
--Add PracticeID column for new clustered index
ALTER TABLE PracticeFee ADD PracticeID INT
GO

--Populate PracticeID
UPDATE PracticeFee SET PracticeID=PFS.PracticeID
FROM PracticeFee PF INNER JOIN PracticeFeeSchedule PFS ON PF.PracticeFeeScheduleID=PFS.PracticeFeeScheduleID
GO

--Make PracticeID column NOT NULL
ALTER TABLE PracticeFee ALTER COLUMN PracticeID INT NOT NULL
GO

--Drop Existing clustered PK
ALTER TABLE PracticeFee DROP CONSTRAINT PK_PracticeFee
GO

--Add new nonclustered PK
ALTER TABLE PracticeFee ADD CONSTRAINT PK_PracticeFee
PRIMARY KEY NONCLUSTERED (PracticeFeeID)
GO

--Add new clusterd index
CREATE UNIQUE CLUSTERED INDEX CI_PracticeFee_PracticeID_PracticeFeeID_PracticeFeeScheduleID
ON PracticeFee (PracticeID, PracticeFeeID, PracticeFeeScheduleID)
GO

--===========================================================================
-- ReferringPhysician
--===========================================================================
--Drop FK to enable dropping and adding of PK with NONCLUSTERED INDEX
ALTER TABLE Encounter DROP CONSTRAINT FK_Encounter_ReferringPhysician
GO

--Drop FK to enable dropping and adding of PK with NONCLUSTERED INDEX
ALTER TABLE Patient DROP CONSTRAINT FK_Patient_ReferringPhysician
GO

--Drop FK to enable dropping and adding of PK with NONCLUSTERED INDEX
ALTER TABLE Claim DROP CONSTRAINT FK_Claim_ReferringPhysician
GO

--Drop Existing clustered PK
ALTER TABLE ReferringPhysician DROP CONSTRAINT PK_ReferringPhysician
GO

--Add new nonclustered PK
ALTER TABLE ReferringPhysician ADD CONSTRAINT PK_ReferringPhysician
PRIMARY KEY NONCLUSTERED (ReferringPhysicianID)
GO

--Replace FK relationship
ALTER TABLE Claim ADD CONSTRAINT FK_Claim_ReferringPhysician
FOREIGN KEY (ReferringProviderID) REFERENCES ReferringPhysician (ReferringPhysicianID)
ON DELETE NO ACTION ON UPDATE NO ACTION
GO

--Replace FK relationship
ALTER TABLE Patient ADD CONSTRAINT FK_Patient_ReferringPhysician
FOREIGN KEY (ReferringPhysicianID) REFERENCES ReferringPhysician (ReferringPhysicianID)
ON DELETE NO ACTION ON UPDATE NO ACTION
GO

--Replace FK relationship
ALTER TABLE Encounter ADD CONSTRAINT FK_Encounter_ReferringPhysician
FOREIGN KEY (ReferringPhysicianID) REFERENCES ReferringPhysician (ReferringPhysicianID)
ON DELETE NO ACTION ON UPDATE NO ACTION
GO

--Add new clusterd index
CREATE UNIQUE CLUSTERED INDEX CI_ReferringPhysician_PracticeID_ReferringPhysicianID
ON ReferringPhysician (PracticeID, ReferringPhysicianID)
GO

--Rebuild only the Clustered Indexes to defrag tables

--DECLARE @DbName VARCHAR(255)
DECLARE @MaxRetries INT, @MaxScanDensity DECIMAL, @MaxExtentFrag DECIMAL

--SET @DbName='gtest3'
SET @MaxRetries=1
SET @MaxScanDensity=95.00
SET @MaxExtentFrag=5.00


CREATE TABLE #Indexes (ObjectName VARCHAR(255), ObjectId INT, IndexName VARCHAR(255), IndexId INT,
		      Level INT, Pages INT, Rows INT, MinimumRecordsSize INT, MaximumRecordSize INT,
                      AverageRecordSize INT, ForwardedRecords INT, Extents INT, ExtentSwitches INT,
                      AverageFreeBytes INT, AveragePageDensity INT, ScanDensity DECIMAL, BestCount INT,
                      ActualCount INT, LogicalFragmentation DECIMAL, ExtentFragmentation DECIMAL)

CREATE TABLE #Indexes_Filtered (TID INT IDENTITY(1,1),ObjectName VARCHAR(255), ObjectId INT, IndexName VARCHAR(255), IndexId INT,
		      Level INT, Pages INT, Rows INT, MinimumRecordsSize INT, MaximumRecordSize INT,
                      AverageRecordSize INT, ForwardedRecords INT, Extents INT, ExtentSwitches INT,
                      AverageFreeBytes INT, AveragePageDensity INT, ScanDensity DECIMAL, BestCount INT,
                      ActualCount INT, LogicalFragmentation DECIMAL, ExtentFragmentation DECIMAL)

DECLARE @SQL VARCHAR(1000)

CREATE TABLE #Tables (TID INT IDENTITY(1,1), TableName VARCHAR(255))

-- SET @SQL='INSERT INTO #Tables(TableName)
-- 	  SELECT Name
-- 	  FROM '+@DbName+'..sysobjects
-- 	  WHERE xtype=''U'''
-- EXEC(@SQL)

INSERT INTO #Tables(TableName)
SELECT Name
FROM sysobjects
WHERE xtype='U'

DECLARE @Counter INT
DECLARE @Loop INT
DECLARE @CurrentTable VARCHAR(255)
DECLARE @DBCSQL VARCHAR(500)
DECLARE @SQL2EXEC VARCHAR(500)

SET @DBCSQL='DBCC SHOWCONTIG ({0}) 
      WITH TABLERESULTS, ALL_INDEXES, NO_INFOMSGS'

SET @CurrentTable=''
SET @Counter=0
SELECT @Loop=COUNT(TableName) FROM #Tables

WHILE @Counter<@Loop
BEGIN
	SET @Counter=@Counter+1
	SELECT @CurrentTable=TableName
	FROM #Tables
	WHERE TID=@Counter
	
	SET @SQL2EXEC=REPLACE(@DBCSQL,'{0}',@CurrentTable)

	INSERT INTO #Indexes(ObjectName , ObjectId , IndexName , IndexId ,
			      Level , Pages , Rows , MinimumRecordsSize , MaximumRecordSize ,
	                      AverageRecordSize , ForwardedRecords , Extents , ExtentSwitches ,
	                      AverageFreeBytes , AveragePageDensity , ScanDensity , BestCount ,
	                      ActualCount , LogicalFragmentation , ExtentFragmentation)
	EXEC(@SQL2EXEC)

END

DELETE FROM #Indexes
WHERE SUBSTRING(IndexName,1,2)<>'CI'

INSERT INTO #Indexes_Filtered(ObjectName , ObjectId , IndexName , IndexId ,
		      Level , Pages , Rows , MinimumRecordsSize , MaximumRecordSize ,
                      AverageRecordSize , ForwardedRecords , Extents , ExtentSwitches ,
                      AverageFreeBytes , AveragePageDensity , ScanDensity , BestCount ,
                      ActualCount , LogicalFragmentation , ExtentFragmentation)
SELECT * FROM #Indexes

DECLARE @RetryCounter INT
DECLARE @RetryLoop INT

SET @RetryLoop=0
SET @RetryCounter=0

IF @MaxRetries IS NULL
	SET @RetryLoop=1
ELSE
	SET @RetryLoop=@MaxRetries

DECLARE @IndexCounter INT
DECLARE @IndexLoop INT
DECLARE @CurrentObj VARCHAR(255)
DECLARE @CurrentIndex VARCHAR(255)
DECLARE @RI_DBCSQL VARCHAR(500)

DECLARE @RunSQL VARCHAR(8000)
SET @RunSQL=''

SET @RI_DBCSQL='UPDATE STATISTICS {1}
		DBCC DBREINDEX({1},{2})
		'

SET @IndexCounter=0
SELECT @IndexLoop=COUNT(TID) FROM #Indexes_Filtered

WHILE @IndexCounter<@IndexLoop
BEGIN
	SET @IndexCounter=@IndexCounter+1
	SELECT @CurrentObj=ObjectName, @CurrentIndex=IndexName FROM #Indexes_Filtered WHERE TID=@IndexCounter

	SET @RetryCounter=0

	WHILE @RetryCounter<@RetryLoop
	BEGIN
		SET @RetryCounter=@RetryCounter+1

		SET @SQL2EXEC=REPLACE(@RI_DBCSQL,'{1}',@CurrentObj)
		SET @SQL2EXEC=REPLACE(@SQL2EXEC,'{2}',@CurrentIndex)
		EXEC(@SQL2EXEC)

	END
	
END

DROP TABLE #Indexes
DROP TABLE #Indexes_Filtered
DROP TABLE #Tables


--Update Database Stats
EXEC SP_UPDATESTATS

---------------------------------------------------------------------------------------
--case XXXX - Description

IF(
SELECT	Count(*)
FROM	Information_Schema.Columns
WHERE	Table_Schema = 'dbo' 
AND	Table_name = 'ClaimTransaction'
AND	Column_Name = 'IsFirstBill') = 0
BEGIN
	ALTER TABLE
		ClaimTransaction
	ADD
		IsFirstBill BIT NOT NULL DEFAULT 0

	EXEC dbo.DataManagement_RegenerateClaimTransactionBalances
END

GO

---------------------------------------------------------------------------------------
--case 3965 - Exception when approving Encounter in Trial Customer

--Get Rid of unecessary and harmful trigger
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tr_IU_ClaimTransaction_ChangeTime]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[tr_IU_ClaimTransaction_ChangeTime]
GO

--Drop existing to recreate new version
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tr_ClaimTransaction_MaintainClaimBalances]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[tr_ClaimTransaction_MaintainClaimBalances]
GO

--===========================================================================
-- Maintain Claim amount info in the ClaimTransaction table
--===========================================================================
CREATE TRIGGER dbo.tr_ClaimTransaction_MaintainClaimBalances
ON	dbo.ClaimTransaction
FOR	INSERT, UPDATE
AS
BEGIN
	--
	--INSERT __trigger_count
--	SELECT MAX(IDD)
--	FROM
--	(SELECT MAX(ID) + 1 as IDD FROM __trigger_count
--	UNION 
--	SELECT 1) T
	
	--
	DECLARE @error_var int
	SET @error_var = 0
	DECLARE @proc_name sysname
    SET @proc_name = (SELECT name FROM sysobjects WHERE id = @@PROCID)
	DECLARE @CRLF char(2)
    SET @CRLF = CHAR(13) + CHAR(10)
	DECLARE @err_message nvarchar(255)
	--
	DECLARE @ClaimTransactionID int
	DECLARE @InsideClaimTransactionID int
	DECLARE @ClaimID int
	DECLARE @TransactionDate datetime
	DECLARE @PracticeID int
	DECLARE @ProviderID int
	DECLARE @ClaimTransactionTypeCode varchar(3)
	DECLARE @Amount money
	DECLARE @PreviousAmount money
	
	DECLARE @BatchKey uniqueidentifier
	SET @BatchKey = NEWID()

	--Need to adjust the date because .net changes the date based upon time zone
	--This needs to happen regardless of the rest of the trigger
	IF UPDATE(ReferenceDate)
	BEGIN
		UPDATE CT
			SET ReferenceDate =  dbo.fn_ReplaceTimeInDate(i.ReferenceDate)
		FROM dbo.ClaimTransaction CT 
			INNER JOIN inserted i 
			ON CT.ClaimTransactionID = i.ClaimTransactionID

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END
	
	--If there IS only 1 record and its the newest record for the claim then we can optimize the call
	IF (SELECT COUNT(*) FROM inserted) = 1
	BEGIN

---------------------------------------------------------------------------------------
--case 3961 Company Indicators Summary shows incorrect output
		SELECT @ClaimTransactionID = i.ClaimTransactionID,
			@ClaimID = i.ClaimID,
			@Amount=i.Amount,
			@ClaimTransactionTypeCode=ClaimTransactionTypeCode,
			@TransactionDate=TransactionDate,
			@PracticeID=PracticeID,
			@ProviderID=Claim_ProviderID 
		FROM inserted I
		
		IF NOT EXISTS (	SELECT * 
						FROM dbo.ClaimTransaction CT 
						WHERE CT.ClaimTransactionID > @ClaimTransactionID
							AND CT.ClaimID = @ClaimID
						)
		BEGIN
			PRINT 'Updating Single Balance ON ' + CAST(@ClaimTransactionID AS varchar)
			--Update the currently affected transaction
			EXEC dbo.ClaimDataProvider_UpdateClaimTransactionBalances @ClaimTransactionID, @BatchKey
			/*********************************************************************************
			Maintain Summary Information
			*********************************************************************************/ 
			--Only maintain the summary TABLE when the transaction are financial
			--Need to CREATE records for billing and assingment
			IF (@ClaimTransactionTypeCode IN ('CST','PAY','END','ADJ', 'BLL'))
			BEGIN
				--Get some of the surrounding information
				SELECT
					@PracticeID = C.PracticeID,
					@ProviderID = C.RenderingProviderID
				FROM dbo.Claim C
				WHERE C.ClaimID = @ClaimID
				
				--Need to reset it each interation
				SET @PreviousAmount = NULL

				SELECT @PreviousAmount = Amount
				FROM deleted
				WHERE ClaimTransactionID = @ClaimTransactionID

				EXEC dbo.ClaimDataProvider_MaintainSummary
					@ClaimTransactionID,
					@TransactionDate,
					@PracticeID,
					@ProviderID,
					@ClaimTransactionTypeCode,
					@Amount,
					@PreviousAmount
					
				--Update the Claim Dates
			END
		
			RETURN
		END
	END


	CREATE TABLE #ClaimTransList(ClaimTransactionID int PRIMARY KEY)
	
	-- =============================================
	-- Declare and using a READ_ONLY cursor
	-- =============================================
	DECLARE claimtrans_cursor CURSOR
	READ_ONLY
	FOR 
		SELECT I.ClaimTransactionID,
			I.ClaimID,
			I.ClaimTransactionTypeCode,
			dbo.fn_DateOnly(I.TransactionDate),
			I.Amount
		FROM inserted I
	
	OPEN claimtrans_cursor
	

	FETCH NEXT FROM claimtrans_cursor INTO @ClaimTransactionID, @ClaimID, @ClaimTransactionTypeCode, @TransactionDate, @Amount
	WHILE (@@fetch_status <> -1)
	BEGIN

		IF (@@fetch_status <> -2)
		BEGIN
			--Do NOT reprocess claimtransactionid's already processed in this group
			IF NOT EXISTS(SELECT * FROM #ClaimTransList WHERE ClaimTransactionID = @ClaimTransactionID)
			BEGIN
				PRINT 'Updating Balances ON ' + CAST(@ClaimTransactionID AS varchar)
				--Update the currently affected transaction
				EXEC dbo.ClaimDataProvider_UpdateClaimTransactionBalances @ClaimTransactionID, @BatchKey
				
				/*********************************************************************************
				Maintain Summary Information
				*********************************************************************************/ 
				--Only maintain the summary TABLE when the transaction are financial
				--Need to CREATE records for billing and assingment
				IF (@ClaimTransactionTypeCode IN ('CST','PAY','END','ADJ', 'BLL', 'ASN'))
				BEGIN
					--Get some of the surrounding information
					SELECT
						@PracticeID = C.PracticeID,
						@ProviderID = C.RenderingProviderID
					FROM dbo.Claim C
					WHERE C.ClaimID = @ClaimID
					
					--Need to reset it each interation
					SET @PreviousAmount = NULL

					SELECT @PreviousAmount = Amount
					FROM deleted
					WHERE ClaimTransactionID = @ClaimTransactionID
					
					EXEC dbo.ClaimDataProvider_MaintainSummary 
						@ClaimTransactionID,
						@TransactionDate,
						@PracticeID,
						@ProviderID,
						@ClaimTransactionTypeCode,
						@Amount,
						@PreviousAmount
						
					--Update the Claim Dates
				END	


				--Any future transactions for this claim and UPDATE them AS well
				DECLARE inside_cursor CURSOR
				READ_ONLY
				FOR 
					SELECT ClaimTransactionID,
						ClaimTransactionTypeCode,
						dbo.fn_DateOnly(TransactionDate),
						Amount
					FROM dbo.ClaimTransaction CT
					WHERE CT.ClaimID = @ClaimID
						AND CT.ClaimTransactionID > @ClaimTransactionID
					ORDER BY ClaimTransactionID
				
				OPEN inside_cursor

---------------------------------------------------------------------------------------
--case 3972 Exception when Editing then Saving Claims

				--The Call to dbo.ClaimDataProvider_UpdateClaimTransactionBalances is causing other cursors to be used
				--inside same connection.  This is distorting the @@FETCH_STATUS return value
				--Therefore a check on unique id is required before processing
				FETCH NEXT FROM inside_cursor INTO @InsideClaimTransactionID, @ClaimTransactionTypeCode, @TransactionDate, @Amount
				WHILE (@@fetch_status <> -1 AND NOT EXISTS(SELECT * FROM #ClaimTransList WHERE ClaimTransactionID=@InsideClaimTransactionID))
				BEGIN

					IF (@@fetch_status <> -2)
					BEGIN
				
						INSERT #ClaimTransList(ClaimTransactionID)
						VALUES(@InsideClaimTransactionID)
						PRINT 'Updating Balances ON ' + CAST(@InsideClaimTransactionID AS varchar)							
						EXEC dbo.ClaimDataProvider_UpdateClaimTransactionBalances @InsideClaimTransactionID, @BatchKey

						/*********************************************************************************
						Maintain Summary Information
						*********************************************************************************/ 
						--Only maintain the summary TABLE when the transaction are financial
						--Need to CREATE records for billing and assingment
						IF (@ClaimTransactionTypeCode IN ('CST','PAY','END','ADJ', 'BLL', 'ASN'))
						BEGIN
							EXEC dbo.ClaimDataProvider_MaintainSummary 
								@InsideClaimTransactionID,
								@TransactionDate,
								@PracticeID,
								@ProviderID,
								@ClaimTransactionTypeCode,
								@Amount,
								@Amount  --<---This IS so the amount does NOT change, but the AR Balances are updated
								
							--Update the Claim Dates
						END
						
					END
					FETCH NEXT FROM inside_cursor INTO @InsideClaimTransactionID, @ClaimTransactionTypeCode, @TransactionDate, @Amount
				END
				
				CLOSE inside_cursor
				DEALLOCATE inside_cursor
			END
		END
		FETCH NEXT FROM claimtrans_cursor INTO @ClaimTransactionID, @ClaimID, @ClaimTransactionTypeCode, @TransactionDate, @Amount
	END
	
	CLOSE claimtrans_cursor
	DEALLOCATE claimtrans_cursor
	
	DROP TABLE #ClaimTransList	
	
	RETURN

rollback_tran:
	IF @err_message IS NULL
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)
	ELSE
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)  + @CRLF + @CRLF + @err_message

	IF @@TRANCOUNT > 0
    		ROLLBACK TRANSACTION

	RAISERROR(@err_message, 16,1)
	
END




GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tr_ClaimTransaction_MaintainClaimBalancesOnDelete]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[tr_ClaimTransaction_MaintainClaimBalancesOnDelete]
GO

--===========================================================================
-- Maintain Claim amount info in the ClaimTransaction table
--===========================================================================
CREATE TRIGGER dbo.tr_ClaimTransaction_MaintainClaimBalancesOnDelete
ON	dbo.ClaimTransaction
FOR	DELETE
AS
BEGIN
	IF (SELECT COUNT(*)
		FROM deleted) > 1
	BEGIN
		RAISERROR('Cannot DELETE more than 1 ClaimTransaction at a time',16,1)
		ROLLBACK
		RETURN
	END
	
	DECLARE @ClaimID int
	
	SELECT @ClaimID = ClaimID
	FROM deleted
	
	IF EXISTS(	SELECT CT.ClaimTransactionID
				FROM dbo.ClaimTransaction CT
				WHERE CT.ClaimID = @ClaimID 
					AND CT.ClaimTransactionTypeCode = 'XXX'
				UNION
				SELECT CT2.ClaimTransactionID
				FROM deleted CT2
				WHERE CT2.ClaimTransactionTypeCode IN  ('XXX')
			)
	BEGIN
		RAISERROR('Cannot DELETE a ClaimTransaction for a voided claim',16,1)
		ROLLBACK
		RETURN
	END
	
	CREATE TABLE #ClaimTransList(ClaimTransactionID int PRIMARY KEY)
	
	DECLARE claimtrans_deleted_cursor CURSOR
	READ_ONLY
	FOR 
		SELECT D.ClaimTransactionID,
			D.ClaimID,
			D.ClaimTransactionTypeCode,
			dbo.fn_DateOnly(D.TransactionDate),
			D.Amount
		FROM DELETED D
	
	DECLARE @ClaimTransactionID int
	DECLARE @FirstClaimTransactionID int
	DECLARE @InsideClaimTransactionID int
	DECLARE @TransactionDate datetime
	DECLARE @PracticeID int
	DECLARE @ProviderID int
	DECLARE @ClaimTransactionTypeCode varchar(3)
	DECLARE @Amount money
	DECLARE @PreviousAmount money
	
	DECLARE @BatchKey uniqueidentifier
	SET @BatchKey = NEWID()
	
	OPEN claimtrans_deleted_cursor
	
	FETCH NEXT FROM claimtrans_deleted_cursor INTO @ClaimTransactionID, @ClaimID, @ClaimTransactionTypeCode, @TransactionDate, @Amount
	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN
			--PRINT 'ClaimID ' + ISNULL(CAST(@ClaimID AS varchar),'NULL')

			--Get some of the surrounding information
			SELECT
				@PracticeID = C.PracticeID,
				@ProviderID = C.RenderingProviderID
			FROM dbo.Claim C
			WHERE C.ClaimID = @ClaimID

			--PRINT '@PracticeID ' + ISNULL(CAST(@PracticeID AS varchar),'NULL')

			/*********************************************************************************
			Maintain Summary Information
			*********************************************************************************/ 
			--Only maintain the summary TABLE when the transaction are financial
			--Need to CREATE records for billing and assingment
			IF (@ClaimTransactionTypeCode IN ('CST','PAY','END','ADJ', 'BLL', 'ASN'))
			BEGIN
				--Need to reset it each interation
				SET @PreviousAmount = NULL

				SELECT @PreviousAmount = Amount
				FROM deleted
				WHERE ClaimTransactionID = @ClaimTransactionID
				
				EXEC dbo.ClaimDataProvider_MaintainSummary 
					@ClaimTransactionID,
					@TransactionDate,
					@PracticeID,
					@ProviderID,
					@ClaimTransactionTypeCode,
					0,
					@PreviousAmount
					
				--Update the Claim Dates
			END
						
			SELECT @FirstClaimTransactionID = MIN(ClaimTransactionID)
			FROM dbo.ClaimTransaction CT
			WHERE CT.ClaimID = @ClaimID

			--Cause the chain of CT's to be re-calculated
			UPDATE dbo.ClaimTransaction 
				SET Amount = Amount
			WHERE ClaimTransactionID = @FirstClaimTransactionID	
		END
		FETCH NEXT FROM claimtrans_deleted_cursor INTO @ClaimTransactionID, @ClaimID, @ClaimTransactionTypeCode, @TransactionDate, @Amount
	END
	
	CLOSE claimtrans_deleted_cursor
	DEALLOCATE claimtrans_deleted_cursor
	
	DROP TABLE #ClaimTransList	

	RETURN
END


GO

--Trigger has changed
--===========================================================================	
IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'tr_Claim_MaintainClaimAmountInClaimTransaction'
	AND	TYPE = 'TR'
)
	DROP TRIGGER dbo.tr_Claim_MaintainClaimAmountInClaimTransaction
GO

--===========================================================================
-- Maintain Claim amount info in the ClaimTransaction table
--===========================================================================
CREATE TRIGGER dbo.tr_Claim_MaintainClaimAmountInClaimTransaction
ON	dbo.Claim
FOR	INSERT, UPDATE
AS
BEGIN
	IF UPDATE(ServiceChargeAmount) OR UPDATE(ServiceUnitCount)
	BEGIN 

		-- =============================================
		-- Declare and using a READ_ONLY cursor
		-- =============================================
		DECLARE claim_cursor CURSOR
		READ_ONLY
		FOR 
			SELECT I.ClaimID, 
				ISNULL(I.ServiceChargeAmount,0) * ISNULL(I.ServiceUnitCount,0) AS Amount,
				I.PatientID,
				I.PracticeID,
				I.RenderingProviderID,
				I.CreatedDate
			FROM inserted I
		
		DECLARE @ClaimID int
		DECLARE @Amount money
		DECLARE @ClaimTrnWithProcedureCntChng int
		DECLARE @ClaimTrDateWithProcedureCntChng datetime
		DECLARE @PreviousProcedureCount int
		DECLARE @PatientID int
		DECLARE @PracticeID int
		DECLARE @ProviderID int
		DECLARE @ClaimCreatedDate datetime	
		
		OPEN claim_cursor
		
		FETCH NEXT FROM claim_cursor INTO @ClaimID, @Amount, @PatientID, @PracticeID, @ProviderID,@ClaimCreatedDate
		WHILE (@@fetch_status <> -1)
		BEGIN
			IF (@@fetch_status <> -2)
			BEGIN
	
				IF NOT EXISTS(	SELECT *
							FROM dbo.ClaimTransaction CT
							WHERE CT.ClaimID = @ClaimID
								AND CT.ClaimTransactionTypeCode = 'CST'
							)
				BEGIN
					INSERT INTO [dbo].[ClaimTransaction] (
						[Amount],
						[ClaimID],
						[ClaimTransactionTypeCode],
						[Notes],
						[PatientID],
						[PracticeID],
						Claim_ProviderID,
						[TransactionDate],
						CreatedDate)
					VALUES (
						@Amount,
						@ClaimID,
						'CST',
						'Claim created for ' + STR(@Amount,15,2) + '  ',
						@PatientID,
						@PracticeID,
						@ProviderID,
						@ClaimCreatedDate,
						GETDATE()
						)
				END
				ELSE
				BEGIN 
					IF UPDATE(ServiceUnitCount)
					BEGIN				
						SELECT @ClaimTrnWithProcedureCntChng=ClaimTransactionID,
						       @ClaimTrDateWithProcedureCntChng=TransactionDate
						FROM ClaimTransaction
						WHERE ClaimID=@ClaimID AND ClaimTransactionTypeCode='CST'

						SELECT @PreviousProcedureCount=ServiceUnitCount
						FROM DELETED
						WHERE ClaimID=@ClaimID

						SELECT @PreviousProcedureCount
						
						EXEC ClaimDataProvider_MaintainSummary
							@ClaimTrnWithProcedureCntChng,
							@ClaimTrDateWithProcedureCntChng,
							@PracticeID,
							@ProviderID,
							'CST',
							0,
							Null,
							@PreviousProcedureCount
						
					END

					--Update the claim start transaction amount
					UPDATE	[dbo].[ClaimTransaction]
						SET	[Amount] = @Amount,
							[ModifiedDate] = GETDATE(),
							[Notes] = CAST(Notes AS varchar(8000)) + 'Claim updated for ' + STR(@Amount,15,2) + '  '
						WHERE ClaimID = @ClaimID
							AND ClaimTransactionTypeCode = 'CST'
				END 
			END
			FETCH NEXT FROM claim_cursor INTO @ClaimID, @Amount, @PatientID, @PracticeID, @ProviderID, @ClaimCreatedDate
		END
		
		CLOSE claim_cursor
		DEALLOCATE claim_cursor
	
	END

END



GO

---------------------------------------------------------------------------------------
--case 3858 - Add report parameters for the Superbill report

-- Took this out as we don't want the report in the menu anymore
/*
DECLARE @category int
DECLARE @reportid int

select @category = ReportCategoryID from ReportCategory where Name = 'Appointments'

insert into report
(ReportCategoryID, DisplayOrder, Image, Name, MenuName, Description, TaskName, ReportPath, PermissionValue, ReportParameters)
values
(@category, 10, '[[image[Practice.Reports.Images.reports.gif]]]', 'Superbill', '&Superbill', 'This report prints out a Superbill based on a Coding Template.', 'Report V2 Viewer', 
'/BusinessManagerReports/rptEncounterForm', 'PrintSuperbill',  
'<?xml version="1.0" encoding="utf-8" ?>
<parameters defaultMessage="Please select a Coding Template to display a Superbill." refreshOnParameterChange="true" requiredOverrideParameters="CodingTemplateID">
	<basicParameters>
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="CodingTemplate" parameterName="CodingTemplateID" text="Coding Template:" default="-1" ignore="-1" permission="FindCodingForm" />
	</basicParameters>
</parameters>' )

SET @reportid = scope_identity()

insert into ReportToSoftwareApplication
values (@reportid, 'M')

-- Change the menu name for Appointment Summary
UPDATE 	Report
SET	MenuName = '&Appointments Summary'
WHERE	Name = 'Appointments Summary'
*/

---------------------------------------------------------------------------------------
--case XXXX - Description

---------------------------------------------------------------------------------------

--ROLLBACK
--COMMIT
