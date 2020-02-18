-- Security_Server
USE superbill_shared
GO
SELECT
u.UserID,u.LastName,u.FirstName,u.WorkPhone,u.WorkPhoneExt,u.EmailAddress,lh.CustomerID,lh.LoginDate
FROM ArchiveSharedDB.dbo.LoginHistory lh WITH (NOLOCK)
INNER JOIN dbo.Users u ON u.EmailAddress = lh.UserEmailAddress
WHERE lh.CustomerID = 25898
ORDER BY lh.LoginDate desc

--Customer
SELECT * FROM sharedserver.superbill_shared.dbo.customer WHERE customerid=25898

--To Find the DoctorID
SELECT * FROM dbo.Doctor WHERE LastName ='LETIZIO'
SELECT * FROM dbo.PaymentType
--Billing Data
USE superbill_25898_dev
GO
SELECT DISTINCT --e.*,
p.FirstName,p.LastName,DateOfService,EncounterStatusID,e.PostingDate,pcd.ProcedureCode,OfficialName,CAST(ServiceChargeAmount*ServiceUnitCount AS MONEY) AS TotalCharges,
CASE pt.PayerTypeCode
WHEN 'P' THEN 'Patient'
WHEN 'I' THEN 'Insurance'
WHEN 'O' THEN 'Other'
ELSE ''
end
AS Type,
CAST(ca.Amount AS MONEY) AS Paid,pmc.DescriptionCode AS PaymentMethod,C.ClaimID
FROM patient p
INNER JOIN dbo.Encounter e ON e.PatientID = p.PatientID
INNER JOIN dbo.EncounterProcedure ep ON ep.EncounterID = e.EncounterID
JOIN dbo.ProcedureCodeDictionary pcd ON pcd.ProcedureCodeDictionaryID = ep.ProcedureCodeDictionaryID
INNER JOIN dbo.Claim c ON c.EncounterProcedureID = ep.EncounterProcedureID
LEFT  JOIN dbo.ClaimAccounting ca ON ca.ClaimID = c.ClaimID AND ca.ClaimTransactionTypeCode='Pay'
LEFT JOIN dbo.Payment pay ON ca.PaymentID=pay.paymentid
INNER JOIN dbo.PaymentMethodCode pmc ON pmc.PaymentMethodCode = e.PaymentMethod
INNER JOIN dbo.PaymentType pt ON pt.PayerTypecode = pay.PayerTypeCode
WHERE e.DoctorID = 2 AND
p.PatientGuid IN (

)
ORDER BY p.LastName,p.FirstName





—Billing/Encounter Data
USE superbill_36569_prod
GO

