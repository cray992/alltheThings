UPDATE Report
SET ReportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
		<basicParameter type="Date" parameterName="BeginDate" text="From:" default="OneYearAgo" />
		<basicParameter type="Date" parameterName="EndDate" text="To:"/>
		<basicParameter type="ClientTime" parameterName="ClientTime" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1"/>
	</extendedParameters>
</parameters>'
from report
where name = 'Key Indicators Summary'

UPDATE report 
set ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
		<basicParameter type="Date" parameterName="BeginDate" text="From:" default="OneYearAgo" />
		<basicParameter type="Date" parameterName="EndDate" text="To:"/>
		<basicParameter type="ClientTime" parameterName="ClientTime" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1"/>
	</extendedParameters>
</parameters>'
where name = 'Key Indicators Detail'


UPDATE Report
SET ReportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" />
		<basicParameter type="Date" parameterName="BeginDate" text="From:" default="OneYearAgo" />
		<basicParameter type="Date" parameterName="EndDate" text="To:"/>
		<basicParameter type="ClientTime" parameterName="ClientTime" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1"/>
	</extendedParameters>
</parameters>'
where name = 'Key Indicators Summary Compare Previous Year'




UPDATE Report
SET ReportParameters = 
'<?xml version="1.0" encoding="utf-8" ?>
<parameters>
	<basicParameters>
		<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
		<basicParameter type="PracticeID" parameterName="PracticeID" />
		<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
		<basicParameter type="CustomDate" dateParameter="Date" text="Date:" default="Today" />
		<basicParameter type="Date" parameterName="Date" text="As Of:" default="Today" />
		<basicParameter type="ClientTime" parameterName="ClientTime" />
	</basicParameters>
	<extendedParameters>
		<extendedParameter type="Separator" text="Filter" />
		<extendedParameter type="Provider" parameterName="ProviderID" text="Provider:" default="-1" ignore="-1"/>
	</extendedParameters>
</parameters>'
where name = 'Key Indicators Summary YTD Review'