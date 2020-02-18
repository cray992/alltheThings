if exists (select * from sys.objects where name = 'FK_Customer_CompanyType')
	alter table [dbo].[customer] drop constraint [FK_Customer_CompanyType]
go

if exists (select * from information_schema.columns where table_name = 'Customer' and column_name = 'CompanyTypeID')
	alter table [dbo].[Customer] drop column [CompanyTypeID]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyType]') AND type in (N'U'))
	DROP TABLE [dbo].[CompanyType]
GO

---------------------------------------------------------------------------------

CREATE TABLE [dbo].[CompanyType](
	[CompanyTypeID] [int] IDENTITY(1,1) NOT NULL,
	[CompanyTypeCaption] [varchar](65) NOT NULL,
	[CompanyTypeSalesforceValue] varchar(65) NOT NULL,
	[SortOrder] [int] NOT NULL,
 CONSTRAINT [PK_CompanyType] PRIMARY KEY CLUSTERED 
(
	[CompanyTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
go

insert into [dbo].[CompanyType] (CompanyTypeCaption, CompanyTypeSalesforceValue, SortOrder)
	select 'Healthcare Provider', 'Healthcare Provider', 1
	union all select 'Billing Services Provider', 'Billing Services Provider', 2
	union all select 'Other', 'Other', 3
go

alter table [dbo].[Customer] add [CompanyTypeID] int
go

alter table [dbo].[Customer]
	add constraint [FK_Customer_CompanyType]
	foreign key ([CompanyTypeID])
	references [dbo].[CompanyType]([CompanyTypeID])
go
