/*
Case 1889 - Create preference table to hold the preferences
*/

CREATE TABLE Preference(
	PreferenceID INT IDENTITY(1,1) NOT NULL,
	UserID INT, 
	PracticeID INT, 
	Section varchar(128) NOT NULL,
	KeyName varchar(128) NOT NULL,
	PreferenceValue varchar(max) NOT NULL,
	CacheGuid uniqueidentifier,
	InternalUse bit NOT NULL CONSTRAINT DF_Preference_InternalUse DEFAULT 0,
	CONSTRAINT PK_Preference PRIMARY KEY NONCLUSTERED 
	(
		PreferenceID
	)
) 

GO

ALTER TABLE Preference ADD CONSTRAINT FK_Preference_Practice
FOREIGN KEY (PracticeID) REFERENCES Practice (PracticeID)

/*
Case 22828 - Create preference table to hold the preferences
*/

INSERT INTO Preference(
	Section,
	KeyName,
	PreferenceValue,
	CacheGuid,
	InternalUse)
VALUES(
	'CustomizeParameters',
	'ClaimBrowser',
	'<parameters>
  <extendedParameters>
	<extendedParameter type="Date" parameterName="PostDate" text="Post Date:" default="None" />
	<extendedParameter type="Date" parameterName="BeginningServiceDate" text="Beginning Service Date:" default="None" />
	<extendedParameter type="Date" parameterName="EndingServiceDate" text="Ending Sevice Date:" default="None" />
	<extendedParameter type="PayerScenario" parameterName="PayerScenarioID" text="Payer Scenario:" default="-1" ignore="-1" />
	<extendedParameter type="Provider" parameterName="ProviderID" text="Rendering Provider:" default="-1" ignore="-1" />
	<extendedParameter type="ReferringPhysician" parameterName="ReferringProviderID" text="Referring Physician..." default="-1" ignore="-1" permission="FindReferringPhysician" />
	<extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
	<extendedParameter type="InsuranceCompany" parameterName="InsuranceCompanyID" text="Insurance Company:" description="Filter by insurance company." default="-1" ignore="-1" />
	<extendedParameter type="Insurance" parameterName="InsuranceCompanyPlanID" text="Insurance Plan:" default="-1" ignore="-1" />
	<extendedParameter type="Patient" parameterName="PatientID" text="Patient:" default="-1" ignore="-1" permission="FindPatient" />
	<extendedParameter type="TextBox" parameterName="BatchID" text="Batch #:" />
	<extendedParameter type="TextBox" parameterName="ProcedureCodeStr" text="Procedure(s):" />
	<extendedParameter type="ComboBox" parameterName="Status" text="Status:" description="Filter by claim status." default="A" ignore="A">
	  <value displayText="All" value="A.A" />
	  <value displayText="Ready" value="R.A" />
	  <value displayText="Pending" value="P.A" />
	  <value displayText="Rejections" value="E.RJT" />
	  <value displayText="Denials" value="E.DEN" />
	  <value displayText="No Response" value="E.BLL" />
	</extendedParameter>
  </extendedParameters>
</parameters>',
	newid(),
	1)
