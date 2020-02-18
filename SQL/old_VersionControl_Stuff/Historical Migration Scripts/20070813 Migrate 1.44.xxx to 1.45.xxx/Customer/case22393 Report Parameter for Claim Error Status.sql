

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ClaimTransactionTypeError_ClaimTransactionTypeError]') AND parent_object_id = OBJECT_ID(N'[dbo].[ClaimTransactionTypeError]'))
ALTER TABLE [dbo].[ClaimTransactionTypeError] DROP CONSTRAINT [FK_ClaimTransactionTypeError_ClaimTransactionTypeError]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ClaimTransactionTypeError]') AND type in (N'U'))
DROP TABLE [dbo].[ClaimTransactionTypeError]
GO


CREATE TABLE [dbo].[ClaimTransactionTypeError](
	[ClaimTransactionTypeCode] [char](3) NOT NULL,
	[TypeName] [varchar](50) NULL,
	[TypeDescription] [varchar](50) NULL,
 CONSTRAINT [PK_ClaimTransactionTypeError] PRIMARY KEY CLUSTERED 
(
	[ClaimTransactionTypeCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[ClaimTransactionTypeError]  WITH CHECK ADD  CONSTRAINT [FK_ClaimTransactionTypeError_ClaimTransactionTypeError] FOREIGN KEY([ClaimTransactionTypeCode])
REFERENCES [dbo].[ClaimTransactionType] ([ClaimTransactionTypeCode])
GO
ALTER TABLE [dbo].[ClaimTransactionTypeError] CHECK CONSTRAINT [FK_ClaimTransactionTypeError_ClaimTransactionTypeError]
GO


Insert INTO [ClaimTransactionTypeError]( [ClaimTransactionTypeCode], [TypeName], [TypeDescription] )
values ('RJT', 'Rejected', 'Rejection')

Insert INTO [ClaimTransactionTypeError]( [ClaimTransactionTypeCode], [TypeName], [TypeDescription] )
values ('DEN', 'Denied', 'Denial')

Insert INTO [ClaimTransactionTypeError]( [ClaimTransactionTypeCode], [TypeName], [TypeDescription] )
values ('BLL', 'No Response', 'No Response')

