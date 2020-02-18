/*----------------------------------

KareoBizclaims DATABASE UPDATE SCRIPT

v1.38.xxxx to v1.39.xxxx
----------------------------------*/

----------------------------------
--BEGIN TRAN 
----------------------------------

/*-----------------------------------------------------------------------------
Case 5214 / 13028: Clearinghouse Reports
-----------------------------------------------------------------------------*/

-- ========================================================================
CREATE TABLE ClearinghouseResponseSourceType 
	(ClearinghouseResponseSourceTypeID int identity(1,1) NOT NULL PRIMARY KEY,
	SourceTypeName varchar(50))
GO

INSERT INTO ClearinghouseResponseSourceType (SourceTypeName) VALUES ('Internal')
INSERT INTO ClearinghouseResponseSourceType (SourceTypeName) VALUES ('Clearinghouse')
INSERT INTO ClearinghouseResponseSourceType (SourceTypeName) VALUES ('Payer')
INSERT INTO ClearinghouseResponseSourceType (SourceTypeName) VALUES ('Printer')
GO

-- ========================================================================
CREATE TABLE ClearinghouseResponseReportType
	(ClearinghouseResponseReportTypeID int identity(1,1) NOT NULL PRIMARY KEY,
	ReportTypeName varchar(50))
GO

INSERT INTO ClearinghouseResponseReportType (ReportTypeName) VALUES ('EFT Check')
INSERT INTO ClearinghouseResponseReportType (ReportTypeName) VALUES ('ERA')
INSERT INTO ClearinghouseResponseReportType (ReportTypeName) VALUES ('Processing')
INSERT INTO ClearinghouseResponseReportType (ReportTypeName) VALUES ('EOB')
INSERT INTO ClearinghouseResponseReportType (ReportTypeName) VALUES ('Monthly')
INSERT INTO ClearinghouseResponseReportType (ReportTypeName) VALUES ('Statement')
INSERT INTO ClearinghouseResponseReportType (ReportTypeName) VALUES ('Other')
GO

-- ========================================================================
ALTER TABLE BizclaimsResponse
ADD
ClearinghouseResponseReportTypeID int,
ClearinghouseResponseSourceTypeID int,
SourceName varchar(128),
Notes varchar(256),
TotalAmount money,
ItemCount int,
Rejected int,
Denied int,
CheckList varchar(2048)
GO

ALTER TABLE [dbo].[BizclaimsResponse]  WITH CHECK ADD CONSTRAINT [FK_BizclaimsResponse_ClearinghouseResponseReportType] FOREIGN KEY([ClearinghouseResponseReportTypeID])
REFERENCES [dbo].[ClearinghouseResponseReportType] ([ClearinghouseResponseReportTypeID])
GO

ALTER TABLE [dbo].[BizclaimsResponse]  WITH CHECK ADD CONSTRAINT [FK_BizclaimsResponse_ClearinghouseResponseSourceType] FOREIGN KEY([ClearinghouseResponseSourceTypeID])
REFERENCES [dbo].[ClearinghouseResponseSourceType] ([ClearinghouseResponseSourceTypeID])
GO

-- ========================================================================
ALTER TABLE ProxymedResponse
ADD
ClearinghouseResponseReportTypeID int,
ClearinghouseResponseSourceTypeID int,
SourceName varchar(128),
Notes varchar(256),
TotalAmount money,
ItemCount int,
Rejected int,
Denied int,
CheckList varchar(2048)
GO

ALTER TABLE [dbo].[ProxymedResponse]  WITH CHECK ADD CONSTRAINT [FK_ProxymedResponse_ClearinghouseResponseReportType] FOREIGN KEY([ClearinghouseResponseReportTypeID])
REFERENCES [dbo].[ClearinghouseResponseReportType] ([ClearinghouseResponseReportTypeID])
GO

ALTER TABLE [dbo].[ProxymedResponse]  WITH CHECK ADD CONSTRAINT [FK_ProxymedResponse_ClearinghouseResponseSourceType] FOREIGN KEY([ClearinghouseResponseSourceTypeID])
REFERENCES [dbo].[ClearinghouseResponseSourceType] ([ClearinghouseResponseSourceTypeID])
GO

-- ========================================================================
ALTER TABLE OfficeAllyResponse
ADD
ClearinghouseResponseReportTypeID int,
ClearinghouseResponseSourceTypeID int,
SourceName varchar(128),
Notes varchar(256),
TotalAmount money,
ItemCount int,
Rejected int,
Denied int,
CheckList varchar(2048)
GO

