/**********************************************************************************************
** Name		: AppointmentDataProvider_GetAppointmentEncounterTemplates
**
** Desc         : Gets the default encounter templates for a group of appointments
**
** Test		: AppointmentDataProvider_GetAppointmentEncounterTemplates '<?xml version=''1.0'' ?><selections><selection AppointmentID=''116215'' /><selection AppointmentID=''174881'' /></selections>'
***********************************************************************************************/
IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'AppointmentDataProvider_GetAppointmentEncounterTemplates'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.AppointmentDataProvider_GetAppointmentEncounterTemplates
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE PROCEDURE dbo.AppointmentDataProvider_GetAppointmentEncounterTemplates
	@AppointmentsXML TEXT
AS
BEGIN
	DECLARE @x_doc INT
	EXEC sp_xml_preparedocument @x_doc OUTPUT, @AppointmentsXML

	SELECT	ATR.AppointmentID,
		D.DoctorID,
		D.DefaultEncounterTemplateID
	FROM	(	SELECT	AppointmentID
			FROM	OPENXML(@x_doc, 'selections/selection')
			WITH (AppointmentID INT)) A
	INNER JOIN	AppointmentToResource ATR
	ON		   ATR.AppointmentID = A.AppointmentID
	AND		   ATR.AppointmentResourceTypeID = 1		-- Get doctors only
	INNER JOIN	Doctor D
	ON		   D.DoctorID = ATR.ResourceID
	AND		   D.DefaultEncounterTemplateID IS NOT NULL

	EXEC sp_xml_removedocument @x_doc

END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO