UPDATE ProviderSpecialty SET SpecialtyName='Individual Certified Orthotist'
WHERE ProviderSpecialtyCode='222Z00000X'

INSERT INTO ProviderSpecialty(ProviderSpecialtyCode, SpecialtyName)
VALUES('227800000X','Respiratory Therapist, Certified')

INSERT INTO ProviderSpecialty(ProviderSpecialtyCode, SpecialtyName)
VALUES('227900000X','Respiratory Therapist, Registered')

GO

DELETE ProviderSpecialty
WHERE ProviderSpecialtyCode IN ('203BP0004X','203BP0009X','203BP0010X','203BP0400X')

GO