--Move schedules' start date forward one day, 
--to avoid conflicts with legacy force-expired schedules.
UPDATE ContractsAndFees_ContractRateSchedule
SET EffectiveStartDate = DATEADD(DAY, 1, EffectiveStartDate)
WHERE ContractRateScheduleID IN

(
	--find real contracts that overlap with a contract we force-disabled
	SELECT crs1.ContractRateScheduleID
	FROM ContractsAndFees_ContractRateSchedule crs1
	WHERE crs1.EffectiveStartDate<>crs1.EffectiveEndDate 
	AND EXISTS
	(
		--find a matching schedule that is only a few seconds long
		SELECT crs2.ContractRateScheduleID
		FROM ContractsAndFees_ContractRateSchedule crs2
		WHERE crs2.EffectiveStartDate = crs2.EffectiveEndDate
		AND crs1.InsuranceCompanyID = crs2.InsuranceCompanyID
		AND crs2.EffectiveStartDate = crs1.EffectiveStartDate
		--and it has to share a link to be considered conflicting.
		AND EXISTS
		(
			(SELECT crsl1.LocationID, crsl1.ProviderID
			FROM ContractsAndFees_ContractRateScheduleLink crsl1
			WHERE crsl1.ContractRateScheduleID = crs1.ContractRateScheduleID)
			
			INTERSECT
			
			(SELECT crsl2.LocationID, crsl2.ProviderID
			FROM ContractsAndFees_ContractRateScheduleLink crsl2
			WHERE crsl2.ContractRateScheduleID = crs2.ContractRateScheduleID)
		)
	)
)

--It's possible that this change made start dates larger than the end dates. 
--Check for and repair inverted start/end values.
UPDATE ContractsAndFees_ContractRateSchedule
SET EffectiveEndDate = EffectiveStartDate
WHERE EffectiveEndDate < EffectiveStartDate


