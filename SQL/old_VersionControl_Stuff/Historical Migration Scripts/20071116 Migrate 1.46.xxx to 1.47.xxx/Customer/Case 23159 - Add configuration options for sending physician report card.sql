alter table practice add Metric xml
GO

Update practice 
SET Metric = 
'<Data>
  <Benchmark>
    <Type Name="DRO">23.00</Type>
  </Benchmark>
</Data>'
GO



ALTER TABLE Doctor
ADD 
ProviderPerformanceReportActive bit NULL
CONSTRAINT DF_Doctor_ProviderPerformanceReportActive DEFAULT 1,
ProviderPerformanceScope int NULL,
ProviderPerformanceFrequency char(1) NULL,
ProviderPerformanceDelay int NULL,
ProviderPerformanceCarbonCopyEmailRecipients varchar(max)

GO

UPDATE Doctor 
SET ProviderPerformanceReportActive = 0,
	ProviderPerformanceScope = 2,
	ProviderPerformanceFrequency = 'W',
	ProviderPerformanceDelay = 2

GO

-- Update the email address for the doctor if there is a user associated with it
UPDATE	Doctor
SET		EmailAddress = U.EmailAddress
FROM	Doctor D
INNER JOIN
		SharedServer.Superbill_Shared.dbo.Users U
ON		   D.UserID = U.UserID
WHERE	len(isnull(D.EmailAddress, '')) = 0
