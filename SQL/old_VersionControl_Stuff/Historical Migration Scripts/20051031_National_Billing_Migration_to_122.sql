/*======================= 122 Import =======================================
=============================================================================
=============================================================================
*/
--=====================   Create functions   =======================================



-----------fn_ChooseNotNullValue




/*
returns @sValue1 f it is not null, 
if @sValue1 is null then returns @sValue2 if it is not null,
otherwise returns null
*/
CREATE  FUNCTION fn_ChooseNotNullValue(@sValue1 varchar(255), @sValue2 varchar(255))
RETURNS varchar(255) AS  
BEGIN 
	DECLARE @temp varchar(255)
	IF @sValue1 IS NOT NULL AND LEN(LTRIM(RTRIM(@sValue1)))>0
		set @temp = @sValue1
	ELSE IF @sValue2 IS NOT NULL AND LEN(LTRIM(RTRIM(@sValue2)))>0
		set @temp =  @sValue2
	ELSE
	        set @temp =  NULL

RETURN @temp
 
END
GO






/* 
If diagnosis code @sInput is longer than three characters, 
inserts '.' after the thirsd character and returns the formatted diagnosis code value
*/

CREATE  FUNCTION fn_FormatDiagnosisCode(@sInput varchar(50))
RETURNS varchar(50) AS  
BEGIN 
	
	DECLARE @sTemp varchar(50);
	DECLARE @sCode varchar(50);

	
	DECLARE @InputLen int;
	DECLARE @iCurrentPos int;
	DECLARE @CurrentChar char(1);



	IF @sInput IS NULL
		SELECT @sTemp = '';
	ELSE 
		BEGIN
		
			SET @sCode = LTRIM(RTRIM(@sInput))
			IF LEN(@sCode) < 4 
					SELECT @sTemp =    @sCode;
			ELSE
				SELECT  @sTemp = SUBSTRING(@sCode,1, 3) + '.' + SUBSTRING(@sCode,4,LEN(@sCode)-3)
		END


	
	
	RETURN @sTemp;
	
END
GO



/*
returns @serviceLocation if it is not an empty string
'99' = "other locations" otherwise
*/
CREATE  FUNCTION fn_GetServiceLocationCode(@serviceLocation varchar(255))
RETURNS varchar(255) AS  
BEGIN
	DECLARE @temp varchar(255)
	DECLARE @sl varchar(255)

	SET @sl = LTRIM(RTRIM(@serviceLocation))

	IF LEN(@sl) =  0
		set @temp = '99'
	ELSE 
		set @temp =  @sl


	RETURN	@temp

END

GO





/*
returns 'Mr.' if the gender - @sGender is 'M'
'Ms.' if the ender - @sGender is 'F'
'' - otherwise
*/

CREATE  FUNCTION fn_PrefixFromGender(@sGender varchar(255))
RETURNS char(3) AS  
BEGIN
	DECLARE @temp char(3)
	DECLARE @gender varchar(255)
	SELECT @gender = LTRIM(RTRIM(UPPER(@sGender)))


	IF @gender = 'M'
		SET @temp = 'Mr.'
	ELSE IF @gender ='F'
		SET @temp = 'Ms.'
	ELSE 
		SET @temp=''
	RETURN	@temp

END


GO





/*
Removes '-' and ' ' from @sInputString
Used to format Social Security numbers for Instance 
*/
CREATE  FUNCTION fn_RemoveDashNSpace(@sInputString varchar(255))
RETURNS varchar(255) AS  
BEGIN

RETURN	LTRIM(RTRIM(REPLACE(REPLACE(@sInputString,'-',''),' ','' )))

END

GO

CREATE FUNCTION dbo.fn_ConvertToValidTimeOrNull(@dtDate varchar(255))
RETURNS datetime AS  
BEGIN 
	DECLARE @TempDate datetime;


	IF ISDATE(@dtDate) = 1
		SET @TempDate = Convert(DateTime, @dtDate)  
	ELSE 
		SET @TempDate = NULL

	RETURN @TempDate;
END



GO



/*======================== IMPORT Insurance.txt ================================================================
 InsuranceImported table is presumed as been created during execution of  
 "National Billing Cust 122 (Insurance.txt)" DTS package  
*/
ALTER TABLE InsuranceCompany ADD VendorID VARCHAR(255) NULL
GO


INSERT INTO dbo.InsuranceCompany 
(InsuranceCompanyName, AddressLine1, AddressLine2, City, State, ZipCode, Phone, PhoneExt, Fax, VendorID)
SELECT [Name], [Address 1], [Address 2], [City], [State], dbo.fn_RemoveDashNSpace([Zip Code]), 
[Phone], [Extension], [Fax], [Code] 
FROM [dbo].[InsuranceImported]

ALTER TABLE InsuranceCompanyPlan ADD VendorID VARCHAR(255) NULL
GO

/*copies the data from dbo.InsuranceCompany creating thus one-to-one relation*/

INSERT INTO dbo.InsuranceCompanyPlan
(PlanName, InsuranceCompanyID,  AddressLine1, AddressLine2, City, State, ZipCode, 
Phone, PhoneExt, Fax, VendorID)
SELECT InsuranceCompanyName, InsuranceCompanyID,  AddressLine1, AddressLine2, 
City, State, ZipCode, Phone, PhoneExt, Fax, VendorID
		FROM dbo.InsuranceCompany

