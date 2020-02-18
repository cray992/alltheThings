-- SF 6255, FB 21247 - minor fix for payment business rule Adjust_ScheduleAdjustWithPDP
update clientbusinessrule set definition = 
'<?xml version="1.0" encoding="utf-8" ?>
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
    	
    	foreach (string type in pdpAdj.Keys)
    		if (false == uniqueTypes.Contains(type))
    			uniqueTypes.Add(type);

    	foreach (string type in cpAdj.Keys)
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
</snippet>'
where rulename='Adjust_ScheduleAdjustWithPDP'