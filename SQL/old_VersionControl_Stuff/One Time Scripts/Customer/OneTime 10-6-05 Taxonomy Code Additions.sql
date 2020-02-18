INSERT INTO ProviderSpecialty(ProviderSpecialtyCode,SpecialtyName, Description)
VALUES('207X00000X','Orthopedic Surgery',NULL)

INSERT INTO ProviderSpecialty(ProviderSpecialtyCode,SpecialtyName, Description)
VALUES('207Q00000X','Family Practice',NULL)

INSERT INTO ProviderSpecialty(ProviderSpecialtyCode,SpecialtyName, Description)
VALUES('222Z00000X','Invidividual Certified Orthotist',NULL)

INSERT INTO ProviderSpecialty(ProviderSpecialtyCode,SpecialtyName, Description)
VALUES('224P00000X','Individual Certified Prosthesist',NULL)

INSERT INTO ProviderSpecialty(ProviderSpecialtyCode,SpecialtyName, Description)
VALUES('225000000X','Individual Certified Orthotics/Prosthetics Fitter',NULL)

INSERT INTO ProviderSpecialty(ProviderSpecialtyCode,SpecialtyName, Description)
VALUES('208100000X','Physical Medicine & Rehabiltion',NULL)

INSERT INTO ProviderSpecialty(ProviderSpecialtyCode,SpecialtyName, Description)
VALUES('207L00000X','Anesthesiology',NULL)

INSERT INTO ProviderSpecialty(ProviderSpecialtyCode,SpecialtyName, Description)
VALUES('208D00000X','General Practice',NULL)

INSERT INTO ProviderSpecialty(ProviderSpecialtyCode,SpecialtyName, Description)
VALUES('207VX0201X','Gynecologic Oncology',NULL)

INSERT INTO ProviderSpecialty(ProviderSpecialtyCode,SpecialtyName, Description)
VALUES('2084N0400X','Nuerology',NULL)

INSERT INTO ProviderSpecialty(ProviderSpecialtyCode,SpecialtyName, Description)
VALUES('207T00000X','Nuerosurgery',NULL)

INSERT INTO ProviderSpecialty(ProviderSpecialtyCode,SpecialtyName, Description)
VALUES('363L00000X','Nurse Practitioner',NULL)

INSERT INTO ProviderSpecialty(ProviderSpecialtyCode,SpecialtyName, Description)
VALUES('363A00000X','Physician Assistant',NULL)

INSERT INTO ProviderSpecialty(ProviderSpecialtyCode,SpecialtyName, Description)
VALUES('2084P0800X','Psychiatry',NULL)

INSERT INTO ProviderSpecialty(ProviderSpecialtyCode,SpecialtyName, Description)
VALUES('207RC0000X','Cardiology',NULL)

-- SELECT SpecialtyName, PracticeID, COUNT(DoctorID) Items
-- FROM Doctor D INNER JOIN ProviderSpecialty PS
-- ON D.ProviderSpecialtyCode=PS.ProviderSpecialtyCode
-- WHERE D.ProviderSpecialtyCode IN ('203BP0004X','203BP0009X','203BP0010X','203BP0400X')
-- GROUP BY SpecialtyName, PracticeID

-- UPDATE D SET ProviderSpecialtyCode='208100000X'
-- FROM Doctor D 
-- WHERE ProviderSpecialtyCode IN ('203BP0004X','203BP0009X','203BP0010X','203BP0400X')