SELECT pp.LastName, pp.FirstName, e.EncounterId,c.EncounterProcedureID,
pcd.ProcedureCode,dd1.DiagnosisCode, dd2.DiagnosisCode,dd3.DiagnosisCode,dd4.DiagnosisCode, dcd1.DiagnosisCode, dcd2.DiagnosisCode,dcd3.DiagnosisCode, dcd4.DiagnosisCode, u.FirstName+' '+ U.LastName AS SubmittedBy,
B.PostingDate BilledDate,ep.ProcedureDateOfService,
CASE WHEN InsuranceCompanyPlanID IS NULL THEN 0 ELSE 1 END AS BlltoInsurance,SUM(Pay.amount) AS PaymentAmount
FROM dbo.Encounter e
INNER JOIN dbo.EncounterProcedure ep ON ep.EncounterID = e.EncounterID
INNER JOIN dbo.ProcedureCodeDictionary pcd ON pcd.ProcedureCodeDictionaryID = ep.ProcedureCodeDictionaryID
INNER JOIN SHAREDSERVER.superbill_shared.dbo.users u ON e.CreatedUserID=u.UserID
LEFT JOIN dbo.EncounterDiagnosis ed1 ON ep.EncounterDiagnosisID1=ed1.EncounterDiagnosisID
LEFT JOIN dbo.EncounterDiagnosis ed2 ON ep.EncounterDiagnosisID2=ed2.EncounterDiagnosisID
LEFT JOIN dbo.EncounterDiagnosis ed3 ON ep.EncounterDiagnosisID3=ed3.EncounterDiagnosisID
LEFT JOIN dbo.EncounterDiagnosis ed4 ON ep.EncounterDiagnosisID4=ed4.EncounterDiagnosisID
LEFT JOIN dbo.EncounterDiagnosis ed5 ON ep.EncounterDiagnosisID5=ed5.EncounterDiagnosisID
LEFT JOIN dbo.EncounterDiagnosis ed6 ON ep.EncounterDiagnosisID6=ed6.EncounterDiagnosisID
LEFT JOIN dbo.EncounterDiagnosis ed7 ON ep.EncounterDiagnosisID7=ed7.EncounterDiagnosisID
LEFT JOIN dbo.EncounterDiagnosis ed8 ON ep.EncounterDiagnosisID8=ed8.EncounterDiagnosisID
LEFT JOIN dbo.DiagnosisCodeDictionary dd1 ON ed1.DiagnosisCodeDictionaryID=dd1.DiagnosisCodeDictionaryID
LEFT JOIN dbo.DiagnosisCodeDictionary dd2 ON ed2.DiagnosisCodeDictionaryID=dd2.DiagnosisCodeDictionaryID
LEFT JOIN dbo.DiagnosisCodeDictionary dd3 ON ed3.DiagnosisCodeDictionaryID=dd3.DiagnosisCodeDictionaryID
LEFT JOIN dbo.DiagnosisCodeDictionary dd4 ON ed4.DiagnosisCodeDictionaryID=dd4.DiagnosisCodeDictionaryID
LEFT JOIN dbo.ICD10DiagnosisCodeDictionary dcd1 ON dcd1.ICD10DiagnosisCodeDictionaryId=ed5.DiagnosisCodeDictionaryID
LEFT JOIN dbo.ICD10DiagnosisCodeDictionary dcd2 ON dcd2.ICD10DiagnosisCodeDictionaryId=ed6.DiagnosisCodeDictionaryID
LEFT JOIN dbo.ICD10DiagnosisCodeDictionary dcd3 ON dcd3.ICD10DiagnosisCodeDictionaryId=ed7.DiagnosisCodeDictionaryID
LEFT JOIN dbo.ICD10DiagnosisCodeDictionary dcd4 ON dcd4.ICD10DiagnosisCodeDictionaryId=ed8.DiagnosisCodeDictionaryID
LEFT JOIN dbo.Claim c ON c.EncounterProcedureID = ep.EncounterProcedureID
LEFT JOIN dbo.ClaimAccounting Pay on pay.claimid=c.claimid AND ClaimTransactionTypeCode='Pay'
LEFT JOIN dbo.Payment p ON pay.PaymentID=p.paymentid
LEFT JOIN dbo.ClaimAccounting_Billings B ON B.ClaimID = c.ClaimID
LEFT JOIN dbo.ClaimAccounting_Assignments a ON a.ClaimID = B.ClaimID AND InsuranceCompanyPlanID IS NOT NULL
INNER JOIN dbo.Patient pp ON pp.PatientID = e.PatientID
INNER JOIN dbo._import_2_1_36569UrgentCare iu ON iu.lastname = pp.LastName AND iu.firstname = pp.FirstName
WHERE EncounterStatusID=3
GROUP BY pp.LastName, pp.FirstName,e.EncounterId,c.EncounterProcedureID,
pcd.ProcedureCode,dd1.DiagnosisCode, dd2.DiagnosisCode,dd3.DiagnosisCode,dd4.DiagnosisCode, dcd1.DiagnosisCode, dcd2.DiagnosisCode,dcd3.DiagnosisCode, dcd4.DiagnosisCode, u.FirstName+' '+ U.LastName ,
B.PostingDate,ep.ProcedureDateOfService,
CASE WHEN InsuranceCompanyPlanID IS NULL THEN 0 ELSE 1 END

—appointments
SELECT p.LastName, p.FirstName, a.CreatedDate, a.StartDate, a.EndDate
FROM dbo.Appointment a
	INNER JOIN dbo.Patient p ON
		p.PatientID = a.PatientID
	INNER JOIN dbo._import_2_1_36569UrgentCare iu ON
		iu.lastname = p.LastName AND iu.firstname = p.FirstName


—AuditLogs
USE KareoAudit
GO
SELECT * FROM dbo.AuditLog WHERE CustomerId = 7864 AND CreatedDate>'2012-01-01 00:53:59.683'ORDER BY CreatedDate D