/*=======================  Import Patient.txt =====================================================
PatientImported table presumed as been created during execution of 
"National Billing Cust 122 (Patient.txt)" DTS package. 
The following script creates an identical PatientImported_WithID table 
but with an additional identity field PatientImportedID
*/
CREATE TABLE [PatientImported_WithID] (
	[Chart Number] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[First Name] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Last Name] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Middle Initial] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Address 1] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Address 2] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[City] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[State] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Zip Code] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Work Phone] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Work Extension] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Home Phone] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Social Security Number] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Sex] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Marital Status] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Date Of Birth] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Employer] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Employer Name] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Employer Address 1] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Employer Address 2] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Employer City] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Employer State] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Employer Zip] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Provider] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Patient Code] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Patient Type] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Hold Code 1] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Hold Code 2] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Hold Code 3] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Hold Code 4] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Hold Code 5] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Managed Care] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Managed Plan] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Managed Payment] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Balance] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Charges] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Payments] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Last Payment] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Last Payment Date] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Insurance Code 1] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Insurance Type 1] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Insurance Group Number 1] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Insurance Insured ID 1] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Insurance Insured Is 1] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Insurance Insured 1] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Insurance Insured Relation 1] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Insurance Auto Bill 1] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Insurance Authorization 1] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Insurance Accept Assignment 1] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Insurance Code 2] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Insurance Type 2] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Insurance Group Number 2] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Insurance Insured ID 2] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Insurance Insured Is 2] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Insurance Insured 2] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Insurance Insured Relation 2] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Insurance Auto Bill 2] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Insurance Authorization 2] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Insurance Accept Assignment 2] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Insurance Code 3] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Insurance Type 3] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Insurance Group Number 3] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Insurance Insured ID 3] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Insurance Insured Is 3] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Insurance Insured 3] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Insurance Insured Relation 3] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Insurance Auto Bill 3] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Insurance Authorization 3] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Insurance Accept Assignment 3] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Symptom Type] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Symptom Date] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Similar Symptom] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Similar Date] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Accident Type] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Accident Date] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Accident State] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Employment Related] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Emergency] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Last XRay] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Consultation 1] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Consultation 2] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Total Disability 1] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Total Disability 2] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Partial Disability 1] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Partial Disability 2] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Hospitalization 1] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Hospitalization 2] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Return Work] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Return Work Date] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Status] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Death Date] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Lab Charge] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Lab Charge Amount] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Facility] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Referring Physician] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Attorney] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Months Treated] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Employment Status] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Student Status] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Signature On File] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Release Information] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EPSDT] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Family Planning] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Percent Disability] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Third Party Liability] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Service Branch] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Service Status] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Service Grade] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Service Card Effective 1] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Service Card Effective 2] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Non Available] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Service Handicapped] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Ambulatory Surgery] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Subluxation 1] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Subluxation 2] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Permanent Diagnosis 1] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Permanent Diagnosis 2] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Permanent Diagnosis 3] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Permanent Diagnosis 4] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Permanent Diagnosis 5] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 1] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 2] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 3] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 4] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 5] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 6] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 7] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 8] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 9] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 10] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 11] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 12] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 13] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 14] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 15] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 16] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 17] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 18] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 19] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 20] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 21] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 22] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 23] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 24] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 25] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 26] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 27] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 28] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 29] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 30] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 31] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 32] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 33] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 34] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 35] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 36] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 37] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 38] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 39] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 40] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 41] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 42] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 43] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 44] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 45] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 46] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 47] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 48] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 49] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 50] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Responsible Is] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Responsible] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Last Visit] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Referring Patient] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Inactive] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Auto Bill Patient] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Co Pay] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Insurance PCA Claim Number 1] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Insurance PCA Claim Number 2] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Insurance PCA Claim Number 3] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 51] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 52] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 53] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 54] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 55] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 56] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 57] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 58] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 59] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 60] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 61] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 62] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 63] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 64] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 65] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 66] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 67] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 68] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 69] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 70] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 71] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 72] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 73] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 74] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Custom Fields 75] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Release Of Information Date] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Medicaid Resubmission No] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Medicaid Original Ref No] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Date Last Seen PCP] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Primary Care Provider] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Nature Of Condition] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Complication Indicator] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EPSDT Findings] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EPSDT Referral Items] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[External Cause Of Accident] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Podiatry Therapy Type] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Systemic Condition] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Class Findings] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[New Patient Date] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Notes Reminder Code] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Created Date] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Modified Date] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Main Phone] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Fax Phone] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Mobile Phone] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Pager Phone] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Other Phone] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Home Email] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Work Email] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Contact Name] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Contact Phone] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Contact Note] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Patient Weight] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Weight Units] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Referral Date] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Pregnancy Indicator] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Estimated Date Of Birth] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Prescription Date] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Last Worked Date] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Date Assumed Care] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Date Relinquished Care] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Reference ID Qualifier] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Service Authorization Exception Code] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Homebound Indicator] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Supervising Physician] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[IDE Number] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Fee Schedule Type] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Collection Status] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Entity Type] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PatientImportedID] [int] IDENTITY (10, 10) NOT NULL 
) ON [PRIMARY]
GO


