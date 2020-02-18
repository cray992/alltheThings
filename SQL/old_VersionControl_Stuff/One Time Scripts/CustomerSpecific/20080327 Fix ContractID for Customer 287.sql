--use superbill_0278bk_prod


update encounterProcedure
set contractID = 46
where 
practiceID = 23 
and encounterProcedureID in
	(

		--TODO: this procedure can be improved use function instead
		SELECT distinct encounterProcedureID
		FROM ContractFeeSchedule, [Contract],
					
		(
			select ProcedureCodeDictionaryID, e.DateOfService, e.encounterID, ep.encounterProcedureID, LocationID, e.doctorID, 
				ProcedureModifier1, DiagnosisCodeDictionaryID, p.gender
			from encounterProcedure ep
				inner join encounter e on e.encounterID = ep.encounterID
				inner join patient p on p.patientID = e.patientID
				inner join EncounterDiagnosis ed on ed.EncounterDiagnosisID = ep.EncounterDiagnosisID1
			where e.createdDate between '3/18/08' and '3/20/08 23:59:59'
				and e.practiceID = 23
				and ep.contractID is null
		) as v

		WHERE
			Contract.ContractID=ContractFeeSchedule.ContractID and
			ContractFeeSchedule.ProcedureCodeDictionaryID=v.ProcedureCodeDictionaryID and 
			DateOfService between EffectiveStartDate and EffectiveEndDate and
			-- check for contract for payer specific contract
--			[Contract].ContractType='S' and

			exists (SELECT * FROM ContractToServiceLocation WHERE ContractID=[CONTRACT].ContractID and ServiceLocationID=LocationID) and
			-- check for doctor
			exists (SELECT * FROM ContractToDoctor WHERE ContractToDoctor.ContractID=[CONTRACT].ContractID and DoctorID=doctorID) and 

			-- check for Gender
			(ContractFeeSchedule.Gender=v.Gender or ContractFeeSchedule.Gender='B') and

			-- check for the modifier -- TODO: try to improve it 
			(IsNull(ProcedureModifier1, '') = IsNull(ContractFeeSchedule.Modifier, '') or 
				(ProcedureModifier1 is not null and (ContractFeeSchedule.Modifier= ProcedureModifier1 or IsNull(ContractFeeSchedule.Modifier,'')=''))) and

			-- check fot the diagnosis
			(IsNull(v.DiagnosisCodeDictionaryID, '')=IsNull(ContractFeeSchedule.DiagnosisCodeDictionaryID, '') or
				(v.DiagnosisCodeDictionaryID is not null and (ContractFeeSchedule.DiagnosisCodeDictionaryID=v.DiagnosisCodeDictionaryID or IsNull(ContractFeeSchedule.DiagnosisCodeDictionaryID, '')='')))

	)	

	

return
--
--select * from procedureCodeDictionary
--where procedureCodeDictionaryID = 29610
--			
--
--			select e.createdDate, ProcedureCodeDictionaryID, e.DateOfService, e.encounterID, ep.encounterProcedureID, LocationID, e.doctorID, 
--				ProcedureModifier1, DiagnosisCodeDictionaryID, p.gender
--			from encounterProcedure ep
--				inner join encounter e on e.encounterID = ep.encounterID
--				inner join patient p on p.patientID = e.patientID
--				inner join EncounterDiagnosis ed on ed.EncounterDiagnosisID = ep.EncounterDiagnosisID1
--			where e.createdDate between '3/18/08' and '3/20/08 23:59:59'
--				and e.practiceID = 23
--				and ep.contractID is null
--			order by ProcedureCodeDictionaryID, e.createdDate
