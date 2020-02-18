INSERT INTO dbo.SharedSystemPropertiesAndValues
        ( PropertyName ,
          Value ,
          PropertyDescription 
        )
VALUES  ( 'QuestPartnerID' , -- PropertyName - varchar(128)
          '2' , -- Value - varchar(max)
          'This is the key value of the Partner table for Quest'  -- PropertyDescription - varchar(500)
        )
INSERT INTO dbo.SharedSystemPropertiesAndValues
        ( PropertyName ,
          Value ,
          PropertyDescription 
        )
VALUES  ( 'KareoAdminUserSecurityGroupID' , -- PropertyName - varchar(128)
          '26' , -- Value - varchar(max)
          'This is the key value of the UserSecurityGroup table for the Kareo Admin security group'  -- PropertyDescription - varchar(500)
        )