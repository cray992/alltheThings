


declare @x xml
set @x = '<parameters csv="false">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="TimeOffset" parameterName="TimeOffset" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="Today" forceDefault="true" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:" overrideMaxDate="true" />
    <basicParameter type="Date" parameterName="EndDate" text="To:" overrideMaxDate="true" endOfDay="true" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="ComboBox" parameterName="AppointmentResourceTypeID" text="Type:" description="Limits the report by resource type." default="-1" ignore="-1">
      <value displayText="All" value="-1" />
      <value displayText="Practice Resource" value="2" />
      <value displayText="Provider" value="1" />
    </extendedParameter>
    <extendedParameter type="PracticeResources" parameterName="ResourceID" text="Practice Resource:" default="-1" ignore="-1" enabledBasedOnParameter="AppointmentResourceTypeID" enabledBasedOnValue="2" />
    <extendedParameter type="Provider" parameterName="ResourceID" text="Provider:" default="-1" ignore="-1" enabledBasedOnParameter="AppointmentResourceTypeID" enabledBasedOnValue="1" />
    <extendedParameter type="AppointmentStatus" parameterName="Status" text="Status:" default="Z" />
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />
    <extendedParameter type="ComboBox" parameterName="AppointmentReasonId" text="Appointment Reason:" description="Filter by Reason" default="-1" >
      <value displayText="ALL" value="-1" />
      <dataSetValue tableName="dbo.AppointmentReason" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="AppointmentType" text="Appointment Type:" description="Select the type of appointment." default="A" ignore="A">
      <value displayText="All" value="A" />
      <value displayText="Patient" value="P" />
      <value displayText="Other" value="O" />
    </extendedParameter>
    
    <extendedParameter type="ComboBox" parameterName="ScheduleStyle" text="Schedule Style:" description="Select the style for printing appointments." default="1">
      <value displayText="Normal" value="1" />
      <value displayText="Fixed Time Slots" value="2" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="StartTime" text="Start Time:" default="08:00:00" enabledBasedOnParameter="ScheduleStyle" enabledBasedOnValue="2">
      <value displayText="12:00 AM" value="00:00:00" />
      <value displayText="12:15 AM" value="00:15:00" />
      <value displayText="12:30 AM" value="00:30:00" />
      <value displayText="12:45 AM" value="00:45:00" />
      <value displayText="01:00 AM" value="01:00:00" />
      <value displayText="01:15 AM" value="01:15:00" />
      <value displayText="01:30 AM" value="01:30:00" />
      <value displayText="01:45 AM" value="01:45:00" />
      <value displayText="02:00 AM" value="02:00:00" />
      <value displayText="02:15 AM" value="02:15:00" />
      <value displayText="02:30 AM" value="02:30:00" />
      <value displayText="02:45 AM" value="02:45:00" />
      <value displayText="03:00 AM" value="03:00:00" />
      <value displayText="03:15 AM" value="03:15:00" />
      <value displayText="03:30 AM" value="03:30:00" />
      <value displayText="03:45 AM" value="03:45:00" />
      <value displayText="04:00 AM" value="04:00:00" />
      <value displayText="04:15 AM" value="04:15:00" />
      <value displayText="04:30 AM" value="04:30:00" />
      <value displayText="04:45 AM" value="04:45:00" />
      <value displayText="05:00 AM" value="05:00:00" />
      <value displayText="05:15 AM" value="05:15:00" />
      <value displayText="05:30 AM" value="05:30:00" />
      <value displayText="05:45 AM" value="05:45:00" />
      <value displayText="06:00 AM" value="06:00:00" />
      <value displayText="06:15 AM" value="06:15:00" />
      <value displayText="06:30 AM" value="06:30:00" />
      <value displayText="06:45 AM" value="06:45:00" />
      <value displayText="07:00 AM" value="07:00:00" />
      <value displayText="07:15 AM" value="07:15:00" />
      <value displayText="07:30 AM" value="07:30:00" />
      <value displayText="07:45 AM" value="07:45:00" />
      <value displayText="08:00 AM" value="08:00:00" />
      <value displayText="08:15 AM" value="08:15:00" />
      <value displayText="08:30 AM" value="08:30:00" />
      <value displayText="08:45 AM" value="08:45:00" />
      <value displayText="09:00 AM" value="09:00:00" />
      <value displayText="09:15 AM" value="09:15:00" />
      <value displayText="09:30 AM" value="09:30:00" />
      <value displayText="09:45 AM" value="09:45:00" />
      <value displayText="10:00 AM" value="10:00:00" />
      <value displayText="10:15 AM" value="10:15:00" />
      <value displayText="10:30 AM" value="10:30:00" />
      <value displayText="10:45 AM" value="10:45:00" />
      <value displayText="11:00 AM" value="11:00:00" />
      <value displayText="11:15 AM" value="11:15:00" />
      <value displayText="11:30 AM" value="11:30:00" />
      <value displayText="11:45 AM" value="11:45:00" />
      <value displayText="12:00 PM" value="12:00:00" />
      <value displayText="12:15 PM" value="12:15:00" />
      <value displayText="12:30 PM" value="12:30:00" />
      <value displayText="12:45 PM" value="12:45:00" />
      <value displayText="01:00 PM" value="13:00:00" />
      <value displayText="01:15 PM" value="13:15:00" />
      <value displayText="01:30 PM" value="13:30:00" />
      <value displayText="01:45 PM" value="13:45:00" />
      <value displayText="02:00 PM" value="14:00:00" />
      <value displayText="02:15 PM" value="14:15:00" />
      <value displayText="02:30 PM" value="14:30:00" />
      <value displayText="02:45 PM" value="14:45:00" />
      <value displayText="03:00 PM" value="15:00:00" />
      <value displayText="03:15 PM" value="15:15:00" />
      <value displayText="03:30 PM" value="15:30:00" />
      <value displayText="03:45 PM" value="15:45:00" />
      <value displayText="04:00 PM" value="16:00:00" />
      <value displayText="04:15 PM" value="16:15:00" />
      <value displayText="04:30 PM" value="16:30:00" />
      <value displayText="04:45 PM" value="16:45:00" />
      <value displayText="05:00 PM" value="17:00:00" />
      <value displayText="05:15 PM" value="17:15:00" />
      <value displayText="05:30 PM" value="17:30:00" />
      <value displayText="05:45 PM" value="17:45:00" />
      <value displayText="06:00 PM" value="18:00:00" />
      <value displayText="06:15 PM" value="18:15:00" />
      <value displayText="06:30 PM" value="18:30:00" />
      <value displayText="06:45 PM" value="18:45:00" />
      <value displayText="07:00 PM" value="19:00:00" />
      <value displayText="07:15 PM" value="19:15:00" />
      <value displayText="07:30 PM" value="19:30:00" />
      <value displayText="07:45 PM" value="19:45:00" />
      <value displayText="08:00 PM" value="20:00:00" />
      <value displayText="08:15 PM" value="20:15:00" />
      <value displayText="08:30 PM" value="20:30:00" />
      <value displayText="08:45 PM" value="20:45:00" />
      <value displayText="09:00 PM" value="21:00:00" />
      <value displayText="09:15 PM" value="21:15:00" />
      <value displayText="09:30 PM" value="21:30:00" />
      <value displayText="09:45 PM" value="21:45:00" />
      <value displayText="10:00 PM" value="22:00:00" />
      <value displayText="10:15 PM" value="22:15:00" />
      <value displayText="10:30 PM" value="22:30:00" />
      <value displayText="10:45 PM" value="22:45:00" />
      <value displayText="11:00 PM" value="23:00:00" />
      <value displayText="11:15 PM" value="23:15:00" />
      <value displayText="11:30 PM" value="23:30:00" />
      <value displayText="11:45 PM" value="23:45:00" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="EndTime" text="End Time:" default="18:00:00" enabledBasedOnParameter="ScheduleStyle" enabledBasedOnValue="2">
      <value displayText="12:00 AM" value="00:00:00" />
      <value displayText="12:15 AM" value="00:15:00" />
      <value displayText="12:30 AM" value="00:30:00" />
      <value displayText="12:45 AM" value="00:45:00" />
      <value displayText="01:00 AM" value="01:00:00" />
      <value displayText="01:15 AM" value="01:15:00" />
      <value displayText="01:30 AM" value="01:30:00" />
      <value displayText="01:45 AM" value="01:45:00" />
      <value displayText="02:00 AM" value="02:00:00" />
      <value displayText="02:15 AM" value="02:15:00" />
      <value displayText="02:30 AM" value="02:30:00" />
      <value displayText="02:45 AM" value="02:45:00" />
      <value displayText="03:00 AM" value="03:00:00" />
      <value displayText="03:15 AM" value="03:15:00" />
      <value displayText="03:30 AM" value="03:30:00" />
      <value displayText="03:45 AM" value="03:45:00" />
      <value displayText="04:00 AM" value="04:00:00" />
      <value displayText="04:15 AM" value="04:15:00" />
      <value displayText="04:30 AM" value="04:30:00" />
      <value displayText="04:45 AM" value="04:45:00" />
      <value displayText="05:00 AM" value="05:00:00" />
      <value displayText="05:15 AM" value="05:15:00" />
      <value displayText="05:30 AM" value="05:30:00" />
      <value displayText="05:45 AM" value="05:45:00" />
      <value displayText="06:00 AM" value="06:00:00" />
      <value displayText="06:15 AM" value="06:15:00" />
      <value displayText="06:30 AM" value="06:30:00" />
      <value displayText="06:45 AM" value="06:45:00" />
      <value displayText="07:00 AM" value="07:00:00" />
      <value displayText="07:15 AM" value="07:15:00" />
      <value displayText="07:30 AM" value="07:30:00" />
      <value displayText="07:45 AM" value="07:45:00" />
      <value displayText="08:00 AM" value="08:00:00" />
      <value displayText="08:15 AM" value="08:15:00" />
      <value displayText="08:30 AM" value="08:30:00" />
      <value displayText="08:45 AM" value="08:45:00" />
      <value displayText="09:00 AM" value="09:00:00" />
      <value displayText="09:15 AM" value="09:15:00" />
      <value displayText="09:30 AM" value="09:30:00" />
      <value displayText="09:45 AM" value="09:45:00" />
      <value displayText="10:00 AM" value="10:00:00" />
      <value displayText="10:15 AM" value="10:15:00" />
      <value displayText="10:30 AM" value="10:30:00" />
      <value displayText="10:45 AM" value="10:45:00" />
      <value displayText="11:00 AM" value="11:00:00" />
      <value displayText="11:15 AM" value="11:15:00" />
      <value displayText="11:30 AM" value="11:30:00" />
      <value displayText="11:45 AM" value="11:45:00" />
      <value displayText="12:00 PM" value="12:00:00" />
      <value displayText="12:15 PM" value="12:15:00" />
      <value displayText="12:30 PM" value="12:30:00" />
      <value displayText="12:45 PM" value="12:45:00" />
      <value displayText="01:00 PM" value="13:00:00" />
      <value displayText="01:15 PM" value="13:15:00" />
      <value displayText="01:30 PM" value="13:30:00" />
      <value displayText="01:45 PM" value="13:45:00" />
      <value displayText="02:00 PM" value="14:00:00" />
      <value displayText="02:15 PM" value="14:15:00" />
      <value displayText="02:30 PM" value="14:30:00" />
      <value displayText="02:45 PM" value="14:45:00" />
      <value displayText="03:00 PM" value="15:00:00" />
      <value displayText="03:15 PM" value="15:15:00" />
      <value displayText="03:30 PM" value="15:30:00" />
      <value displayText="03:45 PM" value="15:45:00" />
      <value displayText="04:00 PM" value="16:00:00" />
      <value displayText="04:15 PM" value="16:15:00" />
      <value displayText="04:30 PM" value="16:30:00" />
      <value displayText="04:45 PM" value="16:45:00" />
      <value displayText="05:00 PM" value="17:00:00" />
      <value displayText="05:15 PM" value="17:15:00" />
      <value displayText="05:30 PM" value="17:30:00" />
      <value displayText="05:45 PM" value="17:45:00" />
      <value displayText="06:00 PM" value="18:00:00" />
      <value displayText="06:15 PM" value="18:15:00" />
      <value displayText="06:30 PM" value="18:30:00" />
      <value displayText="06:45 PM" value="18:45:00" />
      <value displayText="07:00 PM" value="19:00:00" />
      <value displayText="07:15 PM" value="19:15:00" />
      <value displayText="07:30 PM" value="19:30:00" />
      <value displayText="07:45 PM" value="19:45:00" />
      <value displayText="08:00 PM" value="20:00:00" />
      <value displayText="08:15 PM" value="20:15:00" />
      <value displayText="08:30 PM" value="20:30:00" />
      <value displayText="08:45 PM" value="20:45:00" />
      <value displayText="09:00 PM" value="21:00:00" />
      <value displayText="09:15 PM" value="21:15:00" />
      <value displayText="09:30 PM" value="21:30:00" />
      <value displayText="09:45 PM" value="21:45:00" />
      <value displayText="10:00 PM" value="22:00:00" />
      <value displayText="10:15 PM" value="22:15:00" />
      <value displayText="10:30 PM" value="22:30:00" />
      <value displayText="10:45 PM" value="22:45:00" />
      <value displayText="11:00 PM" value="23:00:00" />
      <value displayText="11:15 PM" value="23:15:00" />
      <value displayText="11:30 PM" value="23:30:00" />
      <value displayText="11:45 PM" value="23:45:00" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="MinuteInterval" text="Time Increments:" description="Set the time increments for displaying appointments." default="30" enabledBasedOnParameter="ScheduleStyle" enabledBasedOnValue="2">
      <value displayText="1 minute" value="1" />
      <value displayText="2 minute" value="2" />
      <value displayText="3 minute" value="3" />
      <value displayText="4 minute" value="4" />
      <value displayText="5 minute" value="5" />
      <value displayText="6 minute" value="6" />
      <value displayText="10 minute" value="10" />
      <value displayText="12 minute" value="12" />
      <value displayText="15 minute" value="15" />
      <value displayText="20 minute" value="20" />
      <value displayText="30 minute" value="30" />
      <value displayText="60 minute" value="60" />
    </extendedParameter>
  </extendedParameters>
