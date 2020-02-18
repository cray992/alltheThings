begin tran

	begin try

		select  '0' as AdjustmentCode ,'Default' as Description
		INTO #Reason
		union all
		select  '01','General Adjustment' 
		union all
		select  '02','Contractual Adjustment 1' 
		union all
		select  '03','Contractual Adjustment 2' 
		union all
		select  '04','Contractual Adjustment 3' 
		union all
		select  '05','Capitation Adjustment'
		union all
		select  '06','Out of Network Adjustment' 
		union all
		select  '07','Small Balance Adjustment' 
		union all
		select  '08','Courtesy/Charity Adjustment' 
		union all
		select  '09','Workers'' Comp Adjustment' 
		union all
		select  '10','Payment Correction Adjustment' 
		union all
		select  '11','IRS Tax Deduction' 
		union all
		select  '12','Patient Refund' 
		union all
		select  '13','Insurance Refund' 
		union all
		select  '14','Other Refund' 
		union all
		select  '15','Small Balance Write-Off' 
		union all
		select  '16','Collection Account Write-Off' 
		union all
		select  '17','Settlement Write-Off' 
		union all
		select  '18','Bad Debt Write-Off' 
		union all
		select  '19','Debit Adjustment' 
		union all
		select  '20','Credit Adjustment' 



		delete customerModel.dbo.adjustment
		delete customerModelPrepopulated.dbo.adjustment

		insert into customerModel.dbo.adjustment ( AdjustmentCode, Description )
		select AdjustmentCode, Description from #reason

		insert into customerModelPrepopulated.dbo.adjustment ( AdjustmentCode, Description )
		select AdjustmentCode, Description from #reason

		drop table #reason

		commit tran
	END try
	
	BEGIN catch
		rollback tran
	end catch


