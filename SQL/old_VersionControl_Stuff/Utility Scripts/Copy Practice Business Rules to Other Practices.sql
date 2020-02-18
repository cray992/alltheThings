DELETE BusinessRule
WHERE Name<>'Default Print Billing Form' AND BusinessRuleProcessingTypeID<>2 AND PracticeID<>4

INSERT INTO BusinessRule (PracticeID, BusinessRuleProcessingTypeID, Name, BusinessRuleXML, SortOrder, ContinueProcessing,
CreatedDate, CreatedUserID, ModifiedDate, ModifiedUserID, DefaultRule)
SELECT 1, BusinessRuleProcessingTypeID, Name, BusinessRuleXML, SortOrder, ContinueProcessing,
CreatedDate, CreatedUserID, ModifiedDate, ModifiedUserID, DefaultRule
FROM BusinessRule
WHERE Name<>'Default Print Billing Form' AND BusinessRuleProcessingTypeID<>2 AND PracticeID=4

INSERT INTO BusinessRule (PracticeID, BusinessRuleProcessingTypeID, Name, BusinessRuleXML, SortOrder, ContinueProcessing,
CreatedDate, CreatedUserID, ModifiedDate, ModifiedUserID, DefaultRule)
SELECT 2, BusinessRuleProcessingTypeID, Name, BusinessRuleXML, SortOrder, ContinueProcessing,
CreatedDate, CreatedUserID, ModifiedDate, ModifiedUserID, DefaultRule
FROM BusinessRule
WHERE Name<>'Default Print Billing Form' AND BusinessRuleProcessingTypeID<>2 AND PracticeID=4

INSERT INTO BusinessRule (PracticeID, BusinessRuleProcessingTypeID, Name, BusinessRuleXML, SortOrder, ContinueProcessing,
CreatedDate, CreatedUserID, ModifiedDate, ModifiedUserID, DefaultRule)
SELECT 3, BusinessRuleProcessingTypeID, Name, BusinessRuleXML, SortOrder, ContinueProcessing,
CreatedDate, CreatedUserID, ModifiedDate, ModifiedUserID, DefaultRule
FROM BusinessRule
WHERE Name<>'Default Print Billing Form' AND BusinessRuleProcessingTypeID<>2 AND PracticeID=4

DELETE superbill_0109_prod..BusinessRule
WHERE Name<>'Default Print Billing Form' AND BusinessRuleProcessingTypeID<>2

INSERT INTO superbill_0109_prod..BusinessRule (PracticeID, BusinessRuleProcessingTypeID, Name, BusinessRuleXML, SortOrder, ContinueProcessing,
CreatedDate, CreatedUserID, ModifiedDate, ModifiedUserID, DefaultRule)
SELECT 1, BusinessRuleProcessingTypeID, Name, BusinessRuleXML, SortOrder, ContinueProcessing,
CreatedDate, CreatedUserID, ModifiedDate, ModifiedUserID, DefaultRule
FROM BusinessRule
WHERE Name<>'Default Print Billing Form' AND BusinessRuleProcessingTypeID<>2 AND PracticeID=4

INSERT INTO superbill_0109_prod..BusinessRule (PracticeID, BusinessRuleProcessingTypeID, Name, BusinessRuleXML, SortOrder, ContinueProcessing,
CreatedDate, CreatedUserID, ModifiedDate, ModifiedUserID, DefaultRule)
SELECT 2, BusinessRuleProcessingTypeID, Name, BusinessRuleXML, SortOrder, ContinueProcessing,
CreatedDate, CreatedUserID, ModifiedDate, ModifiedUserID, DefaultRule
FROM BusinessRule
WHERE Name<>'Default Print Billing Form' AND BusinessRuleProcessingTypeID<>2 AND PracticeID=4

INSERT INTO superbill_0109_prod..BusinessRule (PracticeID, BusinessRuleProcessingTypeID, Name, BusinessRuleXML, SortOrder, ContinueProcessing,
CreatedDate, CreatedUserID, ModifiedDate, ModifiedUserID, DefaultRule)
SELECT 3, BusinessRuleProcessingTypeID, Name, BusinessRuleXML, SortOrder, ContinueProcessing,
CreatedDate, CreatedUserID, ModifiedDate, ModifiedUserID, DefaultRule
FROM BusinessRule
WHERE Name<>'Default Print Billing Form' AND BusinessRuleProcessingTypeID<>2 AND PracticeID=4

INSERT INTO superbill_0109_prod..BusinessRule (PracticeID, BusinessRuleProcessingTypeID, Name, BusinessRuleXML, SortOrder, ContinueProcessing,
CreatedDate, CreatedUserID, ModifiedDate, ModifiedUserID, DefaultRule)
SELECT 4, BusinessRuleProcessingTypeID, Name, BusinessRuleXML, SortOrder, ContinueProcessing,
CreatedDate, CreatedUserID, ModifiedDate, ModifiedUserID, DefaultRule
FROM BusinessRule
WHERE Name<>'Default Print Billing Form' AND BusinessRuleProcessingTypeID<>2 AND PracticeID=4