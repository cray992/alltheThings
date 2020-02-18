DELETE FROM dbo.ContractsAndFees_StandardFeeScheduleLink
WHERE ProviderID IN
(
	SELECT DoctorID
	FROM dbo.Doctor AS D 
	WHERE ActiveDoctor = 0
)  

DELETE FROM dbo.ContractsAndFees_ContractRateScheduleLink 
WHERE ProviderID IN 
(
	SELECT DoctorID
	FROM dbo.Doctor AS D 
	WHERE ActiveDoctor = 0
)  
