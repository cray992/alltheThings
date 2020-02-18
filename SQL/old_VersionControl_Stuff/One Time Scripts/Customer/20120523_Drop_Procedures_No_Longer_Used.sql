--SELECT 'If Exists(Select * from sys.objects where name= '''+o.name+''' and type='''+ o.[type]+''') Drop Procedure '+O.name COLLATE SQL_Latin1_General_CP1_CI_AS
--FROM sys.sql_modules AS sm
--INNER JOIN sys.objects AS o ON sm.object_id = o.object_id
--WHERE sm.uses_quoted_identifier=0
--ORDER BY o.type



If Exists(Select * from sys.objects where name= 'MedicalCodeDataProvider_GetCodingTemplates' and type='P ') Drop Procedure MedicalCodeDataProvider_GetCodingTemplates
If Exists(Select * from sys.objects where name= 'MedicalCodeDataProvider_GetCodingTemplate' and type='P ') Drop Procedure MedicalCodeDataProvider_GetCodingTemplate
If Exists(Select * from sys.objects where name= 'MedicalCodeDataProvider_CreateCodingTemplate' and type='P ') Drop Procedure MedicalCodeDataProvider_CreateCodingTemplate
If Exists(Select * from sys.objects where name= 'MedicalCodeDataProvider_UpdateCodingTemplate' and type='P ') Drop Procedure MedicalCodeDataProvider_UpdateCodingTemplate
If Exists(Select * from sys.objects where name= 'MedicalCodeDataProvider_DeleteCodingTemplate' and type='P ') Drop Procedure MedicalCodeDataProvider_DeleteCodingTemplate
If Exists(Select * from sys.objects where name= 'DMSDataProvider_CreateFileToRecordAssociation' and type='P ') Drop Procedure DMSDataProvider_CreateFileToRecordAssociation
If Exists(Select * from sys.objects where name= 'DMSDataProvider_DeleteFileToRecordAssociation' and type='P ') Drop Procedure DMSDataProvider_DeleteFileToRecordAssociation
If Exists(Select * from sys.objects where name= 'AppointmentDataProvider_GetAppointmentCodingTemplates' and type='P ') Drop Procedure AppointmentDataProvider_GetAppointmentCodingTemplates
If Exists(Select * from sys.objects where name= 'DataManagement_RegenerateClaimTransactionBalances' and type='P ') Drop Procedure DataManagement_RegenerateClaimTransactionBalances
If Exists(Select * from sys.objects where name= 'DataManagement_RegenerateSummary' and type='P ') Drop Procedure DataManagement_RegenerateSummary
If Exists(Select * from sys.objects where name= 'ReportDataProvider_EncounterForm_PracticeInfo' and type='P ') Drop Procedure ReportDataProvider_EncounterForm_PracticeInfo
If Exists(Select * from sys.objects where name= 'PracticeDataProvider_CreateProcedureMacro' and type='P ') Drop Procedure PracticeDataProvider_CreateProcedureMacro
If Exists(Select * from sys.objects where name= 'PracticeDataProvider_CreateProcedureMacroDetail' and type='P ') Drop Procedure PracticeDataProvider_CreateProcedureMacroDetail