</parameters>'


-- delete report where name='Appointment Detail'
IF NOT EXISTS( select * from report where name='Appointments Detail')
BEGIN

INSERT INTO [dbo].[Report](
	[ReportCategoryID]
	,[DisplayOrder]
	,[Image]
	,[Name]
	,[Description]
	,[TaskName]
	,[ReportPath]
	,[ReportParameters]
	,[ModifiedDate]
	,[MenuName]
	,[PermissionValue]
	,[PracticeSpecific])
select
	7 as [ReportCategoryID]
	,5 as [DisplayOrder]
	,'[[image[Practice.ReportsV2.Images.reports.gif]]]' as [Image]
	,'Appointments Detail' as [Name]
	,'This report provides a detail of all appointments over a period of time.' as [Description]
	,'Report V2 Viewer' as [TaskName]
	,'/BusinessManagerReports/rptAppointmentsDetail' as [ReportPath]
	,@x as [ReportParameters]
	,getdate() as [ModifiedDate]
	,'A&ppointments Detail' as [MenuName]
	,'ReadAppointmentDetailReport' as [PermissionValue]
	,1 as [PracticeSpecific]


	declare @RptID int

	select @rptId=reportId
	from report
	where name = 'Appointments Detail'

	INSERT INTO ReportToSoftwareApplication(
		ReportID, 
		SoftwareApplicationID, 
		ModifiedDate
		)

	VALUES(
		@RptID,
		'K',
		GETDATE()
		)
		
