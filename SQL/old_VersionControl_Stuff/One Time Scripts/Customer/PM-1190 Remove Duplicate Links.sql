SELECT MIN(sfsl.StandardFeeScheduleLinkID) AS LinkID
INTO #LinksToKeep
FROM ContractsAndFees_StandardFeeScheduleLink sfsl
GROUP BY sfsl.StandardFeeScheduleID, sfsl.ProviderID, sfsl.LocationID

DELETE FROM ContractsAndFees_StandardFeeScheduleLink
WHERE StandardFeeScheduleLinkID NOT IN
(
	SELECT ltk.LinkID
	FROM #LinksToKeep ltk
)

TRUNCATE TABLE #LinksToKeep

INSERT INTO #LinksToKeep (LinkID)
SELECT MIN(crsl.ContractRateScheduleLinkID) AS LinkID
FROM ContractsAndFees_ContractRateScheduleLink crsl
GROUP BY crsl.ContractRateScheduleID, crsl.ProviderID, crsl.LocationID

DELETE FROM ContractsAndFees_ContractRateScheduleLink
WHERE ContractRateScheduleLinkID NOT IN
(
	SELECT ltk.LinkID
	FROM #LinksToKeep ltk
)

DROP TABLE #LinksToKeep
