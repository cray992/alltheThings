

/****** Object:  Trigger [tr_UpdatePractice_IntegrationPartner]    Script Date: 02/22/2013 14:25:28 ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_UpdatePractice_IntegrationPartner]'))
DROP TRIGGER [dbo].[tr_UpdatePractice_IntegrationPartner]
GO


