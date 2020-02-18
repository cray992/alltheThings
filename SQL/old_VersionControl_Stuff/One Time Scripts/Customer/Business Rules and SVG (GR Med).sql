-- Insert data into the tables
/*
-- Loop through all practices and add business rules
DECLARE	@PracticeID INT
DECLARE @i INT
DECLARE @Total INT

SET @PracticeID = 0
SET @i = 1

SELECT	@Total = COUNT(PracticeID)
FROM	Practice

WHILE	@i <= @Total
BEGIN
	SELECT	@PracticeID = MIN(PracticeID)
	FROM	Practice
	WHERE	PracticeID > @PracticeID

	INSERT	BusinessRule(
			PracticeID,
			BusinessRuleProcessingTypeID,
			Name,
			SortOrder,
			ContinueProcessing, 
			BusinessRuleXML
		)
	VALUES	(	@PracticeID,
			1,
			'Business Rule 1',
			1,
			0, 
			'<?xml version="1.0" encoding="utf-8"?>
	<businessRule name="Business Rule 1">
		<conditions>
			<condition field="PayerScenarioID" fieldName="Payer Scenario" predicateName="Equals" value="15" valueName="Workers Comp - Applicant" />
			<condition field="State" fieldName="State" predicateName="Equals" value="CA" />
			<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="9920?" />
			<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="9924?" />
			<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="9927?" />
			<condition field="ReferringPhysicianID" fieldName="Referring Physician" predicateName="Exists" />
		</conditions>
		<actions>
			<action storedProcedure="BusinessRuleEngine_ActionPrintDocuments">
				<parameter>
					<recipient value="2" valueName="Assigned Insurance" />
					<recipient value="3" valueName="Applicant Attorney" />
					<recipient value="4" valueName="Defense Attorney" />
					<recipient value="6" valueName="Employer" />
					<recipient value="5" valueName="Referring Physician" />
				</parameter>
				<document value="7" valueName="Mailing Label" />
				<document value="6" valueName="Proof of Service" />
				<document value="4" valueName="Notice of Representation" />
				<document value="1" valueName="CMS 1500 Form" />
			</action>
		</actions>
	</businessRule>'
		)
	
	INSERT	BusinessRule(
			PracticeID,
			BusinessRuleProcessingTypeID,
			Name,
			SortOrder,
			ContinueProcessing, 
			BusinessRuleXML
		)
	VALUES	(	@PracticeID,
			1,
			'Business Rule 2 (Same as Business Rule 1 but without Referring Physician)',
			2,
			0, 
			'<?xml version="1.0" encoding="utf-8"?>
	<businessRule name="Business Rule 2">
		<conditions>
			<condition field="PayerScenarioID" fieldName="Payer Scenario" predicateName="Equals" value="15" valueName="Workers Comp - Applicant" />
			<condition field="State" fieldName="State" predicateName="Equals" value="CA" />
			<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="9920?" />
			<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="9924?" />
			<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="9927?" />
		</conditions>
		<actions>
			<action storedProcedure="BusinessRuleEngine_ActionPrintDocuments">
				<parameter>
					<recipient value="2" valueName="Assigned Insurance" />
					<recipient value="3" valueName="Applicant Attorney" />
					<recipient value="4" valueName="Defense Attorney" />
					<recipient value="6" valueName="Employer" />
				</parameter>
				<document value="7" valueName="Mailing Label" />
				<document value="6" valueName="Proof of Service" />
				<document value="4" valueName="Notice of Representation" />
				<document value="1" valueName="CMS 1500 Form" />
			</action>
		</actions>
	</businessRule>'
		)
	
	INSERT	BusinessRule(
			PracticeID,
			BusinessRuleProcessingTypeID,
			Name,
			SortOrder,
			ContinueProcessing, 
			BusinessRuleXML
		)
	VALUES	(	@PracticeID,
			1,
			'Business Rule 3',
			3,
			0, 
			'<?xml version="1.0" encoding="utf-8"?>
	<businessRule name="Business Rule 2">
		<conditions>
			<condition field="PayerScenarioID" fieldName="Payer Scenario" predicateName="Equals" value="15" valueName="Workers Comp - Applicant" />
			<condition field="State" fieldName="State" predicateName="Equals" value="CA" />
			<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="9921?" />
			<condition field="ReferringPhysicianID" fieldName="Referring Physician" predicateName="Exists" />
		</conditions>
		<actions>
			<action storedProcedure="BusinessRuleEngine_ActionPrintDocuments">
				<parameter>
					<recipient value="2" valueName="Assigned Insurance" />
					<recipient value="3" valueName="Applicant Attorney" />
					<recipient value="4" valueName="Defense Attorney" />
					<recipient value="5" valueName="Referring Physician" />
				</parameter>
				<document value="7" valueName="Mailing Label" />
				<document value="6" valueName="Proof of Service" />
				<document value="4" valueName="Notice of Representation" />
				<document value="1" valueName="CMS 1500 Form" />
				<document value="5" valueName="Primary Treating Physicians Progress" />
			</action>
		</actions>
	</businessRule>'
		)
	
	INSERT	BusinessRule(
			PracticeID,
			BusinessRuleProcessingTypeID,
			Name,
			SortOrder,
			ContinueProcessing, 
			BusinessRuleXML
		)
	VALUES	(	@PracticeID,
			1,
			'Business Rule 4 (Same as Business Rule 3 but without Referring Physician)',
			4,
			0, 
			'<?xml version="1.0" encoding="utf-8"?>
	<businessRule name="Business Rule 2">
		<conditions>
			<condition field="PayerScenarioID" fieldName="Payer Scenario" predicateName="Equals" value="15" valueName="Workers Comp - Applicant" />
			<condition field="State" fieldName="State" predicateName="Equals" value="CA" />
			<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="9921?" />
		</conditions>
		<actions>
			<action storedProcedure="BusinessRuleEngine_ActionPrintDocuments">
				<parameter>
					<recipient value="2" valueName="Assigned Insurance" />
					<recipient value="3" valueName="Applicant Attorney" />
					<recipient value="4" valueName="Defense Attorney" />
				</parameter>
				<document value="7" valueName="Mailing Label" />
				<document value="6" valueName="Proof of Service" />
				<document value="4" valueName="Notice of Representation" />
				<document value="1" valueName="CMS 1500 Form" />
			</action>
		</actions>
	</businessRule>'
		)

	SET @i = @i + 1
END
*/


