--SELECT *
--FROM ContractsAndFees_StandardFeeScheduleLink sfsl
--WHERE sfsl.LocationID NOT IN
--(
--	SELECT sl.ServiceLocationID
--	FROM ServiceLocation sl
--)
--OR sfsl.ProviderID NOT IN
--(
--	SELECT d.DoctorID
--	FROM Doctor d
--)

DELETE
FROM ContractsAndFees_StandardFeeScheduleLink
WHERE LocationID NOT IN
(
	SELECT sl.ServiceLocationID
	FROM ServiceLocation sl
)
OR ProviderID NOT IN
(
	SELECT d.DoctorID
	FROM Doctor d
)

--SELECT *
--FROM ContractsAndFees_ContractRateScheduleLink crsl
--WHERE crsl.LocationID NOT IN
--(
--	SELECT sl.ServiceLocationID
--	FROM ServiceLocation sl
--)
--OR crsl.ProviderID NOT IN
--(
--	SELECT d.DoctorID
--	FROM Doctor d
--)

DELETE
FROM ContractsAndFees_ContractRateScheduleLink
WHERE LocationID NOT IN
(
	SELECT sl.ServiceLocationID
	FROM ServiceLocation sl
)
OR ProviderID NOT IN
(
	SELECT d.DoctorID
	FROM Doctor d
)
