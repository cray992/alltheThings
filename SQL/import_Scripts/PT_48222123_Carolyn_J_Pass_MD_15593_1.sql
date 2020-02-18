USE superbill_15593_dev
--USE superbill_15593_prod
GO


IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
              WHERE TABLE_NAME = '_import_1_1_PATIENT' AND COLUMN_NAME = 'guarfirstname')
BEGIN
  ALTER TABLE [dbo].[_import_1_1_PATIENT]
  ADD guarfirstname varchar(128) NULL
END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = '_import_1_1_PATIENT' AND COLUMN_NAME = 'guarmiddlename')
BEGIN

  ALTER TABLE [dbo].[_import_1_1_PATIENT]
  ADD [guarmiddlename] varchar(128) NULL
END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = '_import_1_1_PATIENT' AND COLUMN_NAME = 'guarlastname')
BEGIN

  ALTER TABLE [dbo].[_import_1_1_PATIENT]
  ADD [guarlastname] varchar(128) NULL
END

UPDATE [dbo].[_import_1_1_PATIENT]
SET
guarfirstname=REPLACE(SUBSTRING(gname, 1, CHARINDEX(' ', gname)),' ', '') ,
guarmiddlename = CASE WHEN LTRIM(RTRIM(gname)) LIKE '%jr%' AND LTRIM(RTRIM(gname)) LIKE '% % % %'
                      THEN SUBSTRING(
				           gname, 
				           CHARINDEX(' ', gname) + 1, 
						   LEN(gname) - (CHARINDEX(' ', gname)) - CHARINDEX(' ', REVERSE(gname), CHARINDEX(' ', REVERSE(gname)) + 1)
						   )
                      WHEN LTRIM(RTRIM(gname)) LIKE '%jr%' AND LTRIM(RTRIM(gname)) NOT LIKE '% % % %' AND LTRIM(RTRIM(gname)) LIKE '% % %'
			          THEN NULL
    			      WHEN LTRIM(RTRIM(gname)) LIKE '%sr%' AND LTRIM(RTRIM(gname)) LIKE '% % % %'
                      THEN SUBSTRING(
				           gname, 
				           CHARINDEX(' ', gname) + 1, 
						   LEN(gname) - (CHARINDEX(' ', gname)) - CHARINDEX(' ', REVERSE(gname), CHARINDEX(' ', REVERSE(gname)) + 1)
						   )
                      WHEN LTRIM(RTRIM(gname)) LIKE '%sr%' AND LTRIM(RTRIM(gname)) NOT LIKE '% % % %' AND LTRIM(RTRIM(gname)) LIKE '% % %'
			          THEN NULL
				      WHEN LTRIM(RTRIM(gname)) LIKE '%III%' AND LTRIM(RTRIM(gname)) LIKE '% % % %'
                      THEN SUBSTRING(
				           gname, 
				           CHARINDEX(' ', gname) + 1, 
						   LEN(gname) - (CHARINDEX(' ', gname)) - CHARINDEX(' ', REVERSE(gname), CHARINDEX(' ', REVERSE(gname)) + 1)
						   )
                      WHEN LTRIM(RTRIM(gname)) LIKE '%III%' AND LTRIM(RTRIM(gname)) NOT LIKE '% % % %' AND LTRIM(RTRIM(gname)) LIKE '% % %'
			          THEN NULL
                      WHEN ltrim(rtrim(gname)) LIKE '% % %' AND 
                           ltrim(rtrim(gname)) NOT LIKE '%jr%' AND 
						   ltrim(rtrim(gname)) NOT LIKE '%sr%' AND
						   ltrim(rtrim(gname)) NOT LIKE '%III%'                     
                      THEN SUBSTRING(gname, charindex(' ', gname)+1, LEN(gname) - charindex(' ', gname)-charindex(' ', reverse(gname))) 
			          END ,
guarlastname= CASE WHEN LTRIM(RTRIM(gname)) LIKE '%jr%' AND LTRIM(RTRIM(gname)) LIKE '% % % %'
                   THEN SUBSTRING(
				        gname, 
				        CHARINDEX(' ', gname, CHARINDEX(' ', gname) + 1) + 1, 
						LEN(gname) - CHARINDEX(' ', gname, CHARINDEX(' ', gname) + 1)
						)
                   WHEN LTRIM(RTRIM(gname)) LIKE '%jr%' AND LTRIM(RTRIM(gname)) NOT LIKE '% % % %' AND LTRIM(RTRIM(gname)) LIKE '% % %'
			       THEN SUBSTRING(
				        gname, 
				        CHARINDEX(' ', gname) + 1 , 
						LEN(gname) - CHARINDEX(' ', gname) + 1
						)
				   WHEN LTRIM(RTRIM(gname)) LIKE '%sr%' AND LTRIM(RTRIM(gname)) LIKE '% % % %'
                   THEN SUBSTRING(
				        gname, 
				        CHARINDEX(' ', gname, CHARINDEX(' ', gname) + 1) + 1, 
						LEN(gname) - CHARINDEX(' ', gname, CHARINDEX(' ', gname) + 1)
						)
                   WHEN LTRIM(RTRIM(gname)) LIKE '%sr%' AND LTRIM(RTRIM(gname)) NOT LIKE '% % % %' AND LTRIM(RTRIM(gname)) LIKE '% % %'
			       THEN SUBSTRING(
				        gname, 
				        CHARINDEX(' ', gname) + 1 , 
						LEN(gname) - CHARINDEX(' ', gname) + 1
						)
				   WHEN LTRIM(RTRIM(gname)) LIKE '%III%' AND LTRIM(RTRIM(gname)) LIKE '% % % %'
                   THEN SUBSTRING(
				        gname, 
				        CHARINDEX(' ', gname, CHARINDEX(' ', gname) + 1) + 1, 
						LEN(gname) - CHARINDEX(' ', gname, CHARINDEX(' ', gname) + 1)
						)
                   WHEN LTRIM(RTRIM(gname)) LIKE '%III%' AND LTRIM(RTRIM(gname)) NOT LIKE '% % % %' AND LTRIM(RTRIM(gname)) LIKE '% % %'
			       THEN SUBSTRING(
				        gname, 
				        CHARINDEX(' ', gname) + 1 , 
						LEN(gname) - CHARINDEX(' ', gname) + 1
						)
ELSE REPLACE(RIGHT(gname, charindex(' ', reverse(gname))), ' ', '')
END