UPDATE
	ReportHyperlink
SET
	ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>  <task name="Appointment Details" feature-restriction="Appointments">   <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">    <method name="" />    <method name="Add">     <methodParam param="AppointmentID" />     <methodParam param="{0}" type="System.Int32" />     <methodParam param="true" type="System.Boolean" />    </method>    <method name="Add">     <methodParam param="Editing" />     <methodParam param="true" type="System.Boolean" />    </method>    <method name="Add">     <methodParam param="Recurring" />     <methodParam param="false" type="System.Boolean" />    </method>   </object>  </task>'
WHERE
	Description = 'Appointment Detail Task'


UPDATE
	ReportHyperlink
SET
	ReportParameters = '<?xml version="1.0" encoding="utf-8" ?>  <task name="Patient Statement Detail" feature-restriction="PatientStatements">   <object type="Kareo.Superbill.Windows.Tasks.Domain.SimpleDetailParameters">    <method name="">     <methodParam param="{0}" type="System.Int32" />     <methodParam param="true" type="System.Boolean"/>    </method>   </object>  </task>'
WHERE
	Description = 'Patient Statement Detail Task'