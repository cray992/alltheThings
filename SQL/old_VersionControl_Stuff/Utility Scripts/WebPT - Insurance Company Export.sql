
DECLARE @PracticeID INT
SET @PracticeID = -1

--DECLARE @ids TABLE (id INT)

--DECLARE @maxrecords INT,
--    @totalrecords INT

--DECLARE @query_domain VARCHAR(50),
--    @query VARCHAR(50),
--    @review_code VARCHAR(2),
--    @show_code VARCHAR(2)

--DECLARE @InsuranceCompanyPlan TABLE (InsuranceCompanyPlanID INT,
--                                     PlanName VARCHAR(128),
--                                     AddressLine1 VARCHAR(256),
--                                     AddressLine2 VARCHAR(256),
--                                     City VARCHAR(128),
--                                     State VARCHAR(2),
--                                     Country VARCHAR(32),
--                                     ZipCode VARCHAR(9),
--                                     ContactPrefix VARCHAR(16),
--                                     ContactFirstName VARCHAR(64),
--                                     ContactMiddleName VARCHAR(64),
--                                     ContactLastName VARCHAR(64),
--                                     ContactSuffix VARCHAR(16),
--                                     Phone VARCHAR(10),
--                                     PhoneExt VARCHAR(10),
--                                     Fax VARCHAR(10),
--                                     FaxExt VARCHAR(10),
--                                     Copay MONEY,
--                                     Deductible MONEY,
--                                     InsuranceProgramCode CHAR(2),
--                                     EDIPayerNumber VARCHAR(32),
--                                     ClearinghouseDisplayName VARCHAR(32),
--                                     ClearinghousePayerDisplayName VARCHAR(1024),
--                                     ClearinghouseNotes VARCHAR(1000),
--                                     Notes TEXT,
--                                     ReviewCode CHAR(1),
--                                     ClearinghousePayerID INT,
--                                     IsGovernment BIT,
--                                     StateSpecific VARCHAR(256),
--                                     EClaimsRequiresEnrollment BIT,
--                                     EClaimsRequiresAuthorization BIT,
--                                     EClaimsRequiresProviderID BIT,
--                                     EClaimsRequiresTest BIT,
--                                     EClaimsPaperOnly BIT,
--                                     EClaimsResponseLevel INT,
--                                     EClaimsAccepts BIT,
--                                     CreatorPractice VARCHAR(164),
--                                     EClaimsStatus VARCHAR(50),
--                                     ApprovalStatus VARCHAR(12),
--                                     Scope VARCHAR(20),
--                                     EClaimsEnrollmentStatusID INT,
--                                     EClaimsDisable BIT,
--                                     InsuranceCompanyName VARCHAR(128),
--                                     DefaultAdjustmentCode VARCHAR(10),
--                                     Deletable BIT,
--                                     RID INT)
		
