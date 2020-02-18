UPDATE Doctor SET ProviderSpecialtyCode='207R0000X'
WHERE ProviderSpecialtyCode='203BI0300X'

UPDATE Doctor SET ProviderSpecialtyCode='208100000X'
WHERE ProviderSpecialtyCode='203BP0400X'

UPDATE Doctor SET ProviderSpecialtyCode='2081P0010X'
WHERE ProviderSpecialtyCode='203BP0010X'

UPDATE Doctor SET ProviderSpecialtyCode='2081P2900X'
WHERE ProviderSpecialtyCode='203BP0009X'

UPDATE Doctor SET ProviderSpecialtyCode='2081P0004X'
WHERE ProviderSpecialtyCode='203BP0004X'

DELETE ProviderSpecialty
WHERE ProviderSpecialtyCode IN ('203BI0300X','203BP0400X','203BP0010X','203BP0009X','203BP0004X')