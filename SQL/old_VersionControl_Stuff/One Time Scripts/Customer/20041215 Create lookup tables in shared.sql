/* ------------------------------------------------------------

   DESCRIPTION:  Structure Definition Script for Object(s) 

	TABLEs: [dbo].[Country], [dbo].[Gender], [dbo].[State]


     Database:  k0.kareo.ent.superbill_0001_dev

   AUTHOR:	Rolland Zeleznik

   DATE:	12/15/2004 15:44:54

   ------------------------------------------------------------ */

-- =======================================================
-- SCRIPT HEADER
-- =======================================================

SET NOEXEC OFF
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- BEGINNING TRANSACTION
BEGIN TRANSACTION
GO

-- =======================================================
-- SCRIPT NON-ORDERED OBJECTS
-- =======================================================

SET ANSI_PADDING ON
SET ANSI_NULLS ON
GO
 -- TRANSACTION HANDLING
 IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
 GO

CREATE TABLE [dbo].[Country] (
    [Country] varchar(32) CONSTRAINT [PK_Country] PRIMARY KEY,
    [ShortName] varchar(8) NOT NULL,
    [CreatedDate] datetime NOT NULL,
    [CreatedUserID] int NOT NULL,
    [ModifiedDate] datetime NOT NULL,
    [ModifiedUserID] int NOT NULL,
    [RecordTimeStamp] timestamp NOT NULL
)
GO
 -- TRANSACTION HANDLING
 IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
 GO


SET ANSI_PADDING ON
SET ANSI_NULLS ON
GO
 -- TRANSACTION HANDLING
 IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
 GO

CREATE TABLE [dbo].[Gender] (
    [Gender] varchar(1) CONSTRAINT [PK_Gender] PRIMARY KEY,
    [LongName] varchar(16) NOT NULL,
    [CreatedDate] datetime NOT NULL,
    [CreatedUserID] int NOT NULL,
    [ModifiedDate] datetime NOT NULL,
    [ModifiedUserID] int NOT NULL,
    [RecordTimeStamp] timestamp NOT NULL
)
GO
 -- TRANSACTION HANDLING
 IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
 GO


SET ANSI_PADDING ON
SET ANSI_NULLS ON
GO
 -- TRANSACTION HANDLING
 IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
 GO

CREATE TABLE [dbo].[State] (
    [State] varchar(2) CONSTRAINT [PK_State] PRIMARY KEY,
    [LongName] varchar(32) NOT NULL,
    [CreatedDate] datetime NOT NULL,
    [CreatedUserID] int NOT NULL,
    [ModifiedDate] datetime NOT NULL,
    [ModifiedUserID] int NOT NULL,
    [RecordTimeStamp] timestamp NOT NULL
)
GO
 -- TRANSACTION HANDLING
 IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
 GO


-- =======================================================
-- SCRIPT ORDERED OBJECTS AND TABLE FOREIGN KEYS
-- =======================================================

-- -------------------------------------------------------
-- Script for Table: [dbo].[Country]
-- -------------------------------------------------------
Print 'Script for Table: [dbo].[Country] '
GO

ALTER TABLE [dbo].[Country] ADD
   CONSTRAINT [DF_Country_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate],
   CONSTRAINT [DF_Country_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate]
GO
 -- TRANSACTION HANDLING
 IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
 GO


-- -------------------------------------------------------
-- Script for Table: [dbo].[Gender]
-- -------------------------------------------------------
Print 'Script for Table: [dbo].[Gender] '
GO

ALTER TABLE [dbo].[Gender] ADD
   CONSTRAINT [DF_Gender_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate],
   CONSTRAINT [DF_Gender_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate]
GO
 -- TRANSACTION HANDLING
 IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
 GO


-- -------------------------------------------------------
-- Script for Table: [dbo].[State]
-- -------------------------------------------------------
Print 'Script for Table: [dbo].[State] '
GO

ALTER TABLE [dbo].[State] ADD
   CONSTRAINT [DF_State_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate],
   CONSTRAINT [DF_State_CreatedUserID] DEFAULT (0) FOR [CreatedUserID],
   CONSTRAINT [DF_State_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate],
   CONSTRAINT [DF_State_ModifiedUserID] DEFAULT (0) FOR [ModifiedUserID]
