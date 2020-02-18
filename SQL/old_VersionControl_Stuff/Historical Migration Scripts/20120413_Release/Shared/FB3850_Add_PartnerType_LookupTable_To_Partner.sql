USE [Superbill_Shared]
BEGIN TRAN


-- Danger! Partner has a foreign-key reference to PartnerType
IF NOT EXISTS ( SELECT  *
                FROM    [sys].[tables]
                WHERE   [object_id] = OBJECT_ID('PartnerType')
                        AND OBJECTPROPERTY([object_id], N'IsUserTable') = 1 ) 
    BEGIN
        CREATE TABLE [dbo].[PartnerType]
            (
              [PartnerTypeID] INT NOT NULL
                                  IDENTITY(1, 1)
                                  PRIMARY KEY ,
              [Name] VARCHAR(128) NULL ,
              [ModifiedDate] DATETIME CONSTRAINT [DF_PartnerType_ModifiedDate] DEFAULT (GETDATE())
            )
        ON  [PRIMARY];
        
        -- Do populate
        INSERT  INTO [dbo].[PartnerType]
                ( [Name] )
        VALUES  ( 'Direct' );
        INSERT  INTO [dbo].[PartnerType]
                ( [Name] )
        VALUES  ( 'Reseller' );
        INSERT  INTO [dbo].[PartnerType]
                ( [Name] )
        VALUES  ( 'RCM' );
        
		-- Add foreign-key reference for partner-type
        IF NOT EXISTS ( SELECT  *
                        FROM    sys.columns
                        WHERE   Name = N'[PartnerTypeID]'
                                AND Object_ID = OBJECT_ID(N'[dbo].[Partner]') ) 
            BEGIN
                ALTER TABLE [dbo].[Partner] ADD
                [PartnerTypeID] INT NOT NULL CONSTRAINT [DF_Partner_PartnerTypeID] DEFAULT ((1)) -- Default: Direct
         
                ALTER TABLE [dbo].[Partner]
                ADD CONSTRAINT [FK_Partner_PartnerType] FOREIGN KEY([PartnerTypeID]) REFERENCES [dbo].[PartnerType]([PartnerTypeID] )
            END   
                     
    END
COMMIT