END
ELSE BEGIN

	UPDATE [Report]
	set reportParameters=@x, 
		modifiedDate=getdate(),
		[PermissionValue] = 'ReadAppointmentDetailReport'
	where name='Appointments Detail'
END

GO












DECLARE @x xml
set @x = '<parameters csv="false">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
    <basicParameter type="CustomDateRange" fromDateParameter="BeginDate" toDateParameter="EndDate" text="Dates:" default="MonthToDate" forceDefault="true" />
    <basicParameter type="Date" parameterName="BeginDate" text="From:" overrideMaxDate="true" />
    <basicParameter type="Date" parameterName="EndDate" text="To:" overrideMaxDate="true" endOfDay="true" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="ComboBox" parameterName="AppointmentResourceTypeID" text="Type:" description="Limits the report by resource type." default="-1" ignore="-1">
      <value displayText="All" value="-1" />
      <value displayText="Practice Resource" value="2" />
      <value displayText="Provider" value="1" />
    </extendedParameter>
    <extendedParameter type="PracticeResources" parameterName="ResourceID" text="Practice Resource:" default="-1" ignore="-1" enabledBasedOnParameter="AppointmentResourceTypeID" enabledBasedOnValue="2" />
    <extendedParameter type="Provider" parameterName="ResourceID" text="Provider:" default="-1" ignore="-1" enabledBasedOnParameter="AppointmentResourceTypeID" enabledBasedOnValue="1" />
    <extendedParameter type="AppointmentStatus" parameterName="Status" text="Status:" default="Z" />
    <extendedParameter type="Patient" parameterName="PatientID" text="Patient" default="-1" ignore="-1" />
    <extendedParameter type="ServiceLocation" parameterName="ServiceLocationID" text="Service Location:" default="-1" ignore="-1" />

    <extendedParameter type="ComboBox" parameterName="GroupBy1" text="Group by:" description="Groups the report by field" default="3">
		<value displayText="Primary Reason" value="1" />
		<value displayText="Patient" value="2" />
		<value displayText="Resource" value="3" />
		<value displayText="Service Location" value="4" />
		<value displayText="Status" value="5" />
		<value displayText="Appointment Type" value="6" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="GroupBy2" text="Subgroup by:" description="Subgroups the report by field" default="1">
		<value displayText="Primary Reason" value="1" />
		<value displayText="Patient" value="2" />
		<value displayText="Resource" value="3" />
		<value displayText="Service Location" value="4" />
		<value displayText="Status" value="5" />
		<value displayText="Appointment Type" value="6" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="ColumnType" text="Columns:" description="Select the summarization method." default="1">
      <value displayText="Total Only" value="1" />
      <value displayText="Month" value="2" />
      <value displayText="Quarter" value="3" />
      <value displayText="Year" value="4" />
    </extendedParameter>
  </extendedParameters>
