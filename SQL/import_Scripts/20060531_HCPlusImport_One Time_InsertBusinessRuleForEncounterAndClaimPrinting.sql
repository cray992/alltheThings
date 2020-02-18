-- Insert into businessrule (for practiceID 28 through 48)

--BEGIN TRANSACTION

DECLARE @PracticeID int

SET @PracticeID = 28

WHILE @PracticeID < 49
BEGIN

	-- Insert a default business rule for encounter form printing
	INSERT	BusinessRule(
			PracticeID,
			BusinessRuleProcessingTypeID,
			Name,
			SortOrder,
			ContinueProcessing, 
			BusinessRuleXML,
			DefaultRule
	)
	VALUES	(	@PracticeID,
			2,
			'Encounter Form Default',
			1,
			0, 
			'<?xml version="1.0" encoding="utf-8"?>  <businessRule name="Encounter Form Default">
  <conditions/>
  <actions>
    <action storedProcedure="BusinessRuleEngine_ActionPrintDocuments">
      <parameter>
        <recipient value="1" valueName="Practice"/>
      </parameter>
      <document value="9" valueName="Encounter Form"/>
    </action>
  </actions>
  </businessRule>',
			1)

	-- Insert a default business rule for claim bill printing
	INSERT	BusinessRule(
			PracticeID,
			BusinessRuleProcessingTypeID,
			Name,
			SortOrder,
			ContinueProcessing, 
			BusinessRuleXML,
			DefaultRule
		)
	VALUES	(	@PracticeID,
			1,
			'Default Print Billing Form',
			10000,
			0, 
			'<?xml version="1.0" encoding="utf-8"?>
<businessRule name="Default Print Billing Form">
            <conditions>
                        <condition field="AssignedInsurance" fieldName="Assigned Insurance" predicateName="Exists" />
            </conditions>
            <actions>
                        <action storedProcedure="BusinessRuleEngine_ActionPrintDocuments">
                                    <parameter>
                                                <recipient value="2" valueName="Assigned Insurance" />
                                    </parameter>
                                    <document value="99999" type="" valueName="General Billing Form" />
                        </action>
            </actions>
</businessRule>',
			1)

	SET @PracticeID = @PracticeID + 1

END

-- ROLLBACK
-- COMMIT

--select * from businessrule order by practiceid