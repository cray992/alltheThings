/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.AmbulanceTransportInformation ADD
	StartTime varchar(30) NULL,
	StopTime varchar(30) NULL,
	IsEmergency bit NULL
GO
ALTER TABLE dbo.AmbulanceTransportInformation ADD CONSTRAINT
	DF_AmbulanceTransportInformation_IsEmergency DEFAULT 0 FOR IsEmergency
GO
COMMIT