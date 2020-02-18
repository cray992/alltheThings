BEGIN TRAN

DELETE FROM ClientBusinessRule
DELETE FROM ClientBusinessRuleSet

DECLARE @r int

INSERT INTO ClientBusinessRuleSet
 (Name,RuleSet, ValidatingXmlSchemaCollectionName)
VALUES
 ('InsurancePaymentProcessing',
'<?xml version="1.0" encoding="utf-8"?>
<ruleset startRef="Init_InitializeProcessing">
  <!-- Init -->
  <action id="Init_InitializeProcessing" src="database://InsurancePaymentProcessing/Init_InitializeProcessing" nextRef="VoidCheck_ClaimIsVoided" />

  <!-- Voiding -->
  <decision id="VoidCheck_ClaimIsVoided" src="database://InsurancePaymentProcessing/VoidCheck_ClaimIsVoided" successRef="VoidCheck_setClaimErrorState" failRef="Reversing_CPHasReversal" />
  <action id="VoidCheck_setClaimErrorState" src="database://InsurancePaymentProcessing/VoidCheck_setClaimErrorState" nextRef="End_Error" />

  <!-- Reversing -->
  <decision id="Reversing_CPHasReversal" src="database://InsurancePaymentProcessing/Reversing_CPHasReversal" successRef="Reversing_SPIsAvailable" failRef="Denial_CPHasDenial" />
  <decision id="Reversing_SPIsAvailable" src="database://InsurancePaymentProcessing/Reversing_SPIsAvailable" successRef="Reversing_setSPReversed" failRef="Reversing_setClaimErrorState" />
  <action id="Reversing_setSPReversed" src="database://InsurancePaymentProcessing/Reversing_setSPReversed" nextRef="Reversing_ReverseSPTransactions" />
  <action id="Reversing_ReverseSPTransactions" src="database://InsurancePaymentProcessing/Reversing_ReverseSPTransactions" nextRef="Denial_CPHasDenial" />
  <action id="Reversing_setClaimErrorState" src="database://InsurancePaymentProcessing/Reversing_setClaimErrorState" nextRef="End_Error" />

  <!-- Denial -->

  <decision id="Denial_CPHasDenial" src="database://InsurancePaymentProcessing/Denial_CPHasDenial" successRef="Denial_CPLVHasDenial" failRef="Denial_CPImpliesDenial" />
  <decision id="Denial_CPImpliesDenial" src="database://InsurancePaymentProcessing/Denial_CPImpliesDenial" successRef="Denial_setClaimDenialState" failRef="UnknownState_CPIsUnknown" />
  <decision id="Denial_CPLVHasDenial" src="database://InsurancePaymentProcessing/Denial_CPLVHasDenial" successRef="Denial_setClaimErrorState" failRef="Denial_setClaimDenialState" />
  <action id="Denial_setClaimErrorState" src="database://InsurancePaymentProcessing/Denial_setClaimErrorState" nextRef="End_Error" />
  <action id="Denial_setClaimDenialState" src="database://InsurancePaymentProcessing/Denial_setClaimDenialState" nextRef="End_Success" />

  <!-- Unknown State -->

  <decision id="UnknownState_CPIsUnknown" src="database://InsurancePaymentProcessing/UnknownState_CPIsUnknown" successRef="UnknownState_setClaimErrorState" failRef="Crossover_CPNonDefaultAction" />
  <action id="UnknownState_setClaimErrorState" src="database://InsurancePaymentProcessing/UnknownState_setClaimErrorState" nextRef="End_Error" />

  <!-- Crossover -->

  <decision id="Crossover_CPNonDefaultAction" src="database://InsurancePaymentProcessing/Crossover_CPNonDefaultAction" successRef="ErrorUnset_CPIsError"  failRef="Crossover_CPHasCrossover" />
  <decision id="Crossover_CPHasCrossover" src="database://InsurancePaymentProcessing/Crossover_CPHasCrossover" successRef="Crossover_CPLVHasCrossover" failRef="ErrorUnset_CPIsError" />
  <decision id="Crossover_CPLVHasCrossover" src="database://InsurancePaymentProcessing/Crossover_CPLVHasCrossover" successRef="Crossover_setClaimErrorState" failRef="Crossover_ClaimHasNextInstitutionalPayer" />
  <decision id="Crossover_ClaimHasNextInstitutionalPayer" src="database://InsurancePaymentProcessing/Crossover_ClaimHasNextInstitutionalPayer" successRef="Crossover_ScheduleCrossover" failRef="Crossover_setClaimErrorState" />
  <action id="Crossover_setClaimErrorState" src="database://InsurancePaymentProcessing/Crossover_setClaimErrorState" nextRef="End_Error" />
  <action id="Crossover_ScheduleCrossover" src="database://InsurancePaymentProcessing/Crossover_ScheduleCrossover" nextRef="ErrorUnset_CPIsError" />

  <!-- Claim Error Unset -->
  
  <decision id="ErrorUnset_CPIsError" src="database://InsurancePaymentProcessing/ErrorUnset_CPIsError" successRef="ErrorUnset_unsetClaimErrorState" failRef="Reopen_ClaimIsSettled" />
  <action id="ErrorUnset_unsetClaimErrorState" src="database://InsurancePaymentProcessing/ErrorUnset_unsetClaimErrorState" nextRef="Reopen_ClaimIsSettled" />


  <!-- Reopen -->

  <decision id="Reopen_ClaimIsSettled" src="database://InsurancePaymentProcessing/Reopen_ClaimIsSettled" successRef="Reopen_ScheduleReopen" failRef="Payments_CPHasPayments" />
  <action id="Reopen_ScheduleReopen" src="database://InsurancePaymentProcessing/Reopen_ScheduleReopen" nextRef="Payments_CPHasPayments" />

  <!-- Payments -->

  <decision id="Payments_CPHasPayments" src="database://InsurancePaymentProcessing/Payments_CPHasPayments" successRef="Payments_CPLVHasPayments" failRef="Adjust_CPHasAdjustments" />
  <decision id="Payments_CPLVHasPayments" src="database://InsurancePaymentProcessing/Payments_CPLVHasPayments" successRef="Payments_CalculatePaymentWithCPLV" failRef="Payments_CalculatePayment" />
  <action id="Payments_CalculatePaymentWithCPLV" src="database://InsurancePaymentProcessing/Payments_CalculatePaymentWithCPLV" nextRef="Payments_AmountFitsIntoCP" />
  <action id="Payments_CalculatePayment" src="database://InsurancePaymentProcessing/Payments_CalculatePayment" nextRef="Payments_AmountFitsIntoCP" />
  <decision id="Payments_AmountFitsIntoCP" src="database://InsurancePaymentProcessing/Payments_AmountFitsIntoCP" successRef="Payments_AmountNotZero" failRef="Payments_AdjustAmountToCP" />
  <action id="Payments_AdjustAmountToCP" src="database://InsurancePaymentProcessing/Payments_AdjustAmountToCP" nextRef="Payments_AmountNotZero" />
  <decision id="Payments_AmountNotZero" src="database://InsurancePaymentProcessing/Payments_AmountNotZero" successRef="Payments_SchedulePayment" failRef="Adjust_CPHasAdjustments" />
  <action id="Payments_SchedulePayment" src="database://InsurancePaymentProcessing/Payments_SchedulePayment" nextRef="Adjust_CPHasAdjustments" />

  <!-- Adjustments -->

  <decision id="Adjust_CPHasAdjustments" src="database://InsurancePaymentProcessing/Adjust_CPHasAdjustments" successRef="Adjust_CPLVHasAdjustments" failRef="Copay_CPHasCopay" />
  <decision id="Adjust_CPLVHasAdjustments" src="database://InsurancePaymentProcessing/Adjust_CPLVHasAdjustments" successRef="Adjust_ScheduleAdjustWithCPLV" failRef="Adjust_DPHasAdjustments" />
  <decision id="Adjust_DPHasAdjustments" src="database://InsurancePaymentProcessing/Adjust_DPHasAdjustments" successRef="Adjust_FDPHasAdjustments" failRef="Adjust_ScheduleAdjust" />
  <decision id="Adjust_FDPHasAdjustments" src="database://InsurancePaymentProcessing/Adjust_FDPHasAdjustments" successRef="Copay_CPHasCopay" failRef="Adjust_PDPHasAdjustments" />
  <decision id="Adjust_PDPHasAdjustments" src="database://InsurancePaymentProcessing/Adjust_PDPHasAdjustments" successRef="Adjust_ScheduleAdjustWithPDP" failRef="Copay_CPHasCopay" />
  <action id="Adjust_ScheduleAdjustWithCPLV" src="database://InsurancePaymentProcessing/Adjust_ScheduleAdjustWithCPLV" nextRef="Copay_CPHasCopay" />
  <action id="Adjust_ScheduleAdjust" src="database://InsurancePaymentProcessing/Adjust_ScheduleAdjust" nextRef="Copay_CPHasCopay" />
  <action id="Adjust_ScheduleAdjustWithPDP" src="database://InsurancePaymentProcessing/Adjust_ScheduleAdjustWithPDP" nextRef="Copay_CPHasCopay" />

  <!-- Copay -->

  <decision id="Copay_CPHasCopay" src="database://InsurancePaymentProcessing/Copay_CPHasCopay" successRef="Copay_CalculateAmount" failRef="Copay_AdjustForBalanceProblems" />
  <action id="Copay_CalculateAmount" src="database://InsurancePaymentProcessing/Copay_CalculateAmount" nextRef="Copay_CheckAmount" />
  <decision id="Copay_CheckAmount" src="database://InsurancePaymentProcessing/Copay_CheckAmount" successRef="Copay_ScheduleTransaction" failRef="Copay_AdjustForBalanceProblems" />
  <action id="Copay_ScheduleTransaction" src="database://InsurancePaymentProcessing/Copay_ScheduleTransaction" nextRef="Copay_AdjustForBalanceProblems" />

  <action id="Copay_AdjustForBalanceProblems" src="database://InsurancePaymentProcessing/Copay_AdjustForBalanceProblems" nextRef="Post_PrepareTransactions" />


  <!-- Post Transactions -->

  <action id="Post_PrepareTransactions" src="database://InsurancePaymentProcessing/Post_PrepareTransactions" nextRef="Post_Reopen" />
  <action id="Post_Reopen" src="database://InsurancePaymentProcessing/Post_Reopen" nextRef="Post_Reversal" />
  <action id="Post_Reversal" src="database://InsurancePaymentProcessing/Post_Reversal" nextRef="Post_Copay" />
  <action id="Post_Copay" src="database://InsurancePaymentProcessing/Post_Copay" nextRef="Post_Adjustments" />
  <action id="Post_Adjustments" src="database://InsurancePaymentProcessing/Post_Adjustments" nextRef="Post_Payments" />
  <action id="Post_Payments" src="database://InsurancePaymentProcessing/Post_Payments" nextRef="End_Success" />

  <!-- Terminators -->

  <terminateAction id="End_Success" src="database://InsurancePaymentProcessing/End_Success" />
  <terminateAction id="End_Error" src="database://InsurancePaymentProcessing/End_Error" />
</ruleset>',
'Schema_ClientBusinessRule_Set')

