UPDATE ClientBusinessRule
SET ModifiedDate = getdate(),
	Definition = '<?xml version="1.0" encoding="utf-8" ?>
<!--
  action
  Copay_CalculateAmount
-->
<snippet>
  <code>
    <![CDATA[

  decimal amount = 0;
  bool hasNextInstitutionalPayer = Runtime.GetData<bool>("Claim", "HasNextInstitutionalPayer");
  
  if(!hasNextInstitutionalPayer)
  {
	  decimal cpCopay = Runtime.GetData<decimal>("CP","CopayNeeded");
	  decimal claimCopay = Runtime.GetData<decimal>("Claim","CopayNeeded");
  	
	  Log("Rule",string.Format("CP/Claim Copay ${0}/${1}", cpCopay, claimCopay));
  	
	  amount = cpCopay - claimCopay;
  }
  else
  {
	  Log("Rule","Copay calculation skipped due to subsequent payers present");
  }

  Runtime.SetData("Output", "Copay.CalculatedAmount", amount);

	return ActionStatus.Executed;

]]>
  </code>
</snippet>'
WHERE RuleName = 'Copay_CalculateAmount'