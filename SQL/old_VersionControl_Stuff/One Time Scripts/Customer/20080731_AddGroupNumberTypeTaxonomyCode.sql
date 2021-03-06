IF NOT EXISTS (
	SELECT	*
	FROM	[dbo].[GroupNumberType]
	WHERE	[GroupNumberTypeID] = 59
)
BEGIN
INSERT INTO [dbo].[GroupNumberType]
           ([GroupNumberTypeID]
           ,[TypeName]
           ,[ANSIReferenceIdentificationQualifier]
           ,[SortOrder]
           ,[B2BIdentificationQualifier]
           ,[RestrictInsuranceScope]
           ,[Active])
     VALUES
           (59,
			'Provider Taxonomy Code',
			'ZZ',
			370,	
			NULL, 
			0, 
			1)
END
GO