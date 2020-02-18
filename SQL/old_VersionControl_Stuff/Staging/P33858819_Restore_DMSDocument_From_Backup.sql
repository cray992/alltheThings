--Nannette Diaz DPM (7579)
--kprod-db25
BEGIN TRANSACTION;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
COMMIT;
/*
USE superbill_7579_dev;
GO
USE superbill_7579_prod;
GO
*/
IF OBJECT_ID('tempdb..#dms_doc') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#dms_doc;
    END
GO

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

DECLARE @is_debug AS BIT;
SET @is_debug = 0;

CREATE TABLE #dms_doc
    (
      [DMSDocumentID] [int] NOT NULL ,
      [DocumentName] [varchar](128) NOT NULL ,
      [DocumentLabelTypeID] [int] NOT NULL ,
      [DocumentStatusTypeID] [int] NOT NULL ,
      [Notes] [text] NULL ,
      [Properties] [text] NULL ,
      [OriginalDMSDocumentID] [int] NULL ,
      [DocumentTypeID] [int] NOT NULL ,
      [CreatedDate] [datetime] NOT NULL ,
      [CreatedUserID] [int] NOT NULL ,
      [ModifiedDate] [datetime] NOT NULL ,
      [ModifiedUserID] [int] NOT NULL ,
      [RecordTimeStamp] [timestamp] NOT NULL ,
      [PracticeID] [int] NULL
    );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (198
           ,'ALEIDA WIRTH'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-05-21 05:33:14.083'
           ,30553
           ,'2012-05-21 05:33:14.083'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (199
           ,'wirth'
           ,8
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-05-21 08:17:44.630'
           ,30553
           ,'2012-05-21 08:17:44.630'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (200
           ,'ANA GONAELZ ID'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-21 08:19:14.573'
           ,30553
           ,'2012-05-21 08:19:14.573'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (203
           ,'ANA GONAELZ ID'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-21 08:26:46.357'
           ,30553
           ,'2012-05-21 08:26:46.357'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (204
           ,'sara abreu ref '
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-21 08:44:58.837'
           ,30553
           ,'2012-05-21 08:44:58.837'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (205
           ,'nemuris insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-21 08:54:23.660'
           ,30553
           ,'2012-05-21 08:54:23.660'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (206
           ,'MICHELLE CDOPELAND INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-21 08:55:07.653'
           ,30553
           ,'2012-05-21 08:55:07.653'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (207
           ,'wirth insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-21 08:56:11.940'
           ,30553
           ,'2012-05-21 08:56:11.940'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (208
           ,'casuski insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-21 09:02:12.453'
           ,30553
           ,'2012-05-21 09:02:12.453'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (209
           ,'juan jorge insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-21 09:03:02.197'
           ,30553
           ,'2012-05-21 09:03:02.197'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (210
           ,'AGUTA REFERRAL '
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-21 09:04:13.697'
           ,30553
           ,'2012-05-21 09:04:13.697'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (211
           ,'donald waldman insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-21 09:05:14.780'
           ,30553
           ,'2012-05-21 09:05:14.780'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (212
           ,'DONHERT REF'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-21 09:15:43.290'
           ,30553
           ,'2012-05-21 09:15:43.290'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (213
           ,'maria bautista insu'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-21 10:08:00.793'
           ,30553
           ,'2012-05-21 10:08:00.793'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (214
           ,'MCCREARY ID'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-21 10:09:56.063'
           ,30553
           ,'2012-05-21 10:09:56.063'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (215
           ,'MARLYN PARKER INSU'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-21 10:21:01.203'
           ,30553
           ,'2012-05-21 10:21:01.203'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (216
           ,'parquer insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-21 10:48:41.833'
           ,30553
           ,'2012-05-21 10:48:41.833'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (217
           ,'REAMS INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-21 11:05:24.407'
           ,30553
           ,'2012-05-21 11:05:24.407'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (218
           ,'wilfredo rivera insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-21 12:19:15.547'
           ,30553
           ,'2012-05-21 12:19:15.547'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (220
           ,'STRAWSWER INSU'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-21 13:55:47.270'
           ,30553
           ,'2012-05-21 13:55:47.270'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (221
           ,'CELINA CHEIMAN INSUR'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-21 13:57:15.980'
           ,30553
           ,'2012-05-21 13:57:15.980'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (222
           ,'NEREIDA ASORY ID'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-22 04:17:21.227'
           ,30553
           ,'2012-05-22 04:17:21.227'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (223
           ,'AUTHORIZATION FOR DOS 5/18/12 '
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-22 04:19:03.773'
           ,30553
           ,'2012-05-22 04:19:03.773'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (224
           ,'ESTERLYNE GAYE INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-22 04:19:41.350'
           ,30553
           ,'2012-05-22 04:19:41.350'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (225
           ,'ITURRIAGA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-22 04:20:20.420'
           ,30553
           ,'2012-05-22 04:20:20.420'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (227
           ,'GUADALUPE MENDOZA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-22 04:29:26.093'
           ,30553
           ,'2012-05-22 04:29:26.093'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (228
           ,'SAMCHEZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-22 04:39:55.127'
           ,30553
           ,'2012-05-22 04:39:55.127'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (229
           ,'alfonso hernandez id'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-22 04:52:56.890'
           ,30553
           ,'2012-05-22 04:52:56.890'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (230
           ,'STRAWSEER REFERRAL'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-22 05:24:03.943'
           ,30553
           ,'2012-05-22 05:24:03.943'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (231
           ,'GIRALDO INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-22 05:45:16.047'
           ,30553
           ,'2012-05-22 05:45:16.047'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (232
           ,'MARIA LAO INSURANCE'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-22 05:48:04.530'
           ,30553
           ,'2012-05-22 05:48:04.530'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (233
           ,'LIDIA ESTRADA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-22 05:49:14.250'
           ,30553
           ,'2012-05-22 05:49:14.250'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (234
           ,'JESSICA DAY REFERRAL'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-22 06:01:56.837'
           ,30553
           ,'2012-05-22 06:01:56.837'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (236
           ,'RANGEL  insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-22 06:22:41.527'
           ,30553
           ,'2012-05-22 06:22:41.527'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (237
           ,'MARIA HERRERA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-22 06:53:32.010'
           ,30553
           ,'2012-05-22 06:53:32.010'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (238
           ,'Howard insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-24 06:08:48.540'
           ,30553
           ,'2012-05-24 06:08:48.540'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (239
           ,'RODGERS INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-24 06:11:41.623'
           ,30553
           ,'2012-05-24 06:11:41.623'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (240
           ,'jamal thalji insurane'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-24 06:13:00.460'
           ,30553
           ,'2012-05-24 06:13:00.460'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (241
           ,'FRED PENA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-24 06:13:48.347'
           ,30553
           ,'2012-05-24 06:13:48.347'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (242
           ,'barbara warr insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-24 06:15:43.697'
           ,30553
           ,'2012-05-24 06:15:43.697'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (243
           ,'ADA RODRIG INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-24 06:16:45.937'
           ,30553
           ,'2012-05-24 06:16:45.937'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (244
           ,'LOPES DE HARO INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-24 06:18:12.380'
           ,30553
           ,'2012-05-24 06:18:12.380'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (245
           ,'HATLEY INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-24 06:19:24.357'
           ,30553
           ,'2012-05-24 06:19:24.357'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (246
           ,'DEBRA HEARN REFERRAL FOR DOS ON MAY 2012 '
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-24 06:20:55.030'
           ,30553
           ,'2012-05-24 06:20:55.030'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (247
           ,'cruz perez insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-24 06:23:20.363'
           ,30553
           ,'2012-05-24 06:23:20.363'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (248
           ,'JOHN ARTHUR INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-24 06:24:24.387'
           ,30553
           ,'2012-05-24 06:24:24.387'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (249
           ,'jaemme wilson insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-24 06:50:44.527'
           ,30553
           ,'2012-05-24 06:50:44.527'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (250
           ,'FELICITA MEZA ID'
           ,8
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-24 08:27:10.390'
           ,30553
           ,'2012-05-24 08:27:10.390'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (251
           ,'dolores jhonson insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-24 08:28:09.920'
           ,30553
           ,'2012-05-24 08:28:09.920'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (253
           ,'NORMA PEREZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-24 08:29:40.783'
           ,30553
           ,'2012-05-24 08:29:40.783'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (254
           ,'MELANIE INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-24 08:30:55.557'
           ,30553
           ,'2012-05-24 08:30:55.557'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (255
           ,'TAMPLIN INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-24 08:32:10.677'
           ,30553
           ,'2012-05-24 08:32:10.677'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (256
           ,'LARDEN INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-24 08:34:06.173'
           ,30553
           ,'2012-05-24 08:34:06.173'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (257
           ,'LEILA ACEVEDO INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-24 08:35:42.960'
           ,30553
           ,'2012-05-24 08:35:42.960'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (258
           ,'MARK WILSON REFERRAL FOR DOS 5/23/12 '
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-24 08:50:56.857'
           ,30553
           ,'2012-05-24 08:50:56.857'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (259
           ,'MILLS INFORMARION'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-24 08:52:10.130'
           ,30553
           ,'2012-05-24 08:52:10.130'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (260
           ,'WILLIAM MILLER INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-24 12:00:51.117'
           ,30553
           ,'2012-05-24 12:00:51.117'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (261
           ,'PURA DOMINGUEZ  REFERRAL FOR DOS 5/24/12 '
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-24 12:02:02.713'
           ,30553
           ,'2012-05-24 12:02:02.713'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (262
           ,'PURA DOMINGUEZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-24 12:02:27.243'
           ,30553
           ,'2012-05-24 12:02:27.243'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (263
           ,'GILBERTO CORTES INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-24 12:03:13.663'
           ,30553
           ,'2012-05-24 12:03:13.663'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (264
           ,'RAAB  INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-24 12:04:24.890'
           ,30553
           ,'2012-05-24 12:04:24.890'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (265
           ,'przbila insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-24 12:07:36.420'
           ,30553
           ,'2012-05-24 12:07:36.420'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (266
           ,'TYLER INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-24 13:26:39.850'
           ,30553
           ,'2012-05-24 13:26:39.850'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (267
           ,'CONKLIN REFERRAL'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-24 13:28:36.763'
           ,30553
           ,'2012-05-24 13:28:36.763'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (268
           ,'BAUMAN INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-24 13:29:52.610'
           ,30553
           ,'2012-05-24 13:29:52.610'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (269
           ,'NGUYEN INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-25 10:54:25.670'
           ,30553
           ,'2012-05-25 10:54:25.670'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (270
           ,'PATRICIA SANTANA  INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-25 10:56:38.080'
           ,30553
           ,'2012-05-25 10:56:38.080'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (271
           ,'PMT JANER'
           ,10
           ,2
           ,''
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>SHARP MFP TWAIN K</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-05-25 11:00:34.230'
           ,30553
           ,'2012-07-12 07:44:22.900'
           ,30564
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (272
           ,'EVERSOLE MEDICAID INFO'
           ,3
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-25 11:18:48.543'
           ,30553
           ,'2012-05-25 11:18:48.543'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (273
           ,'LAURA PEARSALL'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-25 11:42:41.217'
           ,30553
           ,'2012-05-25 11:42:41.217'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (274
           ,'PMT JANER'
           ,10
           ,2
           ,'mc done'
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>SHARP MFP TWAIN K</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>1</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-05-25 12:16:57.053'
           ,30553
           ,'2012-07-12 07:42:06.790'
           ,30564
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (275
           ,'DENIED JANER'
           ,13
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>SHARP MFP TWAIN K</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-05-25 12:20:28.677'
           ,30553
           ,'2012-07-12 07:31:33.037'
           ,30564
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (276
           ,'PMT DIAZ'
           ,10
           ,2
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>SHARP MFP TWAIN K</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-05-25 12:22:23.777'
           ,30553
           ,'2012-07-12 07:44:08.547'
           ,30564
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (277
           ,'PMT DIAZ'
           ,10
           ,2
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>SHARP MFP TWAIN K</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-05-25 12:23:57.517'
           ,30553
           ,'2012-07-12 07:43:46.390'
           ,30564
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (278
           ,'PMT DIAZ'
           ,10
           ,2
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>SHARP MFP TWAIN K</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>1</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-05-25 12:27:38.483'
           ,30553
           ,'2012-07-12 07:43:27.997'
           ,30564
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (279
           ,'DENIED DIAZ'
           ,13
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>SHARP MFP TWAIN K</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-05-25 12:29:53.830'
           ,30553
           ,'2012-07-12 07:31:15.440'
           ,30564
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (280
           ,'OTC - MAY - JANER'
           ,10
           ,2
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>SHARP MFP TWAIN K</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-05-25 12:31:29.013'
           ,30553
           ,'2012-07-12 07:36:06.957'
           ,30564
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (281
           ,'OTC- DIAZ- MAY'
           ,10
           ,2
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>SHARP MFP TWAIN K</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-05-25 12:32:53.390'
           ,30553
           ,'2012-07-12 07:41:43.717'
           ,30564
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (282
           ,'Fax - 05/28/2012 08:47'
           ,1
           ,1
           ,NULL
           ,NULL
           ,NULL
           ,1
           ,'2012-05-28 08:47:45.787'
           ,1526
           ,'2012-05-28 08:47:45.787'
           ,1526
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (283
           ,'MARGARITA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-29 05:53:59.130'
           ,30553
           ,'2012-05-29 05:53:59.130'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (284
           ,'PRIOL INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-29 09:42:29.590'
           ,30553
           ,'2012-05-29 09:42:29.590'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (285
           ,'FORBES  INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-29 09:43:23.740'
           ,30553
           ,'2012-05-29 09:43:23.740'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (286
           ,'ALVARO INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-29 09:51:15.787'
           ,30553
           ,'2012-05-29 09:51:15.787'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (288
           ,'NASRIN ID '
           ,8
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-29 09:56:45.080'
           ,30553
           ,'2012-05-29 09:56:45.080'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (289
           ,'STOTKO INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-29 09:57:22.793'
           ,30553
           ,'2012-05-29 09:57:22.793'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (290
           ,'ADAM WILLIAMS INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-29 09:58:05.710'
           ,30553
           ,'2012-05-29 09:58:05.710'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (291
           ,'ADAM WILLIAMS AUTHORIZ'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-29 09:58:22.580'
           ,30553
           ,'2012-05-29 09:58:22.580'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (292
           ,'BARRET ANDREA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-29 09:59:07.120'
           ,30553
           ,'2012-05-29 09:59:07.120'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (293
           ,'PRIOLEU BARBARA REFERRAL'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-29 10:00:06.500'
           ,30553
           ,'2012-05-29 10:00:06.500'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (294
           ,'MARIA FRAGOSO  ID'
           ,8
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-29 10:01:04.850'
           ,30553
           ,'2012-05-29 10:01:04.850'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (295
           ,'MARGARITA TORRES GUZMAN INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-29 10:01:56.380'
           ,30553
           ,'2012-05-29 10:01:56.380'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (296
           ,'LAURELLE TEED INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-29 10:05:20.077'
           ,30553
           ,'2012-05-29 10:05:20.077'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (297
           ,'daysys insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-29 12:00:23.273'
           ,30553
           ,'2012-05-29 12:00:23.273'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (298
           ,'REYNA HERRERA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-29 12:11:03.207'
           ,30553
           ,'2012-05-29 12:11:03.207'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (299
           ,'erica matos insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-29 12:11:28.883'
           ,30553
           ,'2012-05-29 12:11:28.883'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (300
           ,'VITALIA DOMINGUEZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-29 12:13:29.367'
           ,30553
           ,'2012-05-29 12:13:29.367'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (301
           ,'RICARDO DOMINGUEZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-29 12:14:02.897'
           ,30553
           ,'2012-05-29 12:14:02.897'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (302
           ,'ANA DOMINGUEZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-29 12:14:39.390'
           ,30553
           ,'2012-05-29 12:14:39.390'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (303
           ,'HILARIA ALVAREZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-29 12:15:59.593'
           ,30553
           ,'2012-05-29 12:15:59.593'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (304
           ,'JOSE TRAVIESO INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-29 12:17:10.987'
           ,30553
           ,'2012-05-29 12:17:10.987'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (305
           ,'donald manguson insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-29 13:09:27.863'
           ,30553
           ,'2012-05-29 13:09:27.863'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (307
           ,'ORALIA ZAYAS INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-29 13:13:43.517'
           ,30553
           ,'2012-05-29 13:13:43.517'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (308
           ,'RUTH MORALES INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-29 13:14:50.290'
           ,30553
           ,'2012-05-29 13:14:50.290'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (309
           ,'alfredo negron insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-29 13:16:48.420'
           ,30553
           ,'2012-05-29 13:16:48.420'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (310
           ,'Fax - 05/29/2012 14:52'
           ,1
           ,1
           ,NULL
           ,NULL
           ,NULL
           ,1
           ,'2012-05-29 14:53:14.807'
           ,1526
           ,'2012-05-29 14:53:14.807'
           ,1526
           ,1
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (311
           ,'LUIS PEREZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-30 08:46:05.490'
           ,30553
           ,'2012-05-30 08:46:05.490'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (312
           ,'eulalia garcia insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-30 08:46:51.100'
           ,30553
           ,'2012-05-30 08:46:51.100'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (313
           ,'ruth morales referral diaz may'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-30 08:47:29.323'
           ,30553
           ,'2012-05-30 08:47:29.323'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (314
           ,'TAMALA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-30 08:48:54.020'
           ,30553
           ,'2012-05-30 08:48:54.020'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (315
           ,'monica diaz insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-30 08:56:14.763'
           ,30553
           ,'2012-05-30 08:56:14.763'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (316
           ,'irma callado id'
           ,8
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-30 08:57:03.353'
           ,30553
           ,'2012-05-30 08:57:03.353'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (317
           ,'PHRONSI  INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-30 08:57:49.693'
           ,30553
           ,'2012-05-30 08:57:49.693'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (318
           ,'GRIFFITH REFERRAL FOR MAY'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-30 08:58:59.050'
           ,30553
           ,'2012-05-30 08:58:59.050'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (319
           ,'AURORA VIGOA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-30 09:00:55.500'
           ,30553
           ,'2012-05-30 09:00:55.500'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (320
           ,'DULCE VILLAGOMEZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-30 09:01:46.783'
           ,30553
           ,'2012-05-30 09:01:46.783'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (321
           ,'DULCE VILLAGOMEZ REFERRAL FOR MAY'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-30 09:02:06.877'
           ,30553
           ,'2012-05-30 09:02:06.877'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (322
           ,'VINCENT ROOMES INSURANCE'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-30 09:04:56.107'
           ,30553
           ,'2012-05-30 09:04:56.107'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (324
           ,'VINCENT ROOMES INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-30 09:05:48.137'
           ,30553
           ,'2012-05-30 09:05:48.137'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (325
           ,'Fax - 05/30/2012 09:15'
           ,1
           ,1
           ,NULL
           ,NULL
           ,NULL
           ,1
           ,'2012-05-30 09:15:38.830'
           ,1526
           ,'2012-05-30 09:15:38.830'
           ,1526
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (326
           ,'MARIA CAMPOY INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-30 09:16:21.543'
           ,30553
           ,'2012-05-30 09:16:21.543'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (327
           ,'ESTHER ECKSTEIN INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-30 10:07:34.357'
           ,30553
           ,'2012-05-30 10:07:34.357'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (328
           ,'ESTHER AUTH FOR FEB'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-30 10:07:54.887'
           ,30553
           ,'2012-05-30 10:07:54.887'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (329
           ,'ANN HARTNETT INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-30 10:45:25.720'
           ,30553
           ,'2012-05-30 10:45:25.720'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (330
           ,'BISHOP INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-30 10:52:49.453'
           ,30553
           ,'2012-05-30 10:52:49.453'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (331
           ,'ELIZABETH MCCWHITE INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-30 10:54:23.773'
           ,30553
           ,'2012-05-30 10:54:23.773'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (332
           ,'DONA ANDERSON INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-30 10:55:25.503'
           ,30553
           ,'2012-05-30 10:55:25.503'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (333
           ,'ALICIA GARCIA ITURRUAGA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-30 10:58:37.720'
           ,30553
           ,'2012-05-30 10:58:37.720'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (334
           ,'alice gonzalez insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-30 11:10:11.367'
           ,30553
           ,'2012-05-30 11:10:11.367'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (335
           ,'MERCEDES RODRIGUEZ INSURACE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-30 11:13:27.750'
           ,30553
           ,'2012-05-30 11:13:27.750'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (336
           ,'MERCEDES RODRIGUEZ REFERRAL FOR DIAZ'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-30 11:14:16.507'
           ,30553
           ,'2012-05-30 11:14:16.507'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (337
           ,'LOURDES ALVARADO INSURANCE '
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-30 11:21:06.123'
           ,30553
           ,'2012-05-30 11:21:06.123'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (338
           ,'GRISEL RIVERA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-30 11:32:15.830'
           ,30553
           ,'2012-05-30 11:32:15.830'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (339
           ,'HERMINA PINA REFERIDO'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-30 11:36:42.220'
           ,30553
           ,'2012-05-30 11:36:42.220'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (340
           ,'CARMEN RODRIG REF INSURANCE'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-30 11:38:19.543'
           ,30553
           ,'2012-05-30 11:38:19.543'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (341
           ,'CATALINA MONTERO REFERRAL FOR MAY VISIT'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-30 11:39:13.287'
           ,30553
           ,'2012-05-30 11:39:13.287'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (342
           ,'RAMON MORALES INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-30 11:58:22.853'
           ,30553
           ,'2012-05-30 11:58:22.853'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (343
           ,'RUTH MORALES REFERRAL JANER'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-30 12:01:03.163'
           ,30553
           ,'2012-05-30 12:01:03.163'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (344
           ,'restall insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-30 12:04:19.747'
           ,30553
           ,'2012-05-30 12:04:19.747'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (345
           ,'AMBER SMITH ID'
           ,8
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-30 12:12:59.320'
           ,30553
           ,'2012-05-30 12:12:59.320'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (346
           ,'LETICIA ROD REFERRAL FOR MAY'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-30 12:14:55.320'
           ,30553
           ,'2012-05-30 12:14:55.320'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (347
           ,'AVILA MORALES INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-30 12:15:42.667'
           ,30553
           ,'2012-05-30 12:15:42.667'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (348
           ,'benicia insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-30 12:42:06.083'
           ,30553
           ,'2012-05-30 12:42:06.083'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (349
           ,'MARY ZAMBOLI INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-30 12:53:24.910'
           ,30553
           ,'2012-05-30 12:53:24.910'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (350
           ,'DOMINGA LOPEZ ID'
           ,9
           ,2
           ,'I confimed insurance on availity on 5/31/12 '
           ,NULL
           ,NULL
           ,2
           ,'2012-05-31 06:43:49.800'
           ,30553
           ,'2012-05-31 06:43:49.800'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (351
           ,'PMT JANER'
           ,10
           ,2
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>SHARP MFP TWAIN K</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>1</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-05-31 09:09:32.760'
           ,30553
           ,'2012-07-12 07:39:56.877'
           ,30564
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (352
           ,'PMT- MISSING'
           ,10
           ,2
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>SHARP MFP TWAIN K</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>1</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-05-31 09:10:57.410'
           ,30553
           ,'2012-07-12 07:39:33.497'
           ,30564
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (353
           ,'OTC- MAY- JANER'
           ,10
           ,2
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>SHARP MFP TWAIN K</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-05-31 09:22:18.180'
           ,30553
           ,'2012-07-12 07:35:56.083'
           ,30564
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (354
           ,'BETTY ALEXANDER INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-31 10:09:02.153'
           ,30553
           ,'2012-05-31 10:09:02.153'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (355
           ,'SYLVIA HORSNBY INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-31 10:09:53.670'
           ,30553
           ,'2012-05-31 10:09:53.670'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (356
           ,'SYLVIA HORNSBY REFERRAL FOR MAY'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-31 10:10:10.120'
           ,30553
           ,'2012-05-31 10:10:10.120'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (357
           ,'LAURA MENDEZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-31 10:10:51.703'
           ,30553
           ,'2012-05-31 10:10:51.703'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (358
           ,'ANNIE ANDERSON INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-31 10:29:17.810'
           ,30553
           ,'2012-05-31 10:29:17.810'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (359
           ,'MARIA DIAZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-31 11:01:55.123'
           ,30553
           ,'2012-05-31 11:01:55.123'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (360
           ,'MICHELLE HELMS INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-31 11:05:09.307'
           ,30553
           ,'2012-05-31 11:05:09.307'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (361
           ,'JUAN ALAYON INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-05-31 11:09:41.277'
           ,30553
           ,'2012-05-31 11:09:41.277'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (362
           ,'PMT DIAZ'
           ,10
           ,2
           ,'mc done'
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>SHARP MFP TWAIN K</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>1</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-05-31 13:58:34.523'
           ,29513
           ,'2012-07-12 07:39:03.543'
           ,30564
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (363
           ,'OTC- MAY- DIAZ'
           ,10
           ,2
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>SHARP MFP TWAIN K</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-05-31 14:02:49.223'
           ,29513
           ,'2012-07-12 07:35:38.987'
           ,30564
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (364
           ,'OTC- MAY - JANER'
           ,10
           ,2
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>SHARP MFP TWAIN K</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-05-31 14:03:54.027'
           ,29513
           ,'2012-07-12 07:35:20.747'
           ,30564
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (365
           ,'MIRANDA MARIANGELI INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-01 05:38:15.200'
           ,30553
           ,'2012-06-01 05:38:15.200'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (366
           ,'DONNAGAGLIOLO_Encounter_2012_01_10_1'
           ,18
           ,2
           ,'FOR JOHANNA GAGLIOLOS NOTES'
           ,NULL
           ,NULL
           ,2
           ,'2012-06-01 06:01:07.410'
           ,29513
           ,'2012-06-01 06:01:07.410'
           ,29513
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (367
           ,'Fax - 06/01/2012 09:40'
           ,1
           ,1
           ,NULL
           ,NULL
           ,NULL
           ,1
           ,'2012-06-01 09:41:11.730'
           ,1526
           ,'2012-06-01 09:41:11.730'
           ,1526
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (369
           ,'MYRIAM VARGAS INSURANCE'
           ,7
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-01 12:12:01.230'
           ,34037
           ,'2012-06-01 12:12:01.230'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (370
           ,'MARIA D ARENAS INSURANCE/ ID'
           ,7
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-01 12:18:01.667'
           ,34037
           ,'2012-06-01 12:18:01.667'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (371
           ,'HECTOR MENDEZ INSURANCE AND ID'
           ,7
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-01 12:22:19.113'
           ,34037
           ,'2012-06-01 12:22:19.113'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (372
           ,'SYLVIA RIVERA ID'
           ,7
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-01 12:26:31.203'
           ,34037
           ,'2012-06-01 12:26:31.203'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (373
           ,'FELICITA CRUZ PEREZ ID INSURANCE'
           ,7
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-01 12:29:30.020'
           ,34037
           ,'2012-06-01 12:29:30.020'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (374
           ,'ANGELA MIRANDA ID/ INSURANCE'
           ,7
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-01 12:31:43.607'
           ,34037
           ,'2012-06-01 12:31:43.607'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (375
           ,'MYRTLE NELSON'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-01 12:35:30.123'
           ,34037
           ,'2012-06-01 12:35:30.123'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (376
           ,'JAVIER VELASQUEZ'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-01 12:37:39.337'
           ,34037
           ,'2012-06-01 12:37:39.337'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (377
           ,'DAMARA FROMETA'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-01 12:40:36.080'
           ,34037
           ,'2012-06-01 12:40:36.080'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (378
           ,'LEANYS RODRIGUEZ'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-01 12:42:24.920'
           ,34037
           ,'2012-06-01 12:42:24.920'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (379
           ,'CLIVELAND HAYNES'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-01 12:48:40.147'
           ,34037
           ,'2012-06-01 12:48:40.147'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (380
           ,'AVENAL HAYNES'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-01 12:51:06.547'
           ,34037
           ,'2012-06-01 12:51:06.547'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (381
           ,'ELSA MARTINEZ'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-01 12:52:05.947'
           ,34037
           ,'2012-06-01 12:52:05.947'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (382
           ,'ANTHONY JOHNSON'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-01 12:53:30.550'
           ,34037
           ,'2012-06-01 12:53:30.550'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (383
           ,'KARENGAY SENNIE ( INSURANCE)'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-01 12:58:39.883'
           ,34037
           ,'2012-07-12 07:28:01.383'
           ,30564
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (384
           ,'ANTONIA SANTOS'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-01 12:59:54.360'
           ,34037
           ,'2012-06-01 12:59:54.360'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (385
           ,'KAREN JEAN ALAYON'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-01 13:02:00.883'
           ,34037
           ,'2012-06-01 13:02:00.883'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (386
           ,'CARIDAD ESTEVEZ'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-01 13:13:31.523'
           ,34037
           ,'2012-06-01 13:13:31.523'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (387
           ,'MICHAEL TUMBLESON'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-01 13:17:30.573'
           ,34037
           ,'2012-06-01 13:17:30.573'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (388
           ,'CEDRIC LAYNE'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-01 13:19:18.297'
           ,34037
           ,'2012-06-01 13:19:18.297'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (389
           ,'AIDA BASAIL'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-01 13:21:35.210'
           ,34037
           ,'2012-06-01 13:21:35.210'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (390
           ,'MONIQUE NEGRETE (FATHER INSURANCE CARD ADAM HERNANDEZ)'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-01 13:35:17.060'
           ,34037
           ,'2012-06-01 13:35:17.060'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (391
           ,'ANGELA RIVERA'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-01 13:47:54.323'
           ,34037
           ,'2012-06-01 13:47:54.323'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (392
           ,'ANA SAHAD'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-01 13:49:23.760'
           ,34037
           ,'2012-06-01 13:49:23.760'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (393
           ,'MIGDALIA SUAREZ'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-01 13:56:10.910'
           ,34037
           ,'2012-06-01 13:56:10.910'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (394
           ,'RUTH YAMBO'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-01 14:06:22.300'
           ,34037
           ,'2012-06-01 14:06:22.300'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (395
           ,'FRANCISCO LANAUZE'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-01 14:08:09.130'
           ,34037
           ,'2012-06-01 14:08:09.130'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (396
           ,'TIMOTHY OLSON (FATHER''S ID AND INSURANCE)'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-01 14:10:25.440'
           ,34037
           ,'2012-06-01 14:10:25.440'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (397
           ,'EUGENIA DORTA'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-01 14:11:42.687'
           ,34037
           ,'2012-06-01 14:11:42.687'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (398
           ,'BENJAMIN WORLAND ID AND INSURANCE)'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-01 14:13:34.823'
           ,34037
           ,'2012-07-12 07:27:47.373'
           ,30564
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (399
           ,'ELIAS NIEVES'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-01 14:15:56.233'
           ,34037
           ,'2012-06-01 14:15:56.233'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (400
           ,'JUAN CORTES'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-01 14:19:58.233'
           ,34037
           ,'2012-06-01 14:19:58.233'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (401
           ,'JOE QUESADA'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-01 14:41:01.933'
           ,34037
           ,'2012-06-01 14:41:01.933'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (402
           ,'MARK LAWSON'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-01 14:43:34.507'
           ,34037
           ,'2012-06-01 14:43:34.507'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (403
           ,'FAYE ROTELLA'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-01 14:51:39.407'
           ,34037
           ,'2012-06-01 14:51:39.407'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (404
           ,'CORCHADO INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-04 09:07:07.900'
           ,30553
           ,'2012-06-04 09:07:07.900'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (405
           ,'CORCHADO BUENO DISCLOSURES'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-04 09:07:43.600'
           ,30553
           ,'2012-06-04 09:07:43.600'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (406
           ,'ISABEL DIAZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-04 13:30:23.930'
           ,30553
           ,'2012-06-04 13:30:23.930'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (407
           ,'LISA VINSON INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-05 04:08:26.380'
           ,30553
           ,'2012-06-05 04:08:26.380'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (408
           ,'LISA VINSON REFERIDO JUNIO'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-05 04:08:44.817'
           ,30553
           ,'2012-06-05 04:08:44.817'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (409
           ,'CARVER INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-05 04:09:43.883'
           ,30553
           ,'2012-06-05 04:09:43.883'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (410
           ,'GWENDOLYN TAYLOR INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-05 04:10:31.277'
           ,30553
           ,'2012-06-05 04:10:31.277'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (411
           ,'ELIA HERNANDEZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-05 04:11:26.563'
           ,30553
           ,'2012-06-05 04:11:26.563'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (412
           ,'ELIA HERNANDEZ REFERRAL FOR JUNE VISIT '
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-05 04:12:26.653'
           ,30553
           ,'2012-06-05 04:12:26.653'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (413
           ,'HOLLAND INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-05 04:15:38.310'
           ,30553
           ,'2012-06-05 04:15:38.310'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (414
           ,'HOLLAND REFERRAL last visit used in june '
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-05 04:16:43.800'
           ,30553
           ,'2012-06-05 04:16:43.800'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (415
           ,'SALVADORA ESTEVES INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-05 04:18:10.850'
           ,30553
           ,'2012-06-05 04:18:10.850'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (416
           ,'SALVADORA ESTEVES REFRRAL for june visit '
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-05 04:18:46.763'
           ,30553
           ,'2012-06-05 04:18:46.763'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (417
           ,'VIRGINIA VELAZQUEZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-05 04:27:22.290'
           ,30553
           ,'2012-06-05 04:27:22.290'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (418
           ,'YENI SEVILA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-05 04:29:42.657'
           ,30553
           ,'2012-06-05 04:29:42.657'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (419
           ,'DOROTHY GOLDIE INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-05 04:37:32.527'
           ,30553
           ,'2012-06-05 04:37:32.527'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (420
           ,'JAMES GOLDIE INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-05 04:39:26.573'
           ,30553
           ,'2012-06-05 04:39:26.573'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (421
           ,'NELIDA RODRIGUEZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-05 04:40:43.890'
           ,30553
           ,'2012-06-05 04:40:43.890'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (422
           ,'NELIDA RODRIGUEZ REFERRAL'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-05 04:41:24.840'
           ,30553
           ,'2012-06-05 04:41:24.840'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (423
           ,'CARLOS FELICIANO INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-05 04:44:09.817'
           ,30553
           ,'2012-06-05 04:44:09.817'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (424
           ,'CARLOS FELICIANO REF JUNIO'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-05 04:45:04.197'
           ,30553
           ,'2012-06-05 04:45:04.197'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (425
           ,'RAMONITA DELGADO INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-05 04:45:55.597'
           ,30553
           ,'2012-06-05 04:45:55.597'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (426
           ,'MARIA WARD INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-05 04:46:44.863'
           ,30553
           ,'2012-06-05 04:46:44.863'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (427
           ,'JOYCE COLE INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-05 04:47:32.950'
           ,30553
           ,'2012-06-05 04:47:32.950'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (428
           ,'DANIEL GONZALEZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-05 05:31:33.293'
           ,30553
           ,'2012-06-05 05:31:33.293'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (429
           ,'ERMELINDA MORENO GOMEZ INSURRANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-05 05:36:31.090'
           ,30553
           ,'2012-06-05 05:36:31.090'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (430
           ,'ERMELINDA MORENO REFERRAL JUNE '
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-05 05:36:55.440'
           ,30553
           ,'2012-06-05 05:36:55.440'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (431
           ,'ANTONIO RIOS INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-05 06:00:47.940'
           ,30553
           ,'2012-06-05 06:00:47.940'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (433
           ,'BARBARA ARNETT REFERRAL FOR JUNE '
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-05 06:03:02.937'
           ,30553
           ,'2012-06-05 06:03:02.937'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (434
           ,'KARL DIETRICH INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-05 06:20:03.613'
           ,30553
           ,'2012-06-05 06:20:03.613'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (435
           ,'KARL DIETRICH REF'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-05 06:20:18.513'
           ,30553
           ,'2012-06-05 06:20:18.513'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (436
           ,'BALLON INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-05 06:27:34.583'
           ,30553
           ,'2012-06-05 06:27:34.583'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (437
           ,'ARNETT INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-05 06:28:47.487'
           ,30553
           ,'2012-06-05 06:28:47.487'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (438
           ,'BARBARA SOCCIO INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-05 06:31:02.313'
           ,30553
           ,'2012-06-05 06:31:02.313'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (439
           ,'MARTA MARIUSSO INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-05 06:35:22.143'
           ,30553
           ,'2012-06-05 06:35:22.143'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (440
           ,'MARTHA FERNANDEZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-05 06:35:59.943'
           ,30553
           ,'2012-06-05 06:35:59.943'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (441
           ,'ROSA FONSECA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-05 09:00:27.587'
           ,30553
           ,'2012-06-05 09:00:27.587'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (442
           ,'QUILES INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-06 04:25:05.643'
           ,30553
           ,'2012-06-06 04:25:05.643'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (443
           ,'MARILYN VEGA REFERIDO JUNIO'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-06 04:27:41.687'
           ,30553
           ,'2012-06-06 04:27:41.687'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (444
           ,'GLOVER INS VER WITH ID'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-06 04:46:47.920'
           ,30553
           ,'2012-06-06 04:46:47.920'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (445
           ,'MARY JO MCCALLIE INSU'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-06 04:52:52.403'
           ,30553
           ,'2012-06-06 04:52:52.403'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (446
           ,'CASALLAS REF N INSURANCE  JUNE VISIT'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-06 05:15:04.100'
           ,30553
           ,'2012-06-06 05:15:04.100'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (447
           ,'MABEL REID INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-06 09:42:38.597'
           ,30553
           ,'2012-06-06 09:42:38.597'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (448
           ,'ZOILA CRUZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-06 09:44:00.683'
           ,30553
           ,'2012-06-06 09:44:00.683'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (449
           ,'ventura roche insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-06 09:45:55.350'
           ,30553
           ,'2012-06-06 09:45:55.350'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (450
           ,'YOLANDA GAMEZ REF INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-06 09:46:40.557'
           ,30553
           ,'2012-06-06 09:46:40.557'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (451
           ,'HEATHER ROTH INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-06 09:53:00.540'
           ,30553
           ,'2012-06-06 09:53:00.540'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (452
           ,'ROTH REFERIDO'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-06 09:53:39.100'
           ,30553
           ,'2012-06-06 09:53:39.100'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (453
           ,'louis diaz insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-06 09:55:03.737'
           ,30553
           ,'2012-06-06 09:55:03.737'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (454
           ,'kobie smith insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-06 09:58:59.800'
           ,30553
           ,'2012-06-06 09:58:59.800'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (455
           ,'kobie referral'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-06 09:59:18.827'
           ,30553
           ,'2012-06-06 09:59:18.827'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (456
           ,'olt insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-06 10:00:13.780'
           ,30553
           ,'2012-06-06 10:00:13.780'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (457
           ,'OLGA RODRIG INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-06 10:00:52.323'
           ,30553
           ,'2012-06-06 10:00:52.323'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (458
           ,'PRIM FAJARDO INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-06 10:02:09.083'
           ,30553
           ,'2012-06-06 10:02:09.083'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (460
           ,'MARIA OLAN REF FOR JUNE'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-06 10:06:04.800'
           ,30553
           ,'2012-06-06 10:06:04.800'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (461
           ,'DIANA RIOS ID'
           ,8
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-06 10:17:40.893'
           ,30553
           ,'2012-06-06 10:17:40.893'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (462
           ,'JOVITO TORRES INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-06 10:21:46.300'
           ,30553
           ,'2012-06-06 10:21:46.300'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (463
           ,'LUZ TORRES INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-06 10:23:24.633'
           ,30553
           ,'2012-06-06 10:23:24.633'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (464
           ,'JOSHUA ROJAS INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-06 10:24:27.810'
           ,30553
           ,'2012-06-06 10:24:27.810'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (465
           ,'AMPARO BLANCO INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-06 11:18:35.460'
           ,30553
           ,'2012-06-06 11:18:35.460'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (466
           ,'JOSE LUIS INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-06 11:19:29.527'
           ,30553
           ,'2012-06-06 11:19:29.527'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (467
           ,'INES MARTINEZ INSUR'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-06 11:36:24.790'
           ,30553
           ,'2012-06-06 11:36:24.790'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (468
           ,'JUAN GIRALDO INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-06 12:09:30.797'
           ,30553
           ,'2012-06-06 12:09:30.797'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (469
           ,'WORK COMP INFO'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-07 05:39:40.747'
           ,30553
           ,'2012-06-07 05:39:40.747'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (470
           ,'JAMIN INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-07 08:01:11.350'
           ,30553
           ,'2012-06-07 08:01:11.350'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (471
           ,'REFERRAL JUNE'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-07 08:01:55.203'
           ,30553
           ,'2012-06-07 08:01:55.203'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (472
           ,'RAMON AVILA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-07 08:03:07.180'
           ,30553
           ,'2012-06-07 08:03:07.180'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (473
           ,'COX INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-07 08:40:59.683'
           ,30553
           ,'2012-06-07 08:40:59.683'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (474
           ,'COX REFERRAL JUNE'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-07 08:41:11.860'
           ,30553
           ,'2012-06-07 08:41:11.860'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (475
           ,'NELLY GARCIA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-07 08:56:49.180'
           ,30553
           ,'2012-06-07 08:56:49.180'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (476
           ,'NELLY GARCIA REF JUNE'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-07 08:57:06.730'
           ,30553
           ,'2012-06-07 08:57:06.730'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (477
           ,'LUZ ROD INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-07 09:02:38.383'
           ,30553
           ,'2012-06-07 09:02:38.383'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (478
           ,'OLGA MOJICA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-07 09:03:22.053'
           ,30553
           ,'2012-06-07 09:03:22.053'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (479
           ,'GRISEL PIN INISURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-07 09:05:25.257'
           ,30553
           ,'2012-06-07 09:05:25.257'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (480
           ,'NICHOLE THOMAS INSURANCE REF'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-07 09:45:47.317'
           ,30553
           ,'2012-06-07 09:45:47.317'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (481
           ,'ROBIN GASTON AUTHORIZ'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-07 10:57:47.763'
           ,30553
           ,'2012-06-07 10:57:47.763'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (482
           ,'GLADYS MORA INSU REF'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-07 11:11:44.917'
           ,30553
           ,'2012-06-07 11:11:44.917'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (483
           ,'MARIA OROPESA SCRIPT FOR DIAZ'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-07 11:13:03.670'
           ,30553
           ,'2012-06-07 11:13:03.670'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (484
           ,'RENEE BOYD  REFERRAL'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-07 11:14:08.183'
           ,30553
           ,'2012-06-07 11:14:08.183'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (485
           ,'CLARA CARMENATY REFER'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-07 11:14:52.653'
           ,30553
           ,'2012-06-07 11:14:52.653'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (491
           ,'NOBLES MARIA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-07 12:34:54.760'
           ,30553
           ,'2012-06-07 12:34:54.760'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (492
           ,'EVERSOLE INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-08 04:48:31.790'
           ,30553
           ,'2012-06-08 04:48:31.790'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (493
           ,'HURST INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-08 05:17:26.410'
           ,30553
           ,'2012-06-08 05:17:26.410'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (494
           ,'JOSE GONZALEZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-08 05:21:45.537'
           ,30553
           ,'2012-06-08 05:21:45.537'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (495
           ,'WEST INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-08 05:22:49.877'
           ,30553
           ,'2012-06-08 05:22:49.877'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (496
           ,'MARIA C RIVERA REF'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-08 07:19:10.967'
           ,30553
           ,'2012-06-08 07:19:10.967'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (497
           ,'BERTHA BURNETT INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-08 08:24:28.230'
           ,30553
           ,'2012-06-08 08:24:28.230'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (498
           ,'CAROLYN WYNN'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-08 08:25:00.200'
           ,30553
           ,'2012-06-08 08:25:00.200'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (499
           ,'LEONIDEZ CORTES INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-08 08:26:08.880'
           ,30553
           ,'2012-06-08 08:26:08.880'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (500
           ,'LORNA OWENS INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-08 08:27:10.373'
           ,30553
           ,'2012-06-08 08:27:10.373'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (501
           ,'AWILDA DAVILA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-08 08:27:41.913'
           ,30553
           ,'2012-06-08 08:27:41.913'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (502
           ,'SEVERO MARTINEZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-08 08:29:00.430'
           ,30553
           ,'2012-06-08 08:29:00.430'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (503
           ,'ORLANDO MATIAS INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-08 08:34:23.950'
           ,30553
           ,'2012-06-08 08:34:23.950'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (504
           ,'NELLY STONE INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-08 09:51:23.280'
           ,30553
           ,'2012-06-08 09:51:23.280'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (505
           ,'BELCHER INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-08 09:58:17.000'
           ,30553
           ,'2012-06-08 09:58:17.000'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (506
           ,'WANDA HERNANDEZ REF JUNE'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-08 09:59:22.360'
           ,30553
           ,'2012-06-08 09:59:22.360'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (507
           ,'BETTY OWENS REF FOR JUNE '
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-08 10:08:01.413'
           ,30553
           ,'2012-06-08 10:08:01.413'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (508
           ,'NEIDA PEREZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-08 10:09:06.590'
           ,30553
           ,'2012-06-08 10:09:06.590'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (509
           ,'REGINALD HARRIS REF FOR MAY'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-08 10:12:44.713'
           ,30553
           ,'2012-06-08 10:12:44.713'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (510
           ,'MARIA I RIVERA REF JUNE'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-08 10:14:40.400'
           ,30553
           ,'2012-06-08 10:14:40.400'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (511
           ,'ERNESTO BORIS ROD INSURA'
           ,8
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-08 10:16:20.157'
           ,30553
           ,'2012-06-08 10:16:20.157'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (512
           ,'ROLANDO SORI AUTHORIZATION'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-08 10:17:38.217'
           ,30553
           ,'2012-06-08 10:17:38.217'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (513
           ,'BAUMAN VERIFI INSURANCE'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-08 10:19:14.473'
           ,30553
           ,'2012-06-08 10:19:14.473'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (514
           ,'JANICE DAYKE REFERRAL'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-08 10:32:48.237'
           ,30553
           ,'2012-06-08 10:32:48.237'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (515
           ,'FRANK ETHEL REF'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-08 10:36:55.893'
           ,30553
           ,'2012-06-08 10:36:55.893'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (516
           ,'DENIAL DIAZ'
           ,13
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-08 12:41:14.740'
           ,34037
           ,'2012-06-08 12:41:14.740'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (517
           ,'DENIAL JANER'
           ,13
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-08 12:44:05.207'
           ,34037
           ,'2012-06-08 12:44:05.207'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (518
           ,'PMT DIAZ'
           ,10
           ,2
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>SHARP MFP TWAIN K</AcquireSourceName><BitDepth>24</BitDepth><PageSize>3</PageSize><PixelType>2</PixelType><Resolution>150</Resolution><ScanningSide>1</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-08 13:32:02.677'
           ,34037
           ,'2012-07-12 07:38:39.470'
           ,30564
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (519
           ,'DENIAL DIAZ'
           ,13
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>24</BitDepth><PageSize>3</PageSize><PixelType>2</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-08 13:41:41.553'
           ,34037
           ,'2012-06-08 13:41:41.553'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (520
           ,'PMT JANER'
           ,10
           ,2
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>SHARP MFP TWAIN K</AcquireSourceName><BitDepth>24</BitDepth><PageSize>3</PageSize><PixelType>2</PixelType><Resolution>150</Resolution><ScanningSide>1</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-08 14:03:55.987'
           ,34037
           ,'2012-07-12 07:38:27.013'
           ,30564
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (521
           ,'LARRY SCHROEDER'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>24</BitDepth><PageSize>3</PageSize><PixelType>2</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-08 14:08:37.973'
           ,34037
           ,'2012-06-08 14:08:37.973'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (522
           ,'LARRY SCHROEDER'
           ,7
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>24</BitDepth><PageSize>3</PageSize><PixelType>2</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-08 14:11:26.480'
           ,34037
           ,'2012-06-08 14:11:26.480'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (523
           ,'LARRY SCHROEDER'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>24</BitDepth><PageSize>3</PageSize><PixelType>2</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-08 14:14:25.000'
           ,34037
           ,'2012-06-08 14:14:25.000'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (525
           ,'ELBA CRUZ'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-08 14:20:39.653'
           ,34037
           ,'2012-06-08 14:20:39.653'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (526
           ,'ELBA CRUZ'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-08 14:21:45.360'
           ,34037
           ,'2012-06-08 14:21:45.360'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (527
           ,'MELANIE STARKS'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-08 14:26:56.667'
           ,34037
           ,'2012-06-08 14:26:56.667'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (528
           ,'NEIL BZIBZIAK'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-08 14:28:12.800'
           ,34037
           ,'2012-06-08 14:28:12.800'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (529
           ,'CORY PERSON'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-08 14:29:48.567'
           ,34037
           ,'2012-06-08 14:29:48.567'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (530
           ,'IVAN RIVERA'
           ,26
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-08 14:31:30.110'
           ,34037
           ,'2012-06-08 14:31:30.110'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (531
           ,'IVAN RIVERA'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-08 14:32:15.973'
           ,34037
           ,'2012-06-08 14:32:15.973'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (532
           ,'BENIFITS AND ELIGIBILITY IVETTE HERNANDEZ'
           ,26
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-08 14:34:16.487'
           ,34037
           ,'2012-06-08 14:34:16.487'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (533
           ,'RAQUEL ROMAN'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-08 14:35:17.710'
           ,34037
           ,'2012-06-08 14:35:17.710'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (534
           ,'AND BENIFITS RAQUEL ROMAN'
           ,26
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-08 14:36:20.570'
           ,34037
           ,'2012-06-08 14:36:20.570'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (535
           ,'JAMES REID'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-08 14:37:08.367'
           ,34037
           ,'2012-06-08 14:37:08.367'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (536
           ,'AND BENIFITS JAMES REID'
           ,26
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-08 14:38:12.480'
           ,34037
           ,'2012-06-08 14:38:12.480'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (537
           ,'TIMOTHY OLSON'
           ,26
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-08 14:39:35.233'
           ,34037
           ,'2012-06-08 14:39:35.233'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (538
           ,'MIRNA DOBLES'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-08 14:40:56.380'
           ,34037
           ,'2012-06-08 14:40:56.380'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (539
           ,'AND BENIFITS MIRNA DOBLES'
           ,26
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-08 14:42:05.877'
           ,34037
           ,'2012-06-08 14:42:05.877'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (540
           ,'KIRENIA PENA'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-08 14:47:34.080'
           ,34037
           ,'2012-06-08 14:47:34.080'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (541
           ,'ANGELINA SMITH'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-08 14:49:01.350'
           ,34037
           ,'2012-06-08 14:49:01.350'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (542
           ,'AND ID LORENZO GARCIA'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-08 14:51:07.260'
           ,34037
           ,'2012-06-08 14:51:07.260'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (543
           ,'LORENZO GARCIA'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-08 14:52:16.430'
           ,34037
           ,'2012-06-08 14:52:16.430'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (544
           ,'MELBA HENDERSON'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-08 14:53:59.207'
           ,34037
           ,'2012-06-08 14:53:59.207'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (545
           ,'JUAN RIVERA'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-08 14:56:51.340'
           ,34037
           ,'2012-06-08 14:56:51.340'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (546
           ,'AND BENEFITS DIEGO OSSA'
           ,26
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-08 14:59:34.193'
           ,34037
           ,'2012-06-08 14:59:34.193'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (547
           ,'DIEGO OSSA'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-08 15:00:18.703'
           ,34037
           ,'2012-06-08 15:00:18.703'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (548
           ,'CARRIE BOWYER'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-08 15:03:23.200'
           ,34037
           ,'2012-06-08 15:03:23.200'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (549
           ,'DONALD JOINER INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-11 06:19:54.503'
           ,30553
           ,'2012-06-11 06:19:54.503'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (550
           ,'EVELYN GRAY INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-11 06:41:22.933'
           ,30553
           ,'2012-06-11 06:41:22.933'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (551
           ,'wanda colon ref n insurance'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-11 06:57:18.803'
           ,30553
           ,'2012-06-11 06:57:18.803'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (552
           ,'JOINER REF FOR JUNE '
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-12 05:16:17.980'
           ,30553
           ,'2012-06-12 05:16:17.980'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (553
           ,'VIRGINIA TORRES INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-12 05:17:17.853'
           ,30553
           ,'2012-06-12 05:17:17.853'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (554
           ,'MAYRA ROQUE INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-12 05:19:41.073'
           ,30553
           ,'2012-06-12 05:19:41.073'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (555
           ,'ORELSO MARTINEZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-12 05:21:27.080'
           ,30553
           ,'2012-06-12 05:21:27.080'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (556
           ,'ROSA MECKES INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-12 05:21:55.253'
           ,30553
           ,'2012-06-12 05:21:55.253'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (557
           ,'vanessa mccray insurance ref'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-12 05:22:53.110'
           ,30553
           ,'2012-06-12 05:22:53.110'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (558
           ,'PASTORA RIOS INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-12 05:42:40.570'
           ,30553
           ,'2012-06-12 05:42:40.570'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (559
           ,'MARIA MARIORANA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-12 07:01:12.060'
           ,30553
           ,'2012-06-12 07:01:12.060'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (560
           ,'SHIRLEY GIRALDO REF'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-12 07:08:02.860'
           ,30553
           ,'2012-06-12 07:08:02.860'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (561
           ,'SAMUEL CORTES INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-12 07:22:00.893'
           ,30553
           ,'2012-06-12 07:22:00.893'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (562
           ,'MARLENE HATCHER SCRIPT'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-12 07:24:34.773'
           ,30553
           ,'2012-06-12 07:24:34.773'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (563
           ,'ROBERT ABREU INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-12 07:47:04.070'
           ,30553
           ,'2012-06-12 07:47:04.070'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (564
           ,'LESBIA PAZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-12 08:02:45.307'
           ,30553
           ,'2012-06-12 08:02:45.307'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (565
           ,'BERRY INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-12 10:56:43.253'
           ,30553
           ,'2012-06-12 10:56:43.253'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (566
           ,'CHARLENE BED INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-12 10:57:53.310'
           ,30553
           ,'2012-06-12 10:57:53.310'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (567
           ,'ORNER INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-12 11:01:45.870'
           ,30553
           ,'2012-06-12 11:01:45.870'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (568
           ,'MARIA DE MORA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-12 11:02:43.977'
           ,30553
           ,'2012-06-12 11:02:43.977'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (569
           ,'GEORGE MENDOZA REF INSURANCE'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-12 11:24:08.993'
           ,30553
           ,'2012-06-12 11:24:08.993'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (570
           ,'CATHERINE SMITH REF INSURANC '
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-12 11:30:25.030'
           ,30553
           ,'2012-06-12 11:30:25.030'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (571
           ,'SUE ETTA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-12 11:32:21.460'
           ,30553
           ,'2012-06-12 11:32:21.460'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (572
           ,'PATROCINIA MACHADO INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-12 11:38:20.493'
           ,30553
           ,'2012-06-12 11:38:20.493'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (573
           ,'suncoast electronic submission'
           ,3
           ,2
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>SHARP MFP TWAIN K</AcquireSourceName><BitDepth>24</BitDepth><PageSize>3</PageSize><PixelType>2</PixelType><Resolution>150</Resolution><ScanningSide>1</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-12 14:28:43.413'
           ,29513
           ,'2012-06-20 09:12:02.390'
           ,30564
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (574
           ,'ESTHER MAPHELEBA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-13 05:54:46.543'
           ,30553
           ,'2012-06-13 05:54:46.543'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (575
           ,'RAMSEY INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-13 05:58:21.670'
           ,30553
           ,'2012-06-13 05:58:21.670'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (576
           ,'PEBBY BARBOUR INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-13 05:59:17.973'
           ,30553
           ,'2012-06-13 05:59:17.973'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (577
           ,'MANUEL MENA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-13 06:02:47.007'
           ,30553
           ,'2012-06-13 06:02:47.007'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (578
           ,'BURKET INSURANCE REFERRAL JUNE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-13 06:03:59.503'
           ,30553
           ,'2012-06-13 06:03:59.503'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (579
           ,'ANGELA ORTIZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-13 07:12:51.917'
           ,30553
           ,'2012-06-13 07:12:51.917'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (580
           ,'RAM INSURANCE REF DIAZ'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-13 07:20:16.007'
           ,30553
           ,'2012-06-13 07:20:16.007'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (581
           ,'VISISTHY REF JANER JUNE'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-13 07:25:04.320'
           ,30553
           ,'2012-06-13 07:25:04.320'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (582
           ,'PINA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-13 07:34:03.123'
           ,30553
           ,'2012-06-13 07:34:03.123'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (583
           ,'PINA REF JUNE'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-13 07:34:24.900'
           ,30553
           ,'2012-06-13 07:34:24.900'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (584
           ,'CLARA LORA INSURANCE/  AUTH '
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-13 07:35:30.077'
           ,30553
           ,'2012-06-13 07:35:30.077'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (585
           ,'ORNER INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-13 07:56:55.017'
           ,30553
           ,'2012-06-13 07:56:55.017'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (586
           ,'HERTA GOLDM INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-13 08:47:42.060'
           ,30553
           ,'2012-06-13 08:47:42.060'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (587
           ,'DORA MELENDEZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-13 08:51:43.190'
           ,30553
           ,'2012-06-13 08:51:43.190'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (588
           ,'LESBIA PAZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-13 08:52:28.460'
           ,30553
           ,'2012-06-13 08:52:28.460'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (589
           ,'emma lopez insurance card'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-13 09:39:05.460'
           ,30553
           ,'2012-06-13 09:39:05.460'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (590
           ,'ZATESHA JORDAN  INSURANCE REF'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-13 10:14:31.857'
           ,30553
           ,'2012-06-13 10:14:31.857'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (591
           ,'MAXINO PEREZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-13 10:42:14.890'
           ,30553
           ,'2012-06-13 10:42:14.890'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (592
           ,'MAXIMO PEREZ REFERRAL'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-13 10:42:33.507'
           ,30553
           ,'2012-06-13 10:42:33.507'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (593
           ,'MARSHA KELLY INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-13 11:03:22.080'
           ,30553
           ,'2012-06-13 11:03:22.080'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (594
           ,'PATTERSON INSURANCE REF'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-13 11:20:11.313'
           ,30553
           ,'2012-06-13 11:20:11.313'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (595
           ,'MARIA CONCEPCION INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-14 04:51:56.303'
           ,30553
           ,'2012-06-14 04:51:56.303'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (596
           ,'donald partridge insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-14 04:53:12.737'
           ,30553
           ,'2012-06-14 04:53:12.737'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (597
           ,'DAVANZO MERCEDES REF for june '
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-14 04:55:17.620'
           ,30553
           ,'2012-06-14 04:55:17.620'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (598
           ,'MARITZA DIAZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-14 04:57:25.113'
           ,30553
           ,'2012-06-14 04:57:25.113'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (599
           ,'MARIA MENDEZ REF'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-14 05:03:15.877'
           ,30553
           ,'2012-06-14 05:03:15.877'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (600
           ,'rose baron insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-14 05:04:49.980'
           ,30553
           ,'2012-06-14 05:04:49.980'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (601
           ,'VIVIAN ALVAREZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-14 05:07:43.230'
           ,30553
           ,'2012-06-14 05:07:43.230'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (602
           ,'ALICIA CLARO VERIFICATION IN'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-14 05:09:35.180'
           ,30553
           ,'2012-06-14 05:09:35.180'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (603
           ,'ALICIA MARTINES REF FOR JUNE'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-14 05:11:44.263'
           ,30553
           ,'2012-06-14 05:11:44.263'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (604
           ,'JOSE RIVERA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-14 05:46:30.260'
           ,30553
           ,'2012-06-14 05:46:30.260'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (605
           ,'NORTON INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-14 06:57:16.880'
           ,30553
           ,'2012-06-14 06:57:16.880'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (606
           ,'SUSAN ROJAS INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-14 06:59:04.547'
           ,30553
           ,'2012-06-14 06:59:04.547'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (607
           ,'SARAH MARTIN REFERRAL'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-14 06:59:56.737'
           ,30553
           ,'2012-06-14 06:59:56.737'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (608
           ,'CARLOS VARGAS REFERIDO JUNE '
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-14 07:01:05.190'
           ,30553
           ,'2012-06-14 07:01:05.190'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (609
           ,'RISHARD TEISHER REFERAL'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-14 07:56:06.070'
           ,30553
           ,'2012-06-14 07:56:06.070'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (610
           ,'MYRRA BETHEL REF JUNE'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-14 07:57:09.097'
           ,30553
           ,'2012-06-14 07:57:09.097'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (611
           ,'GAIL HENDERSON REF'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-14 07:57:55.133'
           ,30553
           ,'2012-06-14 07:57:55.133'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (612
           ,'IRMA LOPEZ REF'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-14 07:59:43.003'
           ,30553
           ,'2012-06-14 07:59:43.003'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (613
           ,'Fax - 06/14/2012 09:22'
           ,1
           ,1
           ,NULL
           ,NULL
           ,NULL
           ,1
           ,'2012-06-14 09:23:01.630'
           ,1526
           ,'2012-06-14 09:23:01.630'
           ,1526
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (614
           ,'JANETT BELLIS INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-14 10:31:11.393'
           ,30553
           ,'2012-06-14 10:31:11.393'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (615
           ,'TAMA LORENZO REF INSURANCE'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-14 10:32:16.667'
           ,30553
           ,'2012-06-14 10:32:16.667'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (616
           ,'MANUEL PEREZ INSURANCE REFERRAL'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-14 12:41:47.800'
           ,30553
           ,'2012-06-14 12:41:47.800'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (617
           ,'VINA REFERRAL FOR JUNE '
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-14 12:43:05.563'
           ,30553
           ,'2012-06-14 12:43:05.563'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (618
           ,'SERGIO CABRALES INSURANCE REFRRAL'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-14 12:43:46.160'
           ,30553
           ,'2012-06-14 12:43:46.160'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (619
           ,'EVELYN VAZQUEZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-14 12:44:25.613'
           ,30553
           ,'2012-06-14 12:44:25.613'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (620
           ,'KAROLE MINGARELLI INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-14 12:46:01.497'
           ,30553
           ,'2012-06-14 12:46:01.497'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (621
           ,'GERALD COWLES INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-14 12:46:37.947'
           ,30553
           ,'2012-06-14 12:46:37.947'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (622
           ,'ANNITA SIMMONS INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-14 12:47:11.043'
           ,30553
           ,'2012-06-14 12:47:11.043'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (623
           ,'CARMEN RAMOS REF'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-14 12:47:50.607'
           ,30553
           ,'2012-06-14 12:47:50.607'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (624
           ,'HAMILTON LINDSEY REF JUNE'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-15 08:16:51.690'
           ,30553
           ,'2012-06-15 08:16:51.690'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (625
           ,'ANA GOMEZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-15 08:17:24.460'
           ,30553
           ,'2012-06-15 08:17:24.460'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (626
           ,'PMT JANER '
           ,10
           ,2
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>SHARP MFP TWAIN K</AcquireSourceName><BitDepth>24</BitDepth><PageSize>3</PageSize><PixelType>2</PixelType><Resolution>150</Resolution><ScanningSide>1</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-15 09:32:34.257'
           ,34037
           ,'2012-07-12 07:38:13.413'
           ,30564
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (627
           ,'PMT DIAZ'
           ,10
           ,2
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>SHARP MFP TWAIN K</AcquireSourceName><BitDepth>24</BitDepth><PageSize>3</PageSize><PixelType>2</PixelType><Resolution>150</Resolution><ScanningSide>1</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-15 10:24:31.767'
           ,34037
           ,'2012-07-12 07:37:57.360'
           ,30564
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (628
           ,'YAILEEN GONZALEZ AUTHORIZATION N INSURANCE'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-15 10:37:20.833'
           ,30553
           ,'2012-06-15 10:37:20.833'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (629
           ,'JUANA HERNANDEZ INSURANC'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-15 10:38:00.130'
           ,30553
           ,'2012-06-15 10:38:00.130'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (630
           ,'ANA ESQUILIN INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-15 10:39:32.363'
           ,30553
           ,'2012-06-15 10:39:32.363'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (631
           ,'MAIDA RUIS REF INSURANCE'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-15 10:46:05.663'
           ,30553
           ,'2012-06-15 10:46:05.663'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (632
           ,'ALICIA CANO COPY INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-15 10:46:48.313'
           ,30553
           ,'2012-06-15 10:46:48.313'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (633
           ,'MARTIN INSURANCE N AUTHO'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-15 10:58:49.900'
           ,30553
           ,'2012-06-15 10:58:49.900'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (634
           ,'THOMAS JOHNSON INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-15 11:03:11.923'
           ,30553
           ,'2012-06-15 11:03:11.923'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (635
           ,'AIDA GARCIA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-15 11:05:07.930'
           ,30553
           ,'2012-06-15 11:05:07.930'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (636
           ,'DIANA PAES LLERA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-15 11:08:01.697'
           ,30553
           ,'2012-06-15 11:08:01.697'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (637
           ,'PMT JANER'
           ,10
           ,2
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>SHARP MFP TWAIN K</AcquireSourceName><BitDepth>24</BitDepth><PageSize>3</PageSize><PixelType>2</PixelType><Resolution>150</Resolution><ScanningSide>1</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-15 11:12:33.257'
           ,34037
           ,'2012-07-12 07:37:45.920'
           ,30564
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (638
           ,'VESTA  WEERS INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-15 11:16:41.493'
           ,30553
           ,'2012-06-15 11:16:41.493'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (640
           ,'ELINA PAULOS INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-15 11:26:38.767'
           ,30553
           ,'2012-06-15 11:26:38.767'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (641
           ,'GUILLERMO LIMA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-15 11:31:02.663'
           ,30553
           ,'2012-06-15 11:31:02.663'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (642
           ,'CARMEN FONSECA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-15 11:31:52.243'
           ,30553
           ,'2012-06-15 11:31:52.243'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (646
           ,'RHONDA JACKSON INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-15 11:36:45.643'
           ,30553
           ,'2012-06-15 11:36:45.643'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (647
           ,'LORENZO MCDUFFIE  INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-15 11:41:43.810'
           ,30553
           ,'2012-06-15 11:41:43.810'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (648
           ,'ESTHER MOYA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-15 11:43:50.113'
           ,30553
           ,'2012-06-15 11:43:50.113'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (649
           ,'SARA MARTIN INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-15 11:51:43.010'
           ,30553
           ,'2012-06-15 11:51:43.010'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (650
           ,'CLIFFORD DENISON INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-15 12:15:15.830'
           ,30553
           ,'2012-06-15 12:15:15.830'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (651
           ,'ENEIDA HERNANDEZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-15 12:16:10.667'
           ,30553
           ,'2012-06-15 12:16:10.667'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (652
           ,'SEMIDEY INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-15 12:17:11.903'
           ,30553
           ,'2012-06-15 12:17:11.903'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (653
           ,'CARIDAD DIAZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-15 12:18:16.780'
           ,30553
           ,'2012-06-15 12:18:16.780'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (654
           ,'AIDA DELCID INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-15 12:19:04.517'
           ,30553
           ,'2012-06-15 12:19:04.517'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (655
           ,'SHERYL SANTOYO INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-15 12:20:30.077'
           ,30553
           ,'2012-06-15 12:20:30.077'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (656
           ,'MARTA FITZGERALS INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-15 12:21:22.747'
           ,30553
           ,'2012-06-15 12:21:22.747'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (657
           ,'DESIRAE BRUTON INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-15 12:22:01.727'
           ,30553
           ,'2012-06-15 12:22:01.727'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (658
           ,'EPIFANIA MONTANEZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-15 12:22:50.160'
           ,30553
           ,'2012-06-15 12:22:50.160'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (659
           ,'REID INSURANCE CARD'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-15 12:24:10.960'
           ,30553
           ,'2012-06-15 12:24:10.960'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (660
           ,'NELSY GOMEZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-15 12:25:27.627'
           ,30553
           ,'2012-06-15 12:25:27.627'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (661
           ,'IDOLANDA CABRERA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-15 12:28:33.740'
           ,30553
           ,'2012-06-15 12:28:33.740'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (662
           ,'LINDA AUSBORNE INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-15 12:29:10.107'
           ,30553
           ,'2012-06-15 12:29:10.107'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (663
           ,'DANIEL SANTANA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-15 12:30:10.147'
           ,30553
           ,'2012-06-15 12:30:10.147'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (664
           ,'GLADYS DAVILA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-15 12:31:52.223'
           ,30553
           ,'2012-06-15 12:31:52.223'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (665
           ,'MACIA CANDELARIO INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-15 12:32:28.400'
           ,30553
           ,'2012-06-15 12:32:28.400'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (667
           ,'MINERVA ROSARIO INSURANCE  AUTHOR'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-18 05:59:50.950'
           ,30553
           ,'2012-06-18 05:59:50.950'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (668
           ,'ANA DELGADO INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-18 06:33:51.100'
           ,30553
           ,'2012-06-18 06:33:51.100'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (669
           ,'CARNEY INSURANCE REF'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-18 07:08:48.450'
           ,30553
           ,'2012-06-18 07:08:48.450'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (671
           ,'Fax - 06/18/2012 09:23'
           ,1
           ,1
           ,NULL
           ,NULL
           ,NULL
           ,1
           ,'2012-06-18 09:23:58.323'
           ,1526
           ,'2012-06-18 09:23:58.323'
           ,1526
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (672
           ,'CHRISTINE BROWN INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-18 11:13:59.327'
           ,30553
           ,'2012-06-18 11:13:59.327'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (673
           ,'borrego insurance referido'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-18 11:15:07.260'
           ,30553
           ,'2012-06-18 11:15:07.260'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (674
           ,'MARIA SANTANA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-18 11:16:29.993'
           ,30553
           ,'2012-06-18 11:16:29.993'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (675
           ,'MIGDALIA RENTAS INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-18 11:17:34.410'
           ,30553
           ,'2012-06-18 11:17:34.410'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (676
           ,'CESAR ASTUDILLO INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-18 11:18:46.233'
           ,30553
           ,'2012-06-18 11:18:46.233'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (677
           ,'MERCEDES CANCEL INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-18 12:09:28.663'
           ,30553
           ,'2012-06-18 12:09:28.663'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (678
           ,'KATHERINE GARCIA INSURANCE REFERRAL'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-18 12:09:57.830'
           ,30553
           ,'2012-06-18 12:09:57.830'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (679
           ,'MIRTA MESA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-18 13:45:58.110'
           ,30553
           ,'2012-06-18 13:45:58.110'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (680
           ,'SARA FUENTES INSURANCE REFERRAL'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-18 13:46:41.817'
           ,30553
           ,'2012-06-18 13:46:41.817'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (681
           ,'esther gonzalez insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-19 05:53:41.417'
           ,30553
           ,'2012-06-19 05:53:41.417'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (682
           ,'ESTHER GONZALEZ REFERIDO JUNE'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-19 05:54:01.247'
           ,30553
           ,'2012-06-19 05:54:01.247'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (683
           ,'RENE DIAZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-19 06:28:34.980'
           ,30553
           ,'2012-06-19 06:28:34.980'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (684
           ,'SHIRLEY THOMAS REF INSUR'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-19 06:30:06.750'
           ,30553
           ,'2012-06-19 06:30:06.750'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (685
           ,'NOEMI GARCIA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-19 07:38:08.727'
           ,30553
           ,'2012-06-19 07:38:08.727'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (686
           ,'BENEDICTO DE JESUS INSURNANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-19 08:15:07.897'
           ,30553
           ,'2012-06-19 08:15:07.897'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (687
           ,'RAIMUNDO LEAL INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-19 10:46:07.560'
           ,30553
           ,'2012-06-19 10:46:07.560'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (688
           ,'ZENAIDA GONZALEZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-19 10:48:09.547'
           ,30553
           ,'2012-06-19 10:48:09.547'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (689
           ,'CAROLYN TRIPP INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-19 10:52:44.713'
           ,30553
           ,'2012-06-19 10:52:44.713'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (690
           ,'MARY PRESNELL INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-19 11:13:28.923'
           ,30553
           ,'2012-06-19 11:13:28.923'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (691
           ,'LANDAVERDE REF'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-19 11:16:45.000'
           ,30553
           ,'2012-06-19 11:16:45.000'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (692
           ,'JULIAN VALDEZ INSURANCE'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-20 05:23:34.210'
           ,30553
           ,'2012-06-20 05:23:34.210'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (693
           ,'NOGUERAS INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-20 08:19:47.370'
           ,30553
           ,'2012-06-20 08:19:47.370'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (694
           ,'LEONEL TELLADO INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-20 08:20:30.397'
           ,30553
           ,'2012-06-20 08:20:30.397'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (695
           ,'WILLIAM GUERRA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-20 08:21:16.747'
           ,30553
           ,'2012-06-20 08:21:16.747'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (696
           ,'VIVIANI INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-20 08:22:00.030'
           ,30553
           ,'2012-06-20 08:22:00.030'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (697
           ,'JUAN SOTO INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-20 08:22:40.880'
           ,30553
           ,'2012-06-20 08:22:40.880'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (698
           ,'JULIA HAND INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-20 08:25:15.620'
           ,30553
           ,'2012-06-20 08:25:15.620'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (699
           ,'MABLE MILNE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-20 08:25:56.160'
           ,30553
           ,'2012-06-20 08:25:56.160'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (700
           ,'HURLESS INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-20 08:27:07.777'
           ,30553
           ,'2012-06-20 08:27:07.777'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (701
           ,'Fax - 06/20/2012 09:26'
           ,1
           ,1
           ,NULL
           ,NULL
           ,NULL
           ,1
           ,'2012-06-20 09:26:30.650'
           ,1526
           ,'2012-06-20 09:26:30.650'
           ,1526
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (702
           ,'ARLEEN DOHNET INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-20 11:28:25.720'
           ,30553
           ,'2012-06-20 11:28:25.720'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (703
           ,'BLANCA ACOSTA REF DIAZ'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-20 11:29:09.657'
           ,30553
           ,'2012-06-20 11:29:09.657'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (704
           ,'BLANCA REF REF JANER'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-20 11:29:29.300'
           ,30553
           ,'2012-06-20 11:29:29.300'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (705
           ,'erma gomez insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-20 11:34:24.423'
           ,30553
           ,'2012-06-20 11:34:24.423'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (706
           ,'AFIFA REFERRAL FOR JUNE'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-20 11:39:48.157'
           ,30553
           ,'2012-06-20 11:39:48.157'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (707
           ,'CARLOS MENENDEZ ID'
           ,8
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-20 13:07:45.843'
           ,30553
           ,'2012-06-20 13:07:45.843'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (708
           ,'WYLENE WEASHINGTON REF JUNE'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-21 05:36:58.097'
           ,30553
           ,'2012-06-21 05:36:58.097'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (709
           ,'MARIA CRISTINA ALVAREZ  ID'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-21 06:04:05.743'
           ,30553
           ,'2012-06-21 06:04:05.743'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (710
           ,'ECKSTEIN  ESTHER REF JUNE DATE '
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-21 06:31:22.483'
           ,30553
           ,'2012-06-21 06:31:22.483'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (711
           ,'OLGA RAMOS INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-21 07:36:52.860'
           ,30553
           ,'2012-06-21 07:36:52.860'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (712
           ,'AMERICA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-21 07:47:46.877'
           ,30553
           ,'2012-06-21 07:47:46.877'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (713
           ,'ROSA RUBERTE INSURANCE REF'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-21 07:48:29.087'
           ,30553
           ,'2012-06-21 07:48:29.087'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (714
           ,'HELIODORO MARTINEZ REF'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-21 07:56:46.943'
           ,30553
           ,'2012-06-21 07:56:46.943'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (715
           ,'rosa ruperte insurance referral'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-21 08:22:36.910'
           ,30553
           ,'2012-06-21 08:22:36.910'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (716
           ,'lucila negron insurance referral'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-21 08:38:36.187'
           ,30553
           ,'2012-06-21 08:38:36.187'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (717
           ,'ESTHER HARRIS INSURANCE REFERRAL'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-21 08:40:10.077'
           ,30553
           ,'2012-06-21 08:40:10.077'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (718
           ,'SIMA JUANA INSURANCE REFERRAL'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-21 08:41:13.373'
           ,30553
           ,'2012-06-21 08:41:13.373'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (719
           ,'MARISOL DOMINGUEZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-21 08:48:49.787'
           ,30553
           ,'2012-06-21 08:48:49.787'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (720
           ,'ANA VARGAS ID'
           ,8
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-21 08:49:43.033'
           ,30553
           ,'2012-06-21 08:49:43.033'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (721
           ,'ELSA LOZADA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-21 08:52:23.210'
           ,30553
           ,'2012-06-21 08:52:23.210'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (722
           ,'DORREN MILLER INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-21 10:30:10.707'
           ,30553
           ,'2012-06-21 10:30:10.707'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (723
           ,'EUNICE YOUNG INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-21 10:31:30.613'
           ,30553
           ,'2012-06-21 10:31:30.613'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (724
           ,'SARA ANDREW  REF'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-21 10:47:45.640'
           ,30553
           ,'2012-06-21 10:47:45.640'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (725
           ,'GLADYS HERNANDEZ REFERRAL'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-21 10:48:24.233'
           ,30553
           ,'2012-06-21 10:48:24.233'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (726
           ,'MARIA PEREZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-21 11:47:38.123'
           ,30553
           ,'2012-06-21 11:47:38.123'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (727
           ,'MARIE TORRES INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-21 11:49:02.267'
           ,30553
           ,'2012-06-21 11:49:02.267'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (728
           ,'MARIA ALONSO INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-21 11:50:18.700'
           ,30553
           ,'2012-06-21 11:50:18.700'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (729
           ,'MARIA ALONSO REFERAL'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-21 11:50:38.027'
           ,30553
           ,'2012-06-21 11:50:38.027'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (730
           ,'SOCORRO BAUTISTA REF JUNE'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-21 11:53:03.840'
           ,30553
           ,'2012-06-21 11:53:03.840'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (731
           ,'LINDY JOHNSON INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-21 11:56:53.370'
           ,30553
           ,'2012-06-21 11:56:53.370'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (732
           ,'HANNEN PANO INSURANCE REFERRAL'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-21 12:08:20.933'
           ,30553
           ,'2012-06-21 12:08:20.933'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (733
           ,'LAZARA BREU INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-21 12:18:52.800'
           ,30553
           ,'2012-06-21 12:18:52.800'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (734
           ,'PABLO DIAZ VALDES INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-21 12:19:43.227'
           ,30553
           ,'2012-06-21 12:19:43.227'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (735
           ,'PARIS HILL INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-22 07:03:49.457'
           ,30553
           ,'2012-06-22 07:03:49.457'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (736
           ,'LISA OLDING INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-22 07:05:04.270'
           ,30553
           ,'2012-06-22 07:05:04.270'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (737
           ,'KENIA VIDAL INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-22 07:06:44.693'
           ,30553
           ,'2012-06-22 07:06:44.693'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (738
           ,'NILDA DEL CUADRO INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-22 07:07:53.567'
           ,30553
           ,'2012-06-22 07:07:53.567'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (739
           ,'Crispina Coram insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-22 07:08:27.233'
           ,30553
           ,'2012-06-22 07:08:27.233'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (740
           ,'MOISES PEREZ ID'
           ,8
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-22 07:09:24.600'
           ,30553
           ,'2012-06-22 07:09:24.600'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (741
           ,'CARMEN GONZALEZ REF INSURANCE'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-22 07:09:59.580'
           ,30553
           ,'2012-06-22 07:09:59.580'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (742
           ,'REBECA BRITO HERNDEZ REF INSUR'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-22 07:10:41.090'
           ,30553
           ,'2012-06-22 07:10:41.090'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (743
           ,'LOURDES VIEL REF INSURANCE'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-22 07:34:20.497'
           ,30553
           ,'2012-06-22 07:34:20.497'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (744
           ,'christine riley referral'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-22 12:45:18.777'
           ,30553
           ,'2012-06-22 12:45:18.777'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (745
           ,'JAIME ZAMORA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-22 12:46:09.850'
           ,30553
           ,'2012-06-22 12:46:09.850'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (746
           ,'ALFREDO LOZADA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-22 12:51:02.267'
           ,30553
           ,'2012-06-22 12:51:02.267'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (747
           ,'walker referrrla june'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-22 12:51:29.227'
           ,30553
           ,'2012-06-22 12:51:29.227'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (748
           ,'JAMES VANDERLOOP INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-25 05:31:53.570'
           ,30553
           ,'2012-06-25 05:31:53.570'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (749
           ,'HALEY REF INSURANCE'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-25 05:47:31.553'
           ,30553
           ,'2012-06-25 05:47:31.553'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (750
           ,'ESTRELLA INSURANCE'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-25 06:12:38.430'
           ,30553
           ,'2012-06-25 06:12:38.430'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (751
           ,'YERA INSURANCE CARD'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-25 07:19:42.827'
           ,30553
           ,'2012-06-25 07:19:42.827'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (752
           ,'JUANA FLORES INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-25 07:21:00.130'
           ,30553
           ,'2012-06-25 07:21:00.130'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (753
           ,'JUANA FLORES NEW REF'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-25 07:21:19.547'
           ,30553
           ,'2012-06-25 07:21:19.547'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (754
           ,'CALAFELL INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-25 07:24:22.103'
           ,30553
           ,'2012-06-25 07:24:22.103'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (755
           ,'JUANITA MOORE INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-25 07:26:45.220'
           ,30553
           ,'2012-06-25 07:26:45.220'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (756
           ,'IRAIDA QUINTANA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-25 07:28:14.297'
           ,30553
           ,'2012-06-25 07:28:14.297'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (757
           ,'JANICE POINDEXTER'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-25 07:29:05.547'
           ,30553
           ,'2012-06-25 07:29:05.547'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (758
           ,'HOUCK INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-25 07:32:04.513'
           ,30553
           ,'2012-06-25 07:32:04.513'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (759
           ,'IDA ALMAGUER INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-25 07:33:01.823'
           ,30553
           ,'2012-06-25 07:33:01.823'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (761
           ,'MICHELLE BRULL INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-25 07:36:40.690'
           ,30553
           ,'2012-06-25 07:36:40.690'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (762
           ,'KATIE HUTCHINSON REF'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-25 08:32:53.430'
           ,30553
           ,'2012-06-25 08:32:53.430'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (764
           ,'BETTY SHAFFER REFERRAL'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-25 08:34:22.943'
           ,30553
           ,'2012-06-25 08:34:22.943'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (765
           ,'BETTIE SHAFFER INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-25 08:34:46.707'
           ,30553
           ,'2012-06-25 08:34:46.707'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (766
           ,'VICTORIA TURPIN INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-25 08:36:21.920'
           ,30553
           ,'2012-06-25 08:36:21.920'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (767
           ,'ORFELINA FERNANDEZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-25 08:40:12.060'
           ,30553
           ,'2012-06-25 08:40:12.060'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (768
           ,'AMANDA HALL NEW INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-25 08:41:55.190'
           ,30553
           ,'2012-06-25 08:41:55.190'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (769
           ,'MARGARET CARDON INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-25 08:44:39.660'
           ,30553
           ,'2012-06-25 08:44:39.660'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (770
           ,'LUZ NEGRON  INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-25 08:45:36.030'
           ,30553
           ,'2012-06-25 08:45:36.030'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (771
           ,'PMT JANER'
           ,10
           ,2
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-25 09:33:10.590'
           ,47692
           ,'2012-07-12 07:37:25.623'
           ,30564
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (772
           ,'OTC- JUNE - JANER'
           ,10
           ,2
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-25 09:36:20.280'
           ,47692
           ,'2012-07-12 07:37:10.260'
           ,30564
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (773
           ,'PMT DIAZ'
           ,10
           ,2
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-25 10:06:58.640'
           ,47692
           ,'2012-07-12 07:33:57.957'
           ,30564
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (774
           ,'test scan'
           ,20
           ,2
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>SHARP MFP TWAIN K</AcquireSourceName><BitDepth>24</BitDepth><PageSize>3</PageSize><PixelType>2</PixelType><Resolution>150</Resolution><ScanningSide>1</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-25 15:51:50.800'
           ,29513
           ,'2012-07-12 07:28:36.603'
           ,30564
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (775
           ,'JENNY ROSADO REFERRAL JUNE DATE '
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-26 04:52:12.677'
           ,30553
           ,'2012-06-26 04:52:12.677'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (776
           ,'ZAIDA RODRIG INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-26 04:58:01.850'
           ,30553
           ,'2012-06-26 04:58:01.850'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (777
           ,'THERESA WOODS INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-26 05:01:39.810'
           ,30553
           ,'2012-06-26 05:01:39.810'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (778
           ,'OSARIO BOUCOURT REFERRAL'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-26 05:02:38.263'
           ,30553
           ,'2012-06-26 05:02:38.263'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (779
           ,'MARY ROESER INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-26 05:04:01.970'
           ,30553
           ,'2012-06-26 05:04:01.970'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (780
           ,'AMPARO SUAREZ REF'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-26 05:05:20.843'
           ,30553
           ,'2012-06-26 05:05:20.843'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (781
           ,'MARIA M LOPEZ'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-26 05:11:30.200'
           ,30553
           ,'2012-06-26 05:11:30.200'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (782
           ,'ALICIA MARTINEZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-26 05:51:17.853'
           ,30553
           ,'2012-06-26 05:51:17.853'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (783
           ,'BORGES INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-26 06:16:03.020'
           ,30553
           ,'2012-06-26 06:16:03.020'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (784
           ,'NGUYEN REF INSURANCE'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-26 06:20:10.077'
           ,30553
           ,'2012-06-26 06:20:10.077'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (785
           ,'ANDREA VIQUEIRA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-26 07:39:14.090'
           ,30553
           ,'2012-06-26 07:39:14.090'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (786
           ,'LUZ RIVERA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-26 07:48:41.623'
           ,30553
           ,'2012-06-26 07:48:41.623'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (788
           ,'MARILIN DE JESUS INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-26 09:02:15.733'
           ,30553
           ,'2012-06-26 09:02:15.733'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (789
           ,'ELIO DIAZ INSURANCE '
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-26 11:28:34.743'
           ,30553
           ,'2012-06-26 11:28:34.743'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (790
           ,'vilma burgos insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-26 11:29:33.657'
           ,30553
           ,'2012-06-26 11:29:33.657'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (791
           ,'JOANN DAVES INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-26 11:30:33.630'
           ,30553
           ,'2012-06-26 11:30:33.630'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (792
           ,'THOMAS AMBROSE INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-27 05:28:57.613'
           ,30553
           ,'2012-06-27 05:28:57.613'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (793
           ,'MARIA HERNANDEZ INSURANCE'
           ,8
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-27 06:10:02.857'
           ,30553
           ,'2012-06-27 06:10:02.857'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (794
           ,'FRANCIS MAHONEY INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-27 07:40:26.033'
           ,30553
           ,'2012-06-27 07:40:26.033'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (795
           ,'ZIVNY INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-27 07:41:14.450'
           ,30553
           ,'2012-06-27 07:41:14.450'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (796
           ,'CELESTE ADAMS INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-27 07:42:46.250'
           ,30553
           ,'2012-06-27 07:42:46.250'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (797
           ,'ELESTE ADAMS REF'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-27 07:43:10.853'
           ,30553
           ,'2012-06-27 07:43:10.853'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (798
           ,'ERNESTINE RILEY INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-27 07:46:25.723'
           ,30553
           ,'2012-06-27 07:46:25.723'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (799
           ,'MARIELA BETANCURT INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-27 07:53:55.737'
           ,30553
           ,'2012-06-27 07:53:55.737'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (800
           ,'DOMENICA MARCHESE INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-27 08:05:27.440'
           ,30553
           ,'2012-06-27 08:05:27.440'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (801
           ,'LAWRENCE GAIL REF'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-27 08:23:01.770'
           ,30553
           ,'2012-06-27 08:23:01.770'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (802
           ,'SONIA FABREGAS INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-27 10:44:37.327'
           ,30553
           ,'2012-06-27 10:44:37.327'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (803
           ,'COREAN INSURANCE REF'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-27 10:47:54.640'
           ,30553
           ,'2012-06-27 10:47:54.640'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (804
           ,'EARNEST NOBLES'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-28 06:28:54.720'
           ,30553
           ,'2012-06-28 06:28:54.720'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (805
           ,'SANDRA NELSON INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-28 08:06:59.353'
           ,30553
           ,'2012-06-28 08:06:59.353'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (806
           ,'CLARA TORANZO INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-28 08:07:40.133'
           ,30553
           ,'2012-06-28 08:07:40.133'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (807
           ,'NILDA DEL CUADRO  REF'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-28 08:08:31.790'
           ,30553
           ,'2012-06-28 08:08:31.790'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (808
           ,'LORY BERRY REFERRAL FOR JUNE '
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-28 08:11:03.343'
           ,30553
           ,'2012-06-28 08:11:03.343'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (809
           ,'RHONDA CROWDER REF'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-28 08:12:09.503'
           ,30553
           ,'2012-06-28 08:12:09.503'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (810
           ,'SHEILA THOMPSON REFERRAL'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-28 08:15:01.433'
           ,30553
           ,'2012-06-28 08:15:01.433'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (811
           ,'JUANA MALDONADO INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-28 11:26:10.520'
           ,30553
           ,'2012-06-28 11:26:10.520'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (812
           ,'CARMEN REFERRAL'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-28 11:26:40.577'
           ,30553
           ,'2012-06-28 11:26:40.577'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (813
           ,'JANICE HERNANDEZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-28 11:34:57.877'
           ,30553
           ,'2012-06-28 11:34:57.877'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (814
           ,'CANGAS INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-28 13:48:11.073'
           ,30553
           ,'2012-06-28 13:48:11.073'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (815
           ,'NANCY WATFORD INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-29 07:22:37.687'
           ,30553
           ,'2012-06-29 07:22:37.687'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (816
           ,'PMT JANER'
           ,10
           ,2
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>SHARP MFP TWAIN K</AcquireSourceName><BitDepth>24</BitDepth><PageSize>3</PageSize><PixelType>2</PixelType><Resolution>150</Resolution><ScanningSide>1</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-29 07:49:11.490'
           ,30553
           ,'2012-07-12 07:33:46.060'
           ,30564
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (817
           ,'PMT JANER'
           ,10
           ,2
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>SHARP MFP TWAIN K</AcquireSourceName><BitDepth>24</BitDepth><PageSize>3</PageSize><PixelType>2</PixelType><Resolution>150</Resolution><ScanningSide>1</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-29 08:24:29.707'
           ,30553
           ,'2012-07-12 07:33:05.747'
           ,30564
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (818
           ,'PMT DIAZ'
           ,10
           ,2
           ,''
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>SHARP MFP TWAIN K</AcquireSourceName><BitDepth>24</BitDepth><PageSize>3</PageSize><PixelType>2</PixelType><Resolution>150</Resolution><ScanningSide>1</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-06-29 09:09:38.207'
           ,30553
           ,'2012-07-12 07:32:21.110'
           ,30564
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (819
           ,'KATHY MURPHT INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-29 09:36:14.133'
           ,30553
           ,'2012-06-29 09:36:14.133'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (820
           ,'ALFREDO DOM INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-29 09:36:56.230'
           ,30553
           ,'2012-06-29 09:36:56.230'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (821
           ,'GAIL LEWIS INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-29 09:38:30.293'
           ,30553
           ,'2012-06-29 09:38:30.293'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (822
           ,'ROSENDO INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-29 09:39:14.803'
           ,30553
           ,'2012-06-29 09:39:14.803'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (823
           ,'KELVIN FULKS INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-29 09:40:31.597'
           ,30553
           ,'2012-06-29 09:40:31.597'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (824
           ,'JOSE RODRIGUEZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-29 09:41:40.560'
           ,30553
           ,'2012-06-29 09:41:40.560'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (825
           ,'JOSE MARANTE REF'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-29 09:59:25.040'
           ,30553
           ,'2012-06-29 09:59:25.040'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (826
           ,'LAURA SMITH INSURANCE_1'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-29 10:15:29.697'
           ,30553
           ,'2012-06-29 10:15:29.697'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (827
           ,'ANDA SOLOMONTE INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-29 10:16:43.783'
           ,30553
           ,'2012-06-29 10:16:43.783'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (828
           ,'LESTER BRUNS INSURANCE_1'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-29 10:18:00.223'
           ,30553
           ,'2012-06-29 10:18:00.223'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (829
           ,'BARBARA JACKSON INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-29 10:19:25.670'
           ,30553
           ,'2012-06-29 10:19:25.670'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (830
           ,'HELEN ALI REFERRAL'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-29 10:24:27.207'
           ,30553
           ,'2012-06-29 10:24:27.207'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (831
           ,'NOELIA GERBOLES INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-29 10:25:25.653'
           ,30553
           ,'2012-06-29 10:25:25.653'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (832
           ,'ELENA LOPEZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-29 10:27:03.520'
           ,30553
           ,'2012-06-29 10:27:03.520'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (833
           ,'MARIA SANCHEZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-06-29 10:29:35.530'
           ,30553
           ,'2012-06-29 10:29:35.530'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (834
           ,'DAVID  URBINA INSURANCE'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-02 05:25:31.737'
           ,30553
           ,'2012-07-02 05:25:31.737'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (835
           ,'susan stevens id'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-02 06:15:45.560'
           ,30553
           ,'2012-07-02 06:15:45.560'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (836
           ,'susan stevens ref april'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-02 06:16:05.880'
           ,30553
           ,'2012-07-02 06:16:05.880'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (837
           ,'HELEN INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-02 08:02:58.127'
           ,30553
           ,'2012-07-02 08:02:58.127'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (839
           ,'marion martin ref'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-02 12:08:07.933'
           ,34346
           ,'2012-07-02 12:08:07.933'
           ,34346
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (840
           ,'JOYCE HENDERSON REF'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-02 12:10:47.173'
           ,34346
           ,'2012-07-02 12:10:47.173'
           ,34346
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (841
           ,'ARGELIA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-03 06:34:20.420'
           ,30553
           ,'2012-07-03 06:34:20.420'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (842
           ,'FELICITA INSURANCE AUTH'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-03 06:39:24.420'
           ,30553
           ,'2012-07-03 06:39:24.420'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (843
           ,'ZOILA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-03 07:00:25.883'
           ,30553
           ,'2012-07-03 07:00:25.883'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (844
           ,'ARINDA PEREZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-03 07:01:02.263'
           ,30553
           ,'2012-07-03 07:01:02.263'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (845
           ,'GLORIA LEWIS  INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-03 07:02:46.197'
           ,30553
           ,'2012-07-03 07:02:46.197'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (846
           ,'OLGA CUBA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-03 07:04:38.323'
           ,30553
           ,'2012-07-03 07:04:38.323'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (847
           ,'MARILYN INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-03 08:18:55.173'
           ,30553
           ,'2012-07-03 08:18:55.173'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (848
           ,'lissette garcia insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-03 08:26:09.463'
           ,30553
           ,'2012-07-03 08:26:09.463'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (849
           ,'JUANA CABRERA REF'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-03 08:27:04.187'
           ,30553
           ,'2012-07-03 08:27:04.187'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (850
           ,'MARGARITA MENDEZ INSURANCE REF'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-03 08:27:53.143'
           ,30553
           ,'2012-07-03 08:27:53.143'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (851
           ,'SARA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-03 08:29:28.877'
           ,30553
           ,'2012-07-03 08:29:28.877'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (852
           ,'MARGARITA TORRES GUZMAN INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-03 08:30:15.470'
           ,30553
           ,'2012-07-03 08:30:15.470'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (853
           ,'CARLOS VELEZ REF'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-03 08:31:23.047'
           ,30553
           ,'2012-07-03 08:31:23.047'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (854
           ,'GLADYS MENENDEZ REF'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-03 08:32:41.333'
           ,30553
           ,'2012-07-03 08:32:41.333'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (855
           ,'ANDREA WELL REF INSURANCE'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-03 08:34:35.730'
           ,30553
           ,'2012-07-03 08:34:35.730'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (856
           ,'ERLEEN INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-03 08:37:03.653'
           ,30553
           ,'2012-07-03 08:37:03.653'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (857
           ,'ELIZA ZAMBRANO INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-03 08:40:13.327'
           ,30553
           ,'2012-07-03 08:40:13.327'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (858
           ,'DOUGLAS ROBERTSON INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-03 10:35:55.857'
           ,30553
           ,'2012-07-03 10:35:55.857'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (859
           ,'KERR ID'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-03 10:52:34.187'
           ,30553
           ,'2012-07-03 10:52:34.187'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (860
           ,'BRUNHILDA INSURANCE REF'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-03 11:14:50.570'
           ,30553
           ,'2012-07-03 11:14:50.570'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (861
           ,'REMECIA PINCHINAT  REF INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-03 11:26:51.433'
           ,30553
           ,'2012-07-03 11:26:51.433'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (862
           ,'THERESA CRIST INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-03 11:34:27.780'
           ,30553
           ,'2012-07-03 11:34:27.780'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (863
           ,'QUINTA WELL REF'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-03 11:34:52.933'
           ,30553
           ,'2012-07-03 11:34:52.933'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (864
           ,'OLAN'
           ,7
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>SHARP MFP TWAIN K</AcquireSourceName><BitDepth>24</BitDepth><PageSize>3</PageSize><PixelType>2</PixelType><Resolution>300</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-03 14:40:01.920'
           ,47692
           ,'2012-07-03 14:40:01.920'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (865
           ,'RICARDO GARCIA INSURANCE REF'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-05 05:47:58.840'
           ,30553
           ,'2012-07-05 05:47:58.840'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (866
           ,'ROSE BILLINGS AUTH INSURANC'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-05 06:50:25.150'
           ,30553
           ,'2012-07-05 06:50:25.150'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (867
           ,'ALEIDA CAM'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-05 06:51:43.633'
           ,30553
           ,'2012-07-05 06:51:43.633'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (868
           ,'JESUS GOMEZ REFERRAL'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-05 10:35:40.967'
           ,30553
           ,'2012-07-05 10:35:40.967'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (869
           ,'PMT DIAZ'
           ,10
           ,2
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>SHARP MFP TWAIN K</AcquireSourceName><BitDepth>24</BitDepth><PageSize>3</PageSize><PixelType>2</PixelType><Resolution>150</Resolution><ScanningSide>1</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-05 11:39:14.557'
           ,30553
           ,'2012-07-13 09:14:47.537'
           ,41476
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (870
           ,'OLGA CASTILLO INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-05 11:52:21.590'
           ,30553
           ,'2012-07-05 11:52:21.590'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (871
           ,'RICHARD CASTILLO INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-05 11:53:00.827'
           ,30553
           ,'2012-07-05 11:53:00.827'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (872
           ,'MARIA OSORIO REF'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-05 12:01:26.247'
           ,30553
           ,'2012-07-05 12:01:26.247'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (873
           ,'ofelia abella insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-05 12:03:33.863'
           ,30553
           ,'2012-07-05 12:03:33.863'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (874
           ,'MATLACH REF'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-05 12:04:12.463'
           ,30553
           ,'2012-07-05 12:04:12.463'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (875
           ,'PMT JANER'
           ,10
           ,2
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>SHARP MFP TWAIN K</AcquireSourceName><BitDepth>24</BitDepth><PageSize>3</PageSize><PixelType>2</PixelType><Resolution>150</Resolution><ScanningSide>1</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-05 12:15:11.193'
           ,30553
           ,'2012-07-13 12:36:31.590'
           ,41476
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (876
           ,'DENIAL JANER - AG DONE'
           ,13
           ,2
           ,'ALREADY FIXED AND RB
DONE AG'
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>SHARP MFP TWAIN K</AcquireSourceName><BitDepth>24</BitDepth><PageSize>3</PageSize><PixelType>2</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-05 12:55:06.300'
           ,30553
           ,'2012-07-12 07:36:28.867'
           ,30564
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (877
           ,'GLOBER INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-05 12:56:53.993'
           ,30553
           ,'2012-07-05 12:56:53.993'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (880
           ,'DAISYRE RODRIGUEZ'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-05 13:01:23.333'
           ,30553
           ,'2012-07-05 13:01:23.333'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (881
           ,'copier@modulardocument.com_20120706_115443'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-06 07:59:14.950'
           ,47692
           ,'2012-07-06 07:59:14.950'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (882
           ,'copier@modulardocument.com_20120706_115544'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-06 07:59:54.540'
           ,47692
           ,'2012-07-06 07:59:54.540'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (883
           ,'copier@modulardocument.com_20120706_150828'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-06 11:12:11.840'
           ,47692
           ,'2012-07-06 11:12:11.840'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (884
           ,'copier@modulardocument.com_20120706_150849'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-06 11:12:35.703'
           ,47692
           ,'2012-07-06 11:12:35.703'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (885
           ,'copier@modulardocument.com_20120706_152050'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-06 11:23:23.363'
           ,47692
           ,'2012-07-06 11:23:23.363'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (886
           ,'copier@modulardocument.com_20120706_153224'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-06 11:39:51.710'
           ,47692
           ,'2012-07-06 11:39:51.710'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (887
           ,'copier@modulardocument.com_20120706_153241'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-06 11:43:15.190'
           ,47692
           ,'2012-07-06 11:43:15.190'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (888
           ,'GUY WILLOUGHBY (ID INCLUDED)'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 11:46:25.530'
           ,34037
           ,'2012-07-06 11:46:25.530'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (889
           ,'GUY WILLOUGHBY (REFERRAL)'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 11:48:22.307'
           ,34037
           ,'2012-07-10 07:34:38.080'
           ,30564
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (890
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 11:50:02.093'
           ,34037
           ,'2012-07-10 07:35:14.460'
           ,30564
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (891
           ,'AND ID'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 11:59:19.460'
           ,34037
           ,'2012-07-06 11:59:19.460'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (892
           ,'AND ID'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 12:04:05.110'
           ,34037
           ,'2012-07-06 12:04:05.110'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (893
           ,'REFERRAL AND VERIFICATION'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 12:05:18.940'
           ,34037
           ,'2012-07-06 12:05:18.940'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (894
           ,'AND ID'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 12:06:23.720'
           ,34037
           ,'2012-07-06 12:06:23.720'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (895
           ,'ELIGIBILITY AND BENEFITS'
           ,26
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 12:09:06.650'
           ,34037
           ,'2012-07-06 12:09:06.650'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (896
           ,'REFERRAL REQUEST CONFIRMATION'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 12:10:54.963'
           ,34037
           ,'2012-07-06 12:10:54.963'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (897
           ,'INSURANCE CARD AND ID'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 12:12:00.723'
           ,34037
           ,'2012-07-06 12:12:00.723'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (898
           ,'REFERRAL AND VERIFICATION'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 12:13:33.083'
           ,34037
           ,'2012-07-06 12:13:33.083'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (899
           ,'INSURANCE CARD AND ID'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 12:15:58.180'
           ,34037
           ,'2012-07-06 12:15:58.180'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (900
           ,'REFERRAL AND VERIFICATION'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 12:17:22.377'
           ,34037
           ,'2012-07-06 12:17:22.377'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (901
           ,'copier@modulardocument.com_20120706_161433'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-06 12:19:10.347'
           ,47692
           ,'2012-07-06 12:19:10.347'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (902
           ,'INSURANCE CARD AND ID'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 12:19:41.077'
           ,34037
           ,'2012-07-06 12:19:41.077'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (903
           ,'copier@modulardocument.com_20120706_161649'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-06 12:20:05.170'
           ,47692
           ,'2012-07-06 12:20:05.170'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (904
           ,'REFERRAL (MELENDEZ MD)'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 12:27:29.650'
           ,34037
           ,'2012-07-06 12:27:29.650'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (905
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 12:28:21.983'
           ,34037
           ,'2012-07-06 12:28:21.983'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (906
           ,'REFERRAL AND VERIFICATION'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 12:30:04.723'
           ,34037
           ,'2012-07-06 12:30:04.723'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (907
           ,'INSURANCE AND ID'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 12:31:14.720'
           ,34037
           ,'2012-07-06 12:31:14.720'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (908
           ,'REFERRAL AND VERIFICATION'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 12:32:22.630'
           ,34037
           ,'2012-07-06 12:32:22.630'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (909
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 12:33:22.050'
           ,34037
           ,'2012-07-06 12:33:22.050'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (910
           ,'copier@modulardocument.com_20120706_163212'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-06 12:34:02.493'
           ,47692
           ,'2012-07-06 12:34:02.493'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (911
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 12:34:02.747'
           ,34037
           ,'2012-07-06 12:34:02.747'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (912
           ,'copier@modulardocument.com_20120706_163229'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-06 12:34:26.783'
           ,47692
           ,'2012-07-06 12:34:26.783'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (913
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 12:35:13.797'
           ,34037
           ,'2012-07-06 12:35:13.797'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (914
           ,'REFERRAL AND VERIFICATION'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 12:36:40.153'
           ,34037
           ,'2012-07-06 12:36:40.153'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (915
           ,'INSURANCE CARD AND ID'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 12:38:11.830'
           ,34037
           ,'2012-07-06 12:38:11.830'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (916
           ,'PASSPORT'
           ,8
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 12:40:27.533'
           ,34037
           ,'2012-07-06 12:40:27.533'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (917
           ,'copier@modulardocument.com_20120706_164343'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-06 12:46:04.710'
           ,47692
           ,'2012-07-06 12:46:04.710'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (918
           ,'copier@modulardocument.com_20120706_164424'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-06 12:46:31.023'
           ,47692
           ,'2012-07-06 12:46:31.023'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (919
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 12:47:41.450'
           ,34037
           ,'2012-07-06 12:47:41.450'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (920
           ,'REFERRAL AND AUTHORIZATION'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 12:48:40.807'
           ,34037
           ,'2012-07-06 12:48:40.807'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (921
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 12:49:33.243'
           ,34037
           ,'2012-07-06 12:49:33.243'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (922
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 12:50:22.900'
           ,34037
           ,'2012-07-06 12:50:22.900'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (923
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 12:52:54.417'
           ,34037
           ,'2012-07-06 12:52:54.417'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (924
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 12:55:17.550'
           ,34037
           ,'2012-07-06 12:55:17.550'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (925
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 12:56:51.007'
           ,34037
           ,'2012-07-06 12:56:51.007'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (926
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 12:57:42.053'
           ,34037
           ,'2012-07-06 12:57:42.053'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (927
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 12:58:26.723'
           ,34037
           ,'2012-07-06 12:58:26.723'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (928
           ,'copier@modulardocument.com_20120706_165746'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-06 12:59:01.680'
           ,47692
           ,'2012-07-06 12:59:01.680'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (929
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 12:59:17.027'
           ,34037
           ,'2012-07-06 12:59:17.027'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (930
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:00:13.500'
           ,34037
           ,'2012-07-06 13:00:13.500'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (931
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:00:59.867'
           ,34037
           ,'2012-07-06 13:00:59.867'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (932
           ,'INSIRANCE CARD AND ID'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:02:02.613'
           ,34037
           ,'2012-07-06 13:02:02.613'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (933
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:02:54.053'
           ,34037
           ,'2012-07-06 13:02:54.053'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (934
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:04:02.717'
           ,34037
           ,'2012-07-06 13:04:02.717'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (935
           ,'INSURANCE CARD AND ID'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:04:57.497'
           ,34037
           ,'2012-07-06 13:04:57.497'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (936
           ,'copier@modulardocument.com_20120706_170346'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-06 13:05:54.553'
           ,47692
           ,'2012-07-06 13:05:54.553'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (937
           ,'INSURANCE CARD AND ID'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:05:55.103'
           ,34037
           ,'2012-07-06 13:05:55.103'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (938
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:06:36.183'
           ,34037
           ,'2012-07-06 13:06:36.183'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (939
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:07:37.990'
           ,34037
           ,'2012-07-06 13:07:37.990'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (940
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:08:13.950'
           ,34037
           ,'2012-07-06 13:08:13.950'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (941
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:09:04.737'
           ,34037
           ,'2012-07-06 13:09:04.737'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (942
           ,'referral for 2/8/2012'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:12:34.560'
           ,34037
           ,'2012-07-06 13:12:34.560'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (943
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:13:22.963'
           ,34037
           ,'2012-07-06 13:13:22.963'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (944
           ,'copier@modulardocument.com_20120706_171134'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-06 13:13:33.710'
           ,47692
           ,'2012-07-06 13:13:33.710'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (945
           ,'INSURANCE CARD AND ID'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:14:16.337'
           ,34037
           ,'2012-07-06 13:14:16.337'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (946
           ,'INSURANCE INFORMATION'
           ,3
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:15:33.897'
           ,34037
           ,'2012-07-12 07:27:14.777'
           ,30564
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (947
           ,'INSURANCE CARD AND ID'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:16:04.140'
           ,34037
           ,'2012-07-06 13:16:04.140'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (948
           ,'REFERRAL AND VERIFICATION'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:17:47.777'
           ,34037
           ,'2012-07-06 13:17:47.777'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (949
           ,'INSURANCE CARD AND ID'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:18:17.430'
           ,34037
           ,'2012-07-06 13:18:17.430'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (950
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:19:09.057'
           ,34037
           ,'2012-07-06 13:19:09.057'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (951
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:19:49.623'
           ,34037
           ,'2012-07-06 13:19:49.623'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (952
           ,'AUTHORIZATION'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:20:51.050'
           ,34037
           ,'2012-07-06 13:20:51.050'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (953
           ,'REFERRAL (2/14/2012)'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:22:17.457'
           ,34037
           ,'2012-07-06 13:22:17.457'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (954
           ,'REFERRAL FOR DATE (4/20/2011)'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:24:32.290'
           ,34037
           ,'2012-07-06 13:24:32.290'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (955
           ,'copier@modulardocument.com_20120706_171925'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-06 13:27:05.600'
           ,47692
           ,'2012-07-06 13:27:05.600'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (956
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:27:15.733'
           ,34037
           ,'2012-07-06 13:27:15.733'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (957
           ,'copier@modulardocument.com_20120706_172003'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-06 13:27:36.653'
           ,47692
           ,'2012-07-06 13:27:36.653'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (958
           ,'REFERRAL (2/25/2011)'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:28:34.780'
           ,34037
           ,'2012-07-06 13:28:34.780'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (959
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:29:41.567'
           ,34037
           ,'2012-07-06 13:29:41.567'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (960
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:30:28.560'
           ,34037
           ,'2012-07-06 13:30:28.560'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (961
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:31:20.523'
           ,34037
           ,'2012-07-06 13:31:20.523'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (962
           ,'REFERRAL FORM (12/19/2011)'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:32:19.850'
           ,34037
           ,'2012-07-06 13:32:19.850'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (963
           ,'INSURANCE CARD AND ID'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:33:40.227'
           ,34037
           ,'2012-07-06 13:33:40.227'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (964
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:34:28.690'
           ,34037
           ,'2012-07-06 13:34:28.690'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (965
           ,'copier@modulardocument.com_20120706_173108'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-06 13:34:37.173'
           ,47692
           ,'2012-07-06 13:34:37.173'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (966
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:35:17.527'
           ,34037
           ,'2012-07-06 13:35:17.527'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (967
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:36:05.377'
           ,34037
           ,'2012-07-06 13:36:05.377'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (968
           ,'REFERRAL AND AUTHORIZATION'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:36:57.117'
           ,34037
           ,'2012-07-06 13:36:57.117'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (969
           ,'INSURANCE CARD AND ID'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:37:52.507'
           ,34037
           ,'2012-07-06 13:37:52.507'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (970
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:38:21.690'
           ,34037
           ,'2012-07-06 13:38:21.690'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (971
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:39:11.457'
           ,34037
           ,'2012-07-06 13:39:11.457'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (972
           ,'REFERRAL (2/29/2012)'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:40:11.217'
           ,34037
           ,'2012-07-06 13:40:11.217'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (973
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:40:56.987'
           ,34037
           ,'2012-07-06 13:40:56.987'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (974
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:41:51.323'
           ,34037
           ,'2012-07-06 13:41:51.323'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (975
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:48:52.767'
           ,34037
           ,'2012-07-06 13:48:52.767'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (976
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:50:10.837'
           ,34037
           ,'2012-07-06 13:50:10.837'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (977
           ,'INSURANCE CARD AND ID'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:50:43.720'
           ,34037
           ,'2012-07-06 13:50:43.720'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (978
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:51:15.767'
           ,34037
           ,'2012-07-06 13:51:15.767'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (979
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:52:08.933'
           ,34037
           ,'2012-07-06 13:52:08.933'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (980
           ,'INSURANCE, VERIFICATION AND ID'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:53:12.183'
           ,34037
           ,'2012-07-06 13:53:12.183'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (981
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:53:53.513'
           ,34037
           ,'2012-07-06 13:53:53.513'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (982
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:54:33.960'
           ,34037
           ,'2012-07-06 13:54:33.960'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (983
           ,'REFERRAL (2/2/2012)'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:55:41.827'
           ,34037
           ,'2012-07-06 13:55:41.827'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (984
           ,'REFERRAL (2/2/2012)'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:57:02.507'
           ,34037
           ,'2012-07-06 13:57:02.507'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (985
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:57:45.837'
           ,34037
           ,'2012-07-06 13:57:45.837'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (986
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:58:22.473'
           ,34037
           ,'2012-07-06 13:58:22.473'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (987
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 13:58:57.743'
           ,34037
           ,'2012-07-06 13:58:57.743'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (988
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-06 14:00:08.890'
           ,34037
           ,'2012-07-06 14:00:08.890'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (989
           ,'INSURANCE/ID CARDS'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-09 06:39:14.047'
           ,30551
           ,'2012-07-09 06:39:14.047'
           ,30551
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (990
           ,'copier@modulardocument.com_20120706_155234'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-09 06:40:15.697'
           ,30551
           ,'2012-07-09 06:40:15.697'
           ,30551
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (991
           ,'INSURANCE/ID CARDS'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-09 06:50:03.613'
           ,30551
           ,'2012-07-09 06:50:03.613'
           ,30551
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (992
           ,'ID/INSURANCE CARDS'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-09 06:51:07.173'
           ,30551
           ,'2012-07-09 06:51:07.173'
           ,30551
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (993
           ,'copier@modulardocument.com_20120706_174053'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-09 06:51:34.177'
           ,47692
           ,'2012-07-09 06:51:34.177'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (994
           ,'copier@modulardocument.com_20120706_174134'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-09 06:52:07.297'
           ,47692
           ,'2012-07-09 06:52:07.297'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (995
           ,'INSURANCE/ID CARDS'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-09 06:52:31.700'
           ,30551
           ,'2012-07-09 06:52:31.700'
           ,30551
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (996
           ,'copier@modulardocument.com_20120706_174149'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-09 06:54:00.193'
           ,47692
           ,'2012-07-09 06:54:00.193'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (997
           ,'copier@modulardocument.com_20120706_155247'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-09 06:54:25.070'
           ,30551
           ,'2012-07-09 06:54:25.070'
           ,30551
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (998
           ,'INSURANCE/ID NUMBER'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-09 06:55:19.690'
           ,30551
           ,'2012-07-09 06:55:19.690'
           ,30551
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (999
           ,'copier@modulardocument.com_20120706_155315'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-09 06:55:48.830'
           ,30551
           ,'2012-07-09 06:55:48.830'
           ,30551
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1000
           ,'INSURANCE/ID CARDS'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-09 06:56:45.350'
           ,30551
           ,'2012-07-09 06:56:45.350'
           ,30551
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1001
           ,'INSURANCE/ID CARDS'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-09 06:58:13.070'
           ,30551
           ,'2012-07-09 06:58:13.070'
           ,30551
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1002
           ,'INSURANCE/ID CARDS'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-09 07:17:43.793'
           ,30551
           ,'2012-07-09 07:17:43.793'
           ,30551
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1003
           ,'INSURANCE/ID CARDS'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-09 07:18:36.560'
           ,30551
           ,'2012-07-09 07:18:36.560'
           ,30551
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1004
           ,'INSURANCE/ID CARDS'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-09 07:19:23.307'
           ,30551
           ,'2012-07-09 07:19:23.307'
           ,30551
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1005
           ,'INSURANCE/ID CARDS'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-09 07:20:08.137'
           ,30551
           ,'2012-07-09 07:20:08.137'
           ,30551
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1006
           ,'INSURANCE/ID CARDS'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-09 07:20:41.027'
           ,30551
           ,'2012-07-09 07:20:41.027'
           ,30551
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1007
           ,'copier@modulardocument.com_20120706_155657'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-09 07:35:42.527'
           ,30551
           ,'2012-07-09 07:35:42.527'
           ,30551
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1008
           ,'copier@modulardocument.com_20120709_124147'
           ,26
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-09 08:53:29.020'
           ,47692
           ,'2012-07-09 08:53:29.020'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1009
           ,'copier@modulardocument.com_20120709_125013'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-09 08:53:54.360'
           ,47692
           ,'2012-07-09 08:53:54.360'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1010
           ,'copier@modulardocument.com_20120709_151154'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-09 11:16:15.977'
           ,47692
           ,'2012-07-09 11:16:15.977'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1011
           ,'copier@modulardocument.com_20120709_151221'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-09 11:16:44.000'
           ,47692
           ,'2012-07-09 11:16:44.000'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1012
           ,'copier@modulardocument.com_20120709_154108'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-09 11:42:45.590'
           ,47692
           ,'2012-07-09 11:42:45.590'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1013
           ,'copier@modulardocument.com_20120709_154123'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-09 11:43:10.527'
           ,47692
           ,'2012-07-09 11:43:10.527'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1014
           ,'copier@modulardocument.com_20120709_161114'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-09 12:12:54.813'
           ,47692
           ,'2012-07-09 12:12:54.813'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1015
           ,'copier@modulardocument.com_20120709_161140'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-09 12:13:39.557'
           ,47692
           ,'2012-07-09 12:13:39.557'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1016
           ,'copier@modulardocument.com_20120709_171148'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-09 13:17:02.840'
           ,47692
           ,'2012-07-09 13:17:02.840'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1017
           ,'copier@modulardocument.com_20120709_171219'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-09 13:17:22.150'
           ,47692
           ,'2012-07-09 13:17:22.150'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1018
           ,'copier@modulardocument.com_20120710_103443'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-10 06:36:56.943'
           ,47692
           ,'2012-07-10 06:36:56.943'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1019
           ,'copier@modulardocument.com_20120710_101519'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-10 06:37:13.507'
           ,47692
           ,'2012-07-10 06:37:13.507'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1020
           ,'copier@modulardocument.com_20120710_104947'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-10 07:03:52.600'
           ,47692
           ,'2012-07-10 07:03:52.600'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1021
           ,'copier@modulardocument.com_20120710_105013'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-10 07:04:29.910'
           ,47692
           ,'2012-07-10 07:04:29.910'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1022
           ,'copier@modulardocument.com_20120710_111032'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-10 07:12:46.640'
           ,47692
           ,'2012-07-10 07:12:46.640'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1023
           ,'copier@modulardocument.com_20120710_111104'
           ,26
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-10 07:13:13.270'
           ,47692
           ,'2012-07-10 07:13:13.270'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1024
           ,'copier@modulardocument.com_20120710_130905'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-10 09:10:42.243'
           ,47692
           ,'2012-07-10 09:10:42.243'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1025
           ,'copier@modulardocument.com_20120710_130920'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-10 09:11:04.040'
           ,47692
           ,'2012-07-10 09:11:04.040'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1026
           ,'copier@modulardocument.com_20120710_132353'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-10 09:25:44.237'
           ,47692
           ,'2012-07-10 09:25:44.237'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1027
           ,'copier@modulardocument.com_20120710_145723'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-10 10:59:28.037'
           ,47692
           ,'2012-07-10 10:59:28.037'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1028
           ,'copier@modulardocument.com_20120710_145746'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-10 10:59:48.197'
           ,47692
           ,'2012-07-10 10:59:48.197'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1029
           ,'copier@modulardocument.com_20120710_150546'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-10 11:08:12.400'
           ,47692
           ,'2012-07-10 11:08:12.400'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1030
           ,'copier@modulardocument.com_20120710_150626'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-10 11:08:35.340'
           ,47692
           ,'2012-07-10 11:08:35.340'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1031
           ,'copier@modulardocument.com_20120710_155052'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-10 11:53:23.897'
           ,47692
           ,'2012-07-10 11:53:23.897'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1032
           ,'copier@modulardocument.com_20120710_155110'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-10 11:53:47.253'
           ,47692
           ,'2012-07-10 11:53:47.253'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1033
           ,'copier@modulardocument.com_20120710_160215'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-10 12:09:04.147'
           ,47692
           ,'2012-07-10 12:09:04.147'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1034
           ,'copier@modulardocument.com_20120710_161416'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-10 12:16:54.107'
           ,47692
           ,'2012-07-10 12:16:54.107'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1035
           ,'copier@modulardocument.com_20120710_161449'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-10 12:17:14.110'
           ,47692
           ,'2012-07-10 12:17:14.110'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1036
           ,'copier@modulardocument.com_20120710_163640'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-10 12:38:29.023'
           ,47692
           ,'2012-07-10 12:38:29.023'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1037
           ,'copier@modulardocument.com_20120710_164513'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-10 12:49:36.523'
           ,47692
           ,'2012-07-10 12:49:36.523'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1038
           ,'copier@modulardocument.com_20120710_164554'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-10 12:50:12.583'
           ,47692
           ,'2012-07-10 12:50:12.583'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1039
           ,'copier@modulardocument.com_20120710_165931'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-10 13:04:15.410'
           ,47692
           ,'2012-07-10 13:04:15.410'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1040
           ,'copier@modulardocument.com_20120710_173446'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-10 13:38:23.897'
           ,47692
           ,'2012-07-10 13:38:23.897'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1041
           ,'copier@modulardocument.com_20120710_174419'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-10 13:49:30.520'
           ,47692
           ,'2012-07-10 13:49:30.520'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1042
           ,'copier@modulardocument.com_20120711_103542'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-11 06:37:33.603'
           ,47692
           ,'2012-07-11 06:37:33.603'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1043
           ,'copier@modulardocument.com_20120711_103617'
           ,26
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-11 06:37:56.380'
           ,47692
           ,'2012-07-11 06:37:56.380'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1044
           ,'copier@modulardocument.com_20120711_104432'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-11 06:46:15.577'
           ,47692
           ,'2012-07-11 06:46:15.577'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1045
           ,'copier@modulardocument.com_20120711_104500'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-11 06:46:57.540'
           ,47692
           ,'2012-07-11 06:46:57.540'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1046
           ,'copier@modulardocument.com_20120711_114159'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-11 07:46:28.737'
           ,47692
           ,'2012-07-11 07:46:28.737'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1047
           ,'copier@modulardocument.com_20120711_123403'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-11 09:37:57.860'
           ,47692
           ,'2012-07-11 09:37:57.860'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1048
           ,'copier@modulardocument.com_20120711_123427'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-11 09:38:35.873'
           ,47692
           ,'2012-07-11 09:38:35.873'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1049
           ,'copier@modulardocument.com_20120711_123441'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-11 09:38:57.633'
           ,47692
           ,'2012-07-11 09:38:57.633'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1050
           ,'copier@modulardocument.com_20120711_162635'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-11 12:40:21.187'
           ,47692
           ,'2012-07-11 12:40:21.187'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1051
           ,'copier@modulardocument.com_20120711_163621'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-11 12:40:55.303'
           ,47692
           ,'2012-07-11 12:40:55.303'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1052
           ,'copier@modulardocument.com_20120711_164120'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-11 12:42:29.100'
           ,47692
           ,'2012-07-11 12:42:29.100'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1053
           ,'copier@modulardocument.com_20120711_170947'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-11 13:11:15.390'
           ,47692
           ,'2012-07-11 13:11:15.390'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1054
           ,'copier@modulardocument.com_20120711_170947'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-11 13:12:09.697'
           ,47692
           ,'2012-07-11 13:12:09.697'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1055
           ,'copier@modulardocument.com_20120712_130457'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-12 09:09:39.683'
           ,47692
           ,'2012-07-12 09:09:39.683'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1056
           ,'copier@modulardocument.com_20120712_130431'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-12 09:10:05.837'
           ,47692
           ,'2012-07-12 09:10:05.837'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1057
           ,'copier@modulardocument.com_20120712_142129'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-12 10:22:58.150'
           ,47692
           ,'2012-07-12 10:22:58.150'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1058
           ,'copier@modulardocument.com_20120712_142145'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-12 10:23:29.353'
           ,47692
           ,'2012-07-12 10:23:29.353'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1059
           ,'copier@modulardocument.com_20120712_143402'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-12 10:38:56.757'
           ,47692
           ,'2012-07-12 10:38:56.757'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1060
           ,'copier@modulardocument.com_20120712_143342'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-12 10:39:50.913'
           ,47692
           ,'2012-07-12 10:39:50.913'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1061
           ,'copier@modulardocument.com_20120712_151911'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-12 11:20:12.603'
           ,47692
           ,'2012-07-12 11:20:12.603'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1062
           ,'copier@modulardocument.com_20120712_151854'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-12 11:20:35.213'
           ,47692
           ,'2012-07-12 11:20:35.213'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1063
           ,'copier@modulardocument.com_20120712_153255'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-12 11:37:47.900'
           ,47692
           ,'2012-07-12 11:37:47.900'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1065
           ,'copier@modulardocument.com_20120712_154137'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-12 11:50:04.310'
           ,47692
           ,'2012-07-12 11:50:04.310'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1066
           ,'copier@modulardocument.com_20120712_154127'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-12 11:50:53.313'
           ,47692
           ,'2012-07-12 11:50:53.313'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1067
           ,'copier@modulardocument.com_20120712_160214'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-12 12:03:22.507'
           ,47692
           ,'2012-07-12 12:03:22.507'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1068
           ,'copier@modulardocument.com_20120712_174818'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-12 13:49:56.437'
           ,47692
           ,'2012-07-12 13:49:56.437'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1069
           ,'copier@modulardocument.com_20120712_174721'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-12 13:50:16.473'
           ,47692
           ,'2012-07-12 13:50:16.473'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1070
           ,'copier@modulardocument.com_20120713_103030'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-13 06:35:06.207'
           ,47692
           ,'2012-07-13 06:35:06.207'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1071
           ,'copier@modulardocument.com_20120713_102921'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-13 06:35:30.270'
           ,47692
           ,'2012-07-13 06:35:30.270'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1072
           ,'copier@modulardocument.com_20120713_103906'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-13 06:43:44.467'
           ,47692
           ,'2012-07-13 06:43:44.467'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1073
           ,'copier@modulardocument.com_20120713_103838'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-13 06:44:04.130'
           ,47692
           ,'2012-07-13 06:44:04.130'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1074
           ,'copier@modulardocument.com_20120713_105846'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-13 07:06:15.250'
           ,47692
           ,'2012-07-13 07:06:15.250'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1075
           ,'copier@modulardocument.com_20120713_105834'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-13 07:06:56.680'
           ,47692
           ,'2012-07-13 07:06:56.680'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1076
           ,'INSURANCE CARD AND ID'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 07:55:49.087'
           ,34037
           ,'2012-07-13 07:55:49.087'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1077
           ,'REFERRAL DATE 11/02/2011'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 08:11:02.580'
           ,34037
           ,'2012-07-13 08:11:02.580'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1078
           ,'REFERRAL DATE 11/28/2011'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 08:12:26.340'
           ,34037
           ,'2012-07-13 08:12:26.340'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1079
           ,'REFERRAL (8/31/2011)/ VERIFICATION'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 08:14:14.463'
           ,34037
           ,'2012-07-13 08:14:14.463'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1080
           ,'INSURANCE CARD AND ID'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 08:15:10.360'
           ,34037
           ,'2012-07-13 08:15:10.360'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1081
           ,'INSURANCE CARD AND ID'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 08:16:08.197'
           ,34037
           ,'2012-07-13 08:16:08.197'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1082
           ,'ELIGIBILITY AND BENEFITS'
           ,26
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 08:17:25.817'
           ,34037
           ,'2012-07-13 08:17:25.817'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1083
           ,'REFERRAL (11/21/2011)'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 08:18:06.177'
           ,34037
           ,'2012-07-13 08:18:06.177'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1084
           ,'REFERRAL (2/18/2011)'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 08:22:17.877'
           ,34037
           ,'2012-07-13 08:22:17.877'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1085
           ,'INSURANCE CARD AND ID'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 08:23:07.340'
           ,34037
           ,'2012-07-13 08:23:07.340'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1086
           ,'REFERRAL (11/17/2011)'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 08:24:44.930'
           ,34037
           ,'2012-07-13 08:24:44.930'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1087
           ,'REFERRAL (7/06/2012)'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 08:41:03.140'
           ,34037
           ,'2012-07-13 08:41:03.140'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1088
           ,'REFERRAL (7/9/2012)'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 08:42:19.043'
           ,34037
           ,'2012-07-13 08:42:19.043'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1089
           ,'REFERRAL (7/9/2012)'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 08:43:07.843'
           ,34037
           ,'2012-07-13 08:43:07.843'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1090
           ,'REFERRAL (7/9/2012)'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 08:44:00.827'
           ,34037
           ,'2012-07-13 08:44:00.827'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1091
           ,'REFERRAL (7/10/2012)'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 08:44:52.727'
           ,34037
           ,'2012-07-13 08:44:52.727'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1092
           ,'REFERRAL (7/6/2012)'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 08:49:03.903'
           ,34037
           ,'2012-07-13 08:49:03.903'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1093
           ,'REFERRAL (6/13/2012)'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 08:50:37.920'
           ,34037
           ,'2012-07-13 08:50:37.920'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1094
           ,'REFERRAL (7/10/2012)'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 08:51:20.137'
           ,34037
           ,'2012-07-13 08:51:20.137'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1095
           ,'REFERRAL (6/21/2012)'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 08:56:33.620'
           ,34037
           ,'2012-07-13 08:56:33.620'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1096
           ,'copier@modulardocument.com_20120713_125745'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-13 08:58:48.233'
           ,47692
           ,'2012-07-13 08:58:48.233'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1098
           ,'copier@modulardocument.com_20120713_125653'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-13 08:59:42.780'
           ,47692
           ,'2012-07-13 08:59:42.780'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1099
           ,'REFERRAL (6/26/2012)'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 09:00:57.997'
           ,34037
           ,'2012-07-13 09:00:57.997'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1100
           ,'REFERRAL (7/12/2012)'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 09:02:43.273'
           ,34037
           ,'2012-07-13 09:02:43.273'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1101
           ,'copier@modulardocument.com_20120713_125724'
           ,13
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-13 09:05:56.970'
           ,47692
           ,'2012-07-13 09:05:56.970'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1102
           ,'REFERRAL (1/9/2012)'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 11:19:10.423'
           ,34037
           ,'2012-07-13 11:19:10.423'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1103
           ,'INSURANCE CARD AND ID'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 11:19:55.370'
           ,34037
           ,'2012-07-13 11:19:55.370'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1104
           ,'REFERRAL (1/10/2012)'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 11:23:40.117'
           ,34037
           ,'2012-07-13 11:23:40.117'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1105
           ,'INSURANCE CARD AND ID'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 11:24:44.030'
           ,34037
           ,'2012-07-13 11:24:44.030'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1106
           ,'INSURANCE CARD AND ID'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 11:41:08.067'
           ,34037
           ,'2012-07-13 11:41:08.067'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1107
           ,'REFERRAL (11/18/2011) & VERIFICATION'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 11:42:22.900'
           ,34037
           ,'2012-07-13 11:42:22.900'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1108
           ,'INSURANCE CARD AND ID'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 11:47:21.657'
           ,34037
           ,'2012-07-13 11:47:21.657'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1109
           ,'INSURANCE CARD AND ID'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 11:49:04.020'
           ,34037
           ,'2012-07-13 11:49:04.020'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1110
           ,'REFERRAL (5/31/2012)'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 11:50:35.407'
           ,34037
           ,'2012-07-13 11:50:35.407'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1111
           ,'copier@modulardocument.com_20120713_154744'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-13 11:50:51.933'
           ,47692
           ,'2012-07-13 11:50:51.933'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1112
           ,'copier@modulardocument.com_20120713_154711'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-13 11:51:16.350'
           ,47692
           ,'2012-07-13 11:51:16.350'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1113
           ,'INSURANCE CARD AND ID'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 11:51:27.230'
           ,34037
           ,'2012-07-13 11:51:27.230'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1114
           ,'INSURANCE CARD AND ID'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 11:52:12.183'
           ,34037
           ,'2012-07-13 11:52:12.183'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1115
           ,'INSURANCE CARD AND ID'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 11:53:05.213'
           ,34037
           ,'2012-07-13 11:53:05.213'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1116
           ,'copier@modulardocument.com_20120713_155550'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-13 11:59:35.420'
           ,47692
           ,'2012-07-13 11:59:35.420'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1117
           ,'copier@modulardocument.com_20120713_155535'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-13 12:00:03.970'
           ,47692
           ,'2012-07-13 12:00:03.970'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1118
           ,'REFERRAL (7/12/2012)'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 12:03:43.850'
           ,34037
           ,'2012-07-13 12:03:43.850'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1119
           ,'copier@modulardocument.com_20120713_160311'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-13 12:08:41.577'
           ,47692
           ,'2012-07-13 12:08:41.577'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1120
           ,'copier@modulardocument.com_20120713_160259'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-13 12:09:22.667'
           ,47692
           ,'2012-07-13 12:09:22.667'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1121
           ,'INSURANCE CARD AND ID'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 12:17:39.097'
           ,34037
           ,'2012-07-13 12:17:39.097'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1122
           ,'copier@modulardocument.com_20120713_161710'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-13 12:18:40.663'
           ,47692
           ,'2012-07-13 12:18:40.663'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1123
           ,'copier@modulardocument.com_20120713_161657'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-13 12:19:03.407'
           ,47692
           ,'2012-07-13 12:19:03.407'
           ,47692
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1124
           ,'REFERRAL (6/12/2012)'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 12:19:27.537'
           ,34037
           ,'2012-07-13 12:19:27.537'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1125
           ,'ELIGIBILITY AND BENEFITS'
           ,26
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 12:32:24.770'
           ,34037
           ,'2012-07-13 12:32:24.770'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1126
           ,'REFERRAL (6/28/2012)'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 12:35:07.810'
           ,34037
           ,'2012-07-13 12:35:07.810'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1127
           ,'REFERRAL (6/28/2012)'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 12:36:06.743'
           ,34037
           ,'2012-07-13 12:36:06.743'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1128
           ,'PATIENT ID'
           ,8
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 12:38:15.153'
           ,34037
           ,'2012-07-13 12:38:15.153'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1129
           ,'REFERRAL (4/24/2012)'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 12:39:09.113'
           ,34037
           ,'2012-07-13 12:39:09.113'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1130
           ,'INSURANCE CARD AND ID'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 12:40:20.257'
           ,34037
           ,'2012-07-13 12:40:20.257'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1131
           ,'INSURANCE CARD AND ID'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 12:41:14.520'
           ,34037
           ,'2012-07-13 12:41:14.520'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1132
           ,'ELIGIBILITY AND BENEFITS'
           ,26
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 12:42:24.160'
           ,34037
           ,'2012-07-13 12:42:24.160'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1133
           ,'ID AND INSURANCE CARD'
           ,8
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 12:50:01.180'
           ,34037
           ,'2012-07-13 12:50:01.180'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1134
           ,'STUDENT ID'
           ,8
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 13:23:20.653'
           ,34037
           ,'2012-07-13 13:23:20.653'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1135
           ,'PATIENT ID'
           ,8
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 13:27:35.253'
           ,34037
           ,'2012-07-13 13:27:35.253'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1136
           ,'INSURANCE CARD AND ID'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 13:33:09.420'
           ,34037
           ,'2012-07-13 13:33:09.420'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1137
           ,'REFERRAL (7/12/2012)'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 13:34:15.190'
           ,34037
           ,'2012-07-13 13:34:15.190'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1138
           ,'INSURANCE CARD AND ID'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 13:38:01.743'
           ,34037
           ,'2012-07-13 13:38:01.743'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1139
           ,'REFERRAL (1/11/2012)'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 13:38:29.990'
           ,34037
           ,'2012-07-13 13:38:29.990'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1140
           ,'ELIGIBILITY AND BENEFITS'
           ,26
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 13:38:59.507'
           ,34037
           ,'2012-07-13 13:38:59.507'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1141
           ,'REFERRAL (11/3/2011)'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 13:54:26.603'
           ,34037
           ,'2012-07-13 13:54:26.603'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1142
           ,'INSURANCE CARD AND ID'
           ,9
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 13:56:11.677'
           ,34037
           ,'2012-07-13 13:56:11.677'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1143
           ,'REFERRAL AND VERIFICATION'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>Neat ADF Scanner</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-13 14:02:06.253'
           ,34037
           ,'2012-07-13 14:02:06.253'
           ,34037
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1144
           ,'ELVIRA TORRES INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-16 05:30:13.620'
           ,30553
           ,'2012-07-16 05:30:13.620'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1145
           ,'KAUFMAN INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-16 05:40:12.923'
           ,30553
           ,'2012-07-16 05:40:12.923'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1146
           ,'MARIA BERKULIS INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-16 06:29:11.397'
           ,30553
           ,'2012-07-16 06:29:11.397'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1147
           ,'VANEZZA MCCRAY REF'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-16 06:32:14.123'
           ,30553
           ,'2012-07-16 06:32:14.123'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1148
           ,'PMT DIAZ'
           ,10
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>SHARP MFP TWAIN K</AcquireSourceName><BitDepth>24</BitDepth><PageSize>3</PageSize><PixelType>2</PixelType><Resolution>150</Resolution><ScanningSide>1</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-16 10:08:14.550'
           ,34346
           ,'2012-07-16 18:54:19.343'
           ,30564
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1149
           ,'trevor documents'
           ,7
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-16 10:54:23.583'
           ,30553
           ,'2012-07-16 10:54:23.583'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1150
           ,'JULIA JAMES INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-16 10:55:12.547'
           ,30553
           ,'2012-07-16 10:55:12.547'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1151
           ,'LILLKIAN TOLEDO INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-16 10:56:17.250'
           ,30553
           ,'2012-07-16 10:56:17.250'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1152
           ,'HILDA CARRION INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-16 10:57:31.707'
           ,30553
           ,'2012-07-16 10:57:31.707'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1153
           ,'vivian rodriguez insurance auth'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-16 11:00:32.327'
           ,30553
           ,'2012-07-16 11:00:32.327'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1154
           ,'PINEIRO INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-16 11:23:55.247'
           ,30553
           ,'2012-07-16 11:23:55.247'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1155
           ,'PMT JANER'
           ,10
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>SHARP MFP TWAIN K</AcquireSourceName><BitDepth>1</BitDepth><PageSize>0</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>1</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-16 11:36:18.863'
           ,34346
           ,'2012-07-16 18:55:31.360'
           ,30564
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1156
           ,'REFERRAL (7/16/2012)'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>SHARP MFP TWAIN K</AcquireSourceName><BitDepth>1</BitDepth><PageSize>0</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-16 13:17:32.017'
           ,34346
           ,'2012-07-16 13:17:32.017'
           ,34346
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1157
           ,'REFERRAL (7/16/2012)'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>SHARP MFP TWAIN K</AcquireSourceName><BitDepth>1</BitDepth><PageSize>0</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-16 13:18:28.807'
           ,34346
           ,'2012-07-16 13:18:28.807'
           ,34346
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1158
           ,'REFERRAL'
           ,5
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>SHARP MFP TWAIN K</AcquireSourceName><BitDepth>1</BitDepth><PageSize>0</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>0</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-16 13:20:50.983'
           ,34346
           ,'2012-07-16 13:20:50.983'
           ,34346
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1159
           ,'LORAINE BURCHER INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-17 05:44:31.523'
           ,30553
           ,'2012-07-17 05:44:31.523'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1160
           ,'juan taveras insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-17 06:12:08.767'
           ,30553
           ,'2012-07-17 06:12:08.767'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1161
           ,'humberto insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-17 06:12:40.273'
           ,30553
           ,'2012-07-17 06:12:40.273'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1162
           ,'MARTHA BAUTES INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-17 07:05:17.103'
           ,30553
           ,'2012-07-17 07:05:17.103'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1163
           ,'LEE CHAFFIN INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-17 08:46:38.287'
           ,30553
           ,'2012-07-17 08:46:38.287'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1164
           ,'ramona blanchard insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-17 08:48:03.743'
           ,30553
           ,'2012-07-17 08:48:03.743'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1165
           ,'ALFREDO ACOSTA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-17 08:49:26.787'
           ,30553
           ,'2012-07-17 08:49:26.787'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1166
           ,'PAICH YOUNG INSURANCE REFERRAL'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-17 10:20:02.430'
           ,30553
           ,'2012-07-17 10:20:02.430'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1167
           ,'ANA SOCIAS INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-17 10:29:40.590'
           ,30553
           ,'2012-07-17 10:29:40.590'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1168
           ,'BLANCA PAGAN INSURANCE REF'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-17 10:31:04.787'
           ,30553
           ,'2012-07-17 10:31:04.787'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1169
           ,'RONNIE PRICE INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-17 10:46:15.333'
           ,30553
           ,'2012-07-17 10:46:15.333'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1170
           ,'juana vazquez insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-18 05:06:25.000'
           ,30553
           ,'2012-07-18 05:06:25.000'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1171
           ,'ANITA APOLLO INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-18 05:10:40.110'
           ,30553
           ,'2012-07-18 05:10:40.110'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1172
           ,'copier@modulardocument.com_20120718_093913'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-18 06:05:46.790'
           ,34346
           ,'2012-07-18 06:05:46.790'
           ,34346
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1173
           ,'copier@modulardocument.com_20120718_093900'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-18 06:06:38.160'
           ,34346
           ,'2012-07-18 06:06:38.160'
           ,34346
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1174
           ,'ARNALDO BORGES INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-18 06:18:59.670'
           ,30553
           ,'2012-07-18 06:18:59.670'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1175
           ,'ETHELEAN JAMES '
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-18 06:37:30.447'
           ,34346
           ,'2012-07-18 06:37:30.447'
           ,34346
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1176
           ,'ALINA ALEJO REF ID'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-18 06:40:32.117'
           ,30553
           ,'2012-07-18 06:40:32.117'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1178
           ,'ANA CRESPO NEW INSURANCE CARD JULY'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-18 07:12:29.007'
           ,30553
           ,'2012-07-18 07:12:29.007'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1179
           ,'ROSE SICKINGER INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-18 08:21:48.743'
           ,30553
           ,'2012-07-18 08:21:48.743'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1180
           ,'JUAN MALDONADO INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-18 08:24:41.903'
           ,30553
           ,'2012-07-18 08:24:41.903'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1181
           ,'MARIA CRUZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-18 08:26:48.133'
           ,30553
           ,'2012-07-18 08:26:48.133'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1182
           ,'PAICH YOUNG JULY  NEW VISIT REF'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-18 08:33:06.957'
           ,30553
           ,'2012-07-18 08:33:06.957'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1183
           ,'DAVID CHIMELS INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-18 08:38:32.577'
           ,30553
           ,'2012-07-18 08:38:32.577'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1184
           ,'DIL INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-18 08:39:42.787'
           ,30553
           ,'2012-07-18 08:39:42.787'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1185
           ,'JANE SAENGER INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-18 08:43:13.780'
           ,30553
           ,'2012-07-18 08:43:13.780'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1186
           ,'DIANNA PIERSON INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-18 08:52:09.290'
           ,30553
           ,'2012-07-18 08:52:09.290'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1187
           ,'LINDA SHELTLE INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-18 08:53:46.220'
           ,30553
           ,'2012-07-18 08:53:46.220'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1189
           ,'ESTHER BAEZ'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-18 09:51:07.980'
           ,34346
           ,'2012-07-18 09:51:07.980'
           ,34346
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1190
           ,'VIVIAN RODRIGUEZ'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-18 09:52:07.653'
           ,34346
           ,'2012-07-18 09:52:07.653'
           ,34346
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1191
           ,'RHONDA FOWLER'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-18 09:53:33.837'
           ,34346
           ,'2012-07-18 09:53:33.837'
           ,34346
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1192
           ,'IRMA LIGON INSURANCE REF'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-18 13:48:11.933'
           ,30553
           ,'2012-07-18 13:48:11.933'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1193
           ,'KENETH MOYER INSURANCE REF'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-19 05:18:54.850'
           ,30553
           ,'2012-07-19 05:18:54.850'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1194
           ,'NOEMA ALVAREZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-19 05:26:33.183'
           ,30553
           ,'2012-07-19 05:26:33.183'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1195
           ,'ALBA MULERO INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-19 05:30:22.923'
           ,30553
           ,'2012-07-19 05:30:22.923'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1196
           ,'ADRIAN PERLAZA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-19 05:34:24.837'
           ,30553
           ,'2012-07-19 05:34:24.837'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1197
           ,'GLADYS SUARES INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-19 05:36:30.763'
           ,30553
           ,'2012-07-19 05:36:30.763'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1198
           ,'AURORA PROVENZANO REF JULY'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-19 05:41:45.953'
           ,30553
           ,'2012-07-19 05:41:45.953'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1199
           ,'TERESA CORREA REF JULY VISIT '
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-19 05:44:27.380'
           ,30553
           ,'2012-07-19 05:44:27.380'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1200
           ,'MARYLIN MARTINEZ INSURANCE REF'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-19 06:48:58.440'
           ,30553
           ,'2012-07-19 06:48:58.440'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1201
           ,'MARIANELA SOTO INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-19 06:52:56.577'
           ,30553
           ,'2012-07-19 06:52:56.577'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1202
           ,'MARY DAY NEW INSURANCE CARD'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-19 06:55:11.170'
           ,30553
           ,'2012-07-19 06:55:11.170'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1203
           ,'NARCISA ROSALES INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-19 06:56:05.843'
           ,30553
           ,'2012-07-19 06:56:05.843'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1204
           ,'MISTY TRACEY INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-19 06:56:53.340'
           ,30553
           ,'2012-07-19 06:56:53.340'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1205
           ,'CASTRO ROBINSON INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-19 06:57:38.907'
           ,30553
           ,'2012-07-19 06:57:38.907'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1206
           ,'SANDRA HELMS INSURANC REF JULY '
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-19 07:00:53.710'
           ,30553
           ,'2012-07-19 07:00:53.710'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1207
           ,'JENNIFER ALLEN REF JULY'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-19 07:02:52.110'
           ,30553
           ,'2012-07-19 07:02:52.110'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1208
           ,'BOYD INSURANCE REF'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-19 07:07:25.897'
           ,30553
           ,'2012-07-19 07:07:25.897'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1209
           ,'MARIE DOVE'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-19 07:08:01.263'
           ,34346
           ,'2012-07-19 07:08:01.263'
           ,34346
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1210
           ,'BARBARA JEREZ REF INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-19 07:09:07.903'
           ,30553
           ,'2012-07-19 07:09:07.903'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1211
           ,'LUCIA JIMENEZ'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-19 07:09:18.200'
           ,34346
           ,'2012-07-19 07:09:18.200'
           ,34346
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1212
           ,'ANTONIA COTTO INSURNACE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-19 07:09:48.220'
           ,30553
           ,'2012-07-19 07:09:48.220'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1214
           ,'CHMIELEWSKI INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-19 07:14:22.443'
           ,30553
           ,'2012-07-19 07:14:22.443'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1215
           ,'ANA SOTO REF JULY'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-19 07:34:44.420'
           ,30553
           ,'2012-07-19 07:34:44.420'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1216
           ,'STEPHEN OSTER INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-19 08:18:26.677'
           ,30553
           ,'2012-07-19 08:18:26.677'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1218
           ,'RAMLOW REF JULY '
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-19 08:29:13.077'
           ,30553
           ,'2012-07-19 08:29:13.077'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1219
           ,'GRISEL GONZALEZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-19 08:31:16.030'
           ,30553
           ,'2012-07-19 08:31:16.030'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1220
           ,'dupont'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-19 08:39:06.930'
           ,30553
           ,'2012-07-19 08:39:06.930'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1221
           ,'BEATRIZ VARELA ID'
           ,8
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-19 10:53:47.047'
           ,30553
           ,'2012-07-19 10:53:47.047'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1222
           ,'MARIA FLEITAS INSURANCE'
           ,8
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-19 10:55:05.913'
           ,30553
           ,'2012-07-19 10:55:05.913'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1223
           ,'KHAW'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-19 10:55:56.250'
           ,30553
           ,'2012-07-19 10:55:56.250'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1224
           ,'ALBERT SINICROPE INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-19 10:56:47.753'
           ,30553
           ,'2012-07-19 10:56:47.753'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1225
           ,'carolyn simms insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-19 12:10:59.783'
           ,30553
           ,'2012-07-19 12:10:59.783'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1226
           ,'IRIS SASTRE INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-20 06:01:59.587'
           ,30553
           ,'2012-07-20 06:01:59.587'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1228
           ,'KATHERINE GARCIA'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-20 06:54:33.947'
           ,34346
           ,'2012-07-20 06:54:33.947'
           ,34346
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1229
           ,'ANA SOTO'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-20 06:55:11.517'
           ,34346
           ,'2012-07-20 06:55:11.517'
           ,34346
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1230
           ,'DOMINGA LOPEZ'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-20 06:55:51.063'
           ,34346
           ,'2012-07-20 06:55:51.063'
           ,34346
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1231
           ,'REFERRAL'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-20 07:18:10.017'
           ,34346
           ,'2012-07-20 07:18:10.017'
           ,34346
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1232
           ,'JOSE PEREZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-20 07:55:45.330'
           ,30553
           ,'2012-07-20 07:55:45.330'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1233
           ,'MC DONE'
           ,13
           ,2
           ,'MC 7-20-12'
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>SHARP MFP TWAIN K</AcquireSourceName><BitDepth>1</BitDepth><PageSize>0</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>1</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-20 08:59:44.993'
           ,34346
           ,'2012-07-20 12:01:35.990'
           ,30563
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1234
           ,'PMT DIAZ (7/20/2012)'
           ,10
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>SHARP MFP TWAIN K</AcquireSourceName><BitDepth>1</BitDepth><PageSize>0</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>1</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-20 09:08:10.637'
           ,34346
           ,'2012-07-20 11:53:02.193'
           ,30564
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1235
           ,'AVERY INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-20 09:29:18.540'
           ,30553
           ,'2012-07-20 09:29:18.540'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1236
           ,'GAYLE INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-20 09:29:46.147'
           ,30553
           ,'2012-07-20 09:29:46.147'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1237
           ,'PMT JANER (7/20/2012)'
           ,10
           ,1
           ,NULL
           ,'<?xml version="1.0" encoding="utf-8"?><ScanSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><AcquireSourceName>SHARP MFP TWAIN K</AcquireSourceName><BitDepth>1</BitDepth><PageSize>3</PageSize><PixelType>0</PixelType><Resolution>150</Resolution><ScanningSide>1</ScanningSide><Brightness>0</Brightness><Contrast>0</Contrast><FeederEnabled>true</FeederEnabled></ScanSettings>'
           ,NULL
           ,1
           ,'2012-07-20 09:35:40.287'
           ,34037
           ,'2012-07-20 11:53:12.857'
           ,30564
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1238
           ,'AUSTIN INSURANCE REF'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-20 11:02:38.957'
           ,30553
           ,'2012-07-20 11:02:38.957'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1239
           ,'MAIDA RUIZ REFERRAL'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-20 11:03:57.773'
           ,30553
           ,'2012-07-20 11:03:57.773'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1240
           ,'PATRICIA SANTANA REF JULY'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-20 11:05:28.813'
           ,30553
           ,'2012-07-20 11:05:28.813'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1241
           ,'JUNE NORTHCUT JULY REF'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-20 11:06:15.453'
           ,30553
           ,'2012-07-20 11:06:15.453'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1242
           ,'ZONIA BArrios insurance'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-20 11:09:34.130'
           ,30553
           ,'2012-07-20 11:09:34.130'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1243
           ,'MAMI HASTY INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-20 11:10:45.903'
           ,30553
           ,'2012-07-20 11:10:45.903'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1244
           ,'DOROTHY HAYES REF'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-20 11:12:30.357'
           ,30553
           ,'2012-07-20 11:12:30.357'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1245
           ,'LUELA INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-20 11:13:41.120'
           ,30553
           ,'2012-07-20 11:13:41.120'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1246
           ,'MIRTHA ESCALONA ID'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-20 11:32:37.343'
           ,30553
           ,'2012-07-20 11:32:37.343'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1247
           ,'NIEVES ORTIZ INSURANCE'
           ,8
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-20 13:10:17.607'
           ,30553
           ,'2012-07-20 13:10:17.607'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1248
           ,'PATRICIA ROBEY INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-20 13:11:17.760'
           ,30553
           ,'2012-07-20 13:11:17.760'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1249
           ,'MICHELE SCARPON REF'
           ,5
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-20 13:12:31.400'
           ,30553
           ,'2012-07-20 13:12:31.400'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1250
           ,'STEVENS INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-20 13:16:44.477'
           ,30553
           ,'2012-07-20 13:16:44.477'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1251
           ,'ANA MARTINEZ INSURANCE'
           ,9
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-20 13:17:47.217'
           ,30553
           ,'2012-07-20 13:17:47.217'
           ,30553
           ,2
           );
INSERT INTO #dms_doc
         ([DMSDocumentID]
         ,[DocumentName]
         ,[DocumentLabelTypeID]
         ,[DocumentStatusTypeID]
         ,[Notes]
         ,[Properties]
         ,[OriginalDMSDocumentID]
         ,[DocumentTypeID]
         ,[CreatedDate]
         ,[CreatedUserID]
         ,[ModifiedDate]
         ,[ModifiedUserID]
         ,[PracticeID])
     VALUES
           (1252
           ,'STONE REF JULY'
           ,25
           ,2
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,'2012-07-20 13:21:14.580'
           ,30553
           ,'2012-07-20 13:21:14.580'
           ,30553
           ,2
           );
           
IF @is_debug = 1 
    BEGIN
        SELECT  [DMSDocumentID] ,
                [DocumentName] ,
                [DocumentLabelTypeID] ,
                [DocumentStatusTypeID] ,
                CAST([Notes] AS VARCHAR(MAX)) ,
                CAST([Properties] AS VARCHAR(MAX)) ,
                [OriginalDMSDocumentID] ,
                [DocumentTypeID] ,
                [CreatedDate] ,
                [CreatedUserID] ,
                [ModifiedDate] ,
                [ModifiedUserID] ,
                [PracticeID]
        FROM    #dms_doc AS TDD
        EXCEPT
        SELECT  [DMSDocumentID] ,
                [DocumentName] ,
                [DocumentLabelTypeID] ,
                [DocumentStatusTypeID] ,
                CAST([Notes] AS VARCHAR(MAX)) ,
                CAST([Properties] AS VARCHAR(MAX)) ,
                [OriginalDMSDocumentID] ,
                [DocumentTypeID] ,
                [CreatedDate] ,
                [CreatedUserID] ,
                [ModifiedDate] ,
                [ModifiedUserID] ,
                [PracticeID]
        FROM    dbo.DMSDocument AS DD;

        SELECT  @@ROWCOUNT AS 'Diff - By columns';

        SELECT  [DMSDocumentID]
        FROM    #dms_doc AS TDD
        EXCEPT
        SELECT  [DMSDocumentID]
        FROM    dbo.DMSDocument AS DD;

        SELECT  @@ROWCOUNT AS 'Diff - By DMSDocumentID';

        SELECT  COUNT(*) AS '#dms_doc'
        FROM    #dms_doc;

        SELECT  COUNT(*) AS 'dbo.DMSDocument'
        FROM    dbo.DMSDocument;
    END

IF @is_debug = 0 
    BEGIN
        BEGIN TRANSACTION;
        SET IDENTITY_INSERT dbo.DMSDocument ON;
   
        INSERT  INTO [dbo].[DMSDocument]
                ( [DMSDocumentID] ,
                  [DocumentName] ,
                  [DocumentLabelTypeID] ,
                  [DocumentStatusTypeID] ,
                  [Notes] ,
                  [Properties] ,
                  [OriginalDMSDocumentID] ,
                  [DocumentTypeID] ,
                  [CreatedDate] ,
                  [CreatedUserID] ,
                  [ModifiedDate] ,
                  [ModifiedUserID] ,
                  [PracticeID]
                )
                SELECT  [DMSDocumentID] ,
                        [DocumentName] ,
                        [DocumentLabelTypeID] ,
                        [DocumentStatusTypeID] ,
                        CAST([Notes] AS VARCHAR(MAX)) ,
                        CAST([Properties] AS VARCHAR(MAX)) ,
                        [OriginalDMSDocumentID] ,
                        [DocumentTypeID] ,
                        [CreatedDate] ,
                        [CreatedUserID] ,
                        [ModifiedDate] ,
                        [ModifiedUserID] ,
                        [PracticeID]
                FROM    #dms_doc AS TDD
                EXCEPT
                SELECT  [DMSDocumentID] ,
                        [DocumentName] ,
                        [DocumentLabelTypeID] ,
                        [DocumentStatusTypeID] ,
                        CAST([Notes] AS VARCHAR(MAX)) ,
                        CAST([Properties] AS VARCHAR(MAX)) ,
                        [OriginalDMSDocumentID] ,
                        [DocumentTypeID] ,
                        [CreatedDate] ,
                        [CreatedUserID] ,
                        [ModifiedDate] ,
                        [ModifiedUserID] ,
                        [PracticeID]
                FROM    dbo.DMSDocument AS DD;
                
        SELECT  @@ROWCOUNT AS 'Inserted';
        SET IDENTITY_INSERT dbo.DMSDocument OFF;
        COMMIT;
    END
GO

IF OBJECT_ID('tempdb..#dms_doc') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#dms_doc;
    END
GO