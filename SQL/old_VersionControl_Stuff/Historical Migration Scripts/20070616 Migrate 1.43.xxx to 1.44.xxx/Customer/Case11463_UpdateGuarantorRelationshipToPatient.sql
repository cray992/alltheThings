/* ============================================================================
Case 11463: Edit Patient window allows different guarantor name when 
relationship is self. 
============================================================================ */
update Patient
set ResponsibleRelationshipToPatient = 'O'
where ResponsibleDifferentThanPatient = 1
and ResponsibleRelationshipToPatient = 'S'

go