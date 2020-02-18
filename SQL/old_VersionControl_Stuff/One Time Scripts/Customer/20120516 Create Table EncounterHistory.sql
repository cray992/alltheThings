IF EXISTS(SELECT * FROM Sys.objects AS o WHERE o.name='EncounterHistory' AND type='U')
DROP TABLE EncounterHistory
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[EncounterHistory](
	[EncounterID] [int] NOT NULL,
	[PracticeID] [int] NOT NULL,
	[PatientID] [int] NOT NULL,
	[DoctorID] [int] NULL,
	[AppointmentID] [int] NULL,
	[LocationID] [int] NULL,
	[PatientEmployerID] [int] NULL,
	[DateOfService] [datetime] NULL,
	[DateCreated] [datetime] NULL,
	[Notes] [text] NULL,
	[EncounterStatusID] [int] NOT NULL,
	[AdminNotes] [text] NULL,
	[AmountPaid] [money] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedUserID] [int] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ModifiedUserID] [int] NOT NULL,
	[RecordTimeStamp] [timestamp] NOT NULL,
	[MedicareAssignmentCode] [char](1) NULL,
	[ReleaseOfInformationCode] [char](1) NULL,
	[ReleaseSignatureSourceCode] [char](1) NULL,
	[PlaceOfServiceCode] [char](2) NOT NULL,
	[ConditionNotes] [text] NULL,
	[PatientCaseID] [int] NULL,
	[InsurancePolicyAuthorizationID] [int] NULL,
	[PostingDate] [datetime] NOT NULL,
	[DateOfServiceTo] [datetime] NULL,
	[SupervisingProviderID] [int] NULL,
	[ReferringPhysicianID] [int] NULL,
	[PaymentMethod] [char](1) NULL,
	[Reference] [varchar](40) NULL,
	[AddOns] [bigint] NOT NULL,
	[HospitalizationStartDT] [datetime] NULL,
	[HospitalizationEndDT] [datetime] NULL,
	[Box19] [varchar](40) NULL,
	[DoNotSendElectronic] [bit] NOT NULL,
	[SubmittedDate] [datetime] NULL,
	[PaymentTypeID] [int] NULL,
	[PaymentDescription] [varchar](250) NULL,
	[EDIClaimNoteReferenceCode] [char](3) NULL,
	[EDIClaimNote] [varchar](1600) NULL,
	[VendorID] [varchar](50) NULL,
	[VendorImportID] [int] NULL,
	[AppointmentStartDate] [datetime] NULL,
	[BatchID] [varchar](50) NULL,
	[SchedulingProviderID] [int] NULL,
	[DoNotSendElectronicSecondary] [bit] NOT NULL,
	[PaymentCategoryID] [int] NULL,
	[overrideClosingDate] [bit] NOT NULL,
	[Box10d] [varchar](40) NULL,
	[ClaimTypeID] [int] NOT NULL,
	[OperatingProviderID] [int] NULL,
	[OtherProviderID] [int] NULL,
	[PrincipalDiagnosisCodeDictionaryID] [int] NULL,
	[AdmittingDiagnosisCodeDictionaryID] [int] NULL,
	[PrincipalProcedureCodeDictionaryID] [int] NULL,
	[DRGCodeID] [int] NULL,
	[ProcedureDate] [datetime] NULL,
	[AdmissionTypeID] [int] NULL,
	[AdmissionDate] [datetime] NULL,
	[PointOfOriginCodeID] [int] NULL,
	[AdmissionHour] [varchar](2) NULL,
	[DischargeHour] [varchar](2) NULL,
	[DischargeStatusCodeID] [int] NULL,
	[Remarks] [varchar](255) NULL,
	[SubmitReasonID] [int] NULL,
	[DocumentControlNumber] [varchar](26) NULL,
	[PTAProviderID] [int] NULL,
	[DateDeleted] DateTime DEFAULT (GETDATE())
	)


