UPDATE P
SET DOB= CAST(dob.dob AS DATETIME)
FROM SHAREDSERVER.superbill_shared.dbo.PatientDOB5 dob WITH (NOLOCK)
INNER JOIN SharedServer.superbill_shared.dbo.Customer AS c WITH (NOLOCK) ON dob.CustomerID=C.CustomerID
INNER JOIN Patient P ON dob.PatientID=p.patientID AND c.DatabaseName=db_name()
WHERE  CAST(dob.dob AS DATETIME)<> p.dob AND p.dob='1900-01-01 12:00:00.000'