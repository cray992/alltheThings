UPDATE dbo.ReportHyperlink
SET ReportParameters =
'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
	<object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
		<method name="" />
		<method name="Add">
			<methodParam param="ReportName" />
			<methodParam param="Contract Management Detail" />
			<methodParam param="true" type="System.Boolean" />
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
						<methodParam param="ProviderID" />
						<methodParam param="{3}" />
					</method>
					<method name="Add">
						<methodParam param="ServiceLocationID" />
						<methodParam param="{4}" />
					</method>
					<method name="Add">
						<methodParam param="DepartmentID" />
						<methodParam param="{5}" />
					</method>
					<method name="Add">
						<methodParam param="InsuranceCompanyID" />
						<methodParam param="{6}" />
					</method>
					<method name="Add">
						<methodParam param="InsuranceCompanyPlanID" />
						<methodParam param="{7}" />
					</method>
					<method name="Add">
						<methodParam param="PayerScenarioID" />
						<methodParam param="{8}" />
					</method>
					<method name="Add">
						<methodParam param="BatchID" />
						<methodParam param="{9}" />
					</method>
					<method name="Add">
						<methodParam param="RevenueCategoryID" />
						<methodParam param="{10}" />
					</method>
					<method name="Add">
						<methodParam param="ProcedureCodeStr" />
						<methodParam param="{11}" />
					</method>
					<method name="Add">
						<methodParam param="Metric" />
						<methodParam param="{12}" />
					</method>
					<method name="Add">
						<methodParam param="PatientID" />
						<methodParam param="{13}" />
					</method>
					<method name="Add">
						<methodParam param="GroupBy" />
						<methodParam param="{14}" />
					</method>
					<method name="Add">
						<methodParam param="SummaryType" />
						<methodParam param="{15}" />
					</method>
				</object>
			</methodParam>
		</method>
	</object>
</task>'
WHERE ReportHyperlinkID = 40