if exists (select * from dbo.sysindexes where name=('IX_InsurancePolicy_PatientCaseId_Precedence_InsuranceCompanyPlanID'))
RETURN

ELSE 

/****** Object:  Index [IX_InsurancePolicy_PatientCaseId_Precedence_InsuranceCompanyPlanID]    Script Date: 04/05/2012 08:58:06 ******/
CREATE NONCLUSTERED INDEX [IX_InsurancePolicy_PatientCaseId_Precedence_InsuranceCompanyPlanID] ON [dbo].[InsurancePolicy] 
(
	[PatientCaseID] ASC,
	[Precedence] ASC,
	[InsuranceCompanyPlanID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

