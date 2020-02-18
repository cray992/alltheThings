-- case 14527 

--select top 10 * from PatientCase

/*
alter table PatientCase drop [FK_PatientCase_EPSDTCode]
alter table PatientCase drop column EPSDTCodeID 
drop table dbo.EPSDTCode
drop table dbo.CodeType

-- ATTEMPT of having general storage for codes

CREATE TABLE dbo.CodeType (
	CodeTypeID int Identity(1, 1) not null PRIMARY KEY,
	CreateDate DateTime not null default GetDate(),
	CreatedUserID int not null default 0,
	ModifiedDate DateTime not null default GetDate(),
	ModifiedUserID int not null default 0,
	Description varchar(256) not null
)
GO

insert into dbo.CodeType (Description) values ('EPSDT Code')

CREATE TABLE dbo.Code (
	CodeID int Identity(1, 1) not null PRIMARY KEY,
	CreateDate DateTime not null default GetDate(),
	CreatedUserID int not null default 0,
	ModifiedDate DateTime not null default GetDate(),
	ModifiedUserID int not null default 0,
	CodeTypeID int,
	Code varchar(32) not null,
	Description varchar(256) not null,
	DisplayOrder int not null
)
GO

ALTER TABLE [dbo].[Code]  WITH CHECK ADD  CONSTRAINT [FK_Code_CodeType] FOREIGN KEY([CodeTypeID])
REFERENCES [dbo].[CodeType] ([CodeTypeID])
GO

INSERT INTO dbo.Code (CodeTypeID, Code, Description, DisplayOrder) 
VALUES (1, 'NU', 'Not used', 1)

INSERT INTO dbo.Code (CodeTypeID, Code, Description, DisplayOrder) 
VALUES (1, 'AV', 'Available - not used', 2)

INSERT INTO dbo.Code (CodeTypeID, Code, Description, DisplayOrder) 
VALUES (1, 'S2', 'Under treatment', 3)

INSERT INTO dbo.Code (CodeTypeID, Code, Description, DisplayOrder) 
VALUES (1, 'ST', 'New Services Requested', 4)

ALTER TABLE PatientCase ADD EPSDTCodeID int null 
GO

ALTER TABLE [dbo].[PatientCase]  WITH CHECK ADD  CONSTRAINT [FK_PatientCase_Code] FOREIGN KEY([EPSDTCodeID])
REFERENCES [dbo].[Code] ([CodeID])
GO

*/

CREATE TABLE dbo.EPSDTCode (
	EPSDTCodeID int Identity(1, 1) not null PRIMARY KEY,
	CreateDate DateTime not null default GetDate(),
	CreatedUserID int not null default 0,
	ModifiedDate DateTime not null default GetDate(),
	ModifiedUserID int not null default 0,
	Code varchar(32) not null,
	Description varchar(256) not null,
	DisplayOrder int not null)
GO

INSERT INTO dbo.EPSDTCode (Code, Description, DisplayOrder) 
VALUES ('NU', 'Not used', 1)

INSERT INTO dbo.EPSDTCode (Code, Description, DisplayOrder) 
VALUES ('AV', 'Available - not used', 2)

INSERT INTO dbo.EPSDTCode (Code, Description, DisplayOrder) 
VALUES ('S2', 'Under treatment', 3)

INSERT INTO dbo.EPSDTCode (Code, Description, DisplayOrder) 
VALUES ('ST', 'New Services Requested', 4)

ALTER TABLE PatientCase ADD EPSDTCodeID int DEFAULT 1 
GO

ALTER TABLE [dbo].[PatientCase]  WITH CHECK ADD CONSTRAINT [FK_PatientCase_EPSDTCode] FOREIGN KEY([EPSDTCodeID])
REFERENCES [dbo].EPSDTCode ([EPSDTCodeID])
GO

UPDATE PATIENTCASE SET EPSDTCodeID=2 where EPSDT=1