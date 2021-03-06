set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO

--===========================================================================
-- GET INSURANCE PLANS
--declare @k int
--exec InsurancePlanDataProvider_GetInsurancePlans null, null, null, null, 0, 25, @k
--===========================================================================
ALTER PROCEDURE [dbo].[InsurancePlanDataProvider_GetInsurancePlans]
	@query_domain VARCHAR(50) = NULL,
	@query VARCHAR(50) = NULL,
	@review_code CHAR(1) = NULL,
	@show_code CHAR(1) = NULL,
	@startRecord int = 0,
	@maxRecords int = 25,
	@totalRecords int = NULL OUTPUT
AS
BEGIN

  IF (@query_domain IS NOT NULL AND @query_domain = 'ClaimID')
  BEGIN
	SELECT	IP.InsuranceCompanyPlanID,
		IC.InsuranceCompanyID, 
		IC.InsuranceCompanyName, 
		IP.PlanName,
		IP.AddressLine1,
		IP.AddressLine2,
		IP.City,
		IP.State,
		IP.Country,
		IP.ZipCode,
		-- case 14789
		dbo.fn_FormatAddress (IP.AddressLine1, IP.AddressLine2, IP.City, IP.State, IP.ZipCode) as FullAddress,
		dbo.fn_FormatPhoneWithExt (IP.Phone, IP.PhoneExt) as FullPhoneNumber,
		IP.ContactPrefix,
		IP.ContactFirstName,
		IP.ContactMiddleName,
		IP.ContactLastName,
		IP.ContactSuffix,
		IP.Phone,
		IP.PhoneExt,
		IP.Fax,
		IP.FaxExt,
		IP.CoPay,
		IP.Deductible, 
		IC.InsuranceProgramCode,
		IC.ProviderNumberTypeID,
		IC.GroupNumberTypeID,
		IC.LocalUseProviderNumberTypeID,
		IC.HCFADiagnosisReferenceFormatCode,
		IC.HCFASameAsInsuredFormatCode,
		CPL.PayerNumber AS EDIPayerNumber,
		ISNULL(CH.ClearinghouseName,'') AS ClearinghouseDisplayName,
		(CPL.[Name] + '   (' + CAST(CPL.ClearinghousePayerID AS VARCHAR) + ')') AS ClearinghousePayerDisplayName,
		COALESCE(CPL.Notes,'') AS ClearinghouseNotes,
		IP.Notes,
		IP.ReviewCode,
		IC.ClearinghousePayerID,
		IC.DefaultAdjustmentCode as DefaultAdjustmentCode,
		CAST (CPL.IsGovernment AS INT) AS IsGovernment,
		CPL.StateSpecific,
		CAST (ISNULL(CPL.IsEnrollmentRequired,0) AS BIT) AS EClaimsRequiresEnrollment,
		CAST (ISNULL(CPL.IsAuthorizationRequired,0) AS BIT) AS EClaimsRequiresAuthorization,
		CAST (ISNULL(CPL.IsProviderIdRequired,0) AS BIT) AS EClaimsRequiresProviderID,
		CAST (ISNULL(CPL.IsTestRequired,0) AS BIT) AS EClaimsRequiresTest,
		CAST (ISNULL(CPL.IsPaperOnly,0) AS BIT) AS EClaimsPaperOnly,
		CAST (ISNULL(CPL.ResponseLevel,0) AS INT) AS EClaimsResponseLevel,
		IC.EClaimsAccepts,
		CASE WHEN IP.CreatedPracticeID IS NULL THEN 'Administrator' ELSE COALESCE(CP.Name + ' (','(') + COALESCE(CAST(CP.PracticeID AS VARCHAR),'0') + ')' END AS CreatorPractice,
		CAST('No' AS VARCHAR (10)) AS EClaimsStatus,
		CASE WHEN IP.ReviewCode = 'R' THEN 'Approved' ELSE 'Not approved' END AS ApprovalStatus,
		CASE WHEN PIn.InsuranceCompanyPlanID IS NULL AND CIn.PlanID IS NULL THEN CAST(1 as BIT) ELSE CAST(0 AS BIT) END AS Deletable,
		KareoInsuranceCompanyPlanID, 
		IDENTITY(int, 0, 1) as RID
	INTO 
		#t_InsuranceCompanyPlan
	FROM	
		dbo.InsuranceCompanyPlan IP
		INNER JOIN dbo.InsuranceCompany IC
		 ON IC.InsuranceCompanyID = IP.InsuranceCompanyID
		LEFT OUTER JOIN ClearinghousePayersList CPL
		  ON IC.ClearinghousePayerID = CPL.ClearinghousePayerID
		LEFT OUTER JOIN SharedServer.superbill_shared.dbo.Clearinghouse CH
		  ON CH.ClearinghouseID = CPL.ClearinghouseID 
		LEFT OUTER JOIN Practice CP
		  ON IP.CreatedPracticeID = CP.PracticeID
		LEFT OUTER JOIN (SELECT	DISTINCT InsuranceCompanyPlanID FROM InsurancePolicy) PIn
		  ON PIn.InsuranceCompanyPlanID = IP.InsuranceCompanyPlanID
		LEFT OUTER JOIN (SELECT	DISTINCT PlanID FROM ContractToInsurancePlan) CIn
		  ON CIn.PlanID = IP.InsuranceCompanyPlanID
		INNER JOIN Claim C
		  ON C.ClaimID = @query
		INNER JOIN EncounterProcedure EP
			ON EP.PracticeID = C.PracticeID 
			AND EP.EncounterProcedureID = C.EncounterProcedureID
		INNER JOIN Encounter E
		    ON E.PracticeID = EP.PracticeID 
			AND E.EncounterID = EP.EncounterID
		INNER JOIN PatientCase PC
		    ON PC.PracticeID = E.PracticeID 
			AND PC.PatientCaseID = E.PatientCaseID
		INNER JOIN InsurancePolicy I
			ON I.PracticeID = PC.PracticeID
			AND I.PatientCaseID = PC.PatientCaseID
		    AND I.InsuranceCompanyPlanID = IP.InsuranceCompanyPlanID

	UPDATE #t_InsuranceCompanyPlan
	SET EClaimsStatus = 'Yes' WHERE EClaimsAccepts = 1
	
	SELECT @totalRecords = COUNT(*)
	FROM #t_InsuranceCompanyPlan
	
	IF @maxRecords = 0
		SET @maxRecords = @totalRecords
		
	SELECT *
	FROM #t_InsuranceCompanyPlan
	WHERE RID BETWEEN @startRecord AND (@startRecord + @maxRecords - 1)
	
	DROP TABLE #t_InsuranceCompanyPlan
	RETURN
  END
  ELSE
  BEGIN
	SELECT	IP.InsuranceCompanyPlanID,
		IC.InsuranceCompanyID, 
		IC.InsuranceCompanyName, 
		IP.PlanName,
		IP.AddressLine1,
		IP.AddressLine2,
		IP.City,
		IP.State,
		IP.Country,
		IP.ZipCode,
		-- case 14789
		dbo.fn_FormatAddress (IP.AddressLine1, IP.AddressLine2, IP.City, IP.State, IP.ZipCode) as FullAddress,
		dbo.fn_FormatPhoneWithExt (IP.Phone, IP.PhoneExt) as FullPhoneNumber,
		IP.ContactPrefix,
		IP.ContactFirstName,
		IP.ContactMiddleName,
		IP.ContactLastName,
		IP.ContactSuffix,
		IP.Phone,
		IP.PhoneExt,
		IP.Fax,
		IP.FaxExt,
		IP.Copay,
		IP.Deductible, 
		IC.InsuranceProgramCode,
		IC.ProviderNumberTypeID,
		IC.GroupNumberTypeID,
		IC.LocalUseProviderNumberTypeID,
		IC.HCFADiagnosisReferenceFormatCode,
		IC.HCFASameAsInsuredFormatCode,
		CPL.PayerNumber AS EDIPayerNumber,
		ISNULL(CH.ClearinghouseName,'') AS ClearinghouseDisplayName,
		(CPL.[Name] + '   (' + CAST(CPL.ClearinghousePayerID AS VARCHAR) + ')') AS ClearinghousePayerDisplayName,
		COALESCE(CPL.Notes,'') AS ClearinghouseNotes,
		IP.Notes,
		IP.ReviewCode,
		IC.ClearinghousePayerID,
		IC.DefaultAdjustmentCode as DefaultAdjustmentCode,
		CAST (CPL.IsGovernment AS INT) AS IsGovernment,
		CPL.StateSpecific,
		CAST (ISNULL(CPL.IsEnrollmentRequired,0) AS BIT) AS EClaimsRequiresEnrollment,
		CAST (ISNULL(CPL.IsAuthorizationRequired,0) AS BIT) AS EClaimsRequiresAuthorization,
		CAST (ISNULL(CPL.IsProviderIdRequired,0) AS BIT) AS EClaimsRequiresProviderID,
		CAST (ISNULL(CPL.IsTestRequired,0) AS BIT) AS EClaimsRequiresTest,
		CAST (ISNULL(CPL.IsPaperOnly,0) AS BIT) AS EClaimsPaperOnly,
		CAST (ISNULL(CPL.ResponseLevel,0) AS INT) AS EClaimsResponseLevel,
		IC.EClaimsAccepts,
		CASE WHEN IP.CreatedPracticeID IS NULL THEN 'Administrator' ELSE COALESCE(CP.Name + ' (','(') + COALESCE(CAST(CP.PracticeID AS VARCHAR),'0') + ')' END AS CreatorPractice,
		CAST('No' AS VARCHAR (10)) AS EClaimsStatus,
		CASE WHEN IP.ReviewCode = 'R' THEN 'Approved' ELSE 'Not approved' END AS ApprovalStatus,
		CASE WHEN PIn.InsuranceCompanyPlanID IS NULL AND CIn.PlanID IS NULL THEN CAST(1 as BIT) ELSE CAST(0 AS BIT) END AS Deletable,
		KareoInsuranceCompanyPlanID, 
		IDENTITY(int, 0, 1) as RID
	INTO 
		#t_InsuranceCompanyPlan1
	FROM	
		dbo.InsuranceCompanyPlan IP
		INNER JOIN dbo.InsuranceCompany IC
		 ON IP.InsuranceCompanyID = IC.InsuranceCompanyID
		LEFT OUTER JOIN ClearinghousePayersList CPL
		  ON IC.ClearinghousePayerID = CPL.ClearinghousePayerID
		LEFT OUTER JOIN SharedServer.superbill_shared.dbo.Clearinghouse CH
		  ON CH.ClearinghouseID = CPL.ClearinghouseID 
		LEFT OUTER JOIN Practice CP
		  ON IP.CreatedPracticeID = CP.PracticeID
		LEFT OUTER JOIN (SELECT	DISTINCT InsuranceCompanyPlanID FROM InsurancePolicy) PIn
		  ON PIn.InsuranceCompanyPlanID = IP.InsuranceCompanyPlanID
		LEFT OUTER JOIN (SELECT	DISTINCT PlanID FROM ContractToInsurancePlan) CIn
		  ON CIn.PlanID = IP.InsuranceCompanyPlanID
	WHERE
		(	(@query_domain IS NULL OR @query IS NULL)
			OR	((@query_domain = 'InsuranceCompany' OR @query_domain = 'All')
				AND IC.InsuranceCompanyName LIKE '%' + @query + '%')
			OR	((@query_domain = 'Clearinghouse' OR @query_domain = 'All')
				AND CH.ClearinghouseName LIKE '%' + @query + '%')
			OR	((@query_domain = 'PlanName' OR @query_domain = 'All')
				AND IP.PlanName LIKE '%' + @query + '%')
			OR	((@query_domain = 'Address' OR @query_domain = 'All')
				AND	(IP.AddressLine1 LIKE '%' + @query + '%'
					OR IP.AddressLine2 LIKE '%' + @query + '%'
					OR IP.City LIKE '%' + @query + '%'
					OR IP.State LIKE '%' + @query + '%'
					OR IP.ZipCode LIKE '%' + @query + '%'))
			OR	((@query_domain = 'Phone' OR @query_domain = 'All')
				AND	(IP.Phone LIKE '%' + REPLACE(REPLACE(REPLACE(@query,'-',''),'(',''),')','') + '%'))
		)
		AND	((@review_code IS NULL)
			  OR	(@review_code IS NOT NULL
				AND IC.ReviewCode = @review_code))
		AND	((@show_code IS NULL)
			  OR	(@show_code = '1' AND IC.EClaimsAccepts = 1)
			  OR	(@show_code = '0' AND IC.EClaimsAccepts = 0))
	ORDER BY PlanName, CPL.ClearinghouseID

	UPDATE #t_InsuranceCompanyPlan1
	SET EClaimsStatus = 'Yes' WHERE EClaimsAccepts = 1
	
	SELECT @totalRecords = COUNT(*)
	FROM #t_InsuranceCompanyPlan1
	
	IF @maxRecords = 0
		SET @maxRecords = @totalRecords
		
	SELECT *
	FROM #t_InsuranceCompanyPlan1
	WHERE RID BETWEEN @startRecord AND (@startRecord + @maxRecords - 1)
	
	DROP TABLE #t_InsuranceCompanyPlan1
	RETURN
  END
END

