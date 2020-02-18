IF EXISTS(SELECT 1 FROM sys.objects WHERE name='BillingInvoicing_ETemplate' AND type='U')
	DROP TABLE BillingInvoicing_ETemplate

GO

CREATE TABLE dbo.BillingInvoicing_ETemplate(ETemplateID INT IDENTITY(1,1) 
CONSTRAINT PK_BillingInvoicing_ETemplate PRIMARY KEY CLUSTERED,
ETemplateName VARCHAR(256) NOT NULL,
SubjectLineTemplate VARCHAR(256) NULL,
EBodyTemplate VARCHAR(MAX) NOT NULL,
Active BIT NOT NULL CONSTRAINT DF_ETemplate_Active DEFAULT 1,
CreatedDate DATETIME NOT NULL CONSTRAINT DF_ETemplate_CreatedDate DEFAULT GETDATE(),
ModifiedDate DATETIME NOT NULL)

GO

DECLARE @Name VARCHAR(256)
DECLARE @Subject VARCHAR(256)
DECLARE @Body VARCHAR(256)

SET @Name='Pay by Check'
SET @Subject='[Invoice] Kareo Monthly Subscription - {invoiceperiod}'
SET @Body='    <div>
        <p>
            <font size="3" face="Calibri">Dear {firstname}:</font>
            <br />
        </p>
        <p>
            <font size="3" face="Calibri">Attached you’ll find your INVOICE for your Kareo account
                for {invoiceperiod} in the amount of {invoiceamount}.</font>
            <br />
        </p>
            <font size="3" face="Calibri"><b>INVOICES</b></font><br />
            <font size="3" face="Calibri">Kareo has now transitioned your account to receive electronic
                copies of your invoice by email. You will also continue to receive a physical copy
                of your invoice by standard mail for the next 3 months.</font>
            <br />
            <br />
            
            <font size="3" face="Calibri"><b>TERMS</b></font><br />
            <font size="3" face="Calibri">{terms}</font>
            <br />
            <br />

            <font size="3" face="Calibri"><b>ELECTRONIC PAYMENTS</b></font><br />
            <font size="3" face="Calibri">If you would like to transition to electronic payments
                for your Kareo fees, please login to </font><a href="http://help.kareo.com/" target="_blank">
                    <font color="#0000FF" size="3" face="Calibri"><u>http://help.kareo.com/</u></font></a><font
                        size="3" face="Calibri"> with your Kareo user account and select the <i>Change My Billing
                            Profile</i> option.</font>
            <br />
            <br />

            <font size="3" face="Calibri"><b>BILLING &amp; ACCOUNT QUESTIONS</b></font><br />
            <font size="3" face="Calibri">If you have any questions related to your Kareo invoices,
                automated payments, provider deactivation, account cancellation, or related account
                issues, please send your questions to </font><a href="mailto:billing@kareo.com" target="_blank">
                    <font color="#0000FF" size="3" face="Calibri"><u>billing@kareo.com</u></font></a><font
                        size="3" face="Calibri"> and we will respond as soon as possible, but usually within
                        2 business days or less.</font>
            <br />
            <br />

            <font size="3" face="Calibri"><b>SUPPORT QUESTIONS</b></font><br />
            <font size="3" face="Calibri">If you have any questions about using your Kareo account
                related to features, training, enrollment, electronic claims processing, or any
                other issues, please send your questions to </font><a href="mailto:support@kareo.com"
                    target="_blank"><font color="#0000FF" size="3" face="Calibri"><u>support@kareo.com</u></font></a><font
                        size="3" face="Calibri"> and we will respond as soon as possible, but usually within
                        2 business days or less.</font>
            <br />
            <br />
            <font size="3" face="Calibri">Thank you very much for using Kareo. </font>
            <br />
        <p>
            <font size="3" face="Calibri">Kind regards,</font>
            <br />
        </p>
            <font size="3" face="Calibri">Kareo Billing</font><br />
            <a href="mailto:billing@kareo.com" target="_blank"><font color="#0000FF" size="3"
                face="Calibri"><u>billing@kareo.com</u></font></a>
            <br />
            <br />
            <br />
    </div>'

