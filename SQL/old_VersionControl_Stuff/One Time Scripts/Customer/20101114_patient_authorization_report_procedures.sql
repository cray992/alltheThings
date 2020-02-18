declare @x xml
set @x = '<parameters csv="false">
  <basicParameters>
    <basicParameter type="ShowFooter" parameterName="rpmShowFooterInfo" />
    <basicParameter type="PracticeID" parameterName="PracticeID" />
    <basicParameter type="PracticeName" parameterName="rpmPracticeName" />
    <basicParameter type="SoftwareApplicationID" parameterName="rpmSoftwareApplicationID" />
    <basicParameter type="ClientTime" parameterName="ClientTime" />
    <basicParameter type="CustomDateRange" fromDateParameter="encounterDateOfPosting" toDateParameter="encounterEndDateOfPosting" text="Dates:" default="MonthToDate" forceDefault="true" />
    <basicParameter type="Date" parameterName="encounterDateOfPosting" text="From Post Date:" />
    <basicParameter type="Date" parameterName="encounterEndDateOfPosting" text="To Post Date:" />
  </basicParameters>
  <extendedParameters>
    <extendedParameter type="Separator" text="Filter" />
    <extendedParameter type="Date" parameterName="startDate" text="Begin Auth Date:" default="None" />
    <extendedParameter type="Date" parameterName="EndDate" text="End Auth Date:" default="None" />
    <extendedParameter type="ComboBox" parameterName="numberOfSessionRemaining" text="Visit(s) remaining" description="Select to filter the number of insurance authorizations remaining" default="-1">
      <value displayText="All" value="-1" />
      <value displayText="0" value="0" />
      <value displayText="1" value="1" />
      <value displayText="2" value="2" />
      <value displayText="3" value="3" />
      <value displayText="4" value="4" />
      <value displayText="5" value="5" />
      <value displayText="6" value="6" />
      <value displayText="7" value="7" />
      <value displayText="8" value="8" />
      <value displayText="9" value="9" />
      <value displayText="10" value="10" />
      <value displayText="15" value="15" />
      <value displayText="20" value="20" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="includeAllAuthorization" text="Selected insurance authorizations " description="Select to include all patient authorizations" default="FALSE">
      <value displayText="Show selected insurance authorizations" value="FALSE" />
      <value displayText="Show all insurance authorization for selected patient" value="TRUE" />
    </extendedParameter>
    <extendedParameter type="ComboBox" parameterName="calcVistsByProcedures" text="Procedures performed" description="Select to calculate number of vists based on approved procedures instead of encounter" default="FALSE">
      <value displayText="Visit by encounters" value="FALSE" />
      <value displayText="Visit by procedures" value="TRUE" />
    </extendedParameter>
  </extendedParameters>
</parameters>'


update r
set reportParameters = @x, modifiedDate = getdate()
from report r
where name = 'Patient Insurance Authorization'
GO
