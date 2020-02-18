USE [ClearinghousePayers]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PracticeEnrollmentOrder]') AND type in (N'U'))
DROP TABLE [dbo].[PracticeEnrollmentOrder]
GO

USE [ClearinghousePayers]
GO

CREATE TABLE [dbo].[PracticeEnrollmentOrder](
	[EnrollmentOrderID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[PracticeID] [int] NOT NULL,
	CONSTRAINT [pk_PracticeEnrollmentOrder] PRIMARY KEY CLUSTERED ([EnrollmentOrderID] ASC) ON [PRIMARY],
	CONSTRAINT [fk_PracticeEnrollmentOrder_EnrollmentOrder] FOREIGN KEY ([EnrollmentOrderID]) REFERENCES [dbo].[EnrollmentOrder]([EnrollmentOrderID])
)

GO
