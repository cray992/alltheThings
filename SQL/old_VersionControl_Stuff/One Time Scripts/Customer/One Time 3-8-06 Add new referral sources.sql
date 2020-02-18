--CASE 9459 Add two new referral sources to all customer databases

IF NOT EXISTS(SELECT * FROM PatientReferralSource WHERE PatientReferralSourceCaption='Chiropractor')
BEGIN
	INSERT INTO PatientReferralSource(PatientReferralSourceCaption)
	VALUES('Chiropractor')
END


IF NOT EXISTS(SELECT * FROM PatientReferralSource WHERE PatientReferralSourceCaption='Physical Therapist')
BEGIN
	INSERT INTO PatientReferralSource(PatientReferralSourceCaption)
	VALUES('Physical Therapist')
END
