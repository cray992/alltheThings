
--This code is no longer accepted by the clearinghouse
--Set it to inactive
DECLARE @TypeIDINT INT
DECLARE @SortOrderINT INT
	
IF NOT EXISTS
(
	SELECT * FROM dbo.ProviderNumberType
	WHERE ANSIReferenceIdentificationQualifier = 'ZZ'
)
BEGIN
	SELECT 
		@TypeIDINT = MAX(ProviderNumberTypeID), 
		@SortOrderINT = MAX(SortOrder)
	FROM dbo.ProviderNumberType
	INSERT INTO dbo.ProviderNumberType
	        ( ProviderNumberTypeID ,
	          TypeName ,
	          ANSIReferenceIdentificationQualifier ,
	          SortOrder ,
	          RestrictInsuranceScope ,
	          Active ,
	          ShowInClaimSettings
	        )
	VALUES  ( @TypeIDINT + 1 , -- ProviderNumberTypeID - int
	          'Provider Taxonomy Code' , -- TypeName - varchar(50)
	          'ZZ' , -- ANSIReferenceIdentificationQualifier - char(2)
	          @SortOrderINT + 10, -- SortOrder - int
	          0 , -- RestrictInsuranceScope - bit
	          0 , -- Active - bit
	          0  -- ShowInClaimSettings - bit
	        )
END
ELSE
BEGIN
	UPDATE dbo.ProviderNumberType
	SET Active = 0--, ShowInClaimSettings = 0
	WHERE ANSIReferenceIdentificationQualifier = 'ZZ'
END


IF NOT EXISTS
(
	SELECT * FROM dbo.GroupNumberType
	WHERE ANSIReferenceIdentificationQualifier = 'ZZ'
)
BEGIN
	SELECT 
		@TypeIDINT = MAX(GroupNumberTypeID), 
		@SortOrderINT = MAX(SortOrder)
	FROM dbo.GroupNumberType
	
	INSERT INTO dbo.GroupNumberType
	        ( GroupNumberTypeID ,
	          TypeName ,
	          ANSIReferenceIdentificationQualifier ,
	          SortOrder ,
	          B2BIdentificationQualifier ,
	          RestrictInsuranceScope ,
	          Active ,
	          ShowInClaimSettings
	        )
	VALUES  ( @TypeIDINT + 1, -- GroupNumberTypeID - int
	          'Provider Taxonomy Code' , -- TypeName - varchar(50)
	          'ZZ' , -- ANSIReferenceIdentificationQualifier - char(2)
	          @SortOrderINT + 10  , -- SortOrder - int
	          '' , -- B2BIdentificationQualifier - char(2)
	          0 , -- RestrictInsuranceScope - bit
	          0 , -- Active - bit
	          0  -- ShowInClaimSettings - bit
	        )
END
ELSE
BEGIN
	UPDATE dbo.GroupNumberType
	SET Active = 0--, ShowInClaimSettings = 0
	WHERE ANSIReferenceIdentificationQualifier = 'ZZ'
END