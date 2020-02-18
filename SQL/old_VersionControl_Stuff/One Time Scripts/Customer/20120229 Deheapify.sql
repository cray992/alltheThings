-- Fix heaps

-- PaymentEncounter
IF EXISTS (SELECT * FROM sys.indexes i WHERE i.type_desc = 'HEAP' AND object_name(i.object_id)  = 'PaymentEncounter')
BEGIN
	IF  EXISTS (SELECT * FROM sys.key_constraints WHERE object_id = object_id(N'[dbo].[U_PaymentEncounter]') AND parent_object_id = object_id('[dbo].[PaymentEncounter]'))
	BEGIN
		ALTER TABLE dbo.PaymentEncounter DROP CONSTRAINT U_PaymentEncounter
	END

	CREATE UNIQUE CLUSTERED INDEX [CI_PaymentEncounter_PaymentID_EncounterID] ON dbo.PaymentEncounter
	(
		PaymentID,
		EncounterID
	)
END

-- PaymentBusinessRuleLog
-- NOTE: Consider dropping this table completely lul
IF EXISTS (SELECT * FROM sys.indexes i WHERE i.type_desc = 'HEAP' AND object_name(i.object_id) = 'PaymentBusinessRuleLog')
BEGIN
	
	--IF  EXISTS (SELECT * FROM sys.key_constraints WHERE object_id = object_id(N'[dbo].[PK_PaymentBusinessRuleLog]') AND parent_object_id = object_id('[dbo].[PaymentBusinessRuleLog]'))
	BEGIN
		ALTER TABLE dbo.PaymentBusinessRuleLog DROP CONSTRAINT PK_PaymentBusinessRuleLog
		ALTER TABLE dbo.PaymentBusinessRuleLog ADD CONSTRAINT PK_PaymentBusinessRuleLog PRIMARY KEY CLUSTERED (PaymentBusinessRuleLogID)
	END
	
END


-- DocumentReprint
IF EXISTS (SELECT * FROM sys.indexes i WHERE i.type_desc = 'HEAP' AND object_name(i.object_id) = 'DocumentReprint')
BEGIN
	
	--IF  EXISTS (SELECT * FROM sys.key_constraints WHERE object_id = object_id(N'[dbo].[PK_DocumentReprint_DocumentID]') AND parent_object_id = object_id('[dbo].[DocumentReprint]'))
	BEGIN
		ALTER TABLE dbo.DocumentReprint DROP CONSTRAINT PK_DocumentReprint_DocumentID
		ALTER TABLE dbo.DocumentReprint ADD CONSTRAINT PK_DocumentReprint_DocumentID PRIMARY KEY CLUSTERED (DocumentID)
	END
	
END

-- ContractToDoctor
IF EXISTS (SELECT * FROM sys.indexes i WHERE i.type_desc = 'HEAP' AND object_name(i.object_id) = 'ContractToDoctor')
BEGIN
	
	CREATE CLUSTERED INDEX CI_ContractToDoctor ON dbo.ContractToDoctor
	(
		DoctorID,
		ContractID
	)
	
END

-- CT_Deletions
IF EXISTS (SELECT * FROM sys.indexes i WHERE i.type_desc = 'HEAP' AND object_name(i.object_id) = 'CT_Deletions')
BEGIN
	
	CREATE CLUSTERED INDEX CI_CT_Deletions ON dbo.CT_Deletions
	(
		ClaimTransactionID
	)
	
END


-- ServiceTypeCodePayerNumber
IF EXISTS (SELECT * FROM sys.indexes i WHERE i.type_desc = 'HEAP' AND object_name(i.object_id) = 'ServiceTypeCodePayerNumber')
BEGIN
	
	CREATE CLUSTERED INDEX CI_ServiceTypeCodePayerNumber ON dbo.ServiceTypeCodePayerNumber
	(
		PayerNumber
	)
	
END


-- PrintingFormDetails
IF EXISTS (SELECT * FROM sys.indexes i WHERE i.type_desc = 'HEAP' AND object_name(i.object_id) = 'PrintingFormDetails')
BEGIN
	
	IF  EXISTS (SELECT * FROM sys.key_constraints WHERE object_id = object_id(N'[dbo].[PK_PrintingFormDetails_PrintingFormDetailsID]') AND parent_object_id = object_id('[dbo].[PrintingFormDetails]'))
	BEGIN
		ALTER TABLE dbo.PrintingFormDetails DROP CONSTRAINT PK_PrintingFormDetails_PrintingFormDetailsID
	END
	
	ALTER TABLE dbo.PrintingFormDetails ADD CONSTRAINT PK_PrintingFormDetails_PrintingFormDetailsID PRIMARY KEY CLUSTERED (PrintingFormDetailsID)
	
END


-- ProcedureMacro
IF EXISTS (SELECT * FROM sys.indexes i WHERE i.type_desc = 'HEAP' AND object_name(i.object_id) = 'ProcedureMacro')
BEGIN
	
	ALTER TABLE dbo.ProcedureMacro ADD CONSTRAINT PK_ProcedureMacro_ProcedureMacroID PRIMARY KEY CLUSTERED (ProcedureMacroID)
	
END


-- ProcedureMacroDetail
IF EXISTS (SELECT * FROM sys.indexes i WHERE i.type_desc = 'HEAP' AND object_name(i.object_id) = 'ProcedureMacroDetail')
BEGIN
	
	CREATE UNIQUE CLUSTERED INDEX CI_ProcedureMacroDetail ON ProcedureMacroDetail
	(
		ProcedureMacroID,
		ProcedureMacroDetailID
	)
	
END


-- TimeblockToAppointmentReason
IF EXISTS (SELECT * FROM sys.indexes i WHERE i.type_desc = 'HEAP' AND object_name(i.object_id) = 'TimeblockToAppointmentReason')
BEGIN
	
	BEGIN
		ALTER TABLE dbo.TimeblockToAppointmentReason DROP CONSTRAINT PK_TimeblockToAppointmentReason_TimeblockToAppointmentReasonID
		ALTER TABLE dbo.TimeblockToAppointmentReason ADD CONSTRAINT PK_TimeblockToAppointmentReason_TimeblockToAppointmentReasonID PRIMARY KEY CLUSTERED (TimeblockToAppointmentReasonID)
	END
	
END

-- Preference
IF EXISTS (SELECT * FROM sys.indexes i WHERE i.type_desc = 'HEAP' AND object_name(i.object_id) = 'Preference')
BEGIN
	
	BEGIN
		ALTER TABLE dbo.Preference DROP CONSTRAINT PK_Preference
		ALTER TABLE dbo.Preference ADD CONSTRAINT PK_Preference PRIMARY KEY CLUSTERED (PreferenceID)
	END
	
END

-- PaymentResponseCode
IF EXISTS (SELECT * FROM sys.indexes i WHERE i.type_desc = 'HEAP' AND object_name(i.object_id) = 'PaymentResponseCode')
BEGIN
	
	DROP INDEX CI_PaymentResponseCode ON PaymentREsponseCode
	
	CREATE CLUSTERED INDEX CI_PaymentResponseCode ON dbo.PaymentResponseCode
	(
		Code
	)
	
END