/*
Copy the data from PatientImported into PatientImported_WithID. That would assign the identity to each
Patient original record
*/
INSERT INTO [dbo].[PatientImported_WithID]([Chart Number], 
[First Name], [Last Name], [Middle Initial], [Address 1], [Address 2], [City], [State], [Zip Code], [Work Phone], [Work Extension], [Home Phone], [Social Security Number], [Sex], [Marital Status], [Date Of Birth], [Employer], [Employer Name], [Employer Address 1], [Employer Address 2], [Employer City], [Employer State], [Employer Zip], [Provider], [Patient Code], [Patient Type], [Hold Code 1], [Hold Code 2], [Hold Code 3], [Hold Code 4], [Hold Code 5], [Managed Care], [Managed Plan], [Managed Payment], [Balance], [Charges], [Payments], [Last Payment], [Last Payment Date], [Insurance Code 1], [Insurance Type 1], [Insurance Group Number 1], [Insurance Insured ID 1], [Insurance Insured Is 1], [Insurance Insured 1], [Insurance Insured Relation 1], [Insurance Auto Bill 1], [Insurance Authorization 1], [Insurance Accept Assignment 1], [Insurance Code 2], [Insurance Type 2], [Insurance Group Number 2], [Insurance Insured ID 2], [Insurance Insured Is 2], [Insurance Insured 2], [Insurance Insured Relation 2], [Insurance Auto Bill 2], [Insurance Authorization 2], [Insurance Accept Assignment 2], [Insurance Code 3], [Insurance Type 3], [Insurance Group Number 3], [Insurance Insured ID 3], [Insurance Insured Is 3], [Insurance Insured 3], [Insurance Insured Relation 3], [Insurance Auto Bill 3], [Insurance Authorization 3], [Insurance Accept Assignment 3], [Symptom Type], [Symptom Date], [Similar Symptom], [Similar Date], [Accident Type], [Accident Date], [Accident State], [Employment Related], [Emergency], [Last XRay], [Consultation 1], [Consultation 2], [Total Disability 1], [Total Disability 2], [Partial Disability 1], [Partial Disability 2], [Hospitalization 1], [Hospitalization 2], [Return Work], [Return Work Date], [Status], [Death Date], [Lab Charge], [Lab Charge Amount], [Facility], [Referring Physician], [Attorney], [Months Treated], [Employment Status], [Student Status], [Signature On File], [Release Information], [EPSDT], [Family Planning], [Percent Disability], [Third Party Liability], [Service Branch], [Service Status], [Service Grade], [Service Card Effective 1], [Service Card Effective 2], [Non Available], [Service Handicapped], [Ambulatory Surgery], [Subluxation 1], [Subluxation 2], [Permanent Diagnosis 1], [Permanent Diagnosis 2], [Permanent Diagnosis 3], [Permanent Diagnosis 4], [Permanent Diagnosis 5], [Custom Fields 1], [Custom Fields 2], [Custom Fields 3], [Custom Fields 4], [Custom Fields 5], [Custom Fields 6], [Custom Fields 7], [Custom Fields 8], [Custom Fields 9], [Custom Fields 10], [Custom Fields 11], [Custom Fields 12], [Custom Fields 13], [Custom Fields 14], [Custom Fields 15], [Custom Fields 16], [Custom Fields 17], [Custom Fields 18], [Custom Fields 19], [Custom Fields 20], [Custom Fields 21], [Custom Fields 22], [Custom Fields 23], [Custom Fields 24], [Custom Fields 25], [Custom Fields 26], [Custom Fields 27], [Custom Fields 28], [Custom Fields 29], [Custom Fields 30], [Custom Fields 31], [Custom Fields 32], [Custom Fields 33], [Custom Fields 34], [Custom Fields 35], [Custom Fields 36], [Custom Fields 37], [Custom Fields 38], [Custom Fields 39], [Custom Fields 40], [Custom Fields 41], [Custom Fields 42], [Custom Fields 43], [Custom Fields 44], [Custom Fields 45], [Custom Fields 46], [Custom Fields 47], [Custom Fields 48], [Custom Fields 49], [Custom Fields 50], [Responsible Is], [Responsible], [Last Visit], [Referring Patient], [Inactive], [Auto Bill Patient], [Co Pay], [Insurance PCA Claim Number 1], [Insurance PCA Claim Number 2], [Insurance PCA Claim Number 3], [Custom Fields 51], [Custom Fields 52], [Custom Fields 53], [Custom Fields 54], [Custom Fields 55], [Custom Fields 56], [Custom Fields 57], [Custom Fields 58], [Custom Fields 59], [Custom Fields 60], [Custom Fields 61], [Custom Fields 62], [Custom Fields 63], [Custom Fields 64], [Custom Fields 65], [Custom Fields 66], [Custom Fields 67], [Custom Fields 68], [Custom Fields 69], [Custom Fields 70], [Custom Fields 71], [Custom Fields 72], [Custom Fields 73], [Custom Fields 74], [Custom Fields 75], [Release Of Information Date], [Medicaid Resubmission No], [Medicaid Original Ref No], [Date Last Seen PCP], [Primary Care Provider], [Nature Of Condition], [Complication Indicator], [EPSDT Findings], [EPSDT Referral Items], [External Cause Of Accident], [Podiatry Therapy Type], [Systemic Condition], [Class Findings], [New Patient Date], [Notes Reminder Code], [Created Date], [Modified Date], [Main Phone], [Fax Phone], [Mobile Phone], [Pager Phone], [Other Phone], [Home Email], [Work Email], [Contact Name], [Contact Phone], [Contact Note], [Patient Weight], [Weight Units], [Referral Date], [Pregnancy Indicator], [Estimated Date Of Birth], [Prescription Date], [Last Worked Date], [Date Assumed Care], [Date Relinquished Care], [Reference ID Qualifier], [Service Authorization Exception Code], [Homebound Indicator], [Supervising Physician], [IDE Number], [Fee Schedule Type], [Collection Status], [Entity Type])
SELECT [Chart Number], [First Name], [Last Name], [Middle Initial], [Address 1], [Address 2], [City], [State], [Zip Code], [Work Phone], [Work Extension], [Home Phone], [Social Security Number], [Sex], [Marital Status], [Date Of Birth], [Employer], [Employer Name], [Employer Address 1], [Employer Address 2], [Employer City], [Employer State], [Employer Zip], [Provider], [Patient Code], [Patient Type], [Hold Code 1], [Hold Code 2], [Hold Code 3], [Hold Code 4], [Hold Code 5], [Managed Care], [Managed Plan], [Managed Payment], [Balance], [Charges], [Payments], [Last Payment], [Last Payment Date], [Insurance Code 1], [Insurance Type 1], [Insurance Group Number 1], [Insurance Insured ID 1], [Insurance Insured Is 1], [Insurance Insured 1], [Insurance Insured Relation 1], [Insurance Auto Bill 1], [Insurance Authorization 1], [Insurance Accept Assignment 1], [Insurance Code 2], [Insurance Type 2], [Insurance Group Number 2], [Insurance Insured ID 2], [Insurance Insured Is 2], [Insurance Insured 2], [Insurance Insured Relation 2], [Insurance Auto Bill 2], [Insurance Authorization 2], [Insurance Accept Assignment 2], [Insurance Code 3], [Insurance Type 3], [Insurance Group Number 3], [Insurance Insured ID 3], [Insurance Insured Is 3], [Insurance Insured 3], [Insurance Insured Relation 3], [Insurance Auto Bill 3], [Insurance Authorization 3], [Insurance Accept Assignment 3], [Symptom Type], [Symptom Date], [Similar Symptom], [Similar Date], [Accident Type], [Accident Date], [Accident State], [Employment Related], [Emergency], [Last XRay], [Consultation 1], [Consultation 2], [Total Disability 1], [Total Disability 2], [Partial Disability 1], [Partial Disability 2], [Hospitalization 1], [Hospitalization 2], [Return Work], [Return Work Date], [Status], [Death Date], [Lab Charge], [Lab Charge Amount], [Facility], [Referring Physician], [Attorney], [Months Treated], [Employment Status], [Student Status], [Signature On File], [Release Information], [EPSDT], [Family Planning], [Percent Disability], [Third Party Liability], [Service Branch], [Service Status], [Service Grade], [Service Card Effective 1], [Service Card Effective 2], [Non Available], [Service Handicapped], [Ambulatory Surgery], [Subluxation 1], [Subluxation 2], [Permanent Diagnosis 1], [Permanent Diagnosis 2], [Permanent Diagnosis 3], [Permanent Diagnosis 4], [Permanent Diagnosis 5], [Custom Fields 1], [Custom Fields 2], [Custom Fields 3], [Custom Fields 4], [Custom Fields 5], [Custom Fields 6], [Custom Fields 7], [Custom Fields 8], [Custom Fields 9], [Custom Fields 10], [Custom Fields 11], [Custom Fields 12], [Custom Fields 13], [Custom Fields 14], [Custom Fields 15], [Custom Fields 16], [Custom Fields 17], [Custom Fields 18], [Custom Fields 19], [Custom Fields 20], [Custom Fields 21], [Custom Fields 22], [Custom Fields 23], [Custom Fields 24], [Custom Fields 25], [Custom Fields 26], [Custom Fields 27], [Custom Fields 28], [Custom Fields 29], [Custom Fields 30], [Custom Fields 31], [Custom Fields 32], [Custom Fields 33], [Custom Fields 34], [Custom Fields 35], [Custom Fields 36], [Custom Fields 37], [Custom Fields 38], [Custom Fields 39], [Custom Fields 40], [Custom Fields 41], [Custom Fields 42], [Custom Fields 43], [Custom Fields 44], [Custom Fields 45], [Custom Fields 46], [Custom Fields 47], [Custom Fields 48], [Custom Fields 49], [Custom Fields 50], [Responsible Is], [Responsible], [Last Visit], [Referring Patient], [Inactive], [Auto Bill Patient], [Co Pay], [Insurance PCA Claim Number 1], [Insurance PCA Claim Number 2], [Insurance PCA Claim Number 3], [Custom Fields 51], [Custom Fields 52], [Custom Fields 53], [Custom Fields 54], [Custom Fields 55], [Custom Fields 56], [Custom Fields 57], [Custom Fields 58], [Custom Fields 59], [Custom Fields 60], [Custom Fields 61], [Custom Fields 62], [Custom Fields 63], [Custom Fields 64], [Custom Fields 65], [Custom Fields 66], [Custom Fields 67], [Custom Fields 68], [Custom Fields 69], [Custom Fields 70], [Custom Fields 71], [Custom Fields 72], [Custom Fields 73], [Custom Fields 74], [Custom Fields 75], [Release Of Information Date], [Medicaid Resubmission No], [Medicaid Original Ref No], [Date Last Seen PCP], [Primary Care Provider], [Nature Of Condition], [Complication Indicator], [EPSDT Findings], [EPSDT Referral Items], [External Cause Of Accident], [Podiatry Therapy Type], [Systemic Condition], [Class Findings], [New Patient Date], [Notes Reminder Code], [Created Date], [Modified Date], [Main Phone], [Fax Phone], [Mobile Phone], [Pager Phone], [Other Phone], [Home Email], [Work Email], [Contact Name], [Contact Phone], [Contact Note], [Patient Weight], [Weight Units], [Referral Date], [Pregnancy Indicator], [Estimated Date Of Birth], [Prescription Date], [Last Worked Date], [Date Assumed Care], [Date Relinquished Care], [Reference ID Qualifier], [Service Authorization Exception Code], [Homebound Indicator], [Supervising Physician], [IDE Number], [Fee Schedule Type], [Collection Status], [Entity Type] FROM [dbo].[PatientImported]