ALTER TABLE [dbo].[OfficeAllyResponse]  WITH CHECK ADD CONSTRAINT [FK_OfficeAllyResponse_ClearinghouseResponseReportType] FOREIGN KEY([ClearinghouseResponseReportTypeID])
REFERENCES [dbo].[ClearinghouseResponseReportType] ([ClearinghouseResponseReportTypeID])
GO

ALTER TABLE [dbo].[OfficeAllyResponse]  WITH CHECK ADD CONSTRAINT [FK_OfficeAllyResponse_ClearinghouseResponseSourceType] FOREIGN KEY([ClearinghouseResponseSourceTypeID])
REFERENCES [dbo].[ClearinghouseResponseSourceType] ([ClearinghouseResponseSourceTypeID])
GO

-- ========================================================================
ALTER TABLE GatewayEDIResponse
ADD
ClearinghouseResponseReportTypeID int,
ClearinghouseResponseSourceTypeID int,
SourceName varchar(128),
Notes varchar(256),
TotalAmount money,
ItemCount int,
Rejected int,
Denied int,
CheckList varchar(2048)
GO

ALTER TABLE [dbo].[GatewayEDIResponse]  WITH CHECK ADD CONSTRAINT [FK_GatewayEDIResponse_ClearinghouseResponseReportType] FOREIGN KEY([ClearinghouseResponseReportTypeID])
REFERENCES [dbo].[ClearinghouseResponseReportType] ([ClearinghouseResponseReportTypeID])
GO

ALTER TABLE [dbo].[GatewayEDIResponse]  WITH CHECK ADD CONSTRAINT [FK_GatewayEDIResponse_ClearinghouseResponseSourceType] FOREIGN KEY([ClearinghouseResponseSourceTypeID])
REFERENCES [dbo].[ClearinghouseResponseSourceType] ([ClearinghouseResponseSourceTypeID])
GO

-- ========================================================================
-- migrate obvious data pieces into the new fields (case 13027):

-- EFT Checks
UPDATE ProxymedResponse SET 
ClearinghouseResponseReportTypeID = 1, ClearinghouseResponseSourceTypeID = 3		-- Payer
WHERE ResponseType = 35

-- ERA processable
UPDATE ProxymedResponse SET 
ClearinghouseResponseReportTypeID = 2, ClearinghouseResponseSourceTypeID = 3
WHERE ResponseType = 33

-- Processing
UPDATE ProxymedResponse SET 
ClearinghouseResponseReportTypeID = 3, ClearinghouseResponseSourceTypeID = 1		-- Internal
WHERE ResponseType = 17

-- EOB
UPDATE ProxymedResponse SET 
ClearinghouseResponseReportTypeID = 4, ClearinghouseResponseSourceTypeID = 3
WHERE ResponseType = 32

-- Monthly
UPDATE ProxymedResponse SET 
ClearinghouseResponseReportTypeID = 5, ClearinghouseResponseSourceTypeID = 2		-- Clearinghouse
WHERE ResponseType IN (14, 15)

-- Statement (like Daily)
UPDATE ProxymedResponse SET 
ClearinghouseResponseReportTypeID = 6, ClearinghouseResponseSourceTypeID = 2
WHERE ResponseType IN (13, 16, 18)

-- Statement (like Daily)
UPDATE ProxymedResponse SET 
ClearinghouseResponseReportTypeID = 6, ClearinghouseResponseSourceTypeID = 3
WHERE ResponseType = 12

-- Patient Statement Report
UPDATE ProxymedResponse SET 
ClearinghouseResponseReportTypeID = 6, ClearinghouseResponseSourceTypeID = 4
WHERE ResponseType = 22

-- Source Name can be also filled here:
UPDATE ProxymedResponse SET 
SourceName = 'MedAvant'
GO

-- Payer Name
UPDATE ProxymedResponse SET 
SourceName = REPLACE(Title, ' ELECTRONIC RESPONSE REPORT', '')
WHERE Title LIKE '% ELECTRONIC RESPONSE REPORT%' AND ResponseType = 12
GO

-- Payer Name for EOBs
UPDATE ProxymedResponse SET 
SourceName = SUBSTRING(Title,CHARINDEX(') - ',Title)+4,100)
WHERE Title LIKE '%) - %' AND ResponseType IN (32, 33, 34, 35)
GO

