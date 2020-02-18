/* Add new Provider Taxonomy Code number type */
INSERT INTO [dbo].[ProviderNumberType]
           ([ProviderNumberTypeID]
           ,[TypeName]
           ,[ANSIReferenceIdentificationQualifier]
           ,[SortOrder]
           ,[RestrictInsuranceScope]
           ,[Active])
     VALUES (
			41,
			'Provider Taxonomy Code', 
			'ZZ', 
			230, 
			0,	
			1 )

GO