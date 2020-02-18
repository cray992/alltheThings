
alter table PatientReferralSource add PracticeID int 
GO
alter table PatientReferralSource add [Description] varchar(128)
GO

update PatientReferralSource set PracticeID=0

-- replicate current list of referral sources to all practices
insert into PatientReferralSource (PatientReferralSourceCaption, [DEscription], PracticeID) 
select PatientReferralSourceCaption, PatientReferralSourceCaption, P.PracticeID
from PatientReferralSource, Practice P

-- migrate patients 
update Patient
	set PatientReferralSourceID=(select PatientReferralSourceID from PatientReferralSource 
								where PracticeID=Patient.PracticeID and PatientReferralSourceCaption=(select PatientReferralSourceCaption from PatientReferralSource where PatientReferralSourceID=Patient.PatientReferralSourceID))

-- delete
delete PAtientReferralSource where PracticeID=0


-- set referential integrity
alter table PatientReferralSource add constraint FK_PatientReferralSourcePractice foreign key (PracticeID) references Practice (PracticeID)
GO
