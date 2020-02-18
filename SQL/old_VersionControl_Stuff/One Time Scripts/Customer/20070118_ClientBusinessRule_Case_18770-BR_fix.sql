BEGIN TRAN

UPDATE ClientBusinessRule SET Definition='<?xml version="1.0" encoding="utf-8" ?>
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
	bool claimPaidTrackingEnabled = false;
	
	if (true == Runtime.ContainsData<bool>("CP","ClaimPaidTrackingEnabled"))
		claimPaidTrackingEnabled = Runtime.GetData<bool>("CP","ClaimPaidTrackingEnabled");
	
	decimal reversalAmount = 0.0M;
	
	if (true == Runtime.ContainsData<decimal>("Output","Reversal.Payment"))
		reversalAmount = Runtime.GetData<decimal>("Output","Reversal.Payment");
		
	//would get the unapplied amount reduced by the (negative) reversal amount
	decimal unappliedAmount = cpAmount - reversalAmount;
    	

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
	
	
	//we are posting an ERA
	if (true == claimPaidTrackingEnabled)
	{
		decimal claimPaidUnappliedAmount = Runtime.GetData<decimal>("CP","ClaimPaidUnappliedAmount");
		
		decimal claimPaidWithReversal = claimPaidUnappliedAmount - reversalAmount;
		
		Log("Rule",string.Format("Service line overpayment; calculated = {0}, claimUnapplied = {1}, rev = {2}", calculatedAmount, claimPaidUnappliedAmount, reversalAmount));
		
		if (calculatedAmount > claimPaidWithReversal)
		{
			Runtime.SetData("Output", "Payments.CalculatedAmount", claimPaidWithReversal);

			calculatedAmount = claimPaidWithReversal;

			Runtime.SetData("Output", "ClaimInError", true);
			Runtime.SetData("Output", "ErrorSeverity", 3);
			Runtime.SetData("Output", "ClaimErrorMessage", "The payer reported a payment on the service line that is greater than the total payment on the claim. The payment for this service line has been reduced to the claim payment amount.");
		}
	}
	

	//this check is not really necessary as it is being done in the last step
	if (unappliedAmount < calculatedAmount)
	{
		Runtime.SetData("Output", "Payments.CalculatedAmount", unappliedAmount);
		
		calculatedAmount = unappliedAmount;
		
		Runtime.SetData("Output", "ClaimInError", true);
		Runtime.SetData("Output", "ErrorSeverity", 3);
		Runtime.SetData("Output", "ClaimErrorMessage", "The payment for this service line was reduced in order to fit into the unapplied amount left on the payment.");
	}	
	
	return ActionStatus.Executed;

]]>
  </code>
</snippet>' WHERE RuleName='Payments_AdjustAmountToCP' 
AND ClientBusinessRuleSetID = (SELECT ClientBusinessRuleSetID FROM ClientBusinessRuleSet WHERE Name='InsurancePaymentProcessing')

UPDATE ClientBusinessRule SET Definition='<?xml version="1.0" encoding="utf-8" ?>
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
	bool claimPaidTrackingEnabled = false;
	
	if (true == Runtime.ContainsData<bool>("CP","ClaimPaidTrackingEnabled"))
		claimPaidTrackingEnabled = Runtime.GetData<bool>("CP","ClaimPaidTrackingEnabled");
		
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
		
	//we are posting an ERA
	if (true == claimPaidTrackingEnabled)
	{
		decimal claimPaidUnappliedAmount = Runtime.GetData<decimal>("CP","ClaimPaidUnappliedAmount");
		
		decimal claimPaidWithReversal = claimPaidUnappliedAmount - reversalAmount;
		
		if (paymentAmount > claimPaidWithReversal)
			fits = false;
	}
		
		
	if (true == fits)
		return DecisionStatus.Success;
	else
		return DecisionStatus.Failure;

]]>
  </code>
</snippet>' WHERE RuleName='Payments_AmountFitsIntoCP' 
AND ClientBusinessRuleSetID = (SELECT ClientBusinessRuleSetID FROM ClientBusinessRuleSet WHERE Name='InsurancePaymentProcessing')


/*
UPDATE ClientBusinessRule SET Definition='' WHERE RuleName='' AND ClientBusinessRuleSetID = (SELECT ClientBusinessRuleSetID FROM ClientBusinessRuleSet WHERE Name='')
*/

--ROLLBACK
COMMIT