-- Payer Name for ERAs
UPDATE ProxymedResponse SET 
SourceName = SUBSTRING(Title,CHARINDEX('*** ',Title)+5,100)
WHERE Title LIKE '%*** %' AND ResponseType IN (32, 33, 34, 35)
GO

-- EFT Checks 
UPDATE ProxymedResponse SET 
CheckList = REPLACE(SUBSTRING(Title,CHARINDEX('(',Title)+1,255),')','') 
WHERE Title LIKE '%EFT Check %' AND ResponseType IN (35)
GO

-- ERA-related Checks 
UPDATE ProxymedResponse SET 
CheckList = REPLACE(SUBSTRING(Title,CHARINDEX('X12/835 (',Title)+9,255),')','') 
WHERE Title LIKE '%X12/835 (%' AND ResponseType = 33
GO

UPDATE ProxymedResponse SET 
CheckList = SUBSTRING(CheckList,1,CHARINDEX('**',CheckList)-1) 
WHERE Title LIKE '%X12/835 (%' AND ResponseType = 33
GO

-- EOB-related Checks 
UPDATE ProxymedResponse SET 
CheckList = SUBSTRING(Title,CHARINDEX('Explanation of Provider Payment (',Title)+33,255) 
WHERE Title LIKE '%Explanation of Provider Payment (%' AND ResponseType = 32
GO

UPDATE ProxymedResponse SET 
CheckList = REPLACE(SUBSTRING(CheckList,1,CHARINDEX(')',CheckList)),')','') 
WHERE Title LIKE '%Explanation of Provider Payment (%' AND ResponseType = 32
GO

-- All claim counters - parse Title to get information
UPDATE ProxymedResponse SET ItemCount =
CONVERT(INT,SUBSTRING(Title,CHARINDEX(' P:',Title)+3,CHARINDEX(' / ',Title)-CHARINDEX(' P:',Title)-3))
WHERE Title LIKE '% P:%/%'
GO

UPDATE ProxymedResponse SET Rejected =
CONVERT(INT,REPLACE(SUBSTRING(Title,CHARINDEX(' R:',Title)+3,4),'/',''))
WHERE Title LIKE '% R:%' AND Title NOT LIKE '% Validation %'
GO

UPDATE ProxymedResponse SET Rejected =
CONVERT(INT,SUBSTRING(Title,CHARINDEX(' R:',Title)+3,10))
WHERE Title LIKE '% Validation %' AND Title LIKE '% R:%'
GO

UPDATE ProxymedResponse SET ItemCount = ISNULL(ItemCount,0) + ISNULL(Rejected,0)
WHERE ItemCount IS NOT NULL OR Rejected IS NOT NULL
GO

-- ========================================================================

-- Statement (like Daily)
UPDATE OfficeAllyResponse SET 
ClearinghouseResponseReportTypeID = 6, ClearinghouseResponseSourceTypeID = 2
WHERE ResponseType IN (13, 16, 18)

-- Statement (like Daily)
UPDATE OfficeAllyResponse SET 
ClearinghouseResponseReportTypeID = 6, ClearinghouseResponseSourceTypeID = 3
WHERE ResponseType = 12

-- Source Name can be also filled here:
UPDATE OfficeAllyResponse SET 
SourceName = 'Office Ally'
GO

-- All claim counters - parse Title to get information
UPDATE OfficeAllyResponse SET ItemCount =
CONVERT(INT,SUBSTRING(Title,CHARINDEX(' P:',Title)+3,CHARINDEX(' / ',Title)-CHARINDEX(' P:',Title)-3))
WHERE Title LIKE '% P:%/%'
GO

UPDATE OfficeAllyResponse SET Rejected =
CONVERT(INT,REPLACE(SUBSTRING(Title,CHARINDEX(' R:',Title)+3,4),'/',''))
WHERE Title LIKE '% R:%' AND Title NOT LIKE '% Validation %'
GO

UPDATE OfficeAllyResponse SET Rejected =
CONVERT(INT,SUBSTRING(Title,CHARINDEX(' R:',Title)+3,10))
WHERE Title LIKE '% Validation %' AND Title LIKE '% R:%'
GO

UPDATE OfficeAllyResponse SET ItemCount = ISNULL(ItemCount,0) + ISNULL(Rejected,0)
WHERE ItemCount IS NOT NULL OR Rejected IS NOT NULL
GO

--ROLLBACK
--COMMIT