INSERT INTO dbo.BillingInvoicing_ETemplate(ETemplateName, SubjectLineTemplate, EBodyTemplate, ModifiedDate)
VALUES(@Name, @Subject, @Body, GETDATE())

GO

DECLARE @Name VARCHAR(256)
DECLARE @Subject VARCHAR(256)
DECLARE @Body VARCHAR(256)

SET @Name='E Payments'
SET @Subject='[Invoice] Kareo Monthly Subscription - {invoiceperiod}'
SET @Body='    <div>
        <p>
            <font size="3" face="Calibri">Dear {firstname}:</font>
            <br/>
        </p>
        <p>
            <font size="3" face="Calibri">Attached you’ll find your INVOICE for your Kareo account
                for {invoiceperiod} in the amount of {invoiceamount}.</font>
            <br/>
        </p>
            <font size="3" face="Calibri"><b>INVOICES</b></font><br />
            <font size="3" face="Calibri">Kareo has now transitioned your account to receive electronic
                copies of your invoice by email. You will also continue to receive a physical copy
                of your invoice by standard mail for the next 3 months.</font>
            <br/>
            <br />
            <font size="3" face="Calibri"><b>TERMS</b></font><br />
            <font size="3" face="Calibri">{terms}</font>
            <br/>
            <br />
            <font size="3" face="Calibri"><b>ELECTRONIC PAYMENTS</b></font><br />
            <font size="3" face="Calibri">If you would like to update the credit card or ACH information
                for the payment of your Kareo fees, please login to </font><a href="http://help.kareo.com/"
                    target="_blank"><font color="#0000FF" size="3" face="Calibri"><u>http://help.kareo.com/</u></font></a><font
                        size="3" face="Calibri"> with your Kareo user account and select the <i>Change My Billing
                            Profile</i> option.</font>
            <br/>
            <br />

            <font size="3" face="Calibri"><b>BILLING &amp; ACCOUNT QUESTIONS</b></font><br />
            <font size="3" face="Calibri">If you have any questions related to your Kareo invoices,
                automated payments, provider deactivation, account cancellation, or another billing
                issue, please send your questions to </font><a href="mailto:billing@kareo.com" target="_blank">
                    <font color="#0000FF" size="3" face="Calibri"><u>billing@kareo.com</u></font></a><font
                        size="3" face="Calibri"> and we will respond as soon as possible, but usually within
                        2 business days or less.</font>
            <br/>
            <br />

            <font size="3" face="Calibri"><b>SUPPORT QUESTIONS</b></font><br />
            <font size="3" face="Calibri">If you have any questions about using your Kareo account
                related to features, training, enrollment, electronic claims processing, or any
                other issues, please send your questions to </font><a href="mailto:support@kareo.com"
                    target="_blank"><font color="#0000FF" size="3" face="Calibri"><u>support@kareo.com</u></font></a><font
                        size="3" face="Calibri"> and we will respond as soon as possible, but usually within
                        2 business days or less.</font>
            <br/>
            <br />
            <font size="3" face="Calibri">Thank you very much for using Kareo. </font>
            <br/>
            <br />
            <font size="3" face="Calibri">Kind regards,</font>
            <br/>
            <br />

            <font size="3" face="Calibri">Kareo Billing</font><br />
            <a href="mailto:billing@kareo.com" target="_blank"><font color="#0000FF" size="3"
                face="Calibri"><u>billing@kareo.com</u></font></a>
            <br/>
            <br/>
            <br/>
    </div>'

INSERT INTO dbo.BillingInvoicing_ETemplate(ETemplateName, SubjectLineTemplate, EBodyTemplate, ModifiedDate)
VALUES(@Name, @Subject, @Body, GETDATE())

GO

ALTER TABLE invoicing.PaymentTerms ADD ETemplateID INT NULL

GO
UPDATE PT
	SET ETemplateID=1
FROM invoicing.PaymentTerms PT
WHERE PaymentTermsID=1

UPDATE PT
	SET ETemplateID=2
FROM invoicing.PaymentTerms PT
WHERE PaymentTermsID=2