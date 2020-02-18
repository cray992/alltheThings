--USE superbill_14589_dev
USE superbill_14589_prod
GO



UPDATE dbo.Patient
SET DOB = (SELECT DATEADD(dd, CAST(alttype AS INT), '1849-12-31 10:00:00.000') FROM dbo.[_import_13_1_DateofBirth] WHERE altseq = pat.VendorID)
FROM dbo.Patient pat 
WHERE pat.PracticeID = 1


UPDATE dbo.Patient
SET DOB = (SELECT DATEADD(dd, CAST(alttype AS INT), '1849-12-31 10:00:00.000') FROM dbo.[_import_14_2_DateofBirth] WHERE altseq = pat.VendorID)
FROM dbo.Patient pat 
WHERE pat.PracticeID = 2


UPDATE dbo.Patient
SET DOB = (SELECT DATEADD(dd, CAST(alttype AS INT), '1849-12-31 10:00:00.000') FROM dbo.[_import_15_3_DateofBirth] WHERE altseq = pat.VendorID)
FROM dbo.Patient pat 
WHERE pat.PracticeID = 3


UPDATE dbo.Patient
SET DOB = (SELECT DATEADD(dd, CAST(alttype AS INT), '1849-12-31 10:00:00.000') FROM dbo.[_import_16_4_DateofBirth] WHERE altseq = pat.VendorID)
FROM dbo.Patient pat 
WHERE pat.PracticeID = 4


UPDATE dbo.Patient
SET DOB = (SELECT DATEADD(dd, CAST(alttype AS INT), '1849-12-31 10:00:00.000') FROM dbo.[_import_17_5_DateofBirth] WHERE altseq = pat.VendorID)
FROM dbo.Patient pat 
WHERE pat.PracticeID = 5


UPDATE dbo.Patient
SET DOB = (SELECT DATEADD(dd, CAST(alttype AS INT), '1849-12-31 10:00:00.000') FROM dbo.[_import_18_6_DateofBirth] WHERE altseq = pat.VendorID)
FROM dbo.Patient pat 
WHERE pat.PracticeID = 6


UPDATE dbo.Patient
SET DOB = (SELECT DATEADD(dd, CAST(alttype AS INT), '1849-12-31 10:00:00.000') FROM dbo.[_import_19_7_DateofBirth] WHERE altseq = pat.VendorID)
FROM dbo.Patient pat 
WHERE pat.PracticeID = 7


UPDATE dbo.Patient
SET DOB = (SELECT DATEADD(dd, CAST(alttype AS INT), '1849-12-31 10:00:00.000') FROM dbo.[_import_20_8_DateofBirth] WHERE altseq = pat.VendorID AND alttype > 0)
FROM dbo.Patient pat 
WHERE pat.PracticeID = 8


UPDATE dbo.Patient
SET DOB = (SELECT DATEADD(dd, CAST(alttype AS INT), '1849-12-31 10:00:00.000') FROM dbo.[_import_21_9_DateofBirth] WHERE altseq = pat.VendorID)
FROM dbo.Patient pat 
WHERE pat.PracticeID = 9


UPDATE dbo.Patient
SET DOB = (SELECT DATEADD(dd, CAST(alttype AS INT), '1849-12-31 10:00:00.000') FROM dbo.[_import_22_10_DateofBirth] WHERE altseq = pat.VendorID)
FROM dbo.Patient pat 
WHERE pat.PracticeID = 10


UPDATE dbo.Patient
SET DOB = (SELECT DATEADD(dd, CAST(alttype AS INT), '1849-12-31 10:00:00.000') FROM dbo.[_import_23_11_DateofBirth] WHERE altseq = pat.VendorID)
FROM dbo.Patient pat 
WHERE pat.PracticeID = 11


UPDATE dbo.Patient
SET DOB = (SELECT DATEADD(dd, CAST(alttype AS INT), '1849-12-31 10:00:00.000') FROM dbo.[_import_24_12_DateofBirth] WHERE altseq = pat.VendorID)
FROM dbo.Patient pat 
WHERE pat.PracticeID = 12