SET @r = SCOPE_IDENTITY()

INSERT INTO ClientBusinessRule (CLientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'VoidCheck_ClaimIsVoided','<?xml version="1.0" encoding="utf-8" ?>
<!--
  decision 
  VoidCheck_ClaimIsVoided
-->
<snippet>
  <code>
    <![CDATA[

	if (true == Runtime.GetData<bool>("Claim","IsVoided"))
		return DecisionStatus.Success;
	else
		return DecisionStatus.Failure;

]]>
  </code>
</snippet>')
INSERT INTO ClientBusinessRule (CLientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'VoidCheck_setClaimErrorState','<?xml version="1.0" encoding="utf-8" ?>
<!--
  action
  VoidCheck_setClaimErrorState
-->
<snippet>
  <code>
    <![CDATA[

	Runtime.SetData("Output", "ClaimInError", true);
	Runtime.SetData("Output", "ClaimErrorMessage", "Sorry, this service line is voided and cannot be processed automatically.");

	return ActionStatus.Executed;

]]>
  </code>
</snippet>')
INSERT INTO ClientBusinessRule (CLientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'End_Error','<?xml version="1.0" encoding="utf-8" ?>
<!--
  terminateAction
  End_Error
-->
<snippet>
  <code>
    <![CDATA[

	return ActionStatus.Executed;

]]>
  </code>
</snippet>')
INSERT INTO ClientBusinessRule (CLientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'End_Success','<?xml version="1.0" encoding="utf-8" ?>
<!--
  terminateAction
  End_Success
-->
<snippet>
  <code>
    <![CDATA[

	return ActionStatus.Executed;

]]>
  </code>
</snippet>')
INSERT INTO ClientBusinessRule (CLientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Reversing_CPHasReversal','<?xml version="1.0" encoding="utf-8" ?>
<!--
  decision
  Reversing_CPHasReversal
-->
<snippet>
  <code>
    <![CDATA[

	
	if (true == Runtime.GetData<bool>("CP","HasReversal"))
		return DecisionStatus.Success; 
	else
		return DecisionStatus.Failure; 

]]>
  </code>
</snippet>')
INSERT INTO ClientBusinessRule (CLientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Reversing_ReverseSPTransactions','<?xml version="1.0" encoding="utf-8" ?>
<!--
  action
  Reversing_ReverseSPTransactions
-->
<snippet>
  <code>
    <![CDATA[
    
    	decimal trackedChargeRemaining = Runtime.GetData<decimal>("Output","ChargeRemaining");
    	decimal trackedCopayRemaining = Runtime.GetData<decimal>("Output","CopayRemaining");
    
    	decimal reversiblePayment = 0;
    	
    	if (true == Runtime.ContainsData<decimal>("SP","ReversiblePayment"))
    		reversiblePayment = Runtime.GetData<decimal>("SP","ReversiblePayment");

    	decimal reversibleCopay = 0;
    	
    	if (true == Runtime.ContainsData<decimal>("SP","ReversiblePRC"))
    		reversibleCopay = Runtime.GetData<decimal>("SP","ReversiblePRC");

    		
    	Dictionary<string, decimal> reversibleAdjustments = null;
    	
    	if (true == Runtime.ContainsData<Dictionary<string,decimal>>("SP","ReversibleAdjustments"))
    		reversibleAdjustments = Runtime.GetData<Dictionary<string,decimal>>("SP","ReversibleAdjustments");
    	else
    		reversibleAdjustments = new Dictionary<string,decimal>();
    	
    	
    	decimal payment = reversiblePayment * -1;
	
	if (payment != 0)
	{
		Runtime.SetData("Output", "Reversal.Payment", payment);
		trackedChargeRemaining -= payment;
	}
		
    	decimal copay = reversibleCopay * -1;
	
	if (copay != 0)
	{
		Runtime.SetData("Output", "Reversal.Copay", copay);
		trackedCopayRemaining -= copay;
	}
		


    	Dictionary<string, decimal> adjustments = new Dictionary<string, decimal>();
    	
    	foreach (string type in reversibleAdjustments.Keys)
    	{
    		if (false == adjustments.ContainsKey(type))
    			adjustments.Add(type,0.0M);
    		
    		adjustments[type] += reversibleAdjustments[type] * -1;
    		
    		trackedChargeRemaining -= reversibleAdjustments[type] * -1;
    	}

	if (adjustments.Count > 0)
		Runtime.SetData("Output", "Reversal.AdjustmentTransactions", adjustments);
		
	Runtime.SetData("Output", "CopayRemaining", trackedCopayRemaining);
	Runtime.SetData("Output", "ChargeRemaining", trackedChargeRemaining);

	Runtime.SetData("Output", "GeneratesTransactions", true);
	

	return ActionStatus.Executed;

]]>
  </code>
  <imports>
    <import namespace="System.Collections.Generic" />
  </imports>  
</snippet>')
INSERT INTO ClientBusinessRule (CLientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Reversing_setClaimErrorState','<?xml version="1.0" encoding="utf-8" ?>
<!--
  action
  Reversing_setClaimErrorState
-->
<snippet>
  <code>
    <![CDATA[

	Runtime.SetData("Output", "ClaimInError", true);
	Runtime.SetData("Output", "ClaimErrorMessage", "The claim is marked with a reversal of a previous payment, but no such payment from the same payer exists.");

	return ActionStatus.Executed;

]]>
  </code>
</snippet>')
INSERT INTO ClientBusinessRule (CLientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Reversing_setSPReversed','<?xml version="1.0" encoding="utf-8" ?>
<!--
  action
  Reversing_setSPReversed
-->
<snippet>
  <code>
    <![CDATA[

	Runtime.SetData("Output", "ReverseSP", true);

	return ActionStatus.Executed;

]]>
  </code>
</snippet>')
INSERT INTO ClientBusinessRule (CLientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Reversing_SPIsAvailable','<?xml version="1.0" encoding="utf-8" ?>
<!--
  decision
  Reversing_SPIsAvailable
-->
<snippet>
  <code>
    <![CDATA[

	if (true == Runtime.GetData<bool>("SP","IsAvailable"))
		return DecisionStatus.Success; 
	else
		return DecisionStatus.Failure; 

]]>
  </code>
</snippet>')

INSERT INTO ClientBusinessRule (CLientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Denial_CPHasDenial','<?xml version="1.0" encoding="utf-8" ?>
<!--
  decision
  Denial_CPHasDenial
-->
<snippet>
  <code>
    <![CDATA[

	if (true == Runtime.GetData<bool>("CP","IsDenial"))
		return DecisionStatus.Success; 
	else
		return DecisionStatus.Failure;

]]>
  </code>
</snippet>')
INSERT INTO ClientBusinessRule (CLientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Denial_setClaimDenialState','<?xml version="1.0" encoding="utf-8" ?>
<!--
  action
  Denial_setClaimDenialState
-->
<snippet>
  <code>
    <![CDATA[

	Runtime.SetData("Output", "ClaimDenied", true);
	
	if (true == Runtime.ContainsData<bool>("CP","IsEncounterDenial"))
	{
		if (true == Runtime.GetData<bool>("CP","IsEncounterDenial"))
		{
			Runtime.SetData("Output", "ClaimInError", true);
			Runtime.SetData("Output", "ErrorSeverity", 3);
			Runtime.SetData("Output", "ClaimErrorMessage", "This service line is part of a denied claim.");
		}
	}

	return ActionStatus.Executed;

]]>
  </code>
</snippet>')
INSERT INTO ClientBusinessRule (CLientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Denial_CPLVHasDenial','<?xml version="1.0" encoding="utf-8" ?>
<!--
  decision
  Denial_CPLVHasDenial
-->
<snippet>
  <code>
    <![CDATA[

	if (false == Runtime.GetData<bool>("CPLV","IsAvailable"))
		return DecisionStatus.Failure;
		
	if (true == Runtime.GetData<bool>("CPLV","IsDenial"))
		return DecisionStatus.Failure;
	else
		return DecisionStatus.Success;

]]>
  </code>
</snippet>')
INSERT INTO ClientBusinessRule (CLientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Denial_setClaimErrorState','<?xml version="1.0" encoding="utf-8" ?>
<!--
  action
  Denial_setClaimErrorState
-->
<snippet>
  <code>
    <![CDATA[

	Runtime.SetData("Output", "ClaimInError", true);
	Runtime.SetData("Output", "ClaimErrorMessage", "Sorry, this service line was previously denied and is now marked not denied. It cannot be processed further automatically.");

	return ActionStatus.Executed;

]]>
  </code>
</snippet>')

INSERT INTO ClientBusinessRule (CLientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'UnknownState_CPIsUnknown','<?xml version="1.0" encoding="utf-8" ?>
<!--
  decision 
  UnknownState_CPIsUnknown
-->
<snippet>
  <code>
    <![CDATA[

	if (true == Runtime.GetData<bool>("CP","IsUnknown"))
		return DecisionStatus.Success;
	else
		return DecisionStatus.Failure;

]]>
  </code>
</snippet>')
INSERT INTO ClientBusinessRule (CLientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'UnknownState_setClaimErrorState','<?xml version="1.0" encoding="utf-8" ?>
<!--
  action
  UnknownState_setClaimErrorState
-->
<snippet>
  <code>
    <![CDATA[

	Runtime.SetData("Output", "ClaimInError", true);
	Runtime.SetData("Output", "ClaimErrorMessage", "The ERA reported an unknown status for the claim.");

	return ActionStatus.Executed;

]]>
  </code>
</snippet>')

INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Init_InitializeProcessing','<?xml version="1.0" encoding="utf-8" ?>
<!--
  action
  Init_InitializeProcessing
-->
<snippet>
  <code>
    <![CDATA[

	int encounterID = Runtime.GetData<int>("Claim","EncounterID");
	int claimID = Runtime.GetData<int>("Claim","ClaimID");
	int patientID = Runtime.GetData<int>("Claim","PatientID");
	string patientName = Runtime.GetData<string>("Claim","PatientName");
	string procedureCode = Runtime.GetData<string>("Claim","ProcedureCode");
	
	string header = string.Format("pt{1}/{0} e{2}/c{3}/{4}", patientName, patientID, encounterID, claimID, procedureCode);

	Log("Rule::Init", header);

	
	decimal claimCopay = 0.00M;
	
	if (true == Runtime.ContainsData<decimal>("Claim","CopayNeeded"))
	{
		claimCopay = Runtime.GetData<decimal>("Claim","CopayNeeded");
	}
	
	Runtime.SetData("Output", "CopayRemaining", claimCopay);
	Runtime.SetData("Output", "ChargeRemaining", Runtime.GetData<decimal>("Claim","CurrentCharge"));
	

	return ActionStatus.Executed;

]]>
  </code>
</snippet>')

INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Crossover_setClaimErrorState','<?xml version="1.0" encoding="utf-8" ?>
<!--
  action
  Crossover_setClaimErrorState
-->
<snippet>
  <code>
    <![CDATA[

	Runtime.SetData("Output", "ClaimInError", true);
	Runtime.SetData("Output", "ClaimErrorMessage", "A crossover is specified, but there is no next institutional payer for this service line.");

	return ActionStatus.Executed;

]]>
  </code>
</snippet>')
INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Crossover_ScheduleCrossover','<?xml version="1.0" encoding="utf-8" ?>
<!--
  action
  Crossover_ScheduleCrossover
-->
<snippet>
  <code>
    <![CDATA[

	Runtime.SetData("Output", "ShouldCrossover", true);
	
	Runtime.SetData("Output", "GeneratesTransactions", true);

	return ActionStatus.Executed;

]]>
  </code>
</snippet>')
INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Crossover_ClaimHasNextInstitutionalPayer','<?xml version="1.0" encoding="utf-8" ?>
<!--
  decision 
  Crossover_ClaimHasNextInstitutionalPayer
-->
<snippet>
  <code>
    <![CDATA[

	if (true == Runtime.GetData<bool>("Claim","HasNextInstitutionalPayer"))
		return DecisionStatus.Success;
	else
		return DecisionStatus.Failure;

]]>
  </code>
</snippet>')
INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Crossover_CPNonDefaultAction','<?xml version="1.0" encoding="utf-8" ?>
<!--
  decision 
  Crossover_CPNonDefaultAction
-->
<snippet>
  <code>
    <![CDATA[

	if ("D" != Runtime.GetData<string>("CP","NextPayerAction"))
		return DecisionStatus.Success;
	else
		return DecisionStatus.Failure;

]]>
  </code>
</snippet>')
INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Crossover_CPLVHasCrossover','<?xml version="1.0" encoding="utf-8" ?>
<!--
  decision 
  Crossover_CPLVHasCrossover
-->
<snippet>
  <code>
    <![CDATA[

	if (true == Runtime.GetData<bool>("CPLV","HasCrossover"))
		return DecisionStatus.Success;
	else
		return DecisionStatus.Failure;

]]>
  </code>
</snippet>')
INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Crossover_CPHasCrossover','<?xml version="1.0" encoding="utf-8" ?>
<!--
  decision 
  Crossover_CPHasCrossover
-->
<snippet>
  <code>
    <![CDATA[

	if (true == Runtime.GetData<bool>("CP","HasCrossover"))
		return DecisionStatus.Success;
	else
		return DecisionStatus.Failure;

]]>
  </code>
</snippet>')

INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'ErrorUnset_CPIsError','<?xml version="1.0" encoding="utf-8" ?>
<!--
  decision 
  ErrorUnset_CPIsError
-->
<snippet>
  <code>
    <![CDATA[

	if (true == Runtime.GetData<bool>("CP","IsError"))
		return DecisionStatus.Success;
	else
		return DecisionStatus.Failure;

]]>
  </code>
</snippet>')
INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'ErrorUnset_unsetClaimErrorState','<?xml version="1.0" encoding="utf-8" ?>
<!--
  action
  ErrorUnset_unsetClaimErrorState
-->
<snippet>
  <code>
    <![CDATA[

	Runtime.SetData("Output", "ClaimInError", false);

	return ActionStatus.Executed;

]]>
  </code>
</snippet>')
INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Reopen_ClaimIsSettled','<?xml version="1.0" encoding="utf-8" ?>
<!--
  decision 
  Reopen_ClaimIsSettled
-->
<snippet>
  <code>
    <![CDATA[

	if (true == Runtime.GetData<bool>("Claim","IsSettled"))
		return DecisionStatus.Success;
	else
		return DecisionStatus.Failure;

]]>
  </code>
</snippet>')
INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Reopen_ScheduleReopen','<?xml version="1.0" encoding="utf-8" ?>
<!--
  action
  Reopen_ScheduleReopen
-->
<snippet>
  <code>
    <![CDATA[

	Runtime.SetData("Output", "ReopenClaim", true);

	return ActionStatus.Executed;

]]>
  </code>
</snippet>')

INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Payments_CPHasPayments','<?xml version="1.0" encoding="utf-8" ?>
<!--
  decision 
  Payments_CPHasPayments
-->
<snippet>
  <code>
    <![CDATA[

	if (true == Runtime.GetData<bool>("CP","HasPayments"))
		return DecisionStatus.Success;
	else
		return DecisionStatus.Failure;

]]>
  </code>
</snippet>')
INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Payments_CPLVHasPayments','<?xml version="1.0" encoding="utf-8" ?>
<!--
  decision 
  Payments_CPLVHasPayments
-->
<snippet>
  <code>
    <![CDATA[

	if (true == Runtime.GetData<bool>("CPLV","HasPayments"))
		return DecisionStatus.Success;
	else
		return DecisionStatus.Failure;

]]>
  </code>
</snippet>')
INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Payments_AmountFitsIntoCP','<?xml version="1.0" encoding="utf-8" ?>
<!--
  decision 
  Payments_AmountFitsIntoCP
-->
<snippet>
  <code>
    <![CDATA[

	decimal paymentAmount = Runtime.GetData<decimal>("Output","Payments.CalculatedAmount");
	decimal cpAmount = Runtime.GetData<decimal>("CP","UnappliedAmount");
	decimal allowedAmount = Runtime.GetData<decimal>("CP","Allowed");
	
	decimal reversalAmount = 0.0M;
	
	if (true == Runtime.ContainsData<decimal>("Output","Reversal.Payment"))
		reversalAmount = Runtime.GetData<decimal>("Output","Reversal.Payment");
		
	//would get the unapplied amount reduced by the (negative) reversal amount
	decimal unappliedAmount = cpAmount - reversalAmount;

	bool fits = true;

	if (paymentAmount > unappliedAmount)
		fits = false;

	if (paymentAmount > allowedAmount)
		fits = false;
		
	if (true == fits)
		return DecisionStatus.Success;
	else
		return DecisionStatus.Failure;

]]>
  </code>
</snippet>')

INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Payments_AmountNotZero','<?xml version="1.0" encoding="utf-8" ?>
<!--
  decision 
  Payments_AmountNotZero
-->
<snippet>
  <code>
    <![CDATA[

	if (Runtime.GetData<decimal>("Output","Payments.CalculatedAmount") != 0.00M)
		return DecisionStatus.Success;
	else
		return DecisionStatus.Failure;

]]>
  </code>
</snippet>')
INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Payments_CalculatePayment','<?xml version="1.0" encoding="utf-8" ?>
<!--
  action
  Payments_CalculatePayment
-->
<snippet>
  <code>
    <![CDATA[

	Runtime.SetData("Output", "Payments.CalculatedAmount", Runtime.GetData<decimal>("CP","SumPayments"));

	return ActionStatus.Executed;

]]>
  </code>
</snippet>')
INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Payments_CalculatePaymentWithCPLV','<?xml version="1.0" encoding="utf-8" ?>
<!--
  action
  Payments_CalculatePaymentWithCPLV
-->
<snippet>
  <code>
    <![CDATA[
    
    	decimal cpAmount = Runtime.GetData<decimal>("CP","SumPayments");
    	decimal cplvAmount = Runtime.GetData<decimal>("CPLV","SumPayments");
    	
    	decimal amount = cpAmount - cplvAmount;
    	

	Runtime.SetData("Output", "Payments.CalculatedAmount", amount);

	return ActionStatus.Executed;

]]>
  </code>
</snippet>')
INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Payments_AdjustAmountToCP','<?xml version="1.0" encoding="utf-8" ?>
<!--
  action
  Payments_AdjustAmountToCP
-->
<snippet>
  <code>
    <![CDATA[
    
    	decimal calculatedAmount = Runtime.GetData<decimal>("Output","Payments.CalculatedAmount");
	decimal cpAmount = Runtime.GetData<decimal>("CP","UnappliedAmount");
	decimal allowedAmount = Runtime.GetData<decimal>("CP","Allowed");
	
	decimal reversalAmount = 0.0M;
	
	if (true == Runtime.ContainsData<decimal>("Output","Reversal.Payment"))
		reversalAmount = Runtime.GetData<decimal>("Output","Reversal.Payment");
		
	//would get the unapplied amount reduced by the (negative) reversal amount
	decimal unappliedAmount = cpAmount - reversalAmount;
    	

	//this check is not really necessary as it is being done in the last step
	if (unappliedAmount < calculatedAmount)
	{
		Runtime.SetData("Output", "Payments.CalculatedAmount", unappliedAmount);
		
		calculatedAmount = unappliedAmount;
		
		Runtime.SetData("Output", "ClaimInError", true);
		Runtime.SetData("Output", "ErrorSeverity", 3);
		Runtime.SetData("Output", "ClaimErrorMessage", "The payment for this service line was reduced in order to fit into the unapplied amount left on the payment.");
	}
	
	//if the service line allowed amount is smaller than the payment we are about to apply,
	//set the payment amount to the allowed amount
	if (calculatedAmount > allowedAmount)
	{
		Runtime.SetData("Output", "Payments.CalculatedAmount", allowedAmount);
		
		calculatedAmount = allowedAmount;
		
		Runtime.SetData("Output", "ClaimInError", true);
		Runtime.SetData("Output", "ErrorSeverity", 3);
		Runtime.SetData("Output", "ClaimErrorMessage", "The payer reported a payment that is greater than the allowed amount. The payment for this service line has been reduced to the allowed amount.");
	}
	
	
	return ActionStatus.Executed;

]]>
  </code>
</snippet>')
INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Payments_SchedulePayment','<?xml version="1.0" encoding="utf-8" ?>
<!--
  action
  Payments_SchedulePayment
-->
<snippet>
  <code>
    <![CDATA[
    
    	decimal trackedChargeRemaining = Runtime.GetData<decimal>("Output","ChargeRemaining");

    	decimal calculatedAmount = Runtime.GetData<decimal>("Output","Payments.CalculatedAmount");

	Runtime.SetData("Output", "Payments.PaymentAmount", calculatedAmount);
	trackedChargeRemaining -= calculatedAmount;
	
	Runtime.SetData("Output", "ChargeRemaining", trackedChargeRemaining);
	
	Runtime.SetData("Output", "GeneratesTransactions", true);

	return ActionStatus.Executed;

]]>
  </code>
</snippet>')

INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Copay_CPHasCopay','<?xml version="1.0" encoding="utf-8" ?>
<!--
  decision 
  Copay_CPHasCopay
-->
<snippet>
  <code>
    <![CDATA[

	//CURRENTLY ALWAYS RETURNS TRUE
	
	return DecisionStatus.Success;

	
	//if (true == Runtime.GetData<bool>("CP","HasCopayNeededInfo"))
	//	return DecisionStatus.Success;
	//else
	//	return DecisionStatus.Failure;

]]>
  </code>
</snippet>')
INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Copay_CalculateAmount','<?xml version="1.0" encoding="utf-8" ?>
<!--
  action
  Copay_CalculateAmount
-->
<snippet>
  <code>
    <![CDATA[

	decimal cpCopay = Runtime.GetData<decimal>("CP","CopayNeeded");
	decimal claimCopay = Runtime.GetData<decimal>("Claim","CopayNeeded");
	
	Log("Rule",string.Format("CP/Claim Copay ${0}/${1}", cpCopay, claimCopay));
	
	decimal amount = cpCopay - claimCopay;

	Runtime.SetData("Output", "Copay.CalculatedAmount", amount);

	return ActionStatus.Executed;

]]>
  </code>
</snippet>')
INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Copay_CheckAmount','<?xml version="1.0" encoding="utf-8" ?>
<!--
  decision 
  Copay_CheckAmount
-->
<snippet>
  <code>
    <![CDATA[

	if (Runtime.GetData<decimal>("Output","Copay.CalculatedAmount") != 0.00M)
		return DecisionStatus.Success;
	else
		return DecisionStatus.Failure;

]]>
  </code>
</snippet>')
INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Copay_ScheduleTransaction','<?xml version="1.0" encoding="utf-8" ?>
<!--
  action
  Copay_ScheduleTransaction
-->
<snippet>
  <code>
    <![CDATA[
    
    	decimal trackedCopayRemaining = Runtime.GetData<decimal>("Output","CopayRemaining");

    	decimal calculatedAmount = Runtime.GetData<decimal>("Output","Copay.CalculatedAmount");

	Runtime.SetData("Output", "Copay.DeltaAmount", calculatedAmount);
	trackedCopayRemaining += calculatedAmount;
	
	Runtime.SetData("Output", "CopayRemaining", trackedCopayRemaining);
	
	
	Runtime.SetData("Output", "GeneratesTransactions", true);

	return ActionStatus.Executed;

]]>
  </code>
</snippet>')

INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Adjust_CPHasAdjustments','<?xml version="1.0" encoding="utf-8" ?>
<!--
  decision 
  Adjust_CPHasAdjustments
-->
<snippet>
  <code>
    <![CDATA[

	if (true == Runtime.GetData<bool>("CP","HasContractualAdjustments"))
		return DecisionStatus.Success;
	else
		return DecisionStatus.Failure;

]]>
  </code>
</snippet>')
INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Adjust_CPLVHasAdjustments','<?xml version="1.0" encoding="utf-8" ?>
<!--
  decision 
  Adjust_CPLVHasAdjustments
-->
<snippet>
  <code>
    <![CDATA[

	if (true == Runtime.GetData<bool>("CPLV","HasContractualAdjustments"))
		return DecisionStatus.Success;
	else
		return DecisionStatus.Failure;

]]>
  </code>
</snippet>')
INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Adjust_DPHasAdjustments','<?xml version="1.0" encoding="utf-8" ?>
<!--
  decision 
  Adjust_DPHasAdjustments
-->
<snippet>
  <code>
    <![CDATA[

	if (true == Runtime.GetData<bool>("DP","HasContractualAdjustments"))
		return DecisionStatus.Success;
	else
		return DecisionStatus.Failure;

]]>
  </code>
</snippet>')
INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Adjust_FDPHasAdjustments','<?xml version="1.0" encoding="utf-8" ?>
<!--
  decision 
  Adjust_FDPHasAdjustments
-->
<snippet>
  <code>
    <![CDATA[

	if (true == Runtime.GetData<bool>("FDP","HasContractualAdjustments"))
		return DecisionStatus.Success;
	else
		return DecisionStatus.Failure;

]]>
  </code>
</snippet>')
INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Adjust_PDPHasAdjustments','<?xml version="1.0" encoding="utf-8" ?>
<!--
  decision 
  Adjust_PDPHasAdjustments
-->
<snippet>
  <code>
    <![CDATA[

	if (true == Runtime.GetData<bool>("PDP","HasContractualAdjustments"))
		return DecisionStatus.Success;
	else
		return DecisionStatus.Failure;

]]>
  </code>
</snippet>')
INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Adjust_ScheduleAdjust','<?xml version="1.0" encoding="utf-8" ?>
<!--
  action
  Adjust_ScheduleAdjust
-->
<snippet>
  <code>
    <![CDATA[
    
       	decimal trackedChargeRemaining = Runtime.GetData<decimal>("Output","ChargeRemaining");

       	Dictionary<string,decimal> cpAdj = Runtime.GetData<Dictionary<string,decimal>>("CP","ContractualAdjustments");
    	Dictionary<string,decimal> externalAdj = Runtime.GetData<Dictionary<string,decimal>>("Claim", "ExternalAdjustments");
    	Dictionary<string,decimal> nonCurrentAdj = Runtime.GetData<Dictionary<string,decimal>>("Claim", "NonCurrentPaymentAdjustments");
    	Dictionary<string,decimal> reversalAdj = new Dictionary<string, decimal>();
    	
    	if (true == Runtime.ContainsData<Dictionary<string,decimal>>("Output","Reversal.AdjustmentTransactions"))
    		reversalAdj = Runtime.GetData<Dictionary<string,decimal>>("Output", "Reversal.AdjustmentTransactions");
    	
    	decimal originalCharge = Runtime.GetData<decimal>("CP","OriginalCharge");
    	decimal appliedSoFar = 0.0M;
    	decimal totalExternalAdjustments = 0.0M;
    	decimal totalNonCurrentAdjustments = 0.0M;
    	decimal totalReversed = 0.0M;
    	
    	Dictionary<string,decimal> resultingAdj = new Dictionary<string,decimal>();
    	
    	//first reverse all external adjustments

    	foreach (string type in externalAdj.Keys)
    	{
    		decimal externalAmount = externalAdj[type];

    		totalExternalAdjustments += externalAmount;
    		
    		if (externalAmount != 0.00M)
    		{
	    		Log("Rule", string.Format("Rev ext adj t{0} ${1}", type, externalAmount));
	    		resultingAdj.Add(type, -1 * externalAmount);
	    		trackedChargeRemaining += externalAmount;
	    	}
    	}

	//calculate non-current payment adjustment total
    	foreach (string type in nonCurrentAdj.Keys)
    	{
    		totalNonCurrentAdjustments += nonCurrentAdj[type];
    	}
    	
    	//reduce by external adjustments that were just reversed
    	totalNonCurrentAdjustments -= totalExternalAdjustments;
    	
	//calculate total reversed
	foreach (string type in reversalAdj.Keys)
	{
		totalReversed += reversalAdj[type];
	}
    			
    	foreach (string type in cpAdj.Keys)
    	{
    		decimal cpAmount = cpAdj[type];

    		decimal adjLeft = originalCharge - totalNonCurrentAdjustments - appliedSoFar - totalReversed;
    		decimal adjustmentAmount = cpAmount;
    		
    		if (adjustmentAmount > adjLeft)
    			adjustmentAmount = adjLeft;

		if (adjustmentAmount != 0.00M)
		{
			Log("Rule", string.Format("Adj t{0} ${1}", type, adjustmentAmount));
	    		resultingAdj.Add(type,adjustmentAmount);
	    		trackedChargeRemaining -= adjustmentAmount;
	    	}
    		
    		appliedSoFar += adjustmentAmount;
    	}
    	
	Runtime.SetData("Output", "Adjust.Adjustments", resultingAdj);
	Runtime.SetData("Output", "ChargeRemaining", trackedChargeRemaining);
	
	Runtime.SetData("Output", "GeneratesTransactions", true);

	return ActionStatus.Executed;

]]>
  </code>
  <imports>
    <import namespace="System.Collections.Generic" />
  </imports>  
</snippet>')
INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Adjust_ScheduleAdjustWithCPLV','<?xml version="1.0" encoding="utf-8" ?>
<!--
  action
  Adjust_ScheduleAdjustWithCPLV
-->
<snippet>
  <code>
    <![CDATA[
    
       	decimal trackedChargeRemaining = Runtime.GetData<decimal>("Output","ChargeRemaining");

    	Dictionary<string,decimal> cpAdj = Runtime.GetData<Dictionary<string,decimal>>("CP","ContractualAdjustments");
    	Dictionary<string,decimal> cplvAdj = Runtime.GetData<Dictionary<string,decimal>>("CPLV","ContractualAdjustments");
    	Dictionary<string,decimal> externalAdj = Runtime.GetData<Dictionary<string,decimal>>("Claim", "ExternalAdjustments");
    	Dictionary<string,decimal> nonCurrentAdj = Runtime.GetData<Dictionary<string,decimal>>("Claim", "NonCurrentPaymentAdjustments");
    	Dictionary<string,decimal> reversalAdj = new Dictionary<string, decimal>();
    	
    	if (true == Runtime.ContainsData<Dictionary<string,decimal>>("Output","Reversal.AdjustmentTransactions"))
    		reversalAdj = Runtime.GetData<Dictionary<string,decimal>>("Output", "Reversal.AdjustmentTransactions");
    	
    	decimal originalCharge = Runtime.GetData<decimal>("CP","OriginalCharge");
    	decimal appliedSoFar = 0.0M;
    	decimal totalExternalAdjustments = 0.0M;
    	decimal totalNonCurrentAdjustments = 0.0M;
    	decimal totalReversed = 0.0M;
    
    	Dictionary<string,decimal> resultingAdj = new Dictionary<string,decimal>();
    	
    	List<string> uniqueTypes = new List<string>();
    	
    	foreach (string type in cpAdj.Keys)
    		if (false == uniqueTypes.Contains(type))
    			uniqueTypes.Add(type);
    			
    	foreach (string type in cplvAdj.Keys)
    		if (false == uniqueTypes.Contains(type))
    			uniqueTypes.Add(type);

    	//first reverse all external adjustments

    	foreach (string type in externalAdj.Keys)
    	{
    		decimal externalAmount = externalAdj[type];

    		totalExternalAdjustments += externalAmount;
    		
    		if (externalAmount != 0.00M)
    		{
	    		Log("Rule", string.Format("Rev ext adj t{0} ${1}", type, externalAmount));
	    		resultingAdj.Add(type, -1 * externalAmount);
	    	}
    	}

	//calculate non-current payment adjustment total
    	foreach (string type in nonCurrentAdj.Keys)
    	{
    		totalNonCurrentAdjustments += nonCurrentAdj[type];
    	}
    	
    	//reduce by external adjustments that were just reversed
    	totalNonCurrentAdjustments -= totalExternalAdjustments;

	//calculate total reversed
	foreach (string type in reversalAdj.Keys)
	{
		totalReversed += reversalAdj[type];
	}
    			
    	foreach (string type in uniqueTypes)
    	{
    		decimal cpAmount = 0.0M, cplvAmount = 0.0M;
    		
    		if (true == cpAdj.ContainsKey(type))
    			cpAmount = cpAdj[type];
    		
    		if (true == cplvAdj.ContainsKey(type))
    			cplvAmount = cplvAdj[type];
    			
    		decimal adjLeft = originalCharge - totalNonCurrentAdjustments - appliedSoFar - totalReversed;
    		decimal adjustmentAmount = cpAmount - cplvAmount;
    		
    		if (adjustmentAmount > adjLeft)
    			adjustmentAmount = adjLeft;
    			
		if (adjustmentAmount != 0.00M)
		{
			Log("Rule", string.Format("Adj t{0} ${1}", type, adjustmentAmount));
	    		resultingAdj.Add(type,adjustmentAmount);
	    	}
    		
    		appliedSoFar += adjustmentAmount;
    	}
    	

	Runtime.SetData("Output", "Adjust.Adjustments", resultingAdj);
	Runtime.SetData("Output", "ChargeRemaining", trackedChargeRemaining);
	
	Runtime.SetData("Output", "GeneratesTransactions", true);

	return ActionStatus.Executed;

]]>
  </code>
  <imports>
    <import namespace="System.Collections.Generic" />
  </imports>  
</snippet>')
INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Adjust_ScheduleAdjustWithPDP','<?xml version="1.0" encoding="utf-8" ?>
<!--
  action
  Adjust_ScheduleAdjustWithPDP
-->
<snippet>
  <code>
    <![CDATA[
    
       	decimal trackedChargeRemaining = Runtime.GetData<decimal>("Output","ChargeRemaining");

    	Dictionary<string,decimal> cpAdj = Runtime.GetData<Dictionary<string,decimal>>("CP","ContractualAdjustments");
    	Dictionary<string,decimal> pdpAdj = Runtime.GetData<Dictionary<string,decimal>>("PDP","ContractualAdjustments");
    	Dictionary<string,decimal> externalAdj = Runtime.GetData<Dictionary<string,decimal>>("Claim", "ExternalAdjustments");
    	Dictionary<string,decimal> nonCurrentAdj = Runtime.GetData<Dictionary<string,decimal>>("Claim", "NonCurrentPaymentAdjustments");
    	Dictionary<string,decimal> reversalAdj = new Dictionary<string, decimal>();
    	
    	if (true == Runtime.ContainsData<Dictionary<string,decimal>>("Output","Reversal.AdjustmentTransactions"))
    		reversalAdj = Runtime.GetData<Dictionary<string,decimal>>("Output", "Reversal.AdjustmentTransactions");
    	
    	decimal originalCharge = Runtime.GetData<decimal>("CP","OriginalCharge");
    	decimal appliedSoFar = 0.0M;
    	decimal totalExternalAdjustments = 0.0M;
    	decimal totalNonCurrentAdjustments = 0.0M;
    	decimal totalReversed = 0.0M;
    	
    	Dictionary<string,decimal> resultingAdj = new Dictionary<string,decimal>();
    	
    	List<string> uniqueTypes = new List<string>();
    	
    	foreach (string type in cpAdj.Keys)
    		if (false == uniqueTypes.Contains(type))
    			uniqueTypes.Add(type);
    			
    	foreach (string type in pdpAdj.Keys)
    		if (false == uniqueTypes.Contains(type))
    			uniqueTypes.Add(type);

    	//first reverse all external adjustments

    	foreach (string type in externalAdj.Keys)
    	{
    		decimal externalAmount = externalAdj[type];

    		totalExternalAdjustments += externalAmount;
    		
    		if (externalAmount != 0.00M)
    		{
	    		Log("Rule", string.Format("Rev ext adj t{0} ${1}", type, externalAmount));
	    		resultingAdj.Add(type, -1 * externalAmount);
	    	}
    	}

	//calculate non-current payment adjustment total
    	foreach (string type in nonCurrentAdj.Keys)
    	{
    		totalNonCurrentAdjustments += nonCurrentAdj[type];
    	}
    	
    	//reduce by external adjustments that were just reversed
    	totalNonCurrentAdjustments -= totalExternalAdjustments;

	//calculate total reversed
	foreach (string type in reversalAdj.Keys)
	{
		totalReversed += reversalAdj[type];
	}

    	foreach (string type in uniqueTypes)
    	{
   		
    		decimal cpAmount = 0.0M, pdpAmount = 0.0M;
    		
    		if (true == cpAdj.ContainsKey(type))
    			cpAmount = cpAdj[type];
    		
    		if (true == pdpAdj.ContainsKey(type))
    			pdpAmount = pdpAdj[type];

    		decimal adjLeft = originalCharge - totalNonCurrentAdjustments - appliedSoFar - totalReversed;
    		decimal adjustmentAmount = cpAmount - pdpAmount;
    		
    		if (adjustmentAmount > adjLeft)
    			adjustmentAmount = adjLeft;
    			
		if (adjustmentAmount != 0.00M)
		{
			Log("Rule", string.Format("Adj t{0} ${1}", type, adjustmentAmount));
	    		resultingAdj.Add(type,adjustmentAmount);
	    	}
    		
    		appliedSoFar += adjustmentAmount;
    	}
    	

	Runtime.SetData("Output", "Adjust.Adjustments", resultingAdj);
	Runtime.SetData("Output", "ChargeRemaining", trackedChargeRemaining);
	
	Runtime.SetData("Output", "GeneratesTransactions", true);

	return ActionStatus.Executed;

]]>
  </code>
  <imports>
    <import namespace="System.Collections.Generic" />
  </imports>  
</snippet>')

INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Post_PrepareTransactions','<?xml version="1.0" encoding="utf-8" ?>
<!--
  action
  Post_PrepareTransactions
-->
<snippet>
  <code>
    <![CDATA[

	Log("Rule","Post Prep");
	
	List<PaymentClaimTransactionValues> transactions = new List<PaymentClaimTransactionValues>();
	
	Runtime.SetData("Output","Transactions", transactions);

	return ActionStatus.Executed;

]]>
  </code>
  <references>
    <reference strongname="Kareo.Superbill.Windows.Tasks" />
  </references>
  <imports>
    <import namespace="Kareo.Superbill.Windows.Tasks.Plugins.Payment" />
  </imports>  
</snippet>')

INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Post_Reopen','<?xml version="1.0" encoding="utf-8" ?>
<!--
  action
  Post_Reopen
-->
<snippet>
  <code>
    <![CDATA[

	//only reopen if other transactions are being applied
	if (true == Runtime.ContainsData<bool>("Output","ReopenClaim") 
		&& true == Runtime.ContainsData<bool>("Output", "GeneratesTransactions")
		&& true == Runtime.GetData<bool>("Output", "GeneratesTransactions"))
	{
		PaymentClaimTransactionValues tranREO = new PaymentClaimTransactionValues();
		tranREO.ClaimTransactionTypeCode = "REO";
		tranREO.Reversible = false;
		
		List<PaymentClaimTransactionValues> transactions = Runtime.GetData<List<PaymentClaimTransactionValues>>("Output","Transactions");
	
		transactions.Add(tranREO);
		
		Log("Rule::Transaction","REO");
	}

	return ActionStatus.Executed;

]]>
  </code>
  <references>
    <reference strongname="Kareo.Superbill.Windows.Tasks" />
  </references>
  <imports>
    <import namespace="Kareo.Superbill.Windows.Tasks.Plugins.Payment" />
  </imports>  
</snippet>')
INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Post_Reversal','<?xml version="1.0" encoding="utf-8" ?>
<!--
  action
  Post_Reversal
-->
<snippet>
  <code>
    <![CDATA[

	List<PaymentClaimTransactionValues> transactions = Runtime.GetData<List<PaymentClaimTransactionValues>>("Output","Transactions");

	if (true == Runtime.ContainsData<bool>("Output","ReverseSP") && true == Runtime.GetData<bool>("Output","ReverseSP"))
	{
		if (true == Runtime.ContainsData<decimal>("Output","Reversal.Payment"))
		{
			decimal paymentAmount = Runtime.GetData<decimal>("Output","Reversal.Payment");

			PaymentClaimTransactionValues tranPAY = new PaymentClaimTransactionValues();
			tranPAY.ClaimTransactionTypeCode = "PAY";
			tranPAY.Reversible = false;
			tranPAY.Amount = paymentAmount;

			transactions.Add(tranPAY);
			Log("Rule::Transaction::Reversal","PAY");
		}

		if (true == Runtime.ContainsData<decimal>("Output","Reversal.Copay"))
		{
			decimal copayAmount = Runtime.GetData<decimal>("Output","Reversal.Copay");

			PaymentClaimTransactionValues tranPRC = new PaymentClaimTransactionValues();
			tranPRC.ClaimTransactionTypeCode = "PRC";
			tranPRC.Reversible = false;
			tranPRC.Amount = copayAmount;

			transactions.Add(tranPRC);
			Log("Rule::Transaction::Reversal","PRC");
		}
		
		if (true == Runtime.ContainsData<Dictionary<string,decimal>>("Output","Reversal.AdjustmentTransactions"))
		{
			Dictionary<string,decimal> adjTransactions = Runtime.GetData<Dictionary<string,decimal>>("Output","Reversal.AdjustmentTransactions");
			
			foreach (string type in adjTransactions.Keys)
			{
				decimal adjAmount = adjTransactions[type];
				
				PaymentClaimTransactionValues tranADJ = new PaymentClaimTransactionValues();
				tranADJ.ClaimTransactionTypeCode = "ADJ";
				tranADJ.Reversible = false;
				tranADJ.Amount = adjAmount;
				tranADJ.AdjustmentReasonCode = type;
				
				transactions.Add(tranADJ);
				Log("Rule::Transaction::Reversal","ADJ");
			}
		}
	}

	return ActionStatus.Executed;

]]>
  </code>
  <references>
    <reference strongname="Kareo.Superbill.Windows.Tasks" />
  </references>
  <imports>
    <import namespace="Kareo.Superbill.Windows.Tasks.Plugins.Payment" />
  </imports>  
</snippet>')
INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Post_Adjustments','<?xml version="1.0" encoding="utf-8" ?>
<!--
  action
  Post_Adjustments
-->
<snippet>
  <code>
    <![CDATA[

	List<PaymentClaimTransactionValues> transactions = Runtime.GetData<List<PaymentClaimTransactionValues>>("Output","Transactions");

	if (true == Runtime.ContainsData<Dictionary<string,decimal>>("Output","Adjust.Adjustments"))
	{
		Dictionary<string,decimal> adjTransactions = Runtime.GetData<Dictionary<string,decimal>>("Output","Adjust.Adjustments");

		foreach (string type in adjTransactions.Keys)
		{
			decimal adjAmount = adjTransactions[type];

			PaymentClaimTransactionValues tranADJ = new PaymentClaimTransactionValues();
			tranADJ.ClaimTransactionTypeCode = "ADJ";
			tranADJ.Reversible = true;
			tranADJ.Amount = adjAmount;
			tranADJ.AdjustmentReasonCode = type;

			transactions.Add(tranADJ);
			Log("Rule::Transaction","ADJ");
		}
	}

	return ActionStatus.Executed;

]]>
  </code>
  <references>
    <reference strongname="Kareo.Superbill.Windows.Tasks" />
  </references>
  <imports>
    <import namespace="Kareo.Superbill.Windows.Tasks.Plugins.Payment" />
  </imports>  
</snippet>')
INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Post_Payments','<?xml version="1.0" encoding="utf-8" ?>
<!--
  action
  Post_Payments
-->
<snippet>
  <code>
    <![CDATA[

	List<PaymentClaimTransactionValues> transactions = Runtime.GetData<List<PaymentClaimTransactionValues>>("Output","Transactions");

	if (true == Runtime.ContainsData<decimal>("Output","Payments.PaymentAmount"))
	{
		decimal paymentAmount = Runtime.GetData<decimal>("Output","Payments.PaymentAmount");

		PaymentClaimTransactionValues tranPAY = new PaymentClaimTransactionValues();
		tranPAY.ClaimTransactionTypeCode = "PAY";
		tranPAY.Reversible = true;
		tranPAY.Amount = paymentAmount;

		transactions.Add(tranPAY);
		Log("Rule::Transaction","PAY");
	}

	return ActionStatus.Executed;

]]>
  </code>
  <references>
    <reference strongname="Kareo.Superbill.Windows.Tasks" />
  </references>
  <imports>
    <import namespace="Kareo.Superbill.Windows.Tasks.Plugins.Payment" />
  </imports>  
</snippet>')
INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Post_Copay','<?xml version="1.0" encoding="utf-8" ?>
<!--
  action
  Post_Copay
-->
<snippet>
  <code>
    <![CDATA[

	List<PaymentClaimTransactionValues> transactions = Runtime.GetData<List<PaymentClaimTransactionValues>>("Output","Transactions");

	if (true == Runtime.ContainsData<decimal>("Output","Copay.DeltaAmount"))
	{
		decimal deltaAmount = Runtime.GetData<decimal>("Output","Copay.DeltaAmount");

		PaymentClaimTransactionValues tranPRC = new PaymentClaimTransactionValues();
		tranPRC.ClaimTransactionTypeCode = "PRC";
		tranPRC.Reversible = true;
		tranPRC.Amount = deltaAmount;

		transactions.Add(tranPRC);
		Log("Rule::Transaction","PRC");
	}

	return ActionStatus.Executed;

]]>
  </code>
  <references>
    <reference strongname="Kareo.Superbill.Windows.Tasks" />
  </references>
  <imports>
    <import namespace="Kareo.Superbill.Windows.Tasks.Plugins.Payment" />
  </imports>  
</snippet>')

INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Denial_CPImpliesDenial','<?xml version="1.0" encoding="utf-8" ?>
<!--
  decision
  Denial_CPImpliesDenial
-->
<snippet>
  <code>
    <![CDATA[
    
    	decimal payments = 0.0M;
    	
    	if (true == Runtime.GetData<bool>("CP","HasPayments"))
    	{
    		payments = Runtime.GetData<decimal>("CP","SumPayments");
    	}
    	
    	decimal sumAdjustments = 0.0M;
    	
    	if (true == Runtime.GetData<bool>("CP","HasContractualAdjustments"))
    	{
	    	Dictionary<string,decimal> cpAdj = Runtime.GetData<Dictionary<string,decimal>>("CP","ContractualAdjustments");
	    	
	    	foreach (string type in cpAdj.Keys)
	    	{
	    		sumAdjustments += cpAdj[type];
	    	}
    	}
    	
    	decimal originalCharge = Runtime.GetData<decimal>("CP","OriginalCharge");

	//implies denial if no payments and contractual adjustments equal original charge    	
    	if (payments == 0.00M && sumAdjustments == originalCharge)
		return DecisionStatus.Success; 
	else
		return DecisionStatus.Failure;

]]>
  </code>
</snippet>')

INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'Copay_AdjustForBalanceProblems','<?xml version="1.0" encoding="utf-8" ?>
<!--
  action
  Copay_AdjustForBalanceProblems
-->
<snippet>
  <code>
    <![CDATA[
    
    	return ActionStatus.Executed;

	//COMMENTED OUT FOR NOW
	/*
    	decimal trackedCopayRemaining = Runtime.GetData<decimal>("Output","CopayRemaining");
    	decimal trackedChargeRemaining = Runtime.GetData<decimal>("Output","ChargeRemaining");

	decimal adjustAmount = trackedCopayRemaining - trackedChargeRemaining;
	
	if (adjustAmount > 0)
	{
		Log("Rule",string.Format("Copay greater than balance; adjust copay by ${0}", adjustAmount));
		
		decimal currentDelta = 0.0M;
		
		if (true == Runtime.ContainsData<decimal>("Output","Copay.DeltaAmount"))
			currentDelta = Runtime.GetData<decimal>("Output", "Copay.DeltaAmount");
			
		currentDelta -= adjustAmount;
		
		//note -- this can result in having an amount = 0, this should be addressed later
		
		Runtime.SetData("Output", "Copay.DeltaAmount", currentDelta);
		
		Runtime.SetData("Output", "GeneratesTransactions", true);
	}


	return ActionStatus.Executed;
	
	*/

]]>
  </code>
</snippet>')


COMMIT

/*
INSERT INTO ClientBusinessRule (ClientBusinessRuleSetID, ValidatingXmlSchemaCollectionName, RuleName, Definition) VALUES (@r, 'Schema_ClientBusinessRule_Rule',
'','')
*/

--ROLLBACK
