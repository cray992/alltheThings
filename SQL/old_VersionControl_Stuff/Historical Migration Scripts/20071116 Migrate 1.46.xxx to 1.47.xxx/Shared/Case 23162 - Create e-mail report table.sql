/*
Case 23162 - Create e-mail report table
*/
/*
CREATE TABLE EmailReport(
	EmailReportID INT NOT NULL,
	StoredProcedure varchar(128) NOT NULL,
	XSLLayout varchar(max) NOT NULL,
	Description varchar(128)
	CONSTRAINT PK_EmailReport PRIMARY KEY NONCLUSTERED 
	(
		EmailReportID
	)
) 

GO

INSERT INTO EmailReport(
	EmailReportID,
	StoredProcedure,
	XSLLayout,
	Description)
VALUES(
	1,
	'Shared_EmailReportDataProvider_ProviderPerformance',
	'<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" indent="yes" />
	<xsl:template match="/">
		<xsl:call-template name="page" />
	</xsl:template>
	<xsl:template name="page">

		<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">

			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
				<meta name="keywords" content="goes_here" />
				<meta name="description" content="goes_here" />
				<title>Kareo E-mail Template</title>
				<style type="text/css">
          #email_container * { margin: 0; padding: 0; }

          #email_container {
          font-family: "Trebuchet MS", Verdana, Sans-Serif;;
          font-size: 12px;
          color: #4f5355;
          margin: 0;
          padding: 30px;
          }

          #email_container h1 {
          font-size: 24px;
          font-weight: bold;
          color: #ff7f00;
          }

          #email_container h3 {
          font-size: 14px;
          font-weight: bold;
          }

          #email_container p {
          line-height: 14px;
          margin-bottom: 15px;
          }

          #email_container strong {
          color: #000;
          }

          #email_container ol,
          #email_container ul {
          margin: 0 0 15px 30px;
          }

          #email_container table {
          font-family: "Trebuchet MS", Verdana, Sans-Serif;;
          font-size: 12px;
          color: #4f5355;
          margin-bottom: 15px;
          border-collapse: collapse;
          }

          #email_container table tr th {
          font-weight: bold;
          text-align: right;
          vertical-align: top;
          width: 150px;
          }

          #email_container table tr td {
          vertical-align: top;
          padding-left: 10px;
          }

          #email_container a { text-decoration: underline; outline: none; }
          #email_container a:link { color: #145995; }
          #email_container a:visited { color: #145995; }
          #email_container a:hover { color: #da0000; }
          #email_container a:active {  }

          #email_container_header {
          margin-bottom: 15px;
          padding-bottom: 10px;
          border-bottom: 1px dotted #a0a3a4;
          }
        </style>
			</head>

			<body>
				<div id="email_container">
					<div id="email_container_header">
						<h1><xsl:value-of select="//title" /></h1>
					</div>

					<p>Customer: <xsl:value-of select="//customer" />  User: <xsl:value-of select="//user" /></p>
					<p><xsl:value-of select="//content" /></p>

				</div>
			</body>
		</html>

	</xsl:template>
</xsl:stylesheet>',
	'Provider Performance Report')
*/