set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

 
--===========================================================================
-- GET PATIENT NAMES
--===========================================================================

ALTER PROCEDURE [dbo].[PatientDataProvider_GetPatientNames]
	@selection_xml TEXT
AS
BEGIN

	DECLARE @x_doc INT
	EXEC sp_xml_preparedocument @x_doc OUTPUT, @selection_xml

	-- case 11144 fix: PatientID contains ClaimID now
	SELECT PatientID 
	INTO #TTClaims
	FROM OPENXML(@x_doc, 'selections/selection') WITH (PatientID INT)

	EXEC sp_xml_removedocument @x_doc

	SELECT C.ClaimID,
		P.PatientID,
		P.Prefix,
		P.FirstName,
		P.MiddleName,
		P.LastName,
		P.Suffix
	FROM	Claim C INNER JOIN PATIENT P ON C.PatientID = P.PatientID
	WHERE	C.ClaimID IN (SELECT PatientID FROM #TTClaims)

	DROP TABLE #TTClaims

END


