INSERT INTO ReportHyperlink(ReportHyperlinkID, Description, ReportParameters, ModifiedDate)
VALUES(43,'Customer Account Detail Report','<task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="" />
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="Customer Account Detail" />
      <methodParam param="true" type="System.Boolean" />
    </method>
    <method name="Add">
      <methodParam param="ReportOverrideParameters" />
      <methodParam>
        <object type="System.Collections.Hashtable">
          <method name="" />
          <method name="Add">
            <methodParam param="PracticeID" />
            <methodParam param="{0}" />
          </method>
          <method name="Add">
            <methodParam param="ProviderID" />
            <methodParam param="{1}" />
          </method>
          <method name="Add">
            <methodParam param="Category" />
            <methodParam param="{2}" />
          </method>
          <method name="Add">
            <methodParam param="TransactionType" />
            <methodParam param="{3}" />
          </method>
          <method name="Add">
            <methodParam param="GroupBy" />
            <methodParam param="{4}" />
          </method>
          <method name="Add">
            <methodParam param="BeginDate" />
            <methodParam param="{5}" />
          </method>
          <method name="Add">
            <methodParam param="EndDate" />
            <methodParam param="{6}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>',GETDATE())

