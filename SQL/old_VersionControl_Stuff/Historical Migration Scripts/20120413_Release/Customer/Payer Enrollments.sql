IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EnrollmentDoctor]') AND type in (N'U'))
DROP TABLE [dbo].[EnrollmentDoctor]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EnrollmentPayer]') AND type in (N'U'))
DROP TABLE [dbo].[EnrollmentPayer]
GO


CREATE TABLE dbo.EnrollmentPayer
(
EnrollmentPayerID INT NOT NULL IDENTITY(1, 1),

PracticeID INT NOT NULL CONSTRAINT FK_EnrollmentPayer_Practice FOREIGN KEY REFERENCES dbo.Practice(PracticeID),
ClearinghousePayerID INT NOT NULL,

InsuranceProgramCode CHAR(2) NOT NULL,
Ptan VARCHAR(100) NULL,

EclaimsSelected BIT NOT NULL,
EligibilitySelected BIT NOT NULL,
EraSelected BIT NOT NULL,

CreatedDateTime SMALLDATETIME NULL,
CreatedUserID INT NULL,
ModifiedDateTime SMALLDATETIME NULL,
ModifiedUserID INT NULL,

InsuranceCompanyID INT NULL CONSTRAINT FK_EnrollmentPayer_InsuranceCompany FOREIGN KEY REFERENCES dbo.InsuranceCompany(InsuranceCompanyID)

CONSTRAINT PK_EnrollmentPayer PRIMARY KEY CLUSTERED 
(
	EnrollmentPayerID ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE dbo.EnrollmentDoctor
(
EnrollmentPayerID INT NOT NULL CONSTRAINT FK_EnrollmentDoctor_EnrollmentPayer FOREIGN KEY REFERENCES dbo.EnrollmentPayer(EnrollmentPayerID),
DoctorID INT NOT NULL CONSTRAINT FK_EnrollmentDoctor_Doctor FOREIGN KEY REFERENCES dbo.Doctor(DoctorID),
Ptan varchar(100) NULL
CONSTRAINT PK_EnrollmentDoctor PRIMARY KEY CLUSTERED 
(
	EnrollmentPayerID ASC, DoctorID ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
