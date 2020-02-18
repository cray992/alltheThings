begin tran

-- Update the link from http://www.medavanthealth.com/payerlist/agreements to http://www.capario.com/services/resource_center/payer/list/agreements
UPDATE	PayerExtraParams
SET		ParamValue = replace(ParamValue, 'http://www.medavanthealth.com/payerlist/agreements', 'http://www.capario.com/services/resource_center/payer/list/agreements')
WHERE	ParamName like '%url' 
AND		ParamValue like 'http://www.medavanthealth.com/payerlist/agreements%'

-- Update the link from http://www.medavanthealth.com/payerlist/ERAagreements to http://www.capario.com/services/resource_center/payer/list/ERAagreements
UPDATE	PayerExtraParams
SET		ParamValue = replace(ParamValue, 'http://www.medavanthealth.com/payerlist/ERAagreements', 'http://www.capario.com/services/resource_center/payer/list/ERAagreements')
WHERE	ParamName like '%url' 
AND		ParamValue like 'http://www.medavanthealth.com/payerlist/ERAagreements%'

commit tran