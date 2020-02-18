

INSERT dbo.ReportHyperlink
        ( 
        ReportHyperlinkID,
         [Description],
         ReportParameters,
          ModifiedDate
        )
VALUES  ( 
51, -- ReportHyperlinkID
          'KI Summary to Encounter Summary Report' , -- Description - varchar(256)
           -- ReportParameters - text
           '<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
	<object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
		<method name="" />
		<method name="Add">
			<methodParam param="ReportName" />
			
			<methodParam param="Encounters Summary" />
			<methodParam param="true" type="System.Boolean"/>
		</method>
		<method name="Add">
			<methodParam param="ReportOverrideParameters" />
			<methodParam>
				<object type="System.Collections.Hashtable">
					<method name="" />
					<method name="Add">
						<methodParam param="BeginDate" />
						<methodParam param="{0}" />
					</method>
					<method name="Add">
						<methodParam param="EndDate" />
						<methodParam param="{1}" />
					</method>
					<method name="Add">
						<methodParam param="DateType" />
						<methodParam param="{2}" />
					</method>
					<method name="Add">                   
						<methodParam param="ServiceLocationID" />
						<methodParam param="{3}" />
					</method>
					<method name="Add">
						<methodParam param="SchedulingProviderID" />
						<methodParam param="{4}" />
					</method>
					<method name="Add">
						<methodParam param="ProviderNumberID" />
						<methodParam param="{5}" />
					</method>
					<method name="Add">
						<methodParam param="PayerScenarioID" />
						<methodParam param="{6}" />
					</method>
					<method name="Add">
						<methodParam param="DepartmentID" />
						<methodParam param="{7}" />
					</method>
					<method name="Add">
						<methodParam param="BatchNumberID" />
						<methodParam param="{8}" />
					</method>
					<method name="Add">
						<methodParam param="EncounterStatusID" />
						<methodParam param="{9}" />
					</method>
				</object>
			</methodParam>
		</method>
	</object>
</task>'
          ,
          GETDATE() --Modified Date

        )