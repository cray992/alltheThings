/*-----------------------------------------------------------------------------
Salesforce case #00069211 - Add 5 "custom" referral source options to patient 
record  
-----------------------------------------------------------------------------*/

UPDATE [dbo].[PatientReferralSource] SET 
	PatientReferralSourceCaption = 'Other Source #1' 
WHERE PatientReferralSourceCaption = 'Other'

INSERT INTO [dbo].[PatientReferralSource]
	([PatientReferralSourceCaption])
VALUES
	('Other Source #2')

INSERT INTO [dbo].[PatientReferralSource]
	([PatientReferralSourceCaption])
VALUES
	('Other Source #3')

INSERT INTO [dbo].[PatientReferralSource]
	([PatientReferralSourceCaption])
VALUES
	('Other Source #4')

INSERT INTO [dbo].[PatientReferralSource]
	([PatientReferralSourceCaption])
VALUES
	('Other Source #5')

GO