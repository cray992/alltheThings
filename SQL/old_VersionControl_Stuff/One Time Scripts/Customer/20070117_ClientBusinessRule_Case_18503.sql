BEGIN TRAN

UPDATE ClientBusinessRule SET Definition='<?xml version="1.0" encoding="utf-8" ?>
<!--
  action
  Crossover_setClaimErrorState
-->
<snippet>
  <code>
    <![CDATA[

	Runtime.SetData("Output", "ClaimInError", true);
	Runtime.SetData("Output", "ClaimErrorMessage", "A crossover is specified, but there is no next institutional payer for this service line.");
	Runtime.SetData("Output", "ClaimSeverity", 3);

	return ActionStatus.Executed;
]]>
  </code>
</snippet>' WHERE RuleName='Crossover_setClaimErrorState' AND ClientBusinessRuleSetID = (SELECT ClientBusinessRuleSetID FROM ClientBusinessRuleSet WHERE Name='InsurancePaymentProcessing')

UPDATE ClientBusinessRuleSet SET RuleSet = '<?xml version="1.0" encoding="utf-8"?>
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
  <action id="Crossover_setClaimErrorState" src="database://InsurancePaymentProcessing/Crossover_setClaimErrorState" nextRef="ErrorUnset_CPIsError" />
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
  
</ruleset>' WHERE Name = 'InsurancePaymentProcessing'

/*
UPDATE ClientBusinessRule SET Definition='' WHERE RuleName='' AND ClientBusinessRuleSetID = (SELECT ClientBusinessRuleSetID FROM ClientBusinessRuleSet WHERE Name='InsurancePaymentProcessing')

UPDATE ClientBusinessRuleSet SET RuleSet = '' WHERE Name = 'InsurancePaymentProcessing'
*/

--ROLLBACK
COMMIT