UPDATE dbo.PatientHistorySetup
SET Configuration =
'<patientHistory type="Charges Summary" storedProcedure="PatientDataProvider_GetActivities_ChargeSummary">
  <!-- Section to determine which parameters are available to this report -->
  <parameters>
    <parameter type="PracticeID" />
    <parameter type="PatientID" />
    <parameter type="PatientCaseID" />
    <parameter type="BeginDate" />
    <parameter type="EndDate" />
    <parameter type="ProviderID" />
    <parameter type="Status" parameter="ReportType" value="O" />
    <parameter type="UnappliedAmount" />
  </parameters>
  <!-- Section to determine which actions (buttons) are available to this report -->
  <actions>
    <action type="Open" hyperlinkField="HyperlinkID" hyperlinkIDField="RefID" />
    <action type="AddNote" />
    <action type="Print" reportName="rptGetActivities_TransactionSummary" />
  </actions>
  <!-- Section to determine the column structure for the report -->
  <columns>
    <column field="ClaimHasNotes" name="Notes" width="40" datatype="Bool" columntype="Check" />
    <column field="ProcedureDateOfService" name="Service Date" width="75" datatype="ShortDateTime" columntype="Label" summaryType="Text" summaryText="TOTALS" />
    <column field="Description" name="Description" width="163" datatype="String" columntype="Label" />
    <column field="ExpectedReimbursement" name="Expected" width="75" datatype="Money" columntype="Label" summaryType="Sum" />
    <column field="Charges" name="Charges" width="75" datatype="Money" columntype="Label" summaryType="Sum" />
    <column field="Adjustments" name="Adjustments" width="75" datatype="Money" columntype="Label" summaryType="Sum" />
    <column field="Receipts" name="Receipts" width="75" datatype="Money" columntype="Label" summaryType="Sum" />
    <column field="PendingPat" name="Pat. Balance" width="75" datatype="Money" columntype="Label" summaryType="SumSubtractLastValue" summarySubtractField="UnappliedAmount" />
    <column field="PendingIns" name="Ins. Balance" width="75" datatype="Money" columntype="Label" summaryType="Sum" />
    <column field="Totalbalance" name="Total Balance" width="77" datatype="Money" columntype="Label" summaryType="SumSubtractLastValue" summarySubtractField="UnappliedAmount" />
    <column field="UnappliedAmount" name="" width="0" datatype="Money" columntype="Label" visible="false" />
  </columns>
</patientHistory>'
WHERE PatientHistorySetupID = 1

UPDATE dbo.PatientHistorySetup
SET Configuration =
'<patientHistory type="Transactions Detail" storedProcedure="PatientDataProvider_GetActivities_TransactionDetail">
  <!-- Section to determine which parameters are available to this report -->
  <parameters>
    <parameter type="PracticeID" />
    <parameter type="PatientID" />
    <parameter type="PatientCaseID" />
    <parameter type="BeginDate" />
    <parameter type="EndDate" />
    <parameter type="ProviderID" />
    <parameter type="Transaction" value="" />
  </parameters>
  <!-- Section to determine which actions (buttons) are available to this report -->
  <actions>
    <action type="Open" hyperlinkField="HyperlinkID" hyperlinkIDField="RefID" />
    <action type="AddNote" />
    <action type="Print" reportName="rptGetActivities_TransactionDetail" />
    <action type="Reprint" reprintField="HCFA_DocumentID" />
  </actions>
  <!-- Section to determine the column structure for the report -->
  <columns>
    <column field="TransactionDate" name="Post/Tx Date" width="75" datatype="ShortDateTime" columntype="Label" summaryType="Text" summaryText="BALANCE" />
    <column field="DateOfService" name="Service Date" width="75" datatype="ShortDateTime" columntype="Label" />
    <column field="Description" name="Description" width="238" datatype="String" columntype="Label" />
    <column field="Amount" name="Amount" width="75" datatype="Money" columntype="Label" />
    <column field="PatientBalance" name="Pat. Balance" width="75" datatype="Money" columntype="Label" summaryType="Balance" />
    <column field="InsuranceBalance" name="Ins. Balance" width="75" datatype="Money" columntype="Label" summaryType="Balance" />
    <column field="TotalBalance" name="Total Balance" width="77" datatype="Money" columntype="Label" summaryType="Balance" />
    <column field="Unapplied" name="Unapplied" width="75" datatype="Money" columntype="Label" summaryType="Balance" />
  </columns>
</patientHistory>'
WHERE PatientHistorySetupID =2