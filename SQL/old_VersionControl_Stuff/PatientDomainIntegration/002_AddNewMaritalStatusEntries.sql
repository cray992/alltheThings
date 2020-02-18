IF NOT Exists(select * from MaritalStatus m where m.MaritalStatus = 'A')
INSERT INTO [MaritalStatus]
           ([MaritalStatus]
           ,[LongName]
           ,[CreatedDate]
           ,[CreatedUserID]
           ,[ModifiedDate]
           ,[ModifiedUserID])
     VALUES
           ('A'
           ,'Annulled'
           ,CURRENT_TIMESTAMP
           ,0
           ,CURRENT_TIMESTAMP
           ,0)
GO

IF NOT Exists(select * from MaritalStatus m where m.MaritalStatus = 'I')
INSERT INTO [MaritalStatus]
           ([MaritalStatus]
           ,[LongName]
           ,[CreatedDate]
           ,[CreatedUserID]
           ,[ModifiedDate]
           ,[ModifiedUserID])
     VALUES
           ('I'
           ,'Interlocutory'
           ,CURRENT_TIMESTAMP
           ,0
           ,CURRENT_TIMESTAMP
           ,0)
GO

IF NOT Exists(select * from MaritalStatus m where m.MaritalStatus = 'L')
INSERT INTO [MaritalStatus]
           ([MaritalStatus]
           ,[LongName]
           ,[CreatedDate]
           ,[CreatedUserID]
           ,[ModifiedDate]
           ,[ModifiedUserID])
     VALUES
           ('L'
           ,'Legally Separated'
           ,CURRENT_TIMESTAMP
           ,0
           ,CURRENT_TIMESTAMP
           ,0)
GO

IF NOT Exists(select * from MaritalStatus m where m.MaritalStatus = 'P')
INSERT INTO [MaritalStatus]
           ([MaritalStatus]
           ,[LongName]
           ,[CreatedDate]
           ,[CreatedUserID]
           ,[ModifiedDate]
           ,[ModifiedUserID])
     VALUES
           ('P'
           ,'Polygamus'
           ,CURRENT_TIMESTAMP
           ,0
           ,CURRENT_TIMESTAMP
           ,0)
GO

IF NOT Exists(select * from MaritalStatus m where m.MaritalStatus = 'T')
INSERT INTO [MaritalStatus]
           ([MaritalStatus]
           ,[LongName]
           ,[CreatedDate]
           ,[CreatedUserID]
           ,[ModifiedDate]
           ,[ModifiedUserID])
     VALUES
           ('T'
           ,'Domestic Partner'
           ,CURRENT_TIMESTAMP
           ,0
           ,CURRENT_TIMESTAMP
           ,0)
GO