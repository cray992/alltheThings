USE superbill_9701_prod
GO
SELECT p.practiceid,p.name,p.EIN,p.AddressLine1,p.AddressLine2,p.City,p.State,p.ZipCode
,p.Phone,p.PhoneExt,p.Fax,p.FaxExt,p.BillingAddressLine1,p.BillingAddressLine2
,p.BillingCity,p.BillingState,p.BillingZipCode
FROM practice p

SELECT d.DoctorID,d.PracticeID,p.Name AS 'PracticeName',d.FirstName,d.LastName,
CASE d.ProviderTypeID
WHEN 1 THEN 'Physician Provider'
WHEN 2 THEN 'Non-Physician Provider'
WHEN 3 THEN 'Part-Time Provider'
WHEN 4 THEN 'Free Promotion'
WHEN 5 THEN 'Bundled Provider'
WHEN 6 THEN 'Chiropractor'
WHEN 7 THEN 'Therapist'
WHEN 8 THEN 'Low-Volume Physician'
WHEN 9 THEN 'Low-Volume Non-Physician'
ELSE''
END AS 'ProviderType'
,d.AddressLine1,d.AddressLine2
,d.City,d.State,d.ZipCode,d.HomePhone,d.HomePhoneExt,d.WorkPhone,d.WorkPhoneExt,d.PagerPhone
,d.PagerPhoneExt,d.MobilePhone,d.DOB,d.EmailAddress
FROM dbo.Doctor d 
INNER JOIN dbo.Practice p ON p.PracticeID=d.PracticeID
WHERE ActiveDoctor=1

SELECT sl.ServiceLocationID,sl.PracticeID,p.Name AS 'PracticeName',sl.AddressLine1,sl.AddressLine2,sl.City,sl.State
,sl.ZipCode,sl.BillingName,sl.Phone,sl.PhoneExt,sl.FaxPhone,sl.FaxPhoneExt
FROM dbo.ServiceLocation sl
INNER JOIN dbo.Practice p ON p.PracticeID=sl.PracticeID

