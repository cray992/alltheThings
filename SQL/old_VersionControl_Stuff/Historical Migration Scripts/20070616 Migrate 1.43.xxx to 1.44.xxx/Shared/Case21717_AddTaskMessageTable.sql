/*============================================================================= 
Case 21717 - Hyperlink to the common rejections guide from the clearinghouse 
reports task 
=============================================================================*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TaskMessage]') AND type in (N'U'))
DROP TABLE [dbo].[TaskMessage]
GO

CREATE TABLE [dbo].[TaskMessage](
	[TaskName] [varchar](50) NOT NULL,
	[MessageContent] [varchar](max) NULL,
	[MinHeight] [int] NULL,
 CONSTRAINT [PK_TaskMessage] PRIMARY KEY CLUSTERED 
(
	[TaskName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/* Add task messages to Clearinghouse Reports browsers ... */

insert into TaskMessage (
	TaskName, 
	MessageContent, 
	MinHeight ) 
values (
	'Company Clearinghouse Report Browser', 
	'<html><head><style>A {color: #4271B6; text-decoration: underline;} A:hover {color: #F2961B; text-decoration: underline;}</style></head><body style="margin-top:5px; margin-left:5px; border-style:solid; border-width:1px; border-color:#f7c800; background-color:#ffffe1; font-family: trebuchet, tahoma, verdana, arial; font-size: 9pt; font-weight: bold;"><div><img src="[[image[Practice.Settings.Images.Help.gif]]]" width="15" height="15" align="middle" border="0" style="padding-right:10px; vertical-align:middle" />&nbsp;&nbsp;Need help troubleshooting rejections?  Read the <a href="http://help.kareo.com/documents/pdf/Kareo_RejectionTroubleshootingGuide" target="_blank">Kareo Rejection Troubleshooting Guide</a>.</div></body></html>', 
	'40' )
go

insert into TaskMessage (
	TaskName, 
	MessageContent, 
	MinHeight ) 
values (
	'Practice Clearinghouse Report Browser', 
	'<html><head><style>A {color: #4271B6; text-decoration: underline;} A:hover {color: #F2961B; text-decoration: underline;}</style></head><body style="margin-top:5px; margin-left:5px; border-style:solid; border-width:1px; border-color:#f7c800; background-color:#ffffe1; font-family: trebuchet, tahoma, verdana, arial; font-size: 9pt; font-weight: bold;"><div><img src="[[image[Practice.Settings.Images.Help.gif]]]" width="15" height="15" align="middle" border="0" style="padding-right:10px; vertical-align:middle" />&nbsp;&nbsp;Need help troubleshooting rejections?  Read the <a href="http://help.kareo.com/documents/pdf/Kareo_RejectionTroubleshootingGuide" target="_blank">Kareo Rejection Troubleshooting Guide</a>.</div></body></html>', 
	'40' )
go

/* Add task message to Group Number browsers ... */

insert into TaskMessage (
	TaskName, 
	MessageContent, 
	MinHeight ) 
values (
	'Group Number Browser', 
	'<html><head><style>A {color: #4271B6; text-decoration: underline;} A:hover {color: #F2961B; text-decoration: underline;}</style></head><body style="margin-top:5px; margin-left:5px; border-style:solid; border-width:1px; border-color:#f7c800; background-color:#ffffe1; font-family: trebuchet, tahoma, verdana, arial; font-size: 9pt; font-weight: bold;"><div><img src="[[image[Practice.Settings.Images.Help.gif]]]" width="15" height="15" align="middle" border="0" style="padding-right:10px; vertical-align:middle" />&nbsp;&nbsp;Need help with group numbers?  Read the <a href="http://help.kareo.com/documents/pdf/Kareo_ProviderAndGroupNumberGuide" target="_blank">Kareo Provider and Group Numbers Guide</a>.</div></body></html>', 
	'40' )
go

/* Add task message to Provider Details ... */

insert into TaskMessage (
	TaskName, 
	MessageContent, 
	MinHeight ) 
values (
	'Provider Detail', 
	'<html><head><style>A {color: #4271B6; text-decoration: underline;} A:hover {color: #F2961B; text-decoration: underline;}</style></head><body style="margin-top:5px; margin-left:5px; border-style:solid; border-width:1px; border-color:#f7c800; background-color:#ffffe1; font-family: trebuchet, tahoma, verdana, arial; font-size: 9pt; font-weight: bold;"><div><img src="[[image[Practice.Settings.Images.Help.gif]]]" width="15" height="15" align="middle" border="0" style="padding-right:10px; vertical-align:middle" />&nbsp;&nbsp;Need help with provider numbers?  Read the <a href="http://help.kareo.com/documents/pdf/Kareo_ProviderAndGroupNumberGuide" target="_blank">Kareo Provider and Group Numbers Guide</a>.</div></body></html>', 
	'40' )
go

/* Add task message to Send Patient Statements Wizard ... */

insert into TaskMessage (
	TaskName, 
	MessageContent, 
	MinHeight ) 
values (
	'Patient Statements Submit Wizard', 
	'<html><head><style>A {color: #4271B6; text-decoration: underline;} A:hover {color: #F2961B; text-decoration: underline;}</style></head><body style="margin-top:5px; margin-left:5px; border-style:solid; border-width:1px; border-color:#f7c800; background-color:#ffffe1; font-family: trebuchet, tahoma, verdana, arial; font-size: 9pt; font-weight: bold;"><div><img src="[[image[Practice.Settings.Images.Help.gif]]]" width="15" height="15" align="middle" border="0" style="padding-right:10px; vertical-align:middle" />&nbsp;&nbsp;Action Required: All customers must update patient statement options before sending any new batches.  Please read the <a href="http://help.kareo.com/documents/pdf/Kareo_PatientStatementGuide" target="_blank">Kareo Patient Statement Guide</a> for more information.</div></body></html>', 
	'55' )
go