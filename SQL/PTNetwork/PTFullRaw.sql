--pt network full; 1/3/20


:connect Las-pdw-shr01.kareoprod.ent

DROP DATABASE [PTNetwork_DailyDeltas]
GO

CREATE DATABASE [PTNetwork_DailyDeltas]
GO

USE [PTNetwork_DailyDeltas]
GO

SELECT
   t.NAME AS TableName,
   MAX(p.rows) AS RowCounts_Before
INTO PTNetwork_DailyDeltas.dbo.RowCounts_Before
FROM
   [LAS-PDW-D043].superbill_24214_prod.sys.tables t
INNER JOIN
   [LAS-PDW-D043].superbill_24214_prod.sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN
   [LAS-PDW-D043].superbill_24214_prod.sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id

WHERE
   t.is_ms_shipped = 0
GROUP BY
   t.NAME   --,  p.Rows
ORDER BY
    t.Name
	;

SET ANSI_NULLS ON
;

SET QUOTED_IDENTIFIER ON
;

SELECT *
INTO Adjustment
FROM [LAS-PDW-D043].superbill_24214_prod.dbo.Adjustment WITH (NOLOCK)
GO
SELECT *
INTO AdjustmentGroup
FROM [LAS-PDW-D043].superbill_24214_prod.dbo.AdjustmentGroup WITH (NOLOCK)
GO
SELECT *
INTO AdjustmentReason
FROM [LAS-PDW-D043].superbill_24214_prod.dbo.AdjustmentReason WITH (NOLOCK)
GO
SELECT *
INTO Claim
FROM [LAS-PDW-D043].superbill_24214_prod.dbo.Claim WITH (NOLOCK)
WHERE CreatedDate>GETDATE()-4
GO
SELECT *
INTO ClaimAccounting
FROM [LAS-PDW-D043].superbill_24214_prod.dbo.ClaimAccounting WITH (NOLOCK)
WHERE PostingDate>GETDATE()-4
GO
SELECT *
INTO ClaimAccounting_Assignments
FROM [LAS-PDW-D043].superbill_24214_prod.dbo.ClaimAccounting_Assignments WITH (NOLOCK)
WHERE PostingDate>GETDATE()-4
GO
SELECT *
INTO ClaimAccounting_Billings
FROM [LAS-PDW-D043].superbill_24214_prod.dbo.ClaimAccounting_Billings WITH (NOLOCK)
WHERE PostingDate>GETDATE()-4
GO
SELECT *
INTO ClaimStatus
FROM [LAS-PDW-D043].superbill_24214_prod.dbo.ClaimStatus WITH (NOLOCK)
GO
SELECT *
INTO ClaimStatusCode
FROM [LAS-PDW-D043].superbill_24214_prod.dbo.ClaimStatusCode WITH (NOLOCK)
GO
SELECT *
INTO ClaimTransaction
FROM [LAS-PDW-D043].superbill_24214_prod.dbo.ClaimTransaction WITH (NOLOCK)
WHERE CreatedDate>GETDATE()-4
GO
SELECT *
INTO ClaimTransactionType
FROM [LAS-PDW-D043].superbill_24214_prod.dbo.ClaimTransactionType WITH (NOLOCK)
GO
SELECT *
INTO Doctor
FROM [LAS-PDW-D043].superbill_24214_prod.dbo.Doctor WITH (NOLOCK)
WHERE CreatedDate>GETDATE()-4
GO
SELECT *
INTO Encounter
FROM [LAS-PDW-D043].superbill_24214_prod.dbo.Encounter WITH (NOLOCK)
WHERE CreatedDate>GETDATE()-4
GO
SELECT *
INTO EncounterDiagnosis
FROM [LAS-PDW-D043].superbill_24214_prod.dbo.EncounterDiagnosis WITH (NOLOCK)
WHERE CreatedDate>GETDATE()-4
GO
SELECT *
INTO EncounterProcedure
FROM [LAS-PDW-D043].superbill_24214_prod.dbo.EncounterProcedure WITH (NOLOCK)
WHERE CreatedDate>GETDATE()-4
GO
SELECT *
INTO EncounterStatus
FROM [LAS-PDW-D043].superbill_24214_prod.dbo.EncounterStatus WITH (NOLOCK)
WHERE CreatedDate>GETDATE()-4
GO
SELECT *
INTO ICD10DiagnosisCodeCategory
FROM [LAS-PDW-D043].superbill_24214_prod.dbo.ICD10DiagnosisCodeCategory WITH (NOLOCK)
WHERE CreatedDate>GETDATE()-4
GO
SELECT *
INTO ICD10DiagnosisCodeDictionary
FROM [LAS-PDW-D043].superbill_24214_prod.dbo.ICD10DiagnosisCodeDictionary WITH (NOLOCK)
WHERE CreatedDate>GETDATE()-4
GO
SELECT *
INTO ICD9DiagnosisCodeDictionary
FROM [LAS-PDW-D043].superbill_24214_prod.dbo.ICD9DiagnosisCodeDictionary WITH (NOLOCK)
WHERE CreatedDate>GETDATE()-4
GO
SELECT *
INTO DiagnosisMapSource
FROM [LAS-PDW-D043].superbill_24214_prod.dbo.DiagnosisMapSource WITH (NOLOCK)
GO
SELECT *
INTO InsuranceCompany
FROM [LAS-PDW-D043].superbill_24214_prod.dbo.InsuranceCompany WITH (NOLOCK)
WHERE CreatedDate>GETDATE()-4
GO
SELECT *
INTO InsuranceCompanyPlan
FROM [LAS-PDW-D043].superbill_24214_prod.dbo.InsuranceCompanyPlan WITH (NOLOCK)
WHERE CreatedDate>GETDATE()-4
GO
SELECT *
INTO InsurancePolicy
FROM [LAS-PDW-D043].superbill_24214_prod.dbo.InsurancePolicy WITH (NOLOCK)
WHERE CreatedDate>GETDATE()-4
GO
SELECT *
INTO Patient
FROM [LAS-PDW-D043].superbill_24214_prod.dbo.Patient WITH (NOLOCK)
WHERE CreatedDate>GETDATE()-4
GO
SELECT *
INTO PatientCase
FROM [LAS-PDW-D043].superbill_24214_prod.dbo.PatientCase WITH (NOLOCK)
WHERE CreatedDate>GETDATE()-4
GO
SELECT *
INTO PayerScenarioType
FROM [LAS-PDW-D043].superbill_24214_prod.dbo.PayerScenarioType WITH (NOLOCK)
GO
SELECT PaymentID, PracticeID, PaymentAmount, PaymentMethodCode, PayerTypeCode, PayerID, PaymentNumber, Description, CreatedDate, ModifiedDate, TIMESTAMP, SourceEncounterID, PostingDate, PaymentTypeID, DefaultAdjustmentCode, BatchID, CreatedUserID,
ModifiedUserID, SourceAppointmentID, CONVERT(XML,EOBEditable)AS EOBEditable, AdjudicationDate, ClearinghouseResponseID, CONVERT(XML,ERAErrors)AS ERAErrors, AppointmentID, AppointmentStartDate, PaymentCategoryID, overrideClosingDate, IsOnline
INTO Payment
FROM OPENQUERY ( [LAS-PDW-D043] ,'SELECT PaymentID, PracticeID, PaymentAmount, PaymentMethodCode, PayerTypeCode, PayerID, PaymentNumber, Description, CreatedDate, ModifiedDate, TIMESTAMP, SourceEncounterID, PostingDate, PaymentTypeID, DefaultAdjustmentCode, BatchID, CreatedUserID,
ModifiedUserID, SourceAppointmentID, CONVERT(nvarchar (MAX),EOBEditable)AS EOBEditable, AdjudicationDate, ClearinghouseResponseID, CONVERT(nvarchar (MAX),ERAErrors)as ERAErrors, AppointmentID, AppointmentStartDate, PaymentCategoryID, overrideClosingDate, IsOnline
FROM superbill_24214_prod.dbo.Payment WITH (NOLOCK) WHERE CreatedDate>GETDATE()-4')
GO
SELECT *
INTO PaymentAuthorization
FROM [LAS-PDW-D043].superbill_24214_prod.dbo.PaymentAuthorization WITH (NOLOCK)
WHERE CreatedDateTime>GETDATE()-4
GO
SELECT PaymentClaimID, PaymentID, PracticeID, PatientID, EncounterID, ClaimID, CONVERT(XML,EOBXml)AS EOBXml, --CONVERT(XML,RawEOBXml0)AS RawEOBXml0,
Notes, Reversed, Draft, HasError, ErrorMsg, PaymentRawEOBID
INTO PaymentClaim
FROM OPENQUERY( [LAS-PDW-D043] ,'SELECT pc.PaymentClaimID, pc.PaymentID, pc.PracticeID, pc.PatientID, pc.EncounterID, pc.ClaimID, convert(nvarchar (MAX),pc.EOBXml) as EOBXml, --convert(nvarchar (MAX),pc.RawEOBXml)as RawEOBXml,
pc.Notes, pc.Reversed, pc.Draft, pc.HasError, pc.ErrorMsg, pc.PaymentRawEOBID
FROM superbill_24214_prod.dbo.PaymentClaim pc with (nolock)
	JOIN superbill_24214_prod.dbo.Payment p with (nolock) ON p.PaymentID=pc.PaymentID
WHERE p.CreatedDate>GETDATE()-4')
GO
SELECT *
INTO PaymentMethodCode
FROM [LAS-PDW-D043].superbill_24214_prod.dbo.PaymentMethodCode WITH (NOLOCK)
GO
SELECT *
INTO Practice
FROM [LAS-PDW-D043].superbill_24214_prod.dbo.Practice WITH (NOLOCK)
WHERE CreatedDate>GETDATE()-4
GO
SELECT *
INTO ProcedureCodeDictionary
FROM [LAS-PDW-D043].superbill_24214_prod.dbo.ProcedureCodeDictionary WITH (NOLOCK)
WHERE CreatedDate>GETDATE()-4
GO
SELECT *
INTO RefundToPayments
FROM [LAS-PDW-D043].superbill_24214_prod.dbo.RefundToPayments WITH (NOLOCK)
WHERE CreatedDate>GETDATE()-4
GO
SELECT *
INTO servicelocation
FROM [LAS-PDW-D043].superbill_24214_prod.dbo.servicelocation WITH (NOLOCK)
WHERE CreatedDate>GETDATE()-4
GO
;

SELECT
   t.NAME AS TableName,
   MAX(p.rows) AS RowCounts_After
INTO PTNetwork_DailyDeltas.dbo.RowCounts_After
FROM
   [LAS-PDW-D043].superbill_24214_prod.sys.tables t
INNER JOIN
   [LAS-PDW-D043].superbill_24214_prod.sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN
   [LAS-PDW-D043].superbill_24214_prod.sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id

WHERE
   t.is_ms_shipped = 0
GROUP BY
   t.NAME   --,  p.Rows
ORDER BY
    t.Name
	;



USE [PTNetwork_DailyDeltas]
GO
;
SELECT b.TableName, b.RowCounts_Before, a.RowCounts_After
	   ,(b.RowCounts_Before-a.RowCounts_After)AS Difference
INTO RowCounts
FROM RowCounts_Before b
	JOIN RowCounts_After a ON
		a.TableName=b.TableName
	JOIN sys.tables st ON a.TableName = st.name
WHERE b.TableName<>'RowCounts_Before'

DROP TABLE RowCounts_Before
DROP TABLE RowCounts_After