/*  
INSERT the data into Patient table
*/

ALTER TABLE Patient ADD PatientImportedDataID INT NULL
GO



INSERT INTO dbo.Patient 
(PracticeID, Prefix, FirstName, LastName, Suffix, MiddleName, AddressLine1,AddressLine2,City,State, ZipCode, Gender, 
MaritalStatus,HomePhone, DOB,SSN, EmailAddress,PatientImportedDataID 
)
SELECT 1,  dbo.fn_PrefixFromGender([Sex]), [First Name], [Last Name], '', [Middle Initial], [Address 1], [Address 2], [City], 
[State], dbo.fn_RemoveDashNSpace([Zip Code]),[Sex], [Marital Status],[Home Phone], 
dbo.fn_ConvertToValidTimeOrNull([Date Of Birth]),
dbo.fn_RemoveDashNSpace([Social Security Number]), 
[dbo].[fn_ChooseNotNullValue]([Home Email],[Work Email]), PatientImportedID  
FROM PatientImported_WithID


/*This INSERTS the data into PatientEmployer table
*/
INSERT INTO dbo.PatientEmployer 
(dbo.PatientEmployer.PatientID, EmployerName, AddressLine1, AddressLine2, City, State, ZipCode) 
SELECT dbo.Patient.PatientID, [Employer Name], [Employer Address 1], [Employer Address 2], 
[Employer City], [Employer State], dbo.fn_RemoveDashNSpace([Employer Zip])
FROM dbo.PatientImported_WithID, dbo.Patient 
WHERE 
dbo.Patient.PatientImportedDataID = dbo.PatientImported_WithID.PatientImportedID