GO
 -- TRANSACTION HANDLING
 IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
 GO


-- =======================================================
-- SCRIPT DATA
-- =======================================================
/* ------------------------------------------------------------
   FILE:         C:\Documents and Settings\rolland\Desktop\kareo_data\Country_Gender_State_data.sql
   
   DESCRIPTION:  Insert scripts for the following table(s)/view(s):

     [dbo].[Country], [dbo].[Gender], [dbo].[State]
   
   AUTHOR:       Rolland Zeleznik                                       
   
   CREATED:      12/15/2004 15:46:55                                    
   ------------------------------------------------------------ */
   
SET NOCOUNT ON

PRINT 'Deleting from table: [dbo].[State]'
DELETE FROM [dbo].[State]

PRINT 'Deleting from table: [dbo].[Gender]'
DELETE FROM [dbo].[Gender]

PRINT 'Deleting from table: [dbo].[Country]'
DELETE FROM [dbo].[Country]

/* Insert scripts for table: [dbo].[Country] */
PRINT 'Inserting rows into table: [dbo].[Country]'

/* Warning - TIMESTAMP datatype not supported for Insert scripts */
INSERT INTO [dbo].[Country] ([Country], [ShortName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('', '', '20020529 15:46:16.647', 0, '20020529 15:46:16.647', 0)
INSERT INTO [dbo].[Country] ([Country], [ShortName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('United States of America', 'U.S.A.', '20020529 15:46:16.647', 0, '20020529 15:46:16.647', 0)

/* Insert scripts for table: [dbo].[Gender] */
PRINT 'Inserting rows into table: [dbo].[Gender]'

/* Warning - TIMESTAMP datatype not supported for Insert scripts */
INSERT INTO [dbo].[Gender] ([Gender], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('', '', '20020529 15:46:17.303', 0, '20020529 15:46:17.303', 0)
INSERT INTO [dbo].[Gender] ([Gender], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('F', 'Female', '20020529 15:46:17.303', 0, '20020529 15:46:17.303', 0)
INSERT INTO [dbo].[Gender] ([Gender], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('M', 'Male', '20020529 15:46:17.303', 0, '20020529 15:46:17.303', 0)
INSERT INTO [dbo].[Gender] ([Gender], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('U', 'Unknown', '20020529 15:46:17.303', 0, '20020529 15:46:17.303', 0)

/* Insert scripts for table: [dbo].[State] */
PRINT 'Inserting rows into table: [dbo].[State]'

/* Warning - TIMESTAMP datatype not supported for Insert scripts */
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('', '<All States>', '20020529 15:46:19.320', 0, '20020529 15:46:19.320', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('AK', 'Alaska', '20030312 09:54:45.403', 0, '20030312 09:54:45.403', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('AL', 'Alabama', '20030312 09:54:45.403', 0, '20030312 09:54:45.403', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('AR', 'Arkansas', '20030312 09:54:45.403', 0, '20030312 09:54:45.403', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('AZ', 'Arizona', '20030312 09:54:45.403', 0, '20030312 09:54:45.403', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('CA', 'California', '20020529 15:46:19.320', 0, '20020529 15:46:19.320', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('CO', 'Colorado', '20030312 09:54:45.403', 0, '20030312 09:54:45.403', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('CT', 'Connecticut', '20030312 09:54:45.403', 0, '20030312 09:54:45.403', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('DC', 'District of Columbia', '20030312 09:54:45.403', 0, '20030312 09:54:45.403', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('DE', 'Delaware', '20030312 09:54:45.403', 0, '20030312 09:54:45.403', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('FL', 'Florida', '20030310 10:22:41.590', 0, '20030310 10:22:41.590', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('GA', 'Georgia', '20030312 09:54:45.403', 0, '20030312 09:54:45.403', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('HI', 'Hawaii', '20030312 09:54:45.420', 0, '20030312 09:54:45.420', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('IA', 'Iowa', '20030312 09:54:45.420', 0, '20030312 09:54:45.420', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('ID', 'Idaho', '20030312 09:54:45.420', 0, '20030312 09:54:45.420', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('IL', 'Illinois', '20030312 09:54:45.420', 0, '20030312 09:54:45.420', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('IN', 'Indiana', '20030312 09:54:45.420', 0, '20030312 09:54:45.420', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('KS', 'Kansas', '20030312 09:54:45.420', 0, '20030312 09:54:45.420', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('KY', 'Kentucky', '20030312 09:54:45.420', 0, '20030312 09:54:45.420', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('LA', 'Louisiana', '20030312 09:54:45.420', 0, '20030312 09:54:45.420', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('MA', 'Massachusetts', '20030312 09:54:45.420', 0, '20030312 09:54:45.420', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('MD', 'Maryland', '20030312 09:54:45.420', 0, '20030312 09:54:45.420', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('ME', 'Maine', '20030312 09:54:45.420', 0, '20030312 09:54:45.420', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('MI', 'Michigan', '20030312 09:54:45.420', 0, '20030312 09:54:45.420', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('MN', 'Minnesota', '20030312 09:54:45.420', 0, '20030312 09:54:45.420', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('MO', 'Missouri', '20030312 09:54:45.420', 0, '20030312 09:54:45.420', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('MS', 'Mississippi', '20030312 09:54:45.420', 0, '20030312 09:54:45.420', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('MT', 'Montana', '20030312 09:54:45.420', 0, '20030312 09:54:45.420', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('NC', 'North Carolina', '20030312 09:54:45.420', 0, '20030312 09:54:45.420', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('ND', 'North Dakota', '20030312 09:54:45.420', 0, '20030312 09:54:45.420', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('NE', 'Nebraska', '20030312 09:54:45.420', 0, '20030312 09:54:45.420', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('NH', 'New Hampshire', '20030312 09:54:45.420', 0, '20030312 09:54:45.420', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('NJ', 'New Jersey', '20030312 09:54:45.420', 0, '20030312 09:54:45.420', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('NM', 'New Mexico', '20030310 10:22:37.030', 0, '20030310 10:22:37.030', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('NV', 'Nevada', '20030310 10:22:46.513', 0, '20030310 10:22:46.513', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('NY', 'New York', '20030312 09:54:45.420', 0, '20030312 09:54:45.420', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('OH', 'Ohio', '20030312 09:54:45.420', 0, '20030312 09:54:45.420', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('OK', 'Oklahoma', '20030312 09:54:45.420', 0, '20030312 09:54:45.420', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('OR', 'Oregon', '20030312 09:54:45.420', 0, '20030312 09:54:45.420', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('PA', 'Pennsylvania', '20030312 09:54:45.420', 0, '20030312 09:54:45.420', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('RI', 'Rhode Island', '20030312 09:54:45.420', 0, '20030312 09:54:45.420', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('SC', 'South Carolina', '20030312 09:54:45.420', 0, '20030312 09:54:45.420', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('SD', 'South Dakota', '20030312 09:54:45.420', 0, '20030312 09:54:45.420', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('TN', 'Tennessee', '20030310 10:22:51.327', 0, '20030310 10:22:51.327', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('TX', 'Texas', '20030312 09:54:45.420', 0, '20030312 09:54:45.420', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('UT', 'Utah', '20030312 09:54:45.420', 0, '20030312 09:54:45.420', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('VA', 'Virginia', '20030312 09:54:45.437', 0, '20030312 09:54:45.437', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('VT', 'Vermont', '20030312 09:54:45.437', 0, '20030312 09:54:45.437', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('WA', 'Washington', '20030312 09:54:45.437', 0, '20030312 09:54:45.437', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('WI', 'Wisconsin', '20030312 09:54:45.437', 0, '20030312 09:54:45.437', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('WV', 'West Virginia', '20030312 09:54:45.437', 0, '20030312 09:54:45.437', 0)
INSERT INTO [dbo].[State] ([State], [LongName], [CreatedDate], [CreatedUserID], [ModifiedDate], [ModifiedUserID]) VALUES ('WY', 'Wyoming', '20030312 09:54:45.437', 0, '20030312 09:54:45.437', 0)


-- COMMITTING TRANSACTION
PRINT 'Script successfully completed'
COMMIT TRANSACTION
GO
SET NOEXEC OFF
GO


