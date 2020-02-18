IF NOT EXISTS ( SELECT  *
                FROM    INFORMATION_SCHEMA.COLUMNS
                WHERE   table_name = 'DeactivationTopic'
                        AND column_name = 'AdMessageContent' ) 
    BEGIN
        ALTER TABLE dbo.DeactivationTopic
        ADD AdMessageContent VARCHAR(MAX) NOT NULL
        CONSTRAINT DT_AdMessageContent_NotNull DEFAULT ''
    END 
IF NOT EXISTS ( SELECT  *
                FROM    INFORMATION_SCHEMA.COLUMNS
                WHERE   table_name = 'DeactivationTopic'
                        AND column_name = 'AdMessageContentHeight' ) 
    BEGIN
        ALTER TABLE dbo.DeactivationTopic
        ADD AdMessageContentHeight INT NOT NULL
        CONSTRAINT DT_AdMessageContentHeight_NotNull DEFAULT 40
    END
GO

BEGIN
    UPDATE  dbo.DeactivationTopic
    SET     AdMessageContent = '<html><head><style>A {color: #4271B6; text-decoration: underline;} A:hover {color: #F2961B; text-decoration: underline;}</style></head><body style="margin-top:5px; margin-left:5px; border-style:solid; border-width:1px; border-color:#f7c800; background-color:#ffffe1; font-family: trebuchet, tahoma, verdana, arial; font-size: 9pt; font-weight: bold;"><div><img src="[[image[Practice.Settings.Images.Help.gif]]]" width="15" height="15" align="middle" border="0" style="padding-right:10px; vertical-align:middle" />&nbsp;&nbsp;Did you know Kareo offers <a href="http://go.kareo.com/rcm-contact-us.html" target="_blank">outsourced Billing Services?</a>.</div></body></html>'
    WHERE   TopicID = 13
END