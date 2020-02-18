-- SF 85553 - Fix to update an existing adjustment of the same type instead of trying to add an adjustment of the same type.
UPDATE	ClientBusinessRule
SET		Definition = '<?xml version="1.0" encoding="utf-8" ?>
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
    	
    	//Log("Rule",string.Format("External adjustment count: {0}", externalAdj.Count.ToString()));

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
          if(resultingAdj.ContainsKey(type))
          {
              resultingAdj[type] += adjustmentAmount;
              Log("Rule", string.Format("Adding to existing Adj t{0} total ${1}", type, resultingAdj[type]));
          }
          else
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
</snippet>'
WHERE	ClientBusinessRuleID = 44
AND		RuleName = 'Adjust_ScheduleAdjust'