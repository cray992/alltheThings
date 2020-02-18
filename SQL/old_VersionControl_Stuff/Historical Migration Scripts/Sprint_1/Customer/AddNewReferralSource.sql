declare @title varchar(100)
set @title='Physician''s Assistant'

if not exists (select * from PatientReferralSource where PatientReferralSourceCaption=@title)
	insert into PatientReferralSource (PatientReferralSourceCaption) values (@title)

