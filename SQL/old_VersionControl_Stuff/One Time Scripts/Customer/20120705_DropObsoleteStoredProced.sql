

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[apD_DeleteEncounter]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[apD_DeleteEncounter]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[apD_DeletePatient]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].apD_DeletePatient
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[apD_UserPractice]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].apD_UserPractice
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[apG_GetPatientAuthorizationUse]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].apG_GetPatientAuthorizationUse
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[apL_AuthorizeUserForPractice]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].apL_AuthorizeUserForPractice
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[apL_GetAppointmentsForPatient]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].apL_GetAppointmentsForPatient
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[apL_GetEmployerForPatient]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].apL_GetEmployerForPatient
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[apL_GetEncounterForPatient]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].apL_GetEncounterForPatient
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[apL_GetEncounterStatusCounts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].apL_GetEncounterStatusCounts
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[apL_GetProcedureCodesForEncounter]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].apL_GetProcedureCodesForEncounter
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AppointmentDataProvider_GetAppointmentRecurrenceMonthlyDayByType]') AND type in (N'FN'))
DROP FUNCTION [dbo].AppointmentDataProvider_GetAppointmentRecurrenceMonthlyDayByType
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AppointmentDataProvider_GetAppointmentRecurrenceWeekOfYear]') AND type in (N'FN'))
DROP FUNCTION [dbo].AppointmentDataProvider_GetAppointmentRecurrenceWeekOfYear

GO


