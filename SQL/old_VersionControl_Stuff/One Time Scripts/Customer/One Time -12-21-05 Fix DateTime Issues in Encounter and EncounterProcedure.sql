UPDATE Encounter SET DateOfServiceTo=DateOfServiceTo, PostingDate=PostingDate, HospitalizationStartDt=HospitalizationStartDt, 
HospitalizationEndDt=HospitalizationEndDt, SubmittedDate=SubmittedDate
WHERE CreatedDate>='12-21-05' OR ModifiedDate>='12-21-05'

UPDATE EncounterProcedure SET ServiceEndDate=ServiceEndDate
FROM EncounterProcedure
WHERE CreatedDate>='12-1-05' AND ServiceEndDate IS NOT NULL
