DELETE superbill_shared..BusinessRule

insert into superbill_shared..BusinessRule
SELECT BusinessRuleID, PracticeID, BusinessRuleProcessingTypeID, Name, BusinessRuleXML, SortOrder, ContinueProcessing,
CreatedDate, CreatedUserID, ModifiedDate, ModifiedUserID, DefaultRule
FROM BusinessRule
WHERE Name='Default Print Billing Form'

insert into superbill_shared..BusinessRule
SELECT BusinessRuleID, 1, BusinessRuleProcessingTypeID, Name, BusinessRuleXML, SortOrder, ContinueProcessing,
CreatedDate, CreatedUserID, ModifiedDate, ModifiedUserID, DefaultRule
FROM BusinessRule
WHERE Name<>'Default Print Billing Form'

insert into superbill_shared..BusinessRule
SELECT BusinessRuleID, 2, BusinessRuleProcessingTypeID, Name, BusinessRuleXML, SortOrder, ContinueProcessing,
CreatedDate, CreatedUserID, ModifiedDate, ModifiedUserID, DefaultRule
FROM BusinessRule
WHERE Name<>'Default Print Billing Form'

insert into superbill_shared..BusinessRule
SELECT BusinessRuleID, 3, BusinessRuleProcessingTypeID, Name, BusinessRuleXML, SortOrder, ContinueProcessing,
CreatedDate, CreatedUserID, ModifiedDate, ModifiedUserID, DefaultRule
FROM BusinessRule
WHERE Name<>'Default Print Billing Form'

insert into superbill_shared..BusinessRule
SELECT BusinessRuleID, 4, BusinessRuleProcessingTypeID, Name, BusinessRuleXML, SortOrder, ContinueProcessing,
CreatedDate, CreatedUserID, ModifiedDate, ModifiedUserID, DefaultRule
FROM BusinessRule
WHERE Name<>'Default Print Billing Form'