DECLARE @MergeToID INT
DECLARE @MergeID INT
--
--SET @MergeToID=
--SET @MergeID=

UPDATE ContractToServiceLocation SET ServiceLocationID=@MergeToID
WHERE ServiceLocationID=@MergeID

UPDATE Appointment SET ServiceLocationID=@MergeToID
WHERE ServiceLocationID=@MergeID

UPDATE HandheldEncounter SET ServiceLocationID=@MergeToID
WHERE ServiceLocationID=@MergeID

UPDATE Encounter SET LocationID=@MergeToID
WHERE LocationID=@MergeID

UPDATE PracticeInsuranceGroupNumber SET LocationID=@MergeToID
WHERE LocationID=@MergeID

UPDATE ProviderNumber SET LocationID=@MergeToID
WHERE LocationID=@MergeID

UPDATE Patient SET DefaultServiceLocationID=@MergeToID
WHERE DefaultServiceLocationID=@MergeID

DELETE ServiceLocation
WHERE ServiceLocationID=@MergeID
