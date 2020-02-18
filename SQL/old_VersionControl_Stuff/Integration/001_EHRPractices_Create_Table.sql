

IF (EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = 'dbo' 
                 AND  TABLE_NAME = 'EHRPractices'))
BEGIN
    Drop Table [dbo].[EHRPractices]
END

CREATE TABLE [dbo].[EHRPractices](
	[PracticeID] [uniqueidentifier] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[AdministrativeContactPrefix] [nvarchar](255) NULL,
	[AdministrativeContactFirstName] [nvarchar](255) NULL,
	[AdministrativeContactMiddleName] [nvarchar](255) NULL,
	[AdministrativeContactLastName] [nvarchar](255) NULL,
	[IsDeleted] [bit] NOT NULL
 CONSTRAINT [PK_EHRPractices] PRIMARY KEY CLUSTERED 
(
	[PracticeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[EHRPractices]  WITH CHECK ADD  CONSTRAINT [FK_EHRPractices_Customer] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customer] ([CustomerID])

ALTER TABLE [dbo].[EHRPractices] CHECK CONSTRAINT [FK_EHRPractices_Customer]

ALTER TABLE [dbo].[EHRPractices] ADD  CONSTRAINT [DF_EHRPractices_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]