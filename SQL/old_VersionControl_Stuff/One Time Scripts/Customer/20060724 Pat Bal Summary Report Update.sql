
/*-----------------------------------------------------------------------------
Case 12598:   Patient not showing on "pat. balance summary report" 
-----------------------------------------------------------------------------*/
UPDATE R
SET ReportParameters =
	'<?xml version="1.0" encoding="utf-8" ?>
	<parameters>
	  <basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDate" dateParameter="EndDate" text="Date:" default="Today" />
		<basicParameter type="Date" parameterName="EndDate" text="As Of:" default="Today" />
		<basicParameter type="ClientTime" parameterName="ClientTime" />
	  </basicParameters>
	  <extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="ComboBox" parameterName="Assigned" text="Assigned to:" description="Show only patients with a balance assigned to all, patient, or insurance."    default="P">
		  <value displayText="All" value="A" />
		  <value displayText="Patient" value="P" />
		  <value displayText="Insurance" value="I" />
		</extendedParameter>
	  </extendedParameters>
	</parameters>'
from report r
where Name = 'Patient Balance Summary'
GO