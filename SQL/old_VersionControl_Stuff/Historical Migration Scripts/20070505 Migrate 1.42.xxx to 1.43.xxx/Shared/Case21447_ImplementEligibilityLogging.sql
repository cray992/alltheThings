-----------------------------------------------------------------------------------------------------
-- 21447 - Eligibility Transaction Log. Add columns to EligibilityTransactionLog
-----------------------------------------------------------------------------------------------------
ALTER TABLE EligibilityTransactionLog ADD
	CustomerId INT NULL, 
	PracticeID INT NULL,
	UserID INT NULL,
	InsuranceCompanyID int NULL,
	InsuranceCompanyName varchar(128) NULL,
	ClearinghousePayerID int NULL,
	InsuranceCompanyPlanID int NULL,
	PlanName varchar(128) NULL,
	InsurancePolicyId int NULL,
	PolicyNumber varchar(32) NULL,
	PatientID int NULL,
	CaseID int NULL,
	PayerNumber271 nchar(32) NULL,
	PayerName271 nchar(1000) NULL,
	ProviderName271 nchar(128) NULL,
	ProviderID271 nchar(32) NULL,
	Success BIT NULL
GO


--CREATE TABLE [dbo].[EligibilityTransactionLog](
--	[TransactionDate] [datetime] NULL,
--	[PayerNumber] [nchar](32)  NULL,
--	[PayerName] [nchar](1000)  NULL,
--	[ProviderName] [nchar](128)  NULL,
--	[ProviderID] [nchar](128)  NULL,
--	[ErrorCode] [nchar](10)  NULL,
--	[ErrorType] [nchar](10)  NULL,
--	[FileName] [nchar](1000)  NULL,
--	[CustomerId] [int] NULL,
--	[PracticeID] [int] NULL,
--	[UserID] [int] NULL,
--	[InsuranceCompanyID] [int] NULL,
--	[InsuranceCompanyName] [varchar](128)  NULL,
--	[ClearinghousePayerID] [int] NULL,
--	[InsuranceCompanyPlanID] [int] NULL,
--	[PlanName] [varchar](128)  NULL,
--	[InsurancePolicyId] [int] NULL,
--	[PolicyNumber] [varchar](32)  NULL,
--	[PatientID] [int] NULL,
--	[CaseID] [int] NULL,
--	[PayerNumber271] [nchar](32)  NULL,
--	[PayerName271] [nchar](1000)  NULL,
--	[ProviderName271] [nchar](128)  NULL,
--	[ProviderID271] [nchar](32)  NULL,
--	[Success] [bit] NULL
--) ON [PRIMARY]
--
--GO
