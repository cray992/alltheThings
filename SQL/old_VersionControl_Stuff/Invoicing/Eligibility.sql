--	CREATE TABLE #EligibilityCheckMetrics(PracticeID INT, DoctorID INT, Requests INT)
--	INSERT INTO #EligibilityCheckMetrics(PracticeID, DoctorID, Requests)
--	SELECT IP.PracticeID, COALESCE(P.PrimaryProviderID,P.PrimaryCarePhysicianID,E.DoctorID) DoctorID, COUNT(DISTINCT RequestID) Requests
--	FROM {3}EligibilityHistory EH INNER JOIN {3}InsurancePolicy IP
--	ON EH.InsurancePolicyID=IP.InsurancePolicyID
--	INNER JOIN {3}PatientCase PC
--	ON IP.PatientCaseID=PC.PatientCaseID
--	INNER JOIN {3}Patient P
--	ON PC.PatientID=P.PatientID
--	LEFT JOIN {3}Encounter E
--	ON PC.PatientCaseiD=E.PatientCaseID
--	WHERE EH.ResponseXML IS NOT NULL AND EH.CreatedDate BETWEEN @StartDate AND @EndDate
--	GROUP BY IP.PracticeID, COALESCE(P.PrimaryProviderID,P.PrimaryCarePhysicianID,E.DoctorID)


--	--Eligibility
--	INSERT INTO #GLReport(CustomerID, ProductSort, StartDate, EndDate, Product, PracticeName, ProviderName, Degree, Created, ProRate, Qty, UnitPrice, TotalPrice)
--	SELECT @CustomerID, 4 ProductSort, @StartDate StartDate, @EndDate EndDate, ''Eligibility'' Product, P.PracticeName, NULL ProviderName, NULL Degree, NULL Created, 
--	1.00 ProRate, SUM(Requests) Qty, 0.30 UnitPrice, NULL TotalPrice
--	FROM #PayingProviders PP INNER JOIN #Practices P
--	ON PP.PracticeID=P.PracticeID
--	INNER JOIN #EligibilityCheckMetrics EC
--	ON PP.PracticeID=EC.PracticeID AND PP.DoctorID=EC.DoctorID
--	GROUP BY P.PracticeName
--	HAVING SUM(Requests)>0

