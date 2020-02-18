IF EXISTS (SELECT * 
  FROM sys.foreign_keys 
   WHERE object_id = OBJECT_ID(N'invoicing.FK_CustomerSettings_TermsType')
   AND parent_object_id = OBJECT_ID(N'invoicing.customersettings')
)
ALTER TABLE invoicing.CustomerSettings DROP CONSTRAINT FK_CustomerSettings_TermsType

IF EXISTS ( SELECT 1 FROM sys.objects AS O
                    INNER JOIN sys.schemas AS S ON O.schema_id = S.schema_id
                    WHERE o.name = 'TermsType'
                    AND S.name = 'invoicing') 
BEGIN 
    DROP TABLE invoicing.TermsType
END

CREATE TABLE invoicing.TermsType
(
TermsType VARCHAR(1) NOT NULL,
Name VARCHAR(100) NOT NULL,
CONSTRAINT [PK_Invoicing_TermsType_TermsType] PRIMARY KEY CLUSTERED 
(
	TermsType ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

go

INSERT INTO invoicing.TermsType
SELECT 'D', 'Discount'
UNION ALL
SELECT 'T', 'Transactional'
UNION ALL
SELECT 'R', 'RCM'

ALTER TABLE invoicing.CustomerSettings
WITH CHECK ADD  CONSTRAINT FK_CustomerSettings_TermsType FOREIGN KEY(TermsType)
	REFERENCES invoicing.TermsType (TermsType)
	
go