/* INSERT into PatientCase */
INSERT INTO dbo.PatientCase 
(PatientID,[Name],PracticeID, PayerScenarioID)
SELECT dbo.Patient.PatientID, 'Case_0122',1,5
FROM dbo.Patient,  dbo.PatientImported_WithID
WHERE dbo.Patient.PatientImportedDataID = dbo.PatientImported_WithID.PatientImportedID

/* INSERT into InsurancePolicy */

-- Insurance Policy 1
INSERT INTO dbo.InsurancePolicy (PatientCaseID, InsuranceCompanyPlanID, 
PolicyNumber, GroupNumber, PracticeID, PatientRelationshipToInsured)
SELECT 
PatientCase.PatientCaseID, InsuranceCompanyPlan.InsuranceCompanyPlanID,
PatientImported_WithID.[Insurance Code 1], PatientImported_WithID.[Insurance Group Number 1], 1, 'S'
FROM  dbo.PatientImported_WithID, dbo.PatientCase, dbo.Patient, dbo.InsuranceCompanyPlan 
WHERE PatientCase.PatientID = Patient.PatientID
AND PatientImported_WithID.PatientImportedID = Patient.PatientImportedDataID
AND InsuranceCompanyPlan.VendorID = PatientImported_WithID.[Insurance Code 1]

-- Insurance Policy 2
INSERT INTO dbo.InsurancePolicy (PatientCaseID, InsuranceCompanyPlanID, 
PolicyNumber, GroupNumber, PracticeID, PatientRelationshipToInsured)
SELECT 
PatientCase.PatientCaseID, InsuranceCompanyPlan.InsuranceCompanyPlanID,
PatientImported_WithID.[Insurance Code 2], PatientImported_WithID.[Insurance Group Number 2], 1, 'S'
FROM  dbo.PatientImported_WithID, dbo.PatientCase, dbo.Patient, dbo.InsuranceCompanyPlan 
WHERE PatientCase.PatientID = Patient.PatientID
AND PatientImported_WithID.PatientImportedID = Patient.PatientImportedDataID
AND InsuranceCompanyPlan.VendorID = PatientImported_WithID.[Insurance Code 2]

-- Insurance Policy 3
INSERT INTO dbo.InsurancePolicy (PatientCaseID, InsuranceCompanyPlanID, 
PolicyNumber, GroupNumber, PracticeID, PatientRelationshipToInsured)
SELECT 
PatientCase.PatientCaseID, InsuranceCompanyPlan.InsuranceCompanyPlanID,
PatientImported_WithID.[Insurance Code 3], PatientImported_WithID.[Insurance Group Number 3], 1, 'S'
FROM  dbo.PatientImported_WithID, dbo.PatientCase, dbo.Patient, dbo.InsuranceCompanyPlan 
WHERE PatientCase.PatientID = Patient.PatientID
AND PatientImported_WithID.PatientImportedID = Patient.PatientImportedDataID
AND InsuranceCompanyPlan.VendorID = PatientImported_WithID.[Insurance Code 3]


