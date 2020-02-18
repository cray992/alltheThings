-- case 12151 
-- adding new payerscenario types and assign these types to the existing payerscenario

-- excluding two DBs with custom set of payerscenarios
if DB_Name()<>'SUPERBILL_0096_PROD' and DB_Name()<>'SUPERBILL_0218_PROD'
begin
	insert into payerscenarioType ([Name]) values ('Attorney Lien')	-- 3 
	update PayerScenario set PayerScenarioTypeID=3 where PayerScenarioID=1

	insert into PayerScenarioType ([Name]) values ('Workers Comp')	-- 4
	update PayerScenario set PayerScenarioTypeID=4 where PayerScenarioID in (13, 15, 16)
end