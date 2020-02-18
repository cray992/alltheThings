--BEGIN TRAN

DECLARE @VendorImportID INT
SET @VendorImportID=48

DELETE PaymentClaimTransaction
WHERE PracticeID IN (113,114,115,116)

DELETE ClaimTransaction
WHERE PracticeID IN (113,114,115,116)

DELETE BC
FROM BillBatch BB INNER JOIN Bill_EDI BE
ON BB.BillBatchID=BE.BillBatchID
INNER JOIN BillClaim BC
ON BE.BillID=BC.BillID AND BC.BillBatchTypeCode='E'
WHERE BB.PracticeID IN (113,114,115,116)

DELETE BC
FROM BillBatch BB INNER JOIN Bill_Statement BS
ON BB.BillBatchID=BS.BillBatchID
INNER JOIN BillClaim BC
ON BS.BillID=BC.BillID AND BC.BillBatchTypeCode='S'
WHERE BB.PracticeID IN (113,114,115,116)

DELETE BE
FROM BillBatch BB INNER JOIN Bill_EDI BE
ON BB.BillBatchID=BE.BillBatchID
WHERE BB.PracticeID IN (113,114,115,116)

DELETE BS
FROM BillBatch BB INNER JOIN Bill_Statement BS
ON BB.BillBatchID=BS.BillBatchID
WHERE BB.PracticeID IN (113,114,115,116)

DELETE BillBatch
WHERE PracticeID IN (113,114,115,116)

DELETE Claim
WHERE PracticeID IN (113,114,115,116)

DELETE EncounterProcedure
WHERE PracticeID IN (113,114,115,116)

DELETE EncounterDiagnosis
WHERE PracticeID IN (113,114,115,116)

DELETE UnappliedPayments
WHERE PracticeID IN (113,114,115,116)

DELETE RTP
FROM Refund R INNER JOIN RefundToPayments RTP
ON R.RefundID=RTP.RefundID
WHERE PracticeID IN (113,114,115,116)

DELETE Refund
WHERE PracticeID IN (113,114,115,116)

DELETE PP
FROM Payment P INNER JOIN PaymentPatient PP
ON P.PaymentID=PP.PaymentID
WHERE P.PracticeID IN (113,114,115,116)

DELETE CATP
FROM Payment P INNER JOIN CapitatedAccountToPayment CATP
ON P.PaymentID=CATP.PaymentID
WHERE P.PracticeID IN (113,114,115,116)

DELETE Payment
WHERE PracticeID IN (113,114,115,116)

DELETE AC
FROM AmbulanceCertificationInformation AC INNER JOIN Encounter E
ON AC.EncounterID=E.EncounterID
WHERE PracticeID IN (113,114,115,116)

DELETE Encounter
WHERE PracticeID IN (113,114,115,116)

DELETE AppointmentToResource
WHERE PracticeID IN (113,114,115,116)

DELETE AppointmentToAppointmentReason
WHERE PracticeID IN (113,114,115,116)

DELETE AR
FROM Appointment A INNER JOIN AppointmentRecurrence AR
ON A.AppointmentID=AR.AppointmentID
WHERE A.PracticeID IN (113,114,115,116)

DELETE ARE
FROM Appointment A INNER JOIN AppointmentRecurrenceException ARE
ON A.AppointmentID=ARE.AppointmentID
WHERE A.PracticeID IN (113,114,115,116)

DELETE Appointment
WHERE PracticeID IN (113,114,115,116)

DELETE IPA
FROM InsurancePolicy IP INNER JOIN InsurancePolicyAuthorization IPA
ON IP.InsurancePolicyID=IPA.InsurancePolicyID
WHERE IP.PracticeID IN (113,114,115,116)

DELETE InsurancePolicy
WHERE PracticeID IN (113,114,115,116)

DELETE PCD
FROM PatientCase PC INNER JOIN PatientCaseDate PCD
ON PC.PatientCaseID=PCD.PatientCaseID
WHERE PC.PracticeID IN (113,114,115,116)

DELETE PatientCase
WHERE  PracticeID IN (113,114,115,116)

DELETE PJN
FROM Patient P INNER JOIN PatientJournalNote PJN
ON P.PatientID=PJN.PatientID
WHERE P.PracticeID IN (113,114,115,116)

DELETE PA
FROM Patient P INNER JOIN PatientAlert PA
ON P.PatientID=PA.PatientID
WHERE P.PracticeID IN (113,114,115,116)

DELETE Patient
WHERE  PracticeID IN (113,114,115,116)

DELETE CTIP
FROM Contract C INNER JOIN ContractToInsurancePlan CTIP
ON C.ContractID=CTIP.ContractID
WHERE PracticeID IN (113,114,115,116)

