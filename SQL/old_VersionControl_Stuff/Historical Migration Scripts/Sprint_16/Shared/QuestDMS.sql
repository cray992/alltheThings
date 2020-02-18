DECLARE @QuestPKG UNIQUEIDENTIFIER

SET @QuestPKG='5de28b92-cb7f-4bcc-80b4-86cea316887e' 

-- use PROD ID upon release: --c18081db-be6d-44ad-ad3a-aab53401e5a4

DELETE SharedSystemPropertiesAndValues WHERE PropertyName='QuestCustomizationDMSFile'

INSERT INTO dbo.SharedSystemPropertiesAndValues
        ( PropertyName ,
          Value ,
          PropertyDescription ,
          ValueType
        )
VALUES  ( 'QuestCustomizationDMSFile' , -- PropertyName - varchar(128)
          @QuestPKG , -- Value - varchar(max)
          'Quest Customer Cobranding Pkg' , -- PropertyDescription - varchar(500)
          ''  -- ValueType - varchar(10)
        )

UPDATE dbo.Customer SET CustomizationDMSFile=@QuestPKG WHERE PartnerID=2


SELECT * FROM dbo.Customer WHERE PartnerID=2
