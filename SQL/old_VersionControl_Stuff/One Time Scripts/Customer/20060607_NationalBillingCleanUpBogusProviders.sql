-- Case 11278 - Clean up data for National Billing with bogus providers

-- Remove referring physicians in Encounters linked to these bogus doctors
UPDATE Encounter
SET ReferringPhysicianID = NULL
WHERE ReferringPhysicianID IN (1428,1434,2154,2532)

UPDATE Encounter
SET SupervisingProviderID = NULL
WHERE SupervisingProviderID IN (1428,1434,2154,2532)

-- Remove referring physicians in Patients linked to these bogus doctors
UPDATE Patient
SET ReferringPhysicianID = NULL
WHERE ReferringPhysicianID IN (1428,1434,2154,2532)

UPDATE Patient 
SET PrimaryProviderID = NULL
WHERE PrimaryProviderID IN (1428,1434,2154,2532)

UPDATE Patient 
SET PrimaryCarePhysicianID = NULL
WHERE PrimaryCarePhysicianID IN (1428,1434,2154,2532)

-- Delete the bogus doctors
DELETE FROM Doctor WHERE DoctorID IN (1428,1434,2154,2532)