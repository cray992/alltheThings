--select * from ProviderNumberType
--select * from GroupNumberType
IF NOT EXISTS ( SELECT  *
                FROM    sys.columns c
                        INNER JOIN sys.tables t ON c.object_id = t.object_id
                WHERE   t.name = 'ProviderNumberType'
                        AND c.name = 'ShowInClaimSettings' ) 
BEGIN
	alter table ProviderNumberType add ShowInClaimSettings bit 
END
GO
IF NOT EXISTS ( SELECT  *
                FROM    sys.columns c
                        INNER JOIN sys.tables t ON c.object_id = t.object_id
                WHERE   t.name = 'GroupNumberType'
                        AND c.name = 'ShowInClaimSettings' ) 
BEGIN
	alter table GroupNumberType add ShowInClaimSettings bit 
END
GO

update ProviderNumberType set ShowInClaimSettings=0;

update GroupNumberType set ShowInClaimSettings=0;

update ProviderNumberType set ShowInClaimSettings=1 where ANSIReferenceIdentificationQualifier in 
('0B', '1A', '1B', '1C', '1D', '1H', 'G2', 'G5', 'N5', 'X5', 'ZZ', '9F');

update GroupNumberType set ShowInClaimSettings=1 where ANSIReferenceIdentificationQualifier in 
('0B', '1A', '1B', '1C', '1D', '1H', '1J', 'FH', 'G2', 'G5', 'LU', 'X5', 'SN', 'SM', 'SV', 'ZN', 'ZZ', 'EW');
