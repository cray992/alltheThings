--===========================================================================
-- POP: ENCOUNTER
--===========================================================================

UPDATE	Encounter
SET	DoctorSignature = '0'
WHERE	DoctorSignature IS NULL

--===========================================================================
-- MOD: ENCOUNTER
--===========================================================================

ALTER TABLE dbo.Encounter
ADD CONSTRAINT DF_Encounter_DoctorSignature
DEFAULT ('0') FOR DoctorSignature

ALTER TABLE dbo.Encounter
ALTER COLUMN DoctorSignature VARCHAR(50) NOT NULL

