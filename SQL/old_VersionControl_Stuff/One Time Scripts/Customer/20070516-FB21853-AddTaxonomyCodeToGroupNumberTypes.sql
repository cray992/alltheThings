/*=============================================================================    
Case 21853 - Support the printing of provider taxomony code w/ ZZ qualifier 
in CMS-1500 box 33B  
=============================================================================*/

INSERT INTO [dbo].[GroupNumberType]
	([GroupNumberTypeID]
	,[TypeName]
	,[ANSIReferenceIdentificationQualifier]
	,[SortOrder]
	,[B2BIdentificationQualifier])
VALUES
	(59,
	'Provider Taxonomy Code',
	'ZZ',
	370,
	NULL)

GO