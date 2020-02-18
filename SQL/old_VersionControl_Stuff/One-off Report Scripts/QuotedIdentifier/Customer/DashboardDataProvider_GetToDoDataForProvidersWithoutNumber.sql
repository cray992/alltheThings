SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DashboardDataProvider_GetToDoDataForProvidersWithoutNumber]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DashboardDataProvider_GetToDoDataForProvidersWithoutNumber]
GO


CREATE PROCEDURE dbo.DashboardDataProvider_GetToDoDataForProvidersWithoutNumber
	@PracticeID int = 34
AS
BEGIN
	
	SELECT D.DoctorID AS ProviderID,
		RTRIM(ISNULL(D.FirstName + ' ','') + ISNULL(D.MiddleName + ' ', '')) + ISNULL(' ' + D.LastName,'') + ISNULL(', ' + dbo.fn_ZeroLengthStringToNull(D.Degree), '') AS ProviderFullname
	FROM dbo.Doctor D
	WHERE D.PracticeID = @PracticeID
		AND D.[External] = 0
		AND NOT EXISTS (SELECT *
						FROM dbo.ProviderNumber PN
						WHERE PN.DoctorID = D.DoctorID)


END
