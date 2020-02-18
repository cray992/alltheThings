IF NOT EXISTS(SELECT * FROM Report WHERE Name='Patient Contact List')
BEGIN

	DECLARE @PatientContactListRptID INT

	INSERT INTO Report(ReportCategoryID, DisplayOrder, Image, Name, Description, TaskName, ReportPath, ReportParameters, MenuName, PermissionValue)
	VALUES(5, 50, '[[image[Practice.ReportsV2.Images.reports.gif]]]', 'Patient Contact List', 'This report shows a list of patients and their contact information.',
	'Report V2 Viewer','/BusinessManagerReports/rptPatientContactList','<?xml version="1.0" encoding="utf-8" ?>
	<parameters>
		<basicParameters>
			<basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
			<basicParameter type="PracticeID" parameterName="PracticeID" />
			<basicParameter type="PracticeName" parameterName="rpmPracticeName" />
			<basicParameter type="ClientTime" parameterName="ClientTime" />
		</basicParameters>
		<extendedParameters>
			<extendedParameter type="Separator" text="Filter" />
			<extendedParameter type="ComboBox" parameterName="Activity" text="Activity:" description="Limits the report by patients with activity within specified time frame." default="30 days">
				<value displayText="30 days" value="30 days" />
				<value displayText="90 days" value="90 days" />
				<value displayText="180 days" value="180 days" />
				<value displayText="1 year" value="1 year" />
			</extendedParameter>
		</extendedParameters>
	</parameters>','Patient &Contact List','ReadPatientContactListReport')

	SET @PatientContactListRptID=@@IDENTITY

	INSERT INTO ReportToSoftwareApplication(ReportID, SoftwareApplicationID, ModifiedDate)
	VALUES(@PatientContactListRptID,'B',GETDATE())
	INSERT INTO ReportToSoftwareApplication(ReportID, SoftwareApplicationID, ModifiedDate)
	VALUES(@PatientContactListRptID,'M',GETDATE())

INSERT INTO ReportHyperlink(

            ReportHyperlinkID,

            Description,

            ReportParameters,

            ModifiedDate)

VALUES(

            14,

            'Patient Detail Task',

            '<?xml version="1.0" encoding="utf-8" ?>

<task name="Patient Detail">

      <object type="Kareo.Superbill.Windows.Tasks.Domain.SimpleDetailParameters">

            <method name="">

                  <methodParam param="{0}" type="System.Int32" />

                  <methodParam param="true" type="System.Boolean"/>

            </method>

      </object>

</task>',

            getdate())

END


