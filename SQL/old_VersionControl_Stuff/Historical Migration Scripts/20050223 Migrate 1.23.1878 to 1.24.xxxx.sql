/*

DATABASE UPDATE SCRIPT

v1.23.1878 to v1.24.xxxx
*/
----------------------------------

--BEGIN TRAN 
----------------------------------

---------------------------------------------------------------------------------------
--case 3500:  Remove the ReportServer column from the Report table

ALTER TABLE
	Report
DROP COLUMN
	ReportServer
GO

---------------------------------------------------------------------------------------
--case 3226 - Add report hyperlink information for Payments Application report

insert into ReportHyperlink
(ReportHyperlinkID, 
Description, 
ReportParameters)
values
(9, 
'Payments Application Report', 
'<?xml version="1.0" encoding="utf-8" ?>
<task name="Report V2 Viewer">
  <object type="Kareo.Superbill.Windows.Tasks.Domain.GeneralParameters">
    <method name="Add">
      <methodParam param="ReportName" />
      <methodParam param="Payments Application" />
      <methodParam param="true" type="System.Boolean"/>
    </method>
    <method name="Add">
      <methodParam param="ReportOverrideParameters" />
      <methodParam>
        <object type="System.Collections.Hashtable">
          <method name="Add">
            <methodParam param="PaymentID" />
            <methodParam param="{0}" />
          </method>
          <method name="Add">
            <methodParam param="rpmPayerName" />
            <methodParam param="{1}" />
          </method>
          <method name="Add">
            <methodParam param="rpmPaymentNumber" />
            <methodParam param="{2}" />
          </method>
          <method name="Add">
            <methodParam param="rpmPaymentAmount" />
            <methodParam param="{3}" />
          </method>
          <method name="Add">
            <methodParam param="rpmPaymentDate" />
            <methodParam param="{4}" />
          </method>
          <method name="Add">
            <methodParam param="rpmUnappliedAmount" />
            <methodParam param="{5}" />
          </method>
          <method name="Add">
            <methodParam param="rpmRefundAmount" />
            <methodParam param="{6}" />
          </method>
        </object>
      </methodParam>
    </method>
  </object>
</task>')


GO

---------------------------------------------------------------------------------------
--case XXXX - Description

---------------------------------------------------------------------------------------

--ROLLBACK
--COMMIT
