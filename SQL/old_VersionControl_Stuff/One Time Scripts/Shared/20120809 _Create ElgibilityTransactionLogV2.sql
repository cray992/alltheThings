CREATE TABLE [dbo].[EligibilityTransactionLogV2]
(
[TransactionDate] [datetime] NULL,
[PayerNumber] [varchar] (32) NULL,
[PayerName] [varchar] (1000)  NULL,
[ProviderName] [varchar] (128)  NULL,
[ProviderID] [varchar] (128)  NULL,
[ErrorCode] [varchar] (10)  NULL,
[ErrorType] [varchar] (10)  NULL,
[FileName] [varchar] (1000)  NULL,
[CustomerId] [int] NULL,
[PracticeID] [int] NULL,
[UserID] [int] NULL,
[InsuranceCompanyID] [int] NULL,
[InsuranceCompanyName] [varchar] (128)  NULL,
[ClearinghousePayerID] [int] NULL,
[InsuranceCompanyPlanID] [int] NULL,
[PlanName] [varchar] (128)  NULL,
[InsurancePolicyId] [int] NULL,
[PolicyNumber] [varchar] (32)  NULL,
[PatientID] [int] NULL,
[CaseID] [int] NULL,
[PayerNumber271] [varchar] (32)  NULL,
[PayerName271] [varchar] (1000)  NULL,
[ProviderName271] [varchar] (128)  NULL,
[ProviderID271] [varchar] (128)  NULL,
[Success] [bit] NULL,
[ServiceTypeCode] [varchar] (2)  NULL,
[EligibilityTransactionLogV1ID] [int] NOT NULL,
[EligibilityTransactionLogV2ID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
--GO
--ALTER TABLE [dbo].[EligibilityTransactionLogV2] ADD CONSTRAINT [PK_EligibilityTransactionLogV2] PRIMARY KEY CLUSTERED  ([EligibilityTransactionLogV2ID]) ON [PRIMARY]
--GO
--CREATE NONCLUSTERED INDEX [IX_EligibilityTransactionLogV2_CustomerID_TransactionDate] ON [dbo].[EligibilityTransactionLogV2] ([CustomerId], [TransactionDate]) INCLUDE ([PracticeID], [InsuranceCompanyID], [InsuranceCompanyPlanID], [InsurancePolicyId], [PatientID], [CaseID]) WITH (FILLFACTOR=100) ON [PRIMARY]
--GO
--CREATE NONCLUSTERED INDEX [IX_EligibilityTransactionLogV2_UserID] ON [dbo].[EligibilityTransactionLogV2] ([UserID]) WITH (FILLFACTOR=100) ON [PRIMARY]
--GO
--CREATE NONCLUSTERED INDEX [IX_EligibilityTransactionLogV2_TransactionDate] ON [dbo].[EligibilityTransactionLogV2] ([TransactionDate]) ON [PRIMARY]
--GO
--CREATE NONCLUSTERED INDEX [IX_EligibilityTransactionLogV2] ON [dbo].[EligibilityTransactionLogV2] ([EligibilityTransactionLogV2ID]) ON [PRIMARY]
--GO

----DROP TABLE dbo.EligibilityTransactionLogV2
--sp_rename 'EligibilityTransactionLog','EligibilityTransactionLog_OLD'
--sp_rename 'EligibilityTransactionLogV2','EligibilityTransactionLog'


--DROP TABLE dbo.EligibilityTransactionLog