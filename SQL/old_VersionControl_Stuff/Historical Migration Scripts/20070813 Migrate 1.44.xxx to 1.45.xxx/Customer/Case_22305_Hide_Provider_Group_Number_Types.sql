/* Case 22305 - Hide unused provider & group number types from users */

/* Add Active column to ProviderNumberType ... */
ALTER TABLE dbo.ProviderNumberType ADD
	Active bit NULL
GO

ALTER TABLE dbo.ProviderNumberType ADD CONSTRAINT
	DF_ProviderNumberType_Active DEFAULT 0 FOR Active
GO

UPDATE	dbo.ProviderNumberType
SET		Active = 1
GO

/* ----------------------------------------------------------------------------
Deactivate the following provider number types, unless they are being used 
currently:

   a. Blue Cross (California)
   b. Medicare Railroad Number

---------------------------------------------------------------------------- */
UPDATE	dbo.ProviderNumberType
SET		Active = 0
WHERE	ProviderNumberTypeID IN ( 6, 9 ) 
		AND ProviderNumberTypeID NOT IN ( 
			SELECT PN.ProviderNumberTypeID 
			FROM ProviderNumber PN 
				JOIN ProviderNumberType PNT 
				ON PN.ProviderNumberTypeID = PNT.ProviderNumberTypeID 
			GROUP BY PN.ProviderNumberTypeID )
GO

/* Add Active column to GroupNumberType ... */
ALTER TABLE dbo.GroupNumberType ADD
	Active bit NULL
GO

ALTER TABLE dbo.GroupNumberType ADD CONSTRAINT
	DF_GroupNumberType_Active DEFAULT 0 FOR Active
GO

UPDATE	dbo.GroupNumberType 
SET		Active = 1
GO

/* ----------------------------------------------------------------------------
Deactivate the following group number types, unless they are being used 
currently:

  a. B3 - Preferred Provider Organization Number
  b. BQ - Health Maintenance Organization Code Number
  c. U3 - Unique Supplier Identification Number
  d. RN - EDI Receiver Number
  e. RM - EDI Receiver Name
  f. PI - Payor Identification
  g. PP - Pharmacy Processor Number
  h. 4A - Personal Identification Number
  i. CT - Contract Number
  j. EL - Electronic Device PIN Number
  k. EO - Submitter Identification Number
  l. JD - User Identification
  m. Q4 - Prior Identifier Number

---------------------------------------------------------------------------- */
UPDATE	dbo.GroupNumberType
SET		Active = 0
WHERE	AnsiReferenceIdentificationQualifier IN ( 'B3', 'BQ', 'U3', 'RN', 'RM', 'PI', 'PP', '4A', 'CT', 'EL', 'EO', 'JD', 'Q4' )
		AND GroupNumberTypeID NOT IN ( 
			SELECT PIGN.GroupNumberTypeID 
			FROM PracticeInsuranceGroupNumber PIGN 
				JOIN GroupNumberType GNT 
				ON GNT.GroupNumberTypeID = PIGN.GroupNumberTypeID 
			GROUP BY PIGN.GroupNumberTypeID )
GO

/*-----------------------------------------------------------------------------
For Provider Number type "G5 – Provider Site Number (Zo required)" (35), the 
extended description, “(Zo required)”, should be removed from the description 
for G5. According to Adren, the additional Zo setting is no longer required 
when selecting G5.
-----------------------------------------------------------------------------*/

UPDATE	dbo.ProviderNumberType
SET		TypeName = 'Provider Site Number'
WHERE	ProviderNumberTypeID = 35 
GO