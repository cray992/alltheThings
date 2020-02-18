--list of emails that shouldn't be emailed 
DECLARE @excludeEmails TABLE (EmailAddress varchar(256))
INSERT INTO @excludeEmails VALUES ('heather@heather.com')
INSERT INTO @excludeEmails VALUES ('s@s.com')
INSERT INTO @excludeEmails VALUES ('jaustin@wintellect.com')
INSERT INTO @excludeEmails VALUES ('abc@yahoo.com')
INSERT INTO @excludeEmails VALUES ('%@family.guy')
INSERT INTO @excludeEmails VALUES ('test@pmr')
INSERT INTO @excludeEmails VALUES ('rorton@sample1.com')
INSERT INTO @excludeEmails VALUES ('%@adren.com')
INSERT INTO @excludeEmails VALUES ('%@ama.com')
INSERT INTO @excludeEmails VALUES ('%@brokebackmountain.com')
INSERT INTO @excludeEmails VALUES ('no@L.com')
INSERT INTO @excludeEmails VALUES ('%@griffin.%')
INSERT INTO @excludeEmails VALUES ('%@quahog.org')
INSERT INTO @excludeEmails VALUES ('m@nuel.com')
INSERT INTO @excludeEmails VALUES ('trialtest0@kareo.com')
INSERT INTO @excludeEmails VALUES ('c@ca.com')
INSERT INTO @excludeEmails VALUES ('3_')
INSERT INTO @excludeEmails VALUES ('5_')
INSERT INTO @excludeEmails VALUES ('%@kareo.com')
INSERT INTO @excludeEmails VALUES ('%@ilya.us')
INSERT INTO @excludeEmails VALUES ('%@test.com')
INSERT INTO @excludeEmails VALUES ('%@test1122.com')
INSERT INTO @excludeEmails VALUES ('x@x.com')
INSERT INTO @excludeEmails VALUES ('%@jj.com')
INSERT INTO @excludeEmails VALUES ('jane@office.com')
INSERT INTO @excludeEmails VALUES ('admin@mfa.com')
INSERT INTO @excludeEmails VALUES ('A@A')
INSERT INTO @excludeEmails VALUES ('ab@aol.com')
INSERT INTO @excludeEmails VALUES ('shawn@microsoft.com')
INSERT INTO @excludeEmails VALUES ('Shaun@yahoo.com')
INSERT INTO @excludeEmails VALUES ('shaun@test0.net')
INSERT INTO @excludeEmails VALUES ('%@gofarm.la')
INSERT INTO @excludeEmails VALUES ('%@jason.com')
INSERT INTO @excludeEmails VALUES ('%@jasonmcdonald.com')
INSERT INTO @excludeEmails VALUES ('%@kareo.ent')
INSERT INTO @excludeEmails VALUES ('%@kareotesting.info')
INSERT INTO @excludeEmails VALUES ('%@noeltest.info')


SELECT
	ContactEmail, 
	ContactFirstName, 
	ContactLastName, 
	CompanyName,
	'Normal'
FROM
	Customer C
	LEFT OUTER JOIN @excludeEmails EE ON C.ContactEmail LIKE EE.EmailAddress
WHERE 
	CustomerType='N'
	AND dbactive=1 
	AND accountlocked = 0
	AND EE.EmailAddress IS NULL
