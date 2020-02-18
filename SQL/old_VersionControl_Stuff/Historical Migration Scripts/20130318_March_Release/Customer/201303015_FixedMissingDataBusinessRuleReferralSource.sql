IF NOT EXISTS(SELECT * FROM Practice WITH (NOLOCK))
Begin
RETURN
END


DECLARE @PracticeID INT , @CreateUserID INT
SET @PracticeID=(

SELECT MIN(PracticeID)
FROM Practice AS p)


SET @CreateUserID=(SELECT CreatedUserID FROM Practice WHERE PracticeId=@PracticeID)

IF NOT EXISTS(SELECT *
FROM BusinessRule AS br
WHERE br.PracticeID=@PracticeID)


BEGIN 
-- Insert a default business rule for encounter form printing
INSERT BusinessRule(PracticeID, BusinessRuleProcessingTypeID, Name, SortOrder, ContinueProcessing, BusinessRuleXML, DefaultRule)
VALUES (@PracticeID, 2, 'Encounter Form Default', 1, 0, '<?xml version="1.0" encoding="utf-8"?><businessRule name="Encounter Form Default"><conditions/><actions><action storedProcedure="BusinessRuleEngine_ActionPrintDocuments"><parameter><recipient value="1" valueName="Practice"/></parameter><document value="9" valueName="Encounter Form"/></action></actions></businessRule>', 1)

-- Insert a default business rule for claim bill printing
INSERT BusinessRule( PracticeID,
BusinessRuleProcessingTypeID,
Name,
SortOrder,
ContinueProcessing, 
BusinessRuleXML,
DefaultRule
)
VALUES (@PracticeID, 1,'Default Print Billing Form',10000,0, '<?xml version="1.0" encoding="utf-8"?><businessRule name="Default Print Billing Form"><conditions><condition field="AssignedInsurance" fieldName="Assigned Insurance" predicateName="Exists" /></conditions><actions><action storedProcedure="BusinessRuleEngine_ActionPrintDocuments">                                    <parameter><recipient value="2" valueName="Assigned Insurance" /></parameter><document value="99999" type="" valueName="General Billing Form" /></action></actions></businessRule>',1)
END


IF NOT EXISTS(SELECT * FROM PatientReferralSource AS prs WHERE PracticeID=@PracticeID)
BEGIN 
-- create default referral source codes
insert into PatientReferralSource(PatientReferralSourceCaption, [Description], PracticeID) values ('Attorney','Attorney', @practiceID)
insert into PatientReferralSource(PatientReferralSourceCaption, [Description], PracticeID) values ('Brochure','Brochure', @practiceID)
insert into PatientReferralSource(PatientReferralSourceCaption, [Description], PracticeID) values ('Case Manager','Case Manager', @practiceID)
insert into PatientReferralSource(PatientReferralSourceCaption, [Description], PracticeID) values ('Friend / Family','Friend / Family', @practiceID)
insert into PatientReferralSource(PatientReferralSourceCaption, [Description], PracticeID) values ('Insurance','Insurance', @practiceID)
insert into PatientReferralSource(PatientReferralSourceCaption, [Description], PracticeID) values ('Nurse','Nurse', @practiceID)
insert into PatientReferralSource(PatientReferralSourceCaption, [Description], PracticeID) values ('Patient Seminar','Patient Seminar', @practiceID)
insert into PatientReferralSource(PatientReferralSourceCaption, [Description], PracticeID) values ('Previous Patient','Previous Patient', @practiceID)
insert into PatientReferralSource(PatientReferralSourceCaption, [Description], PracticeID) values ('Print Ad','Print Ad', @practiceID)
insert into PatientReferralSource(PatientReferralSourceCaption, [Description], PracticeID) values ('Online Ad','Online Ad', @practiceID)
insert into PatientReferralSource(PatientReferralSourceCaption, [Description], PracticeID) values ('Radio Ad','Radio Ad', @practiceID)
insert into PatientReferralSource(PatientReferralSourceCaption, [Description], PracticeID) values ('Physician','Physician', @practiceID)
insert into PatientReferralSource(PatientReferralSourceCaption, [Description], PracticeID) values ('Search Engine','Search Engine', @practiceID)
insert into PatientReferralSource(PatientReferralSourceCaption, [Description], PracticeID) values ('Website','Website', @practiceID)
insert into PatientReferralSource(PatientReferralSourceCaption, [Description], PracticeID) values ('Workers Comp','Workers Comp', @practiceID)
insert into PatientReferralSource(PatientReferralSourceCaption, [Description], PracticeID) values ('Yellow Pages','Yellow Pages', @practiceID)
insert into PatientReferralSource(PatientReferralSourceCaption, [Description], PracticeID) values ('Other Source #1','Other Source #1', @practiceID)
insert into PatientReferralSource(PatientReferralSourceCaption, [Description], PracticeID) values ('Chiropractor','Chiropractor', @practiceID)
insert into PatientReferralSource(PatientReferralSourceCaption, [Description], PracticeID) values ('Physical Therapist','Physical Therapist', @practiceID)
insert into PatientReferralSource(PatientReferralSourceCaption, [Description], PracticeID) values ('Emergency Room','Emergency Room', @practiceID)
insert into PatientReferralSource(PatientReferralSourceCaption, [Description], PracticeID) values ('Other Source #2','Other Source #2', @practiceID)
insert into PatientReferralSource(PatientReferralSourceCaption, [Description], PracticeID) values ('Other Source #3','Other Source #3', @practiceID)
insert into PatientReferralSource(PatientReferralSourceCaption, [Description], PracticeID) values ('Other Source #4','Other Source #4', @practiceID)
insert into PatientReferralSource(PatientReferralSourceCaption, [Description], PracticeID) values ('Other Source #5','Other Source #5', @practiceID)
insert into PatientReferralSource(PatientReferralSourceCaption, [Description], PracticeID) values ('Physician''s Assistant','Physician''s Assistant', @practiceID)
END

IF NOT EXISTS(SELECT * FROM UserPractices AS up WHERE up.PracticeID=@PracticeID AND up.UserID=@CreateUserID)

BEGIN 

INSERT INTO [UserPractices] ([UserID],[PracticeID],[CreatedUserID],[ModifiedUserID])
VALUES (@CreateUserID, @PracticeID, @CreateUserID, @CreateUserID)
END

