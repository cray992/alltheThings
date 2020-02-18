-- CommonTruncations


-- ZIP
LEFT(CASE
WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) IN (5,9)
THEN dbo.fn_RemoveNonNumericCharacters(i.zip)
WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) = 4
THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.zip)
ELSE '' END,9) , -- ZipCode - varchar(9)


-- PHONE
CASE
WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.phone)) >= 10
THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.phone),10)
ELSE '' END , -- HomePhone - varchar(10)


-- SSN
CASE
WHEN LEN(dbo.fn_RemoveNonNumericCharacters(P.ssn)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(P.SSN), 9)
ELSE NULL END , -- SSN - char(9)


-- Policy Start and End Dates
CASE WHEN ISDATE(ip.Policy2StartDate) = 1 THEN ip.policy2startdate ELSE NULL END ,
CASE WHEN ISDATE(ip.Policy2EndDate) = 1 THEN ip.policy2enddate ELSE NULL END ,
