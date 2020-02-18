CREATE TABLE [BillingForm] (
	[BillingFormID] [int] IDENTITY (1, 1) NOT NULL ,
	[FormType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[FormName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Transform] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[TIMESTAMP] [TIMESTAMP] NOT NULL ,
	CONSTRAINT [PK_BillingForm] PRIMARY KEY  CLUSTERED 
	(
		[BillingFormID]
	)  ON [PRIMARY] 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


CREATE TABLE [PracticeResourceType] (
	[PracticeResourceTypeID] [int] IDENTITY (1, 1) NOT NULL ,
	[TypeName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	CONSTRAINT [PK_PracticeResourceType] PRIMARY KEY  CLUSTERED 
	(
		[PracticeResourceTypeID]
	)  ON [PRIMARY] 
) ON [PRIMARY]
GO





CREATE TABLE [PracticeResource] (
	[PracticeResourceID] [int] IDENTITY (1, 1) NOT NULL ,
	[PracticeResourceTypeID] [int] NOT NULL ,
	[PracticeID] [int] NOT NULL ,
	[ResourceName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	CONSTRAINT [PK_PracticeResource] PRIMARY KEY  CLUSTERED 
	(
		[PracticeResourceID]
	)  ON [PRIMARY] ,
	CONSTRAINT [FK_PracticeResource_Practice] FOREIGN KEY 
	(
		[PracticeID]
	) REFERENCES [Practice] (
		[PracticeID]
	),
	CONSTRAINT [FK_PracticeResource_PracticeResourceType] FOREIGN KEY 
	(
		[PracticeResourceTypeID]
	) REFERENCES [PracticeResourceType] (
		[PracticeResourceTypeID]
	)
) ON [PRIMARY]
GO


INSERT INTO PracticeResourceType (TypeName) VALUES ('Equipment')
INSERT INTO PracticeResourceType (TypeName) VALUES ('Facility')
INSERT INTO PracticeResourceType (TypeName) VALUES ('Human Resource')



INSERT INTO BillingForm (FormType, FormName, Transform) VALUES ('HCFA', 'Standard', '')
INSERT INTO BillingForm (FormType, FormName, Transform) VALUES ('HCFA', 'Medicaid of Ohio', '')



/*

execute the following two commands from command prompt

textcopy /S 10.0.0.10 /U dev /P /D pmr_copy /T BillingForm /C Transform /W "WHERE BillingFormID = 1" 
/F c:\cvsroot\PMR\Software\Billing\Libraries\PMR.Billing.ServiceImplementation\Bill_RAW-HCFA.xsl /I

textcopy /S 10.0.0.10 /U dev /P /D pmr_copy /T BillingForm /C Transform /W "WHERE BillingFormID = 2" 
/F c:\cvsroot\PMR\Software\Billing\Libraries\PMR.Billing.ServiceImplementation\Bill_RAW-HCFA-MedicaidOhio.xsl /I


*/


ALTER TABLE 
	InsuranceCompanyPlan
ADD 
	BillingFormID INT NOT NULL DEFAULT 1



UPDATE InsuranceCompanyPlan SET BillingFormID = 2 WHERE PlanName LIKE '%Human Services%' AND State = 'OH'


ALTER TABLE 
	Claim
ADD 
	LocalUseData VARCHAR(25) NULL




/*

NOW EXECUTE ALL SQL SCRIPTS


*/
