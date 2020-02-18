IF NOT EXISTS(SELECT * FROM sys.objects AS O WHERE name='EligibilityTransactionLog_OLD')
	EXEC sp_rename 'EligibilityTransactionLog', 'EligibilityTransactionLog_OLD'
GO

IF NOT EXISTS(SELECT * FROM sys.objects AS O WHERE name='EligibilityTransactionLog')
BEGIN 
	CREATE TABLE [dbo].[EligibilityTransactionLog](
		   [TransactionDate] [datetime] NULL,
		   [PayerNumber] [varchar](32) NULL,
		   [PayerName] [varchar](1000) NULL,
		   [ProviderName] [varchar](128) NULL,
		   [ProviderID] [varchar](128) NULL,
		   [ErrorCode] [varchar](10) NULL,
		   [ErrorType] [varchar](10) NULL,
		   [FileName] [varchar](1000) NULL,
		   [CustomerId] [int] NULL,
		   [PracticeID] [int] NULL,
		   [UserID] [int] NULL,
		   [InsuranceCompanyID] [int] NULL,
		   [InsuranceCompanyName] [varchar](128) NULL,
		   [ClearinghousePayerID] [int] NULL,
		   [InsuranceCompanyPlanID] [int] NULL,
		   [PlanName] [varchar](128) NULL,
		   [InsurancePolicyId] [int] NULL,
		   [PolicyNumber] [varchar](32) NULL,
		   [PatientID] [int] NULL,
		   [CaseID] [int] NULL,
		   [PayerNumber271] [varchar](32) NULL,
		   [PayerName271] [varchar](1000) NULL,
		   [ProviderName271] [varchar](128) NULL,
		   [ProviderID271] [varchar](128) NULL,
		   [Success] [bit] NULL,
		   [ServiceTypeCode] [varchar](2) NULL,
		   [EligibilityTransactionLogV1ID] [int] NULL,
		   [EligibilityTransactionLogV2ID] [int] IDENTITY(1,1) NOT NULL,
		   [EligibilityTransportID] [int] NULL,
		   [Fallback] [int] NULL,
		   [DurationInMs] [int] NULL
	) ON [PRIMARY] 
	SET ANSI_PADDING OFF
	ALTER TABLE [dbo].[EligibilityTransactionLog] ADD [RequestData] [varchar](max) NULL
	ALTER TABLE [dbo].[EligibilityTransactionLog] ADD [ResponseData] [varchar](max) NULL
	ALTER TABLE [dbo].[EligibilityTransactionLog] ADD [ErrorTrace] [varchar](max) NULL
	CONSTRAINT [PK_EligibilityTransactionLog] PRIMARY KEY CLUSTERED 
	(
		   [EligibilityTransactionLogV2ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END 
