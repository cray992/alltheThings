--
-- Create Table [DemographicMarketingSourceGroup] and insert default data
--
CREATE TABLE [Superbill_Shared].[dbo].[DemographicMarketingSourceGroup](
	[DemographicMarketingSourceGroupID] [int] NOT NULL,
	[DemographicMarketingSourceGroupCaption] [varchar](50) NOT NULL,
CONSTRAINT [PK_DemographicMarketingSourceGroup] PRIMARY KEY CLUSTERED 
(
	[DemographicMarketingSourceGroupID] ASC
))
GO

INSERT INTO [Superbill_Shared].[dbo].[DemographicMarketingSourceGroup]([DemographicMarketingSourceGroupID], [DemographicMarketingSourceGroupCaption])
SELECT 1, N'Search Engine' UNION ALL
SELECT 2, N'Email' UNION ALL
SELECT 3, N'Customer Referral' UNION ALL
SELECT 4, N'Partners' UNION ALL
SELECT 5, N'Directories' UNION ALL
SELECT 6, N'Associations' UNION ALL
SELECT 7, N'Social Media' UNION ALL
SELECT 8, N'Other'
GO


--
-- UPdate [DemographicMarketingSource] and insert new data
--

UPDATE [Superbill_Shared].[dbo].[DemographicMarketingSource]
   SET [Active] = 0
   WHERE MarketingSourceID < 100
GO

ALTER TABLE [DemographicMarketingSource] ADD [DemographicMarketingSourceGroupID] [varchar](50) NOT NULL CONSTRAINT DF_DemographicMarketingSource_DemographicMarketingSourceGroupID_Default DEFAULT(0)
ALTER TABLE [DemographicMarketingSource] DROP CONSTRAINT DF_DemographicMarketingSource_DemographicMarketingSourceGroupID_Default
GO

INSERT INTO [Superbill_Shared].[dbo].[DemographicMarketingSource]([MarketingSourceID], [MarketingSourceCaption], [Active], [DemographicMarketingSourceGroupID])
SELECT 100, N'Google', 1, 1 UNION ALL
SELECT 105, N'Yahoo', 1, 1 UNION ALL
SELECT 110, N'Bing', 1, 1 UNION ALL
SELECT 115, N'Other Search Engine', 1, 1 UNION ALL
SELECT 120, N'Email', 1, 2 UNION ALL
SELECT 125, N'Newsletter', 1, 2 UNION ALL
SELECT 130, N'Customer Referral', 1, 3 UNION ALL
SELECT 135, N'Billing Service Referral', 1, 3 UNION ALL
SELECT 140, N'Word-of-Mouth', 1, 3 UNION ALL
SELECT 145, N'Practice Fusion', 1, 4 UNION ALL
SELECT 150, N'Bio-Reference Laboratories', 1, 4 UNION ALL
SELECT 155, N'PBO MD', 1, 4 UNION ALL
SELECT 160, N'WebPT', 1, 4 UNION ALL
SELECT 165, N'Other Partner', 1, 4 UNION ALL
SELECT 170, N'Capterra', 1, 5 UNION ALL
SELECT 175, N'MPM', 1, 5 UNION ALL
SELECT 180, N'Software Advice', 1, 5 UNION ALL
SELECT 185, N'AMBA', 1, 6 UNION ALL
SELECT 190, N'HBMA', 1, 6 UNION ALL
SELECT 195, N'HIMSS', 1, 6 UNION ALL
SELECT 200, N'MGMA', 1, 6 UNION ALL
SELECT 205, N'Twitter', 1, 7 UNION ALL
SELECT 210, N'Facebook', 1, 7 UNION ALL
SELECT 215, N'YouTube', 1, 7 UNION ALL
SELECT 220, N'Flickr', 1, 7 UNION ALL
SELECT 225, N'Other', 1, 8 UNION ALL
SELECT 230, N'Unknown', 1, 8
