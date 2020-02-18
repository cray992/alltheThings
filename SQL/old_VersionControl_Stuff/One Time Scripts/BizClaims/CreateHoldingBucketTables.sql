SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[UnroutedResponse](
	[UnroutedResponseID] [int] IDENTITY(1,1) NOT NULL,
	[PayerGatewayID] [int] NOT NULL,
	[ResponseID] [int] NOT NULL,
	[Routed] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[RoutedBy] [varchar](128) NULL,
	[RoutedDate] [datetime] NULL 
 CONSTRAINT [PK_UnroutedResponse] PRIMARY KEY CLUSTERED 
(
	[UnroutedResponseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[UnroutedResponse] ADD  CONSTRAINT [DF_UnroutedResponse_Routed]  DEFAULT ((0)) FOR [Routed]
GO

ALTER TABLE [dbo].[UnroutedResponse] ADD  CONSTRAINT [DF_UnroutedResponse_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[UnroutedResponse]  WITH CHECK ADD  CONSTRAINT [FK_UnroutedResponse_PayerGateway] FOREIGN KEY([PayerGatewayID])
REFERENCES [dbo].[PayerGateway] ([PayerGatewayId])
GO

ALTER TABLE [dbo].[UnroutedResponse] CHECK CONSTRAINT [FK_UnroutedResponse_PayerGateway]
GO

