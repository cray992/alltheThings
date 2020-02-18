ALTER TABLE SupportType
ADD ProductCaptionAndPrice varchar(100)
GO

UPDATE SupportType SET ProductCaptionAndPrice = '(No Charge)' WHERE SupportTypeCaption = 'Self-Service'
UPDATE SupportType SET ProductCaptionAndPrice = 'Premium Email Support ($99/month)' WHERE SupportTypeCaption = 'Level 1'
UPDATE SupportType SET ProductCaptionAndPrice = 'Premium Email Support ($299/month)' WHERE SupportTypeCaption = 'Level 2'
UPDATE SupportType SET ProductCaptionAndPrice = 'Premium Email Support ($499/month)' WHERE SupportTypeCaption = 'Level 3'
UPDATE SupportType SET ProductCaptionAndPrice = 'Premium Email Support ($899/month)' WHERE SupportTypeCaption = 'Level 4'
GO
