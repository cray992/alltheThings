IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[InsurancePolicy]') AND name = N'IX_InsurancePolicy_PatientCaseID')
BEGIN
	DROP INDEX [IX_InsurancePolicy_PatientCaseID] ON dbo.InsurancePolicy
END

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[InsurancePolicy]') AND name = N'UQ_InsurancePolicy_PatientCaseID_Precedence')
BEGIN
	DROP INDEX [UQ_InsurancePolicy_PatientCaseID_Precedence] ON dbo.InsurancePolicy
END


CREATE UNIQUE NONCLUSTERED INDEX [UQ_InsurancePolicy_PatientCaseID_Precedence] ON [dbo].[InsurancePolicy] 
(
	[PatientCaseID] ASC,
	[Precedence] ASC
)
INCLUDE ( [PolicyStartDate],
[PolicyEndDate],
[Active])


IF EXISTS (SELECT * FROM sysobjects WHERE xtype = 'UQ' AND name = 'UQ_InsurancePolicy_PatientCaseIDPrecedence')
BEGIN
	ALTER TABLE dbo.InsurancePolicy DROP CONSTRAINT [UQ_InsurancePolicy_PatientCaseIDPrecedence]
END
