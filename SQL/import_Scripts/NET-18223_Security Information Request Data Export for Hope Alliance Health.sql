USE superbill_shared
GO 

--Login Audit
SELECT 
u.UserID,u.LastName,u.FirstName,u.WorkPhone,u.WorkPhoneExt,u.EmailAddress,lh.CustomerID,lh.LoginDate
FROM ArchiveSharedDB.dbo.LoginHistory lh WITH (NOLOCK) 
INNER JOIN dbo.Users u ON u.EmailAddress = lh.UserEmailAddress
WHERE lh.CustomerID = 21998
ORDER BY lh.LoginDate desc


--Customer
SELECT * FROM sharedserver.superbill_shared.dbo.customer WHERE customerid=25898


--To Find the DoctorID
SELECT * FROM dbo.Doctor WHERE LastName ='LETIZIO'
SELECT * FROM dbo.PaymentType


--Billing Data
USE superbill_21998_prod
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

ORDER BY p.LastName,p.FirstName


SELECT * FROM dbo.ClearinghouseResponse WHERE ResponseType IN (31,33)

--SELECT *
--FROM SHAREDSERVER.superbill_shared.dbo.customer WHERE customerid=20449

--SELECT *
--FROM SHAREDSERVER.superbill_shared.dbo.users
--WHERE userid=127061