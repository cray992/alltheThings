
-- add new field to claimsetting screen
alter table ClaimSettings add TaxonomyCode char(10) null
GO
ALTER TABLE [dbo].[ClaimSettings]  WITH CHECK ADD  CONSTRAINT [FK_ClaimSettings_TaxonomyCode] FOREIGN KEY([TaxonomyCode])
REFERENCES [dbo].[TaxonomyCode] ([TaxonomyCode])
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Practice_TaxonomyCode]') AND parent_object_id = OBJECT_ID(N'[dbo].[Practice]'))
ALTER TABLE [dbo].[Practice] DROP CONSTRAINT [FK_Practice_TaxonomyCode]
GO

-- remove TaxonomyCode from practice screen
ALTER TABLE dbo.Practice DROP COLUMN TaxonomyCode
GO


-- adding bunch of new fields for practice info

ALTER TABLE dbo.ClaimSettings ADD OverridePracticeNameFlag BIT not null DEFAULT 0
GO
ALTER TABLE dbo.ClaimSettings ADD OverridePracticeAddressFlag BIT not null DEFAULT 0
GO
ALTER TABLE dbo.ClaimSettings ADD OverridePracticeName VARCHAR(256)
GO
ALTER TABLE dbo.ClaimSettings ADD OverridePracticeAddressLine1 VARCHAR(256)
GO
ALTER TABLE dbo.ClaimSettings ADD OverridePracticeAddressLine2 VARCHAR(256)
GO
ALTER TABLE dbo.ClaimSettings ADD OverridePracticeCity VARCHAR(128)
GO
ALTER TABLE dbo.ClaimSettings ADD OverridePracticeState VARCHAR(2)
GO
ALTER TABLE dbo.ClaimSettings ADD OverridePracticeZipCode VARCHAR(9)
GO
ALTER TABLE dbo.ClaimSettings ADD OverridePracticeCountry VARCHAR(32)
GO