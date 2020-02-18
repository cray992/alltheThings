CREATE TABLE [ActivityType] (
	[ActivityTypeCode] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	CONSTRAINT [PK_ActivityType] PRIMARY KEY  CLUSTERED 
	(
		[ActivityTypeCode]
	)  ON [PRIMARY] 
) ON [PRIMARY]
GO



CREATE TABLE [GroupNumberType] (
	[GroupNumberTypeID] [int] IDENTITY (1, 1) NOT NULL ,
	[TypeName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	CONSTRAINT [PK_GroupNumberType] PRIMARY KEY  CLUSTERED 
	(
		[GroupNumberTypeID]
	)  ON [PRIMARY] 
) ON [PRIMARY]
GO

/*
CREATE TABLE [PaymentClaimTransaction] (
	[PaymentClaimTransactionID] [int] IDENTITY (1, 1) NOT NULL ,
	[PaymentID] [int] NOT NULL ,
	[ClaimID] [int] NOT NULL ,
	[ClaimTransactionID] [int] NULL ,
	CONSTRAINT [PK_PaymentClaimTransaction] PRIMARY KEY  CLUSTERED 
	(
		[PaymentClaimTransactionID]
	)  ON [PRIMARY] ,
	CONSTRAINT [FK_PaymentClaimTransaction_ClaimTransaction] FOREIGN KEY 
	(
		[ClaimTransactionID]
	) REFERENCES [ClaimTransaction] (
		[ClaimTransactionID]
	),
	CONSTRAINT [FK_PaymentClaimTransaction_Payment] FOREIGN KEY 
	(
		[PaymentID]
	) REFERENCES [Payment] (
		[PaymentID]
	)
) ON [PRIMARY]
GO
*/

CREATE TABLE [PracticeInsuranceGroupNumber] (
	[PracticeInsuranceGroupNumberID] [int] IDENTITY (1, 1) NOT NULL ,
	[PracticeID] [int] NOT NULL ,
	[LocationID] [int] NULL ,
	[InsuranceCompanyPlanID] [int] NULL ,
	[GroupNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[GroupNumberTypeID] [int] NOT NULL ,
	[TIMESTAMP] [datetime] NULL ,
	CONSTRAINT [PK_PracticeInsuranceGroupNumber] PRIMARY KEY  CLUSTERED 
	(
		[PracticeInsuranceGroupNumberID]
	)  ON [PRIMARY] ,
	CONSTRAINT [FK_PracticeInsuranceGroupNumber_GroupNumberType] FOREIGN KEY 
	(
		[GroupNumberTypeID]
	) REFERENCES [GroupNumberType] (
		[GroupNumberTypeID]
	),
	CONSTRAINT [FK_PracticeInsuranceGroupNumber_InsuranceCompanyPlan] FOREIGN KEY 
	(
		[InsuranceCompanyPlanID]
	) REFERENCES [InsuranceCompanyPlan] (
		[InsuranceCompanyPlanID]
	),
	CONSTRAINT [FK_PracticeInsuranceGroupNumber_Practice] FOREIGN KEY 
	(
		[PracticeID]
	) REFERENCES [Practice] (
		[PracticeID]
	),
	CONSTRAINT [FK_PracticeInsuranceGroupNumber_ServiceLocation] FOREIGN KEY 
	(
		[LocationID]
	) REFERENCES [ServiceLocation] (
		[ServiceLocationID]
	)
) ON [PRIMARY]
GO

CREATE TABLE [ProviderNumberType] (
	[ProviderNumberTypeID] [int] IDENTITY (1, 1) NOT NULL ,
	[TypeName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	CONSTRAINT [PK_BillingIdentifier] PRIMARY KEY  CLUSTERED 
	(
		[ProviderNumberTypeID]
	)  ON [PRIMARY] 
) ON [PRIMARY]
GO


CREATE TABLE [ProviderNumber] (
	[ProviderNumberID] [int] IDENTITY (1, 1) NOT NULL ,
	[DoctorID] [int] NOT NULL ,
	[ProviderNumberTypeID] [int] NOT NULL ,
	[InsuranceCompanyPlanID] [int] NULL ,
	[LocationID] [int] NULL ,
	[ProviderNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	CONSTRAINT [PK_ProviderNumber] PRIMARY KEY  CLUSTERED 
	(
		[ProviderNumberID]
	)  ON [PRIMARY] ,
	CONSTRAINT [FK_ProviderNumber_Doctor] FOREIGN KEY 
	(
		[DoctorID]
	) REFERENCES [Doctor] (
		[DoctorID]
	),
	CONSTRAINT [FK_ProviderNumber_InsuranceCompanyPlan] FOREIGN KEY 
	(
		[InsuranceCompanyPlanID]
	) REFERENCES [InsuranceCompanyPlan] (
		[InsuranceCompanyPlanID]
	),
	CONSTRAINT [FK_ProviderNumber_ProviderNumberType] FOREIGN KEY 
	(
		[ProviderNumberTypeID]
	) REFERENCES [ProviderNumberType] (
		[ProviderNumberTypeID]
	),
	CONSTRAINT [FK_ProviderNumber_ServiceLocation] FOREIGN KEY 
	(
		[LocationID]
	) REFERENCES [ServiceLocation] (
		[ServiceLocationID]
	)
) ON [PRIMARY]
GO




ALTER TABLE [InsuranceCompanyPlan] ADD 
	[ProviderNumberTypeID] [int] NULL ,
	[GroupNumberTypeID] [int] NULL ,
	[LocalUseProviderNumberTypeID] [int] NULL ,
	CONSTRAINT [FK_InsuranceCompanyPlan_GroupNumberType] FOREIGN KEY 
	(
		[GroupNumberTypeID]
	) REFERENCES [GroupNumberType] (
		[GroupNumberTypeID]
	),
	CONSTRAINT [FK_InsuranceCompanyPlan_ProviderNumber] FOREIGN KEY 
	(
		[LocalUseProviderNumberTypeID]
	) REFERENCES [ProviderNumber] (
		[ProviderNumberID]
	),
	CONSTRAINT [FK_InsuranceCompanyPlan_ProviderNumberType] FOREIGN KEY 
	(
		[ProviderNumberTypeID]
	) REFERENCES [ProviderNumberType] (
		[ProviderNumberTypeID]
	)
GO


DELETE FROM 
	PaymentClaimTransaction
WHERE
	ClaimTransactionID IN
	(
		SELECT
			CT.ClaimTransactionID
		FROM
			PaymentClaimTransaction PCT
			INNER JOIN ClaimTransaction CT ON CT.ClaimTransactionID = PCT.ClaimTransactionID
		WHERE
			CT.ClaimTransactionTypeCode='PAY'
	)

INSERT INTO
	PaymentClaimTransaction
	(PaymentID, ClaimID, ClaimTransactionID)
	(
		SELECT
			CT.ReferenceID AS PaymentID,
			CT.ClaimID,
			CT.ClaimTransactionID
		FROM 
			ClaimTransaction CT
			INNER JOIN Payment P ON P.PaymentID = CT.ReferenceID
		WHERE
			CT.ClaimTransactionTypeCode = 'PAY'
	)


insert into ActivityType values ('ADJ','Adjustments')
insert into ActivityType values ('APP','Appointments')
insert into ActivityType values ('BILL','Insurance Bills')
insert into ActivityType values ('CLM','Claims')
insert into ActivityType values ('ENC','Encounters')
insert into ActivityType values ('PMT','Payments')
insert into ActivityType values ('PST','Payment Postings')
insert into ActivityType values ('SC','Status Changes')
insert into ActivityType values ('STMT','Patient Statements')


insert into ProviderNumbertype (TypeName) values ('Insurance Plan Specific')
insert into GroupNumbertype (TypeName) values ('Insurance Plan Specific')

insert into ProviderNumbertype (TypeName) values ('UPIN')
insert into ProviderNumbertype (TypeName) values ('BC/BS Individual Number')
insert into ProviderNumbertype (TypeName) values ('Medicaid Number')
insert into ProviderNumbertype (TypeName) values ('Medicare Individual Provider Number')
insert into ProviderNumbertype (TypeName) values ('Medicare Railroad Number')
insert into ProviderNumbertype (TypeName) values ('Medical License Number')
insert into ProviderNumbertype (TypeName) values ('National Provider Number')

insert into GroupNumbertype (TypeName) values ('BC/BS Group Number')
insert into GroupNumbertype (TypeName) values ('Medicare Group Provider Number')
