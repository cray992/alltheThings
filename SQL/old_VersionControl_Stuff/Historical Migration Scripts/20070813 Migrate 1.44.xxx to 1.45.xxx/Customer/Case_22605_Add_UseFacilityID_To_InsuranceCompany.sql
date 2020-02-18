/*-----------------------------------------------------------------------------
Case 22605 - Add facility id checkbox to support CMS-1500 box 32b
-----------------------------------------------------------------------------*/
ALTER TABLE dbo.InsuranceCompany ADD
	UseFacilityID bit NULL
GO

ALTER TABLE dbo.InsuranceCompany ADD CONSTRAINT
	DF_InsuranceCompany_UseFacilityID DEFAULT 1 FOR UseFacilityID
GO

UPDATE dbo.InsuranceCompany SET
	UseFacilityID = 1
GO