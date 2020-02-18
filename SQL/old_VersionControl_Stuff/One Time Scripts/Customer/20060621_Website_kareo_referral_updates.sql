







/*

Add Active/Inactive Colum to Marketing Source Table

*/
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
IF EXISTS (SELECT * FROM tempdb..sysobjects WHERE id=OBJECT_ID('tempdb..#tmpErrors')) DROP TABLE #tmpErrors
GO
CREATE TABLE #tmpErrors (Error int)
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRANSACTION
GO
PRINT N'Altering [dbo].[DemographicMarketingSource]'
GO
ALTER TABLE [dbo].[DemographicMarketingSource] ADD
[Active] [bit] NOT NULL CONSTRAINT [DF_DemographicMarketingSource_Active] DEFAULT ((1))
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT 'The database update succeeded'
COMMIT TRANSACTION
END
ELSE PRINT 'The database update failed'
GO
DROP TABLE #tmpErrors
GO



/*

Modify Marketing Source Data

*/
SET NUMERIC_ROUNDABORT OFF
GO
SET XACT_ABORT, ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
-- Pointer used for text / image updates. This might not be needed, but is declared here just in case
DECLARE @pv binary(16)

BEGIN TRANSACTION
UPDATE [dbo].[DemographicMarketingSource] SET Active=0
UPDATE [dbo].[DemographicMarketingSource] SET [MarketingSourceCaption]=N'News Article' WHERE [MarketingSourceID]=5
UPDATE [dbo].[DemographicMarketingSource] SET [MarketingSourceCaption]=N'Search Engine' WHERE [MarketingSourceID]=8
INSERT INTO [dbo].[DemographicMarketingSource] ([MarketingSourceID], [MarketingSourceCaption]) VALUES (11, N'Customer Referral')
INSERT INTO [dbo].[DemographicMarketingSource] ([MarketingSourceID], [MarketingSourceCaption]) VALUES (12, N'Industry Association')
INSERT INTO [dbo].[DemographicMarketingSource] ([MarketingSourceID], [MarketingSourceCaption]) VALUES (13, N'Magazine Advertisement')
INSERT INTO [dbo].[DemographicMarketingSource] ([MarketingSourceID], [MarketingSourceCaption]) VALUES (14, N'Trade Show')
INSERT INTO [dbo].[DemographicMarketingSource] ([MarketingSourceID], [MarketingSourceCaption]) VALUES (15, N'Word Of Mouth')
COMMIT TRANSACTION