-- Updating the Referring Physician
IF EXISTS(SELECT * FROM sysobjects WHERE name='BillDataProvider_BusinessRuleRecipients_ReferringPhysician' AND xtype='P')
	DROP PROCEDURE dbo.BillDataProvider_BusinessRuleRecipients_ReferringPhysician

GO

CREATE PROCEDURE BillDataProvider_BusinessRuleRecipients_ReferringPhysician
@DocumentID INT

AS

BEGIN
	INSERT INTO #Recipients(RecipientName, PrintingFormRecipientID, RecordID)
	SELECT TOP 1 RTRIM(ISNULL(RP.FirstName + ' ','') + ISNULL(RP.MiddleName + ' ', '')) + ISNULL(' ' + RP.LastName,'') + ISNULL(', ' + dbo.fn_ZeroLengthStringToNull(RP.Degree), ''),
	5, PC.ReferringPhysicianID
	FROM Document D INNER JOIN Document_HCFA DH
	ON D.DocumentID=DH.DocumentID
	INNER JOIN Claim C
	ON DH.RepresentativeClaimID=C.ClaimID
	INNER JOIN EncounterProcedure EP
	ON C.EncounterProcedureID=EP.EncounterProcedureID
	INNER JOIN Encounter E
	ON EP.EncounterID=E.EncounterID
	INNER JOIN PatientCase PC
	ON E.PatientCaseID=PC.PatientCaseID
	INNER JOIN ReferringPhysician RP
	ON PC.ReferringPhysicianID=RP.ReferringPhysicianID
	WHERE D.DocumentID=@DocumentID
END