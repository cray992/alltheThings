----47

--CREATE DATABASE [HPI_30DayDelta]

USE HPI_30DayDelta
GO

IF object_id('[dbo].[getPatientCase]','v') IS NOT NULL
DROP VIEW [dbo].[getPatientCase]
GO
CREATE VIEW [dbo].[getPatientCase] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getPatientCase WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getPatientCase WITH (NOLOCK)
GO
IF object_id('[dbo].[getPayerProcessingStatusType]','v') IS NOT NULL
DROP VIEW [dbo].[getPayerProcessingStatusType]
GO
CREATE VIEW [dbo].[getPayerProcessingStatusType] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getPayerProcessingStatusType WITH (NOLOCK)
GO
IF object_id('[dbo].[getPayerScenario]','v') IS NOT NULL
DROP VIEW [dbo].[getPayerScenario]
GO
CREATE VIEW [dbo].[getPayerScenario] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getPayerScenario WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getPayerScenario WITH (NOLOCK)
GO
IF object_id('[dbo].[getPaymentAuthorization]','v') IS NOT NULL
DROP VIEW [dbo].[getPaymentAuthorization]
GO
CREATE VIEW [dbo].[getPaymentAuthorization] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getPaymentAuthorization WITH (NOLOCK)
GO
IF object_id('[dbo].[getPaymentPatient]','v') IS NOT NULL
DROP VIEW [dbo].[getPaymentPatient]
GO
CREATE VIEW [dbo].[getPaymentPatient] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getPaymentPatient WITH (NOLOCK)
GO
IF object_id('[dbo].[getPaymentMethodCode]','v') IS NOT NULL
DROP VIEW [dbo].[getPaymentMethodCode]
GO
CREATE VIEW [dbo].[getPaymentMethodCode] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getPaymentMethodCode WITH (NOLOCK)
GO
IF object_id('[dbo].[getPaymentMethodType]','v') IS NOT NULL
DROP VIEW [dbo].[getPaymentMethodType]
GO
CREATE VIEW [dbo].[getPaymentMethodType] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getPaymentMethodType WITH (NOLOCK)
GO
IF object_id('[dbo].[getPayerTypeCode]','v') IS NOT NULL
DROP VIEW [dbo].[getPayerTypeCode]
GO
CREATE VIEW [dbo].[getPayerTypeCode] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getPayerTypeCode WITH (NOLOCK)
GO
IF object_id('[dbo].[getPaymentType]','v') IS NOT NULL
DROP VIEW [dbo].[getPaymentType]
GO
CREATE VIEW [dbo].[getPaymentType] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getPaymentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getPaymentType WITH (NOLOCK)
GO
IF object_id('[dbo].[getPractice]','v') IS NOT NULL
DROP VIEW [dbo].[getPractice]
GO
CREATE VIEW [dbo].[getPractice] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getPractice WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getPractice WITH (NOLOCK)
GO
IF object_id('[dbo].[getPracticeInsuranceGroupNumber]','v') IS NOT NULL
DROP VIEW [dbo].[getPracticeInsuranceGroupNumber]
GO
CREATE VIEW [dbo].[getPracticeInsuranceGroupNumber] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getPracticeInsuranceGroupNumber WITH (NOLOCK)
GO
IF object_id('[dbo].[getPracticeToInsuranceCompany]','v') IS NOT NULL
DROP VIEW [dbo].[getPracticeToInsuranceCompany]
GO
CREATE VIEW [dbo].[getPracticeToInsuranceCompany] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getPracticeToInsuranceCompany WITH (NOLOCK)
GO
IF object_id('[dbo].[getProcedureCodeDictionary]','v') IS NOT NULL
DROP VIEW [dbo].[getProcedureCodeDictionary]
GO
CREATE VIEW [dbo].[getProcedureCodeDictionary] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getProcedureCodeDictionary WITH (NOLOCK)
GO
IF object_id('[dbo].[getProviderNumber]','v') IS NOT NULL
DROP VIEW [dbo].[getProviderNumber]
GO
CREATE VIEW [dbo].[getProviderNumber] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getProviderNumber WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getProviderNumber WITH (NOLOCK)
GO
IF object_id('[dbo].[getProviderNumberType]','v') IS NOT NULL
DROP VIEW [dbo].[getProviderNumberType]
GO
CREATE VIEW [dbo].[getProviderNumberType] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getProviderNumberType WITH (NOLOCK)
GO
IF object_id('[dbo].[getProviderSpecialty]','v') IS NOT NULL
DROP VIEW [dbo].[getProviderSpecialty]
GO
CREATE VIEW [dbo].[getProviderSpecialty] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getProviderSpecialty WITH (NOLOCK)
GO
IF object_id('[dbo].[getRefund]','v') IS NOT NULL
DROP VIEW [dbo].[getRefund]
GO
CREATE VIEW [dbo].[getRefund] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getRefund WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getRefund WITH (NOLOCK)
GO
IF object_id('[dbo].[getRefundStatusCode]','v') IS NOT NULL
DROP VIEW [dbo].[getRefundStatusCode]
GO
CREATE VIEW [dbo].[getRefundStatusCode] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getRefundStatusCode WITH (NOLOCK)
GO
IF object_id('[dbo].[getRefundToPayments]','v') IS NOT NULL
DROP VIEW [dbo].[getRefundToPayments]
GO
CREATE VIEW [dbo].[getRefundToPayments] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getRefundToPayments WITH (NOLOCK)
GO
IF object_id('[dbo].[getServiceLocation]','v') IS NOT NULL
DROP VIEW [dbo].[getServiceLocation]
GO
CREATE VIEW [dbo].[getServiceLocation] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getServiceLocation WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getServiceLocation WITH (NOLOCK)
GO
IF object_id('[dbo].[getTask]','v') IS NOT NULL
DROP VIEW [dbo].[getTask]
GO
CREATE VIEW [dbo].[getTask] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getTask WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getTask WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getTaskStatus] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getTaskStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getTaskStatus WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getTaskType] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getTaskType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getTaskType WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getTypeOfService] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getTypeOfService WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getTypeOfService WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getUsers] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getUsers WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getUsers WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getBillingInvoicing] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getBillingInvoicing WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getBillingInvoicing_RcmTerms_Payment] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getBillingInvoicing_RcmTerms_Payment WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getAdjustment] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getAdjustment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getAdjustment WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getAdjustmentGroup] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getAdjustmentGroup WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getAdjustmentReason] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getAdjustmentReason WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getAppointmentreason] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getAppointmentreason WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getAppointment] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getAppointment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getAppointment WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getAppointmenttoappointmentreason] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getAppointmenttoappointmentreason WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getAppointmenttoresource] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getAppointmenttoresource WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getAppointmentType] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getAppointmentType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getAppointmentType WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getAppointmentConfirmationStatus] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getAppointmentConfirmationStatus WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getAppointmentResourceType] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getAppointmentResourceType WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getBillBatchType] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getBillBatchType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getBillBatchType WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getBillClaim] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getBillClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getBillClaim WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getBillingInvoicing_RcmTerms] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getBillingInvoicing_RcmTerms WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getBillingInvoicing_RcmTerms_PaymentCategoryTerms] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getBillingInvoicing_RcmTerms_PaymentCategoryTerms WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getCapitatedAccount] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getCapitatedAccount WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getCapitatedAccountToPayment] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getCapitatedAccountToPayment WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getCategory] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getCategory WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getCategory WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getClaim] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getClaim WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getClaim WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getClaimAccounting] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getClaimAccounting WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getClaimAccounting_Assignments] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getClaimAccounting_Assignments WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getClaimAccounting_Billings] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getClaimAccounting_Billings WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getClaimAccounting_Errors] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getClaimAccounting_Errors WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getClaimAccounting_FollowUp] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getClaimAccounting_FollowUp WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getClaimResponseStatus] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getClaimResponseStatus WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getClaimStatus] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getClaimStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getClaimStatus WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getClaimPaymentStatus] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getClaimPaymentStatus WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getClaimSettings] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getClaimSettings WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getClaimSettings WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getClaimStatusCode] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getClaimStatusCode WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getClaimStateFollowUp] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getClaimStateFollowUp WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getClaimTransaction] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getClaimTransaction WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getClaimTransactionType] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getClaimTransactionType WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getClaimTransactionTypeError] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getClaimTransactionTypeError WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getClearinghouseResponse] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getClearinghouseResponse WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getClearinghouseEnrollmentStatusType] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getClearinghouseEnrollmentStatusType WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getClearinghousePayersList] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getClearinghousePayersList WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getClearinghouseResponsePatientStatement] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getClearinghouseResponsePatientStatement WITH (NOLOCK)
GO
CREATE VIEW [dbo].[spt_values] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.spt_values WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.spt_values WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getClearinghouseResponseReportType] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getClearinghouseResponseReportType WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getClearinghouseResponseType] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getClearinghouseResponseType WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getClearinghouseResponseSourceType] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getClearinghouseResponseSourceType WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getContractsAndFees_ContractRate] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getContractsAndFees_ContractRate WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getContractsAndFees_ContractRateSchedule] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getContractsAndFees_ContractRateSchedule WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getContractsAndFees_ContractRateScheduleLink] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getContractsAndFees_ContractRateScheduleLink WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getContractsAndFees_StandardFee] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getContractsAndFees_StandardFee WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getContractsAndFees_StandardFeeSchedule] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getContractsAndFees_StandardFeeSchedule WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getContractsAndFees_StandardFeeScheduleLink] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getContractsAndFees_StandardFeeScheduleLink WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getDoctor] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getDoctor WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getDoctor WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getEncounter] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getEncounter WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getEncounter WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getEncounterProcedure] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getEncounterProcedure WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getEncounterStatus] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getEncounterStatus WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getEnrollmentPayer] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getEnrollmentPayer WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getGroupNumberType] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getGroupNumberType WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getHCFADiagnosisReferenceFormat] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getHCFADiagnosisReferenceFormat WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getHCFASameAsInsuredFormat] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getHCFASameAsInsuredFormat WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getInsuranceCompany] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getInsuranceCompany WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getInsuranceCompanyPlan] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getInsuranceCompanyPlan WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getInsurancePolicy] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getInsurancePolicy WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getInsuranceProgram] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getInsuranceProgram WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getInsuranceProgramType] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getInsuranceProgramType WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getPatient] AS
Select * From [LAS-PDW-D001].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D002].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D003].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D004].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D005].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D006].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D007].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D008].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D009].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D010].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D011].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D012].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D013].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D014].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D015].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D016].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D017].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D018].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D019].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D020].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D021].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D022].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D023].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D024].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D025].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D026].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D027].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D028].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D029].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D030].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D031].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D032].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D033].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D034].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D035].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D036].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D037].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D038].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D039].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D040].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D041].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D042].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
--Select * From [LAS-PDW-D043].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D044].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D045].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D046].KareoDBA.dbo.getPatient WITH (NOLOCK) UNION ALL
Select * From [LAS-PDW-D048].KareoDBA.dbo.getPatient WITH (NOLOCK)
GO
CREATE VIEW [dbo].[getPayment] AS
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D001],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D002],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D003],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D004],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D005],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D006],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D007],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D008],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D009],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D010],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D011],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D012],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D013],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D014],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D015],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
--SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
--FROM OPENQUERY([LAS-PDW-D016],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D017],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D018],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D019],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D020],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D021],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D022],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D023],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D024],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D025],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D026],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D027],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D028],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D029],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D030],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D031],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D032],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D033],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D034],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D035],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D036],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D037],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D038],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D039],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D040],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D041],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D042],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
--SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
--FROM OPENQUERY([LAS-PDW-D043],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D044],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D045],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D046],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as XML) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline]
FROM OPENQUERY([LAS-PDW-D048],'SELECT [CustomerId],[PaymentID],[PracticeID],[PaymentAmount],[PaymentMethodCode],[PayerTypeCode],[PayerID],[PaymentNumber],[Description],[CreatedDate],[ModifiedDate],[TIMESTAMP],[SourceEncounterID],[PostingDate],[PaymentTypeID],[DefaultAdjustmentCode],[BatchID],[CreatedUserID],[ModifiedUserID],[SourceAppointmentID],[EOBEditable],[AdjudicationDate],[ClearinghouseResponseID],CAST(ERAErrors as varchar(max)) as ERAErrors,[AppointmentID],[AppointmentStartDate],[PaymentCategoryID],[overrideClosingDate],[IsOnline] FROM KareoDBA.dbo.getPayment WITH (NOLOCK)')
GO
CREATE VIEW [dbo].[getPaymentClaim] AS
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D001],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D002],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D003],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D004],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D005],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D006],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D007],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D008],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D009],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D010],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D011],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D012],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D013],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D014],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D015],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
--SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
--FROM OPENQUERY([LAS-PDW-D016],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D017],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D018],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D019],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D020],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D021],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D022],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D023],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D024],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D025],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D026],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D027],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D028],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D029],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D030],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D031],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D032],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D033],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D034],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D035],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D036],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D037],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D038],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D039],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D040],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D041],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D042],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
--SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
--FROM OPENQUERY([LAS-PDW-D043],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D044],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D045],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D046],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)') UNION ALL
SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as XML) as EOBXml,CAST(RawEOBXml as XML) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID]
FROM OPENQUERY([LAS-PDW-D048],'SELECT [CustomerId],[PaymentClaimID],[PaymentID],[PracticeID],[PatientID],[EncounterID],[ClaimID],CAST(EOBXml as varchar(max)) as EOBXml,CAST(RawEOBXml as varchar(max)) as RawEOBXml,[Notes],[Reversed],[Draft],[HasError],[ErrorMsg],[PaymentRawEOBID] FROM [KareoDBA].[dbo].[getPaymentClaim] WITH (NOLOCK)')
GO
