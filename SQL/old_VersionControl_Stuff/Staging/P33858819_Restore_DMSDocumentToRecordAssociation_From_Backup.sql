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
IF OBJECT_ID('tempdb..#dms_to_rec') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#dms_to_rec;
    END
GO

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

DECLARE @is_debug AS BIT;
SET @is_debug = 0;

CREATE TABLE #dms_to_rec
    (
      [DMSDocumentID] [int] NOT NULL ,
      [RecordID] [int] NOT NULL ,
      [RecordTypeID] [int] NOT NULL ,
      [ModifiedUserID] [int] NOT NULL ,
      [ModifiedDate] [datetime] NOT NULL ,
      [CreatedUserID] [int] NOT NULL ,
      [CreatedDate] [datetime] NOT NULL ,
      [RecordTimeStamp] [timestamp] NOT NULL
    );

INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           ( 1231          ,3316
           ,1
           ,34346
           ,'2012-07-20 07:18:10.023'
           ,34346
           ,'2012-07-20 07:18:10.023'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1223
           ,3300
           ,1
           ,30553
           ,'2012-07-19 10:55:56.270'
           ,30553
           ,'2012-07-19 10:55:56.270'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1181
           ,3296
           ,1
           ,30553
           ,'2012-07-18 08:26:48.140'
           ,30553
           ,'2012-07-18 08:26:48.140'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1246
           ,3294
           ,1
           ,30553
           ,'2012-07-20 11:32:37.353'
           ,30553
           ,'2012-07-20 11:32:37.353'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1172
           ,3291
           ,1
           ,34346
           ,'2012-07-18 06:05:46.803'
           ,34346
           ,'2012-07-18 06:05:46.803'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1222
           ,3282
           ,1
           ,30553
           ,'2012-07-19 10:55:05.923'
           ,30553
           ,'2012-07-19 10:55:05.923'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1196
           ,3278
           ,1
           ,30553
           ,'2012-07-19 05:34:24.850'
           ,30553
           ,'2012-07-19 05:34:24.850'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1069
           ,3270
           ,1
           ,47692
           ,'2012-07-12 13:50:16.487'
           ,47692
           ,'2012-07-12 13:50:16.487'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1068
           ,3270
           ,1
           ,47692
           ,'2012-07-12 13:49:56.453'
           ,47692
           ,'2012-07-12 13:49:56.453'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1211
           ,3268
           ,1
           ,34346
           ,'2012-07-19 07:09:18.217'
           ,34346
           ,'2012-07-19 07:09:18.217'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1052
           ,3263
           ,1
           ,47692
           ,'2012-07-11 12:42:29.110'
           ,47692
           ,'2012-07-11 12:42:29.110'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1051
           ,3263
           ,1
           ,47692
           ,'2012-07-11 12:40:55.323'
           ,47692
           ,'2012-07-11 12:40:55.323'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1050
           ,3263
           ,1
           ,47692
           ,'2012-07-11 12:40:21.203'
           ,47692
           ,'2012-07-11 12:40:21.203'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1049
           ,3260
           ,1
           ,47692
           ,'2012-07-11 09:38:57.650'
           ,47692
           ,'2012-07-11 09:38:57.650'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1048
           ,3260
           ,1
           ,47692
           ,'2012-07-11 09:38:35.883'
           ,47692
           ,'2012-07-11 09:38:35.883'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1047
           ,3260
           ,1
           ,47692
           ,'2012-07-11 09:37:57.880'
           ,47692
           ,'2012-07-11 09:37:57.880'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1028
           ,3258
           ,1
           ,47692
           ,'2012-07-10 10:59:48.207'
           ,47692
           ,'2012-07-10 10:59:48.207'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1027
           ,3258
           ,1
           ,47692
           ,'2012-07-10 10:59:28.060'
           ,47692
           ,'2012-07-10 10:59:28.060'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1017
           ,3250
           ,1
           ,47692
           ,'2012-07-09 13:17:22.160'
           ,47692
           ,'2012-07-09 13:17:22.160'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1016
           ,3250
           ,1
           ,47692
           ,'2012-07-09 13:17:02.857'
           ,47692
           ,'2012-07-09 13:17:02.857'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1015
           ,3249
           ,1
           ,47692
           ,'2012-07-09 12:13:39.580'
           ,47692
           ,'2012-07-09 12:13:39.580'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1014
           ,3249
           ,1
           ,47692
           ,'2012-07-09 12:12:54.833'
           ,47692
           ,'2012-07-09 12:12:54.833'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1013
           ,3248
           ,1
           ,47692
           ,'2012-07-09 11:43:10.533'
           ,47692
           ,'2012-07-09 11:43:10.533'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1012
           ,3248
           ,1
           ,47692
           ,'2012-07-09 11:42:45.620'
           ,47692
           ,'2012-07-09 11:42:45.620'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1226
           ,3247
           ,1
           ,30553
           ,'2012-07-20 06:01:59.603'
           ,30553
           ,'2012-07-20 06:01:59.603'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1220
           ,3242
           ,1
           ,30553
           ,'2012-07-19 08:39:06.937'
           ,30553
           ,'2012-07-19 08:39:06.937'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (996
           ,3239
           ,1
           ,47692
           ,'2012-07-09 06:54:00.207'
           ,47692
           ,'2012-07-09 06:54:00.207'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (994
           ,3239
           ,1
           ,47692
           ,'2012-07-09 06:52:07.320'
           ,47692
           ,'2012-07-09 06:52:07.320'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (993
           ,3239
           ,1
           ,47692
           ,'2012-07-09 06:51:34.190'
           ,47692
           ,'2012-07-09 06:51:34.190'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1165
           ,3238
           ,1
           ,30553
           ,'2012-07-17 08:49:26.797'
           ,30553
           ,'2012-07-17 08:49:26.797'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1186
           ,3237
           ,1
           ,30553
           ,'2012-07-18 08:52:09.310'
           ,30553
           ,'2012-07-18 08:52:09.310'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (885
           ,3234
           ,1
           ,47692
           ,'2012-07-06 11:23:23.377'
           ,47692
           ,'2012-07-06 11:23:23.377'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (884
           ,3234
           ,1
           ,47692
           ,'2012-07-06 11:12:35.730'
           ,47692
           ,'2012-07-06 11:12:35.730'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (883
           ,3234
           ,1
           ,47692
           ,'2012-07-06 11:12:11.987'
           ,47692
           ,'2012-07-06 11:12:11.987'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1183
           ,3211
           ,1
           ,30553
           ,'2012-07-18 08:38:32.590'
           ,30553
           ,'2012-07-18 08:38:32.590'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (837
           ,3205
           ,1
           ,30553
           ,'2012-07-02 08:02:58.140'
           ,30553
           ,'2012-07-02 08:02:58.140'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1144
           ,3201
           ,1
           ,30553
           ,'2012-07-16 05:30:13.710'
           ,30553
           ,'2012-07-16 05:30:13.710'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1210
           ,3198
           ,1
           ,30553
           ,'2012-07-19 07:09:07.913'
           ,30553
           ,'2012-07-19 07:09:07.913'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (858
           ,3197
           ,1
           ,30553
           ,'2012-07-03 10:35:56.113'
           ,30553
           ,'2012-07-03 10:35:56.113'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1182
           ,3185
           ,1
           ,30553
           ,'2012-07-18 08:33:06.970'
           ,30553
           ,'2012-07-18 08:33:06.970'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1166
           ,3185
           ,1
           ,30553
           ,'2012-07-17 10:20:02.447'
           ,30553
           ,'2012-07-17 10:20:02.447'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (783
           ,3182
           ,1
           ,30553
           ,'2012-06-26 06:16:03.030'
           ,30553
           ,'2012-06-26 06:16:03.030'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (777
           ,3180
           ,1
           ,30553
           ,'2012-06-26 05:01:39.823'
           ,30553
           ,'2012-06-26 05:01:39.823'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1168
           ,3176
           ,1
           ,30553
           ,'2012-07-17 10:31:05.280'
           ,30553
           ,'2012-07-17 10:31:05.280'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (859
           ,3174
           ,1
           ,30553
           ,'2012-07-03 10:52:34.200'
           ,30553
           ,'2012-07-03 10:52:34.200'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (789
           ,3167
           ,1
           ,30553
           ,'2012-06-26 11:28:34.767'
           ,30553
           ,'2012-06-26 11:28:34.767'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (799
           ,3164
           ,1
           ,30553
           ,'2012-06-27 07:53:55.750'
           ,30553
           ,'2012-06-27 07:53:55.750'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (748
           ,3162
           ,1
           ,30553
           ,'2012-06-25 05:31:53.633'
           ,30553
           ,'2012-06-25 05:31:53.633'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1221
           ,3160
           ,1
           ,30553
           ,'2012-07-19 10:53:47.523'
           ,30553
           ,'2012-07-19 10:53:47.523'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (707
           ,3152
           ,1
           ,30553
           ,'2012-06-20 13:07:45.857'
           ,30553
           ,'2012-06-20 13:07:45.857'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1149
           ,3151
           ,1
           ,30553
           ,'2012-07-16 10:54:23.603'
           ,30553
           ,'2012-07-16 10:54:23.603'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (727
           ,3148
           ,1
           ,30553
           ,'2012-06-21 11:49:02.280'
           ,30553
           ,'2012-06-21 11:49:02.280'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (854
           ,3147
           ,1
           ,30553
           ,'2012-07-03 08:32:41.340'
           ,30553
           ,'2012-07-03 08:32:41.340'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (793
           ,3144
           ,1
           ,30553
           ,'2012-06-27 06:10:02.873'
           ,30553
           ,'2012-06-27 06:10:02.873'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (709
           ,3142
           ,1
           ,30553
           ,'2012-06-21 06:04:05.760'
           ,30553
           ,'2012-06-21 06:04:05.760'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (786
           ,3140
           ,1
           ,30553
           ,'2012-06-26 07:48:41.630'
           ,30553
           ,'2012-06-26 07:48:41.630'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (850
           ,3137
           ,1
           ,30553
           ,'2012-07-03 08:27:53.170'
           ,30553
           ,'2012-07-03 08:27:53.170'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (700
           ,3136
           ,1
           ,30553
           ,'2012-06-20 08:27:07.783'
           ,30553
           ,'2012-06-20 08:27:07.783'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (804
           ,3133
           ,1
           ,30553
           ,'2012-06-28 06:28:54.963'
           ,30553
           ,'2012-06-28 06:28:54.963'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (751
           ,3128
           ,1
           ,30553
           ,'2012-06-25 07:19:42.843'
           ,30553
           ,'2012-06-25 07:19:42.843'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (686
           ,3125
           ,1
           ,30553
           ,'2012-06-19 08:15:07.930'
           ,30553
           ,'2012-06-19 08:15:07.930'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (672
           ,3124
           ,1
           ,30553
           ,'2012-06-18 11:13:59.340'
           ,30553
           ,'2012-06-18 11:13:59.340'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (690
           ,3123
           ,1
           ,30553
           ,'2012-06-19 11:13:28.930'
           ,30553
           ,'2012-06-19 11:13:28.930'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (628
           ,3119
           ,1
           ,30553
           ,'2012-06-15 10:37:20.847'
           ,30553
           ,'2012-06-15 10:37:20.847'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (697
           ,3117
           ,1
           ,30553
           ,'2012-06-20 08:22:40.900'
           ,30553
           ,'2012-06-20 08:22:40.900'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (689
           ,3115
           ,1
           ,30553
           ,'2012-06-19 10:52:44.720'
           ,30553
           ,'2012-06-19 10:52:44.720'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (815
           ,3114
           ,1
           ,30553
           ,'2012-06-29 07:22:37.717'
           ,30553
           ,'2012-06-29 07:22:37.717'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1228
           ,3110
           ,1
           ,34346
           ,'2012-07-20 06:54:33.953'
           ,34346
           ,'2012-07-20 06:54:33.953'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (678
           ,3110
           ,1
           ,30553
           ,'2012-06-18 12:09:57.840'
           ,30553
           ,'2012-06-18 12:09:57.840'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (593
           ,3109
           ,1
           ,30553
           ,'2012-06-13 11:03:22.100'
           ,30553
           ,'2012-06-13 11:03:22.100'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (692
           ,3107
           ,1
           ,30553
           ,'2012-06-20 05:23:34.223'
           ,30553
           ,'2012-06-20 05:23:34.223'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (585
           ,3104
           ,1
           ,30553
           ,'2012-06-13 07:56:55.027'
           ,30553
           ,'2012-06-13 07:56:55.027'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (614
           ,3102
           ,1
           ,30553
           ,'2012-06-14 10:31:11.417'
           ,30553
           ,'2012-06-14 10:31:11.417'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (668
           ,3100
           ,1
           ,30553
           ,'2012-06-18 06:33:51.107'
           ,30553
           ,'2012-06-18 06:33:51.107'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (667
           ,3099
           ,1
           ,30553
           ,'2012-06-18 05:59:50.973'
           ,30553
           ,'2012-06-18 05:59:50.973'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (584
           ,3098
           ,1
           ,30553
           ,'2012-06-13 07:35:30.090'
           ,30553
           ,'2012-06-13 07:35:30.090'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (598
           ,3097
           ,1
           ,30553
           ,'2012-06-14 04:57:25.133'
           ,30553
           ,'2012-06-14 04:57:25.133'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (500
           ,3096
           ,1
           ,30553
           ,'2012-06-08 08:27:10.397'
           ,30553
           ,'2012-06-08 08:27:10.397'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (633
           ,3095
           ,1
           ,30553
           ,'2012-06-15 10:58:49.927'
           ,30553
           ,'2012-06-15 10:58:49.927'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (590
           ,3094
           ,1
           ,30553
           ,'2012-06-13 10:14:31.863'
           ,30553
           ,'2012-06-13 10:14:31.863'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (600
           ,3093
           ,1
           ,30553
           ,'2012-06-14 05:04:49.997'
           ,30553
           ,'2012-06-14 05:04:49.997'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (632
           ,3087
           ,1
           ,30553
           ,'2012-06-15 10:46:48.320'
           ,30553
           ,'2012-06-15 10:46:48.320'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (602
           ,3087
           ,1
           ,30553
           ,'2012-06-14 05:09:35.197'
           ,30553
           ,'2012-06-14 05:09:35.197'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (480
           ,3082
           ,1
           ,30553
           ,'2012-06-07 09:45:47.330'
           ,30553
           ,'2012-06-07 09:45:47.330'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (445
           ,3079
           ,1
           ,30553
           ,'2012-06-06 04:52:52.410'
           ,30553
           ,'2012-06-06 04:52:52.410'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (604
           ,3076
           ,1
           ,30553
           ,'2012-06-14 05:46:30.270'
           ,30553
           ,'2012-06-14 05:46:30.270'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (447
           ,3073
           ,1
           ,30553
           ,'2012-06-06 09:42:38.610'
           ,30553
           ,'2012-06-06 09:42:38.610'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (468
           ,3069
           ,1
           ,30553
           ,'2012-06-06 12:09:30.803'
           ,30553
           ,'2012-06-06 12:09:30.803'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1066
           ,3068
           ,1
           ,47692
           ,'2012-07-12 11:50:53.823'
           ,47692
           ,'2012-07-12 11:50:53.823'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1065
           ,3068
           ,1
           ,47692
           ,'2012-07-12 11:50:04.723'
           ,47692
           ,'2012-07-12 11:50:04.723'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (464
           ,3066
           ,1
           ,30553
           ,'2012-06-06 10:24:27.820'
           ,30553
           ,'2012-06-06 10:24:27.820'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (493
           ,3065
           ,1
           ,30553
           ,'2012-06-08 05:17:26.423'
           ,30553
           ,'2012-06-08 05:17:26.423'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (409
           ,3052
           ,1
           ,30553
           ,'2012-06-05 04:09:43.900'
           ,30553
           ,'2012-06-05 04:09:43.900'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (694
           ,3051
           ,1
           ,30553
           ,'2012-06-20 08:20:30.403'
           ,30553
           ,'2012-06-20 08:20:30.403'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (802
           ,3049
           ,1
           ,30553
           ,'2012-06-27 10:44:37.340'
           ,30553
           ,'2012-06-27 10:44:37.340'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (821
           ,3048
           ,1
           ,30553
           ,'2012-06-29 09:38:30.300'
           ,30553
           ,'2012-06-29 09:38:30.300'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (331
           ,3045
           ,1
           ,30553
           ,'2012-05-30 10:54:23.790'
           ,30553
           ,'2012-05-30 10:54:23.790'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (338
           ,3041
           ,1
           ,30553
           ,'2012-05-30 11:32:15.840'
           ,30553
           ,'2012-05-30 11:32:15.840'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (427
           ,3039
           ,1
           ,30553
           ,'2012-06-05 04:47:32.960'
           ,30553
           ,'2012-06-05 04:47:32.960'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (442
           ,3038
           ,1
           ,30553
           ,'2012-06-06 04:25:05.660'
           ,30553
           ,'2012-06-06 04:25:05.660'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (813
           ,3037
           ,1
           ,30553
           ,'2012-06-28 11:34:57.897'
           ,30553
           ,'2012-06-28 11:34:57.897'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (880
           ,3032
           ,1
           ,30553
           ,'2012-07-05 13:01:23.343'
           ,30553
           ,'2012-07-05 13:01:23.343'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (446
           ,3031
           ,1
           ,30553
           ,'2012-06-06 05:15:04.117'
           ,30553
           ,'2012-06-06 05:15:04.117'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (832
           ,3023
           ,1
           ,30553
           ,'2012-06-29 10:27:03.533'
           ,30553
           ,'2012-06-29 10:27:03.533'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (288
           ,3020
           ,1
           ,30553
           ,'2012-05-29 09:56:45.093'
           ,30553
           ,'2012-05-29 09:56:45.093'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (467
           ,3014
           ,1
           ,30553
           ,'2012-06-06 11:36:24.803'
           ,30553
           ,'2012-06-06 11:36:24.803'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (298
           ,3009
           ,1
           ,30553
           ,'2012-05-29 12:11:03.220'
           ,30553
           ,'2012-05-29 12:11:03.220'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (336
           ,3007
           ,1
           ,30553
           ,'2012-05-30 11:14:16.517'
           ,30553
           ,'2012-05-30 11:14:16.517'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (335
           ,3007
           ,1
           ,30553
           ,'2012-05-30 11:13:27.760'
           ,30553
           ,'2012-05-30 11:13:27.760'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (496
           ,3005
           ,1
           ,30553
           ,'2012-06-08 07:19:10.983'
           ,30553
           ,'2012-06-08 07:19:10.983'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (513
           ,3003
           ,1
           ,30553
           ,'2012-06-08 10:19:14.480'
           ,30553
           ,'2012-06-08 10:19:14.480'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (268
           ,3003
           ,1
           ,30553
           ,'2012-05-24 13:29:52.620'
           ,30553
           ,'2012-05-24 13:29:52.620'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (326
           ,3000
           ,1
           ,30553
           ,'2012-05-30 09:16:21.557'
           ,30553
           ,'2012-05-30 09:16:21.557'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (239
           ,2993
           ,1
           ,30553
           ,'2012-05-24 06:11:41.633'
           ,30553
           ,'2012-05-24 06:11:41.633'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (297
           ,2988
           ,1
           ,30553
           ,'2012-05-29 12:00:23.303'
           ,30553
           ,'2012-05-29 12:00:23.303'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (247
           ,2987
           ,1
           ,30553
           ,'2012-05-24 06:23:20.373'
           ,30553
           ,'2012-05-24 06:23:20.373'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (842
           ,2983
           ,1
           ,30553
           ,'2012-07-03 06:39:24.437'
           ,30553
           ,'2012-07-03 06:39:24.437'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (250
           ,2983
           ,1
           ,30553
           ,'2012-05-24 08:27:10.400'
           ,30553
           ,'2012-05-24 08:27:10.400'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (264
           ,2982
           ,1
           ,30553
           ,'2012-05-24 12:04:24.897'
           ,30553
           ,'2012-05-24 12:04:24.897'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (698
           ,2981
           ,1
           ,30553
           ,'2012-06-20 08:25:15.660'
           ,30553
           ,'2012-06-20 08:25:15.660'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (601
           ,2979
           ,1
           ,30553
           ,'2012-06-14 05:07:43.247'
           ,30553
           ,'2012-06-14 05:07:43.247'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (324
           ,2974
           ,1
           ,30553
           ,'2012-05-30 09:05:48.147'
           ,30553
           ,'2012-05-30 09:05:48.147'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (322
           ,2974
           ,1
           ,30553
           ,'2012-05-30 09:04:56.117'
           ,30553
           ,'2012-05-30 09:04:56.117'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (283
           ,2971
           ,1
           ,30553
           ,'2012-05-29 05:53:59.170'
           ,30553
           ,'2012-05-29 05:53:59.170'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (302
           ,2970
           ,1
           ,30553
           ,'2012-05-29 12:14:39.400'
           ,30553
           ,'2012-05-29 12:14:39.400'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (577
           ,2966
           ,1
           ,30553
           ,'2012-06-13 06:02:47.067'
           ,30553
           ,'2012-06-13 06:02:47.067'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (292
           ,2965
           ,1
           ,30553
           ,'2012-05-29 09:59:07.127'
           ,30553
           ,'2012-05-29 09:59:07.127'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1180
           ,2964
           ,1
           ,30553
           ,'2012-07-18 08:24:41.917'
           ,30553
           ,'2012-07-18 08:24:41.917'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (305
           ,2963
           ,1
           ,30553
           ,'2012-05-29 13:09:27.873'
           ,30553
           ,'2012-05-29 13:09:27.873'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (498
           ,2961
           ,1
           ,30553
           ,'2012-06-08 08:25:00.213'
           ,30553
           ,'2012-06-08 08:25:00.213'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (216
           ,2958
           ,1
           ,30553
           ,'2012-05-21 10:48:41.840'
           ,30553
           ,'2012-05-21 10:48:41.840'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (215
           ,2957
           ,1
           ,30553
           ,'2012-05-21 10:21:01.213'
           ,30553
           ,'2012-05-21 10:21:01.213'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (592
           ,2955
           ,1
           ,30553
           ,'2012-06-13 10:42:33.517'
           ,30553
           ,'2012-06-13 10:42:33.517'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (591
           ,2955
           ,1
           ,30553
           ,'2012-06-13 10:42:14.900'
           ,30553
           ,'2012-06-13 10:42:14.900'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1201
           ,2954
           ,1
           ,30553
           ,'2012-07-19 06:52:56.587'
           ,30553
           ,'2012-07-19 06:52:56.587'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1247
           ,2953
           ,1
           ,30553
           ,'2012-07-20 13:10:17.620'
           ,30553
           ,'2012-07-20 13:10:17.620'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (555
           ,2949
           ,1
           ,30553
           ,'2012-06-12 05:21:27.090'
           ,30553
           ,'2012-06-12 05:21:27.090'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1200
           ,2948
           ,1
           ,30553
           ,'2012-07-19 06:48:58.450'
           ,30553
           ,'2012-07-19 06:48:58.450'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (722
           ,2946
           ,1
           ,30553
           ,'2012-06-21 10:30:10.723'
           ,30553
           ,'2012-06-21 10:30:10.723'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (417
           ,2943
           ,1
           ,30553
           ,'2012-06-05 04:27:22.300'
           ,30553
           ,'2012-06-05 04:27:22.300'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (345
           ,2942
           ,1
           ,30553
           ,'2012-05-30 12:12:59.330'
           ,30553
           ,'2012-05-30 12:12:59.330'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1030
           ,2941
           ,1
           ,47692
           ,'2012-07-10 11:08:35.350'
           ,47692
           ,'2012-07-10 11:08:35.350'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1029
           ,2941
           ,1
           ,47692
           ,'2012-07-10 11:08:12.417'
           ,47692
           ,'2012-07-10 11:08:12.417'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1248
           ,2939
           ,1
           ,30553
           ,'2012-07-20 13:11:17.770'
           ,30553
           ,'2012-07-20 13:11:17.770'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (223
           ,2935
           ,1
           ,30553
           ,'2012-05-22 04:19:03.780'
           ,30553
           ,'2012-05-22 04:19:03.780'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (596
           ,2928
           ,1
           ,30553
           ,'2012-06-14 04:53:12.747'
           ,30553
           ,'2012-06-14 04:53:12.747'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (456
           ,2927
           ,1
           ,30553
           ,'2012-06-06 10:00:13.790'
           ,30553
           ,'2012-06-06 10:00:13.790'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (236
           ,2925
           ,1
           ,30553
           ,'2012-05-22 06:22:41.540'
           ,30553
           ,'2012-05-22 06:22:41.540'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (811
           ,2923
           ,1
           ,30553
           ,'2012-06-28 11:26:10.537'
           ,30553
           ,'2012-06-28 11:26:10.537'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (791
           ,2919
           ,1
           ,30553
           ,'2012-06-26 11:30:33.643'
           ,30553
           ,'2012-06-26 11:30:33.643'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (761
           ,2917
           ,1
           ,30553
           ,'2012-06-25 07:36:40.693'
           ,30553
           ,'2012-06-25 07:36:40.693'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (243
           ,2912
           ,1
           ,30553
           ,'2012-05-24 06:16:45.943'
           ,30553
           ,'2012-05-24 06:16:45.943'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1197
           ,2905
           ,1
           ,30553
           ,'2012-07-19 05:36:30.770'
           ,30553
           ,'2012-07-19 05:36:30.770'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (629
           ,2904
           ,1
           ,30553
           ,'2012-06-15 10:38:00.137'
           ,30553
           ,'2012-06-15 10:38:00.137'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1238
           ,2899
           ,1
           ,30553
           ,'2012-07-20 11:02:38.970'
           ,30553
           ,'2012-07-20 11:02:38.970'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (296
           ,2894
           ,1
           ,30553
           ,'2012-05-29 10:05:20.087'
           ,30553
           ,'2012-05-29 10:05:20.087'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (483
           ,2887
           ,1
           ,30553
           ,'2012-06-07 11:13:03.687'
           ,30553
           ,'2012-06-07 11:13:03.687'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1193
           ,2885
           ,1
           ,30553
           ,'2012-07-19 05:18:54.870'
           ,30553
           ,'2012-07-19 05:18:54.870'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1184
           ,2883
           ,1
           ,30553
           ,'2012-07-18 08:39:42.807'
           ,30553
           ,'2012-07-18 08:39:42.807'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (635
           ,2882
           ,1
           ,30553
           ,'2012-06-15 11:05:07.940'
           ,30553
           ,'2012-06-15 11:05:07.940'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1170
           ,2865
           ,1
           ,30553
           ,'2012-07-18 05:06:25.403'
           ,30553
           ,'2012-07-18 05:06:25.403'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (509
           ,2859
           ,1
           ,30553
           ,'2012-06-08 10:12:44.720'
           ,30553
           ,'2012-06-08 10:12:44.720'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1146
           ,2855
           ,1
           ,30553
           ,'2012-07-16 06:29:11.407'
           ,30553
           ,'2012-07-16 06:29:11.407'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1163
           ,2853
           ,1
           ,30553
           ,'2012-07-17 08:46:38.303'
           ,30553
           ,'2012-07-17 08:46:38.303'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1176
           ,2852
           ,1
           ,30553
           ,'2012-07-18 06:40:32.130'
           ,30553
           ,'2012-07-18 06:40:32.130'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (476
           ,2849
           ,1
           ,30553
           ,'2012-06-07 08:57:06.740'
           ,30553
           ,'2012-06-07 08:57:06.740'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (475
           ,2849
           ,1
           ,30553
           ,'2012-06-07 08:56:49.207'
           ,30553
           ,'2012-06-07 08:56:49.207'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (340
           ,2848
           ,1
           ,30553
           ,'2012-05-30 11:38:19.557'
           ,30553
           ,'2012-05-30 11:38:19.557'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (790
           ,2847
           ,1
           ,30553
           ,'2012-06-26 11:29:33.673'
           ,30553
           ,'2012-06-26 11:29:33.673'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (619
           ,2846
           ,1
           ,30553
           ,'2012-06-14 12:44:25.623'
           ,30553
           ,'2012-06-14 12:44:25.623'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (847
           ,2845
           ,1
           ,30553
           ,'2012-07-03 08:18:55.220'
           ,30553
           ,'2012-07-03 08:18:55.220'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (494
           ,2844
           ,1
           ,30553
           ,'2012-06-08 05:21:45.883'
           ,30553
           ,'2012-06-08 05:21:45.883'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (508
           ,2835
           ,1
           ,30553
           ,'2012-06-08 10:09:06.597'
           ,30553
           ,'2012-06-08 10:09:06.597'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1250
           ,2832
           ,1
           ,30553
           ,'2012-07-20 13:16:44.483'
           ,30553
           ,'2012-07-20 13:16:44.483'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (484
           ,2831
           ,1
           ,30553
           ,'2012-06-07 11:14:08.193'
           ,30553
           ,'2012-06-07 11:14:08.193'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (829
           ,2822
           ,1
           ,30553
           ,'2012-06-29 10:19:25.673'
           ,30553
           ,'2012-06-29 10:19:25.673'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (248
           ,2817
           ,1
           ,30553
           ,'2012-05-24 06:24:24.407'
           ,30553
           ,'2012-05-24 06:24:24.407'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1230
           ,2816
           ,1
           ,34346
           ,'2012-07-20 06:55:51.110'
           ,34346
           ,'2012-07-20 06:55:51.110'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (350
           ,2816
           ,1
           ,30553
           ,'2012-05-31 06:43:49.817'
           ,30553
           ,'2012-05-31 06:43:49.817'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (866
           ,2815
           ,1
           ,30553
           ,'2012-07-05 06:50:25.160'
           ,30553
           ,'2012-07-05 06:50:25.160'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (222
           ,2814
           ,1
           ,30553
           ,'2012-05-22 04:17:21.240'
           ,30553
           ,'2012-05-22 04:17:21.240'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (826
           ,2812
           ,1
           ,30553
           ,'2012-06-29 10:15:29.707'
           ,30553
           ,'2012-06-29 10:15:29.707'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (861
           ,2810
           ,1
           ,30553
           ,'2012-07-03 11:26:51.450'
           ,30553
           ,'2012-07-03 11:26:51.450'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (848
           ,2805
           ,1
           ,30553
           ,'2012-07-03 08:26:09.473'
           ,30553
           ,'2012-07-03 08:26:09.473'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (845
           ,2789
           ,1
           ,30553
           ,'2012-07-03 07:02:46.213'
           ,30553
           ,'2012-07-03 07:02:46.213'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (682
           ,2785
           ,1
           ,30553
           ,'2012-06-19 05:54:01.337'
           ,30553
           ,'2012-06-19 05:54:01.337'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (681
           ,2785
           ,1
           ,30553
           ,'2012-06-19 05:53:41.430'
           ,30553
           ,'2012-06-19 05:53:41.430'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (834
           ,2784
           ,1
           ,30553
           ,'2012-07-02 05:25:31.820'
           ,30553
           ,'2012-07-02 05:25:31.820'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1167
           ,2783
           ,1
           ,30553
           ,'2012-07-17 10:29:40.607'
           ,30553
           ,'2012-07-17 10:29:40.607'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (333
           ,2780
           ,1
           ,30553
           ,'2012-05-30 10:58:37.727'
           ,30553
           ,'2012-05-30 10:58:37.727'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (225
           ,2778
           ,1
           ,30553
           ,'2012-05-22 04:20:20.433'
           ,30553
           ,'2012-05-22 04:20:20.433'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1249
           ,2777
           ,1
           ,30553
           ,'2012-07-20 13:12:31.410'
           ,30553
           ,'2012-07-20 13:12:31.410'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (805
           ,2775
           ,1
           ,30553
           ,'2012-06-28 08:06:59.367'
           ,30553
           ,'2012-06-28 08:06:59.367'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (822
           ,2773
           ,1
           ,30553
           ,'2012-06-29 09:39:14.813'
           ,30553
           ,'2012-06-29 09:39:14.813'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (803
           ,2771
           ,1
           ,30553
           ,'2012-06-27 10:47:54.650'
           ,30553
           ,'2012-06-27 10:47:54.650'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (792
           ,2764
           ,1
           ,30553
           ,'2012-06-27 05:28:57.650'
           ,30553
           ,'2012-06-27 05:28:57.650'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (568
           ,2761
           ,1
           ,30553
           ,'2012-06-12 11:02:43.997'
           ,30553
           ,'2012-06-12 11:02:43.997'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (784
           ,2760
           ,1
           ,30553
           ,'2012-06-26 06:20:10.087'
           ,30553
           ,'2012-06-26 06:20:10.087'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (794
           ,2754
           ,1
           ,30553
           ,'2012-06-27 07:40:26.050'
           ,30553
           ,'2012-06-27 07:40:26.050'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (449
           ,2746
           ,1
           ,30553
           ,'2012-06-06 09:45:55.623'
           ,30553
           ,'2012-06-06 09:45:55.623'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (749
           ,2737
           ,1
           ,30553
           ,'2012-06-25 05:47:31.570'
           ,30553
           ,'2012-06-25 05:47:31.570'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (206
           ,2733
           ,1
           ,30553
           ,'2012-05-21 08:55:07.660'
           ,30553
           ,'2012-05-21 08:55:07.660'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (741
           ,2730
           ,1
           ,30553
           ,'2012-06-22 07:09:59.590'
           ,30553
           ,'2012-06-22 07:09:59.590'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (742
           ,2729
           ,1
           ,30553
           ,'2012-06-22 07:10:41.100'
           ,30553
           ,'2012-06-22 07:10:41.100'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (693
           ,2727
           ,1
           ,30553
           ,'2012-06-20 08:19:47.380'
           ,30553
           ,'2012-06-20 08:19:47.380'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (495
           ,2725
           ,1
           ,30553
           ,'2012-06-08 05:22:50.233'
           ,30553
           ,'2012-06-08 05:22:50.233'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (575
           ,2723
           ,1
           ,30553
           ,'2012-06-13 05:58:21.680'
           ,30553
           ,'2012-06-13 05:58:21.680'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (723
           ,2721
           ,1
           ,30553
           ,'2012-06-21 10:31:30.630'
           ,30553
           ,'2012-06-21 10:31:30.630'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (705
           ,2718
           ,1
           ,30553
           ,'2012-06-20 11:34:24.437'
           ,30553
           ,'2012-06-20 11:34:24.437'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (702
           ,2717
           ,1
           ,30553
           ,'2012-06-20 11:28:25.737'
           ,30553
           ,'2012-06-20 11:28:25.737'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (688
           ,2714
           ,1
           ,30553
           ,'2012-06-19 10:48:09.557'
           ,30553
           ,'2012-06-19 10:48:09.557'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (833
           ,2709
           ,1
           ,30553
           ,'2012-06-29 10:29:35.537'
           ,30553
           ,'2012-06-29 10:29:35.537'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (684
           ,2708
           ,1
           ,30553
           ,'2012-06-19 06:30:06.767'
           ,30553
           ,'2012-06-19 06:30:06.767'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (669
           ,2706
           ,1
           ,30553
           ,'2012-06-18 07:08:48.490'
           ,30553
           ,'2012-06-18 07:08:48.490'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (687
           ,2701
           ,1
           ,30553
           ,'2012-06-19 10:46:07.580'
           ,30553
           ,'2012-06-19 10:46:07.580'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1239
           ,2700
           ,1
           ,30553
           ,'2012-07-20 11:03:57.783'
           ,30553
           ,'2012-07-20 11:03:57.783'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (631
           ,2700
           ,1
           ,30553
           ,'2012-06-15 10:46:05.670'
           ,30553
           ,'2012-06-15 10:46:05.670'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (616
           ,2696
           ,1
           ,30553
           ,'2012-06-14 12:41:47.813'
           ,30553
           ,'2012-06-14 12:41:47.813'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (606
           ,2694
           ,1
           ,30553
           ,'2012-06-14 06:59:04.990'
           ,30553
           ,'2012-06-14 06:59:04.990'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1204
           ,2693
           ,1
           ,30553
           ,'2012-07-19 06:56:53.347'
           ,30553
           ,'2012-07-19 06:56:53.347'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (615
           ,2692
           ,1
           ,30553
           ,'2012-06-14 10:32:16.683'
           ,30553
           ,'2012-06-14 10:32:16.683'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (765
           ,2691
           ,1
           ,30553
           ,'2012-06-25 08:34:46.930'
           ,30553
           ,'2012-06-25 08:34:46.930'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (764
           ,2691
           ,1
           ,30553
           ,'2012-06-25 08:34:23.047'
           ,30553
           ,'2012-06-25 08:34:23.047'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (578
           ,2685
           ,1
           ,30553
           ,'2012-06-13 06:03:59.510'
           ,30553
           ,'2012-06-13 06:03:59.510'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (551
           ,2680
           ,1
           ,30553
           ,'2012-06-11 06:57:18.840'
           ,30553
           ,'2012-06-11 06:57:18.840'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (258
           ,2671
           ,1
           ,30553
           ,'2012-05-24 08:50:56.863'
           ,30553
           ,'2012-05-24 08:50:56.863'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (450
           ,2661
           ,1
           ,30553
           ,'2012-06-06 09:46:40.907'
           ,30553
           ,'2012-06-06 09:46:40.907'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (779
           ,2658
           ,1
           ,30553
           ,'2012-06-26 05:04:01.980'
           ,30553
           ,'2012-06-26 05:04:01.980'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (482
           ,2657
           ,1
           ,30553
           ,'2012-06-07 11:11:44.923'
           ,30553
           ,'2012-06-07 11:11:44.923'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (564
           ,2654
           ,1
           ,30553
           ,'2012-06-12 08:02:45.630'
           ,30553
           ,'2012-06-12 08:02:45.630'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (704
           ,2651
           ,1
           ,30553
           ,'2012-06-20 11:29:29.690'
           ,30553
           ,'2012-06-20 11:29:29.690'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (703
           ,2651
           ,1
           ,30553
           ,'2012-06-20 11:29:09.670'
           ,30553
           ,'2012-06-20 11:29:09.670'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (416
           ,2642
           ,1
           ,30553
           ,'2012-06-05 04:18:46.780'
           ,30553
           ,'2012-06-05 04:18:46.780'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (415
           ,2642
           ,1
           ,30553
           ,'2012-06-05 04:18:10.857'
           ,30553
           ,'2012-06-05 04:18:10.857'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1202
           ,2628
           ,1
           ,30553
           ,'2012-07-19 06:55:11.180'
           ,30553
           ,'2012-07-19 06:55:11.180'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (437
           ,2624
           ,1
           ,30553
           ,'2012-06-05 06:28:47.503'
           ,30553
           ,'2012-06-05 06:28:47.503'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (433
           ,2624
           ,1
           ,30553
           ,'2012-06-05 06:03:02.947'
           ,30553
           ,'2012-06-05 06:03:02.947'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (474
           ,2611
           ,1
           ,30553
           ,'2012-06-07 08:41:11.867'
           ,30553
           ,'2012-06-07 08:41:11.867'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (473
           ,2611
           ,1
           ,30553
           ,'2012-06-07 08:40:59.700'
           ,30553
           ,'2012-06-07 08:40:59.700'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (408
           ,2609
           ,1
           ,30553
           ,'2012-06-05 04:08:44.823'
           ,30553
           ,'2012-06-05 04:08:44.823'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (407
           ,2609
           ,1
           ,30553
           ,'2012-06-05 04:08:26.403'
           ,30553
           ,'2012-06-05 04:08:26.403'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (653
           ,2605
           ,1
           ,30553
           ,'2012-06-15 12:18:16.790'
           ,30553
           ,'2012-06-15 12:18:16.790'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (438
           ,2602
           ,1
           ,30553
           ,'2012-06-05 06:31:02.337'
           ,30553
           ,'2012-06-05 06:31:02.337'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (358
           ,2599
           ,1
           ,30553
           ,'2012-05-31 10:29:17.820'
           ,30553
           ,'2012-05-31 10:29:17.820'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (569
           ,2598
           ,1
           ,30553
           ,'2012-06-12 11:24:09.003'
           ,30553
           ,'2012-06-12 11:24:09.003'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (332
           ,2594
           ,1
           ,30553
           ,'2012-05-30 10:55:25.513'
           ,30553
           ,'2012-05-30 10:55:25.513'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (269
           ,2591
           ,1
           ,30553
           ,'2012-05-25 10:54:25.707'
           ,30553
           ,'2012-05-25 10:54:25.707'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (851
           ,2587
           ,1
           ,30553
           ,'2012-07-03 08:29:28.887'
           ,30553
           ,'2012-07-03 08:29:28.887'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (775
           ,2586
           ,1
           ,30553
           ,'2012-06-26 04:52:12.690'
           ,30553
           ,'2012-06-26 04:52:12.690'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (273
           ,2585
           ,1
           ,30553
           ,'2012-05-25 11:42:41.227'
           ,30553
           ,'2012-05-25 11:42:41.227'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1240
           ,2582
           ,1
           ,30553
           ,'2012-07-20 11:05:29.027'
           ,30553
           ,'2012-07-20 11:05:29.027'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (270
           ,2582
           ,1
           ,30553
           ,'2012-05-25 10:56:38.087'
           ,30553
           ,'2012-05-25 10:56:38.087'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (444
           ,2576
           ,1
           ,30553
           ,'2012-06-06 04:46:47.927'
           ,30553
           ,'2012-06-06 04:46:47.927'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (465
           ,2575
           ,1
           ,30553
           ,'2012-06-06 11:18:35.477'
           ,30553
           ,'2012-06-06 11:18:35.477'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (570
           ,2570
           ,1
           ,30553
           ,'2012-06-12 11:30:25.047'
           ,30553
           ,'2012-06-12 11:30:25.047'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (648
           ,2568
           ,1
           ,30553
           ,'2012-06-15 11:43:50.120'
           ,30553
           ,'2012-06-15 11:43:50.120'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (251
           ,2567
           ,1
           ,30553
           ,'2012-05-24 08:28:09.930'
           ,30553
           ,'2012-05-24 08:28:09.930'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (207
           ,2558
           ,1
           ,30553
           ,'2012-05-21 08:56:11.950'
           ,30553
           ,'2012-05-21 08:56:11.950'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1147
           ,2535
           ,1
           ,30553
           ,'2012-07-16 06:32:14.130'
           ,30553
           ,'2012-07-16 06:32:14.130'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (557
           ,2535
           ,1
           ,30553
           ,'2012-06-12 05:22:53.137'
           ,30553
           ,'2012-06-12 05:22:53.137'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (574
           ,2533
           ,1
           ,30553
           ,'2012-06-13 05:54:46.583'
           ,30553
           ,'2012-06-13 05:54:46.583'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (736
           ,2526
           ,1
           ,30553
           ,'2012-06-22 07:05:04.280'
           ,30553
           ,'2012-06-22 07:05:04.280'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1219
           ,2524
           ,1
           ,30553
           ,'2012-07-19 08:31:16.040'
           ,30553
           ,'2012-07-19 08:31:16.040'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (314
           ,2523
           ,1
           ,30553
           ,'2012-05-30 08:48:54.033'
           ,30553
           ,'2012-05-30 08:48:54.033'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (609
           ,2521
           ,1
           ,30553
           ,'2012-06-14 07:56:06.087'
           ,30553
           ,'2012-06-14 07:56:06.087'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (657
           ,2518
           ,1
           ,30553
           ,'2012-06-15 12:22:01.733'
           ,30553
           ,'2012-06-15 12:22:01.733'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (291
           ,2517
           ,1
           ,30553
           ,'2012-05-29 09:58:22.590'
           ,30553
           ,'2012-05-29 09:58:22.590'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (290
           ,2517
           ,1
           ,30553
           ,'2012-05-29 09:58:05.720'
           ,30553
           ,'2012-05-29 09:58:05.720'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1190
           ,2512
           ,1
           ,34346
           ,'2012-07-18 09:52:07.677'
           ,34346
           ,'2012-07-18 09:52:07.677'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1153
           ,2512
           ,1
           ,30553
           ,'2012-07-16 11:00:32.333'
           ,30553
           ,'2012-07-16 11:00:32.333'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (617
           ,2505
           ,1
           ,30553
           ,'2012-06-14 12:43:05.573'
           ,30553
           ,'2012-06-14 12:43:05.573'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (472
           ,2499
           ,1
           ,30553
           ,'2012-06-07 08:03:07.193'
           ,30553
           ,'2012-06-07 08:03:07.193'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (218
           ,2498
           ,1
           ,30553
           ,'2012-05-21 12:19:15.567'
           ,30553
           ,'2012-05-21 12:19:15.567'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (841
           ,2497
           ,1
           ,30553
           ,'2012-07-03 06:34:20.437'
           ,30553
           ,'2012-07-03 06:34:20.437'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (503
           ,2495
           ,1
           ,30553
           ,'2012-06-08 08:34:23.963'
           ,30553
           ,'2012-06-08 08:34:23.963'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (706
           ,2493
           ,1
           ,30553
           ,'2012-06-20 11:39:48.170'
           ,30553
           ,'2012-06-20 11:39:48.170'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (654
           ,2492
           ,1
           ,30553
           ,'2012-06-15 12:19:04.527'
           ,30553
           ,'2012-06-15 12:19:04.527'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (560
           ,2490
           ,1
           ,30553
           ,'2012-06-12 07:08:02.867'
           ,30553
           ,'2012-06-12 07:08:02.867'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (646
           ,2487
           ,1
           ,30553
           ,'2012-06-15 11:36:45.650'
           ,30553
           ,'2012-06-15 11:36:45.650'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1071
           ,2478
           ,1
           ,47692
           ,'2012-07-13 06:35:30.283'
           ,47692
           ,'2012-07-13 06:35:30.283'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1070
           ,2478
           ,1
           ,47692
           ,'2012-07-13 06:35:06.223'
           ,47692
           ,'2012-07-13 06:35:06.223'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (618
           ,2475
           ,1
           ,30553
           ,'2012-06-14 12:43:46.183'
           ,30553
           ,'2012-06-14 12:43:46.183'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (856
           ,2471
           ,1
           ,30553
           ,'2012-07-03 08:37:03.660'
           ,30553
           ,'2012-07-03 08:37:03.660'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (221
           ,2464
           ,1
           ,30553
           ,'2012-05-21 13:57:15.990'
           ,30553
           ,'2012-05-21 13:57:15.990'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1216
           ,2460
           ,1
           ,30553
           ,'2012-07-19 08:18:26.697'
           ,30553
           ,'2012-07-19 08:18:26.697'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (754
           ,2454
           ,1
           ,30553
           ,'2012-06-25 07:24:22.113'
           ,30553
           ,'2012-06-25 07:24:22.113'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1151
           ,2445
           ,1
           ,30553
           ,'2012-07-16 10:56:17.263'
           ,30553
           ,'2012-07-16 10:56:17.263'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1043
           ,2431
           ,1
           ,47692
           ,'2012-07-11 06:37:56.393'
           ,47692
           ,'2012-07-11 06:37:56.393'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1042
           ,2431
           ,1
           ,47692
           ,'2012-07-11 06:37:33.620'
           ,47692
           ,'2012-07-11 06:37:33.620'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1041
           ,2431
           ,1
           ,47692
           ,'2012-07-10 13:49:30.537'
           ,47692
           ,'2012-07-10 13:49:30.537'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (572
           ,2426
           ,1
           ,30553
           ,'2012-06-12 11:38:20.510'
           ,30553
           ,'2012-06-12 11:38:20.510'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (567
           ,2423
           ,1
           ,30553
           ,'2012-06-12 11:01:45.887'
           ,30553
           ,'2012-06-12 11:01:45.887'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (511
           ,2416
           ,1
           ,30553
           ,'2012-06-08 10:16:20.167'
           ,30553
           ,'2012-06-08 10:16:20.167'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (807
           ,2408
           ,1
           ,30553
           ,'2012-06-28 08:08:31.800'
           ,30553
           ,'2012-06-28 08:08:31.800'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (738
           ,2408
           ,1
           ,30553
           ,'2012-06-22 07:07:53.577'
           ,30553
           ,'2012-06-22 07:07:53.577'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (661
           ,2403
           ,1
           ,30553
           ,'2012-06-15 12:28:33.750'
           ,30553
           ,'2012-06-15 12:28:33.750'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (731
           ,2399
           ,1
           ,30553
           ,'2012-06-21 11:56:53.377'
           ,30553
           ,'2012-06-21 11:56:53.377'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (208
           ,2398
           ,1
           ,30553
           ,'2012-05-21 09:02:12.473'
           ,30553
           ,'2012-05-21 09:02:12.473'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (642
           ,2392
           ,1
           ,30553
           ,'2012-06-15 11:31:52.250'
           ,30553
           ,'2012-06-15 11:31:52.250'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (710
           ,2379
           ,1
           ,30553
           ,'2012-06-21 06:31:22.510'
           ,30553
           ,'2012-06-21 06:31:22.510'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (328
           ,2379
           ,1
           ,30553
           ,'2012-05-30 10:07:54.893'
           ,30553
           ,'2012-05-30 10:07:54.893'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (327
           ,2379
           ,1
           ,30553
           ,'2012-05-30 10:07:34.360'
           ,30553
           ,'2012-05-30 10:07:34.360'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (720
           ,2375
           ,1
           ,30553
           ,'2012-06-21 08:49:43.050'
           ,30553
           ,'2012-06-21 08:49:43.050'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (991
           ,2373
           ,1
           ,30551
           ,'2012-07-09 06:50:03.627'
           ,30551
           ,'2012-07-09 06:50:03.627'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (676
           ,2371
           ,1
           ,30553
           ,'2012-06-18 11:18:46.243'
           ,30553
           ,'2012-06-18 11:18:46.243'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (514
           ,2368
           ,1
           ,30553
           ,'2012-06-08 10:32:48.247'
           ,30553
           ,'2012-06-08 10:32:48.247'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (729
           ,2364
           ,1
           ,30553
           ,'2012-06-21 11:50:38.047'
           ,30553
           ,'2012-06-21 11:50:38.047'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (728
           ,2364
           ,1
           ,30553
           ,'2012-06-21 11:50:18.713'
           ,30553
           ,'2012-06-21 11:50:18.713'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (673
           ,2363
           ,1
           ,30553
           ,'2012-06-18 11:15:07.270'
           ,30553
           ,'2012-06-18 11:15:07.270'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (622
           ,2362
           ,1
           ,30553
           ,'2012-06-14 12:47:11.077'
           ,30553
           ,'2012-06-14 12:47:11.077'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (745
           ,2361
           ,1
           ,30553
           ,'2012-06-22 12:46:09.860'
           ,30553
           ,'2012-06-22 12:46:09.860'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (435
           ,2360
           ,1
           ,30553
           ,'2012-06-05 06:20:18.530'
           ,30553
           ,'2012-06-05 06:20:18.530'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (434
           ,2360
           ,1
           ,30553
           ,'2012-06-05 06:20:03.633'
           ,30553
           ,'2012-06-05 06:20:03.633'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (990
           ,2359
           ,1
           ,30551
           ,'2012-07-09 06:40:15.703'
           ,30551
           ,'2012-07-09 06:40:15.703'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (989
           ,2359
           ,1
           ,30551
           ,'2012-07-09 06:39:14.197'
           ,30551
           ,'2012-07-09 06:39:14.197'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (638
           ,2356
           ,1
           ,30553
           ,'2012-06-15 11:16:41.507'
           ,30553
           ,'2012-06-15 11:16:41.507'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (743
           ,2353
           ,1
           ,30553
           ,'2012-06-22 07:34:20.513'
           ,30553
           ,'2012-06-22 07:34:20.513'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1229
           ,2343
           ,1
           ,34346
           ,'2012-07-20 06:55:11.527'
           ,34346
           ,'2012-07-20 06:55:11.527'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1215
           ,2343
           ,1
           ,30553
           ,'2012-07-19 07:34:44.427'
           ,30553
           ,'2012-07-19 07:34:44.427'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (767
           ,2340
           ,1
           ,30553
           ,'2012-06-25 08:40:12.063'
           ,30553
           ,'2012-06-25 08:40:12.063'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1033
           ,2339
           ,1
           ,47692
           ,'2012-07-10 12:09:04.160'
           ,47692
           ,'2012-07-10 12:09:04.160'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (830
           ,2338
           ,1
           ,30553
           ,'2012-06-29 10:24:27.233'
           ,30553
           ,'2012-06-29 10:24:27.233'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (737
           ,2337
           ,1
           ,30553
           ,'2012-06-22 07:06:44.710'
           ,30553
           ,'2012-06-22 07:06:44.710'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1075
           ,2334
           ,1
           ,47692
           ,'2012-07-13 07:06:56.690'
           ,47692
           ,'2012-07-13 07:06:56.690'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1074
           ,2334
           ,1
           ,47692
           ,'2012-07-13 07:06:15.670'
           ,47692
           ,'2012-07-13 07:06:15.670'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (997
           ,2334
           ,1
           ,30551
           ,'2012-07-09 06:54:25.077'
           ,30551
           ,'2012-07-09 06:54:25.077'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (903
           ,2331
           ,1
           ,47692
           ,'2012-07-06 12:20:05.183'
           ,47692
           ,'2012-07-06 12:20:05.183'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (901
           ,2331
           ,1
           ,47692
           ,'2012-07-06 12:19:10.360'
           ,47692
           ,'2012-07-06 12:19:10.360'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (912
           ,2330
           ,1
           ,47692
           ,'2012-07-06 12:34:26.973'
           ,47692
           ,'2012-07-06 12:34:26.973'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (910
           ,2330
           ,1
           ,47692
           ,'2012-07-06 12:34:02.507'
           ,47692
           ,'2012-07-06 12:34:02.507'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (510
           ,2328
           ,1
           ,30553
           ,'2012-06-08 10:14:40.407'
           ,30553
           ,'2012-06-08 10:14:40.407'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (699
           ,2327
           ,1
           ,30553
           ,'2012-06-20 08:25:56.167'
           ,30553
           ,'2012-06-20 08:25:56.167'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1160
           ,2325
           ,1
           ,30553
           ,'2012-07-17 06:12:08.790'
           ,30553
           ,'2012-07-17 06:12:08.790'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (209
           ,2322
           ,1
           ,30553
           ,'2012-05-21 09:03:02.217'
           ,30553
           ,'2012-05-21 09:03:02.217'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1117
           ,2321
           ,1
           ,47692
           ,'2012-07-13 12:00:03.980'
           ,47692
           ,'2012-07-13 12:00:03.980'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1116
           ,2321
           ,1
           ,47692
           ,'2012-07-13 11:59:35.430'
           ,47692
           ,'2012-07-13 11:59:35.430'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1001
           ,2317
           ,1
           ,30551
           ,'2012-07-09 06:58:13.080'
           ,30551
           ,'2012-07-09 06:58:13.080'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (766
           ,2316
           ,1
           ,30553
           ,'2012-06-25 08:36:21.930'
           ,30553
           ,'2012-06-25 08:36:21.930'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (677
           ,2315
           ,1
           ,30553
           ,'2012-06-18 12:09:28.680'
           ,30553
           ,'2012-06-18 12:09:28.680'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (739
           ,2310
           ,1
           ,30553
           ,'2012-06-22 07:08:27.240'
           ,30553
           ,'2012-06-22 07:08:27.240'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (718
           ,2309
           ,1
           ,30553
           ,'2012-06-21 08:41:13.380'
           ,30553
           ,'2012-06-21 08:41:13.380'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1005
           ,2308
           ,1
           ,30551
           ,'2012-07-09 07:20:08.147'
           ,30551
           ,'2012-07-09 07:20:08.147'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (641
           ,2307
           ,1
           ,30553
           ,'2012-06-15 11:31:02.670'
           ,30553
           ,'2012-06-15 11:31:02.670'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1150
           ,2301
           ,1
           ,30553
           ,'2012-07-16 10:55:12.557'
           ,30553
           ,'2012-07-16 10:55:12.557'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (877
           ,2300
           ,1
           ,30553
           ,'2012-07-05 12:56:54.350'
           ,30553
           ,'2012-07-05 12:56:54.350'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (659
           ,2298
           ,1
           ,30553
           ,'2012-06-15 12:24:10.967'
           ,30553
           ,'2012-06-15 12:24:10.967'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (213
           ,2297
           ,1
           ,30553
           ,'2012-05-21 10:08:00.800'
           ,30553
           ,'2012-05-21 10:08:00.800'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1036
           ,2290
           ,1
           ,47692
           ,'2012-07-10 12:38:29.037'
           ,47692
           ,'2012-07-10 12:38:29.037'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (491
           ,2290
           ,1
           ,30553
           ,'2012-06-07 12:34:54.793'
           ,30553
           ,'2012-06-07 12:34:54.793'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (721
           ,2284
           ,1
           ,30553
           ,'2012-06-21 08:52:23.220'
           ,30553
           ,'2012-06-21 08:52:23.220'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (746
           ,2283
           ,1
           ,30553
           ,'2012-06-22 12:51:02.280'
           ,30553
           ,'2012-06-22 12:51:02.280'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (594
           ,2280
           ,1
           ,30553
           ,'2012-06-13 11:20:11.323'
           ,30553
           ,'2012-06-13 11:20:11.323'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (620
           ,2279
           ,1
           ,30553
           ,'2012-06-14 12:46:01.507'
           ,30553
           ,'2012-06-14 12:46:01.507'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1000
           ,2276
           ,1
           ,30551
           ,'2012-07-09 06:56:45.360'
           ,30551
           ,'2012-07-09 06:56:45.360'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (995
           ,2272
           ,1
           ,30551
           ,'2012-07-09 06:52:31.710'
           ,30551
           ,'2012-07-09 06:52:31.710'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1007
           ,2269
           ,1
           ,30551
           ,'2012-07-09 07:35:42.550'
           ,30551
           ,'2012-07-09 07:35:42.550'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (214
           ,2268
           ,1
           ,30553
           ,'2012-05-21 10:09:56.070'
           ,30553
           ,'2012-05-21 10:09:56.070'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (656
           ,2266
           ,1
           ,30553
           ,'2012-06-15 12:21:22.790'
           ,30553
           ,'2012-06-15 12:21:22.790'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (286
           ,2264
           ,1
           ,30553
           ,'2012-05-29 09:51:15.800'
           ,30553
           ,'2012-05-29 09:51:15.800'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1062
           ,2261
           ,1
           ,47692
           ,'2012-07-12 11:20:35.223'
           ,47692
           ,'2012-07-12 11:20:35.223'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1061
           ,2261
           ,1
           ,47692
           ,'2012-07-12 11:20:12.623'
           ,47692
           ,'2012-07-12 11:20:12.623'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (680
           ,2260
           ,1
           ,30553
           ,'2012-06-18 13:46:41.837'
           ,30553
           ,'2012-06-18 13:46:41.837'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (716
           ,2259
           ,1
           ,30553
           ,'2012-06-21 08:38:36.200'
           ,30553
           ,'2012-06-21 08:38:36.200'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (348
           ,2253
           ,1
           ,30553
           ,'2012-05-30 12:42:06.097'
           ,30553
           ,'2012-05-30 12:42:06.097'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (788
           ,2249
           ,1
           ,30553
           ,'2012-06-26 09:02:15.750'
           ,30553
           ,'2012-06-26 09:02:15.750'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (755
           ,2247
           ,1
           ,30553
           ,'2012-06-25 07:26:45.237'
           ,30553
           ,'2012-06-25 07:26:45.237'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1171
           ,2241
           ,1
           ,30553
           ,'2012-07-18 05:10:40.533'
           ,30553
           ,'2012-07-18 05:10:40.533'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1235
           ,2231
           ,1
           ,30553
           ,'2012-07-20 09:29:18.560'
           ,30553
           ,'2012-07-20 09:29:18.560'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1236
           ,2229
           ,1
           ,30553
           ,'2012-07-20 09:29:46.150'
           ,30553
           ,'2012-07-20 09:29:46.150'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1101
           ,2226
           ,1
           ,47692
           ,'2012-07-13 09:05:56.980'
           ,47692
           ,'2012-07-13 09:05:56.980'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1098
           ,2226
           ,1
           ,47692
           ,'2012-07-13 08:59:42.797'
           ,47692
           ,'2012-07-13 08:59:42.797'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1096
           ,2226
           ,1
           ,47692
           ,'2012-07-13 08:58:48.243'
           ,47692
           ,'2012-07-13 08:58:48.243'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (561
           ,2218
           ,1
           ,30553
           ,'2012-06-12 07:22:00.900'
           ,30553
           ,'2012-06-12 07:22:00.900'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (458
           ,2210
           ,1
           ,30553
           ,'2012-06-06 10:02:09.633'
           ,30553
           ,'2012-06-06 10:02:09.633'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (231
           ,2205
           ,1
           ,30553
           ,'2012-05-22 05:45:16.053'
           ,30553
           ,'2012-05-22 05:45:16.053'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (347
           ,2203
           ,1
           ,30553
           ,'2012-05-30 12:15:42.687'
           ,30553
           ,'2012-05-30 12:15:42.687'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (342
           ,2202
           ,1
           ,30553
           ,'2012-05-30 11:58:22.873'
           ,30553
           ,'2012-05-30 11:58:22.873'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (753
           ,2199
           ,1
           ,30553
           ,'2012-06-25 07:21:19.553'
           ,30553
           ,'2012-06-25 07:21:19.553'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (752
           ,2199
           ,1
           ,30553
           ,'2012-06-25 07:21:00.140'
           ,30553
           ,'2012-06-25 07:21:00.140'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (586
           ,2197
           ,1
           ,30553
           ,'2012-06-13 08:47:42.077'
           ,30553
           ,'2012-06-13 08:47:42.077'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (759
           ,2195
           ,1
           ,30553
           ,'2012-06-25 07:33:01.850'
           ,30553
           ,'2012-06-25 07:33:01.850'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1242
           ,2191
           ,1
           ,30553
           ,'2012-07-20 11:09:34.137'
           ,30553
           ,'2012-07-20 11:09:34.137'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1067
           ,2190
           ,1
           ,47692
           ,'2012-07-12 12:03:22.520'
           ,47692
           ,'2012-07-12 12:03:22.520'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (623
           ,2184
           ,1
           ,30553
           ,'2012-06-14 12:47:50.613'
           ,30553
           ,'2012-06-14 12:47:50.613'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1002
           ,2170
           ,1
           ,30551
           ,'2012-07-09 07:17:43.803'
           ,30551
           ,'2012-07-09 07:17:43.803'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1199
           ,2169
           ,1
           ,30553
           ,'2012-07-19 05:44:27.387'
           ,30553
           ,'2012-07-19 05:44:27.387'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (999
           ,2169
           ,1
           ,30551
           ,'2012-07-09 06:55:48.840'
           ,30551
           ,'2012-07-09 06:55:48.840'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (998
           ,2169
           ,1
           ,30551
           ,'2012-07-09 06:55:19.700'
           ,30551
           ,'2012-07-09 06:55:19.700'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1003
           ,2168
           ,1
           ,30551
           ,'2012-07-09 07:18:36.627'
           ,30551
           ,'2012-07-09 07:18:36.627'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (758
           ,2167
           ,1
           ,30553
           ,'2012-06-25 07:32:04.520'
           ,30553
           ,'2012-06-25 07:32:04.520'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (621
           ,2165
           ,1
           ,30553
           ,'2012-06-14 12:46:37.957'
           ,30553
           ,'2012-06-14 12:46:37.957'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1004
           ,2164
           ,1
           ,30551
           ,'2012-07-09 07:19:23.317'
           ,30551
           ,'2012-07-09 07:19:23.317'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (734
           ,2163
           ,1
           ,30553
           ,'2012-06-21 12:19:43.240'
           ,30553
           ,'2012-06-21 12:19:43.240'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1207
           ,2152
           ,1
           ,30553
           ,'2012-07-19 07:02:52.117'
           ,30553
           ,'2012-07-19 07:02:52.117'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (882
           ,2148
           ,1
           ,47692
           ,'2012-07-06 07:59:54.550'
           ,47692
           ,'2012-07-06 07:59:54.550'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (881
           ,2148
           ,1
           ,47692
           ,'2012-07-06 07:59:14.967'
           ,47692
           ,'2012-07-06 07:59:14.967'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1054
           ,2147
           ,1
           ,47692
           ,'2012-07-11 13:12:10.130'
           ,47692
           ,'2012-07-11 13:12:10.130'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1053
           ,2147
           ,1
           ,47692
           ,'2012-07-11 13:11:15.403'
           ,47692
           ,'2012-07-11 13:11:15.403'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (312
           ,2147
           ,1
           ,30553
           ,'2012-05-30 08:46:51.123'
           ,30553
           ,'2012-05-30 08:46:51.123'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1039
           ,2146
           ,1
           ,47692
           ,'2012-07-10 13:04:15.420'
           ,47692
           ,'2012-07-10 13:04:15.420'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (695
           ,2146
           ,1
           ,30553
           ,'2012-06-20 08:21:16.760'
           ,30553
           ,'2012-06-20 08:21:16.760'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (410
           ,2144
           ,1
           ,30553
           ,'2012-06-05 04:10:31.283'
           ,30553
           ,'2012-06-05 04:10:31.283'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1026
           ,2143
           ,1
           ,47692
           ,'2012-07-10 09:25:44.247'
           ,47692
           ,'2012-07-10 09:25:44.247'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1019
           ,2142
           ,1
           ,47692
           ,'2012-07-10 06:37:13.520'
           ,47692
           ,'2012-07-10 06:37:13.520'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1018
           ,2142
           ,1
           ,47692
           ,'2012-07-10 06:36:56.957'
           ,47692
           ,'2012-07-10 06:36:56.957'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1025
           ,2141
           ,1
           ,47692
           ,'2012-07-10 09:11:04.053'
           ,47692
           ,'2012-07-10 09:11:04.053'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1024
           ,2141
           ,1
           ,47692
           ,'2012-07-10 09:10:42.263'
           ,47692
           ,'2012-07-10 09:10:42.263'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1021
           ,2140
           ,1
           ,47692
           ,'2012-07-10 07:04:29.920'
           ,47692
           ,'2012-07-10 07:04:29.920'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1020
           ,2140
           ,1
           ,47692
           ,'2012-07-10 07:03:52.610'
           ,47692
           ,'2012-07-10 07:03:52.610'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (405
           ,2136
           ,1
           ,30553
           ,'2012-06-04 09:07:43.617'
           ,30553
           ,'2012-06-04 09:07:43.617'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (404
           ,2136
           ,1
           ,30553
           ,'2012-06-04 09:07:07.930'
           ,30553
           ,'2012-06-04 09:07:07.930'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (744
           ,2133
           ,1
           ,30553
           ,'2012-06-22 12:45:18.810'
           ,30553
           ,'2012-06-22 12:45:18.810'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (696
           ,2132
           ,1
           ,30553
           ,'2012-06-20 08:22:00.040'
           ,30553
           ,'2012-06-20 08:22:00.040'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (785
           ,2131
           ,1
           ,30553
           ,'2012-06-26 07:39:14.103'
           ,30553
           ,'2012-06-26 07:39:14.103'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (868
           ,2129
           ,1
           ,30553
           ,'2012-07-05 10:35:40.980'
           ,30553
           ,'2012-07-05 10:35:40.980'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (576
           ,2126
           ,1
           ,30553
           ,'2012-06-13 05:59:17.990'
           ,30553
           ,'2012-06-13 05:59:17.990'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (505
           ,2124
           ,1
           ,30553
           ,'2012-06-08 09:58:17.010'
           ,30553
           ,'2012-06-08 09:58:17.010'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1251
           ,2121
           ,1
           ,30553
           ,'2012-07-20 13:17:47.230'
           ,30553
           ,'2012-07-20 13:17:47.230'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (855
           ,2115
           ,1
           ,30553
           ,'2012-07-03 08:34:35.737'
           ,30553
           ,'2012-07-03 08:34:35.737'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (205
           ,2114
           ,1
           ,30553
           ,'2012-05-21 08:54:23.670'
           ,30553
           ,'2012-05-21 08:54:23.670'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (782
           ,2111
           ,1
           ,30553
           ,'2012-06-26 05:51:17.863'
           ,30553
           ,'2012-06-26 05:51:17.863'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (603
           ,2111
           ,1
           ,30553
           ,'2012-06-14 05:11:44.270'
           ,30553
           ,'2012-06-14 05:11:44.270'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (233
           ,2106
           ,1
           ,30553
           ,'2012-05-22 05:49:14.260'
           ,30553
           ,'2012-05-22 05:49:14.260'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (344
           ,2102
           ,1
           ,30553
           ,'2012-05-30 12:04:19.760'
           ,30553
           ,'2012-05-30 12:04:19.760'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1040
           ,2094
           ,1
           ,47692
           ,'2012-07-10 13:38:24.237'
           ,47692
           ,'2012-07-10 13:38:24.237'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (795
           ,2083
           ,1
           ,30553
           ,'2012-06-27 07:41:14.460'
           ,30553
           ,'2012-06-27 07:41:14.460'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1011
           ,2078
           ,1
           ,47692
           ,'2012-07-09 11:16:44.007'
           ,47692
           ,'2012-07-09 11:16:44.007'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1010
           ,2078
           ,1
           ,47692
           ,'2012-07-09 11:16:15.993'
           ,47692
           ,'2012-07-09 11:16:15.993'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (887
           ,2077
           ,1
           ,47692
           ,'2012-07-06 11:43:15.197'
           ,47692
           ,'2012-07-06 11:43:15.197'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (886
           ,2077
           ,1
           ,47692
           ,'2012-07-06 11:39:51.720'
           ,47692
           ,'2012-07-06 11:39:51.720'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (295
           ,2074
           ,1
           ,30553
           ,'2012-05-29 10:01:56.390'
           ,30553
           ,'2012-05-29 10:01:56.390'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (316
           ,2067
           ,1
           ,30553
           ,'2012-05-30 08:57:03.360'
           ,30553
           ,'2012-05-30 08:57:03.360'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1244
           ,2066
           ,1
           ,30553
           ,'2012-07-20 11:12:30.367'
           ,30553
           ,'2012-07-20 11:12:30.367'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (640
           ,2065
           ,1
           ,30553
           ,'2012-06-15 11:26:38.777'
           ,30553
           ,'2012-06-15 11:26:38.777'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (462
           ,2063
           ,1
           ,30553
           ,'2012-06-06 10:21:46.317'
           ,30553
           ,'2012-06-06 10:21:46.317'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (463
           ,2062
           ,1
           ,30553
           ,'2012-06-06 10:23:24.640'
           ,30553
           ,'2012-06-06 10:23:24.640'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1038
           ,2061
           ,1
           ,47692
           ,'2012-07-10 12:50:12.590'
           ,47692
           ,'2012-07-10 12:50:12.590'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1037
           ,2061
           ,1
           ,47692
           ,'2012-07-10 12:49:36.767'
           ,47692
           ,'2012-07-10 12:49:36.767'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1056
           ,2057
           ,1
           ,47692
           ,'2012-07-12 09:10:05.847'
           ,47692
           ,'2012-07-12 09:10:05.847'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1055
           ,2057
           ,1
           ,47692
           ,'2012-07-12 09:09:39.700'
           ,47692
           ,'2012-07-12 09:09:39.700'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (625
           ,2051
           ,1
           ,30553
           ,'2012-06-15 08:17:24.467'
           ,30553
           ,'2012-06-15 08:17:24.467'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1058
           ,2049
           ,1
           ,47692
           ,'2012-07-12 10:23:29.363'
           ,47692
           ,'2012-07-12 10:23:29.363'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1057
           ,2049
           ,1
           ,47692
           ,'2012-07-12 10:22:58.177'
           ,47692
           ,'2012-07-12 10:22:58.177'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (852
           ,2049
           ,1
           ,30553
           ,'2012-07-03 08:30:15.480'
           ,30553
           ,'2012-07-03 08:30:15.480'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (507
           ,2048
           ,1
           ,30553
           ,'2012-06-08 10:08:01.420'
           ,30553
           ,'2012-06-08 10:08:01.420'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (502
           ,2047
           ,1
           ,30553
           ,'2012-06-08 08:29:00.443'
           ,30553
           ,'2012-06-08 08:29:00.443'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1123
           ,2045
           ,1
           ,47692
           ,'2012-07-13 12:19:03.423'
           ,47692
           ,'2012-07-13 12:19:03.423'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1122
           ,2045
           ,1
           ,47692
           ,'2012-07-13 12:18:40.673'
           ,47692
           ,'2012-07-13 12:18:40.673'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (595
           ,2043
           ,1
           ,30553
           ,'2012-06-14 04:51:56.317'
           ,30553
           ,'2012-06-14 04:51:56.317'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (965
           ,2040
           ,1
           ,47692
           ,'2012-07-06 13:34:37.183'
           ,47692
           ,'2012-07-06 13:34:37.183'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (957
           ,2040
           ,1
           ,47692
           ,'2012-07-06 13:27:36.667'
           ,47692
           ,'2012-07-06 13:27:36.667'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (955
           ,2040
           ,1
           ,47692
           ,'2012-07-06 13:27:05.610'
           ,47692
           ,'2012-07-06 13:27:05.610'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1174
           ,2036
           ,1
           ,30553
           ,'2012-07-18 06:18:59.680'
           ,30553
           ,'2012-07-18 06:18:59.680'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (611
           ,2035
           ,1
           ,30553
           ,'2012-06-14 07:57:55.140'
           ,30553
           ,'2012-06-14 07:57:55.140'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (478
           ,2033
           ,1
           ,30553
           ,'2012-06-07 09:03:22.063'
           ,30553
           ,'2012-06-07 09:03:22.063'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (419
           ,2023
           ,1
           ,30553
           ,'2012-06-05 04:37:32.533'
           ,30553
           ,'2012-06-05 04:37:32.533'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (420
           ,2022
           ,1
           ,30553
           ,'2012-06-05 04:39:26.580'
           ,30553
           ,'2012-06-05 04:39:26.580'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (732
           ,2019
           ,1
           ,30553
           ,'2012-06-21 12:08:20.943'
           ,30553
           ,'2012-06-21 12:08:20.943'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (469
           ,2005
           ,1
           ,30553
           ,'2012-06-07 05:39:40.760'
           ,30553
           ,'2012-06-07 05:39:40.760'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1120
           ,2004
           ,1
           ,47692
           ,'2012-07-13 12:09:22.677'
           ,47692
           ,'2012-07-13 12:09:22.677'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1119
           ,2004
           ,1
           ,47692
           ,'2012-07-13 12:08:41.593'
           ,47692
           ,'2012-07-13 12:08:41.593'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (259
           ,2000
           ,1
           ,30553
           ,'2012-05-24 08:52:10.137'
           ,30553
           ,'2012-05-24 08:52:10.137'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1161
           ,1996
           ,1
           ,30553
           ,'2012-07-17 06:12:40.287'
           ,30553
           ,'2012-07-17 06:12:40.287'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1009
           ,1992
           ,1
           ,47692
           ,'2012-07-09 08:53:54.387'
           ,47692
           ,'2012-07-09 08:53:54.387'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1008
           ,1992
           ,1
           ,47692
           ,'2012-07-09 08:53:29.037'
           ,47692
           ,'2012-07-09 08:53:29.037'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1063
           ,1989
           ,1
           ,47692
           ,'2012-07-12 11:37:47.917'
           ,47692
           ,'2012-07-12 11:37:47.917'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (944
           ,1983
           ,1
           ,47692
           ,'2012-07-06 13:13:33.720'
           ,47692
           ,'2012-07-06 13:13:33.720'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (240
           ,1983
           ,1
           ,30553
           ,'2012-05-24 06:13:00.833'
           ,30553
           ,'2012-05-24 06:13:00.833'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (918
           ,1980
           ,1
           ,47692
           ,'2012-07-06 12:46:31.450'
           ,47692
           ,'2012-07-06 12:46:31.450'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (917
           ,1980
           ,1
           ,47692
           ,'2012-07-06 12:46:05.113'
           ,47692
           ,'2012-07-06 12:46:05.113'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1112
           ,1974
           ,1
           ,47692
           ,'2012-07-13 11:51:16.363'
           ,47692
           ,'2012-07-13 11:51:16.363'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1111
           ,1974
           ,1
           ,47692
           ,'2012-07-13 11:50:51.947'
           ,47692
           ,'2012-07-13 11:50:51.947'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (485
           ,1966
           ,1
           ,30553
           ,'2012-06-07 11:14:52.663'
           ,30553
           ,'2012-06-07 11:14:52.663'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1152
           ,1962
           ,1
           ,30553
           ,'2012-07-16 10:57:31.723'
           ,30553
           ,'2012-07-16 10:57:31.723'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (559
           ,1951
           ,1
           ,30553
           ,'2012-06-12 07:01:12.073'
           ,30553
           ,'2012-06-12 07:01:12.073'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (443
           ,1936
           ,1
           ,30553
           ,'2012-06-06 04:27:41.693'
           ,30553
           ,'2012-06-06 04:27:41.693'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (658
           ,1919
           ,1
           ,30553
           ,'2012-06-15 12:22:50.167'
           ,30553
           ,'2012-06-15 12:22:50.167'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (756
           ,1918
           ,1
           ,30553
           ,'2012-06-25 07:28:14.307'
           ,30553
           ,'2012-06-25 07:28:14.307'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1194
           ,1914
           ,1
           ,30553
           ,'2012-07-19 05:26:33.193'
           ,30553
           ,'2012-07-19 05:26:33.193'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (612
           ,1912
           ,1
           ,30553
           ,'2012-06-14 07:59:43.010'
           ,30553
           ,'2012-06-14 07:59:43.010'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1154
           ,1908
           ,1
           ,30553
           ,'2012-07-16 11:23:55.260'
           ,30553
           ,'2012-07-16 11:23:55.260'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (708
           ,1901
           ,1
           ,30553
           ,'2012-06-21 05:36:58.117'
           ,30553
           ,'2012-06-21 05:36:58.117'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (874
           ,1900
           ,1
           ,30553
           ,'2012-07-05 12:04:12.477'
           ,30553
           ,'2012-07-05 12:04:12.477'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (733
           ,1892
           ,1
           ,30553
           ,'2012-06-21 12:18:52.807'
           ,30553
           ,'2012-06-21 12:18:52.807'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (563
           ,1887
           ,1
           ,30553
           ,'2012-06-12 07:47:04.080'
           ,30553
           ,'2012-06-12 07:47:04.080'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (800
           ,1885
           ,1
           ,30553
           ,'2012-06-27 08:05:27.450'
           ,30553
           ,'2012-06-27 08:05:27.450'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1214
           ,1884
           ,1
           ,30553
           ,'2012-07-19 07:14:22.450'
           ,30553
           ,'2012-07-19 07:14:22.450'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (624
           ,1881
           ,1
           ,30553
           ,'2012-06-15 08:16:51.703'
           ,30553
           ,'2012-06-15 08:16:51.703'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (260
           ,1872
           ,1
           ,30553
           ,'2012-05-24 12:00:51.130'
           ,30553
           ,'2012-05-24 12:00:51.130'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (230
           ,1871
           ,1
           ,30553
           ,'2012-05-22 05:24:03.953'
           ,30553
           ,'2012-05-22 05:24:03.953'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (220
           ,1871
           ,1
           ,30553
           ,'2012-05-21 13:55:47.280'
           ,30553
           ,'2012-05-21 13:55:47.280'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (346
           ,1859
           ,1
           ,30553
           ,'2012-05-30 12:14:55.330'
           ,30553
           ,'2012-05-30 12:14:55.330'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (846
           ,1857
           ,1
           ,30553
           ,'2012-07-03 07:04:38.333'
           ,30553
           ,'2012-07-03 07:04:38.333'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (554
           ,1856
           ,1
           ,30553
           ,'2012-06-12 05:19:41.083'
           ,30553
           ,'2012-06-12 05:19:41.083'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (242
           ,1848
           ,1
           ,30553
           ,'2012-05-24 06:15:43.710'
           ,30553
           ,'2012-05-24 06:15:43.710'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (581
           ,1847
           ,1
           ,30553
           ,'2012-06-13 07:25:04.330'
           ,30553
           ,'2012-06-13 07:25:04.330'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (580
           ,1847
           ,1
           ,30553
           ,'2012-06-13 07:20:16.013'
           ,30553
           ,'2012-06-13 07:20:16.013'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (808
           ,1839
           ,1
           ,30553
           ,'2012-06-28 08:11:03.363'
           ,30553
           ,'2012-06-28 08:11:03.363'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (814
           ,1834
           ,1
           ,30553
           ,'2012-06-28 13:48:11.090'
           ,30553
           ,'2012-06-28 13:48:11.090'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (636
           ,1830
           ,1
           ,30553
           ,'2012-06-15 11:08:01.703'
           ,30553
           ,'2012-06-15 11:08:01.703'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (501
           ,1819
           ,1
           ,30553
           ,'2012-06-08 08:27:41.930'
           ,30553
           ,'2012-06-08 08:27:41.930'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (809
           ,1817
           ,1
           ,30553
           ,'2012-06-28 08:12:09.510'
           ,30553
           ,'2012-06-28 08:12:09.510'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (647
           ,1803
           ,1
           ,30553
           ,'2012-06-15 11:41:43.820'
           ,30553
           ,'2012-06-15 11:41:43.820'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (217
           ,1802
           ,1
           ,30553
           ,'2012-05-21 11:05:24.427'
           ,30553
           ,'2012-05-21 11:05:24.427'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (844
           ,1794
           ,1
           ,30553
           ,'2012-07-03 07:01:02.283'
           ,30553
           ,'2012-07-03 07:01:02.283'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1035
           ,1780
           ,1
           ,47692
           ,'2012-07-10 12:17:14.130'
           ,47692
           ,'2012-07-10 12:17:14.130'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1034
           ,1780
           ,1
           ,47692
           ,'2012-07-10 12:16:54.117'
           ,47692
           ,'2012-07-10 12:16:54.117'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (257
           ,1758
           ,1
           ,30553
           ,'2012-05-24 08:35:42.967'
           ,30553
           ,'2012-05-24 08:35:42.967'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (337
           ,1749
           ,1
           ,30553
           ,'2012-05-30 11:21:06.133'
           ,30553
           ,'2012-05-30 11:21:06.133'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (860
           ,1747
           ,1
           ,30553
           ,'2012-07-03 11:14:50.583'
           ,30553
           ,'2012-07-03 11:14:50.583'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (840
           ,1739
           ,1
           ,34346
           ,'2012-07-02 12:10:47.190'
           ,34346
           ,'2012-07-02 12:10:47.190'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (234
           ,1734
           ,1
           ,30553
           ,'2012-05-22 06:01:56.860'
           ,30553
           ,'2012-05-22 06:01:56.860'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1145
           ,1729
           ,1
           ,30553
           ,'2012-07-16 05:40:12.933'
           ,30553
           ,'2012-07-16 05:40:12.933'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (714
           ,1725
           ,1
           ,30553
           ,'2012-06-21 07:56:46.957'
           ,30553
           ,'2012-06-21 07:56:46.957'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (849
           ,1717
           ,1
           ,30553
           ,'2012-07-03 08:27:04.293'
           ,30553
           ,'2012-07-03 08:27:04.293'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (301
           ,1712
           ,1
           ,30553
           ,'2012-05-29 12:14:02.903'
           ,30553
           ,'2012-05-29 12:14:02.903'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1185
           ,1705
           ,1
           ,30553
           ,'2012-07-18 08:43:13.800'
           ,30553
           ,'2012-07-18 08:43:13.800'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1206
           ,1698
           ,1
           ,30553
           ,'2012-07-19 07:00:53.720'
           ,30553
           ,'2012-07-19 07:00:53.720'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (424
           ,1695
           ,1
           ,30553
           ,'2012-06-05 04:45:04.207'
           ,30553
           ,'2012-06-05 04:45:04.207'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (423
           ,1695
           ,1
           ,30553
           ,'2012-06-05 04:44:09.837'
           ,30553
           ,'2012-06-05 04:44:09.837'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (597
           ,1689
           ,1
           ,30553
           ,'2012-06-14 04:55:17.630'
           ,30553
           ,'2012-06-14 04:55:17.630'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (675
           ,1684
           ,1
           ,30553
           ,'2012-06-18 11:17:34.420'
           ,30553
           ,'2012-06-18 11:17:34.420'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (719
           ,1680
           ,1
           ,30553
           ,'2012-06-21 08:48:49.803'
           ,30553
           ,'2012-06-21 08:48:49.803'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1225
           ,1676
           ,1
           ,30553
           ,'2012-07-19 12:10:59.800'
           ,30553
           ,'2012-07-19 12:10:59.800'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1189
           ,1667
           ,1
           ,34346
           ,'2012-07-18 09:51:07.997'
           ,34346
           ,'2012-07-18 09:51:07.997'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (730
           ,1662
           ,1
           ,30553
           ,'2012-06-21 11:53:03.850'
           ,30553
           ,'2012-06-21 11:53:03.850'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (713
           ,1661
           ,1
           ,30553
           ,'2012-06-21 07:48:29.470'
           ,30553
           ,'2012-06-21 07:48:29.470'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (715
           ,1660
           ,1
           ,30553
           ,'2012-06-21 08:22:36.930'
           ,30553
           ,'2012-06-21 08:22:36.930'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (289
           ,1648
           ,1
           ,30553
           ,'2012-05-29 09:57:22.813'
           ,30553
           ,'2012-05-29 09:57:22.813'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (294
           ,1647
           ,1
           ,30553
           ,'2012-05-29 10:01:04.860'
           ,30553
           ,'2012-05-29 10:01:04.860'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (757
           ,1639
           ,1
           ,30553
           ,'2012-06-25 07:29:05.570'
           ,30553
           ,'2012-06-25 07:29:05.570'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (224
           ,1618
           ,1
           ,30553
           ,'2012-05-22 04:19:41.360'
           ,30553
           ,'2012-05-22 04:19:41.360'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1191
           ,1614
           ,1
           ,34346
           ,'2012-07-18 09:53:33.847'
           ,34346
           ,'2012-07-18 09:53:33.847'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (245
           ,1607
           ,1
           ,30553
           ,'2012-05-24 06:19:24.363'
           ,30553
           ,'2012-05-24 06:19:24.363'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (735
           ,1601
           ,1
           ,30553
           ,'2012-06-22 07:03:49.483'
           ,30553
           ,'2012-06-22 07:03:49.483'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (662
           ,1598
           ,1
           ,30553
           ,'2012-06-15 12:29:10.117'
           ,30553
           ,'2012-06-15 12:29:10.117'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (740
           ,1593
           ,1
           ,30553
           ,'2012-06-22 07:09:24.607'
           ,30553
           ,'2012-06-22 07:09:24.607'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (679
           ,1589
           ,1
           ,30553
           ,'2012-06-18 13:45:58.127'
           ,30553
           ,'2012-06-18 13:45:58.127'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (655
           ,1583
           ,1
           ,30553
           ,'2012-06-15 12:20:30.087'
           ,30553
           ,'2012-06-15 12:20:30.087'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (354
           ,1576
           ,1
           ,30553
           ,'2012-05-31 10:09:02.170'
           ,30553
           ,'2012-05-31 10:09:02.170'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1252
           ,1565
           ,1
           ,30553
           ,'2012-07-20 13:21:14.590'
           ,30553
           ,'2012-07-20 13:21:14.590'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (504
           ,1565
           ,1
           ,30553
           ,'2012-06-08 09:51:23.290'
           ,30553
           ,'2012-06-08 09:51:23.290'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (608
           ,1544
           ,1
           ,30553
           ,'2012-06-14 07:01:05.537'
           ,30553
           ,'2012-06-14 07:01:05.537'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (254
           ,1536
           ,1
           ,30553
           ,'2012-05-24 08:30:55.563'
           ,30553
           ,'2012-05-24 08:30:55.563'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (304
           ,1522
           ,1
           ,30553
           ,'2012-05-29 12:17:10.990'
           ,30553
           ,'2012-05-29 12:17:10.990'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (303
           ,1521
           ,1
           ,30553
           ,'2012-05-29 12:15:59.607'
           ,30553
           ,'2012-05-29 12:15:59.607'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (246
           ,1520
           ,1
           ,30553
           ,'2012-05-24 06:20:55.040'
           ,30553
           ,'2012-05-24 06:20:55.040'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (553
           ,1517
           ,1
           ,30553
           ,'2012-06-12 05:17:17.867'
           ,30553
           ,'2012-06-12 05:17:17.867'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (492
           ,1513
           ,1
           ,30553
           ,'2012-06-08 04:48:31.817'
           ,30553
           ,'2012-06-08 04:48:31.817'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (272
           ,1513
           ,1
           ,30553
           ,'2012-05-25 11:18:48.557'
           ,30553
           ,'2012-05-25 11:18:48.557'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (556
           ,1505
           ,1
           ,30553
           ,'2012-06-12 05:21:55.270'
           ,30553
           ,'2012-06-12 05:21:55.270'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (512
           ,1500
           ,1
           ,30553
           ,'2012-06-08 10:17:38.230'
           ,30553
           ,'2012-06-08 10:17:38.230'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (299
           ,1492
           ,1
           ,30553
           ,'2012-05-29 12:11:28.893'
           ,30553
           ,'2012-05-29 12:11:28.893'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (228
           ,1480
           ,1
           ,30553
           ,'2012-05-22 04:39:55.137'
           ,30553
           ,'2012-05-22 04:39:55.137'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (776
           ,1468
           ,1
           ,30553
           ,'2012-06-26 04:58:01.860'
           ,30553
           ,'2012-06-26 04:58:01.860'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (936
           ,1452
           ,1
           ,47692
           ,'2012-07-06 13:05:54.560'
           ,47692
           ,'2012-07-06 13:05:54.560'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (871
           ,1452
           ,1
           ,30553
           ,'2012-07-05 11:53:00.833'
           ,30553
           ,'2012-07-05 11:53:00.833'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (928
           ,1451
           ,1
           ,47692
           ,'2012-07-06 12:59:01.690'
           ,47692
           ,'2012-07-06 12:59:01.690'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (870
           ,1451
           ,1
           ,30553
           ,'2012-07-05 11:52:21.603'
           ,30553
           ,'2012-07-05 11:52:21.603'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (356
           ,1447
           ,1
           ,30553
           ,'2012-05-31 10:10:10.130'
           ,30553
           ,'2012-05-31 10:10:10.130'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (355
           ,1447
           ,1
           ,30553
           ,'2012-05-31 10:09:53.673'
           ,30553
           ,'2012-05-31 10:09:53.673'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (204
           ,1431
           ,1
           ,30553
           ,'2012-05-21 08:44:58.840'
           ,30553
           ,'2012-05-21 08:44:58.840'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (211
           ,1428
           ,1
           ,30553
           ,'2012-05-21 09:05:14.787'
           ,30553
           ,'2012-05-21 09:05:14.787'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (630
           ,1423
           ,1
           ,30553
           ,'2012-06-15 10:39:32.617'
           ,30553
           ,'2012-06-15 10:39:32.617'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (588
           ,1414
           ,1
           ,30553
           ,'2012-06-13 08:52:28.470'
           ,30553
           ,'2012-06-13 08:52:28.470'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (285
           ,1401
           ,1
           ,30553
           ,'2012-05-29 09:43:23.767'
           ,30553
           ,'2012-05-29 09:43:23.767'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (825
           ,1400
           ,1
           ,30553
           ,'2012-06-29 09:59:25.050'
           ,30553
           ,'2012-06-29 09:59:25.050'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (801
           ,1398
           ,1
           ,30553
           ,'2012-06-27 08:23:01.777'
           ,30553
           ,'2012-06-27 08:23:01.777'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (649
           ,1397
           ,1
           ,30553
           ,'2012-06-15 11:51:43.030'
           ,30553
           ,'2012-06-15 11:51:43.030'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (607
           ,1397
           ,1
           ,30553
           ,'2012-06-14 06:59:57.067'
           ,30553
           ,'2012-06-14 06:59:57.067'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (778
           ,1395
           ,1
           ,30553
           ,'2012-06-26 05:02:38.273'
           ,30553
           ,'2012-06-26 05:02:38.273'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (481
           ,1392
           ,1
           ,30553
           ,'2012-06-07 10:57:47.803'
           ,30553
           ,'2012-06-07 10:57:47.803'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (255
           ,1390
           ,1
           ,30553
           ,'2012-05-24 08:32:10.690'
           ,30553
           ,'2012-05-24 08:32:10.690'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (412
           ,1389
           ,1
           ,30553
           ,'2012-06-05 04:12:26.667'
           ,30553
           ,'2012-06-05 04:12:26.667'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (411
           ,1389
           ,1
           ,30553
           ,'2012-06-05 04:11:26.570'
           ,30553
           ,'2012-06-05 04:11:26.570'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (768
           ,1378
           ,1
           ,30553
           ,'2012-06-25 08:41:55.203'
           ,30553
           ,'2012-06-25 08:41:55.203'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (726
           ,1373
           ,1
           ,30553
           ,'2012-06-21 11:47:38.143'
           ,30553
           ,'2012-06-21 11:47:38.143'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (515
           ,1371
           ,1
           ,30553
           ,'2012-06-08 10:36:55.920'
           ,30553
           ,'2012-06-08 10:36:55.920'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (455
           ,1363
           ,1
           ,30553
           ,'2012-06-06 09:59:18.837'
           ,30553
           ,'2012-06-06 09:59:18.837'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (454
           ,1363
           ,1
           ,30553
           ,'2012-06-06 09:58:59.813'
           ,30553
           ,'2012-06-06 09:58:59.813'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (797
           ,1360
           ,1
           ,30553
           ,'2012-06-27 07:43:10.870'
           ,30553
           ,'2012-06-27 07:43:10.870'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (796
           ,1360
           ,1
           ,30553
           ,'2012-06-27 07:42:46.263'
           ,30553
           ,'2012-06-27 07:42:46.263'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (471
           ,1359
           ,1
           ,30553
           ,'2012-06-07 08:01:55.220'
           ,30553
           ,'2012-06-07 08:01:55.220'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (470
           ,1359
           ,1
           ,30553
           ,'2012-06-07 08:01:11.377'
           ,30553
           ,'2012-06-07 08:01:11.377'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (610
           ,1358
           ,1
           ,30553
           ,'2012-06-14 07:57:09.103'
           ,30553
           ,'2012-06-14 07:57:09.103'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (452
           ,1356
           ,1
           ,30553
           ,'2012-06-06 09:53:39.113'
           ,30553
           ,'2012-06-06 09:53:39.113'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (451
           ,1356
           ,1
           ,30553
           ,'2012-06-06 09:53:00.547'
           ,30553
           ,'2012-06-06 09:53:00.547'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (770
           ,1353
           ,1
           ,30553
           ,'2012-06-25 08:45:36.037'
           ,30553
           ,'2012-06-25 08:45:36.037'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1241
           ,1351
           ,1
           ,30553
           ,'2012-07-20 11:06:15.930'
           ,30553
           ,'2012-07-20 11:06:15.930'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (330
           ,1347
           ,1
           ,30553
           ,'2012-05-30 10:52:49.467'
           ,30553
           ,'2012-05-30 10:52:49.467'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (717
           ,1346
           ,1
           ,30553
           ,'2012-06-21 08:40:10.083'
           ,30553
           ,'2012-06-21 08:40:10.083'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (267
           ,1340
           ,1
           ,30553
           ,'2012-05-24 13:28:36.770'
           ,30553
           ,'2012-05-24 13:28:36.770'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (650
           ,1336
           ,1
           ,30553
           ,'2012-06-15 12:15:15.853'
           ,30553
           ,'2012-06-15 12:15:15.853'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (769
           ,1335
           ,1
           ,30553
           ,'2012-06-25 08:44:39.667'
           ,30553
           ,'2012-06-25 08:44:39.667'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (665
           ,1332
           ,1
           ,30553
           ,'2012-06-15 12:32:28.407'
           ,30553
           ,'2012-06-15 12:32:28.407'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (762
           ,1299
           ,1
           ,30553
           ,'2012-06-25 08:32:53.437'
           ,30553
           ,'2012-06-25 08:32:53.437'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (674
           ,1297
           ,1
           ,30553
           ,'2012-06-18 11:16:30.000'
           ,30553
           ,'2012-06-18 11:16:30.000'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1243
           ,1278
           ,1
           ,30553
           ,'2012-07-20 11:10:45.910'
           ,30553
           ,'2012-07-20 11:10:45.910'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1209
           ,1270
           ,1
           ,34346
           ,'2012-07-19 07:08:01.290'
           ,34346
           ,'2012-07-19 07:08:01.290'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (872
           ,1265
           ,1
           ,30553
           ,'2012-07-05 12:01:26.260'
           ,30553
           ,'2012-07-05 12:01:26.260'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (781
           ,1260
           ,1
           ,30553
           ,'2012-06-26 05:11:30.210'
           ,30553
           ,'2012-06-26 05:11:30.210'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1203
           ,1256
           ,1
           ,30553
           ,'2012-07-19 06:56:05.853'
           ,30553
           ,'2012-07-19 06:56:05.853'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1175
           ,1249
           ,1
           ,34346
           ,'2012-07-18 06:37:30.460'
           ,34346
           ,'2012-07-18 06:37:30.460'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1060
           ,1240
           ,1
           ,47692
           ,'2012-07-12 10:39:50.930'
           ,47692
           ,'2012-07-12 10:39:50.930'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1059
           ,1240
           ,1
           ,47692
           ,'2012-07-12 10:38:56.770'
           ,47692
           ,'2012-07-12 10:38:56.770'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (343
           ,1240
           ,1
           ,30553
           ,'2012-05-30 12:01:03.177'
           ,30553
           ,'2012-05-30 12:01:03.177'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (313
           ,1240
           ,1
           ,30553
           ,'2012-05-30 08:47:29.337'
           ,30553
           ,'2012-05-30 08:47:29.337'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (308
           ,1240
           ,1
           ,30553
           ,'2012-05-29 13:14:50.307'
           ,30553
           ,'2012-05-29 13:14:50.307'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (212
           ,1237
           ,1
           ,30553
           ,'2012-05-21 09:15:43.300'
           ,30553
           ,'2012-05-21 09:15:43.300'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1164
           ,1228
           ,1
           ,30553
           ,'2012-07-17 08:48:04.147'
           ,30553
           ,'2012-07-17 08:48:04.147'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (683
           ,1223
           ,1
           ,30553
           ,'2012-06-19 06:28:34.997'
           ,30553
           ,'2012-06-19 06:28:34.997'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (831
           ,1213
           ,1
           ,30553
           ,'2012-06-29 10:25:25.663'
           ,30553
           ,'2012-06-29 10:25:25.663'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1006
           ,1207
           ,1
           ,30551
           ,'2012-07-09 07:20:41.033'
           ,30551
           ,'2012-07-09 07:20:41.033'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (414
           ,1206
           ,1
           ,30553
           ,'2012-06-05 04:16:43.810'
           ,30553
           ,'2012-06-05 04:16:43.810'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (413
           ,1206
           ,1
           ,30553
           ,'2012-06-05 04:15:38.320'
           ,30553
           ,'2012-06-05 04:15:38.320'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (550
           ,1204
           ,1
           ,30553
           ,'2012-06-11 06:41:22.943'
           ,30553
           ,'2012-06-11 06:41:22.943'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (341
           ,1199
           ,1
           ,30553
           ,'2012-05-30 11:39:13.300'
           ,30553
           ,'2012-05-30 11:39:13.300'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (418
           ,1190
           ,1
           ,30553
           ,'2012-06-05 04:29:42.670'
           ,30553
           ,'2012-06-05 04:29:42.670'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (992
           ,1179
           ,1
           ,30551
           ,'2012-07-09 06:51:07.180'
           ,30551
           ,'2012-07-09 06:51:07.180'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (256
           ,1172
           ,1
           ,30553
           ,'2012-05-24 08:34:06.183'
           ,30553
           ,'2012-05-24 08:34:06.183'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (652
           ,1171
           ,1
           ,30553
           ,'2012-06-15 12:17:11.920'
           ,30553
           ,'2012-06-15 12:17:11.920'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (651
           ,1166
           ,1
           ,30553
           ,'2012-06-15 12:16:10.683'
           ,30553
           ,'2012-06-15 12:16:10.683'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (865
           ,1164
           ,1
           ,30553
           ,'2012-07-05 05:47:58.853'
           ,30553
           ,'2012-07-05 05:47:58.853'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (440
           ,1161
           ,1
           ,30553
           ,'2012-06-05 06:35:59.960'
           ,30553
           ,'2012-06-05 06:35:59.960'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (339
           ,1159
           ,1
           ,30553
           ,'2012-05-30 11:36:42.230'
           ,30553
           ,'2012-05-30 11:36:42.230'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (430
           ,1150
           ,1
           ,30553
           ,'2012-06-05 05:36:55.477'
           ,30553
           ,'2012-06-05 05:36:55.477'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (429
           ,1150
           ,1
           ,30553
           ,'2012-06-05 05:36:31.100'
           ,30553
           ,'2012-06-05 05:36:31.100'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (828
           ,1146
           ,1
           ,30553
           ,'2012-06-29 10:18:00.230'
           ,30553
           ,'2012-06-29 10:18:00.230'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (227
           ,1145
           ,1
           ,30553
           ,'2012-05-22 04:29:26.103'
           ,30553
           ,'2012-05-22 04:29:26.103'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1218
           ,1103
           ,1
           ,30553
           ,'2012-07-19 08:29:13.250'
           ,30553
           ,'2012-07-19 08:29:13.250'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (477
           ,1100
           ,1
           ,30553
           ,'2012-06-07 09:02:38.390'
           ,30553
           ,'2012-06-07 09:02:38.390'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (460
           ,1097
           ,1
           ,30553
           ,'2012-06-06 10:06:04.830'
           ,30553
           ,'2012-06-06 10:06:04.830'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (263
           ,1093
           ,1
           ,30553
           ,'2012-05-24 12:03:13.680'
           ,30553
           ,'2012-05-24 12:03:13.680'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (321
           ,1092
           ,1
           ,30553
           ,'2012-05-30 09:02:06.897'
           ,30553
           ,'2012-05-30 09:02:06.897'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (320
           ,1092
           ,1
           ,30553
           ,'2012-05-30 09:01:46.817'
           ,30553
           ,'2012-05-30 09:01:46.817'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1045
           ,1078
           ,1
           ,47692
           ,'2012-07-11 06:46:57.553'
           ,47692
           ,'2012-07-11 06:46:57.553'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1044
           ,1078
           ,1
           ,47692
           ,'2012-07-11 06:46:15.590'
           ,47692
           ,'2012-07-11 06:46:15.590'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (237
           ,1034
           ,1
           ,30553
           ,'2012-05-22 06:53:32.023'
           ,30553
           ,'2012-05-22 06:53:32.023'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (431
           ,1033
           ,1
           ,30553
           ,'2012-06-05 06:00:47.950'
           ,30553
           ,'2012-06-05 06:00:47.950'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (479
           ,1030
           ,1
           ,30553
           ,'2012-06-07 09:05:25.273'
           ,30553
           ,'2012-06-07 09:05:25.273'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (441
           ,1026
           ,1
           ,30553
           ,'2012-06-05 09:00:27.600'
           ,30553
           ,'2012-06-05 09:00:27.600'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (839
           ,972
           ,1
           ,34346
           ,'2012-07-02 12:08:07.950'
           ,34346
           ,'2012-07-02 12:08:07.950'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (691
           ,970
           ,1
           ,30553
           ,'2012-06-19 11:16:45.010'
           ,30553
           ,'2012-06-19 11:16:45.010'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (812
           ,956
           ,1
           ,30553
           ,'2012-06-28 11:26:40.587'
           ,30553
           ,'2012-06-28 11:26:40.587'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (210
           ,948
           ,1
           ,30553
           ,'2012-05-21 09:04:13.710'
           ,30553
           ,'2012-05-21 09:04:13.710'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (422
           ,946
           ,1
           ,30553
           ,'2012-06-05 04:41:24.850'
           ,30553
           ,'2012-06-05 04:41:24.850'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (421
           ,946
           ,1
           ,30553
           ,'2012-06-05 04:40:43.900'
           ,30553
           ,'2012-06-05 04:40:43.900'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (857
           ,933
           ,1
           ,30553
           ,'2012-07-03 08:40:13.333'
           ,30553
           ,'2012-07-03 08:40:13.333'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (827
           ,923
           ,1
           ,30553
           ,'2012-06-29 10:16:43.790'
           ,30553
           ,'2012-06-29 10:16:43.790'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (552
           ,915
           ,1
           ,30553
           ,'2012-06-12 05:16:18.010'
           ,30553
           ,'2012-06-12 05:16:18.010'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (549
           ,915
           ,1
           ,30553
           ,'2012-06-11 06:19:54.570'
           ,30553
           ,'2012-06-11 06:19:54.570'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (307
           ,905
           ,1
           ,30553
           ,'2012-05-29 13:13:43.527'
           ,30553
           ,'2012-05-29 13:13:43.527'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (798
           ,892
           ,1
           ,30553
           ,'2012-06-27 07:46:26.080'
           ,30553
           ,'2012-06-27 07:46:26.080'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (506
           ,886
           ,1
           ,30553
           ,'2012-06-08 09:59:22.380'
           ,30553
           ,'2012-06-08 09:59:22.380'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (819
           ,884
           ,1
           ,30553
           ,'2012-06-29 09:36:14.173'
           ,30553
           ,'2012-06-29 09:36:14.173'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1224
           ,860
           ,1
           ,30553
           ,'2012-07-19 10:56:47.763'
           ,30553
           ,'2012-07-19 10:56:47.763'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (780
           ,856
           ,1
           ,30553
           ,'2012-06-26 05:05:20.850'
           ,30553
           ,'2012-06-26 05:05:20.850'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (426
           ,849
           ,1
           ,30553
           ,'2012-06-05 04:46:44.870'
           ,30553
           ,'2012-06-05 04:46:44.870'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1212
           ,848
           ,1
           ,30553
           ,'2012-07-19 07:09:48.227'
           ,30553
           ,'2012-07-19 07:09:48.227'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (406
           ,839
           ,1
           ,30553
           ,'2012-06-04 13:30:23.947'
           ,30553
           ,'2012-06-04 13:30:23.947'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (229
           ,837
           ,1
           ,30553
           ,'2012-05-22 04:52:56.900'
           ,30553
           ,'2012-05-22 04:52:56.900'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (203
           ,834
           ,1
           ,30553
           ,'2012-05-21 08:26:46.363'
           ,30553
           ,'2012-05-21 08:26:46.363'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (660
           ,829
           ,1
           ,30553
           ,'2012-06-15 12:25:27.637'
           ,30553
           ,'2012-06-15 12:25:27.637'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1208
           ,818
           ,1
           ,30553
           ,'2012-07-19 07:07:25.907'
           ,30553
           ,'2012-07-19 07:07:25.907'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (566
           ,783
           ,1
           ,30553
           ,'2012-06-12 10:57:53.320'
           ,30553
           ,'2012-06-12 10:57:53.320'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (349
           ,779
           ,1
           ,30553
           ,'2012-05-30 12:53:24.920'
           ,30553
           ,'2012-05-30 12:53:24.920'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (436
           ,767
           ,1
           ,30553
           ,'2012-06-05 06:27:34.593'
           ,30553
           ,'2012-06-05 06:27:34.593'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (319
           ,757
           ,1
           ,30553
           ,'2012-05-30 09:00:55.503'
           ,30553
           ,'2012-05-30 09:00:55.503'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (873
           ,756
           ,1
           ,30553
           ,'2012-07-05 12:03:33.877'
           ,30553
           ,'2012-07-05 12:03:33.877'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1073
           ,751
           ,1
           ,47692
           ,'2012-07-13 06:44:04.143'
           ,47692
           ,'2012-07-13 06:44:04.143'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1072
           ,751
           ,1
           ,47692
           ,'2012-07-13 06:43:44.487'
           ,47692
           ,'2012-07-13 06:43:44.487'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (334
           ,744
           ,1
           ,30553
           ,'2012-05-30 11:10:11.373'
           ,30553
           ,'2012-05-30 11:10:11.373'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (439
           ,742
           ,1
           ,30553
           ,'2012-06-05 06:35:22.157'
           ,30553
           ,'2012-06-05 06:35:22.157'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1173
           ,740
           ,1
           ,34346
           ,'2012-07-18 06:06:38.177'
           ,34346
           ,'2012-07-18 06:06:38.177'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (562
           ,740
           ,1
           ,30553
           ,'2012-06-12 07:24:34.780'
           ,30553
           ,'2012-06-12 07:24:34.780'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (357
           ,738
           ,1
           ,30553
           ,'2012-05-31 10:10:51.710'
           ,30553
           ,'2012-05-31 10:10:51.710'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (300
           ,736
           ,1
           ,30553
           ,'2012-05-29 12:13:29.383'
           ,30553
           ,'2012-05-29 12:13:29.383'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1192
           ,710
           ,1
           ,30553
           ,'2012-07-18 13:48:11.967'
           ,30553
           ,'2012-07-18 13:48:11.967'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (565
           ,707
           ,1
           ,30553
           ,'2012-06-12 10:56:43.273'
           ,30553
           ,'2012-06-12 10:56:43.273'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (241
           ,706
           ,1
           ,30553
           ,'2012-05-24 06:13:48.360'
           ,30553
           ,'2012-05-24 06:13:48.360'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (360
           ,695
           ,1
           ,30553
           ,'2012-05-31 11:05:09.323'
           ,30553
           ,'2012-05-31 11:05:09.323'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (266
           ,693
           ,1
           ,30553
           ,'2012-05-24 13:26:39.863'
           ,30553
           ,'2012-05-24 13:26:39.863'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1032
           ,682
           ,1
           ,47692
           ,'2012-07-10 11:53:47.267'
           ,47692
           ,'2012-07-10 11:53:47.267'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1031
           ,682
           ,1
           ,47692
           ,'2012-07-10 11:53:23.913'
           ,47692
           ,'2012-07-10 11:53:23.913'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1046
           ,668
           ,1
           ,47692
           ,'2012-07-11 07:46:28.760'
           ,47692
           ,'2012-07-11 07:46:28.760'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (497
           ,668
           ,1
           ,30553
           ,'2012-06-08 08:24:28.253'
           ,30553
           ,'2012-06-08 08:24:28.253'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (587
           ,658
           ,1
           ,30553
           ,'2012-06-13 08:51:43.207'
           ,30553
           ,'2012-06-13 08:51:43.207'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (583
           ,641
           ,1
           ,30553
           ,'2012-06-13 07:34:24.913'
           ,30553
           ,'2012-06-13 07:34:24.913'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (582
           ,641
           ,1
           ,30553
           ,'2012-06-13 07:34:03.130'
           ,30553
           ,'2012-06-13 07:34:03.130'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (318
           ,640
           ,1
           ,30553
           ,'2012-05-30 08:58:59.063'
           ,30553
           ,'2012-05-30 08:58:59.063'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (317
           ,640
           ,1
           ,30553
           ,'2012-05-30 08:57:49.720'
           ,30553
           ,'2012-05-30 08:57:49.720'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (820
           ,638
           ,1
           ,30553
           ,'2012-06-29 09:36:56.237'
           ,30553
           ,'2012-06-29 09:36:56.237'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (589
           ,619
           ,1
           ,30553
           ,'2012-06-13 09:39:05.483'
           ,30553
           ,'2012-06-13 09:39:05.483'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (249
           ,610
           ,1
           ,30553
           ,'2012-05-24 06:50:44.717'
           ,30553
           ,'2012-05-24 06:50:44.717'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (599
           ,593
           ,1
           ,30553
           ,'2012-06-14 05:03:15.887'
           ,30553
           ,'2012-06-14 05:03:15.887'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (579
           ,581
           ,1
           ,30553
           ,'2012-06-13 07:12:51.960'
           ,30553
           ,'2012-06-13 07:12:51.960'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (843
           ,577
           ,1
           ,30553
           ,'2012-07-03 07:00:25.900'
           ,30553
           ,'2012-07-03 07:00:25.900'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (750
           ,572
           ,1
           ,30553
           ,'2012-06-25 06:12:38.440'
           ,30553
           ,'2012-06-25 06:12:38.440'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (853
           ,569
           ,1
           ,30553
           ,'2012-07-03 08:31:23.067'
           ,30553
           ,'2012-07-03 08:31:23.067'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (365
           ,560
           ,1
           ,30553
           ,'2012-06-01 05:38:15.210'
           ,30553
           ,'2012-06-01 05:38:15.210'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (461
           ,556
           ,1
           ,30553
           ,'2012-06-06 10:17:40.907'
           ,30553
           ,'2012-06-06 10:17:40.907'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (361
           ,543
           ,1
           ,30553
           ,'2012-05-31 11:09:41.290'
           ,30553
           ,'2012-05-31 11:09:41.290'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (634
           ,541
           ,1
           ,30553
           ,'2012-06-15 11:03:11.943'
           ,30553
           ,'2012-06-15 11:03:11.943'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (453
           ,531
           ,1
           ,30553
           ,'2012-06-06 09:55:03.743'
           ,30553
           ,'2012-06-06 09:55:03.743'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1179
           ,520
           ,1
           ,30553
           ,'2012-07-18 08:21:48.760'
           ,30553
           ,'2012-07-18 08:21:48.760'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (571
           ,512
           ,1
           ,30553
           ,'2012-06-12 11:32:21.483'
           ,30553
           ,'2012-06-12 11:32:21.483'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (685
           ,510
           ,1
           ,30553
           ,'2012-06-19 07:38:08.743'
           ,30553
           ,'2012-06-19 07:38:08.743'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (663
           ,497
           ,1
           ,30553
           ,'2012-06-15 12:30:10.153'
           ,30553
           ,'2012-06-15 12:30:10.153'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (712
           ,489
           ,1
           ,30553
           ,'2012-06-21 07:47:46.893'
           ,30553
           ,'2012-06-21 07:47:46.893'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (499
           ,486
           ,1
           ,30553
           ,'2012-06-08 08:26:08.893'
           ,30553
           ,'2012-06-08 08:26:08.893'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (867
           ,477
           ,1
           ,30553
           ,'2012-07-05 06:51:43.640'
           ,30553
           ,'2012-07-05 06:51:43.640'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (311
           ,467
           ,1
           ,30553
           ,'2012-05-30 08:46:05.513'
           ,30553
           ,'2012-05-30 08:46:05.513'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1162
           ,448
           ,1
           ,30553
           ,'2012-07-17 07:05:17.120'
           ,30553
           ,'2012-07-17 07:05:17.120'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (862
           ,435
           ,1
           ,30553
           ,'2012-07-03 11:34:27.787'
           ,30553
           ,'2012-07-03 11:34:27.787'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (262
           ,427
           ,1
           ,30553
           ,'2012-05-24 12:02:27.573'
           ,30553
           ,'2012-05-24 12:02:27.573'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (261
           ,427
           ,1
           ,30553
           ,'2012-05-24 12:02:03.087'
           ,30553
           ,'2012-05-24 12:02:03.087'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (558
           ,415
           ,1
           ,30553
           ,'2012-06-12 05:42:40.583'
           ,30553
           ,'2012-06-12 05:42:40.583'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (329
           ,414
           ,1
           ,30553
           ,'2012-05-30 10:45:25.740'
           ,30553
           ,'2012-05-30 10:45:25.740'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (428
           ,411
           ,1
           ,30553
           ,'2012-06-05 05:31:33.303'
           ,30553
           ,'2012-06-05 05:31:33.303'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1198
           ,393
           ,1
           ,30553
           ,'2012-07-19 05:41:45.973'
           ,30553
           ,'2012-07-19 05:41:45.973'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1195
           ,387
           ,1
           ,30553
           ,'2012-07-19 05:30:22.977'
           ,30553
           ,'2012-07-19 05:30:22.977'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1169
           ,381
           ,1
           ,30553
           ,'2012-07-17 10:46:15.350'
           ,30553
           ,'2012-07-17 10:46:15.350'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (664
           ,376
           ,1
           ,30553
           ,'2012-06-15 12:31:52.253'
           ,30553
           ,'2012-06-15 12:31:52.253'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (724
           ,369
           ,1
           ,30553
           ,'2012-06-21 10:47:45.667'
           ,30553
           ,'2012-06-21 10:47:45.667'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (425
           ,364
           ,1
           ,30553
           ,'2012-06-05 04:45:55.617'
           ,30553
           ,'2012-06-05 04:45:55.617'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (244
           ,321
           ,1
           ,30553
           ,'2012-05-24 06:18:12.387'
           ,30553
           ,'2012-05-24 06:18:12.387'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (315
           ,320
           ,1
           ,30553
           ,'2012-05-30 08:56:14.787'
           ,30553
           ,'2012-05-30 08:56:14.787'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1187
           ,288
           ,1
           ,30553
           ,'2012-07-18 08:53:46.237'
           ,30553
           ,'2012-07-18 08:53:46.237'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (863
           ,274
           ,1
           ,30553
           ,'2012-07-03 11:34:52.940'
           ,30553
           ,'2012-07-03 11:34:52.940'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (457
           ,260
           ,1
           ,30553
           ,'2012-06-06 10:00:52.333'
           ,30553
           ,'2012-06-06 10:00:52.333'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (711
           ,250
           ,1
           ,30553
           ,'2012-06-21 07:36:52.877'
           ,30553
           ,'2012-06-21 07:36:52.877'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (824
           ,246
           ,1
           ,30553
           ,'2012-06-29 09:41:40.593'
           ,30553
           ,'2012-06-29 09:41:40.593'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1205
           ,239
           ,1
           ,30553
           ,'2012-07-19 06:57:38.913'
           ,30553
           ,'2012-07-19 06:57:38.913'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (265
           ,233
           ,1
           ,30553
           ,'2012-05-24 12:07:36.437'
           ,30553
           ,'2012-05-24 12:07:36.437'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1232
           ,226
           ,1
           ,30553
           ,'2012-07-20 07:55:45.340'
           ,30553
           ,'2012-07-20 07:55:45.340'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (253
           ,222
           ,1
           ,30553
           ,'2012-05-24 08:29:40.790'
           ,30553
           ,'2012-05-24 08:29:40.790'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (466
           ,217
           ,1
           ,30553
           ,'2012-06-06 11:19:29.533'
           ,30553
           ,'2012-06-06 11:19:29.533'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (605
           ,197
           ,1
           ,30553
           ,'2012-06-14 06:57:16.890'
           ,30553
           ,'2012-06-14 06:57:16.890'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (725
           ,196
           ,1
           ,30553
           ,'2012-06-21 10:48:24.240'
           ,30553
           ,'2012-06-21 10:48:24.240'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (806
           ,195
           ,1
           ,30553
           ,'2012-06-28 08:07:40.140'
           ,30553
           ,'2012-06-28 08:07:40.140'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (810
           ,191
           ,1
           ,30553
           ,'2012-06-28 08:15:01.440'
           ,30553
           ,'2012-06-28 08:15:01.440'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (293
           ,189
           ,1
           ,30553
           ,'2012-05-29 10:00:06.507'
           ,30553
           ,'2012-05-29 10:00:06.507'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (284
           ,189
           ,1
           ,30553
           ,'2012-05-29 09:42:29.603'
           ,30553
           ,'2012-05-29 09:42:29.603'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (823
           ,186
           ,1
           ,30553
           ,'2012-06-29 09:40:31.707'
           ,30553
           ,'2012-06-29 09:40:31.707'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1245
           ,174
           ,1
           ,30553
           ,'2012-07-20 11:13:41.127'
           ,30553
           ,'2012-07-20 11:13:41.127'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (309
           ,166
           ,1
           ,30553
           ,'2012-05-29 13:16:48.430'
           ,30553
           ,'2012-05-29 13:16:48.430'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (747
           ,160
           ,1
           ,30553
           ,'2012-06-22 12:51:29.237'
           ,30553
           ,'2012-06-22 12:51:29.237'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1178
           ,137
           ,1
           ,30553
           ,'2012-07-18 07:12:29.017'
           ,30553
           ,'2012-07-18 07:12:29.017'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1159
           ,122
           ,1
           ,30553
           ,'2012-07-17 05:44:31.537'
           ,30553
           ,'2012-07-17 05:44:31.537'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1023
           ,116
           ,1
           ,47692
           ,'2012-07-10 07:13:13.547'
           ,47692
           ,'2012-07-10 07:13:13.547'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1022
           ,116
           ,1
           ,47692
           ,'2012-07-10 07:12:47.180'
           ,47692
           ,'2012-07-10 07:12:47.180'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (836
           ,98
           ,1
           ,30553
           ,'2012-07-02 06:16:05.903'
           ,30553
           ,'2012-07-02 06:16:05.903'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (835
           ,98
           ,1
           ,30553
           ,'2012-07-02 06:15:45.580'
           ,30553
           ,'2012-07-02 06:15:45.580'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (448
           ,6632
           ,3
           ,30553
           ,'2012-06-06 09:44:00.697'
           ,30553
           ,'2012-06-06 09:44:00.697'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (359
           ,6572
           ,3
           ,40626
           ,'2012-05-31 11:59:48.967'
           ,40626
           ,'2012-05-31 11:59:48.967'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (232
           ,6288
           ,3
           ,30553
           ,'2012-05-22 05:48:04.537'
           ,30553
           ,'2012-05-22 05:48:04.537'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (359
           ,5239
           ,3
           ,30553
           ,'2012-05-31 11:01:55.547'
           ,30553
           ,'2012-05-31 11:01:55.547'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (238
           ,4573
           ,3
           ,30553
           ,'2012-05-24 06:08:48.563'
           ,30553
           ,'2012-05-24 06:08:48.563'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1132
           ,3277
           ,8
           ,34037
           ,'2012-07-13 12:42:24.173'
           ,34037
           ,'2012-07-13 12:42:24.173'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1131
           ,3277
           ,8
           ,34037
           ,'2012-07-13 12:41:14.527'
           ,34037
           ,'2012-07-13 12:41:14.527'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1099
           ,3275
           ,8
           ,34037
           ,'2012-07-13 09:00:58.010'
           ,34037
           ,'2012-07-13 09:00:58.010'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1095
           ,3274
           ,8
           ,34037
           ,'2012-07-13 08:56:33.647'
           ,34037
           ,'2012-07-13 08:56:33.647'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1156
           ,3257
           ,8
           ,34346
           ,'2012-07-16 13:17:32.040'
           ,34346
           ,'2012-07-16 13:17:32.040'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1090
           ,3244
           ,8
           ,34037
           ,'2012-07-13 08:44:00.837'
           ,34037
           ,'2012-07-13 08:44:00.837'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1092
           ,3243
           ,8
           ,34037
           ,'2012-07-13 08:49:03.910'
           ,34037
           ,'2012-07-13 08:49:03.910'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1093
           ,3201
           ,8
           ,34037
           ,'2012-07-13 08:50:37.930'
           ,34037
           ,'2012-07-13 08:50:37.930'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1087
           ,3137
           ,8
           ,34037
           ,'2012-07-13 08:41:03.150'
           ,34037
           ,'2012-07-13 08:41:03.150'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1158
           ,3119
           ,8
           ,34346
           ,'2012-07-16 13:20:51.430'
           ,34346
           ,'2012-07-16 13:20:51.430'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1094
           ,2889
           ,8
           ,34037
           ,'2012-07-13 08:51:20.147'
           ,34037
           ,'2012-07-13 08:51:20.147'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1137
           ,2865
           ,8
           ,34037
           ,'2012-07-13 13:34:15.200'
           ,34037
           ,'2012-07-13 13:34:15.200'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1129
           ,2827
           ,8
           ,34037
           ,'2012-07-13 12:39:09.133'
           ,34037
           ,'2012-07-13 12:39:09.133'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1128
           ,2827
           ,8
           ,34037
           ,'2012-07-13 12:38:15.170'
           ,34037
           ,'2012-07-13 12:38:15.170'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1130
           ,2779
           ,8
           ,34037
           ,'2012-07-13 12:40:20.263'
           ,34037
           ,'2012-07-13 12:40:20.263'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (377
           ,2615
           ,8
           ,34037
           ,'2012-06-01 12:40:36.097'
           ,34037
           ,'2012-06-01 12:40:36.097'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (376
           ,2601
           ,8
           ,34037
           ,'2012-06-01 12:37:39.350'
           ,34037
           ,'2012-06-01 12:37:39.350'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (370
           ,2593
           ,8
           ,34037
           ,'2012-06-01 12:18:01.673'
           ,34037
           ,'2012-06-01 12:18:01.673'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (378
           ,2588
           ,8
           ,34037
           ,'2012-06-01 12:42:24.930'
           ,34037
           ,'2012-06-01 12:42:24.930'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1124
           ,2570
           ,8
           ,34037
           ,'2012-07-13 12:19:27.547'
           ,34037
           ,'2012-07-13 12:19:27.547'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1121
           ,2570
           ,8
           ,34037
           ,'2012-07-13 12:17:39.110'
           ,34037
           ,'2012-07-13 12:17:39.110'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (371
           ,2556
           ,8
           ,34037
           ,'2012-06-01 12:22:19.130'
           ,34037
           ,'2012-06-01 12:22:19.130'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (374
           ,2537
           ,8
           ,34037
           ,'2012-06-01 12:31:44.003'
           ,34037
           ,'2012-06-01 12:31:44.003'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (534
           ,2531
           ,8
           ,34037
           ,'2012-06-08 14:36:20.597'
           ,34037
           ,'2012-06-08 14:36:20.597'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (533
           ,2531
           ,8
           ,34037
           ,'2012-06-08 14:35:17.720'
           ,34037
           ,'2012-06-08 14:35:17.720'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (536
           ,2525
           ,8
           ,34037
           ,'2012-06-08 14:38:12.497'
           ,34037
           ,'2012-06-08 14:38:12.497'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (535
           ,2525
           ,8
           ,34037
           ,'2012-06-08 14:37:08.377'
           ,34037
           ,'2012-06-08 14:37:08.377'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (390
           ,2522
           ,8
           ,34037
           ,'2012-06-01 13:35:17.073'
           ,34037
           ,'2012-06-01 13:35:17.073'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1091
           ,2504
           ,8
           ,34037
           ,'2012-07-13 08:44:52.747'
           ,34037
           ,'2012-07-13 08:44:52.747'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (389
           ,2502
           ,8
           ,34037
           ,'2012-06-01 13:21:35.240'
           ,34037
           ,'2012-06-01 13:21:35.240'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (529
           ,2500
           ,8
           ,34037
           ,'2012-06-08 14:29:48.573'
           ,34037
           ,'2012-06-08 14:29:48.573'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (386
           ,2494
           ,8
           ,34037
           ,'2012-06-01 13:13:31.530'
           ,34037
           ,'2012-06-01 13:13:31.530'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (531
           ,2467
           ,8
           ,34037
           ,'2012-06-08 14:32:15.993'
           ,34037
           ,'2012-06-08 14:32:15.993'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (530
           ,2467
           ,8
           ,34037
           ,'2012-06-08 14:31:30.130'
           ,34037
           ,'2012-06-08 14:31:30.130'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (388
           ,2462
           ,8
           ,34037
           ,'2012-06-01 13:19:18.307'
           ,34037
           ,'2012-06-01 13:19:18.307'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (372
           ,2452
           ,8
           ,34037
           ,'2012-06-01 12:26:31.210'
           ,34037
           ,'2012-06-01 12:26:31.210'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (539
           ,2447
           ,8
           ,34037
           ,'2012-06-08 14:42:05.893'
           ,34037
           ,'2012-06-08 14:42:05.893'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (538
           ,2447
           ,8
           ,34037
           ,'2012-06-08 14:40:56.387'
           ,34037
           ,'2012-06-08 14:40:56.387'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (387
           ,2444
           ,8
           ,34037
           ,'2012-06-01 13:17:30.590'
           ,34037
           ,'2012-06-01 13:17:30.590'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (383
           ,2443
           ,8
           ,34037
           ,'2012-06-01 12:58:39.897'
           ,34037
           ,'2012-06-01 12:58:39.897'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (381
           ,2439
           ,8
           ,34037
           ,'2012-06-01 12:52:05.990'
           ,34037
           ,'2012-06-01 12:52:05.990'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (379
           ,2436
           ,8
           ,34037
           ,'2012-06-01 12:48:40.160'
           ,34037
           ,'2012-06-01 12:48:40.160'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (382
           ,2433
           ,8
           ,34037
           ,'2012-06-01 12:53:30.760'
           ,34037
           ,'2012-06-01 12:53:30.760'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (528
           ,2425
           ,8
           ,34037
           ,'2012-06-08 14:28:12.813'
           ,34037
           ,'2012-06-08 14:28:12.813'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (391
           ,2404
           ,8
           ,34037
           ,'2012-06-01 13:47:54.333'
           ,34037
           ,'2012-06-01 13:47:54.333'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (526
           ,2390
           ,8
           ,34037
           ,'2012-06-08 14:21:45.373'
           ,34037
           ,'2012-06-08 14:21:45.373'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (525
           ,2390
           ,8
           ,34037
           ,'2012-06-08 14:20:39.660'
           ,34037
           ,'2012-06-08 14:20:39.660'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (385
           ,2384
           ,8
           ,34037
           ,'2012-06-01 13:02:00.903'
           ,34037
           ,'2012-06-01 13:02:00.903'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (963
           ,2369
           ,8
           ,34037
           ,'2012-07-06 13:33:40.257'
           ,34037
           ,'2012-07-06 13:33:40.257'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (972
           ,2368
           ,8
           ,34037
           ,'2012-07-06 13:40:11.227'
           ,34037
           ,'2012-07-06 13:40:11.227'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (977
           ,2355
           ,8
           ,34037
           ,'2012-07-06 13:50:43.743'
           ,34037
           ,'2012-07-06 13:50:43.743'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (976
           ,2355
           ,8
           ,34037
           ,'2012-07-06 13:50:10.860'
           ,34037
           ,'2012-07-06 13:50:10.860'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (523
           ,2320
           ,8
           ,34037
           ,'2012-06-08 14:14:25.017'
           ,34037
           ,'2012-06-08 14:14:25.017'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (522
           ,2320
           ,8
           ,34037
           ,'2012-06-08 14:11:26.497'
           ,34037
           ,'2012-06-08 14:11:26.497'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1114
           ,2312
           ,8
           ,34037
           ,'2012-07-13 11:52:12.190'
           ,34037
           ,'2012-07-13 11:52:12.190'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (532
           ,2311
           ,8
           ,34037
           ,'2012-06-08 14:34:16.500'
           ,34037
           ,'2012-06-08 14:34:16.500'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (380
           ,2295
           ,8
           ,34037
           ,'2012-06-01 12:51:06.557'
           ,34037
           ,'2012-06-01 12:51:06.557'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (978
           ,2294
           ,8
           ,34037
           ,'2012-07-06 13:51:16.167'
           ,34037
           ,'2012-07-06 13:51:16.167'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1115
           ,2288
           ,8
           ,34037
           ,'2012-07-13 11:53:05.230'
           ,34037
           ,'2012-07-13 11:53:05.230'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (375
           ,2282
           ,8
           ,34037
           ,'2012-06-01 12:35:30.137'
           ,34037
           ,'2012-06-01 12:35:30.137'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1133
           ,2269
           ,8
           ,34037
           ,'2012-07-13 12:50:01.187'
           ,34037
           ,'2012-07-13 12:50:01.187'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (935
           ,2267
           ,8
           ,34037
           ,'2012-07-06 13:04:57.507'
           ,34037
           ,'2012-07-06 13:04:57.507'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (527
           ,2251
           ,8
           ,34037
           ,'2012-06-08 14:26:56.673'
           ,34037
           ,'2012-06-08 14:26:56.673'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (988
           ,2250
           ,8
           ,34037
           ,'2012-07-06 14:00:08.903'
           ,34037
           ,'2012-07-06 14:00:08.903'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (400
           ,2246
           ,8
           ,34037
           ,'2012-06-01 14:19:58.400'
           ,34037
           ,'2012-06-01 14:19:58.400'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (545
           ,2234
           ,8
           ,34037
           ,'2012-06-08 14:56:51.370'
           ,34037
           ,'2012-06-08 14:56:51.370'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (394
           ,2208
           ,8
           ,34037
           ,'2012-06-01 14:06:22.310'
           ,34037
           ,'2012-06-01 14:06:22.310'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (540
           ,2192
           ,8
           ,34037
           ,'2012-06-08 14:47:34.100'
           ,34037
           ,'2012-06-08 14:47:34.100'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (401
           ,2186
           ,8
           ,34037
           ,'2012-06-01 14:41:01.943'
           ,34037
           ,'2012-06-01 14:41:01.943'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (951
           ,2177
           ,8
           ,34037
           ,'2012-07-06 13:19:49.630'
           ,34037
           ,'2012-07-06 13:19:49.630'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1103
           ,2154
           ,8
           ,34037
           ,'2012-07-13 11:19:55.383'
           ,34037
           ,'2012-07-13 11:19:55.383'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1102
           ,2154
           ,8
           ,34037
           ,'2012-07-13 11:19:10.440'
           ,34037
           ,'2012-07-13 11:19:10.440'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (402
           ,2153
           ,8
           ,34037
           ,'2012-06-01 14:43:34.523'
           ,34037
           ,'2012-06-01 14:43:34.523'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (544
           ,2137
           ,8
           ,34037
           ,'2012-06-08 14:53:59.217'
           ,34037
           ,'2012-06-08 14:53:59.217'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (543
           ,2130
           ,8
           ,34037
           ,'2012-06-08 14:52:16.437'
           ,34037
           ,'2012-06-08 14:52:16.437'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (542
           ,2130
           ,8
           ,34037
           ,'2012-06-08 14:51:07.270'
           ,34037
           ,'2012-06-08 14:51:07.270'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (395
           ,2128
           ,8
           ,34037
           ,'2012-06-01 14:08:09.140'
           ,34037
           ,'2012-06-01 14:08:09.140'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (548
           ,2117
           ,8
           ,34037
           ,'2012-06-08 15:03:23.437'
           ,34037
           ,'2012-06-08 15:03:23.437'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (393
           ,2104
           ,8
           ,34037
           ,'2012-06-01 13:56:10.927'
           ,34037
           ,'2012-06-01 13:56:10.927'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (399
           ,2103
           ,8
           ,34037
           ,'2012-06-01 14:15:56.253'
           ,34037
           ,'2012-06-01 14:15:56.253'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (373
           ,2094
           ,8
           ,34037
           ,'2012-06-01 12:29:30.030'
           ,34037
           ,'2012-06-01 12:29:30.030'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (541
           ,2085
           ,8
           ,34037
           ,'2012-06-08 14:49:01.363'
           ,34037
           ,'2012-06-08 14:49:01.363'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (398
           ,2079
           ,8
           ,34037
           ,'2012-06-01 14:13:34.833'
           ,34037
           ,'2012-06-01 14:13:34.833'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (537
           ,2073
           ,8
           ,34037
           ,'2012-06-08 14:39:35.240'
           ,34037
           ,'2012-06-08 14:39:35.240'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (396
           ,2073
           ,8
           ,34037
           ,'2012-06-01 14:10:25.447'
           ,34037
           ,'2012-06-01 14:10:25.447'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1105
           ,2072
           ,8
           ,34037
           ,'2012-07-13 11:24:44.040'
           ,34037
           ,'2012-07-13 11:24:44.040'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1104
           ,2072
           ,8
           ,34037
           ,'2012-07-13 11:23:40.147'
           ,34037
           ,'2012-07-13 11:23:40.147'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (369
           ,2013
           ,8
           ,34037
           ,'2012-06-01 12:12:01.237'
           ,34037
           ,'2012-06-01 12:12:01.237'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1134
           ,2009
           ,8
           ,34037
           ,'2012-07-13 13:23:20.663'
           ,34037
           ,'2012-07-13 13:23:20.663'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (397
           ,2002
           ,8
           ,34037
           ,'2012-06-01 14:11:42.693'
           ,34037
           ,'2012-06-01 14:11:42.693'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (403
           ,1977
           ,8
           ,34037
           ,'2012-06-01 14:51:39.427'
           ,34037
           ,'2012-06-01 14:51:39.427'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1076
           ,1975
           ,8
           ,34037
           ,'2012-07-13 07:55:49.413'
           ,34037
           ,'2012-07-13 07:55:49.413'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (547
           ,1973
           ,8
           ,34037
           ,'2012-06-08 15:00:18.717'
           ,34037
           ,'2012-06-08 15:00:18.717'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (546
           ,1973
           ,8
           ,34037
           ,'2012-06-08 14:59:34.200'
           ,34037
           ,'2012-06-08 14:59:34.200'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (904
           ,1956
           ,8
           ,34037
           ,'2012-07-06 12:27:30.033'
           ,34037
           ,'2012-07-06 12:27:30.033'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (913
           ,1918
           ,8
           ,34037
           ,'2012-07-06 12:35:14.203'
           ,34037
           ,'2012-07-06 12:35:14.203'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (980
           ,1909
           ,8
           ,34037
           ,'2012-07-06 13:53:12.203'
           ,34037
           ,'2012-07-06 13:53:12.203'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (967
           ,1905
           ,8
           ,34037
           ,'2012-07-06 13:36:05.383'
           ,34037
           ,'2012-07-06 13:36:05.383'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (938
           ,1897
           ,8
           ,34037
           ,'2012-07-06 13:06:36.190'
           ,34037
           ,'2012-07-06 13:06:36.190'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (937
           ,1897
           ,8
           ,34037
           ,'2012-07-06 13:05:55.110'
           ,34037
           ,'2012-07-06 13:05:55.110'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (916
           ,1876
           ,8
           ,34037
           ,'2012-07-06 12:40:27.540'
           ,34037
           ,'2012-07-06 12:40:27.540'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (920
           ,1874
           ,8
           ,34037
           ,'2012-07-06 12:48:40.817'
           ,34037
           ,'2012-07-06 12:48:40.817'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (893
           ,1861
           ,8
           ,34037
           ,'2012-07-06 12:05:18.953'
           ,34037
           ,'2012-07-06 12:05:18.953'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (892
           ,1861
           ,8
           ,34037
           ,'2012-07-06 12:04:05.120'
           ,34037
           ,'2012-07-06 12:04:05.120'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (891
           ,1854
           ,8
           ,34037
           ,'2012-07-06 11:59:19.467'
           ,34037
           ,'2012-07-06 11:59:19.467'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (890
           ,1854
           ,8
           ,34037
           ,'2012-07-06 11:50:02.100'
           ,34037
           ,'2012-07-06 11:50:02.100'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1110
           ,1851
           ,8
           ,34037
           ,'2012-07-13 11:50:35.417'
           ,34037
           ,'2012-07-13 11:50:35.417'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1141
           ,1841
           ,8
           ,34037
           ,'2012-07-13 13:54:26.617'
           ,34037
           ,'2012-07-13 13:54:26.617'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1113
           ,1829
           ,8
           ,34037
           ,'2012-07-13 11:51:27.237'
           ,34037
           ,'2012-07-13 11:51:27.237'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1089
           ,1824
           ,8
           ,34037
           ,'2012-07-13 08:43:07.860'
           ,34037
           ,'2012-07-13 08:43:07.860'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (975
           ,1819
           ,8
           ,34037
           ,'2012-07-06 13:48:52.773'
           ,34037
           ,'2012-07-06 13:48:52.773'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (922
           ,1797
           ,8
           ,34037
           ,'2012-07-06 12:50:22.910'
           ,34037
           ,'2012-07-06 12:50:22.910'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1143
           ,1786
           ,8
           ,34037
           ,'2012-07-13 14:02:06.283'
           ,34037
           ,'2012-07-13 14:02:06.283'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1142
           ,1786
           ,8
           ,34037
           ,'2012-07-13 13:56:11.683'
           ,34037
           ,'2012-07-13 13:56:11.683'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1140
           ,1771
           ,8
           ,34037
           ,'2012-07-13 13:38:59.513'
           ,34037
           ,'2012-07-13 13:38:59.513'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1139
           ,1771
           ,8
           ,34037
           ,'2012-07-13 13:38:30.000'
           ,34037
           ,'2012-07-13 13:38:30.000'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1138
           ,1771
           ,8
           ,34037
           ,'2012-07-13 13:38:01.753'
           ,34037
           ,'2012-07-13 13:38:01.753'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (915
           ,1735
           ,8
           ,34037
           ,'2012-07-06 12:38:11.873'
           ,34037
           ,'2012-07-06 12:38:11.873'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (914
           ,1735
           ,8
           ,34037
           ,'2012-07-06 12:36:40.763'
           ,34037
           ,'2012-07-06 12:36:40.763'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (902
           ,1724
           ,8
           ,34037
           ,'2012-07-06 12:19:41.093'
           ,34037
           ,'2012-07-06 12:19:41.093'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (900
           ,1724
           ,8
           ,34037
           ,'2012-07-06 12:17:23.227'
           ,34037
           ,'2012-07-06 12:17:23.227'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (899
           ,1723
           ,8
           ,34037
           ,'2012-07-06 12:15:58.190'
           ,34037
           ,'2012-07-06 12:15:58.190'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (898
           ,1723
           ,8
           ,34037
           ,'2012-07-06 12:13:33.097'
           ,34037
           ,'2012-07-06 12:13:33.097'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (906
           ,1708
           ,8
           ,34037
           ,'2012-07-06 12:30:04.733'
           ,34037
           ,'2012-07-06 12:30:04.733'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (974
           ,1698
           ,8
           ,34037
           ,'2012-07-06 13:41:51.333'
           ,34037
           ,'2012-07-06 13:41:51.333'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (981
           ,1688
           ,8
           ,34037
           ,'2012-07-06 13:53:53.530'
           ,34037
           ,'2012-07-06 13:53:53.530'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (907
           ,1685
           ,8
           ,34037
           ,'2012-07-06 12:31:14.730'
           ,34037
           ,'2012-07-06 12:31:14.730'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (908
           ,1680
           ,8
           ,34037
           ,'2012-07-06 12:32:22.640'
           ,34037
           ,'2012-07-06 12:32:22.640'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (927
           ,1665
           ,8
           ,34037
           ,'2012-07-06 12:58:26.740'
           ,34037
           ,'2012-07-06 12:58:26.740'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (947
           ,1659
           ,8
           ,34037
           ,'2012-07-06 13:16:04.150'
           ,34037
           ,'2012-07-06 13:16:04.150'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (946
           ,1659
           ,8
           ,34037
           ,'2012-07-06 13:15:33.903'
           ,34037
           ,'2012-07-06 13:15:33.903'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (895
           ,1656
           ,8
           ,34037
           ,'2012-07-06 12:09:06.663'
           ,34037
           ,'2012-07-06 12:09:06.663'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (894
           ,1656
           ,8
           ,34037
           ,'2012-07-06 12:06:23.727'
           ,34037
           ,'2012-07-06 12:06:23.727'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (897
           ,1634
           ,8
           ,34037
           ,'2012-07-06 12:12:00.730'
           ,34037
           ,'2012-07-06 12:12:00.730'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (896
           ,1634
           ,8
           ,34037
           ,'2012-07-06 12:10:54.990'
           ,34037
           ,'2012-07-06 12:10:54.990'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1157
           ,1623
           ,8
           ,34346
           ,'2012-07-16 13:18:28.823'
           ,34346
           ,'2012-07-16 13:18:28.823'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1136
           ,1596
           ,8
           ,34037
           ,'2012-07-13 13:33:09.430'
           ,34037
           ,'2012-07-13 13:33:09.430'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (979
           ,1596
           ,8
           ,34037
           ,'2012-07-06 13:52:09.570'
           ,34037
           ,'2012-07-06 13:52:09.570'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (960
           ,1594
           ,8
           ,34037
           ,'2012-07-06 13:30:28.570'
           ,34037
           ,'2012-07-06 13:30:28.570'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1135
           ,1592
           ,8
           ,34037
           ,'2012-07-13 13:27:35.260'
           ,34037
           ,'2012-07-13 13:27:35.260'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1088
           ,1582
           ,8
           ,34037
           ,'2012-07-13 08:42:19.053'
           ,34037
           ,'2012-07-13 08:42:19.053'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (933
           ,1576
           ,8
           ,34037
           ,'2012-07-06 13:02:54.060'
           ,34037
           ,'2012-07-06 13:02:54.060'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1109
           ,1574
           ,8
           ,34037
           ,'2012-07-13 11:49:04.027'
           ,34037
           ,'2012-07-13 11:49:04.027'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (924
           ,1565
           ,8
           ,34037
           ,'2012-07-06 12:55:17.557'
           ,34037
           ,'2012-07-06 12:55:17.557'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (958
           ,1544
           ,8
           ,34037
           ,'2012-07-06 13:28:34.800'
           ,34037
           ,'2012-07-06 13:28:34.800'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (953
           ,1500
           ,8
           ,34037
           ,'2012-07-06 13:22:17.473'
           ,34037
           ,'2012-07-06 13:22:17.473'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (952
           ,1495
           ,8
           ,34037
           ,'2012-07-06 13:20:51.057'
           ,34037
           ,'2012-07-06 13:20:51.057'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (930
           ,1494
           ,8
           ,34037
           ,'2012-07-06 13:00:13.507'
           ,34037
           ,'2012-07-06 13:00:13.507'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (956
           ,1480
           ,8
           ,34037
           ,'2012-07-06 13:27:15.757'
           ,34037
           ,'2012-07-06 13:27:15.757'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (950
           ,1478
           ,8
           ,34037
           ,'2012-07-06 13:19:09.070'
           ,34037
           ,'2012-07-06 13:19:09.070'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (926
           ,1477
           ,8
           ,34037
           ,'2012-07-06 12:57:42.063'
           ,34037
           ,'2012-07-06 12:57:42.063'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1108
           ,1467
           ,8
           ,34037
           ,'2012-07-13 11:47:21.667'
           ,34037
           ,'2012-07-13 11:47:21.667'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (971
           ,1467
           ,8
           ,34037
           ,'2012-07-06 13:39:11.467'
           ,34037
           ,'2012-07-06 13:39:11.467'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (985
           ,1460
           ,8
           ,34037
           ,'2012-07-06 13:57:45.847'
           ,34037
           ,'2012-07-06 13:57:45.847'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (921
           ,1449
           ,8
           ,34037
           ,'2012-07-06 12:49:33.270'
           ,34037
           ,'2012-07-06 12:49:33.270'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (970
           ,1427
           ,8
           ,34037
           ,'2012-07-06 13:38:21.700'
           ,34037
           ,'2012-07-06 13:38:21.700'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (969
           ,1427
           ,8
           ,34037
           ,'2012-07-06 13:37:52.517'
           ,34037
           ,'2012-07-06 13:37:52.517'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1100
           ,1368
           ,8
           ,34037
           ,'2012-07-13 09:02:43.287'
           ,34037
           ,'2012-07-13 09:02:43.287'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (954
           ,1360
           ,8
           ,34037
           ,'2012-07-06 13:24:32.320'
           ,34037
           ,'2012-07-06 13:24:32.320'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1083
           ,1351
           ,8
           ,34037
           ,'2012-07-13 08:18:06.183'
           ,34037
           ,'2012-07-13 08:18:06.183'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1082
           ,1351
           ,8
           ,34037
           ,'2012-07-13 08:17:25.823'
           ,34037
           ,'2012-07-13 08:17:25.823'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1081
           ,1351
           ,8
           ,34037
           ,'2012-07-13 08:16:08.570'
           ,34037
           ,'2012-07-13 08:16:08.570'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1080
           ,1350
           ,8
           ,34037
           ,'2012-07-13 08:15:10.377'
           ,34037
           ,'2012-07-13 08:15:10.377'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1079
           ,1350
           ,8
           ,34037
           ,'2012-07-13 08:14:14.480'
           ,34037
           ,'2012-07-13 08:14:14.480'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1107
           ,1319
           ,8
           ,34037
           ,'2012-07-13 11:42:22.943'
           ,34037
           ,'2012-07-13 11:42:22.943'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1106
           ,1319
           ,8
           ,34037
           ,'2012-07-13 11:41:08.337'
           ,34037
           ,'2012-07-13 11:41:08.337'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1085
           ,1308
           ,8
           ,34037
           ,'2012-07-13 08:23:07.360'
           ,34037
           ,'2012-07-13 08:23:07.360'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (941
           ,1270
           ,8
           ,34037
           ,'2012-07-06 13:09:04.747'
           ,34037
           ,'2012-07-06 13:09:04.747'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (911
           ,1264
           ,8
           ,34037
           ,'2012-07-06 12:34:02.753'
           ,34037
           ,'2012-07-06 12:34:02.753'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1077
           ,1249
           ,8
           ,34037
           ,'2012-07-13 08:11:02.590'
           ,34037
           ,'2012-07-13 08:11:02.590'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (961
           ,1249
           ,8
           ,34037
           ,'2012-07-06 13:31:20.537'
           ,34037
           ,'2012-07-06 13:31:20.537'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1078
           ,1248
           ,8
           ,34037
           ,'2012-07-13 08:12:26.350'
           ,34037
           ,'2012-07-13 08:12:26.350'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (986
           ,1220
           ,8
           ,34037
           ,'2012-07-06 13:58:22.480'
           ,34037
           ,'2012-07-06 13:58:22.480'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1084
           ,1219
           ,8
           ,34037
           ,'2012-07-13 08:22:17.883'
           ,34037
           ,'2012-07-13 08:22:17.883'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (987
           ,1205
           ,8
           ,34037
           ,'2012-07-06 13:58:57.750'
           ,34037
           ,'2012-07-06 13:58:57.750'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1086
           ,1203
           ,8
           ,34037
           ,'2012-07-13 08:24:44.943'
           ,34037
           ,'2012-07-13 08:24:44.943'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (940
           ,1203
           ,8
           ,34037
           ,'2012-07-06 13:08:13.960'
           ,34037
           ,'2012-07-06 13:08:13.960'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (905
           ,1201
           ,8
           ,34037
           ,'2012-07-06 12:28:21.997'
           ,34037
           ,'2012-07-06 12:28:21.997'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (929
           ,1184
           ,8
           ,34037
           ,'2012-07-06 12:59:17.037'
           ,34037
           ,'2012-07-06 12:59:17.037'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (919
           ,1118
           ,8
           ,34037
           ,'2012-07-06 12:47:41.460'
           ,34037
           ,'2012-07-06 12:47:41.460'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (909
           ,1117
           ,8
           ,34037
           ,'2012-07-06 12:33:22.060'
           ,34037
           ,'2012-07-06 12:33:22.060'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (949
           ,1114
           ,8
           ,34037
           ,'2012-07-06 13:18:17.437'
           ,34037
           ,'2012-07-06 13:18:17.437'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (948
           ,1114
           ,8
           ,34037
           ,'2012-07-06 13:17:47.793'
           ,34037
           ,'2012-07-06 13:17:47.793'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (392
           ,1072
           ,8
           ,34037
           ,'2012-06-01 13:49:23.770'
           ,34037
           ,'2012-06-01 13:49:23.770'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (923
           ,1053
           ,8
           ,34037
           ,'2012-07-06 12:52:54.423'
           ,34037
           ,'2012-07-06 12:52:54.423'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1125
           ,1051
           ,8
           ,34037
           ,'2012-07-13 12:32:24.787'
           ,34037
           ,'2012-07-13 12:32:24.787'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (945
           ,1051
           ,8
           ,34037
           ,'2012-07-06 13:14:16.347'
           ,34037
           ,'2012-07-06 13:14:16.347'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (943
           ,1051
           ,8
           ,34037
           ,'2012-07-06 13:13:23.070'
           ,34037
           ,'2012-07-06 13:13:23.070'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (964
           ,1011
           ,8
           ,34037
           ,'2012-07-06 13:34:28.697'
           ,34037
           ,'2012-07-06 13:34:28.697'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1126
           ,982
           ,8
           ,34037
           ,'2012-07-13 12:35:07.817'
           ,34037
           ,'2012-07-13 12:35:07.817'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1127
           ,979
           ,8
           ,34037
           ,'2012-07-13 12:36:06.753'
           ,34037
           ,'2012-07-13 12:36:06.753'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (939
           ,944
           ,8
           ,34037
           ,'2012-07-06 13:07:38.000'
           ,34037
           ,'2012-07-06 13:07:38.000'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (1118
           ,901
           ,8
           ,34037
           ,'2012-07-13 12:03:43.863'
           ,34037
           ,'2012-07-13 12:03:43.863'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (973
           ,881
           ,8
           ,34037
           ,'2012-07-06 13:40:56.993'
           ,34037
           ,'2012-07-06 13:40:56.993'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (959
           ,818
           ,8
           ,34037
           ,'2012-07-06 13:29:41.577'
           ,34037
           ,'2012-07-06 13:29:41.577'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (934
           ,759
           ,8
           ,34037
           ,'2012-07-06 13:04:02.727'
           ,34037
           ,'2012-07-06 13:04:02.727'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (925
           ,710
           ,8
           ,34037
           ,'2012-07-06 12:56:51.020'
           ,34037
           ,'2012-07-06 12:56:51.020'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (384
           ,660
           ,8
           ,34037
           ,'2012-06-01 12:59:54.370'
           ,34037
           ,'2012-06-01 12:59:54.370'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (932
           ,602
           ,8
           ,34037
           ,'2012-07-06 13:02:02.620'
           ,34037
           ,'2012-07-06 13:02:02.620'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (982
           ,571
           ,8
           ,34037
           ,'2012-07-06 13:54:33.970'
           ,34037
           ,'2012-07-06 13:54:33.970'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (968
           ,454
           ,8
           ,34037
           ,'2012-07-06 13:36:57.130'
           ,34037
           ,'2012-07-06 13:36:57.130'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (931
           ,416
           ,8
           ,34037
           ,'2012-07-06 13:01:00.223'
           ,34037
           ,'2012-07-06 13:01:00.223'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (966
           ,410
           ,8
           ,34037
           ,'2012-07-06 13:35:17.537'
           ,34037
           ,'2012-07-06 13:35:17.537'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (983
           ,369
           ,8
           ,34037
           ,'2012-07-06 13:55:41.840'
           ,34037
           ,'2012-07-06 13:55:41.840'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (984
           ,196
           ,8
           ,34037
           ,'2012-07-06 13:57:02.513'
           ,34037
           ,'2012-07-06 13:57:02.513'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (962
           ,191
           ,8
           ,34037
           ,'2012-07-06 13:32:19.860'
           ,34037
           ,'2012-07-06 13:32:19.860'
           );
INSERT INTO #dms_to_rec
           ([DMSDocumentID]
           ,[RecordID]
           ,[RecordTypeID]
           ,[ModifiedUserID]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[CreatedDate])
     VALUES
           (942
           ,98
           ,8
           ,34037
           ,'2012-07-06 13:12:34.577'
           ,34037
           ,'2012-07-06 13:12:34.577'
           );
  
IF @is_debug = 1 
    BEGIN
        SELECT  COUNT(*) AS '#dms_to_rec'
        FROM    #dms_to_rec;

        SELECT  [DMSDocumentID] ,
                [RecordID] ,
                [RecordTypeID] ,
                [ModifiedUserID] ,
                [ModifiedDate] ,
                [CreatedUserID] ,
                [CreatedDate]
        FROM    #dms_to_rec
        EXCEPT
        SELECT  [DMSDocumentID] ,
                [RecordID] ,
                [RecordTypeID] ,
                [ModifiedUserID] ,
                [ModifiedDate] ,
                [CreatedUserID] ,
                [CreatedDate]
        FROM    dbo.DMSDocumentToRecordAssociation;

        SELECT  @@ROWCOUNT AS 'Diff';
    END
        
IF @is_debug = 0 
    BEGIN
        BEGIN TRANSACTION;
        INSERT  INTO dbo.DMSDocumentToRecordAssociation
                ( DMSDocumentID ,
                  RecordID ,
                  RecordTypeID ,
                  ModifiedUserID ,
                  ModifiedDate ,
                  CreatedUserID ,
                  CreatedDate
                )
                SELECT  [DMSDocumentID] ,
                        [RecordID] ,
                        [RecordTypeID] ,
                        [ModifiedUserID] ,
                        [ModifiedDate] ,
                        [CreatedUserID] ,
                        [CreatedDate]
                FROM    #dms_to_rec
                EXCEPT
                SELECT  [DMSDocumentID] ,
                        [RecordID] ,
                        [RecordTypeID] ,
                        [ModifiedUserID] ,
                        [ModifiedDate] ,
                        [CreatedUserID] ,
                        [CreatedDate]
                FROM    dbo.DMSDocumentToRecordAssociation;
                
        SELECT  @@ROWCOUNT AS 'Inserted';
        COMMIT;
    END

IF OBJECT_ID('tempdb..#dms_to_rec') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#dms_to_rec;
    END
GO
