if not exists(select * from [ProviderNumberType] where [ProviderNumberTypeID]=42)
	INSERT INTO [ProviderNumberType]
			   ([ProviderNumberTypeID]
			   ,[TypeName]
			   ,[ANSIReferenceIdentificationQualifier]
			   ,[SortOrder]
			   ,[RestrictInsuranceScope]
			   ,[Active])
		 VALUES
			   (42
			   ,'Provider NPI Override'
			   ,'XX'
			   ,350
			   ,0
			   ,1)


if not exists(select * from [GroupNumberType] where [GroupNumberTypeID]=61)
	INSERT INTO [GroupNumberType]
			   ([GroupNumberTypeID]
			   ,[TypeName]
			   ,[ANSIReferenceIdentificationQualifier]
			   ,[SortOrder]
			   ,[B2BIdentificationQualifier]
			   ,[RestrictInsuranceScope]
			   ,[Active])
		 VALUES
			   (61
			   ,'Practice Override NPI'
			   ,'XX'
			   ,390
			   ,'XX'
			   ,0
			   ,1)