</parameters>'


update report
set ReportParameters=@x, ModifiedDate=getdate()
where name in ('Appointments Summary')


GO

	delete reportHyperlink where reportHyperLinkId=50

	insert into reportHyperlink(
		reportHyperlinkId,
		Description,
		ReportParameters
		)
	values(
		50,
		'Appointment Detail Report',
		'<task name="Report V2 Viewer">
	  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
		<method name=""/>
		<method name="Add">
		  <methodParam param="ReportName"/>
		  <methodParam param="Appointments Detail"/>
		  <methodParam param="true" type="System.Boolean"/>
		</method>
		<method name="Add">
		  <methodParam param="ReportOverrideParameters"/>
		  <methodParam>
			<object type="System.Collections.Hashtable">
			  <method name=""/>
			  <method name="Add">
				<methodParam param="BeginDate"/>
				<methodParam param="{0}"/>
			  </method>
			  <method name="Add">
				<methodParam param="EndDate"/>
				<methodParam param="{1}"/>
			  </method>
			  <method name="Add">
				<methodParam param="AppointmentResourceTypeID"/>
				<methodParam param="{2}"/>
			  </method>
			  <method name="Add">
				<methodParam param="ResourceID"/>
				<methodParam param="{3}"/>
			  </method>
			  <method name="Add">
				<methodParam param="Status"/>
				<methodParam param="{4}"/>
			  </method>
			  <method name="Add">
				<methodParam param="PatientID"/>
				<methodParam param="{5}"/>
			  </method>
			  <method name="Add">
				<methodParam param="ServiceLocationID"/>
				<methodParam param="{6}"/>
			  </method>
			  <method name="Add">
				<methodParam param="AppointmentReasonId"/>
				<methodParam param="{7}"/>
			  </method>
			  <method name="Add">
				<methodParam param="AppointmentType"/>
				<methodParam param="{8}"/>
			  </method>
			</object>
		  </methodParam>
		</method>
	  </object>
	</task>'
	)