/*==================================  Import Transaction.txt ==========================
TransactionImported table presumed as been created during execution of 
"National Billing Cust 122 (Transaction.With.Headers.txt)" DTS package. 
The following script creates an identical TransactionImported_WithID table but with an additional
identity field TransactionImportedID

Note: Original Transaction.txt file does not contains headers which defined
in the separate "headers for transactions file.txt" 
Transaction.With.Headers.txt file is identical to Transaction.txt but with headers from
"headers for transactions file.txt" files.
*/
------------ CREATE TransactionImported_WithID table  --------
CREATE TABLE [TransactionImported_WithID] (
	[TransactionImportedID] [int] IDENTITY (10, 10) NOT NULL ,
	[Patient Chart] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ Billing #] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Billing Created Date] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Co-Pay] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Bill to Patient] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Bill to Primary] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Bill to Secondary] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Bill to Tertiary] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Transaction Date Field 1] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Transaction Date Field 2] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Provider Code] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Place of Service Code] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Diagnosis 1 Code] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Diagnosis 2 Code] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Diagnosis 3 Code] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Diagnosis 4 Code] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Diagnosis 5 Code] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Transaction Code] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Modifier 1] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Modifier 2] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Modifier 3] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Modifier 4] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Procedure Charge] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Units] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Extended Amount] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Patient Portion] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Note on Statement] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Note on Insurance] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Transaction Line Note] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Printed on Day Sheet] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Transaction File Posted] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Item Number] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Sub Item Number] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Anesthesia Minutes] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Narrative Type] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Narrative] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Entry Date] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Entry Time] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Taxable] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Charge Patient Only] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]


/*
Copy TransactionImported into TransactionImported_WithID table
*/



INSERT INTO [dbo].[TransactionImported_WithID]
([Patient Chart], [ Billing #], [Billing Created Date], [Co-Pay], [Bill to Patient], [Bill to Primary], [Bill to Secondary], [Bill to Tertiary], [Transaction Date Field 1], [Transaction Date Field 2], [Provider Code], [Place of Service Code], [Diagnosis 1 Code], [Diagnosis 2 Code], [Diagnosis 3 Code], [Diagnosis 4 Code], [Diagnosis 5 Code], [Transaction Code], [Modifier 1], [Modifier 2], [Modifier 3], [Modifier 4], [Procedure Charge], [Units], [Extended Amount], [Patient Portion], [Note on Statement], [Note on Insurance], [Transaction Line Note], [Printed on Day Sheet], [Transaction File Posted], [Item Number], [Sub Item Number], [Anesthesia Minutes], [Narrative Type], [Narrative], [Entry Date], [Entry Time], [Taxable], [Charge Patient Only])
SELECT [Patient Chart], [ Billing #], [Billing Created Date], [Co-Pay], [Bill to Patient], [Bill to Primary], [Bill to Secondary], [Bill to Tertiary], [Transaction Date Field 1], [Transaction Date Field 2], [Provider Code], [Place of Service Code], [Diagnosis 1 Code], [Diagnosis 2 Code], [Diagnosis 3 Code], [Diagnosis 4 Code], [Diagnosis 5 Code], [Transaction Code], [Modifier 1], [Modifier 2], [Modifier 3], [Modifier 4], [Procedure Charge], [Units], [Extended Amount], [Patient Portion], [Note on Statement], [Note on Insurance], [Transaction Line Note], [Printed on Day Sheet], [Transaction File Posted], [Item Number], [Sub Item Number], [Anesthesia Minutes], [Narrative Type], [Narrative], [Entry Date], [Entry Time], [Taxable], [Charge Patient Only] FROM [dbo].[TransactionImported]


/*
INSERT INTO ProcedureCodeDictionary missing ProcedureCode codes
*/
INSERT INTO ProcedureCodeDictionary (ProcedureCode)
SELECT DISTINCT [Transaction Code] FROM dbo.TransactionImported
WHERE [Transaction Code] 
NOT IN (SELECT DISTINCT ProcedureCode FROM ProcedureCodeDictionary)



/*
Inserting INTO Encounter table 
*/
INSERT INTO dbo.Encounter (PracticeID, PatientID, DoctorID, LocationID, DateOfService, 
PlaceOfServiceCode, PatientCaseID, DatePosted, EncounterStatusID )
SELECT 1, dbo.Patient.PatientID, 3, 1,  
[dbo].[fn_DateOnly](dbo.TransactionImported_WithID.[Transaction Date Field 1]) theDate, 
11, dbo.PatientCase.PatientCaseID,0,1
FROM dbo.TransactionImported_WithID, dbo.PatientImported_WithID, dbo.Patient, dbo.PatientCase
WHERE 
dbo.PatientCase.PatientID = Patient.PatientID
AND dbo.PatientImported_WithID.PatientImportedID = dbo.Patient.PatientImportedDataID
AND dbo.PatientImported_WithID.[Chart Number] = dbo.TransactionImported_WithID.[Patient Chart]
GROUP BY dbo.Patient.PatientID, 
[dbo].[fn_DateOnly](dbo.TransactionImported_WithID.[Transaction Date Field 1]),
dbo.PatientCase.PatientCaseID
ORDER BY dbo.Patient.PatientID, theDate, dbo.PatientCase.PatientCaseID

/*
Inserting INTO EnconterProcedure
*/
INSERT INTO dbo.EncounterProcedure 
( EncounterID, ProcedureCodeDictionaryID,ServiceChargeAmount, ProcedureDateOfService, PracticeID )
SELECT 
dbo.Encounter.EncounterID, ProcedureCodeDictionary.ProcedureCodeDictionaryID,
Convert(money, dbo.TransactionImported_WithID.[Procedure Charge]), 
dbo.TransactionImported_WithID.[Transaction Date Field 1],1
FROM dbo.Encounter, dbo.TransactionImported_WithID, ProcedureCodeDictionary, Patient, 
dbo.PatientImported_WithID
WHERE 
CAST(CONVERT(CHAR(10), dbo.TransactionImported_WithID.[Transaction Date Field 1],110) AS DATETIME)
= CAST(CONVERT(CHAR(10), dbo.Encounter.DateOfService,110) AS DATETIME)
AND dbo.Encounter.PatientID = Patient.PatientID
AND Patient.PatientImportedDataID = dbo.PatientImported_WithID.PatientImportedID
AND dbo.TransactionImported_WithID.[Transaction Code] = ProcedureCodeDictionary.ProcedureCode
AND dbo.PatientImported_WithID.[Chart Number] = dbo.TransactionImported_WithID.[Patient Chart]





/*
INSERT INTO DiagnosisCodeDictionary mising DiagnosisCode for all 5 diagnosis
*/
--Diagnosis 1
INSERT INTO DiagnosisCodeDictionary (DiagnosisCode)
SELECT DISTINCT [dbo].[fn_FormatDiagnosisCode]([Diagnosis 1 Code])
FROM dbo.TransactionImported
WHERE 
LEN([dbo].[fn_FormatDiagnosisCode]([Diagnosis 1 Code]))>0
AND
[dbo].[fn_FormatDiagnosisCode]([Diagnosis 1 Code])
NOT IN (SELECT DISTINCT DiagnosisCode FROM DiagnosisCodeDictionary)

--Diagnosis 2
INSERT INTO DiagnosisCodeDictionary (DiagnosisCode)
SELECT DISTINCT [dbo].[fn_FormatDiagnosisCode]([Diagnosis 2 Code])
FROM dbo.TransactionImported
WHERE 
LEN([dbo].[fn_FormatDiagnosisCode]([Diagnosis 2 Code]))>0
AND
[dbo].[fn_FormatDiagnosisCode]([Diagnosis 2 Code])
NOT IN (SELECT DISTINCT DiagnosisCode FROM DiagnosisCodeDictionary)

--Diagnosis 3
INSERT INTO DiagnosisCodeDictionary (DiagnosisCode)
SELECT DISTINCT [dbo].[fn_FormatDiagnosisCode]([Diagnosis 3 Code])
FROM dbo.TransactionImported
WHERE 
LEN([dbo].[fn_FormatDiagnosisCode]([Diagnosis 3 Code]))>0
AND
[dbo].[fn_FormatDiagnosisCode]([Diagnosis 3 Code])
NOT IN (SELECT DISTINCT DiagnosisCode FROM DiagnosisCodeDictionary)

----Diagnosis 4
INSERT INTO DiagnosisCodeDictionary (DiagnosisCode)
SELECT DISTINCT [dbo].[fn_FormatDiagnosisCode]([Diagnosis 4 Code])
FROM dbo.TransactionImported
WHERE 
LEN([dbo].[fn_FormatDiagnosisCode]([Diagnosis 4 Code]))>0
AND
[dbo].[fn_FormatDiagnosisCode]([Diagnosis 4 Code])
NOT IN (SELECT DISTINCT DiagnosisCode FROM DiagnosisCodeDictionary)

----Diagnosis 5
INSERT INTO DiagnosisCodeDictionary (DiagnosisCode)
SELECT DISTINCT [dbo].[fn_FormatDiagnosisCode]([Diagnosis 5 Code])
FROM dbo.TransactionImported
WHERE 
LEN([dbo].[fn_FormatDiagnosisCode]([Diagnosis 5 Code]))>0
AND
[dbo].[fn_FormatDiagnosisCode]([Diagnosis 5 Code])
NOT IN (SELECT DISTINCT DiagnosisCode FROM DiagnosisCodeDictionary)
/*
 Inserting INTO EnconterDiagnosis for  All 5 Diagnosis 
*/

----Diagnosis 1
INSERT INTO dbo.EncounterDiagnosis 
( EncounterID, DiagnosisCodeDictionaryID, PracticeID )
SELECT dbo.Encounter.EncounterID, DiagnosisCodeDictionary.DiagnosisCodeDictionaryID,1
FROM dbo.Encounter, dbo.TransactionImported_WithID, Patient, DiagnosisCodeDictionary, dbo.PatientImported_WithID
WHERE 
CAST(CONVERT(CHAR(10), dbo.TransactionImported_WithID.[Transaction Date Field 1],110) AS DATETIME)
= CAST(CONVERT(CHAR(10), dbo.Encounter.DateOfService,110) AS DATETIME)
AND dbo.Encounter.PatientID = Patient.PatientID
AND Patient.PatientImportedDataID = dbo.PatientImported_WithID.PatientImportedID
AND dbo.PatientImported_WithID.[Chart Number] = dbo.TransactionImported_WithID.[Patient Chart]
AND [dbo].[fn_FormatDiagnosisCode](dbo.TransactionImported_WithID.[Diagnosis 1 Code]) = DiagnosisCodeDictionary.DiagnosisCode

----Diagnosis 2
INSERT INTO dbo.EncounterDiagnosis 
( EncounterID, DiagnosisCodeDictionaryID, PracticeID )
SELECT dbo.Encounter.EncounterID, DiagnosisCodeDictionary.DiagnosisCodeDictionaryID,1
FROM dbo.Encounter, dbo.TransactionImported_WithID, Patient, DiagnosisCodeDictionary, dbo.PatientImported_WithID
WHERE 
CAST(CONVERT(CHAR(10), dbo.TransactionImported_WithID.[Transaction Date Field 1],110) AS DATETIME)
= CAST(CONVERT(CHAR(10), dbo.Encounter.DateOfService,110) AS DATETIME)
AND dbo.Encounter.PatientID = Patient.PatientID
AND Patient.PatientImportedDataID = dbo.PatientImported_WithID.PatientImportedID
AND dbo.PatientImported_WithID.[Chart Number] = dbo.TransactionImported_WithID.[Patient Chart]
AND [dbo].[fn_FormatDiagnosisCode](dbo.TransactionImported_WithID.[Diagnosis 2 Code]) = DiagnosisCodeDictionary.DiagnosisCode


----Diagnosis 3
INSERT INTO dbo.EncounterDiagnosis 
( EncounterID, DiagnosisCodeDictionaryID, PracticeID )
SELECT dbo.Encounter.EncounterID, DiagnosisCodeDictionary.DiagnosisCodeDictionaryID,1
FROM dbo.Encounter, dbo.TransactionImported_WithID, Patient, DiagnosisCodeDictionary, dbo.PatientImported_WithID
WHERE 
CAST(CONVERT(CHAR(10), dbo.TransactionImported_WithID.[Transaction Date Field 1],110) AS DATETIME)
= CAST(CONVERT(CHAR(10), dbo.Encounter.DateOfService,110) AS DATETIME)
AND dbo.Encounter.PatientID = Patient.PatientID
AND Patient.PatientImportedDataID = dbo.PatientImported_WithID.PatientImportedID
AND dbo.PatientImported_WithID.[Chart Number] = dbo.TransactionImported_WithID.[Patient Chart]
AND [dbo].[fn_FormatDiagnosisCode](dbo.TransactionImported_WithID.[Diagnosis 3 Code]) = DiagnosisCodeDictionary.DiagnosisCode



----Diagnosis 4
INSERT INTO dbo.EncounterDiagnosis 
( EncounterID, DiagnosisCodeDictionaryID, PracticeID )
SELECT dbo.Encounter.EncounterID, DiagnosisCodeDictionary.DiagnosisCodeDictionaryID,1
FROM dbo.Encounter, dbo.TransactionImported_WithID, Patient, DiagnosisCodeDictionary, dbo.PatientImported_WithID
WHERE 
CAST(CONVERT(CHAR(10), dbo.TransactionImported_WithID.[Transaction Date Field 1],110) AS DATETIME)
= CAST(CONVERT(CHAR(10), dbo.Encounter.DateOfService,110) AS DATETIME)
AND dbo.Encounter.PatientID = Patient.PatientID
AND Patient.PatientImportedDataID = dbo.PatientImported_WithID.PatientImportedID
AND dbo.PatientImported_WithID.[Chart Number] = dbo.TransactionImported_WithID.[Patient Chart]
AND [dbo].[fn_FormatDiagnosisCode](dbo.TransactionImported_WithID.[Diagnosis 4 Code]) = DiagnosisCodeDictionary.DiagnosisCode


----Diagnosis 5
INSERT INTO dbo.EncounterDiagnosis 
( EncounterID, DiagnosisCodeDictionaryID, PracticeID )
SELECT dbo.Encounter.EncounterID, DiagnosisCodeDictionary.DiagnosisCodeDictionaryID,1
FROM dbo.Encounter, dbo.TransactionImported_WithID, Patient, DiagnosisCodeDictionary, dbo.PatientImported_WithID
WHERE 
CAST(CONVERT(CHAR(10), dbo.TransactionImported_WithID.[Transaction Date Field 1],110) AS DATETIME)
= CAST(CONVERT(CHAR(10), dbo.Encounter.DateOfService,110) AS DATETIME)
AND dbo.Encounter.PatientID = Patient.PatientID
AND Patient.PatientImportedDataID = dbo.PatientImported_WithID.PatientImportedID
AND dbo.PatientImported_WithID.[Chart Number] = dbo.TransactionImported_WithID.[Patient Chart]
AND [dbo].[fn_FormatDiagnosisCode](dbo.TransactionImported_WithID.[Diagnosis 5 Code]) = DiagnosisCodeDictionary.DiagnosisCode


--========================= Drop Functions ========================
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[fn_RemoveDashNSpace]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[fn_RemoveDashNSpace]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[fn_PrefixFromGender]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[fn_PrefixFromGender]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[fn_GetServiceLocationCode]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[fn_GetServiceLocationCode]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[fn_FormatDiagnosisCode]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[fn_FormatDiagnosisCode]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[fn_ChooseNotNullValue]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[fn_ChooseNotNullValue]
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[fn_ConvertToValidTimeOrNull]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[fn_ConvertToValidTimeOrNull]
GO
--========================= End of Story ====================================================