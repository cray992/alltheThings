/*

DATABASE UPDATE SCRIPT

v1.15.1622 to v.1.16.1635
*/

ALTER TABLE dbo.Doctor
ADD
	HipaaProviderTaxonomyCode VARCHAR(20) NOT NULL DEFAULT '208100000X' WITH VALUES
GO

ALTER TABLE dbo.Practice
ADD
	[EClaimsSendEnabled] [bit] NOT NULL DEFAULT 0 WITH VALUES,
	[EStatementsSendEnabled] [bit] NOT NULL DEFAULT 0 WITH VALUES,
	[EStatementsSendInTestMode] [bit] NOT NULL DEFAULT 0 WITH VALUES,
	[EStatementsLogin] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT '' WITH VALUES,
	[EStatementsPassword] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT '' WITH VALUES,
	[EStatementsNotes] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO

ALTER TABLE dbo.PracticeClearinghouseInfo
DROP DF_PracticeClearinghouseInfo_PracticeEtin
GO
ALTER TABLE dbo.PracticeClearinghouseInfo
DROP COLUMN PracticeEtin, StatementsLogin, StatementsPassword
GO

ALTER TABLE dbo.InsuranceCompanyPlan
ADD
	[EClaimsPaperOnly] [bit] NOT NULL DEFAULT 0 WITH VALUES,
	[EClaimsRequiresTest] [bit] NOT NULL DEFAULT 0 WITH VALUES,
	[EClaimsAccepts] [bit] NOT NULL DEFAULT 0 WITH VALUES
GO

--InsuranceCompanyPlan NOT NULLS
ALTER TABLE [dbo].[InsuranceCompanyPlan] ALTER COLUMN [EClaimsRequiresEnrollment] [bit] NOT NULL
ALTER TABLE [dbo].[InsuranceCompanyPlan] ALTER COLUMN [EClaimsRequiresAuthorization] [bit] NOT NULL
ALTER TABLE [dbo].[InsuranceCompanyPlan] ALTER COLUMN [EClaimsRequiresProviderID] [bit] NOT NULL

GO
--Practice Table NOT NULLS
ALTER TABLE [dbo].[Practice] ALTER COLUMN [EnrolledForEClaims] [bit] NOT NULL
ALTER TABLE [dbo].[Practice] ALTER COLUMN [EnrolledForEStatements] [bit] NOT NULL

GO
--PracticeToInsuranceCompany NOT NULLS

ALTER TABLE [dbo].[PracticeToInsuranceCompanyPlan] ALTER COLUMN [EClaimsPracticeIsEnrolled] [bit] NOT NULL
ALTER TABLE [dbo].[PracticeToInsuranceCompanyPlan] ALTER COLUMN [EStatementsPracticeIsEnrolled] [bit] NOT NULL
GO