DELETE CTSL
FROM Contract C INNER JOIN ContractToServiceLocation CTSL
ON C.ContractID=CTSL.ContractID
WHERE PracticeID IN (113,114,115,116)

DELETE CF
FROM Contract C INNER JOIN ContractFeeSchedule CF
ON C.ContractID=CF.ContractID
WHERE PracticeID IN (113,114,115,116)

DELETE CD
FROM Contract C INNER JOIN ContractToDoctor CD
ON C.ContractID=CD.ContractID
WHERE PracticeID IN (113,114,115,116)

DELETE Contract
WHERE PracticeID IN (113,114,115,116)

DELETE InsuranceCompanyPlan
WHERE VendorImportID=@VendorImportID AND InsuranceCompanyPlanID NOT IN (SELECT DISTINCT ICP.InsuranceCompanyPlanID
FROM InsuranceCompanyPlan ICP INNER JOIN InsurancePolicy IP
ON ICP.InsuranceCompanyPlanID=IP.InsuranceCompanyPlanID
WHERE ICP.VendorImportID=@VendorImportID AND IP.PracticeID NOT IN (113,114,115,116))
AND InsuranceCompanyPlanID NOT IN (
select distinct icp.Insurancecompanyplanid
from providernumber pn inner join insurancecompanyplan icp
on pn.insurancecompanyplanid=icp.insurancecompanyplanid
inner join doctor d
on pn.doctorid=d.doctorid
where icp.vendorimportid=@VendorImportID and practiceid NOT IN (113,114,115,116))

DELETE IC
FROM InsuranceCompany IC LEFT JOIN InsuranceCompanyPlan ICP
ON IC.InsuranceCompanyID=ICP.InsuranceCompanyID
WHERE IC.VendorImportID=@VendorImportID AND ICP.InsuranceCompanyID IS NULL

--New Removal Portion

DELETE ARDR
FROM AppointmentReasonDefaultResource ARDR INNER JOIN AppointmentReason AR
ON ARDR.AppointmentReasonID=AR.AppointmentReasonID
WHERE AR.PracticeID IN (114,116)

DELETE AppointmentReason
WHERE PracticeID IN (114,116)

DELETE TRE
FROM TimeBlock TB INNER JOIN TimeblockRecurrenceException TRE
ON TB.TimeblockID=TRE.TimeblockID
WHERE TB.PracticeID IN (114,116)

DELETE TR
FROM TimeBlock TB INNER JOIN TimeblockRecurrence TR
ON TB.TimeblockID=TR.TimeblockID
WHERE TB.PracticeID IN (114,116)

DELETE TimeBlock
WHERE PracticeID IN (114,116)

DELETE PN
FROM ProviderNumber PN INNER JOIN Doctor D
ON PN.DoctorID=D.DoctorID
WHERE D.PracticeID IN (114,116)

--DELETE PN
--FROM ProviderNumber PN INNER JOIN Doctor D
--ON PN.DoctorID=D.DoctorID
--WHERE PracticeID IN (113,115) AND VendorImportID IS NOT NULL AND [External]=1

DELETE Doctor
WHERE PracticeID IN (114,116)

--Referring Physicians
--DELETE Doctor
--WHERE PracticeID IN (113,115) AND VendorImportID IS NOT NULL AND [External]=1

DELETE Department
WHERE PracticeID IN (114,116)

DELETE PracticeResource
WHERE PracticeID IN (114,116)

DELETE ServiceLocation
WHERE PracticeID IN (114,116)

DELETE PCTPCD
FROM EncounterTemplate ET INNER JOIN ProcedureCategory PC
ON ET.EncounterTemplateID=PC.EncounterTemplateID
INNER JOIN ProcedureCategoryToProcedureCodeDictionary PCTPCD
ON PC.ProcedureCategoryID=PCTPCD.ProcedureCategoryID
WHERE ET.PracticeID IN (114,116)

DELETE PC
FROM EncounterTemplate ET INNER JOIN ProcedureCategory PC
ON ET.EncounterTemplateID=PC.EncounterTemplateID
WHERE ET.PracticeID IN (114,116)

DELETE DCTDCD
FROM EncounterTemplate ET INNER JOIN DiagnosisCategory DC
ON ET.EncounterTemplateID=DC.EncounterTemplateID
INNER JOIN DiagnosisCategoryToDiagnosisCodeDictionary DCTDCD
ON DC.DiagnosisCategoryID=DCTDCD.DiagnosisCategoryID
WHERE ET.PracticeID IN (114,116)

DELETE DC
FROM EncounterTemplate ET INNER JOIN DiagnosisCategory DC
ON ET.EncounterTemplateID=DC.EncounterTemplateID
WHERE ET.PracticeID IN (114,116)

DELETE EncounterTemplate 
WHERE PracticeID IN (114,116)

--ROLLBACK TRAN
--COMMIT TRAN



