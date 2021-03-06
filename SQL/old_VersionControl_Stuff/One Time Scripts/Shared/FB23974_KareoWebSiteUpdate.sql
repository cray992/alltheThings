UPDATE [dbo].[DemographicMarketingSource] SET
	Active = 0
GO

/*
New List:
Customer Referral 
Direct Mail Advertisement 
Industry Association 
Magazine Advertisement 
News Article 
Search Engine (Sponsored Link) 
Search Engine (Normal Link) 
Trade Show 
Word-Of-Mouth 
Other 
*/

INSERT INTO [dbo].[DemographicMarketingSource]
           ([MarketingSourceID]
           ,[MarketingSourceCaption]
           ,[Active])
     VALUES
           (50
           ,'Customer Referral'
           ,1)

INSERT INTO [dbo].[DemographicMarketingSource]
           ([MarketingSourceID]
           ,[MarketingSourceCaption]
           ,[Active])
     VALUES
           (55
           ,'Direct Mail Advertisement'
           ,1)

INSERT INTO [dbo].[DemographicMarketingSource]
           ([MarketingSourceID]
           ,[MarketingSourceCaption]
           ,[Active])
     VALUES
           (60
           ,'Industry Association'
           ,1)

INSERT INTO [dbo].[DemographicMarketingSource]
           ([MarketingSourceID]
           ,[MarketingSourceCaption]
           ,[Active])
     VALUES
           (65
           ,'Magazine Advertisement'
           ,1)

INSERT INTO [dbo].[DemographicMarketingSource]
           ([MarketingSourceID]
           ,[MarketingSourceCaption]
           ,[Active])
     VALUES
           (70
           ,'News Article'
           ,1)

INSERT INTO [dbo].[DemographicMarketingSource]
           ([MarketingSourceID]
           ,[MarketingSourceCaption]
           ,[Active])
     VALUES
           (75
           ,'Search Engine (Sponsored Link)'
           ,1)

INSERT INTO [dbo].[DemographicMarketingSource]
           ([MarketingSourceID]
           ,[MarketingSourceCaption]
           ,[Active])
     VALUES
           (80
           ,'Search Engine (Normal Link)'
           ,1)

INSERT INTO [dbo].[DemographicMarketingSource]
           ([MarketingSourceID]
           ,[MarketingSourceCaption]
           ,[Active])
     VALUES
           (85
           ,'Trade Show'
           ,1)

INSERT INTO [dbo].[DemographicMarketingSource]
           ([MarketingSourceID]
           ,[MarketingSourceCaption]
           ,[Active])
     VALUES
           (90
           ,'Word-Of-Mouth'
           ,1)

INSERT INTO [dbo].[DemographicMarketingSource]
           ([MarketingSourceID]
           ,[MarketingSourceCaption]
           ,[Active])
     VALUES
           (95
           ,'Other'
           ,1)

GO