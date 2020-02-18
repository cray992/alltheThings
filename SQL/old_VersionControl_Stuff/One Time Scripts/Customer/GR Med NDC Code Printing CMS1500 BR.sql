INSERT INTO BusinessRule(PracticeID, BusinessRuleProcessingTypeID, Name, BusinessRuleXML, SortOrder, ContinueProcessing, DefaultRule)
VALUES(5,1,'Business Rule 39 NDC CMS1500 Printing','<?xml version="1.0" encoding="utf-8" ?>
<businessRule name="Business Rule 39 NDC CMS1500 Printing">
	<conditions>
		<condition field="AssignedInsurance" fieldName="Assigned Insurance" predicateName="Exists"
			value="" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="A30" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="AL30" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="AL90" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="C120" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="C30" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="C60" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="C90" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="CA120" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="CAR120" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="CA90" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="CE60" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="CEP60" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="D120" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="DI120" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="DC120" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="G60" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="G120" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="G90" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="GL120" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="GU120" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="GC120" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="HY60" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="H120" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="HY120" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="HD120" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="HB120" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="BA120" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="BA60" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="BA12 " />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="HA120" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="HYD" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="H12" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="H60" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="K60" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="N120" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="NA120" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="N30" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="P120" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="PN120" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="P30" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="P90" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="R120" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="R60" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="R90" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="RA60" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="RA90" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="S60" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="SE60" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="T60" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="T90" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="T120" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="TR120" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="TA120" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="T30" />
		<condition field="ProcedureCode" fieldName="Procedure Code" predicateName="Equals" value="TR30" />
	</conditions>
	<actions>
		<action storedProcedure="BusinessRuleEngine_ActionPrintDocuments">
			<parameter>
				<recipient value="8" valueName="Patient Insurances" />
			</parameter>
			<document type="" value="12" valueName="CMS 1500 Form" />
		</action>
	</actions>
</businessRule>
',39,0,0)