--SELECT  CAST(IP.InsuranceCompanyPlanID AS INT) AS InsuranceCompanyPlanID, IP.PlanName, IP.AddressLine1, IP.AddressLine2,
--        IP.City, IP.State, IP.Country, IP.ZipCode, IP.ContactPrefix, IP.ContactFirstName, IP.ContactMiddleName,
--        IP.ContactLastName, IP.ContactSuffix, IP.Phone, IP.PhoneExt, IP.Fax, IP.FaxExt, IP.Copay, IP.Deductible,
--        IC.InsuranceProgramCode, CPL.PayerNumber AS EDIPayerNumber,
--        ISNULL(CH.ClearinghouseName, '') AS ClearinghouseDisplayName,
--        (CPL.[Name] + '   (' + CAST(CPL.ClearinghousePayerID AS VARCHAR) + ')') AS ClearinghousePayerDisplayName,
--        COALESCE(CPL.Notes, '') AS ClearinghouseNotes, IP.Notes, IP.ReviewCode, IC.ClearinghousePayerID,
--        CAST (CPL.IsGovernment AS INT) AS IsGovernment, CPL.StateSpecific,
--        CAST (ISNULL(CPL.IsEnrollmentRequired, 0) AS BIT) AS EClaimsRequiresEnrollment,
--        CAST (ISNULL(CPL.IsAuthorizationRequired, 0) AS BIT) AS EClaimsRequiresAuthorization,
--        CAST (ISNULL(CPL.IsProviderIdRequired, 0) AS BIT) AS EClaimsRequiresProviderID,
--        CAST (ISNULL(CPL.IsTestRequired, 0) AS BIT) AS EClaimsRequiresTest,
--        CAST (ISNULL(CPL.IsPaperOnly, 0) AS BIT) AS EClaimsPaperOnly,
--        CAST (ISNULL(CPL.ResponseLevel, 0) AS INT) AS EClaimsResponseLevel, IC.EClaimsAccepts,
--        CASE WHEN IP.CreatedPracticeID IS NULL THEN 'Administrator'
--             ELSE COALESCE(CP.Name + ' (', '(') + COALESCE(CAST(CP.PracticeID AS VARCHAR), '0') + ')'
--        END AS CreatorPractice, CAST('Not enrolled' AS VARCHAR(50)) AS EClaimsStatus,
--        CASE WHEN IP.ReviewCode = 'R' THEN 'Approved'
--             ELSE 'Not approved'
--        END AS ApprovalStatus, CASE WHEN IP.ReviewCode = 'R' THEN 'All Practices'
--                                    ELSE 'Practice Specific'
--                               END AS Scope, CAST(PTICP.EClaimsEnrollmentStatusID AS INT) AS EClaimsEnrollmentStatusID,
--        CAST(PTICP.EClaimsDisable AS BIT) AS EClaimsDisable, IC.InsuranceCompanyName, IC.DefaultAdjustmentCode,
--        CAST (1 AS BIT) Deletable, IDENTITY( INT, 0, 1 ) AS RID
--INTO    #t_InsuranceCompanyPlan
--FROM    dbo.InsuranceCompany IC
--        LEFT JOIN  dbo.InsuranceCompanyPlan IP ON IC.InsuranceCompanyID = IP.InsuranceCompanyID
--        LEFT OUTER JOIN SHAREDSERVER.Superbill_Shared.dbo.ClearinghousePayersList CPL ON IC.ClearinghousePayerID = CPL.ClearinghousePayerID
--        LEFT OUTER JOIN SharedServer.superbill_shared.dbo.Clearinghouse CH ON CH.ClearinghouseID = CPL.ClearinghouseID
--        LEFT OUTER JOIN Practice CP ON CP.PracticeID = IP.CreatedPracticeID
--        LEFT OUTER JOIN PracticeToInsuranceCompany PTICP ON PTICP.InsuranceCompanyID = IC.InsuranceCompanyID
--                                                            AND PTICP.PracticeID = @PracticeID
--ORDER BY PlanName, CPL.ClearinghouseID

--	-- Get the records we are going to return
--SELECT  @totalRecords = @@rowcount
	
--IF @maxRecords = 0 
--    SET @maxRecords = @totalRecords

--INSERT  INTO @InsuranceCompanyPlan
--        SELECT  *
--        FROM    #t_InsuranceCompanyPlan

--INSERT  INTO @ids
--        SELECT  InsuranceCompanyPlanID
--        FROM    @InsuranceCompanyPlan
	
--DROP TABLE #t_InsuranceCompanyPlan
	
SELECT  IC.InsuranceCompanyID, IC.InsuranceCompanyName, IC.AddressLine1, IC.AddressLine2, IC.City, IC.State, IC.Country,
        IC.ZipCode,
        CASE WHEN IC.ReviewCode = 'R' THEN 'False'
             ELSE 'True'
        END AS InsuranceCompanyPracticeSpecific, 
        IC.CreatedPracticeID AS InsuranceCompanyCreatedPracticeID,
        ICP.InsuranceCompanyPlanID, ICP.PlanName, ICP.AddressLine1, ICP.AddressLine2, ICP.City, ICP.State, ICP.Country,
        ICP.ZipCode, ICP.InsuranceCompanyID,
        CASE WHEN ICP.ReviewCode = 'R' THEN 'False'
             ELSE 'True'
        END AS InsurancePlanPracticeSpecific, ICP.CreatedPracticeID AS InsurancePlanCreatedPracticeID,

        CASE WHEN IC.CreatedPracticeID <> ICP.CreatedPracticeID
                  AND IC.ReviewCode = ''
                  AND ICP.ReviewCode = '' THEN 'True'
             ELSE 'False'
        END AS InvisbilePlan

FROM    dbo.InsuranceCompany IC
 INNER JOIN PracticeToInsuranceCompany PTICP ON PTICP.InsuranceCompanyID = IC.InsuranceCompanyID
                                                            AND PTICP.PracticeID = @PracticeID
        LEFT OUTER JOIN dbo.InsuranceCompanyPlan ICP ON IC.InsuranceCompanyID = ICP.InsuranceCompanyID 
        LEFT OUTER JOIN Practice CP ON CP.PracticeID = ICP.CreatedPracticeID
       
--WHERE   icp.InsuranceCompanyPlanID IN (SELECT DISTINCT
--                                                (id)
--                                       FROM     @ids)
ORDER BY IC.InsuranceCompanyName, ICP.PlanName
