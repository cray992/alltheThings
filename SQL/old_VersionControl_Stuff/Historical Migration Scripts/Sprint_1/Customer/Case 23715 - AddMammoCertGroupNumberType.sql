/* Case 23715: SF case 61770 - Add support for REF*EW segment in 2300 Loop */
IF NOT EXISTS (SELECT * FROM [dbo].[GroupNumberType] WHERE [GroupNumberTypeID] = 60)
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
			   (60
			   ,'Mammography Certification Number'
			   ,'EW'
			   ,380
			   ,'EW'
			   ,0
			   ,1)
END
GO